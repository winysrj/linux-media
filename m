Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1476 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3I3MOa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 08:14:30 -0400
Message-ID: <52496B14.1060804@xs4all.nl>
Date: Mon, 30 Sep 2013 14:14:12 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.samsung@gmail.com>
CC: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	posciak@google.com, Inki Dae <inki.dae@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH v3 3/4] [media] exynos-scaler: Add m2m functionality for
 the SCALER driver
References: <1378991371-24428-1-git-send-email-shaik.ameer@samsung.com> <1378991371-24428-4-git-send-email-shaik.ameer@samsung.com> <52493160.5030401@xs4all.nl> <CAOD6ATpssyY_955-VMYPBzQOqHWgE0OZvU0xvU62+Q2e90JW8g@mail.gmail.com> <52495337.4040309@xs4all.nl> <CAOD6ATpY66-nx0T6XaoT3YT8trUwt=hdr-ToZv4PH3xnxGET_g@mail.gmail.com>
In-Reply-To: <CAOD6ATpY66-nx0T6XaoT3YT8trUwt=hdr-ToZv4PH3xnxGET_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/30/2013 12:48 PM, Shaik Ameer Basha wrote:
> Hi Hans,
> 
> 
> On Mon, Sep 30, 2013 at 4:02 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 09/30/2013 11:32 AM, Shaik Ameer Basha wrote:
>>> Hi Hans,
>>>
>>> Thanks for pointing it out.
>>>
>>>
>>> On Mon, Sep 30, 2013 at 1:38 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> Hi Shaik,
>>>>
>>>> I have a few questions regarding the selection part...
>>>>
>>>> On 09/12/2013 03:09 PM, Shaik Ameer Basha wrote:
>>>>> This patch adds the Makefile and memory to memory (m2m) interface
>>>>> functionality for the SCALER driver.
>>>>>
>>>>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>>>>> ---
>>>>>  drivers/media/platform/Kconfig                    |    8 +
>>>>>  drivers/media/platform/Makefile                   |    1 +
>>>>>  drivers/media/platform/exynos-scaler/Makefile     |    3 +
>>>>>  drivers/media/platform/exynos-scaler/scaler-m2m.c |  781 +++++++++++++++++++++
>>>>>  4 files changed, 793 insertions(+)
>>>>>  create mode 100644 drivers/media/platform/exynos-scaler/Makefile
>>>>>  create mode 100644 drivers/media/platform/exynos-scaler/scaler-m2m.c
>>>>>
>>>>
>>>
>>>
>>> [...]
>>>
>>>
>>>>> +
>>>>> +static int scaler_m2m_s_selection(struct file *file, void *fh,
>>>>> +                             struct v4l2_selection *s)
>>>>> +{
>>>>> +     struct scaler_frame *frame;
>>>>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>>>>> +     struct v4l2_crop cr;
>>>>> +     struct scaler_variant *variant = ctx->scaler_dev->variant;
>>>>> +     int ret;
>>>>> +
>>>>> +     cr.type = s->type;
>>>>> +     cr.c = s->r;
>>>>> +
>>>>> +     if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
>>>>> +         (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
>>>>> +             return -EINVAL;
>>>>> +
>>>>> +     ret = scaler_try_crop(ctx, &cr);
>>>>> +     if (ret < 0)
>>>>> +             return ret;
>>>>> +
>>>>> +     if (s->flags & V4L2_SEL_FLAG_LE &&
>>>>> +         !is_rectangle_enclosed(&cr.c, &s->r))
>>>>> +             return -ERANGE;
>>>>> +
>>>>> +     if (s->flags & V4L2_SEL_FLAG_GE &&
>>>>> +         !is_rectangle_enclosed(&s->r, &cr.c))
>>>>> +             return -ERANGE;
>>>>> +
>>>>> +     s->r = cr.c;
>>>>> +
>>>>> +     switch (s->target) {
>>>>> +     case V4L2_SEL_TGT_COMPOSE_BOUNDS:
>>>>> +     case V4L2_SEL_TGT_COMPOSE_DEFAULT:
>>>>> +     case V4L2_SEL_TGT_COMPOSE:
>>>>> +             frame = &ctx->s_frame;
>>>>> +             break;
>>>>> +
>>>>> +     case V4L2_SEL_TGT_CROP_BOUNDS:
>>>>> +     case V4L2_SEL_TGT_CROP:
>>>>> +     case V4L2_SEL_TGT_CROP_DEFAULT:
>>>>> +             frame = &ctx->d_frame;
>>>>> +             break;
>>>>
>>>> Similar problems as with g_selection above. Tomasz mentioned to me that the selection
>>>> API is not implemented correctly in m2m Samsung drivers. It looks like this code is
>>>> copied-and-pasted from other drivers, so it seems he was right.
>>>
>>> Sorry, after going through the documentation, I have to agree with you...
>>> As you mentioned, this part of the code was copied while implementing
>>> the G-Scaler driver :)
>>>
>>> I will change the above implementation for M2M devices (GScaler and
>>> SCALER) as below,
>>> I will only allow all V4L2_SEL_TGT_COMPOSE_* target requests if
>>> 's->type' is equal to "V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE".
>>> and all V4L2_SEL_TGT_CROP_* target requests if 's->type' is equal to
>>> "V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE".
>>>
>>> I hope with the above two checkings taken in to care, there should not
>>> be any issues with using selection APIs here.
>>
>> Well, that depends on what the hardware does.
>>
>> Using compose with a capture buffer means that the frame as delivered by
>> the hardware is composed into a larger buffer. E.g. the hardware gives
>> you 1280x720 which is composed into a buffer of size 1920x1080.
>>
>> Using crop with an output buffer means that the hardware gets a cropped
>> part of a larger frame. E.g. you give a 1280x720 crop from a larger 1920x1080
>> buffer.
>>
>> I suspect however, that in this case the hardware does the opposite for
>> capture: you really want to crop with a capture buffer (e.g. the hardware
>> delivers a 1280x720 frame which is cropped before DMA to 640x360).
>>
>> I'm not sure what you want to do with an output buffer: cropping or composing.
>>
>> Tomasz mentioned that the M2M + selection API was screwy, and this seems to
>> be to be the case indeed.
>>
>> Which is also why I would like to know exactly what this hardware does.
> 
> This hardware is just a M2M device.
> It accepts one source buffer at a time and does some operations on
> that and saves to the destination buffer.
> Operations like Rotation, Cropping, Scaling, Color Space Conversion
> etc are possible.
> 
> Here when I provide the Output buffer (source buffer), I can apply all
> V4L2_SEL_TGT_CROP_* targets on it.
> That means I can select the whole buffer for processing or apply some
> crop and select that area for further processing.
> 
> similarly, On the capture buffer (output buffer), I can apply
> V4L2_SEL_TGT_COMPOSE_* targets.
> That means I can compose the final output to the complete capture
> frame (dst frame), or I can choose some part of the destination frame.

OK, in that case your proposed changes are indeed correct. Sorry, I had
to check this carefully since it is so easy to get confused :-)

Regards,

	Hans
