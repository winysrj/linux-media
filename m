Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39733 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbdFGP1G (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 11:27:06 -0400
From: Thierry Escande <thierry.escande@collabora.com>
Subject: Re: [PATCH 6/9] [media] s5p-jpeg: Add support for resolution change
 event
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
 <1496419376-17099-7-git-send-email-thierry.escande@collabora.com>
 <18b325de-ce2a-d303-957b-ad6c7518c5f4@gmail.com>
Message-ID: <bf35719d-c397-487f-0d4c-eb28fea8fad5@collabora.com>
Date: Wed, 7 Jun 2017 17:27:01 +0200
MIME-Version: 1.0
In-Reply-To: <18b325de-ce2a-d303-957b-ad6c7518c5f4@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On 02/06/2017 23:53, Jacek Anaszewski wrote:
> Hi Thierry,
> 
> On 06/02/2017 06:02 PM, Thierry Escande wrote:
>> From: henryhsu <henryhsu@chromium.org>
>>
>> This patch adds support for resolution change event to notify clients so
>> they can prepare correct output buffer. When resolution change happened,
>> G_FMT for CAPTURE should return old resolution and format before CAPTURE
>> queues streamoff.
> 
> Do you have a use case for that?
Sorry but no. Again, the entry in the chromeos bug tracker does not 
mention any use case.

>> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
>> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
>> -	pix->width = q_data->w;
>> -	pix->height = q_data->h;
>> +	if ((f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
>> +	     ct->mode == S5P_JPEG_ENCODE) ||
>> +	    (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
>> +	     ct->mode == S5P_JPEG_DECODE)) {
>> +		pix->width = 0;
>> +		pix->height = 0;
>> +	} else {
>> +		pix->width = q_data->w;
>> +		pix->height = q_data->h;
>> +	}
>> +
> 
> Is this change related to the patch subject?
Hum... Not sure indeed. I'll remove that from the v2.

>> +static void s5p_jpeg_set_capture_queue_data(struct s5p_jpeg_ctx *ctx)
>> +{
>> +	struct s5p_jpeg_q_data *q_data = &ctx->cap_q;
>> +
>> +	q_data->w = ctx->out_q.w;
>> +	q_data->h = ctx->out_q.h;
>> +
>> +	jpeg_bound_align_image(ctx, &q_data->w, S5P_JPEG_MIN_WIDTH,
>> +			       S5P_JPEG_MAX_WIDTH, q_data->fmt->h_align,
>> +			       &q_data->h, S5P_JPEG_MIN_HEIGHT,
>> +			       S5P_JPEG_MAX_HEIGHT, q_data->fmt->v_align);
>> +
>> +	q_data->size = q_data->w * q_data->h * q_data->fmt->depth >> 3;
>> +}
>> +
>>   static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
>>   {
>>   	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> @@ -2565,9 +2611,20 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
>>   
>>   	if (ctx->mode == S5P_JPEG_DECODE &&
>>   	    vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
>> -		struct s5p_jpeg_q_data tmp, *q_data;
>> -
>> -		ctx->hdr_parsed = s5p_jpeg_parse_hdr(&tmp,
>> +		static const struct v4l2_event ev_src_ch = {
>> +			.type = V4L2_EVENT_SOURCE_CHANGE,
>> +			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
>> +		};
>> +		struct vb2_queue *dst_vq;
>> +		u32 ori_w;
>> +		u32 ori_h;
>> +
>> +		dst_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
>> +					 V4L2_BUF_TYPE_VIDEO_CAPTURE);
>> +		ori_w = ctx->out_q.w;
>> +		ori_h = ctx->out_q.h;
>> +
>> +		ctx->hdr_parsed = s5p_jpeg_parse_hdr(&ctx->out_q,
>>   		     (unsigned long)vb2_plane_vaddr(vb, 0),
>>   		     min((unsigned long)ctx->out_q.size,
>>   			 vb2_get_plane_payload(vb, 0)), ctx);
>> @@ -2576,31 +2633,18 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
>>   			return;
>>   		}
>>   
>> -		q_data = &ctx->out_q;
>> -		q_data->w = tmp.w;
>> -		q_data->h = tmp.h;
>> -		q_data->sos = tmp.sos;
>> -		memcpy(q_data->dht.marker, tmp.dht.marker,
>> -		       sizeof(tmp.dht.marker));
>> -		memcpy(q_data->dht.len, tmp.dht.len, sizeof(tmp.dht.len));
>> -		q_data->dht.n = tmp.dht.n;
>> -		memcpy(q_data->dqt.marker, tmp.dqt.marker,
>> -		       sizeof(tmp.dqt.marker));
>> -		memcpy(q_data->dqt.len, tmp.dqt.len, sizeof(tmp.dqt.len));
>> -		q_data->dqt.n = tmp.dqt.n;
>> -		q_data->sof = tmp.sof;
>> -		q_data->sof_len = tmp.sof_len;
> 
> You're removing here quantization and Huffman table info, is it
> intentional?
ctx->out_q is now passed directly to s5p_jpeg_parse_hdr(). This avoids 
this field-by-field copy already done in s5p_jpeg_parse_hdr().
This do not remove anything unless I'm missing something here...

Regards,
  Thierry
