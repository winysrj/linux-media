Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52451 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab2HADoZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 23:44:25 -0400
Received: by vbbff1 with SMTP id ff1so6552563vbb.19
        for <linux-media@vger.kernel.org>; Tue, 31 Jul 2012 20:44:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207311418.05012.hverkuil@xs4all.nl>
References: <1343736753-18454-1-git-send-email-shaik.ameer@samsung.com>
	<1343736753-18454-5-git-send-email-shaik.ameer@samsung.com>
	<201207311418.05012.hverkuil@xs4all.nl>
Date: Wed, 1 Aug 2012 09:14:24 +0530
Message-ID: <CAOD6ATqyxhV6mhOQcfe-65n_5brF5meSS6SHj1WgdzWkJPuZ5w@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] media: gscaler: Add m2m functionality for the
 G-Scaler driver
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, sungchun.kang@samsung.com,
	khw0178.kim@samsung.com, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, sy0816.kang@samsung.com,
	s.nawrocki@samsung.com, posciak@google.com, alim.akhtar@gmail.com,
	prashanth.g@samsung.com, joshi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Jul 31, 2012 at 5:48 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tue 31 July 2012 14:12:32 Shaik Ameer Basha wrote:
>> From: Sungchun Kang <sungchun.kang@samsung.com>
>>
>> This patch adds the memory to memory (m2m) interface functionality
>> for the G-Scaler driver.
>>
>> Signed-off-by: Hynwoong Kim <khw0178.kim@samsung.com>
>> Signed-off-by: Sungchun Kang <sungchun.kang@samsung.com>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>  drivers/media/video/exynos-gsc/gsc-m2m.c |  772 ++++++++++++++++++++++++++++++
>>  1 files changed, 772 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/media/video/exynos-gsc/gsc-m2m.c
>>
>> diff --git a/drivers/media/video/exynos-gsc/gsc-m2m.c b/drivers/media/video/exynos-gsc/gsc-m2m.c
>> new file mode 100644
>> index 0000000..d7ecdb8
>> --- /dev/null
>> +++ b/drivers/media/video/exynos-gsc/gsc-m2m.c
>
>
>> +static int gsc_m2m_querycap(struct file *file, void *fh,
>> +                        struct v4l2_capability *cap)
>> +{
>> +     struct gsc_ctx *ctx = fh_to_ctx(fh);
>> +     struct gsc_dev *gsc = ctx->gsc_dev;
>> +
>> +     strlcpy(cap->driver, gsc->pdev->name, sizeof(cap->driver));
>> +     strlcpy(cap->card, gsc->pdev->name, sizeof(cap->card));
>> +     strlcpy(cap->bus_info, "platform", sizeof(cap->bus_info));
>> +     cap->device_caps = V4L2_CAP_STREAMING |
>> +                             V4L2_CAP_VIDEO_CAPTURE_MPLANE |
>> +                             V4L2_CAP_VIDEO_OUTPUT_MPLANE;
>
> Yesterday the new V4L2_CAP_M2M_PLANE was added. You should add this
> capability here. It is up to you to decide whether to remove the
> CAPTURE_MPLANE and OUTPUT_MPLANE caps at the same time, or leave them for
> a bit until any applications have had the chance to use the new M2M capability.
>
> Combining the capture and output caps caused problems since apps would misdetect
> this as a normal capture device instead of an M2M device. It's only for a
> transition time that all three caps are allowed.
>

thanks for pointing it out.
I addressed your comment in v5 set.
CAPTURE_MPLANE and OUTPUT_MPLANE will be removed later.

> Regards,
>
>         Hans


Regards,
Shaik Ameer Basha
