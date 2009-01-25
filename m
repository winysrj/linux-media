Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailhost.okg-computer.de ([85.131.254.125])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@okg-computer.de>) id 1LR3BE-000146-IJ
	for linux-dvb@linuxtv.org; Sun, 25 Jan 2009 12:29:33 +0100
Received: from [10.10.42.118] (f053213038.adsl.alicedsl.de [78.53.213.38])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mailhost.okg-computer.de (Postfix) with ESMTP id 2D676441A4
	for <linux-dvb@linuxtv.org>; Sun, 25 Jan 2009 12:29:29 +0100 (CET)
Message-ID: <497C359C.5090308@okg-computer.de>
Date: Sun, 25 Jan 2009 10:49:16 +0100
From: =?ISO-8859-1?Q?Jens_Krehbiel-Gr=E4ther?=
 <linux-dvb@okg-computer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <497C3F0F.1040107@makhutov.org>
In-Reply-To: <497C3F0F.1040107@makhutov.org>
Subject: Re: [linux-dvb] How to use scan-s2?
Reply-To: linux-media@vger.kernel.org
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

Artem Makhutov schrieb:
> Hello,
>
> I am wondering on how to use scan-s2.
>
> When running scan-s2 like this I am only getting 13 services:
>
> scan-s2 -a 2 -o zap /usr/share/dvb/dvb-s/Astra-19.2E > channels.conf
>
> when running
>
> scan-s2 -a 2 -n -o zap /usr/share/dvb/dvb-s/Astra-19.2E > channels.conf
>
> then I am getting 152 services.
>
> When running the old dvbscan application I am getting 1461 services:
>
> dvbscan -a 2 -o zap /usr/share/dvb/dvb-s/Astra-19.2E > channels.conf
>
>
> Have I missed a parameter in scan-s2 or what else could be the problem?
>
> Thanks, Artem


Hi Artem!

I had the same "problem".When add no options I am only getting a few 
services.
When I add the "-n" option I get some more services but all services I 
only get, when I am adding "-n -5".

the "-5" means:
multiply all filter timeouts by factor 5 for non-DVB-compliant section 
repitition rates

The scan takes a long time then, but I get 1476 services (Astra 19.2).
My device is a Pinnacle PCTV 452e (USB).
Perhaps this switch is working with your device, too?

Jens

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
