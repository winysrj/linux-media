Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:38488 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2GSNle (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 09:41:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Soby Mathew <soby.linuxtv@gmail.com>
Subject: Re: Supporting 3D formats in V4L2
Date: Thu, 19 Jul 2012 15:41:07 +0200
Cc: linux-media@vger.kernel.org
References: <CAGzWAsg3hsGV5CPsCzxcKO4djG4iRZauEQvju=G=Zp4Rpqpz2g@mail.gmail.com>
In-Reply-To: <CAGzWAsg3hsGV5CPsCzxcKO4djG4iRZauEQvju=G=Zp4Rpqpz2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207191541.07286.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Soby!

On Thu 19 July 2012 14:18:13 Soby Mathew wrote:
> Hi everyone,
>     Currently there is limitation in v4l2 for specifying the 3D
> formats . In HDMI 1.4 standard, the following 3D formats are
> specified:

I think that this is ideal for adding to enum v4l2_field.
I've made some proposals below:

> 
>       1. FRAME_PACK,

V4L2_FIELD_3D_FRAME_PACK	(progressive)
V4L2_FIELD_3D_FRAME_PACK_TB	(interlaced, odd == top comes first)

>       2. FIELD_ALTERNATIVE,

V4L2_FIELD_3D_FIELD_ALTERNATIVE

>       3. LINE_ALTERNATIVE,

V4L2_FIELD_3D_LINE_ALTERNATIVE

>       4. SIDE BY SIDE FULL,

V4L2_FIELD_3D_SBS_FULL

>       5. SIDE BY SIDE HALF,

V4L2_FIELD_3D_SBS_HALF

>       6. LEFT + DEPTH,

V4L2_FIELD_3D_L_DEPTH

>       7. LEFT + DEPTH + GRAPHICS + GRAPHICS-DEPTH,

V4L2_FIELD_3D_L_DEPTH_GFX_DEPTH

>       8. TOP AND BOTTOM

V4L2_FIELD_3D_TAB

You would also need defines that describe which field is received for the field
alternative mode (it's put in struct v4l2_buffer):

V4L2_FIELD_3D_LEFT_TOP
V4L2_FIELD_3D_LEFT_BOTTOM
V4L2_FIELD_3D_RIGHT_TOP
V4L2_FIELD_3D_RIGHT_BOTTOM

> 
> 
> In addition for some of the formats like Side-by-side-half there are
> some additional metadata (like type of horizontal sub-sampling)

A control seems to be the most appropriate method of exposing the
horizontal subsampling.

> and
> parallax information which may be required for programming the display
> processing pipeline properly.

This would be a new ioctl, but I think this should only be implemented if
someone can actually test it with real hardware. The same is true for the
more exotic 3D formats above.

It seems SBS is by far the most common format.

> 
> I am not very sure on how to expose this to the userspace. This is an
> inherent property of video signal  , hence it would be appropriate to
> have an additional field in v4l_format to specify 3D format. Currently
> this is a requirement for HDMI 1.4 Rx / Tx but in the future it would
> be applicable to broadcast sources also.
> 
> In our implementation we have temporarily defined a Private Control to
> expose this .
> 
> Please let me know of your suggestions .

I hope this helps!

Regards,

	Hans
