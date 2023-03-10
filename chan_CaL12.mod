TITLE (L-type HVA calcium current for MSP Neuron)

COMMENT
Unit check passed even without Units off
ENDCOMMENT 

INDEPENDENT {t FROM 0 TO 1 WITH 1 (ms)}

NEURON {
	SUFFIX CaL12
	USEION Ca READ Cai, Cao WRITE iCa VALENCE 2
	RANGE minf, mtau, hinf, htau, iCa, p
	GLOBAL pmax
}

UNITS {
	(mA)	= (milliamp)
	(mV)	= (millivolt)
	(mM)	= (milli/liter)
        FARADAY = 96489 (coul)
        R       = 8.314 (volt-coul/degC)
}

PARAMETER {
	v		(mV)
	celsius	(degC)
	: cai		(mM)
	: cao		(mM)
	Cai		(mM)
	Cao		(mM)
	pmax = 6.7e-6	(cm/s)		
}

CONSTANT {
	a = 0.17 (1)
}
STATE {
	m h
}

ASSIGNED {
	iCa		(mA/cm2)
	mtau		(ms)
	minf
	hinf
	htau		(ms)
	p		(cm/s)
}

BREAKPOINT { 
	SOLVE state METHOD euler
	p=pmax*m*m*(a*h+(1-a))
	iCa =p*ghk(v,Cai,Cao,2)	
}

DERIVATIVE state {
	rates(v)
	m'= (minf-m) / mtau
	h'= (hinf-h) / htau
	}

INITIAL {
	rates(v)
	m = minf
	h = hinf
}

FUNCTION ghk( v(mV), ci(mM), co(mM), z)  (millicoul/cm3) { LOCAL e, w
        w = v * (.001) * z*FARADAY / (R*(celsius+273.16))
        if (fabs(w)>1e-4) 
          { e = w / (exp(w)-1) }
        else : denominator is small -> Taylor series
          { e = 1-w/2 }
        ghk = - (.001) * z*FARADAY * (co-ci*exp(w)) * e
}

PROCEDURE rates(v(mV)) { LOCAL m_alpha, m_beta
	m_alpha = 0.1194*(v+8.124)/(exp((v+8.124)/9.005)-1)
	m_beta = 2.97*exp(v/31.4)
	mtau = 1/(m_alpha+m_beta)
	htau = 14.77
	minf = 1 / (1+exp((v+8.9)/-6.7))
	hinf = 1 / (1+exp((v+13.4)/11.9))
}

