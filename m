Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:43499 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755435AbeDWPKQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 11:10:16 -0400
Subject: Re: [RFCv11 PATCH 27/29] vim2m: support requests
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-28-hverkuil@xs4all.nl>
 <306cf219797f08bb854beab05ff1c4546c6c679e.camel@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <26166610-c678-39fd-4c35-24e95ded168e@xs4all.nl>
Date: Mon, 23 Apr 2018 17:10:10 +0200
MIME-Version: 1.0
In-Reply-To: <306cf219797f08bb854beab05ff1c4546c6c679e.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/2018 01:42 PM, Paul Kocialkowski wrote:
> Hi,
> 
> On Mon, 2018-04-09 at 16:20 +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add support for requests to vim2m.
> 
> Please find a nit below.
> 
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/platform/vim2m.c | 25 +++++++++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>
>> diff --git a/drivers/media/platform/vim2m.c
>> b/drivers/media/platform/vim2m.c
>> index 9b18b32c255d..2dcf0ea85705 100644
>> --- a/drivers/media/platform/vim2m.c
>> +++ b/drivers/media/platform/vim2m.c
>> @@ -387,8 +387,26 @@ static void device_run(void *priv)
>>  	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
>>  	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
>>  
>> +	/* Apply request if needed */
> 
> This comment suggests that this is where request submission is handled.
> I suggest making it clear that this the place where the *controls*
> attached to the request are applied, instead.

True. Fixed here and below.

Thanks!

	Hans

> 
>> +	if (src_buf->vb2_buf.req_obj.req)
>> +		v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
>> +					&ctx->hdl);
>> +	if (dst_buf->vb2_buf.req_obj.req &&
>> +	    dst_buf->vb2_buf.req_obj.req != src_buf-
>>> vb2_buf.req_obj.req)
>> +		v4l2_ctrl_request_setup(dst_buf->vb2_buf.req_obj.req,
>> +					&ctx->hdl);
>> +
>>  	device_process(ctx, src_buf, dst_buf);
>>  
>> +	/* Complete request if needed */
> 
> Ditto here.
> 
>> +	if (src_buf->vb2_buf.req_obj.req)
>> +		v4l2_ctrl_request_complete(src_buf-
>>> vb2_buf.req_obj.req,
>> +					&ctx->hdl);
>> +	if (dst_buf->vb2_buf.req_obj.req &&
>> +	    dst_buf->vb2_buf.req_obj.req != src_buf-
>>> vb2_buf.req_obj.req)
>> +		v4l2_ctrl_request_complete(dst_buf-
>>> vb2_buf.req_obj.req,
>> +					&ctx->hdl);
>> +
>>  	/* Run a timer, which simulates a hardware irq  */
>>  	schedule_irq(dev, ctx->transtime);
>>  }
>> @@ -823,6 +841,8 @@ static void vim2m_stop_streaming(struct vb2_queue
>> *q)
>>  			vbuf = v4l2_m2m_dst_buf_remove(ctx-
>>> fh.m2m_ctx);
>>  		if (vbuf == NULL)
>>  			return;
>> +		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
>> +					   &ctx->hdl);
>>  		spin_lock_irqsave(&ctx->dev->irqlock, flags);
>>  		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
>>  		spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
>> @@ -1003,6 +1023,10 @@ static const struct v4l2_m2m_ops m2m_ops = {
>>  	.job_abort	= job_abort,
>>  };
>>  
>> +static const struct media_device_ops m2m_media_ops = {
>> +	.req_queue = vb2_request_queue,
>> +};
>> +
>>  static int vim2m_probe(struct platform_device *pdev)
>>  {
>>  	struct vim2m_dev *dev;
>> @@ -1027,6 +1051,7 @@ static int vim2m_probe(struct platform_device
>> *pdev)
>>  	dev->mdev.dev = &pdev->dev;
>>  	strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
>>  	media_device_init(&dev->mdev);
>> +	dev->mdev.ops = &m2m_media_ops;
>>  	dev->v4l2_dev.mdev = &dev->mdev;
>>  	dev->pad[0].flags = MEDIA_PAD_FL_SINK;
>>  	dev->pad[1].flags = MEDIA_PAD_FL_SOURCE;
