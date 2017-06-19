Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56419 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdFSNvB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 09:51:01 -0400
Subject: Re: [PATCH v2 5/6] [media] s5p-jpeg: Add support for resolution
 change event
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1497287605-20074-1-git-send-email-thierry.escande@collabora.com>
 <CGME20170612171431epcas5p19a448035865da056440a819f17875601@epcas5p1.samsung.com>
 <1497287605-20074-6-git-send-email-thierry.escande@collabora.com>
 <dd3fa8e9-48e2-ab1d-4b4e-da63900c08d6@samsung.com>
From: Thierry Escande <thierry.escande@collabora.com>
Message-ID: <d214a1d2-bce4-ea46-866c-6e35d16f26c9@collabora.com>
Date: Mon, 19 Jun 2017 15:50:51 +0200
MIME-Version: 1.0
In-Reply-To: <dd3fa8e9-48e2-ab1d-4b4e-da63900c08d6@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

On 16/06/2017 17:38, Andrzej Pietrasiewicz wrote:
> Hi Thierry,
> 
> Thank you for the patch.
> 
> Can you give a use case for resolution change event?
Unfortunately, the original commit does not mention any clear use case. 
I've asked to the patch author for more information.

> Also plase see inline.
> 
> W dniu 12.06.2017 o 19:13, Thierry Escande pisze:
>> From: henryhsu <henryhsu@chromium.org>
>> @@ -1611,8 +1612,6 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx 
>> *ct, struct v4l2_format *f)
>>               FMT_TYPE_OUTPUT : FMT_TYPE_CAPTURE;
>>       q_data->fmt = s5p_jpeg_find_format(ct, pix->pixelformat, f_type);
>> -    q_data->w = pix->width;
>> -    q_data->h = pix->height;
>>       if (q_data->fmt->fourcc != V4L2_PIX_FMT_JPEG) {
>>           /*
>>            * During encoding Exynos4x12 SoCs access wider memory area
>> @@ -1620,6 +1619,8 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx 
>> *ct, struct v4l2_format *f)
>>            * the JPEG_IMAGE_SIZE register. In order to avoid sysmmu
>>            * page fault calculate proper buffer size in such a case.
>>            */
>> +        q_data->w = pix->width;
>> +        q_data->h = pix->height;
> 
> Is this change related to what the patch is supposed to be doing?
Yes actually. From the author comments to the same question:
"We want to send a resolution change in the first frame. Without this, 
q_data->w and h will be updated by s_fmt. Then we won't know the 
resolution is changed from (0, 0) to (w, h) in qbuf function."

>>   static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
>>   {
>>       struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> @@ -2499,9 +2545,20 @@ static void s5p_jpeg_buf_queue(struct 
>> vb2_buffer *vb)
>>       if (ctx->mode == S5P_JPEG_DECODE &&
>>           vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
>> -        struct s5p_jpeg_q_data tmp, *q_data;
>> -
>> -        ctx->hdr_parsed = s5p_jpeg_parse_hdr(&tmp,
>> +        static const struct v4l2_event ev_src_ch = {
>> +            .type = V4L2_EVENT_SOURCE_CHANGE,
>> +            .u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
>> +        };
>> +        struct vb2_queue *dst_vq;
>> +        u32 ori_w;
>> +        u32 ori_h;
>> +
>> +        dst_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
>> +                     V4L2_BUF_TYPE_VIDEO_CAPTURE);
>> +        ori_w = ctx->out_q.w;
>> +        ori_h = ctx->out_q.h;
>> +
>> +        ctx->hdr_parsed = s5p_jpeg_parse_hdr(&ctx->out_q,
>>                (unsigned long)vb2_plane_vaddr(vb, 0),
>>                min((unsigned long)ctx->out_q.size,
>>                vb2_get_plane_payload(vb, 0)), ctx);
>> @@ -2510,43 +2567,18 @@ static void s5p_jpeg_buf_queue(struct 
>> vb2_buffer *vb)
>>               return;
>>           }
>> -        q_data = &ctx->out_q;
>> -        q_data->w = tmp.w;
>> -        q_data->h = tmp.h;
>> -        q_data->sos = tmp.sos;
>> -        memcpy(q_data->dht.marker, tmp.dht.marker,
>> -               sizeof(tmp.dht.marker));
>> -        memcpy(q_data->dht.len, tmp.dht.len, sizeof(tmp.dht.len));
>> -        q_data->dht.n = tmp.dht.n;
>> -        memcpy(q_data->dqt.marker, tmp.dqt.marker,
>> -               sizeof(tmp.dqt.marker));
>> -        memcpy(q_data->dqt.len, tmp.dqt.len, sizeof(tmp.dqt.len));
>> -        q_data->dqt.n = tmp.dqt.n;
>> -        q_data->sof = tmp.sof;
>> -        q_data->sof_len = tmp.sof_len;
>> -
>> -        q_data = &ctx->cap_q;
>> -        q_data->w = tmp.w;
>> -        q_data->h = tmp.h;
> 
> 
> Why is this part removed?
This has not been removed.
The &tmp s5p_jpeg_q_data struct was passed to s5p_jpeg_parse_hdr() and 
then copied field-by-field into ctx->out_q (through q_data pointer).
With this change ctx->out_q is passed to s5p_jpeg_parse_hdr() and this 
avoids the copy.
Then ctx->cap_q width & height copy is done in 
s5p_jpeg_set_capture_queue_data().

Regards,
  Thierry
