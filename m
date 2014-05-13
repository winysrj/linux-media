Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:61194 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786AbaEMKrl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 May 2014 06:47:41 -0400
MIME-Version: 1.0
In-Reply-To: <5371D0ED.4050208@xs4all.nl>
References: <1399960743-4542-1-git-send-email-arun.kk@samsung.com>
	<1399960743-4542-3-git-send-email-arun.kk@samsung.com>
	<5371D0ED.4050208@xs4all.nl>
Date: Tue, 13 May 2014 16:17:41 +0530
Message-ID: <CALt3h78bhGtvaqQSrHSmejGu4rb1OywU8dhGQxx+NxqJE3pitw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] [media] s5p-mfc: Add support for resolution change event
From: Arun Kumar K <arun.kk@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <posciak@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, May 13, 2014 at 1:29 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 05/13/14 07:59, Arun Kumar K wrote:
>> From: Pawel Osciak <posciak@chromium.org>
>>
>> When a resolution change point is reached, queue an event to signal the
>> userspace that a new set of buffers is required before decoding can
>> continue.
>>
>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc.c     |    7 +++++++
>>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |    2 ++
>>  2 files changed, 9 insertions(+)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> index 54f7ba1..2d7d1ae 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> @@ -320,6 +320,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
>>       struct s5p_mfc_buf *src_buf;
>>       unsigned long flags;
>>       unsigned int res_change;
>> +     struct v4l2_event ev;
>>
>>       dst_frame_status = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_status, dev)
>>                               & S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
>> @@ -351,6 +352,12 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
>>               if (ctx->state == MFCINST_RES_CHANGE_FLUSH) {
>>                       s5p_mfc_handle_frame_all_extracted(ctx);
>>                       ctx->state = MFCINST_RES_CHANGE_END;
>> +
>> +                     memset(&ev, 0, sizeof(struct v4l2_event));
>> +                     ev.type = V4L2_EVENT_SOURCE_CHANGE;
>> +                     ev.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION;
>
> I would replace this by:
>
>                 static const struct v4l2_event ev_src_ch = {
>                         .type = V4L2_EVENT_SOURCE_CHANGE,
>                         .u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
>                 };
>
> No need for memsets or filling in structs at runtime.
>

Ok will make this change.

Regards
Arun

> Regards,
>
>         Hans
>
>> +                     v4l2_event_queue_fh(&ctx->fh, &ev);
>> +
>>                       goto leave_handle_frame;
>>               } else {
>>                       s5p_mfc_handle_frame_all_extracted(ctx);
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>> index 4f94491..b383829 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>> @@ -855,6 +855,8 @@ static int vidioc_subscribe_event(struct v4l2_fh *fh,
>>       switch (sub->type) {
>>       case V4L2_EVENT_EOS:
>>               return v4l2_event_subscribe(fh, sub, 2, NULL);
>> +     case V4L2_EVENT_SOURCE_CHANGE:
>> +             return v4l2_src_change_event_subscribe(fh, sub);
>>       default:
>>               return -EINVAL;
>>       }
>>
>
