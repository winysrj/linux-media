Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2825 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762541AbZE1VVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 17:21:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: Re: About s_stream in v4l2-subdev
Date: Thu, 28 May 2009 23:21:17 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dongsoo45.kim@samsung.com" <dongsoo45.kim@samsung.com>,
	=?utf-8?q?=EB=AF=BC=EB=B3=91=ED=98=B8?= <bhmin@samsung.com>,
	=?utf-8?q?=EA=B9=80=ED=98=95=EC=A4=80_=EA=B9=80?=
	<riverful.kim@samsung.com>
References: <5e9665e10905280420x73ebc7ean5c029b131e6b7e8c@mail.gmail.com>
In-Reply-To: <5e9665e10905280420x73ebc7ean5c029b131e6b7e8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905282321.17931.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 28 May 2009 13:20:15 Dongsoo, Nathaniel Kim wrote:
> Hello everyone,
>
> I'm doing my driver job with kernel 2.6.30-rc6, trying to figure out
> how to convert my old drivers to v4l2-subdev framework. Looking into
> the v4l2-subdev.h file an interesting API popped up and can't find any
> precise comment about that. It is "s_stream" in v4l2_subdev_video_ops.
> I think I found this api in the very nick of time, if the purpose of
> that api  is exactly what I need. Actually, I was trying to make my
> sub device to get streamon and streamoff command from the device side,
> and I wish the "s_stream" is that for. Because in case of camera
> module with embedded JPEG encoder, it is necessary to make the camera
> module be aware of the exact moment of streamon to pass the encoded
> data to camera interface. (many of camera ISPs can't stream out
> continuous frame of JPEG data, so we have only one chance  of shot).
> Is the s_stream for streamon purpose in subdev? (I hope so...finger
> crossed) Cheers,

Yes it is. It is for subdevs that need to implement VIDIOC_STREAMON and 
VIDIOC_STREAMOFF.

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
