Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:43908 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab0G3Onf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 10:43:35 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Pawel Osciak <p.osciak@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
	"t.fujak@samsung.com" <t.fujak@samsung.com>
Date: Fri, 30 Jul 2010 09:43:28 -0500
Subject: RE: [PATCH v5 0/3] Multi-planar video format and buffer support for
 the V4L2 API
Message-ID: <A69FA2915331DC488A831521EAE36FE4016B9622E1@dlee06.ent.ti.com>
References: <1280479783-23945-1-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1280479783-23945-1-git-send-email-p.osciak@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<Snip>

>
> struct v4l2_format {
>        enum v4l2_buf_type type;
>        union {
>                struct v4l2_pix_format          pix;     /*
>V4L2_BUF_TYPE_VIDEO_CAPTURE */
>+               struct v4l2_pix_format_mplane   pix_mp;  /*
>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
>                struct v4l2_window              win;     /*
>V4L2_BUF_TYPE_VIDEO_OVERLAY */
>                struct v4l2_vbi_format          vbi;     /*
>V4L2_BUF_TYPE_VBI_CAPTURE */
>                struct v4l2_sliced_vbi_format   sliced;  /*
>V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
>                __u8    raw_data[200];                   /* user-defined */
>        } fmt;
> };
>
>For the new buffer types mp_pix member is chosen. For those buffer types,
>struct v4l2_pix_format_mplane is used:
>

Typo. replae mp_pix with pix_mp

>/**
> * struct v4l2_pix_format_mplane - multiplanar format definition
> * @width:              image width in pixels
> * @height:             image height in pixels
> * @pixelformat:        little endian four character code (fourcc)
> * @field:              field order (for interlaced video)
> * @colorspace:         supplemental to pixelformat
> * @plane_fmt:          per-plane information
> * @num_planes:         number of planes for this format and number of
>valid

<Snip>

>
>
>7. Format conversion
>----------------------------------
>v4l2 core ioctl handling includes a simple conversion layer that allows
>translation - when possible - between multi-planar and single-planar APIs,
>transparently to drivers and applications.
>
>The table below summarizes conversion behavior for cases when driver and
>application use different API versions:
>
>---------------------------------------------------------------
>              | Application MP --> Driver SP --> Application MP
>   G_FMT      |            always OK   |   always OK
>   S_FMT      |            -EINVAL     |   always OK
> TRY_FMT      |            -EINVAL     |   always OK
>---------------------------------------------------------------
>              | Application SP --> Driver MP --> Application SP
>   G_FMT      |            always OK   |   -EBUSY
>   S_FMT      |            always OK   |   -EBUSY and WARN()
> TRY_FMT      |            always OK   |   -EBUSY and WARN()
>

What is the logic behind using -EBUSY for this? Why not -EINVAL? Also why use WARN()?

>Legend:
>- SP - single-planar API used (NOT format!)
>- MP - multi-planar API used (NOT format!)
>- always OK - conversion is always valid irrespective of number of planes
>- -EINVAL - if an MP application tries to TRY or SET a format with more
>            than 1 plane, EINVAL is returned from the conversion function
>            (of course, 1-plane multi-planar formats work and are
>converted)
>- -EBUSY - if an MP driver returns a more than 1-plane format to an SP
>           application, the conversion layer returns EBUSY to the
>application;
>           this is useful in cases when the driver is currently set to a
>more
>           than 1-plane format, SP application would not be able to
>understand
>           it)
>- -EBUSY and WARN() - there is only one reason for which SET or TRY from an
>SP
>           application would result in a driver returning a more than 1-
>plane
>           format - when the driver adjusts a 1-plane format to a more than
>           1-plane format. This should not happen and is a bug in driver,
>hence
>           a WARN_ON(). Application receives EBUSY.
>
>

Suppose, S_FMT/TRY_FMT is called with UYVY format and driver supports only NV12 (2 plane) only, then for

Application SP --> Driver MP --> Application SP

I guess in this case, new drivers that supports multi-plane format would have to return old NV12 format code (for backward compatibility). Is
this handled by driver or translation layer? 

Application MP --> Driver SP --> Application MP

In this case, new driver would return new NV12 format code and have no issue.
Not sure what translation layer does in this scenario.

<snip>

>
>===============================================
>V. Using ioctl()s and mmap()
>===============================================
>
>* Format calls (VIDIOC_S/TRY/G_FMT) are converted transparently across APIs
>  by the ioctl handling code, where possible. Conversion from single-planar
>  to multi-planar cannot fail, but the other way around is possible only
>for
>  1-plane formats.
>  Possible errors in conversion are described below.
>

Could you explain what you mean by conversion of formats? The idea of the translation layer functionality is not clear to me. An example would help.


Murali

