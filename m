Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40681 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbbCTN0D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 09:26:03 -0400
Received: from [10.61.175.37] (unknown [173.38.220.60])
	by tschai.lan (Postfix) with ESMTPSA id 72AB02A009F
	for <linux-media@vger.kernel.org>; Fri, 20 Mar 2015 14:25:51 +0100 (CET)
Message-ID: <550C1FE5.2050300@xs4all.nl>
Date: Fri, 20 Mar 2015 14:25:57 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [RFC] Extend struct v4l2_fmtdesc to give more format info
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a proposal to extend the information returned by v4l2_fmtdesc (VIDIOC_ENUM_FMT).

Especially in combination with my previous RFC PATCH (https://patchwork.linuxtv.org/patch/28877/)
this is very easy to fill in correctly in the core, and it will help both drivers and
applications.

It is very common that you need to know whether the format is for rgb, greyscale or YUV,
whether a format is only supported with the multiplanar API or not (useful for the
libv4l-mplane plugin to avoid enumerating multiplanar formats), whether there is an
alpha channel, what the chroma subsampling format is and how planar formats are organized.


struct v4l2_fmtdesc {
        __u32               index;              /* Format number      */
        __u32               type;               /* enum v4l2_buf_type */
        __u32               flags;
        __u8                description[32];    /* Description string */
        __u32               pixelformat;        /* Format fourcc      */
        __u8                color_encoding;     /* Color encoding     */
        __u8                chroma_subsampling; /* Chroma subsampling */
        __u8                planar;      	/* Planar format organization */
        __u8                reserved2;
        __u32               reserved[3];
};

#define V4L2_FMT_FLAG_COMPRESSED 0x0001
#define V4L2_FMT_FLAG_EMULATED   0x0002
#define V4L2_FMT_FLAG_IS_MPLANE  0x0004
#define V4L2_FMT_FLAG_HAS_ALPHA  0x0008

#define V4L2_FMT_COLOR_ENC_UNKNOWN      0
#define V4L2_FMT_COLOR_ENC_RGB          1
#define V4L2_FMT_COLOR_ENC_GREY         2
#define V4L2_FMT_COLOR_ENC_YCBCR        3

#define V4L2_FMT_CHROMA_UNKNOWN         0
#define V4L2_FMT_CHROMA_4_4_4           1
#define V4L2_FMT_CHROMA_4_2_2           2
#define V4L2_FMT_CHROMA_4_2_0           3
#define V4L2_FMT_CHROMA_4_1_1           4
#define V4L2_FMT_CHROMA_4_1_0           5

#define V4L2_FMT_PLANAR_UNKNOWN      	0
#define V4L2_FMT_PLANAR_NONE     	1	/* not a planar format */
#define V4L2_FMT_PLANAR_Y_CBCR          2	/* one luma, one packed chroma plane */
#define V4L2_FMT_PLANAR_Y_CB_CR         3	/* one luma and two chroma planes  */

For compressed formats color_encoding, chroma_subsampling and planar are all
set to 0.

Using this information helps both drivers and applications to calculate the
bytesperline values and offsets of each plane for formats like PIX_FMT_YUV420.

I've worked with this in vivid and in qv4l2, and it is a real pain without
this information. Every driver and app needs to do the same calculations.

It's trivial to add support for this in the v4l2 core.

I am also considering adding a bits_per_pixel field. It is likely useful
as an internal kernel helper function, but whether it helps applications
is something I don't really know.

Feedback is welcome!

	Hans
