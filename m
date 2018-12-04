Return-Path: <SRS0=WxzW=ON=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93789C04EB8
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 18:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3591320834
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 18:51:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3591320834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mess.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbeLDSvs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 13:51:48 -0500
Received: from gofer.mess.org ([88.97.38.141]:54727 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbeLDSvs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Dec 2018 13:51:48 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 00C8B60825; Tue,  4 Dec 2018 18:51:46 +0000 (GMT)
Date:   Tue, 4 Dec 2018 18:51:46 +0000
From:   Sean Young <sean@mess.org>
To:     Malcolm Priestley <tvboxspy@gmail.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] media: lmedm04: Add missing usb_free_urb to free,
 interrupt urb
Message-ID: <20181204185146.5sylezcoyshnb2o4@gofer.mess.org>
References: <e967120b-eceb-f841-075c-aa2c15ada987@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e967120b-eceb-f841-075c-aa2c15ada987@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Nov 29, 2018 at 10:29:31PM +0000, Malcolm Priestley wrote:
> The interrupt urb is killed but never freed add the function
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/media/usb/dvb-usb-v2/lmedm04.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> index f109c04f05ae..8b405e131439 100644
> --- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
> +++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> @@ -1264,6 +1264,7 @@ static void *lme2510_exit_int(struct dvb_usb_device *d)
>  
>  	if (st->lme_urb != NULL) {
>  		usb_kill_urb(st->lme_urb);
> +		usb_free_urb(st->lme_urb);

Now st->lme_urb is a stale pointer.

>  		usb_free_coherent(d->udev, 128, st->buffer,
>  				  st->lme_urb->transfer_dma);

And now you're following it.

>  		info("Interrupt Service Stopped");
> -- 
> 2.19.1
