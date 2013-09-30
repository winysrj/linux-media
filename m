Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:64642 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3I3Jco (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 05:32:44 -0400
MIME-Version: 1.0
In-Reply-To: <52493160.5030401@xs4all.nl>
References: <1378991371-24428-1-git-send-email-shaik.ameer@samsung.com>
	<1378991371-24428-4-git-send-email-shaik.ameer@samsung.com>
	<52493160.5030401@xs4all.nl>
Date: Mon, 30 Sep 2013 15:02:43 +0530
Message-ID: <CAOD6ATpssyY_955-VMYPBzQOqHWgE0OZvU0xvU62+Q2e90JW8g@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] [media] exynos-scaler: Add m2m functionality for
 the SCALER driver
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	posciak@google.com, Inki Dae <inki.dae@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for pointing it out.


On Mon, Sep 30, 2013 at 1:38 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Shaik,
>
> I have a few questions regarding the selection part...
>
> On 09/12/2013 03:09 PM, Shaik Ameer Basha wrote:
>> This patch adds the Makefile and memory to memory (m2m) interface
>> functionality for the SCALER driver.
>>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> ---
>>  drivers/media/platform/Kconfig                    |    8 +
>>  drivers/media/platform/Makefile                   |    1 +
>>  drivers/media/platform/exynos-scaler/Makefile     |    3 +
>>  drivers/media/platform/exynos-scaler/scaler-m2m.c |  781 +++++++++++++++++++++
>>  4 files changed, 793 insertions(+)
>>  create mode 100644 drivers/media/platform/exynos-scaler/Makefile
>>  create mode 100644 drivers/media/platform/exynos-scaler/scaler-m2m.c
>>
>


[...]


>> +
>> +static int scaler_m2m_s_selection(struct file *file, void *fh,
>> +                             struct v4l2_selection *s)
>> +{
>> +     struct scaler_frame *frame;
>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>> +     struct v4l2_crop cr;
>> +     struct scaler_variant *variant = ctx->scaler_dev->variant;
>> +     int ret;
>> +
>> +     cr.type = s->type;
>> +     cr.c = s->r;
>> +
>> +     if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
>> +         (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
>> +             return -EINVAL;
>> +
>> +     ret = scaler_try_crop(ctx, &cr);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     if (s->flags & V4L2_SEL_FLAG_LE &&
>> +         !is_rectangle_enclosed(&cr.c, &s->r))
>> +             return -ERANGE;
>> +
>> +     if (s->flags & V4L2_SEL_FLAG_GE &&
>> +         !is_rectangle_enclosed(&s->r, &cr.c))
>> +             return -ERANGE;
>> +
>> +     s->r = cr.c;
>> +
>> +     switch (s->target) {
>> +     case V4L2_SEL_TGT_COMPOSE_BOUNDS:
>> +     case V4L2_SEL_TGT_COMPOSE_DEFAULT:
>> +     case V4L2_SEL_TGT_COMPOSE:
>> +             frame = &ctx->s_frame;
>> +             break;
>> +
>> +     case V4L2_SEL_TGT_CROP_BOUNDS:
>> +     case V4L2_SEL_TGT_CROP:
>> +     case V4L2_SEL_TGT_CROP_DEFAULT:
>> +             frame = &ctx->d_frame;
>> +             break;
>
> Similar problems as with g_selection above. Tomasz mentioned to me that the selection
> API is not implemented correctly in m2m Samsung drivers. It looks like this code is
> copied-and-pasted from other drivers, so it seems he was right.

Sorry, after going through the documentation, I have to agree with you...
As you mentioned, this part of the code was copied while implementing
the G-Scaler driver :)

I will change the above implementation for M2M devices (GScaler and
SCALER) as below,
I will only allow all V4L2_SEL_TGT_COMPOSE_* target requests if
's->type' is equal to "V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE".
and all V4L2_SEL_TGT_CROP_* target requests if 's->type' is equal to
"V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE".

I hope with the above two checkings taken in to care, there should not
be any issues with using selection APIs here.

Thanks,
Shaik Ameer Basha

>
> The selection API for m2m devices will be discussed during the upcoming V4L2 mini-summit
> since the API may actually need some adjustments to have it work the way it should.
>
> As requested above, if you can explain the exact functionality you are trying to
> implement here, then I can look over this code carefully and see how it should be done.
>
> Thanks!
>
>         Hans
>
[...]
