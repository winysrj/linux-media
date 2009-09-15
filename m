Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:50655 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbZIOOtR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 10:49:17 -0400
Message-ID: <4AAFA955.9080501@cogweb.net>
Date: Tue, 15 Sep 2009 07:48:53 -0700
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: linux-media@vger.kernel.org
Subject: Re: Reliable work-horse capture device?
References: <4AAEFEC9.3080405@cogweb.net>	 <20090915000841.56c24dd6@pedra.chehab.org>  <4AAF11EC.3040800@cogweb.net> <1253011177.3166.16.camel@palomino.walls.org>
In-Reply-To: <1253011177.3166.16.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Mon, 2009-09-14 at 21:02 -0700, David Liontooth wrote:
>   
>> Mauro Carvalho Chehab wrote:
>>     
>>> Hi David,
>>>
>>> Em Mon, 14 Sep 2009 19:41:13 -0700
>>> David Liontooth <lionteeth@cogweb.net> escreveu:
>>>
>>>   
>>>       
>>>> We're setting up NTSC cable television capture devices in a handfull of 
>>>> remote locations, using four devices to capture around fifty hours a day 
>>>> on each location. Capture is scripted and will be ongoing for several 
>>>> years. We want to minimize the need for human intervention.
>>>>
>>>> I'm looking for advice on which capture device to use.  My main 
>>>> candidates are ivtv (WinTV PVR 500) and USB, but I've not used any of 
>>>> the supported USB devices.
>>>>
>>>> Are there USB devices that are sufficiently reliable to hold up under 
>>>> continuous capture for years? Are the drivers robust?
>>>>
>>>> I need zvbi-ntsc-cc support, so a big thanks to Michael Krufty for just 
>>>> now adding it to em28xx. Do any other USB device chipsets have raw 
>>>> closed captioning support?
>>>>
>>>> I would also consider using the PCIe device Hauppauge WinTV-HVR-2200, 
>>>> but I need analog support.
>>>>
>>>> Appreciate any advice.
>>>>     
>>>>         
>>> If you look for stability, the most important item is to choose a good stable
>>> server distribution, like RHEL5. You'll be better serviced than using a desktop
>>> distro with some new (not so stable) kernel and tools.
>>>
>>> In terms of stability, the PCI devices are generally more reliable, and, among
>>> all drivers, bttv is the winner, since it is the older driver, so, in thesis,
>>> more bugs were solved on it. That's the reason why several surveillance systems
>>> are still today based on bttv. If you need a newer hardware, then you may choose
>>> saa7134, cx88 or ivtv devices.
>>>
>>> I don't recommend using an USB hardware for such hard usage: it will probably
>>> have a shorter life (since it is not as ventilated as a PCI device on a
>>> server cabinet), and you might experience troubles after long plays. In terms
>>> of USB with analog support, em28xx driver is the more stable, and we recently
>>> fixed some bugs on it, related to memory consumption along the time (it used to
>>> forget to free memory, resulting on crashes, after several stream
>>> start/stop's). 
>>>
>>> There's a tool at v4l2-apps/test made to stress a video driver, made by
>>> Douglas. I suggest that you should run it with the board you'll choose to be
>>> sure that you won't have memory garbage along driver usage.
>>>
>>> Cheers,
>>> Mauro
>>>   
>>>       
>> Thank you, Mauro! I much appreciate the advice.
>>
>> I also see I misattributed the zvbi-ntsc-cc support for em28xx -- kudos 
>> goes to Devin Heitmueller for great work on this.
>>
>> As for the ventilation issue for USB devices, that may not be a serious 
>> obstacle. If the USB sticks such as Hauppauge HVR-950 have reliable 
>> components, we could strip the plastic casing and mount the unit next to 
>> a fan inside the case.
>>
>> Memory leaks would be a serious problem on the other hand; thank you for 
>> pointing to the stress test.
>>
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
>> Our fallback is ivtv. I was hoping to use USB so that we could get 
>> blades instead of 3U cases; it's also getting hard to find good 
>> motherboards with four PCI slots.
>>     
>
>
> I will point out that, for a fallback position, the cx18 driver also
> performs very reliably with essentially the same feature set as ivtv
> (since it started out as a cut and paste from ivtv).
>
> The HVR-1600 is the card with which I do most of my testing.  It is a
> PCI bus device and can perform analog (with VBI) and digital capture
> simultaneously, but not 2 analog streams simultaneously.  I know of two
> users who have at least 3 of these boards in one machine.  (I mention
> the HVR-1600, in case you have a hard time finding the PVR-500 or
> similar analog only cards.)
>
> Of course for you, it sounds like one analog capture device per PCI slot
> is suboptimal.  From a bus throughput perspective, I'd assume you'd
> really want a multiple analog input PCI or PCIe capture card, that could
> do compression on board.
>
> Regards,
> Andy
>   
Thanks Andy, that's a useful suggestion for a fallback.

Cheers,
Dave

