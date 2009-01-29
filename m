Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:56829 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbZA2V7U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 16:59:20 -0500
Date: Thu, 29 Jan 2009 13:59:13 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: DongSoo Kim <dongsoo.kim@gmail.com>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCHv2] New V4L2 ioctls for OMAP class of Devices
In-Reply-To: <200901290933.36754.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0901291355570.17300@shell2.speakeasy.net>
References: <1233206626-19157-1-git-send-email-hardik.shah@ti.com>
 <5e9665e10901282344v38999d5bvdc5530dd4151f869@mail.gmail.com>
 <200901290933.36754.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2009, Hans Verkuil wrote:
> On Thursday 29 January 2009 08:44:20 DongSoo Kim wrote:
> > Hello.
> >
> > > +#define VIDIOC_S_COLOR_SPACE_CONV      _IOW('V', 83, struct
> > > v4l2_color_space_conversion) +#define VIDIOC_G_COLOR_SPACE_CONV
> > > _IOR('V', 84, struct v4l2_color_space_conversion)
> >
> > Do you mind if I ask a question about those ioctls?
> > Because as far as I understand, we can use VIDIOC_S_FMT ioctl to convert
> > colorspaces. Setting through colorspace member in v4l2_pix_format, we
> > could change output colorspace.
>
> Colorspace is read-only, you cannot set it. It just gives you the colorspace
> that the hardware uses by default.

Is there a reason it must be read-only?

> If you want to fully control the colorspace, then you need these ioctls.

I don't know about "fully".  I don't see anything about gamma correction.
Since there is no documentation, it's also not clear if it can describe the
full range luma the bt848 and cx88 can produce.
