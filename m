Return-path: <linux-media-owner@vger.kernel.org>
Received: from web35805.mail.mud.yahoo.com ([66.163.179.174]:27863 "HELO
	web35805.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752894AbZBTQQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 11:16:30 -0500
Date: Fri, 20 Feb 2009 08:16:29 -0800 (PST)
From: Amy Overmyer <aovermy@yahoo.com>
Subject: Re: vbox cat's eye 3560 usb device
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <132842.8631.qm@web35805.mail.mud.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Lastly, are there any other IC components on the back or front of the
> PCB ?  Can you provide pics (upload them to the wiki article)) ?

The back only has a couple components, probably for electrical, no ICs.
The
front only has the cypress (100 pin pkg) chip and the NIM, with a
couple small components, that I can't read what they are. The PCB is
stamped osc by one of them and usbid on the other, so I'm guessing one
is an oscillator and the other the PROM where the cold USB id is stored.

I
opened up the NIM (hey, they're $30 at my local computer store right
now, so even if I kill it, I have an extra), and I saw my old friend
the BCM3510 (I have a 1rst gen air2pc pci card that works pretty well
for me) and a smaller chip marked tua6030 (or could be 6080, the
writing is faint, but infineon doesn't look like they make an 6080). 

I have photos but need to upload them.

> have a look at the cxusb, its likely closer to what you want:
> http://linuxtv.org/hg/v4l-dvb/file/tip/linux/drivers/media/dvb/dvb-usb/

OK, I'll take a look there. Thank you.


      
