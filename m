Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:53398 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159AbcCUWt6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 18:49:58 -0400
Subject: Re: [PATCH RFC 0/2] pxa_camera transition to v4l2 standalone device
To: Robert Jarzmik <robert.jarzmik@free.fr>
References: <1458421288-22094-1-git-send-email-robert.jarzmik@free.fr>
 <56EFAD47.8010403@xs4all.nl> <87lh5bmpro.fsf@belgarion.home>
 <56F077A4.1090808@xs4all.nl> <87h9fzmozy.fsf@belgarion.home>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56F07A90.8060305@xs4all.nl>
Date: Mon, 21 Mar 2016 23:49:52 +0100
MIME-Version: 1.0
In-Reply-To: <87h9fzmozy.fsf@belgarion.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/2016 11:42 PM, Robert Jarzmik wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
>>> Input ioctls:
>>> 	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>>> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>> 	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>>> 	test VIDIOC_ENUMAUDIO: OK (Not Supported)
>>> 		fail: v4l2-test-input-output.cpp(418): G_INPUT not supported for a capture device
>>
>> ENUM/G/S_INPUT is missing and is required for capture devices.
> Okay, that one will be easy I think :) It's a mono-sensor mono-videostream IP.
> I will add that when for RFC v2.
> 
>>> 	Format ioctls:
>>> 		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>>> 		test VIDIOC_G/S_PARM: OK (Not Supported)
>>> 		test VIDIOC_G_FBUF: OK (Not Supported)
>>> 		fail: v4l2-test-formats.cpp(329): pixelformat != V4L2_PIX_FMT_JPEG && colorspace == V4L2_COLORSPACE_JPEG
>>> 		fail: v4l2-test-formats.cpp(432): testColorspace(pix.pixelformat, pix.colorspace, pix.ycbcr_enc, pix.quantization)
>>
>> The sensor should almost certainly use COLORSPACE_SRGB. Certainly not
>> COLORSPACE_JPEG.
> Ah even for YUYV format, I didn't know ...

The pixel format != colorspace. You can read more about that here, if you are
interested:

https://hverkuil.home.xs4all.nl/spec/media.html#colorspaces

> 
>>> 	Buffer ioctls:
>>> 		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>> 		fail: v4l2-test-buffers.cpp(571): q.has_expbuf(node)
>>
>> You are missing .vidioc_expbuf = vbs_ioctl_expbuf and the vb2 io_mode
>> VB2_DMABUF.
> Nope, I have :
> 	.vidioc_expbuf			= vb2_ioctl_expbuf,
> 	vq->io_modes = VB2_MMAP | VB2_DMABUF;
> 
> So it's something more subtle, and I have a bit of work to understand what.

Fix the colorspace issue first, I wonder if it is just fallout from that earlier
issue.

Regards,

	Hans

> 
> Cheers.
> 
> --
> Robert
> 

