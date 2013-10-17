Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27669 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3JQP1b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 11:27:31 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MUT000MSK7UR7E0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 17 Oct 2013 16:27:29 +0100 (BST)
Message-id: <526001DF.9040309@samsung.com>
Date: Thu, 17 Oct 2013 17:27:27 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: John Sheu <sheu@google.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	m.chehab@samsung.com, Kamil Debski <k.debski@samsung.com>,
	pawel@osciak.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: Fwd: [PATCH 3/6] [media] s5p-mfc: add support for
 VIDIOC_{G,S}_CROP to encoder
References: <1381362589-32237-1-git-send-email-sheu@google.com>
 <1381362589-32237-4-git-send-email-sheu@google.com>
 <52564DE6.6090709@xs4all.nl>
 <CAErgknA-3bk1BoYa6KJAfO+863DBTi_5U8i_hh7F8O+mXfyNWg@mail.gmail.com>
 <CAErgknA-ZgSzeeaaEuYKFZ0zonCt=10tBX7FeOT16-yQLZVnZw@mail.gmail.com>
 <52590184.5030806@xs4all.nl>
 <CAErgknAXZzbBMm0JeASOVzsXNNyu7Af32hd0t_fR8VkPeVrx4A@mail.gmail.com>
In-reply-to: <CAErgknAXZzbBMm0JeASOVzsXNNyu7Af32hd0t_fR8VkPeVrx4A@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello John,

I am a designer of original selection API. Maybe I could clarify what
does what in VIDIOC_S_CROP ioctl.

> I thought you were not making sense for a bit.  Then I walked away,
> came back, and I think you're making sense now.  So:
>
> * Crop always refers to the source image
> * Compose always refers to the destination image
>

Not exactly. Look below.

There are three basic cases in V4L2 that deal with crop/compose features.



CASE 1. Capture devices like sensors



There is only queue, the capture queue.

The only valid buffer types are V4L2_BUF_TYPE_VIDEO_CAPTURE
or V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE.

OLD API:

The operation
	ioctl(fd, VIDIOC_S_CROP, struct v4l2_crop { .type = V4L2_BUF_TYPE_VIDEO_CAPTURE } )

selects an area on a sensor array that is processed by a device.
The memory buffers is filled totally with data produced by the device.

It is NOT possible to partially fill a buffer.


In selection API the old API call:
	ioctl(capture, VIDIOC_S_CROP, struct v4l2_crop { .type = V4L2_BUF_TYPE_VIDEO_CAPTURE })
becomes
	ioctl(capture, VIDIOC_S_SELECTION, struct v4l2_selection { .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
		.target = V4L2_SEL_TGT_CROP })


Setting a area in the memory buffer (not supported in old API) is done by:
	ioctl(capture, VIDIOC_S_SELECTION, struct v4l2_selection { .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
		.target = V4L2_SEL_TGT_COMPOSE })



CASE 2. Output devices like TV encoders.




There is only output queue.

The only valid buffer types are V4L2_BUF_TYPE_VIDEO_OUTPUT
or V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE.

OLD API:

The operation
	ioctl(fd, VIDIOC_S_CROP, struct v4l2_crop { .type = V4L2_BUF_TYPE_VIDEO_OUTPUT } )

selects an area on a display where buffer's content is inserted.
So technically VIDIOC_S_CROP is used to configure composing.
It was a quick and effective hack to utilize good old VIDIOC_S_CROP
for a new type of device in V4L2, the output device.

It is NOT possible to chose which part of a memory buffer is going to be
displayed. One has to insert the whole buffer.

With selection API old API call becomes
	ioctl(capture, VIDIOC_S_SELECTION, struct v4l2_selection { .type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
		.target = V4L2_SEL_TGT_COMPOSE })


Setting a area in the memory buffer (not supported in old API) is done by:
	ioctl(capture, VIDIOC_S_SELECTION, struct v4l2_selection { .type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
		.target = V4L2_SEL_TGT_CROP })




CASE 3. The memory-to-memory devices




There are two queues capture and output.
The only valid buffer types are V4L2_BUF_TYPE_VIDEO_OUTPUT
or V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE or V4L2_BUF_TYPE_VIDEO_CAPTURE
or V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE.

OLD API:

The operation
	ioctl(fd, VIDIOC_S_CROP, struct v4l2_crop { .type = V4L2_BUF_TYPE_VIDEO_CAPTURE } )
selects an area in a destination buffer that is filled by a device.
Notice that it is something completely different from definition
of VIDIOC_S_CROP on only-capture devices.
In case of M2M, crop means composing actually.

The operation
	ioctl(fd, VIDIOC_S_CROP, struct v4l2_crop { .type = V4L2_BUF_TYPE_VIDEO_OUTPUT } )
selects an area in source buffer that is processed by hardware. So it is
actually cropping contradictory to what VIDIOC_S_CROP does on only-output devices.

All describe non-consistencies seams to a result of some
misunderstanding that happened in early days of m2m API.
Currently, there are applications use M2M devices and
assume the mentioned behavior. I am afraid that it is now
an unintentional part V4L2 API :(.

That is why I strongly recommend to migrate to selection API.
In selection API
	ioctl(fd, VIDIOC_S_CROP, struct v4l2_crop { .type = V4L2_BUF_TYPE_VIDEO_OUTPUT } )
becomes
	ioctl(capture, VIDIOC_S_SELECTION, struct v4l2_selection { .type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
		.target = V4L2_SEL_TGT_CROP })

Moreover, the old API call
	ioctl(fd, VIDIOC_S_CROP, struct v4l2_crop { .type = V4L2_BUF_TYPE_VIDEO_CAPTURE } )
becomes
	ioctl(capture, VIDIOC_S_SELECTION, struct v4l2_selection { .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
		.target = V4L2_SEL_TGT_COMPOSE })

So in all cases cropping is cropping, composing is composing.
The other advantage of selection API are constraint flags that can be used co control
for policy of rounding rectangle's coordinates.
Moreover, the selection API provides additional methods to extract
bounds for rectangles, default areas, and padding areas.

It is important to know that currently the behavior of two operation:
	ioctl(capture, VIDIOC_S_SELECTION, struct v4l2_selection { .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
		.target = V4L2_SEL_TGT_CROP })
	ioctl(capture, VIDIOC_S_SELECTION, struct v4l2_selection { .type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
		.target = V4L2_SEL_TGT_COMPOSE })
is still undefined and application should not use them.


I hope you find this information useful.


Regards,
Tomasz Stanislawski


On 10/12/2013 11:08 AM, John Sheu wrote:

> On Sat, Oct 12, 2013 at 1:00 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 10/12/2013 01:48 AM, John Sheu wrote:
>>> On Wed, Oct 9, 2013 at 11:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> In all cases, the crop boundary refers to the area in the source
>>> image; for a CAPTURE device, this is the (presumably analog) sensor,
>>
>> Correct.
>>
>>> and for an OUTPUT device, this is the memory buffer.
>>
>> Correct.
> 
> Here you are referring to the crop boundary, which is _not_ always
> what {G,S}_CROP refers to.  (Confusing part).  {G,S}_CROP refers to
> the crop boundary only for a CAPTURE queue.
> 
>>> My particular
>>> case is a memory-to-memory device, with both CAPTURE and OUTPUT
>>> queues.  In this case, {G,S}_CROP on either the CAPTURE or OUTPUT
>>> queues should effect exactly the same operation: cropping on the
>>> source image, i.e. whatever image buffer I'm providing to the OUTPUT
>>> queue.
>>
>> Incorrect.
>>
>> S_CROP on an OUTPUT queue does the inverse: it refers to the area in
>> the sink image.
> 
> This confused me for a bit (seeming contradiction with the above),
> until I realized that you're referring to the S_CROP ioctl here, which
> is _not_ the "crop boundary"; on an OUTPUT queue it refers to the
> compose boundary.
> 
>> No, it adds the compose operation for capture and the crop operation for
>> output, and it uses the terms 'cropping' and 'composing' correctly
>> without the inversion that S_CROP introduced on the output side.
>>
>> Bottom line: S_CROP for capture is equivalent to S_SELECTION(V4L2_SEL_TGT_CROP).
>> S_CROP for output is equivalent to S_SELECTION(V4L2_SEL_TGT_COMPOSE).
> 
> So yes.  By adding the {G,S}_SELECTION ioctls we can now refer to the
> compose boundary for CAPTURE, and crop boundary for OUTPUT.
> 
> 
> Now, here's a question.  It seems that for a mem2mem device, since
> {G,S}_CROP on the CAPTURE queue covers the crop boundary, and
> {G,S}_CROP on the OUTPUT queue capture the compose boundary, is there
> any missing functionality that {G,S}_SELECTION is covering here.  In
> other words: for a mem2mem device, the crop and compose boundaries
> should be identical for the CAPTURE and OUTPUT queues?
> 
> -John Sheu
> 

