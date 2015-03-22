Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50310 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751704AbbCVP4P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 11:56:15 -0400
Date: Sun, 22 Mar 2015 17:56:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC] Extend struct v4l2_fmtdesc to give more format info
Message-ID: <20150322155611.GO16613@valkosipuli.retiisi.org.uk>
References: <550C1FE5.2050300@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <550C1FE5.2050300@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Mar 20, 2015 at 02:25:57PM +0100, Hans Verkuil wrote:
> This is a proposal to extend the information returned by v4l2_fmtdesc (VIDIOC_ENUM_FMT).
> 
> Especially in combination with my previous RFC PATCH (https://patchwork.linuxtv.org/patch/28877/)
> this is very easy to fill in correctly in the core, and it will help both drivers and
> applications.
> 
> It is very common that you need to know whether the format is for rgb, greyscale or YUV,
> whether a format is only supported with the multiplanar API or not (useful for the
> libv4l-mplane plugin to avoid enumerating multiplanar formats), whether there is an
> alpha channel, what the chroma subsampling format is and how planar formats are organized.
> 
> 
> struct v4l2_fmtdesc {
>         __u32               index;              /* Format number      */
>         __u32               type;               /* enum v4l2_buf_type */
>         __u32               flags;
>         __u8                description[32];    /* Description string */
>         __u32               pixelformat;        /* Format fourcc      */
>         __u8                color_encoding;     /* Color encoding     */
>         __u8                chroma_subsampling; /* Chroma subsampling */
>         __u8                planar;      	/* Planar format organization */
>         __u8                reserved2;
>         __u32               reserved[3];
> };
> 
> #define V4L2_FMT_FLAG_COMPRESSED 0x0001
> #define V4L2_FMT_FLAG_EMULATED   0x0002
> #define V4L2_FMT_FLAG_IS_MPLANE  0x0004
> #define V4L2_FMT_FLAG_HAS_ALPHA  0x0008
> 
> #define V4L2_FMT_COLOR_ENC_UNKNOWN      0
> #define V4L2_FMT_COLOR_ENC_RGB          1
> #define V4L2_FMT_COLOR_ENC_GREY         2
> #define V4L2_FMT_COLOR_ENC_YCBCR        3
> 
> #define V4L2_FMT_CHROMA_UNKNOWN         0
> #define V4L2_FMT_CHROMA_4_4_4           1
> #define V4L2_FMT_CHROMA_4_2_2           2
> #define V4L2_FMT_CHROMA_4_2_0           3
> #define V4L2_FMT_CHROMA_4_1_1           4
> #define V4L2_FMT_CHROMA_4_1_0           5
> 
> #define V4L2_FMT_PLANAR_UNKNOWN      	0
> #define V4L2_FMT_PLANAR_NONE     	1	/* not a planar format */
> #define V4L2_FMT_PLANAR_Y_CBCR          2	/* one luma, one packed chroma plane */
> #define V4L2_FMT_PLANAR_Y_CB_CR         3	/* one luma and two chroma planes  */
> 
> For compressed formats color_encoding, chroma_subsampling and planar are all
> set to 0.
> 
> Using this information helps both drivers and applications to calculate the
> bytesperline values and offsets of each plane for formats like PIX_FMT_YUV420.
> 
> I've worked with this in vivid and in qv4l2, and it is a real pain without
> this information. Every driver and app needs to do the same calculations.
> 
> It's trivial to add support for this in the v4l2 core.

How much of this is defined by the 4cc code already? Everything?

This is an interesting case. The information would likely be needed by both
applications and drivers but in the kernel API itself it's redundant, isn't
it?

> I am also considering adding a bits_per_pixel field. It is likely useful
> as an internal kernel helper function, but whether it helps applications
> is something I don't really know.

I think this would be nice to have. But like the others, I wonder if the
kernel API is the right place for this.

Do you have concrete examples (excluding the vivi driver) where drivers
would benefit from this in other than a trivial manner? I can imagine the
user space would though.

Just my 5 euro cents.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
