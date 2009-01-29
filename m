Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1315 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbZA2IeD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 03:34:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: DongSoo Kim <dongsoo.kim@gmail.com>
Subject: Re: [PATCHv2] New V4L2 ioctls for OMAP class of Devices
Date: Thu, 29 Jan 2009 09:33:36 +0100
Cc: Hardik Shah <hardik.shah@ti.com>, linux-media@vger.kernel.org,
	video4linux-list@redhat.com
References: <1233206626-19157-1-git-send-email-hardik.shah@ti.com> <5e9665e10901282344v38999d5bvdc5530dd4151f869@mail.gmail.com>
In-Reply-To: <5e9665e10901282344v38999d5bvdc5530dd4151f869@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901290933.36754.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 29 January 2009 08:44:20 DongSoo Kim wrote:
> Hello.
>
> > +#define VIDIOC_S_COLOR_SPACE_CONV      _IOW('V', 83, struct
> > v4l2_color_space_conversion) +#define VIDIOC_G_COLOR_SPACE_CONV     
> > _IOR('V', 84, struct v4l2_color_space_conversion)
>
> Do you mind if I ask a question about those ioctls?
> Because as far as I understand, we can use VIDIOC_S_FMT ioctl to convert
> colorspaces. Setting through colorspace member in v4l2_pix_format, we
> could change output colorspace.

Colorspace is read-only, you cannot set it. It just gives you the colorspace 
that the hardware uses by default.

If you want to fully control the colorspace, then you need these ioctls.

Regards,

	Hans

> If there is some different use, can you tell me what it is?
>
> Regards,
> Nate



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
