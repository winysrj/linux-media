Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51326 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387848AbeKGAge (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 19:36:34 -0500
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v4 4/6] media: uvcvideo: queue: Simplify spin-lock usage
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
 <ec54c7e1cfc4d1846c3dc09f27f609e7cf82b45c.1522168131.git-series.kieran.bingham@ideasonboard.com>
 <18698388.LcrgILxgHI@avalon>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <4a55341e-859f-934c-41ba-6137bb812439@ideasonboard.com>
Date: Tue, 6 Nov 2018 15:10:49 +0000
MIME-Version: 1.0
In-Reply-To: <18698388.LcrgILxgHI@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 30/07/2018 20:57, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Tuesday, 27 March 2018 19:46:01 EEST Kieran Bingham wrote:
>> Both uvc_start_streaming(), and uvc_stop_streaming() are called from
>> userspace context, with interrupts enabled. As such, they do not need to
>> save the IRQ state, and can use spin_lock_irq() and spin_unlock_irq()
>> respectively.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
>>
>> ---
>>
>> v4:
>>  - Rebase to v4.16 (linux-media/master)
>>
>>  drivers/media/usb/uvc/uvc_queue.c | 10 ++++------
>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_queue.c
>> b/drivers/media/usb/uvc/uvc_queue.c index adcc4928fae4..698d9a5a5aae 100644
>> --- a/drivers/media/usb/uvc/uvc_queue.c
>> +++ b/drivers/media/usb/uvc/uvc_queue.c
>> @@ -169,7 +169,6 @@ static int uvc_start_streaming(struct vb2_queue *vq,
>> unsigned int count) {
>>  	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
>>  	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
>> -	unsigned long flags;
>>  	int ret;
>>
>>  	queue->buf_used = 0;
>> @@ -178,9 +177,9 @@ static int uvc_start_streaming(struct vb2_queue *vq,
>> unsigned int count) if (ret == 0)
>>  		return 0;
>>
>> -	spin_lock_irqsave(&queue->irqlock, flags);
>> +	spin_lock_irq(&queue->irqlock);
>>  	uvc_queue_return_buffers(queue, UVC_BUF_STATE_QUEUED);
>> -	spin_unlock_irqrestore(&queue->irqlock, flags);
>> +	spin_unlock_irq(&queue->irqlock);
>>
>>  	return ret;
>>  }
>> @@ -188,14 +187,13 @@ static int uvc_start_streaming(struct vb2_queue *vq,
>> unsigned int count) static void uvc_stop_streaming(struct vb2_queue *vq)
>>  {
>>  	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
>> -	unsigned long flags;
>>
>>  	if (vq->type != V4L2_BUF_TYPE_META_CAPTURE)
>>  		uvc_video_enable(uvc_queue_to_stream(queue), 0);
>>
>> -	spin_lock_irqsave(&queue->irqlock, flags);
>> +	spin_lock_irq(&queue->irqlock);
>>  	uvc_queue_return_buffers(queue, UVC_BUF_STATE_ERROR);
>> -	spin_unlock_irqrestore(&queue->irqlock, flags);
>> +	spin_unlock_irq(&queue->irqlock);
>>  }
> 
> I think you missed my comment that stated
> 
>> Please add a one-line comment above both functions to state
>>
>> /* Must be called with interrupts enabled. */
> 
> Philipp Zabel commented that you could also add lockdep_assert_irqs_enabled(), 
> and I think that's a good idea. I'll let you decide whether to do both, or 
> only add lockdep_assert_irqs_enabled(), I'm fine with either option.
> 
> With this fixed,

I think code should talk louder than comments (especially as it provides
runtime verification and assertions when lockdep is enabled) - so I've
gone for Philipp's suggestion here.

> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 

Collected, thanks.


>>  static const struct vb2_ops uvc_queue_qops = {
> 

-- 
Regards
--
Kieran
