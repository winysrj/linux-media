Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3660 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab2HVLJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 07:09:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: workshop-2011@linuxtv.org
Subject: Re: [Workshop-2011] V4L2 API ambiguities: workshop presentation
Date: Wed, 22 Aug 2012 13:09:25 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201208171235.58094.hverkuil@xs4all.nl>
In-Reply-To: <201208171235.58094.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208221309.25058.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri August 17 2012 12:35:58 Hans Verkuil wrote:
> Hi all,
> 
> I've prepared a presentation for the upcoming workshop based on my RFC and the
> comments I received.
> 
> It is available here:
> 
> http://hverkuil.home.xs4all.nl/presentations/v4l2-workshop-2012.odp
> http://hverkuil.home.xs4all.nl/presentations/v4l2-workshop-2012.pdf
> 
> Attendees of the workshop: please review this before the workshop starts. I
> want to go through this list fairly quickly (particularly slides 1-14) so we
> can have more time for other topics.

One additional topic:

The V4L2 API has a number of experimental API elements, see:

	http://hverkuil.home.xs4all.nl/spec/media.html#experimental

The following have been in use for a considerable amount of time I and propose
to drop the experimental tag:

Video Output Overlay (OSD) Interface, the section called “Video Output Overlay Interface”.

V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY, enum v4l2_buf_type, Table 3.3, “enum v4l2_buf_type”.

V4L2_CAP_VIDEO_OUTPUT_OVERLAY, VIDIOC_QUERYCAP ioctl, Table A.92, “Device Capabilities Flags”.

VIDIOC_ENUM_FRAMESIZES and VIDIOC_ENUM_FRAMEINTERVALS ioctls.

VIDIOC_G_ENC_INDEX ioctl.

VIDIOC_ENCODER_CMD and VIDIOC_TRY_ENCODER_CMD ioctls.

VIDIOC_DECODER_CMD and VIDIOC_TRY_DECODER_CMD ioctls.


While the (TRY_)DECODER_CMD ioctls are strictly speaking new to V4L2 (appearing
in 3.4) they started life as identical ioctls (although with a different name)
in dvb/video.h.

Other than being renamed and folded into the V4L2 specification they are quite
old as well.

Regards,

	Hans
