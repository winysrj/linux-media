Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:47816 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbZIOFER (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 01:04:17 -0400
Message-ID: <4AAF203B.3010304@cogweb.net>
Date: Mon, 14 Sep 2009 22:03:55 -0700
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: Re: Reliable work-horse capture device?
References: <4AAEFEC9.3080405@cogweb.net>	<20090915000841.56c24dd6@pedra.chehab.org>	<4AAF11EC.3040800@cogweb.net> <20090915013430.61ad5889@pedra.chehab.org>
In-Reply-To: <20090915013430.61ad5889@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Em Mon, 14 Sep 2009 21:02:52 -0700
> David Liontooth <lionteeth@cogweb.net> escreveu:
>
>   
>> As for the ventilation issue for USB devices, that may not be a serious 
>> obstacle. If the USB sticks such as Hauppauge HVR-950 have reliable 
>> components, we could strip the plastic casing and mount the unit next to 
>> a fan inside the case.
>>     
>
> Yes, this may work.
>
> Don't forget that, if you use USB devices, you'll probably need one separate USB
> buses per each device, due to USB limits in terms of the maximum number of isoc
> packets per second. If you don't require high quality, you could try to use
> a format that requires less than 16 bits per pixel or 320x240 pixels, in order
> to have more than one device per bus.
>   
Thanks for pointing this out.
>   
>> I would be happy to use bttv, but I can't find cards. I also need to 
>> grab audio off the PCI bus, which only some bttv cards support.
>>
>> We've been using saa7135 cards for several years with relatively few 
>> incidents, but they occasionally drop audio.
>> I've been unable to find any pattern in the audio drops, so I haven't 
>> reported it -- I have no way to reproduce the error, but it happens 
>> regularly, affecting between 3 and 5% of recordings. Audio will 
>> sometimes drop in the middle of a recording and then resume, or else 
>> work fine on the next recording.
>>     
>
> saa7134 has a thread to detect audio audio stereo mode. Maybe there is a bug
> somewhere there.
>   
Interesting idea -- anything I can do to debug?
>   
>> Our fallback is ivtv. I was hoping to use USB so that we could get 
>> blades instead of 3U cases; it's also getting hard to find good 
>> motherboards with four PCI slots.
>>     
>
> The current best relation in terms of slots is the new cx25821. It has 8
> simultaneous inputs at 60 fps per each PCIe board. If you don't need a tuner,
> this design could be very interesting. The driver was written by Conexant, and
> it is not yet present on any distribution (I just committed it today - at
> staging - since it needs some cleanups to match kernel CodingStyle).
>   
Wow, that's great to get support for this powerful device. We do need 
tuners, though -- we're capturing straight from RF television cable. 
Otherwise a beautiful product, even with h264 compression, which is what 
we need.

Cheers,
Dave


