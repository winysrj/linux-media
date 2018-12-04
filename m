Return-Path: <SRS0=WxzW=ON=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7793C04EB8
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 18:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EC262081C
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 18:55:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EC262081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mess.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbeLDSz0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 13:55:26 -0500
Received: from gofer.mess.org ([88.97.38.141]:56889 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbeLDSzZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Dec 2018 13:55:25 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 8CA5060825; Tue,  4 Dec 2018 18:55:24 +0000 (GMT)
Date:   Tue, 4 Dec 2018 18:55:24 +0000
From:   Sean Young <sean@mess.org>
To:     Malcolm Priestley <tvboxspy@gmail.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/4] media: lmedm04: Move interrupt buffer to priv buffer.
Message-ID: <20181204185524.itmelvz6fwadtlkp@gofer.mess.org>
References: <a54f1631-4279-f580-9a61-75472b2b90e2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a54f1631-4279-f580-9a61-75472b2b90e2@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Nov 29, 2018 at 10:30:15PM +0000, Malcolm Priestley wrote:
> Interrupt is always present throught life time of
> there is no dma element move this buffer to private
> area of driver.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/media/usb/dvb-usb-v2/lmedm04.c | 26 +++++++++-----------------
>  1 file changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> index 8fb53b83c914..7b1aaed259db 100644
> --- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
> +++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> @@ -134,7 +134,7 @@ struct lme2510_state {
>  	u8 stream_on;
>  	u8 pid_size;
>  	u8 pid_off;
> -	void *buffer;
> +	u8 int_buffer[128];
>  	struct urb *lme_urb;
>  	u8 usb_buffer[64];
>  	/* Frontend original calls */
> @@ -408,20 +408,14 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
>  	if (lme_int->lme_urb == NULL)
>  			return -ENOMEM;
>  
> -	lme_int->buffer = usb_alloc_coherent(d->udev, 128, GFP_ATOMIC,
> -					&lme_int->lme_urb->transfer_dma);
> -

The buffer was allocated with usb_alloc_coherent, however now it is
allocated with kmalloc. 

> -	if (lme_int->buffer == NULL)
> -			return -ENOMEM;
> -
>  	usb_fill_int_urb(lme_int->lme_urb,
> -				d->udev,
> -				usb_rcvintpipe(d->udev, 0xa),
> -				lme_int->buffer,
> -				128,
> -				lme2510_int_response,
> -				adap,
> -				8);
> +			 d->udev,
> +			 usb_rcvintpipe(d->udev, 0xa),
> +			 lme_int->int_buffer,
> +			 sizeof(lme_int->int_buffer),
> +			 lme2510_int_response,
> +			 adap,
> +			 8);
>  
>  	/* Quirk of pipe reporting PIPE_BULK but behaves as interrupt */
>  	ep = usb_pipe_endpoint(d->udev, lme_int->lme_urb->pipe);

On line 408:
        lme_int->lme_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;

This requires usb_alloc_coherent().

> @@ -1245,11 +1239,9 @@ static void lme2510_exit(struct dvb_usb_device *d)
>  		lme2510_kill_urb(&adap->stream);
>  	}
>  
> -	if (st->lme_urb != NULL) {
> +	if (st->lme_urb) {
>  		usb_kill_urb(st->lme_urb);
>  		usb_free_urb(st->lme_urb);
> -		usb_free_coherent(d->udev, 128, st->buffer,
> -				  st->lme_urb->transfer_dma);
>  		info("Interrupt Service Stopped");
>  	}
>  }
> -- 
> 2.19.1
