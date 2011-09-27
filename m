Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3583 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1I0JoO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 05:44:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: [PATCH 4/4 v2][FOR 3.1] v4l2: add blackfin capture bridge driver
Date: Tue, 27 Sep 2011 11:42:41 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
References: <1316465981-28469-1-git-send-email-scott.jiang.linux@gmail.com> <201109261609.32349.hverkuil@xs4all.nl> <CAHG8p1BiKzS8sJ+qxWSFw0Uk+0gC0e7ABmJaT8igaSeYttOtLw@mail.gmail.com>
In-Reply-To: <CAHG8p1BiKzS8sJ+qxWSFw0Uk+0gC0e7ABmJaT8igaSeYttOtLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271142.41309.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, September 27, 2011 10:23:35 Scott Jiang wrote:
> >
> >> +             ret = v4l2_subdev_call(bcap_dev->sd, video,
> >> +                                     g_mbus_fmt, &mbus_fmt);
> >> +             if (ret < 0)
> >> +                     return ret;
> >> +
> >> +             for (i = 0; i < BCAP_MAX_FMTS; i++) {
> >> +                     if (mbus_fmt.code != bcap_formats[i].mbus_code)
> >> +                             continue;
> >> +                     bcap_fmt = &bcap_formats[i];
> >> +                     v4l2_fill_pix_format(pixfmt, &mbus_fmt);
> >> +                     pixfmt->pixelformat = bcap_fmt->pixelformat;
> >> +                     pixfmt->bytesperline = pixfmt->width * bcap_fmt->bpp / 8;
> >> +                     pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
> >> +                     break;
> >> +             }
> >> +             if (i == BCAP_MAX_FMTS) {
> >> +                     v4l2_err(&bcap_dev->v4l2_dev,
> >> +                                     "subdev fmt is not supported by bcap\n");
> >> +                     return -EINVAL;
> >> +             }
> >
> > Why do this on first open? Shouldn't it be better to do this after the subdev
> > was loaded?
> >
> Hi Hans, thank you for your comments.
> This point I haven't had a good solution. PPI is only a parallel port,
> it has no default std or format.
> That's why you always found I have no default std and format.
> Sylwester Nawrocki recommend me add this code here, but different
> input can has different std and format according to v4l2 spec.
> That means if app only set input, or set input and std without setting
> format, the default format getting here may be invalid.
> Do you have any better solution for this?

What you would typically do in a case like this (if I understand it
correctly) is that in the s_input ioctl you first select the input in the
subdev, and then you can call the subdev to determine the standard and
format and use that information to set up the bridge. This requires that
the subdev is able to return a proper standard/format after an input
change.

By also selecting an initial input at driver load you will ensure that
you always have a default std/fmt available from the very beginning.

It also looks like the s_input in the bridge driver allows for inputs that
return a subdev format that can't be supported by the bridge. Is that correct?
If so, then the board code should disallow such inputs. Frankly, that's a
WARN_ON since that is something that is never supposed to happen.

Regards,

	Hans
