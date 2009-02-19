Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp116.rog.mail.re2.yahoo.com ([68.142.225.232]:39116 "HELO
	smtp116.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751838AbZBSCSj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 21:18:39 -0500
Message-ID: <499CC17D.9040800@rogers.com>
Date: Wed, 18 Feb 2009 21:18:37 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Amy Overmyer <aovermy@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: vbox cat's eye 3560 usb device
References: <538926.88491.qm@web35806.mail.mud.yahoo.com>
In-Reply-To: <538926.88491.qm@web35806.mail.mud.yahoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Amy,

Amy Overmyer wrote:
> I’m trying to write a driver for the 
> device, just as a learning exercise. So far, I’ve got the firmware in intel hex 
> format (from usbsnoop on windows, then a couple perl scripts to mutate it) and 
> am able to use fxload to load it with –t fx2 and there are 2 separate files, a 
> short one (the loader) and the firmware proper; so in fxload I have a –s and a 
> –I. 
>  
> I’m able to take it from cold to 
> warm that way solely within Linux. 
>  
> The device itself has a cypress CY7C68013A fx2 chip and a large tin can tuner/demod stamped with 
> Thomson that has a sticker on it identifying it as 8601A. Helpfully, the 3560 
> opens up easily with the removal of two screws on the shell.
>   

The Thomson NIM is the same one that they use on their 150/151 PCI
cards.   I don't know what the internal components of it are, but the
digital demodulator may be somewhat exposed to view -- the metal can has
a ventilation opening, though the metal may actually be bent inwards for
contact with the chip (so as to allow the casing to act as a
heatsink)).   If you can ascertain the identity of the unknown
components then you  will be  in a better position to gauge whether you
should bother continuing or not  (i.e. if the demod is currently
unsupported, you would have to develop support for it in order to ever
get the device working under Linux).  My suggestion here is:
- non-invasive: search for any clues from the Windows driver inf files
- invasive:  as non-destructively as possible, open the can ... I don't
advise this unless it looks do-able ... proceed at your own risk.

Lastly, are there any other IC components on the back or front of the
PCB ?  Can you provide pics (upload them to the wiki article)) ?

>  
> It’s cold boot usb id is 14f3:3560 and its warm boot is 
> 14f3:a560.
>  
> I have taken that hex file and 
> created a binary file out of the 2nd file (-I in fxload speak). I 
> think, correct me if I’m wrong, there is already a fx2 loader available, thus I 
> will not need the loader file.
>  
> One of the stranger things I saw in 
> the usbsnoop trace in windows was when it came to reset of the CPUCS, the driver 
> sent down both a poke at x0e600 and a poke at 0x7f92. One is the fx CPUCS 
> register, I believe the other is a fx2 CPUCS register. 
>  
> Currently I am mutating dibusb-mc 
> just to see if I can get it to the point of going from cold to warm in the 
> driver. 
>  
> I have taken usb sniffs from windows 
> of doing things such as scanning for channels, watching a channel, etc. so I can 
> try to figure out if anything else in the v4l-dvb collection behaves 
> similarly.
>  
> I guess what I’m looking for is any 
> hints that might be useful to figuring this out. 
>  
> Like I said, it’s a learning 
> exercise, I already have enough tuners, and anyway, the cost of buying a 
> supported tuner is far cheaper than the time needed to develop 
> this!
>  
> Thanks for any info! I’ve pretty 
> much devoured everything available on the wiki.

have a look at the cxusb, its likely closer to what you want:
http://linuxtv.org/hg/v4l-dvb/file/tip/linux/drivers/media/dvb/dvb-usb/
