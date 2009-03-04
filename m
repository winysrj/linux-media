Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:43409 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbZCDSLg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2009 13:11:36 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: ospite@studenti.unina.it, mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pxa_camera: Redesign DMA handling
References: <1236021422-8074-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903030929160.5059@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 04 Mar 2009 19:11:24 +0100
In-Reply-To: <Pine.LNX.4.64.0903030929160.5059@axis700.grange> (Guennadi Liakhovetski's message of "Tue\, 3 Mar 2009 16\:49\:51 +0100 \(CET\)")
Message-ID: <87bpsh2m5v.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> (moved to the new v4l list)
>
>> The DMA transfers in pxa_camera showed some weaknesses in
>> multiple queued buffers context :
>>  - poll/select problem
>>    The order between list pcdev->capture and DMA chain was
>>    not the same. This creates a discrepancy between video
>>    buffers marked as "done" by the IRQ handler, and the
>>    really finished video buffer.
>
> Could you please describe where and how the order could get wrong?
Sorry, I missed that point in the previous reply.

It's still the same bit of code :
-                       } else {
-                               buf_dma->sg_cpu[nents].ddadr =
-                                       DDADR(pcdev->dma_chans[i]);

That chains the end of the queued buffer to the active buffer (probably the one
running in DMA chain [1]). So we'll get images in the following order:

 <queued_buffer>, then <active_buffer (head of pcdev->capture)>, then <others>.

The desired order is :
 <active_buffer (head of pcdev->capture)>, then <others>, then <queued_buffer>.

>>  - multiple buffers DMA starting
>>    When multiple buffers were queued, the DMA channels were
>
> You mean multiple scatter-gather elements?
No, I mean multiple video buffers.
Multiple scatter-gather elements form one video buffer, and multiple video
buffers are queued to form a list of images (video stream).

Cheers.

--
Robert

[1] I mean _probably_, because the DMA chain can be already ahead of 1 buffer
(we're talking in terms of PXA cycles, which is very hard to watch), while
active pointer is not yet updated.
