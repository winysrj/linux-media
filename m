Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4911 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZA3JDH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2009 04:03:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCHv2] New V4L2 ioctls for OMAP class of Devices
Date: Fri, 30 Jan 2009 10:02:37 +0100
Cc: DongSoo Kim <dongsoo.kim@gmail.com>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	linux-media@vger.kernel.org
References: <1233206626-19157-1-git-send-email-hardik.shah@ti.com> <200901290933.36754.hverkuil@xs4all.nl> <Pine.LNX.4.58.0901291355570.17300@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0901291355570.17300@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301002.38257.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 29 January 2009 22:59:13 Trent Piepho wrote:
> On Thu, 29 Jan 2009, Hans Verkuil wrote:
> > On Thursday 29 January 2009 08:44:20 DongSoo Kim wrote:
> > > Hello.
> > >
> > > > +#define VIDIOC_S_COLOR_SPACE_CONV      _IOW('V', 83, struct
> > > > v4l2_color_space_conversion) +#define VIDIOC_G_COLOR_SPACE_CONV
> > > > _IOR('V', 84, struct v4l2_color_space_conversion)
> > >
> > > Do you mind if I ask a question about those ioctls?
> > > Because as far as I understand, we can use VIDIOC_S_FMT ioctl to
> > > convert colorspaces. Setting through colorspace member in
> > > v4l2_pix_format, we could change output colorspace.
> >
> > Colorspace is read-only, you cannot set it. It just gives you the
> > colorspace that the hardware uses by default.
>
> Is there a reason it must be read-only?

The V4L2 spec. And I've no idea if we can safely change it to a read/write 
property or if there are apps out their that do not set this field.

> > If you want to fully control the colorspace, then you need these
> > ioctls.
>
> I don't know about "fully".  I don't see anything about gamma correction.
> Since there is no documentation, it's also not clear if it can describe
> the full range luma the bt848 and cx88 can produce.

I'm also waiting for full documentation on this. I do know that this type of 
matrix is common in other devices as well.

I'm not sure if gamma correction can be done with CSC, but I think that 
should be done through a separate control anyway. However, I'm no expert.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
