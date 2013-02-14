Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35030 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537Ab3BNMKa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 07:10:30 -0500
Message-ID: <511CD40B.5030208@ti.com>
Date: Thu, 14 Feb 2013 17:39:47 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: AW: omapdss/omap3isp/omapfb: Picture from omap3isp can't recover
 after a blank/unblank (or overlay disables after resuming)
References: <6EE9CD707FBED24483D4CB0162E85467245822C8@AMSPRD0711MB532.eurprd07.prod.outlook.com> <51138BCA.4010701@ti.com> <6EE9CD707FBED24483D4CB0162E8546724593AEC@AMSPRD0711MB532.eurprd07.prod.outlook.com> <511CB792.1020608@ti.com>
In-Reply-To: <511CB792.1020608@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 14 February 2013 03:38 PM, Tomi Valkeinen wrote:
> On 2013-02-14 11:30, Florian Neuhaus wrote:
>> Hi Tomi,
>>
>> Tomi Valkeinen wrote on 2013-02-07:
>>
>>> FIFO underflow means that the DSS hardware wasn't able to fetch enough
>>> pixel data in time to output them to the panel. Sometimes this happens
>>> because of plain misconfiguration, but usually it happens because of
>>> the hardware just can't do things fast enough with the configuration
>>> the user has set.
>>>
>>> In this case I see that you are using VRFB rotation on fb0, and the
>>> rotation is
>>> 270 degrees. Rotating the fb is heavy, especially 90 and 270 degrees.
>>> It may be that when the DSS is resumed, there's a peak in the mem
>>> usage as DSS suddenly needs to fetch lots of data.
>>>
>>> Another issue that could be involved is power management. After the
>>> DSS is suspended, parts of OMAP may be put to sleep. When the DSS is
>>> resumed, these parts need to be woken up, and it may be that there's a
>>> higher mem latency for a short period of time right after resume.
>>> Which could again cause DSS not getting enough pixel data.
>>>
>>> You say the issue doesn't happen if you disable fb0. What happens if
>>> you disable fb0, blank the screen, then unblank the screen, and after
>>> that enable fb0 again?
>>
>> By "disable fb0" do you mean disconnect fb0 from ovl0 or disable ovl0?
>> I have done both:
>> http://pastebin.com/Bxm1Z2RY
>>
>> This works as expected.
>
> I think both disconnecting fb0 and ovl0, and disabling ovl0 end up doing
> the same, which is disabling ovl0. Which is what I meant.
>
> So, if I understand correctly, this only happens at unblank, and can be
> circumvented by temporarily keeping ovl0 disabled during the unblank,
> and enabling ovl0 afterwards works fine.
>
> So for some reason the time of unblank is "extra heavy" for the memory bus.
>
> Archit, I have a feeling that enabling the LCD is heavier on the memory
> bus than what happens at VBLANK, even if both start fetching the pixels
> for a fresh frame. You've been twiddling with the FIFO stuff, am I right
> there?

I don't think it's heavier in terms of memory bandwidth when you enable 
the LCD compared to the fetch of new frame content on a VBLANK. In both 
cases, the DSS tries to preload a few set of lines.

In terms of responsiveness from the interconnect, it's possible that DSS 
has a lower priority(in the round robin queue of initiators) compared to 
when it was active.

I don't know if LCD enable vs VBLANK has some sort of difference with VRFB.

>
>> Further tests I have done:
>>
>> Enable fb1/ovl1 and hit some keys on the keyboard to let fb0/ovl0 update in the
>> background causes a fifo underflow too:
>> http://pastebin.com/f3JnMLsV
>>
>> This happens only, if I enable the vrfb (rotate=3). So the whole thing
>> seems to be a rotation issue. Do you have some hints to trace down
>> the problem?
>
> Not rotation issue as such, but memory bandwidth issue.
>
>>> How about if you disable VRFB rotation, either totally, or set the
>>> rotation to 0 or 180 degrees?
>>
>> Disable rotation is not an option for me, as we have a "wrong" oriented
>> portrait display with 480x800 which we must use in landscape mode...
>
> I understand, I only meant that for testing purposes. VRFB rotation with
> 0 and 180 cause a slight impact on the mem bus, whereas 90 and 270
> rotation cause a large impact. Also, as I mentioned earlier, the PM may
> also affect this, as things may have been shut down in the OMAP. So
> disabling PM related features could also "fix" the problem.
>
> In many cases underflows are rather hard to debug and solve. There are
> things in the DSS hardware like FIFO thresholds and prefetch, and VRFB
> tile sizes, which can be changed (although unfortunately only by
> modifying the drivers). How they should be changed if a difficult
> question, though, and whether it'll help is also a question mark.

One thing which might help to debug this is to comment out the underflow 
error handling, and see if it continues to happen, this will tell if it 
was just a temporary bandwidth issue, or it's some consistent PM related 
thing

Archit
