Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailhost.okg-computer.de ([85.131.254.125])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@okg-computer.de>) id 1LJp64-0006bh-1O
	for linux-dvb@linuxtv.org; Mon, 05 Jan 2009 14:02:21 +0100
Received: from [10.10.42.131] (f053210113.adsl.alicedsl.de [78.53.210.113])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mailhost.okg-computer.de (Postfix) with ESMTP id 91F2C44241
	for <linux-dvb@linuxtv.org>; Mon,  5 Jan 2009 14:02:16 +0100 (CET)
Message-ID: <496204D8.6090602@okg-computer.de>
Date: Mon, 05 Jan 2009 14:02:16 +0100
From: =?ISO-8859-15?Q?Jens_Krehbiel-Gr=E4ther?=
 <linux-dvb@okg-computer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] S2API (pctv452e) artefacts in video stream
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

Hi!

I use a Pinnacle USB-Receiver (PCTV Sat HDTV Pro). The module is 
dvb-usb-pctv452e.

I use the repository from Igor Liplianin (actual hg release). The module 
compiles and loads fine. The scanning with scan-s2 and zapping with 
szap-s2 also wirk fine.
But when I record TV from the USB-device with "cat 
/dev/dvb/adapter0/dvr0 > (filename)" I got the TV-Stream of the actual 
tv-station (zapped with "szap-s2 -r SAT.1" for example).
This recorded video has artefacts, even missed frames.

Anyone else having this problem? I remember that on multiproto there was 
a similar problem with the pctv452e until Dominik Kuhlen patched 
somthing since then the video was OK. Is it possible that the same 
"error" is in the S2API-driver?

Regards,
  Jens
<http://mercurial.intuxication.org/hg/s2-liplianin>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
