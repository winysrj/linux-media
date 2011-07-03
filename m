Return-path: <mchehab@pedra>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:65322 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab1GCP3b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 11:29:31 -0400
Received: by fxd18 with SMTP id 18so4553324fxd.11
        for <linux-media@vger.kernel.org>; Sun, 03 Jul 2011 08:29:29 -0700 (PDT)
Message-ID: <4E108AD5.8080700@gmail.com>
Date: Sun, 03 Jul 2011 17:29:25 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?=
	<u.kleine-koenig@pengutronix.de>
CC: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	kernel@pengutronix.de
Subject: Re: [PATCH] media/at91sam9x5-video: new driver for the high end overlay
 on at91sam9x5
References: <1309377531-9246-1-git-send-email-u.kleine-koenig@pengutronix.de> <4E0E3A20.6040002@gmail.com> <20110702200954.GZ11559@pengutronix.de>
In-Reply-To: <20110702200954.GZ11559@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Uwe,

On 07/02/2011 10:09 PM, Uwe Kleine-König wrote:
> Hello Sylwester,
> 
> thanks for your feedback. A few comments below. For the statements I
> don't reply to, you can consider a "OK, will be fixed in v2".
> 
> On Fri, Jul 01, 2011 at 11:20:32PM +0200, Sylwester Nawrocki wrote:
>> On 06/29/2011 09:58 PM, Uwe Kleine-König wrote:
>>> +	if (handled&   heoimr)
>>> +		return IRQ_HANDLED;
>>> +	else
>>
>> else could be omitted
> I like the else, but don't care much.

sure, it was purely a personal preference.

>>> +	if (rect->left<   0)
>>> +		hwxpos = 0;
>>> +	else
>>> +		hwxpos = rect->left;
>>
>> Could be rewritten as:
>>
>> 	hwxpos = rect->left<  0 ? 0 : rect->left;
> could even be rewritten as
> 
> 	hwxpos = max(rect->left, 0);

ok, I give up, couldn't make it any simpler;)

> 
>>> +static void at91sam9x5_video_vb_wait_prepare(struct vb2_queue *q)
>>> +{
>>> +	struct at91sam9x5_video_priv *priv =
>>> +		container_of(q, struct at91sam9x5_video_priv, queue);
>>> +	unsigned long flags;
>>> +
>>> +	debug("cfgupdate=%d hwstate=%d cfgstate=%d\n",
>>> +			priv->cfgupdate, priv->hwstate, priv->cfgstate);
>>> +	debug("bufs=%p,%p\n", priv->cur.vb, priv->next.vb);
>>> +	spin_lock_irqsave(&priv->lock, flags);
>>> +
>>> +	at91sam9x5_video_handle_irqstat(priv);
>>> +
>>> +	at91sam9x5_video_write32(priv, REG_HEOIER,
>>> +			REG_HEOIxR_ADD | REG_HEOIxR_DMA |
>>> +			REG_HEOIxR_UADD | REG_HEOIxR_UDMA |
>>> +			REG_HEOIxR_VADD | REG_HEOIxR_VDMA);
>>
>> What the above two calls are intended to be doing ?
>
> handle_irqstat handles the eventual pending irqs. The second call
> enables irqs for "frame done" (..._DMA) and "new descriptor loaded"
> (..._ADD).

OK, so it looks to me like irqs are unmasked in wait_prepare and masked
back in wait_finish. I would try to move this logic to start_streaming and
the interrupt handler.
It seems this way too much dependant on when wait_prepare/wait_finish are
called by videobuf2. AFAIK those callbacks are not called in non-blocking
mode.

> 
>>> +const struct vb2_ops at91sam9x5_video_vb_ops = {
>>> +	.queue_setup = at91sam9x5_video_vb_queue_setup,
>>> +
>>> +	.wait_prepare = at91sam9x5_video_vb_wait_prepare,
>>> +	.wait_finish = at91sam9x5_video_vb_wait_finish,
>>
>> These 2 functions are intended to unlock and lock respectively the mutex
>> that is used to serialize ioctl handlers, in particular DQBUF.
>> I'm not sure if you're doing the right thing in
>> at91sam9x5_video_vb_wait_prepare/at91sam9x5_video_vb_wait_finish.
> I'm not taking a mutex for sure.

All right, so this needs to be changed. If you decide to add a file
operations mutex and protect each file operation individually in the driver,
rather than assigning a pointer to such mutex to struct video_device::lock
and let the core serialize file ops, then wait_prepare/wait_finish
could be omitted.

> 
>>> +
>>> +	.buf_prepare = at91sam9x5_video_vb_buf_prepare,
>>> +	.buf_queue = at91sam9x5_video_vb_buf_queue,
>>> +};

Also if your driver is supposed to support write() method,
vidioc_streamon/vidioc_streamoff should be just a pass-through for
vb2_streamon/vb2_streamoff and the hardware control should happen in
start_streaming, stop_streaming callbacks.

I can't see a stop_streaming callback in your vb2 operations set.
It's been made mandatory recently, thus it would be good to add it.

>>> +
>>> +static int at91sam9x5_video_vidioc_querycap(struct file *filp,
>>> +		void *fh, struct v4l2_capability *cap)
>>> +{
>>> +	strcpy(cap->driver, DRIVER_NAME);

I would go for a strlcpy here, better to be safe than sorry. ;-)

>>> +	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING |
>>> +		V4L2_CAP_VIDEO_OVERLAY;
>>> +
>>> +	/* XXX */
>>> +	cap->version = 0;
>>
>> There is no need to set this field any more. It will be overwritten
>> with kernel versions in __video_do_ioctl(). See this for more details:
>> http://git.linuxtv.org/media_tree.git?a=commit;h=33436a81b0d4d1036ffcf0edb7e3bfa65d18ad08
> I saw the discussion on the ML, but missed that it was already
> committed.
> 
>>> +	cap->card[0] = '\0';
>>> +	cap->bus_info[0] = '\0';
> I assume I need to fill these with more sensible values?

I think bus_info is not very useful for this driver and can be left as is.
As for cap->card, I'm not sure. Some drivers just just fill it in with
a video node name (/dev/video*), some are more creative.
Here is what the V4L2 specifications says:
http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-querycap.html

--
Regards,
Sylwester
