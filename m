Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2582 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3IKI3M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 04:29:12 -0400
Message-ID: <523029C6.8070305@xs4all.nl>
Date: Wed, 11 Sep 2013 10:28:54 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: videobuf2: V4L2_BUF_TYPE_VIDEO_CAPTURE and V4L2_BUF_TYPE_VIDEO_OUTPUT
 at the same time?
References: <CAPybu_2dq6FkWebNw8ySD=4wJu++3z7K6oNDjXEJvcKVvRTVsQ@mail.gmail.com>
In-Reply-To: <CAPybu_2dq6FkWebNw8ySD=4wJu++3z7K6oNDjXEJvcKVvRTVsQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Memory-to-memory devices can do this. In that case querycap will return the M2M
or M2M_MPLANE capability. The mem2mem_testdev driver is a good example.

Other devices shouldn't combine the two.

On 09/10/2013 04:10 PM, Ricardo Ribalda Delgado wrote:
> Hello!
> 
> I am writing the driver for a device that can work as an input and as
> output at the same time. It is used for debugging of the video
> pipeline.
> 
> Is it possible to have a vb2 queue that supports capture and out at
> the same time?
> 
> After a fast look on the code it seems that the code flow is different
> depending of the type. if (V4L2_TYPE_IS_OUTPUT()....)  :(

A vb2_queue is for one direction only, so for a bidirectional device you need
two vb2_queue structs. It's recommended to use the v4l2-mem2mem.h framework
for that, as is also used by the mem2mem_testdev driver.

> 
> Also it seems that struct video device has only space for one
> vb2_queue, so I cant create a video device with two vbuf2 queues.

You can, but not by using the vb2_queue pointer in videodev. It might
actually be nice to add better core support for m2m devices. If
someone needs a project, then that would be nice.

Regards,

	Hans

> So is there any way to have a video device with videobuf2 that
> supports caputer and output?
> 
> Thanks!
> 
