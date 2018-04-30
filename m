Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:37237 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754458AbeD3Ovm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 10:51:42 -0400
Subject: Re: [RFCv11 PATCH 26/29] vim2m: use workqueue
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-27-hverkuil@xs4all.nl>
 <ed6b6652337239c97125ac96b203dddd517e0427.camel@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <119dbcf8-ee07-2a9b-9930-fbdbe5fcabd3@xs4all.nl>
Date: Mon, 30 Apr 2018 16:51:40 +0200
MIME-Version: 1.0
In-Reply-To: <ed6b6652337239c97125ac96b203dddd517e0427.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/04/18 16:06, Paul Kocialkowski wrote:
> Hi,
> 
> On Mon, 2018-04-09 at 16:20 +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> v4l2_ctrl uses mutexes, so we can't setup a ctrl_handler in
>> interrupt context. Switch to a workqueue instead.
> 
> See one comment below.
> 
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/platform/vim2m.c | 15 +++++++++++++--
>>  1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/vim2m.c
>> b/drivers/media/platform/vim2m.c
>> index ef970434af13..9b18b32c255d 100644
>> --- a/drivers/media/platform/vim2m.c
>> +++ b/drivers/media/platform/vim2m.c
>> @@ -150,6 +150,7 @@ struct vim2m_dev {
>>  	spinlock_t		irqlock;
>>  
>>  	struct timer_list	timer;
>> +	struct work_struct	work_run;
> 
> Wouldn't it make more sense to move this to vim2m_ctx instead (since
> this is heavily m2m-specific)?

The work is triggered by a timer which is m2m_dev specific. So it makes
no sense to move this to the per-filehandle vim2m_ctx IMHO.

Regards,

	Hans

> 
>>  	struct v4l2_m2m_dev	*m2m_dev;
>>  };
>> @@ -392,9 +393,10 @@ static void device_run(void *priv)
>>  	schedule_irq(dev, ctx->transtime);
>>  }
>>  
>> -static void device_isr(struct timer_list *t)
>> +static void device_work(struct work_struct *w)
>>  {
>> -	struct vim2m_dev *vim2m_dev = from_timer(vim2m_dev, t,
>> timer);
>> +	struct vim2m_dev *vim2m_dev =
>> +		container_of(w, struct vim2m_dev, work_run);
>>  	struct vim2m_ctx *curr_ctx;
>>  	struct vb2_v4l2_buffer *src_vb, *dst_vb;
>>  	unsigned long flags;
>> @@ -426,6 +428,13 @@ static void device_isr(struct timer_list *t)
>>  	}
>>  }
>>  
>> +static void device_isr(struct timer_list *t)
>> +{
>> +	struct vim2m_dev *vim2m_dev = from_timer(vim2m_dev, t,
>> timer);
>> +
>> +	schedule_work(&vim2m_dev->work_run);
>> +}
>> +
>>  /*
>>   * video ioctls
>>   */
>> @@ -806,6 +815,7 @@ static void vim2m_stop_streaming(struct vb2_queue
>> *q)
>>  	struct vb2_v4l2_buffer *vbuf;
>>  	unsigned long flags;
>>  
>> +	flush_scheduled_work();
>>  	for (;;) {
>>  		if (V4L2_TYPE_IS_OUTPUT(q->type))
>>  			vbuf = v4l2_m2m_src_buf_remove(ctx-
>>> fh.m2m_ctx);
>> @@ -1011,6 +1021,7 @@ static int vim2m_probe(struct platform_device
>> *pdev)
>>  	vfd = &dev->vfd;
>>  	vfd->lock = &dev->dev_mutex;
>>  	vfd->v4l2_dev = &dev->v4l2_dev;
>> +	INIT_WORK(&dev->work_run, device_work);
>>  
>>  #ifdef CONFIG_MEDIA_CONTROLLER
>>  	dev->mdev.dev = &pdev->dev;
