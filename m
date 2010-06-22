Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <epek@gmx.net>) id 1OQzTX-0002Yy-Ri
	for linux-dvb@linuxtv.org; Tue, 22 Jun 2010 11:09:00 +0200
Received: from mail.gmx.net ([213.165.64.20])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with smtp
	for <linux-dvb@linuxtv.org>
	id 1OQzTX-0000m4-0t; Tue, 22 Jun 2010 11:08:59 +0200
Date: Tue, 22 Jun 2010 11:08:54 +0200
From: "Erich N. Pekarek" <epek@gmx.net>
In-Reply-To: <alpine.DEB.2.01.1006161906320.13184@localhost.localdomain>
Message-ID: <20100622090854.12710@gmx.net>
MIME-Version: 1.0
References: <4C0CAE38.8050806@gmx.net>
	<alpine.DEB.2.01.1006161906320.13184@localhost.localdomain>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
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

> From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
> > Symptoms: Stick gets recognized, firmware gets loaded, frontend gets
> loaded.
> 
> I see something a bit different --
> [62890.938154] usb 4-2.1: firmware: requesting dvbt_bda_stellar_usb.inp
> [62894.338892] usbcore: registered new interface driver smsusb
> [62894.467939] usb 4-2.1: USB disconnect, address 4
> [62896.753324] usb 4-2.1: New USB device found, idVendor=187f,
> idProduct=0100
> 
> That is, no frontend gets loaded for me.  So, no tuning.  The
> other two devices attached at the moment both work properly.

Yes, that problem sounds familiar - see my comment on this below, please.

> Plus I'll have to see what changes I need to get the DAB support
> from Siano working properly, as I hadn't done that yet with the
> 2.6.34-rc2 kernel.

I can't help in that case, since, up to my knowlegde, in favour to dvb-t radio there is no dab-radio in Austria.

> thanks,
> barry bouwsma

Comment on the frontend loading issue:

This is my dmesg...

[30256.700149] usb 6-1: new full speed USB device using uhci_hcd and address 2
[30256.861399] usb 6-1: configuration #1 chosen from 1 choice
[30257.339156] smsusb_probe: line: 422: rom interface 0 is not used
[30257.342174] usb 6-1: firmware: requesting dvbt_bda_stellar_usb.inp
[30257.483485] usbcore: registered new interface driver smsusb
[30257.540221] usb 6-1: USB disconnect, address 2
[30260.050077] usb 6-1: new full speed USB device using uhci_hcd and address 3
[30260.224132] usb 6-1: configuration #1 chosen from 1 choice
[30260.233362] DVB: registering new adapter (Siano Stellar Digital Receiver)
[30260.233828] DVB: registering adapter 0 frontend 0 (Siano Mobile Digital MDTV Receiver)...

Of course I am using the original ".inp"-Microcode, which I previously copied to /lib/firmware/`uname -r`/dvbt_bda_stellar_usb.inp

Since the autoload of the interface seems to have been forgotten within the source code itself, I created /etc/modprobe.d/siano.conf with the following line:

install smsusb /sbin/modprobe --ignore-install smsusb && /sbin/modprobe --ignore-install smsdvb

I hope this is the right way to do it and does not cause other problems.

I once repeat: the dvb-device is accessible, but the signal and snr levels stay at "0" permanently.
I remember, that a similar problem occurred in the siano-dev branch before. Mkrufky had a patch addressing this issue in former versions (adapted for 2.6.8-to 2.6.18), but it eventually did not find it's way into the repository.

Unfortunately, I do not possess a copy of the ancient patch file any longer.

Thanks for your reply and
best regards

Erich
-- 
GMX DSL: Internet-, Telefon- und Handy-Flat ab 19,99 EUR/mtl.  
Bis zu 150 EUR Startguthaben inklusive! http://portal.gmx.net/de/go/dsl

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
