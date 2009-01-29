Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1273 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbZA2IlP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 03:41:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Shah, Hardik" <hardik.shah@ti.com>
Subject: Re: [PATCHv2] New V4L2 ioctls for OMAP class of Devices
Date: Thu, 29 Jan 2009 09:41:06 +0100
Cc: DongSoo Kim <dongsoo.kim@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02F535F6BD@dbde02.ent.ti.com>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB02F535F6BD@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901290941.06705.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 29 January 2009 09:28:07 Shah, Hardik wrote:
> > -----Original Message-----
> > From: DongSoo Kim [mailto:dongsoo.kim@gmail.com]
> > Sent: Thursday, January 29, 2009 1:14 PM
> > To: Shah, Hardik
> > Cc: linux-media@vger.kernel.org; video4linux-list@redhat.com
> > Subject: Re: [PATCHv2] New V4L2 ioctls for OMAP class of Devices
> >
> > Hello.
> >
> > > +#define VIDIOC_S_COLOR_SPACE_CONV      _IOW('V', 83, struct
> >
> > v4l2_color_space_conversion)
> >
> > > +#define VIDIOC_G_COLOR_SPACE_CONV      _IOR('V', 84, struct
> >
> > v4l2_color_space_conversion)
> >
> > Do you mind if I ask a question about those ioctls?
> > Because as far as I understand, we can use VIDIOC_S_FMT ioctl to
> > convert colorspaces. Setting through colorspace member in
> > v4l2_pix_format, we could change output colorspace.
> > If there is some different use, can you tell me what it is?
>
> [Shah, Hardik] OMAP Display sub-system supports various pixel formats as
> inputs like YUV, UYVY, RGB24, RGB16 but the compositors which take these
> input format and displays on to the output devices like TV, LCD can only
> understand RGB format.  Hardware has provision for converting any data
> taken in YUV or UYVY format to be converted into the RGB formats, before
> giving it to the output devices.  To convert this hardware needs to be
> programmed with correct coefficient and offsets to convert from YUV to
> RGB.

Does that mean that when I select a YUV format for output, I still need to 
call the color space conversion ioctl? That is not right. Selecting a 
format must setup the CSC with decent defaults. I assumed the CSC ioctls 
were only meant for fine-grained control: first you call S_FMT to select 
the pixelformat which sets up the CSC with defaults, then you call 
VIDIOC_G/S_COLOR_SPACE_CONV to modify them if needed.

Regards,

	Hans

> These coefficients are pretty standard but still some one may 
> require altering it. For this new ioctl is added.  Standard equation for
> converting from YUV or UYVY is
>
> | R |		| RY RCr RCb |   | Y - 16   |
> | G | = 1/K | Gy GCr Gcb | * | Cr - 128 |
> | B |		| By BCr BCb |   | Cb - 128 |
>
> Where Ry, Rcr, Rcb Gy, Gcr, Gcb, By, Bcr and Bcb are the programmable
> coefficients.  But in future offsets like Y-16, Cr-128 or Cb-128 or
> constant like 1/K may also be programmable.  So I have added this new
> ioctl.
>
> Regards,
> Hardik Shah
>
> > Regards,
> > Nate
> >
> > --
> > ========================================================
> > Dong Soo, Kim
> > Engineer
> > Mobile S/W Platform Lab. S/W centre
> > Telecommunication R&D Centre
> > Samsung Electronics CO., LTD.
> > e-mail : dongsoo.kim@gmail.com
> >            dongsoo45.kim@samsung.com
> > ========================================================
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
