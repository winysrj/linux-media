Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45848 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbZA2I2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 03:28:42 -0500
From: "Shah, Hardik" <hardik.shah@ti.com>
To: DongSoo Kim <dongsoo.kim@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Thu, 29 Jan 2009 13:58:07 +0530
Subject: RE: [PATCHv2] New V4L2 ioctls for OMAP class of Devices
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02F535F6BD@dbde02.ent.ti.com>
In-Reply-To: <5e9665e10901282344v38999d5bvdc5530dd4151f869@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: DongSoo Kim [mailto:dongsoo.kim@gmail.com]
> Sent: Thursday, January 29, 2009 1:14 PM
> To: Shah, Hardik
> Cc: linux-media@vger.kernel.org; video4linux-list@redhat.com
> Subject: Re: [PATCHv2] New V4L2 ioctls for OMAP class of Devices
> 
> Hello.
> 
> > +#define VIDIOC_S_COLOR_SPACE_CONV      _IOW('V', 83, struct
> v4l2_color_space_conversion)
> > +#define VIDIOC_G_COLOR_SPACE_CONV      _IOR('V', 84, struct
> v4l2_color_space_conversion)
> 
> Do you mind if I ask a question about those ioctls?
> Because as far as I understand, we can use VIDIOC_S_FMT ioctl to convert
> colorspaces. Setting through colorspace member in v4l2_pix_format, we
> could change output colorspace.
> If there is some different use, can you tell me what it is?
> 
[Shah, Hardik] OMAP Display sub-system supports various pixel formats as inputs like YUV, UYVY, RGB24, RGB16 but the compositors which take these input format and displays on to the output devices like TV, LCD can only understand RGB format.  Hardware has provision for converting any data taken in YUV or UYVY format to be converted into the RGB formats, before giving it to the output devices.  To convert this hardware needs to be programmed with correct coefficient and offsets to convert from YUV to RGB.  These coefficients are pretty standard but still some one may require altering it. For this new ioctl is added.  Standard equation for converting from YUV or UYVY is 

| R |		| RY RCr RCb |   | Y - 16   |
| G | = 1/K | Gy GCr Gcb | * | Cr - 128 |
| B |		| By BCr BCb |   | Cb - 128 |

Where Ry, Rcr, Rcb Gy, Gcr, Gcb, By, Bcr and Bcb are the programmable coefficients.  But in future offsets like Y-16, Cr-128 or Cb-128 or constant like 1/K may also be programmable.  So I have added this new ioctl.

Regards,
Hardik Shah


> Regards,
> Nate
> 
> --
> ========================================================
> Dong Soo, Kim
> Engineer
> Mobile S/W Platform Lab. S/W centre
> Telecommunication R&D Centre
> Samsung Electronics CO., LTD.
> e-mail : dongsoo.kim@gmail.com
>            dongsoo45.kim@samsung.com
> ========================================================

