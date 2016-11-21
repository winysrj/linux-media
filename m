Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:51320 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753882AbcKUPdo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 10:33:44 -0500
Subject: Re: [PATCH v3 4/9] media: venus: vdec: add video decoder files
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-5-git-send-email-stanimir.varbanov@linaro.org>
 <63a91a5a-a97b-f3df-d16d-c8f76bf20c30@xs4all.nl>
 <4ec31084-1720-845a-30f6-60ddfe285ff1@linaro.org>
 <86442d1d-4a12-71c1-97fa-12bc73bb5045@linaro.org>
 <9ff4f3cf-f6d1-cebe-6f1a-e4209c55e4f4@xs4all.nl>
 <15975057-dd6a-6946-07ac-93a748b6a176@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <aed4a795-3abe-2d5a-abc4-c638cd4f4d61@xs4all.nl>
Date: Mon, 21 Nov 2016 16:33:41 +0100
MIME-Version: 1.0
In-Reply-To: <15975057-dd6a-6946-07ac-93a748b6a176@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/11/16 16:29, Stanimir Varbanov wrote:
> Hi Hans,
>
> On 11/21/2016 05:04 PM, Hans Verkuil wrote:
>> On 18/11/16 10:11, Stanimir Varbanov wrote:
>>> Hi Hans,
>>>
>>>>>> +
>>>>>> +static int
>>>>>> +vdec_reqbufs(struct file *file, void *fh, struct
>>>>>> v4l2_requestbuffers *b)
>>>>>> +{
>>>>>> +    struct vb2_queue *queue = to_vb2q(file, b->type);
>>>>>> +
>>>>>> +    if (!queue)
>>>>>> +        return -EINVAL;
>>>>>> +
>>>>>> +    return vb2_reqbufs(queue, b);
>>>>>> +}
>>>>>
>>>>> Is there any reason why the v4l2_m2m_ioctl_reqbufs et al helper
>>>>> functions
>>>>> can't be used? I strongly recommend that, unless there is a specific
>>>>> reason
>>>>> why that won't work.
>>>>
>>>> So that means I need to completely rewrite the v4l2 part and adopt it
>>>> for mem2mem device APIs.
>>>>
>>>> If that is what you meant I can invest some time to make a estimation
>>>> what would be the changes and time needed. After that we can decide what
>>>> to do - take the driver as is and port it to mem2mem device APIs later
>>>> on or wait for the this transition to happen before merging.
>>>>
>>>
>>> I made an attempt to adopt v4l2 part of the venus driver to m2m API's
>>> and the result was ~300 less lines of code, but with the price of few
>>> extensions in m2m APIs (and I still have issues with running
>>> simultaneously multiple instances).
>>>
>>> I have to add few functions/macros to iterate over a list (list_for_each
>>> and friends). This is used to find the returned from decoder buffers by
>>> address and associate them to vb2_buffer, because the decoder can change
>>> the order of the output buffers.
>>>
>>> The main problem I have is registering of the capture buffers before
>>> session_start. This is requirement (disadvantage) of the firmware
>>> implementation i.e. I need to announce capture buffers (address and size
>>> of the buffer) to the firmware before start buffer interaction by
>>> session_start.
>>>
>>> So having that I think I will need one more week to stabilize the driver
>>> to the state that it was before this m2m transition.
>>>
>>> Thoughts?
>>>
>>
>> It sounds like this it worth doing, since if you need these extensions,
>> then
>> it is likely someone else will need it as well.
>
> Meanwhile I have found bigger obstacle - I cannot run multiple instances
> simultaneously. By m2m design it can execute only one job (m2m context)
> at a time per m2m device. Can you confirm that my observation is correct?

The m2m framework assumes a single HW instance, yes. Do you have multiple
HW decoders? I might not understand what you mean...

Regards,

	Hans

>
> If so one solution could be on every fops::open I can create m2m_dev and
> init m2m_cxt.
>
>>
>> Can you mail me a preliminary patch with the core m2m changes? That will be
>> helpful for me to look at.
>
> Something like below diffs:
>
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c
> b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index 61d56c940f80..52e22ec0f67b 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -136,6 +136,28 @@ void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx
> *q_ctx)
>  }
>  EXPORT_SYMBOL_GPL(v4l2_m2m_buf_remove);
>
> +struct vb2_v4l2_buffer *
> +v4l2_m2m_buf_remove_match(struct v4l2_m2m_queue_ctx *q_ctx, void *priv,
> +                          int (*match)(void *priv, struct
> vb2_v4l2_buffer *vb))
> +{
> +       struct v4l2_m2m_buffer *b, *tmp;
> +       struct vb2_v4l2_buffer *ret = NULL;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&q_ctx->rdy_spinlock, flags);
> +       list_for_each_entry_safe(b, tmp, &q_ctx->rdy_queue, list) {
> +               if (match(priv, &b->vb)) {
> +                       list_del(&b->list);
> +                       ret = &b->vb;
> +                       break;
> +               }
> +       }
> +       spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_m2m_buf_remove_match);
> +
>  /*
>   * Scheduling handlers
>   */
> diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
> index 64e1819ea66d..e943609209ba 100644
> --- a/include/media/v4l2-mem2mem.h
> +++ b/include/media/v4l2-mem2mem.h
> @@ -263,6 +263,24 @@ static inline void *v4l2_m2m_dst_buf_remove(struct
> v4l2_m2m_ctx *m2m_ctx)
>         return v4l2_m2m_buf_remove(&m2m_ctx->cap_q_ctx);
>  }
>
> +struct vb2_v4l2_buffer *
> +v4l2_m2m_buf_remove_match(struct v4l2_m2m_queue_ctx *q_ctx, void *priv,
> +                       int (*match)(void *priv, struct vb2_v4l2_buffer
> *vb));
> +
> +static inline struct vb2_v4l2_buffer *
> +v4l2_m2m_src_buf_remove_match(struct v4l2_m2m_ctx *m2m_ctx, void *priv,
> +                       int (*match)(void *priv, struct vb2_v4l2_buffer
> *vb))
> +{
> +       return v4l2_m2m_buf_remove_match(&m2m_ctx->out_q_ctx, priv, match);
> +}
> +
> +static inline struct vb2_v4l2_buffer *
> +v4l2_m2m_dst_buf_remove_match(struct v4l2_m2m_ctx *m2m_ctx, void *priv,
> +                       int (*match)(void *priv, struct vb2_v4l2_buffer
> *vb))
> +{
> +       return v4l2_m2m_buf_remove_match(&m2m_ctx->cap_q_ctx, priv, match);
> +}
>
> diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
> index 5a9597dd1ee0..64e1819ea66d 100644
> --- a/include/media/v4l2-mem2mem.h
> +++ b/include/media/v4l2-mem2mem.h
> @@ -211,6 +211,12 @@ static inline void *v4l2_m2m_next_dst_buf(struct
> v4l2_m2m_ctx *m2m_ctx)
>         return v4l2_m2m_next_buf(&m2m_ctx->cap_q_ctx);
>  }
>
> +#define v4l2_m2m_for_each_dst_buf(q_ctx, b)    \
> +       list_for_each_entry(b, &q_ctx->cap_q_ctx.rdy_queue, list)
> +
> +#define v4l2_m2m_for_each_src_buf(q_ctx, b)    \
> +       list_for_each_entry(b, &q_ctx->out_q_ctx.rdy_queue, list)
> +
>  /**
>   * v4l2_m2m_get_src_vq() - return vb2_queue for source buffers
>   *
>
