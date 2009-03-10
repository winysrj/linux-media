Return-path: <linux-media-owner@vger.kernel.org>
Received: from wmproxy2-g27.free.fr ([212.27.42.92]:33095 "EHLO
	wmproxy2-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbZCJK0J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 06:26:09 -0400
Date: Tue, 10 Mar 2009 11:25:47 +0100 (CET)
From: robert.jarzmik@free.fr
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <1810737378.2957541236680747373.JavaMail.root@zimbra20-e3.priv.proxad.net>
In-Reply-To: <1214153377.2956891236680608913.JavaMail.root@zimbra20-e3.priv.proxad.net>
Subject: Re: [PATCH 2/4] pxa_camera: Redesign DMA handling
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Now consider the "first vb" was unqueued _and_ requeued in the meantime, while
> the "new buffer" was under DMA active filling.
> Won't we finish with something like :
> 
> +-----------------------+  +------------------+
> | Former New vb | dummy |  | First vb | dummy |
> +-------^-----------|---+  +----^-----+---|---+
>         |           |           |         |
>         |           +-----------+         |
>         |            former link          |
>         |                                 |
>         |                                 |
>         +---------------------------------+
>                   new restarter link

> No. remember, the last _valid_ descriptor contains the DDADR_STOP as the 
> next descriptor address, so, it'll stop there.
OK, I see. I'll check this evening.

> 
> Would you mind if I changed the pxa descriptors chain for _one_ video buffer into :
>  +-----------+------------+------------+-----+---------------+-----------------+
>  | restarter | desc-sg[0] | desc-sg[1] | ... | desc-sg[last] | finisher/linker |
>  +-----------+------------+------------+-----+---------------+-----------------+
> where :
>  - desc-sg[n] are descriptors to fill in the image
>  - finisher/linker is either the DMA STOP, or just a 0 bytes transfer with next 
>    descriptor set up to the desc-sg[0] of the next captured frame
>  - restarter is never used (ie. DMA chains start always at desc-sg[0]), excepting
>    when restarting a running chain
> 
> I know I ask for 1 additionnal descriptor, but I find that easier to maintain.
> Would you agree for such a change ?

> 1 Additional descriptor is not a big problem per se, they are only a few 
> bytes big, the question is only if this really improves anything. I have 
> taken over the current solution as the "only working" from original 
                                             \-> I'm not really convinced,
                                                 as capture_example _doesn't_ work
                                                 and remains "unkillable".
You have my test bed at your disposition (previous mail), you can try.

> sources, probably, going back to Intel. As you understand, this is quite 
> critical code, and we shouldn't break it. So, unless there are real good 
                                    \-> true, we sould improve it.

> in a race-free way. Maybe we could do something like
> 1. prepare the new descriptor-chain.
> 2. with one instruction append it to the current tail by just rewriting 
>    the tail's next descriptor pointer, which was equal to DDADR_STOP
> 3. verify if it worked, i.e., if DMA is still before the merge-point or 
>    already after it.
> 4. fast path - in most cases we would succeed, so, we are done, just 
>    update all our software states. If we failed, and DMA stopped before we 
>    have overwritten the pointer, re-start DMA from the beginning of our 
>    new buffer, which should be fast and race-free.

> I think, actually, this might work. We only have to think carefully about 
> 3 - how do we reliably verify the DMA status?
I don't think there is a way with this approach. The trouble is if we don't
stop the DMA, we'll read DDADR() and act upon its value. But the time we act,
DDADR() could have changed to DDADR_STOP for example.

OTOH, what could be done is to check in the pxa_cam_wakeup(), when we dequeue
a video buffer, if DDADR() == DDADR_STOP. If the DMA is stopped and a buffer
remains on the capture list, we fell into the case where our chaining didn't
work => we call pxa_cam_start_capture(), and the videobuffer will be handled.

If DDADR() was not DDADR_STOP, that means _another_ buffer was running, and we
have the guarantee to be called once again in pxa_cam_wakeup(), so we leave the
situation as it is, and check the next time.

With this approach (which is your approach, but 3+4 are moved to
pxa_camera_wakeup), we shouldn't need to stop the DMA chain. The price to pay
is a check in pxa_camera_wakeup(), and a restart of a frame queued in an
impossibly tiny time window.

What do you think of that one ?

> What do you think?
I think we think basically the same thing, and that's good :) I'll make a try
this evening, and maybe another couple of days to cross-check all debug traces.
I'll try the algorithm we specified (as there might be exchanges in the day).
As a fallback, if it doesn't work, I would have to stop the DMA chain as before.

Don't hesitate to comment on the algorithm, there's still refining to be done,
and I need you on it. I feel something great will come out of it :))))

Cheers.

--
Robert
