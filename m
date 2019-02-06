Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0746C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 16:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 932F720811
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 16:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730871AbfBFQgk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 11:36:40 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:46215 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730678AbfBFQgj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Feb 2019 11:36:39 -0500
Received: from [IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5] ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud9.xs4all.net with ESMTPA
        id rQBdgBn7CRO5ZrQBegpIf0; Wed, 06 Feb 2019 17:36:36 +0100
Subject: Re: [PATCH 01/10] media: Introduce helpers to fill pixel format
 structs
To:     Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>
References: <20190205202417.16555-1-ezequiel@collabora.com>
 <20190205202417.16555-2-ezequiel@collabora.com>
 <79ad7cf7-90d5-9542-06ea-e28ddeb14e94@xs4all.nl>
 <85ff24016b4d4b55a1a02f1aee6b42dbbaf2279a.camel@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d1ea8698-e4c6-a826-0820-b8395c8c2a6f@xs4all.nl>
Date:   Wed, 6 Feb 2019 17:36:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <85ff24016b4d4b55a1a02f1aee6b42dbbaf2279a.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKMUxHQWTvU5qxG9TLwP7a2cBpT86mLTLxbPGNY6lDSIUoYFzvove9eBogXhOlno9WtfYrhTlVZx2YSa4++sNLWi0he+A3Uh243KCszDWP7HlBs3hVjx
 4Gv46QaWsMOhV7vr57Ij5bpewNU9CE0ppoZ8H1uQA/3g5MVK22ffdbe2NZlT/Z4w9U0gdPI84abEdihUmS+FaiENZg6HME3Tf/TYqEI7niBZPVZWKimWmu8y
 j92tNeKtnxuo/tSMuE6soKR0Kuc+gE6NoaVCYAcgcMZcCEEh+2qY8d6PLxKPAX0FdMnACPnFsUk7QaQS0dqfvb1MFX4Q6rOPGz8gULj8WOxKAbKjB7giIiY1
 bEq+21/pOrWR7Sa/NLjPgLcZoLUogSGoKqQbPBklK92mICiD06N5bFHMHB2625sKk5xiDNC/pMyS7NfiZm9CTnul2iFHIlrjtfoL3nXlVuKgA4hTmdyTpWIL
 Cs7DL3BdFUwXrzF3LPBgyreP97Bfvi2hCB0PncQ8K4t4qn9YmCIr6Pw0bfpQ6ibN125s8YA2oF0FP7Lf6ajQXwRHwMhbK66tFR+6yUW1SSJ1ryRrnDRYsT8P
 b1Q=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/6/19 5:22 PM, Ezequiel Garcia wrote:
> On Wed, 2019-02-06 at 11:43 +0100, Hans Verkuil wrote:
>> Hi Ezequiel,
>>
>> A quick review below. This looks really useful, BTW.
>>
>> On 2/5/19 9:24 PM, Ezequiel Garcia wrote:
>>> Add two new API helpers, v4l2_fill_pixfmt and v4l2_fill_pixfmt_mp,
>>> to be used by drivers to calculate plane sizes and bytes per lines.
>>>
>>> Note that driver-specific paddig and alignment are not
>>
>> paddig -> padding
>>
>>> taken into account, and must be done by drivers using this API.
>>>
>>> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
>>> ---
>>>  drivers/media/v4l2-core/Makefile      |   2 +-
>>>  drivers/media/v4l2-core/v4l2-common.c |  71 +++++++++++++++++
>>>  drivers/media/v4l2-core/v4l2-fourcc.c | 109 ++++++++++++++++++++++++++
>>>  include/media/v4l2-common.h           |   5 ++
>>>  include/media/v4l2-fourcc.h           |  53 +++++++++++++
>>>  5 files changed, 239 insertions(+), 1 deletion(-)
>>>  create mode 100644 drivers/media/v4l2-core/v4l2-fourcc.c
>>>  create mode 100644 include/media/v4l2-fourcc.h
>>>
>>> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
>>> index 9ee57e1efefe..bc23c3407c17 100644
>>> --- a/drivers/media/v4l2-core/Makefile
>>> +++ b/drivers/media/v4l2-core/Makefile
>>> @@ -7,7 +7,7 @@ tuner-objs	:=	tuner-core.o
>>>  
>>>  videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
>>>  			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o \
>>> -			v4l2-async.o
>>> +			v4l2-async.o v4l2-fourcc.o
>>>  ifeq ($(CONFIG_COMPAT),y)
>>>    videodev-objs += v4l2-compat-ioctl32.o
>>>  endif
>>> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
>>> index 50763fb42a1b..39d86a389cae 100644
>>> --- a/drivers/media/v4l2-core/v4l2-common.c
>>> +++ b/drivers/media/v4l2-core/v4l2-common.c
>>> @@ -61,6 +61,7 @@
>>>  #include <media/v4l2-common.h>
>>>  #include <media/v4l2-device.h>
>>>  #include <media/v4l2-ctrls.h>
>>> +#include <media/v4l2-fourcc.h>
>>
>> Either create a v4l2-fourcc.c source using this header, or move the
>> contents of v4l2-fourcc.h to v4l2-common.h.
>>
>> Creating a new header but not a new source is a bit weird.
>>
> 
> This patch adds v4l2-fourcc.c and v4l2-fourcc.h, containing
> only the pixel format array and the fourcc name helper.

Ah, I now see that I got confused because some functions were added to v4l2-fourcc.c
and others to v4l2-common.c.

I still stand by my comment: either everything goes to v4l2-common, or to
v4l2-fourcc. But it makes no sense IMHO to split it over two sources.

> 
>>>  
>>>  #include <linux/videodev2.h>
>>>  
>>> @@ -455,3 +456,73 @@ int v4l2_s_parm_cap(struct video_device *vdev,
>>>  	return ret;
>>>  }
>>>  EXPORT_SYMBOL_GPL(v4l2_s_parm_cap);
>>> +
>>> +void v4l2_fill_pixfmt_mp(struct v4l2_pix_format_mplane *pixfmt,
>>> +			 int pixelformat, int width, int height)
>>> +{
>>> +	const struct v4l2_format_info *info;
>>> +	struct v4l2_plane_pix_format *plane;
>>> +	int i;
>>> +
>>> +	info = v4l2_format_info(pixelformat);
>>> +	if (!info)
>>> +		return;
>>
>> You should return a bool or something to indicate whether or not
>> the pixelformat was known.
>>
> 
> Got it.
> 
>>> +
>>> +	pixfmt->width = width;
>>> +	pixfmt->height = height;
>>> +	pixfmt->pixelformat = pixelformat;
>>> +
>>> +	if (!info->multiplanar) {
>>
>> It would make much more sense if multiplanar contained the number of
>> planes to use (i.e. equal to pixfmt->num_planes).
>>
>> See more about this below.
>>
>>> +		pixfmt->num_planes = 1;
>>> +		plane = &pixfmt->plane_fmt[0];
>>> +		plane->bytesperline = width * info->cpp[0];
>>> +		plane->sizeimage = 0;
>>> +		for (i = 0; i < info->num_planes; i++) {
>>> +			unsigned int hsub = (i == 0) ? 1 : info->hsub;
>>> +			unsigned int vsub = (i == 0) ? 1 : info->vsub;
>>> +
>>> +			plane->sizeimage += info->cpp[i] *
>>> +				DIV_ROUND_UP(width, hsub) *
>>> +				DIV_ROUND_UP(height, vsub);
>>> +		}
>>> +	} else {
>>> +		pixfmt->num_planes = info->num_planes;
>>> +		for (i = 0; i < info->num_planes; i++) {
>>> +			unsigned int hsub = (i == 0) ? 1 : info->hsub;
>>> +			unsigned int vsub = (i == 0) ? 1 : info->vsub;
>>> +
>>> +			plane = &pixfmt->plane_fmt[i];
>>> +			plane->bytesperline =
>>> +				info->cpp[i] * DIV_ROUND_UP(width, hsub);
>>> +			plane->sizeimage =
>>> +				plane->bytesperline * DIV_ROUND_UP(height, vsub);
>>> +		}
>>> +	}
>>> +}
>>> +EXPORT_SYMBOL_GPL(v4l2_fill_pixfmt_mp);
>>> +
>>> +void v4l2_fill_pixfmt(struct v4l2_pix_format *pixfmt, int pixelformat, int width, int height)
>>> +{
>>> +	const struct v4l2_format_info *info;
>>> +	int i;
>>> +
>>> +	info = v4l2_format_info(pixelformat);
>>> +	if (!info)
>>> +		return;
>>
>> You have to check if pixelformat was a multiplanar format and reject it.
>>
> 
> OK.
> 
>>> +
>>> +	pixfmt->width = width;
>>> +	pixfmt->height = height;
>>> +	pixfmt->pixelformat = pixelformat;
>>> +	pixfmt->bytesperline = width * info->cpp[0];
>>> +	pixfmt->sizeimage = 0;
>>> +
>>> +	for (i = 0; i < info->num_planes; i++) {
>>> +		unsigned int hsub = (i == 0) ? 1 : info->hsub;
>>> +		unsigned int vsub = (i == 0) ? 1 : info->vsub;
>>> +
>>> +		pixfmt->sizeimage += info->cpp[i] *
>>> +			DIV_ROUND_UP(width, hsub) *
>>> +			DIV_ROUND_UP(height, vsub);
>>> +	}
>>> +}
>>> +EXPORT_SYMBOL_GPL(v4l2_fill_pixfmt);
>>> diff --git a/drivers/media/v4l2-core/v4l2-fourcc.c b/drivers/media/v4l2-core/v4l2-fourcc.c
>>> new file mode 100644
>>> index 000000000000..982c0ffa1a66
>>> --- /dev/null
>>> +++ b/drivers/media/v4l2-core/v4l2-fourcc.c
>>> @@ -0,0 +1,109 @@
>>> +/*
>>> + * Copyright (c) 2018 Collabora, Ltd.
>>> + *
>>> + * Based on drm-fourcc:
>>> + * Copyright (c) 2016 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> + *
>>> + * Permission to use, copy, modify, distribute, and sell this software and its
>>> + * documentation for any purpose is hereby granted without fee, provided that
>>> + * the above copyright notice appear in all copies and that both that copyright
>>> + * notice and this permission notice appear in supporting documentation, and
>>> + * that the name of the copyright holders not be used in advertising or
>>> + * publicity pertaining to distribution of the software without specific,
>>> + * written prior permission.  The copyright holders make no representations
>>> + * about the suitability of this software for any purpose.  It is provided "as
>>> + * is" without express or implied warranty.
>>> + *
>>> + * THE COPYRIGHT HOLDERS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
>>> + * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO
>>> + * EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY SPECIAL, INDIRECT OR
>>> + * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
>>> + * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
>>> + * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
>>> + * OF THIS SOFTWARE.
>>> + */
>>> +
>>> +#include <linux/ctype.h>
>>> +#include <linux/videodev2.h>
>>> +#include <media/v4l2-fourcc.h>
>>> +
>>> +static char printable_char(int c)
>>> +{
>>> +	return isascii(c) && isprint(c) ? c : '?';
>>> +}
>>> +
>>> +const char *v4l2_get_format_name(uint32_t format)
>>
>> This should be called v4l2_get_fourcc_name. The format name is what ENUMFMT returns.
>>
> 
> Got it.
> 
>>> +{
>>> +	static char buf[4];
>>> +
>>> +	snprintf(buf, 4,
>>> +		 "%c%c%c%c",
>>> +		 printable_char(format & 0xff),
>>> +		 printable_char((format >> 8) & 0xff),
>>> +		 printable_char((format >> 16) & 0xff),
>>> +		 printable_char((format >> 24) & 0x7f));
>>
>> If bit 31 is set, then add a '-BE' suffix to indicate that this is a
>> big endian variant of the same pixelformat with bit 31 set to 0.
>>
>> See also v4l_fill_fmtdesc() in v4l2-ioctl.c.
>>
> 
> I omitted endianness and alpha because they weren't used
> by V4L2, but let me add them to make the code generic
> and support out-of-tree stuff.
> 
>>> +
>>> +	return buf;
>>> +}
>>> +EXPORT_SYMBOL(v4l2_get_format_name);
>>
>> I remember that Sakari tried to make a macro for this in a public header, but
>> it was either rejected or fizzled out:
>>
>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg128702.html
>>
> 
> I see. This time we are adding the fourcc name helper to the private API,
> which shouldn't cause too much debate. Adding Sakari to the loop.
> 
>>> +
>>> +const struct v4l2_format_info *v4l2_format_info(u32 format)
>>> +{
>>> +	static const struct v4l2_format_info formats[] = {
>>> +		/* RGB formats */
>>> +		{ .format = V4L2_PIX_FMT_BGR24,		.num_planes = 1, .cpp = { 3, 0, 0 }, .hsub = 1, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_RGB24,		.num_planes = 1, .cpp = { 3, 0, 0 }, .hsub = 1, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_HSV24,		.num_planes = 1, .cpp = { 3, 0, 0 }, .hsub = 1, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_BGR32,		.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_XBGR32,	.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_RGB32,		.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_XRGB32,	.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_HSV32,		.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_ARGB32,	.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_ABGR32,	.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_GREY,		.num_planes = 1, .cpp = { 1, 0, 0 }, .hsub = 1, .vsub = 1 },
>>> +
>>> +		/* YUV formats */
>>> +		{ .format = V4L2_PIX_FMT_YUYV,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_YVYU,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_UYVY,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_VYUY,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
>>> +
>>> +		{ .format = V4L2_PIX_FMT_NV12,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2 },
>>> +		{ .format = V4L2_PIX_FMT_NV21,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2 },
>>> +		{ .format = V4L2_PIX_FMT_NV16,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_NV61,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_NV24,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 1, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_NV42,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 1, .vsub = 1 },
>>> +
>>> +		{ .format = V4L2_PIX_FMT_YUV410,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 4, .vsub = 4 },
>>> +		{ .format = V4L2_PIX_FMT_YVU410,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 4, .vsub = 4 },
>>> +		{ .format = V4L2_PIX_FMT_YUV411P,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 4, .vsub = 1 },
>>> +		{ .format = V4L2_PIX_FMT_YUV420,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2 },
>>> +		{ .format = V4L2_PIX_FMT_YVU420,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2 },
>>> +		{ .format = V4L2_PIX_FMT_YUV422P,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 1 },
>>> +
>>> +		{ .format = V4L2_PIX_FMT_YUV420M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2, .multiplanar = 1 },
>>> +		{ .format = V4L2_PIX_FMT_YVU420M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2, .multiplanar = 1 },
>>> +		{ .format = V4L2_PIX_FMT_YUV422M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 1, .multiplanar = 1 },
>>> +		{ .format = V4L2_PIX_FMT_YVU422M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 1, .multiplanar = 1 },
>>> +		{ .format = V4L2_PIX_FMT_YUV444M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 1, .vsub = 1, .multiplanar = 1 },
>>> +		{ .format = V4L2_PIX_FMT_YVU444M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 1, .vsub = 1, .multiplanar = 1 },
>>> +
>>> +		{ .format = V4L2_PIX_FMT_NV12M,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2, .multiplanar = 1 },
>>> +		{ .format = V4L2_PIX_FMT_NV21M,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2, .multiplanar = 1 },
>>> +		{ .format = V4L2_PIX_FMT_NV16M,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 1, .multiplanar = 1 },
>>> +		{ .format = V4L2_PIX_FMT_NV61M,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 1, .multiplanar = 1 },
>>> +
>>> +	};
>>> +	unsigned int i;
>>> +
>>> +	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
>>> +		if (formats[i].format == format)
>>> +			return &formats[i];
>>> +	}
>>
>> No need for {}
>>
> 
> OK
> 
>>> +
>>> +	pr_warn("Unsupported V4L 4CC format %s (%08x)\n", v4l2_get_format_name(format), format);
>>
>> Make this a pr_dev or remove it altogether. I prefer the latter.
>>
> 
> Right. If the function returns an error condition, we can drop it.
> 
>>> +	return NULL;
>>> +}
>>> +EXPORT_SYMBOL(v4l2_format_info);
>>> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
>>> index 0c511ed8ffb0..6461ce747d90 100644
>>> --- a/include/media/v4l2-common.h
>>> +++ b/include/media/v4l2-common.h
>>> @@ -327,6 +327,11 @@ void v4l_bound_align_image(unsigned int *width, unsigned int wmin,
>>>  			   unsigned int hmax, unsigned int halign,
>>>  			   unsigned int salign);
>>>  
>>> +void v4l2_fill_pixfmt(struct v4l2_pix_format *pixfmt, int pixelformat,
>>> +		      int width, int height);
>>> +void v4l2_fill_pixfmt_mp(struct v4l2_pix_format_mplane *pixfmt, int pixelformat,
>>> +			 int width, int height);
>>> +
>>>  /**
>>>   * v4l2_find_nearest_size - Find the nearest size among a discrete
>>>   *	set of resolutions contained in an array of a driver specific struct.
>>> diff --git a/include/media/v4l2-fourcc.h b/include/media/v4l2-fourcc.h
>>> new file mode 100644
>>> index 000000000000..3d24f442aaf5
>>> --- /dev/null
>>> +++ b/include/media/v4l2-fourcc.h
>>> @@ -0,0 +1,53 @@
>>> +/*
>>> + * Copyright (c) 2018 Collabora, Ltd.
>>> + *
>>> + * Based on drm-fourcc:
>>> + * Copyright (c) 2016 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> + *
>>> + * Permission to use, copy, modify, distribute, and sell this software and its
>>> + * documentation for any purpose is hereby granted without fee, provided that
>>> + * the above copyright notice appear in all copies and that both that copyright
>>> + * notice and this permission notice appear in supporting documentation, and
>>> + * that the name of the copyright holders not be used in advertising or
>>> + * publicity pertaining to distribution of the software without specific,
>>> + * written prior permission.  The copyright holders make no representations
>>> + * about the suitability of this software for any purpose.  It is provided "as
>>> + * is" without express or implied warranty.
>>> + *
>>> + * THE COPYRIGHT HOLDERS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
>>> + * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO
>>> + * EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY SPECIAL, INDIRECT OR
>>> + * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
>>> + * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
>>> + * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
>>> + * OF THIS SOFTWARE.
>>
>> Should be an SPDX ID.
>>
>>> + */
>>> +#ifndef __V4L2_FOURCC_H__
>>> +#define __V4L2_FOURCC_H__
>>> +
>>> +#include <linux/types.h>
>>> +
>>> +/**
>>> + * struct v4l2_format_info - information about a V4L2 format
>>> + * @format: 4CC format identifier (V4L2_PIX_FMT_*)
>>> + * @header_size: Size of header, optional and used by compressed formats
>>> + * @num_planes: Number of planes (1 to 3)
>>
>> This is actually 1-4 since there may be an alpha channel as well. Not that we have
>> such formats since the only formats with an alpha channel are interleaved formats,
>> but it is possible.
>>
>> So this value is 2 for both NV12 and NV12M.
>>
>>> + * @cpp: Number of bytes per pixel (per plane)
>>
>> cpp? Shouldn't that be bpp?
>>
>> Note that this can differ per plane (see e.g. NV24).
>>
> 
> Yes, the comment should specify that it's an array of bytes per pixel.
> 
> And the naming follows drm-fourcc. cpp stands for char-per-pixel.
> It may be confusing but at the same time, I really like to have
> consistent naming across the board (think for instance in
> the DMA coherent/consistent aliases).

We never use cpp in the media subsystem, it's always bpp. Please keep
that name.

And the v4l2 fourccs are unrelated to the drm fourccs. Historically
they developed along separate paths and I actually think it can be
confusing to suggest that they are related.

Now whether there should be an effort to unify the two is an entirely
different question.

> 
> Also, note that drm-fourcc deprecates cpp, to support tile formats.
> Hopefully we don't need that here?

We do have tile formats (V4L2_PIX_FMT_NV12MT_16X16), but it is up to the
driver to align width/height accordingly.

>  
>>> + * @hsub: Horizontal chroma subsampling factor
>>> + * @vsub: Vertical chroma subsampling factor
>>
>> A bit too cryptic IMHO. I would prefer hdiv or hsubsampling. 'hsub' suggests
>> subtraction :-)
>>
> 
> Ditto, this name follows drm-fourcc. I'm fine either way.
> 
>>> + * @multiplanar: Is it a multiplanar variant format? (e.g. NV12M)
>>
>> This should, I think, be renamed to num_non_contig_planes to indicate how many
>> non-contiguous planes there are in the format.
>>
>> So this value is 1 for NV12 and 2 for NV12M. For V4L2_PIX_FMT_YUV444M it is 3.
>>
>> You can stick this value directly into pixfmt_mp->num_planes.
>>
> 
> Fine by me, but I have to admit I don't see the value of adding the
> number of non-contiguous planes. For multiplanar non-contiguous formats
> the number of planes is equal to the number of planes.

Hmm, that's true. Choose whatever gives you the shortest code :-)

> 
> Although maybe it will be clear this way for readers?
> 
>> As an aside: perhaps we should start calling the 'multiplanar API' the
>> 'multiple non-contiguous planes API', at least in the documentation. It's the
>> first time that I found a description that actually covers the real meaning.
>>
> 
> Yes, indeed. In fact, my first version of this code had something like
> "is_noncontiguous" instead of the "multiplanar" field.

I'm fine with that. Add a comment after it like: /* aka multiplanar */

> 
>>> + */
>>> +struct v4l2_format_info {
>>> +	u32 format;
>>> +	u32 header_size;
>>> +	u8 num_planes;
>>> +	u8 cpp[3];
>>> +	u8 hsub;
>>> +	u8 vsub;
>>> +	u8 multiplanar;
>>> +};
>>> +
>>> +const struct v4l2_format_info *v4l2_format_info(u32 format);
>>> +const char *v4l2_get_format_name(u32 format);
>>> +
>>> +#endif
>>>
>>
> 
> Thanks a lot for the thorough review!
> 
>> Regards,
>>
>> 	Hans
> 
> 
> 

Regards,

	Hans
