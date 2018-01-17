Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43057 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbeAQJoS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 04:44:18 -0500
Message-ID: <1516182255.11434.1.camel@pengutronix.de>
Subject: Re: [RFT PATCH v3 4/6] uvcvideo: queue: Simplify spin-lock usage
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>
Date: Wed, 17 Jan 2018 10:44:15 +0100
In-Reply-To: <1566744.FFqUaHsn7F@avalon>
References: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
         <9f83cda1d54615e068c20fcadf69a1f09ae50ec1.1515748369.git-series.kieran.bingham@ideasonboard.com>
         <1566744.FFqUaHsn7F@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-01-16 at 19:23 +0200, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Friday, 12 January 2018 11:19:26 EET Kieran Bingham wrote:
> > Both uvc_start_streaming(), and uvc_stop_streaming() are called from
> > userspace context. As such, they do not need to save the IRQ state, and
> > can use spin_lock_irq() and spin_unlock_irq() respectively.
> 
> Note that userspace context isn't enough, the key part is that they're called 
> with interrupts enabled. If they were called from userspace context but under 
> a spin_lock_irq() you couldn't use spin_unlock_irq() in those functions.
> 
> > Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> > ---
> >  drivers/media/usb/uvc/uvc_queue.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_queue.c
> > b/drivers/media/usb/uvc/uvc_queue.c index 4a581d631525..ddac4d89a291 100644
> > --- a/drivers/media/usb/uvc/uvc_queue.c
> > +++ b/drivers/media/usb/uvc/uvc_queue.c
> > @@ -158,7 +158,6 @@ static int uvc_start_streaming(struct vb2_queue *vq,
> > unsigned int count) {
> >  	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
> >  	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
> > -	unsigned long flags;
> >  	int ret;
> > 
> >  	queue->buf_used = 0;
> > @@ -167,9 +166,9 @@ static int uvc_start_streaming(struct vb2_queue *vq,
> > unsigned int count) if (ret == 0)
> >  		return 0;
> > 
> > -	spin_lock_irqsave(&queue->irqlock, flags);
> > +	spin_lock_irq(&queue->irqlock);
> >  	uvc_queue_return_buffers(queue, UVC_BUF_STATE_QUEUED);
> > -	spin_unlock_irqrestore(&queue->irqlock, flags);
> > +	spin_unlock_irq(&queue->irqlock);
> > 
> >  	return ret;
> >  }
> > @@ -178,13 +177,12 @@ static void uvc_stop_streaming(struct vb2_queue *vq)
> >  {
> >  	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
> >  	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
> > -	unsigned long flags;
> > 
> >  	uvc_video_enable(stream, 0);
> > 
> > -	spin_lock_irqsave(&queue->irqlock, flags);
> > +	spin_lock_irq(&queue->irqlock);
> >  	uvc_queue_return_buffers(queue, UVC_BUF_STATE_ERROR);
> > -	spin_unlock_irqrestore(&queue->irqlock, flags);
> > +	spin_unlock_irq(&queue->irqlock);
> >  }
> 
> Please add a one-line comment above both functions to state
> 
> /* Must be called with interrupts enabled. */

You could add lockdep_assert_irqs_enabled() as well.

> With this and the commit message updated,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

regards
Philipp
