Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4258 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaHKMPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 08:15:18 -0400
Message-ID: <53E8B3AA.2000509@xs4all.nl>
Date: Mon, 11 Aug 2014 14:14:34 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ian Molton <ian.molton@codethink.co.uk>
CC: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	g.liakhovetski@gmx.de, m.chehab@samsung.com,
	vladimir.barinov@cogentembedded.com, magnus.damm@gmail.com,
	horms@verge.net.au, linux-sh@vger.kernel.org
Subject: Re: [PATCH 3/4] media: rcar_vin: Fix race condition terminating stream
References: <1404812474-7627-1-git-send-email-ian.molton@codethink.co.uk>	<1404812474-7627-4-git-send-email-ian.molton@codethink.co.uk>	<53DFFABC.9000800@xs4all.nl> <20140811122343.858030a5082cfe1723acec4c@codethink.co.uk>
In-Reply-To: <20140811122343.858030a5082cfe1723acec4c@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/2014 01:23 PM, Ian Molton wrote:
> On Mon, 04 Aug 2014 23:27:24 +0200
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>>> +/*
>>> + * Wait for capture to stop and all in-flight buffers to be finished with by
>>> + * the video hardware. This must be called under &priv->lock
>>> + *
>>> + */
>>> +static void rcar_vin_wait_stop_streaming(struct rcar_vin_priv *priv)
>>> +{
>>> +	while (priv->state != STOPPED) {
>>> +
>>> +		/* issue stop if running */
>>> +		if (priv->state == RUNNING)
>>> +			rcar_vin_request_capture_stop(priv);
>>> +
>>> +		/* wait until capturing has been stopped */
>>> +		if (priv->state == STOPPING) {
>>> +			priv->request_to_stop = true;
>>> +			spin_unlock_irq(&priv->lock);
>>> +			wait_for_completion(&priv->capture_stop);
>>> +			spin_lock_irq(&priv->lock);
>>> +		}
>>> +	}
>>> +}
>>> +
>>>  static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
>>>  {
>>>  	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
>>> @@ -462,7 +485,6 @@ static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
>>>  	struct rcar_vin_priv *priv = ici->priv;
>>>  	unsigned int i;
>>>  	int buf_in_use = 0;
>>> -
>>>  	spin_lock_irq(&priv->lock);
>>>  
>>>  	/* Is the buffer in use by the VIN hardware? */
>>> @@ -474,20 +496,8 @@ static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
>>>  	}
>>>  
>>>  	if (buf_in_use) {
>>> -		while (priv->state != STOPPED) {
>>> -
>>> -			/* issue stop if running */
>>> -			if (priv->state == RUNNING)
>>> -				rcar_vin_request_capture_stop(priv);
>>> -
>>> -			/* wait until capturing has been stopped */
>>> -			if (priv->state == STOPPING) {
>>> -				priv->request_to_stop = true;
>>> -				spin_unlock_irq(&priv->lock);
>>> -				wait_for_completion(&priv->capture_stop);
>>> -				spin_lock_irq(&priv->lock);
>>> -			}
>>> -		}
>>> +		rcar_vin_wait_stop_streaming(priv);
>>> +
>>
>> Why on earth would videobuf_release call stop_streaming()?
> 
> It doesn't. But it appears it can be called whilst the driver still
> possesses the buffer, in which case, the driver (as was) would
> request capture stop, and wait for the buffer to be returned from the
> driver.
> 
> This logic here has not been changed, merely moved out to an
> appropriately named function, so that it can be re-used in
> rcar_vin_stop_streaming().
> 
>> You start streaming in the start_streaming op, not in the buf_queue op. If you
>> need a certain minimum of buffers before start_streaming can be called, then just
>> set min_buffers_needed in struct vb2_queue.
> 
> I can submit an additional patch to correct this behaviour in the rcar_vin driver, if that would be helpful?

Please do. The vb2 framework is great, but not if try to second-guess it.
I can guarantee that the current approach will fail in all sorts of subtle
ways. Frankly, I'm surprised it works at all!
 
>> And stop streaming happens in stop_streaming. The various vb2 queue ops should just
>> do what the op name says. That way everything works nicely together and it makes
>> your driver much easier to understand.
> 
> Agreed. It was particularly difficult to understand WTH this driver was doing.

If you can, take kernel 3.15 or 3.16, enable CONFIG_VIDEO_ADV_DEBUG and then
rewrite that code. A good template for the vb2 part might be
Documentation/video4linux/v4l2-pci-skeleton.c.

Looking at the rcar code I think that you only have to implement buf_queue and
start/stop_streaming and can ditch buf_init/cleanup altogether. The stop_streaming
op is the crucial one since that's where you have to stop the DMA, wait (if needed)
for the hardware to access any remaining buffers and return those buffers to the
vb2 framework.

If you try that and test with CONFIG_VIDEO_ADV_DEBUG on, then the vb2 instrumentation
I added will tell you if there are any remaining issues. Also test what happens if
start_streaming fails (assuming it can fail).

I also recommend testing with the v4l2-compliance tool from v4l-utils.git. See what
works/breaks.

If you have questions, don't hesitate to contact me.

Regards,

	Hans

> 
>> Sorry I am late in reviewing this, but I only now stumbled on these patches.
> 
> Thanks for the review!
> 
> -Ian
> 
>>>  		/*
>>>  		 * Capturing has now stopped. The buffer we have been asked
>>>  		 * to release could be any of the current buffers in use, so
>>> @@ -517,12 +527,15 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
>>>  
>>>  	spin_lock_irq(&priv->lock);
>>>  
>>> +	rcar_vin_wait_stop_streaming(priv);
>>> +
>>>  	for (i = 0; i < vq->num_buffers; ++i)
>>>  		if (vq->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
>>>  			vb2_buffer_done(vq->bufs[i], VB2_BUF_STATE_ERROR);
>>>  
>>>  	list_for_each_safe(buf_head, tmp, &priv->capture)
>>>  		list_del_init(buf_head);
>>> +
>>>  	spin_unlock_irq(&priv->lock);
>>>  }
>>>  
>>>
>>
>>
>>
> 
> 

