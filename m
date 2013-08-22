Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:54589 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab3HVMcn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 08:32:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH v1 42/49] media: dvb-core: prepare for enabling irq in complete()
Date: Thu, 22 Aug 2013 14:32:39 +0200
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1376756714-25479-1-git-send-email-ming.lei@canonical.com> <1376756714-25479-43-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1376756714-25479-43-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308221432.39636.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat 17 August 2013 18:25:07 Ming Lei wrote:
> Complete() will be run with interrupt enabled, so change to
> spin_lock_irqsave().
> 
> These functions may be called inside URB->complete(), so use
> spin_lock_irqsave().
> 
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Note: Mauro needs to Ack this as well. It looks good to me, but I don't
maintain dvb code.

Regards,

	Hans

> ---
>  drivers/media/dvb-core/dvb_demux.c |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
> index 3485655..58de441 100644
> --- a/drivers/media/dvb-core/dvb_demux.c
> +++ b/drivers/media/dvb-core/dvb_demux.c
> @@ -476,7 +476,9 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
>  void dvb_dmx_swfilter_packets(struct dvb_demux *demux, const u8 *buf,
>  			      size_t count)
>  {
> -	spin_lock(&demux->lock);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&demux->lock, flags);
>  
>  	while (count--) {
>  		if (buf[0] == 0x47)
> @@ -484,7 +486,7 @@ void dvb_dmx_swfilter_packets(struct dvb_demux *demux, const u8 *buf,
>  		buf += 188;
>  	}
>  
> -	spin_unlock(&demux->lock);
> +	spin_unlock_irqrestore(&demux->lock, flags);
>  }
>  
>  EXPORT_SYMBOL(dvb_dmx_swfilter_packets);
> @@ -519,8 +521,9 @@ static inline void _dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf,
>  {
>  	int p = 0, i, j;
>  	const u8 *q;
> +	unsigned long flags;
>  
> -	spin_lock(&demux->lock);
> +	spin_lock_irqsave(&demux->lock, flags);
>  
>  	if (demux->tsbufp) { /* tsbuf[0] is now 0x47. */
>  		i = demux->tsbufp;
> @@ -564,7 +567,7 @@ static inline void _dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf,
>  	}
>  
>  bailout:
> -	spin_unlock(&demux->lock);
> +	spin_unlock_irqrestore(&demux->lock, flags);
>  }
>  
>  void dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf, size_t count)
> @@ -581,11 +584,13 @@ EXPORT_SYMBOL(dvb_dmx_swfilter_204);
>  
>  void dvb_dmx_swfilter_raw(struct dvb_demux *demux, const u8 *buf, size_t count)
>  {
> -	spin_lock(&demux->lock);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&demux->lock, flags);
>  
>  	demux->feed->cb.ts(buf, count, NULL, 0, &demux->feed->feed.ts, DMX_OK);
>  
> -	spin_unlock(&demux->lock);
> +	spin_unlock_irqrestore(&demux->lock, flags);
>  }
>  EXPORT_SYMBOL(dvb_dmx_swfilter_raw);
>  
> 
