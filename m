Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:59066 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526AbbCWPDd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2015 11:03:33 -0400
Message-ID: <55102B3A.3060702@xs4all.nl>
Date: Mon, 23 Mar 2015 08:03:22 -0700
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC] Extend struct v4l2_fmtdesc to give more format info
References: <550C1FE5.2050300@xs4all.nl> <20150322155611.GO16613@valkosipuli.retiisi.org.uk>
In-Reply-To: <20150322155611.GO16613@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/22/2015 08:56 AM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Fri, Mar 20, 2015 at 02:25:57PM +0100, Hans Verkuil wrote:
>> This is a proposal to extend the information returned by v4l2_fmtdesc (VIDIOC_ENUM_FMT).
>>
>> Especially in combination with my previous RFC PATCH (https://patchwork.linuxtv.org/patch/28877/)
>> this is very easy to fill in correctly in the core, and it will help both drivers and
>> applications.
>>
>> It is very common that you need to know whether the format is for rgb, greyscale or YUV,
>> whether a format is only supported with the multiplanar API or not (useful for the
>> libv4l-mplane plugin to avoid enumerating multiplanar formats), whether there is an
>> alpha channel, what the chroma subsampling format is and how planar formats are organized.
>>
>>
>> struct v4l2_fmtdesc {
>>         __u32               index;              /* Format number      */
>>         __u32               type;               /* enum v4l2_buf_type */
>>         __u32               flags;
>>         __u8                description[32];    /* Description string */
>>         __u32               pixelformat;        /* Format fourcc      */
>>         __u8                color_encoding;     /* Color encoding     */
>>         __u8                chroma_subsampling; /* Chroma subsampling */
>>         __u8                planar;      	/* Planar format organization */
>>         __u8                reserved2;
>>         __u32               reserved[3];
>> };
>>
>> #define V4L2_FMT_FLAG_COMPRESSED 0x0001
>> #define V4L2_FMT_FLAG_EMULATED   0x0002
>> #define V4L2_FMT_FLAG_IS_MPLANE  0x0004
>> #define V4L2_FMT_FLAG_HAS_ALPHA  0x0008
>>
>> #define V4L2_FMT_COLOR_ENC_UNKNOWN      0
>> #define V4L2_FMT_COLOR_ENC_RGB          1
>> #define V4L2_FMT_COLOR_ENC_GREY         2
>> #define V4L2_FMT_COLOR_ENC_YCBCR        3
>>
>> #define V4L2_FMT_CHROMA_UNKNOWN         0
>> #define V4L2_FMT_CHROMA_4_4_4           1
>> #define V4L2_FMT_CHROMA_4_2_2           2
>> #define V4L2_FMT_CHROMA_4_2_0           3
>> #define V4L2_FMT_CHROMA_4_1_1           4
>> #define V4L2_FMT_CHROMA_4_1_0           5
>>
>> #define V4L2_FMT_PLANAR_UNKNOWN      	0
>> #define V4L2_FMT_PLANAR_NONE     	1	/* not a planar format */
>> #define V4L2_FMT_PLANAR_Y_CBCR          2	/* one luma, one packed chroma plane */
>> #define V4L2_FMT_PLANAR_Y_CB_CR         3	/* one luma and two chroma planes  */
>>
>> For compressed formats color_encoding, chroma_subsampling and planar are all
>> set to 0.
>>
>> Using this information helps both drivers and applications to calculate the
>> bytesperline values and offsets of each plane for formats like PIX_FMT_YUV420.
>>
>> I've worked with this in vivid and in qv4l2, and it is a real pain without
>> this information. Every driver and app needs to do the same calculations.
>>
>> It's trivial to add support for this in the v4l2 core.
> 
> How much of this is defined by the 4cc code already? Everything?

Yes, everything.

> This is an interesting case. The information would likely be needed by both
> applications and drivers but in the kernel API itself it's redundant, isn't
> it?

Not really. Most drivers (at least those that have some of the more complex
formats) encode this information in their own tables (usually in some sort of
a bit-depth field and whether a format is rgb or yuv). By moving this info to
the core you can simplify drivers by just asking the core for that info. It also
makes it possible to add helper functions to calculate things like the sizeimage
value, which is non-trivial in the case of the planar formats.

>> I am also considering adding a bits_per_pixel field. It is likely useful
>> as an internal kernel helper function, but whether it helps applications
>> is something I don't really know.
> 
> I think this would be nice to have. But like the others, I wonder if the
> kernel API is the right place for this.
> 
> Do you have concrete examples (excluding the vivi driver) where drivers
> would benefit from this in other than a trivial manner? I can imagine the
> user space would though.

Take a look at drivers/media/platform/coda/coda-common.c for example (just the
first that popped up in my search, I know there are others). A function like
coda_try_fmt can certainly be simplified.

Basically all this is meta information about a fourcc. Every driver and application
that uses such a fourcc has to duplicate that information today, which is a waste.

If we fill in the fmtdesc in the core anyway, then why not add this info? It's
trivial.

Regards,

	Hans
