Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:32818 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbZCYUkc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 16:40:32 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pxa-camera: simplify the .buf_queue path by merging two loops
References: <1236986240-24115-1-git-send-email-robert.jarzmik@free.fr>
	<1236986240-24115-2-git-send-email-robert.jarzmik@free.fr>
	<1236986240-24115-3-git-send-email-robert.jarzmik@free.fr>
	<1236986240-24115-4-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903161153200.4409@axis700.grange>
	<87hc1tdzv2.fsf@free.fr>
	<Pine.LNX.4.64.0903250935090.5795@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 25 Mar 2009 21:40:20 +0100
In-Reply-To: <Pine.LNX.4.64.0903250935090.5795@axis700.grange> (Guennadi Liakhovetski's message of "Wed\, 25 Mar 2009 09\:37\:15 +0100 \(CET\)")
Message-ID: <87r60lpc97.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> pxa_dma_update_sg_tail() is called only once, runs exactly the same loop as the
> caller and has to recalculate the last element in an sg-list, that the caller
> has already calculated. Eliminate redundancy by merging the two loops and
> re-using the calculated pointer. This also saves a bit of performance which is
> always good during video-capture.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> On Mon, 16 Mar 2009, Robert Jarzmik wrote:
>
>> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
>> 
>> > pxa_dma_update_sg_tail is called only here, why not inline it and also put 
>> > inside one loop?
>> As for the inline, I'm pretty sure you know it is automatically done by gcc.
>> 
>> As for moving it inside the loop, that would certainly improve performance. Yet
>> I find it more readable/maintainable that way, and will leave it. But I won't be
>> bothered at all if you retransform it back to your view, that's up to you.
>
> Robert, this is what I'm going to apply on top of your patch-series. 
> Please, object:-)
Here you are : :)
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

--
Robert
