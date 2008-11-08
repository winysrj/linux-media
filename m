Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd16712.kasserver.com ([85.13.137.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vdr@helmutauer.de>) id 1Kyqjs-0003uz-Np
	for linux-dvb@linuxtv.org; Sat, 08 Nov 2008 17:32:49 +0100
Received: from [192.168.178.120] (p50813FFD.dip0.t-ipconnect.de
	[80.129.63.253])
	by dd16712.kasserver.com (Postfix) with ESMTP id 2FEC8180D461D
	for <linux-dvb@linuxtv.org>; Sat,  8 Nov 2008 17:32:45 +0100 (CET)
Message-ID: <4915BF3A.3010807@helmutauer.de>
Date: Sat, 08 Nov 2008 17:32:58 +0100
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4914C482.8010306@helmutauer.de> <4914C4E6.1060305@helmutauer.de>
In-Reply-To: <4914C4E6.1060305@helmutauer.de>
Subject: Re: [linux-dvb] tbs 8920 / cx24116 not working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello Igor

Thanks for your patch from here:
http://www.linuxtv.org/pipermail/linux-dvb/2008-November/030207.html

I do not get the email for this answer :(

Now DVB-S works, but when I switch to a HDTV channel I get this messages:

> cx24108 debug: entering SetTunerFreq, freq=1612000
> cx24108 debug: select vco #7 (f=1612000)
> cx24108 debug: pump=1, n=49, a=26
> cx24108 debug: entering SetTunerFreq, freq=1613375
> cx24108 debug: select vco #7 (f=1613375)
> cx24108 debug: pump=1, n=49, a=27
> cx24108 debug: entering SetTunerFreq, freq=1610625
> cx24108 debug: select vco #7 (f=1610625)
> cx24108 debug: pump=1, n=49, a=24
> cx24108 debug: entering SetTunerFreq, freq=1614750
> cx24108 debug: select vco #7 (f=1614750)
> cx24108 debug: pump=1, n=49, a=29
> cx24108 debug: entering SetTunerFreq, freq=1609250
> cx24108 debug: select vco #7 (f=1609250)
> cx24108 debug: pump=1, n=49, a=23
> cx24108 debug: entering SetTunerFreq, freq=1616125
> cx24108 debug: select vco #7 (f=1616125)
> cx24108 debug: pump=1, n=49, a=30
> cx24108 debug: entering SetTunerFreq, freq=1607875
> cx24108 debug: select vco #7 (f=1607875)
> cx24108 debug: pump=1, n=49, a=22
> cx24108 debug: entering SetTunerFreq, freq=1617500
> cx24108 debug: select vco #7 (f=1617500)
> cx24108 debug: pump=1, n=49, a=31
> cx24108 debug: entering SetTunerFreq, freq=1606500
> cx24108 debug: select vco #7 (f=1606500)
> cx24108 debug: pump=1, n=49, a=20
> cx24108 debug: entering SetTunerFreq, freq=1618875
And nothing woll be received.
Tested with:

ANIXE HD;BetaDigital:11914:hC910M2O35S1:S19.2E:27500:1535:0;1539=deu:0:0:132:133:6:0
and
ARTE HD;ZDFvision:11362:hC23M2O35S1:S19.2E:22000:6210:6221=deu,6222=fra:6230:0:11120:1:1011:0

-- 
Helmut Auer, helmut@helmutauer.de 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
