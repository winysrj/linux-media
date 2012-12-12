Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:46587 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2LLFzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Dec 2012 00:55:04 -0500
Received: by mail-we0-f172.google.com with SMTP id r3so111452wey.31
        for <linux-media@vger.kernel.org>; Tue, 11 Dec 2012 21:55:02 -0800 (PST)
Message-ID: <50C81AF5.4050308@gmail.com>
Date: Wed, 12 Dec 2012 10:49:41 +0500
From: Saad Bin Javed <sbjaved@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>, linux-media@vger.kernel.org
Subject: Re: Kworld PCI Analog TV Card Lite PVR-7134SE
References: <50C62497.5000209@gmail.com> <50C652A4.7040807@netscape.net> <50C71D1D.4030709@gmail.com> <50C81440.3060306@netscape.net>
In-Reply-To: <50C81440.3060306@netscape.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Alfredo,

Thank you for helping me.

> Is the same card:
>
> Board indentification  : 713XTV VRE: J

Yes, I have the same board. 713XTV VRE:J

> Please try:  modprobe
> saa7134 card=63 tuner=43 or  modprobe saa7134 card=59 tuner=56
>
> please tell me  which  program  you use to  watch TV.
> Use xawtvand set it  well,run from a  terminal

I'm using tv-time and scantv. I've also tried VLC and Mplayer. I will 
try xawtvand.

> What is your  country  and  TV standard?,
> Do the  channels  are correctly set?

Country: Pakistan, TV Standard: PAL-B
Since the proper tuner is not getting detected, I can't scan for 
channels. BTW I tried the card in a windows box borrowed from my cousin. 
The card works fine.

> I had a  similar problem  and what I did  was  try  all  tuners
>
> example:
>
> modprobe saa7134 card=63 tuner=1
> modprobe saa7134 card=63 tuner=2
> ...
> modprobe saa7134 card=63 tuner=63
>
> modprobe saa7134 card=59 tuner=1
> modprobe saa7134 card=59 tuner=2
> ...
> modprobe saa7134 card=59 tuner=56
>

I will try different card/tuner combinations but since there are 50+ 
cards and 50+ tuners, you can imagine the number of combinations :)
Plus I can't seem to unload the saa7134 module using "modprobe -r" or 
"rmmod"...It gives a FATAL module in use error. So I have to reboot the 
machine every time to set new card/tuner which SUCKS.

> I think that your card isn't 153.There are many  cards  with  the same
> name  but different  electronic.
>
> The tuner is what is below the sticker that says kworld. Perhaps you can
> see the name of the tuner.

In the jpeg link I posted in the earlier message, I have labelled all 
the onboard chips. Have a look again: 
http://tinypic.com/view.php?pic=2lwnmuc&s=6
I can't seem to find which chip is the tuner. I emailed Kworld support, 
they say its a TENA TNF9533BDF/BK tuner. I can't find any chip onbaord 
with this name!

Anyways thanks again.

Regards,

Saad
