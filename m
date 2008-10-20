Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd16712.kasserver.com ([85.13.137.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vdr@helmutauer.de>) id 1Ks1I4-0005VX-Ak
	for linux-dvb@linuxtv.org; Mon, 20 Oct 2008 22:23:49 +0200
Received: from [192.168.178.120] (p508101BD.dip0.t-ipconnect.de [80.129.1.189])
	by dd16712.kasserver.com (Postfix) with ESMTP id A68E8180CB5DD
	for <linux-dvb@linuxtv.org>; Mon, 20 Oct 2008 22:23:47 +0200 (CEST)
Message-ID: <48FCE8D8.9070908@helmutauer.de>
Date: Mon, 20 Oct 2008 22:23:52 +0200
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48F9969D.90305@helmutauer.de> <48FCC5FB.1030706@helmutauer.de>
	<48FCCE09.10400@linuxtv.org>
In-Reply-To: <48FCCE09.10400@linuxtv.org>
Subject: Re: [linux-dvb] Problems with conexant CX24123/CX24109
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

Hi Steven

> > What's special about the ARD transponder vs other transponders?
> >
> >   
>   
No idea, with other cards its no problem, but this "beast" fails.
Under windows at the same cable its working fine.

> > If you can show a difference I can try to replicate it with a generator 
> > and provide a patch.
> >   
>   
Thats the correspondent channels.conf:
Das 
Erste;ARD:11836:hC34:S19.2E:27500:101:102=deu,103=2ch;106=dd:104:0:28106:1:1101:0
ZDF;ZDFvision:11953:hC34:S19.2E:27500:110:120=deu,121=2ch;125=dd:130:0:28006:1:1079:0
RTL Television,RTL;RTL 
World:12187:hC34:S19.2E:27500:163:104=deu;106=deu:105:0:12003:1:1089:0
RTL2;RTL World:12187:hC34:S19.2E:27500:166:128=deu:68:0:12020:1:1089:0
VOX;RTL World:12187:hC34:S19.2E:27500:167:136=deu:71:0:12060:1:1089:0
SAT.1;ProSiebenSat.1:12544:hC56:S19.2E:22000:255:256=deu;259=deu:32:0:17500:1:1107:0
ProSieben;ProSiebenSat.1:12544:hC56:S19.2E:22000:511:512=deu;515=deu:33:0:17501:1:1107:0
kabel 
eins;ProSiebenSat.1:12544:hC56:S19.2E:22000:767:768=deu:34:0:17502:1:1107:0


ARD has the lowest frequency so maybe thats the problem ?


-- Helmut Auer, helmut@helmutauer.de


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
