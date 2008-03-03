Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout1.informatik.tu-muenchen.de ([131.159.0.12])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alexander.simon@informatik.tu-muenchen.de>)
	id 1JWAek-0004Cs-AX
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 14:24:42 +0100
Received: from alex (p54984316.dip.t-dialin.net [84.152.67.22])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in.tum.de (Postfix) with ESMTP id 5866C6821
	for <linux-dvb@linuxtv.org>; Mon,  3 Mar 2008 14:24:34 +0100 (CET)
From: Alexander Simon <alexander.simon@informatik.tu-muenchen.de>
To: linux-dvb@linuxtv.org
Date: Mon, 3 Mar 2008 14:25:26 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803031425.26937.alexander.simon@informatik.tu-muenchen.de>
Subject: [linux-dvb] Terratec Cinergy T USB XXS working
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

Hi List,

lately a friend of mine got a Terratec Cinergy T USB XXS and was wondering if 
it were supported under Linux.
After unsuccessful googling for this card (even your Wiki gives nothing), i 
started investigating on my own.
The Windows driver loaded an dvb7700all.sys, which seemed to be for an dibcom 
7700. After replacing USB IDs in dvb-usb/dib_0700_devices.c with the ones 
from the card, i got it working by replacing
{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_MYTV_T) },
with the Cards ID in the 127f67dea087 (3.3.08) branch:
{ USB_DEVICE(USB_VID_TERRATEC, 0x0078) },

So, the card is a clone of the "newest" Nova-T.
Scanning channels in Munich and watching with Kaffeine have been tested so far 
and worked flawlessly.

Could some developer please include this card into the current source?

You can send me a mail for questions.


Please note that i am talking about T USB XXS, not T USB XS or similar.

Greetings, Alex

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
