Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751018AbdFRUxw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Jun 2017 16:53:52 -0400
Subject: Re: [RFC PATCH 1/2] v4l2-ioctl/exynos: fix G/S_SELECTION's type
 handling
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <20170508143506.16448-1-hverkuil@xs4all.nl>
 <20170616125827.GQ12407@valkosipuli.retiisi.org.uk>
From: Sylwester Nawrocki <snawrocki@kernel.org>
Message-ID: <baf6fee6-3c65-5aea-f042-cfdd6698e4ba@kernel.org>
Date: Sun, 18 Jun 2017 22:53:48 +0200
MIME-Version: 1.0
In-Reply-To: <20170616125827.GQ12407@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/16/2017 02:58 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> Cc Sylwester and Marek as well.
> 
> On Mon, May 08, 2017 at 04:35:05PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hansverk@cisco.com>
>>
>> The type field in struct v4l2_selection is supposed to never use the
>> _MPLANE variants. E.g. if the driver supports V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
>> then userspace should still pass V4L2_BUF_TYPE_VIDEO_CAPTURE.
>>
>> The reasons for this are lost in the mists of time, but it is really
>> annoying. In addition, the exynos drivers didn't follow this rule and
>> instead expected the _MPLANE type.
>>
>> To fix that code is added to the v4l2 core that maps the _MPLANE buffer
>> types to their regular equivalents before calling the driver.
>>
>> Effectively this allows for userspace to use either _MPLANE or the regular
>> buffer type. This keeps backwards compatibility while making things easier
>> for userspace.
>>
>> Since drivers now never see the _MPLANE buffer types the exynos drivers
>> had to be adapted as well.
>>
>> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
>> ---
>>   drivers/media/platform/exynos-gsc/gsc-core.c     |  4 +-
>>   drivers/media/platform/exynos-gsc/gsc-m2m.c      |  8 ++--
>>   drivers/media/platform/exynos4-is/fimc-capture.c |  4 +-
>>   drivers/media/platform/exynos4-is/fimc-lite.c    |  4 +-
>>   drivers/media/v4l2-core/v4l2-ioctl.c             | 53 +++++++++++++++++++++---
>>   5 files changed, 57 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
>> index 59a634201830..107faa04c947 100644
>> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
>> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c

>> +/*
>> + * The selection API specified originally that the _MPLANE buffer types
>> + * shouldn't be used. The reasons for this are lost in the mists of time
>> + * (or just really crappy memories). Regardless, this is really annoying
>> + * for userspace. So to keep things simple we map _MPLANE buffer types
>> + * to their 'regular' counterparts before calling the driver. And we
>> + * restore it afterwards. This way applications can use either buffer
>> + * type and drivers don't need to check for both.

I agree this is annoying the _MPLANE buffer types are excluded this way. 
I suspect one of the main reasons was bias of the original author of the 
selection API to the multi-planar API. Now the API got messy because I didn't
adhere to this rule of buffer type change for VIDIOC_S_SELECTION, and the
code propagated to the other driver. Sorry about that.  

I checked GStreamer and AFAIU there is no change of buffer type for
S_SELECTION there:
https://cgit.freedesktop.org/gstreamer/gst-plugins-good/tree/sys/v4l2/gstv4l2object.c?id=3342d86d9b92cf60c419b728d10944968d77ecac#n3722

>> + */
>> +static int v4l_g_selection(const struct v4l2_ioctl_ops *ops,
>> +			   struct file *file, void *fh, void *arg)
>> +{
>> +	struct v4l2_selection *p = arg;
>> +	u32 old_type = p->type;
>> +	int ret;
>> +
>> +	if (p->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>> +		p->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	else if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> +		p->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>> +	ret = ops->vidioc_g_selection(file, fh, p);
>> +	p->type = old_type;
>> +	return ret;
>> +}
>> +
>> +static int v4l_s_selection(const struct v4l2_ioctl_ops *ops,
>> +			   struct file *file, void *fh, void *arg)
>> +{
>> +	struct v4l2_selection *p = arg;
>> +	u32 old_type = p->type;
>> +	int ret;
>> +
>> +	if (p->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>> +		p->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	else if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> +		p->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>> +	ret = ops->vidioc_s_selection(file, fh, p);
> 
> Can it be that ops->vidioc_s_selection() is NULL here? I don't think it's
> checked anywhere. Same in v4l_g_selection().

I think it can't be, there is the valid_ioctls bitmap test before a call back 
to the driver, to see if driver actually implements an ioctl. And the bitmap 
is populated beforehand in determine_valid_ioctls().

--
Regards,
Sylwester
