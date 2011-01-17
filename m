Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3711 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab1AQGwR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 01:52:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jonghun Han <jonghun.han@samsung.com>
Subject: Re: How to set global alpha to V4L2_BUF_TYPE_CAPTURE ?
Date: Mon, 17 Jan 2011 07:52:02 +0100
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	"'Marek Szyprowski'" <m.szyprowski@samsung.com>
References: <003801cbb5f8$ec278180$c4768480$%han@samsung.com>
In-Reply-To: <003801cbb5f8$ec278180$c4768480$%han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101170752.03018.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, January 17, 2011 04:44:54 Jonghun Han wrote:
> 
> Hello,
> 
> How to set global alpha to V4L2_BUF_TYPE_CAPTURE ?
> 
> Samsung SoC S5PC210 has Camera interface and Video post processor named FIMC
> which can set the alpha value to V4L2_BUF_TYPE_CAPTURE. 
> For example during color space conversion from YUV422 to ARGB8888, 
> FIMC can set the alpha value to V4L2_BUF_TYPE_CAPTURE.
> 
> I tried to find an available command to set it but I couldn't found it.

That's right, there isn't.

> But there is fmt.win.global_alpha for Video Overlay Interface.
> So in my opinion VIDIOC_S_FMT is also suitable for V4L2_BUF_TYPE_CAPTURE*.
> How about using fmt.pix.priv in struct v4l2_format 
> and fmt.pix_mp.reserved[0] in struct v4l2_format ?

Not a good idea. This is really ideal for a control. We already have a
somewhat similar control in the form of V4L2_CID_BG_COLOR. It's perfectly
reasonable to add a V4L2_CID_ALPHA_COLOR (or something similar) where you
set this up.

The little available space in the format structs is too precious to use for
something trivial like this :-)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
