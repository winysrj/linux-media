Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46735
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbcGOVuh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 17:50:37 -0400
Subject: Re: [PATCH] [media] vb2: map dmabuf for planes on driver queue
 instead of vidioc_qbuf
To: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org
References: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
 <57893C98.6040804@osg.samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Message-ID: <ba8fefc0-e0fd-b527-8852-3104347991b2@osg.samsung.com>
Date: Fri, 15 Jul 2016 17:50:25 -0400
MIME-Version: 1.0
In-Reply-To: <57893C98.6040804@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Shuah,

On 07/15/2016 03:42 PM, Shuah Khan wrote:
> On 07/15/2016 10:26 AM, Javier Martinez Canillas wrote:
>> The buffer planes' dma-buf are currently mapped when buffers are queued
>> from userspace but it's more appropriate to do the mapping when buffers
>> are queued in the driver since that's when the actual DMA operation are
>> going to happen.
>>
>> Suggested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> ---
>>
>> Hello,
>>
>> A side effect of this change is that if the dmabuf map fails for some
>> reasons (i.e: a driver using the DMA contig memory allocator but CMA
>> not being enabled), the fail will no longer happen on VIDIOC_QBUF but
>> later (i.e: in VIDIOC_STREAMON).
>>
>> I don't know if that's an issue though but I think is worth mentioning.
> 
> How does this change impact the user applications.? This changes

One thing that Nicolas mentioned is that for example GStreamer uses QBUF
to detect if a dma-buf is compatible, and fallbacks to a slow path if
that's not the case. For example if VIDIOC_QBUF fails, gst can attempt
to do another VIDIOC_REQBUFS with a different streaming I/O method as a
fallback.

If now QBUF doesn't fail, then gst will believe that it's OK and drop the
buffer so won't be able to recover from an error later and do a fallback.

Now, I don't know if that is the correct thing to expect since the v4l2
doc for VIDIOC_QBUF doesn't say that the ioctl should be used for this.

The question is if validating that the exported dma-buf can be imported
is something that could be done without attempting to do the mapping.

> the behavior and user applications now get dmabuf map error at a
> later stage in the call sequence.
>
> The change itself looks consistent with the change described.
> 
> -- Shuah
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
