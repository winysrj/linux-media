Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp119.rog.mail.re2.yahoo.com ([68.142.224.74]:31062 "HELO
	smtp119.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752724AbZBVVuq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 16:50:46 -0500
Message-ID: <49A1C8B5.2010501@rogers.com>
Date: Sun, 22 Feb 2009 16:50:45 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Amy Overmyer <aovermy@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: vbox cat's eye 3560 usb device
References: <132842.8631.qm@web35805.mail.mud.yahoo.com>
In-Reply-To: <132842.8631.qm@web35805.mail.mud.yahoo.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Amy Overmyer wrote:
>> Lastly, are there any other IC components on the back or front of the
>> PCB ?  Can you provide pics (upload them to the wiki article)) ?
>>     
>
> The back only has a couple components, probably for electrical, no ICs.
>   
okay

> The
> front only has the cypress (100 pin pkg) chip and the NIM, with a
> couple small components, that I can't read what they are. The PCB is
> stamped osc by one of them and usbid on the other, so I'm guessing one
> is an oscillator and the other the PROM where the cold USB id is stored.
>   

okay. I rather imagine that your guesses are correct

> I
> opened up the NIM (hey, they're $30 at my local computer store right
> now, so even if I kill it, I have an extra), and I saw my old friend
> the BCM3510 (I have a 1rst gen air2pc pci card that works pretty well
> for me)
Wow, I'm kind of surprised about that one -- I would have expected the
NIM to have been a little more contemporary (given that I believe these
devices (150/151/3560) came out in the ~2005 time frame).

> and a smaller chip marked tua6030 (or could be 6080, the
> writing is faint, but infineon doesn't look like they make an 6080). 
>   

Yes, that would be 6030

> I have photos but need to upload them.
>   
okay


This device might also be close in design to the original Technisat
Air2PC-ATSC-USB device
(http://www.linuxtv.org/wiki/index.php/TechniSat_Air2PC-ATSC-USB) --
though, obviously it doesn't use a Flexcop controller ... I say might
be, as I don't know what the USB bridge is in the Technisat device, nor
the exact tuner module employed. Patrick might recall though


