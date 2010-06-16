Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1OOwCX-0005i2-3p
	for linux-dvb@linuxtv.org; Wed, 16 Jun 2010 19:14:58 +0200
Received: from ey-out-2122.google.com ([74.125.78.27])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OOwCW-0007Am-Br; Wed, 16 Jun 2010 19:14:56 +0200
Received: by ey-out-2122.google.com with SMTP id 9so847152eyd.39
	for <linux-dvb@linuxtv.org>; Wed, 16 Jun 2010 10:14:55 -0700 (PDT)
Date: Wed, 16 Jun 2010 19:14:31 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: "Erich N. Pekarek" <epek@gmx.net>
In-Reply-To: <4C0CAE38.8050806@gmx.net>
Message-ID: <alpine.DEB.2.01.1006161906320.13184@localhost.localdomain>
References: <4C0CAE38.8050806@gmx.net>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy Piranha tuning (again)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

On Mon (Monday) 07.Jun (June) 2010, 10:30,  Erich N. Pekarek wrote:

> my DVB-T Stick, that formerly worked fine under previous kernel versions now
> does not tune to any channel unter 2.6.32+.

Sorry for the delay, but I've been trying to recover from a USB
system disk that's finally become uselessly corrupted.

Thanks for pointing this out -- I can verify that I see a similar
problem with a particular 2.6.34-rc2 that I've just built to try
and get other things working again.



> Symptoms: Stick gets recognized, firmware gets loaded, frontend gets loaded.

I see something a bit different --
[62890.938154] usb 4-2.1: firmware: requesting dvbt_bda_stellar_usb.inp
[62894.338892] usbcore: registered new interface driver smsusb
[62894.467939] usb 4-2.1: USB disconnect, address 4
[62896.753324] usb 4-2.1: New USB device found, idVendor=187f, idProduct=0100

That is, no frontend gets loaded for me.  So, no tuning.  The
other two devices attached at the moment both work properly.


I'll try to build the very latest -git kernel on this machine
and if nothing's horribly broken, see if there's any change, as
well as see if I can figure out what's gone wrong.  Not as Real
Soon Now[tm] as it should be, but slow machine and slow me.

Plus I'll have to see what changes I need to get the DAB support
from Siano working properly, as I hadn't done that yet with the
2.6.34-rc2 kernel.


thanks,
barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
