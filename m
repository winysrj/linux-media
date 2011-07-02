Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44559 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab1GBUKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2011 16:10:00 -0400
Date: Sat, 2 Jul 2011 22:09:54 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	kernel@pengutronix.de
Subject: Re: [PATCH] media/at91sam9x5-video: new driver for the high end
 overlay on at91sam9x5
Message-ID: <20110702200954.GZ11559@pengutronix.de>
References: <1309377531-9246-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <4E0E3A20.6040002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E0E3A20.6040002@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Sylwester,

thanks for your feedback. A few comments below. For the statements I
don't reply to, you can consider a "OK, will be fixed in v2".

On Fri, Jul 01, 2011 at 11:20:32PM +0200, Sylwester Nawrocki wrote:
> On 06/29/2011 09:58 PM, Uwe Kleine-König wrote:
> > +	if (handled&  heoimr)
> > +		return IRQ_HANDLED;
> > +	else
> 
> else could be omitted
I like the else, but don't care much.
 
> > +	if (rect->left<  0)
> > +		hwxpos = 0;
> > +	else
> > +		hwxpos = rect->left;
> 
> Could be rewritten as:
> 
> 	hwxpos = rect->left < 0 ? 0 : rect->left;
could even be rewritten as

	hwxpos = max(rect->left, 0);
 
> > +static void at91sam9x5_video_vb_wait_prepare(struct vb2_queue *q)
> > +{
> > +	struct at91sam9x5_video_priv *priv =
> > +		container_of(q, struct at91sam9x5_video_priv, queue);
> > +	unsigned long flags;
> > +
> > +	debug("cfgupdate=%d hwstate=%d cfgstate=%d\n",
> > +			priv->cfgupdate, priv->hwstate, priv->cfgstate);
> > +	debug("bufs=%p,%p\n", priv->cur.vb, priv->next.vb);
> > +	spin_lock_irqsave(&priv->lock, flags);
> > +
> > +	at91sam9x5_video_handle_irqstat(priv);
> > +
> > +	at91sam9x5_video_write32(priv, REG_HEOIER,
> > +			REG_HEOIxR_ADD | REG_HEOIxR_DMA |
> > +			REG_HEOIxR_UADD | REG_HEOIxR_UDMA |
> > +			REG_HEOIxR_VADD | REG_HEOIxR_VDMA);
> 
> What the above two calls are intended to be doing ?
handle_irqstat handles the eventual pending irqs. The second call
enables irqs for "frame done" (..._DMA) and "new descriptor loaded"
(..._ADD).

> > +const struct vb2_ops at91sam9x5_video_vb_ops = {
> > +	.queue_setup = at91sam9x5_video_vb_queue_setup,
> > +
> > +	.wait_prepare = at91sam9x5_video_vb_wait_prepare,
> > +	.wait_finish = at91sam9x5_video_vb_wait_finish,
> 
> These 2 functions are intended to unlock and lock respectively the mutex
> that is used to serialize ioctl handlers, in particular DQBUF.
> I'm not sure if you're doing the right thing in 
> at91sam9x5_video_vb_wait_prepare/at91sam9x5_video_vb_wait_finish. 
I'm not taking a mutex for sure.
 
> > +
> > +	.buf_prepare = at91sam9x5_video_vb_buf_prepare,
> > +	.buf_queue = at91sam9x5_video_vb_buf_queue,
> > +};
> > +
> > +static int at91sam9x5_video_vidioc_querycap(struct file *filp,
> > +		void *fh, struct v4l2_capability *cap)
> > +{
> > +	strcpy(cap->driver, DRIVER_NAME);
> > +	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING |
> > +		V4L2_CAP_VIDEO_OVERLAY;
> > +
> > +	/* XXX */
> > +	cap->version = 0;
> 
> There is no need to set this field any more. It will be overwritten
> with kernel versions in __video_do_ioctl(). See this for more details:
> http://git.linuxtv.org/media_tree.git?a=commit;h=33436a81b0d4d1036ffcf0edb7e3bfa65d18ad08
I saw the discussion on the ML, but missed that it was already
committed.

> > +	cap->card[0] = '\0';
> > +	cap->bus_info[0] = '\0';
I assume I need to fill these with more sensible values?

> > +static int __init at91sam9x5_video_init(void)
> > +{
> > +	/* XXX: register the device in arch/arm/mach-at91 */
> > +	int ret;
> > +	const struct resource res[] = {
> > +		{
> > +			.start = 0xf8038280,
> > +			.end = 0xf803833f,
> > +			.flags = IORESOURCE_MEM,
> > +		}, {
> > +			.start = 25,
> > +			.end = 25,
> > +			.flags = IORESOURCE_IRQ,
> > +		},
> > +	};
> > +	const struct at91sam9x5_video_pdata pdata = {
> > +		.base_width = 800,
> > +		.base_height = 480,
> > +	};
> 
> What is it needed for ? Couldn't it be hard coded in the driver
> or queried somehow ?
Ah, this isn't needed any more since I use the fbinfo to get the same
info. I will just remove that.
 
Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
