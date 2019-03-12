Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2243C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F8462083D
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfCLPcf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:32:35 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51669 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfCLPce (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 11:32:34 -0400
X-Originating-IP: 90.88.22.102
Received: from aptenodytes (aaubervilliers-681-1-80-102.w90-88.abo.wanadoo.fr [90.88.22.102])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id CB95FE000E;
        Tue, 12 Mar 2019 15:32:31 +0000 (UTC)
Message-ID: <87eee8a06fba3882cbba472922d81cfeecd0c950.camel@bootlin.com>
Subject: Re: [PATCH v5 03/23] cedrus: set requires_requests
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Date:   Tue, 12 Mar 2019 16:32:31 +0100
In-Reply-To: <20190306211343.15302-4-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
         <20190306211343.15302-4-dafna3@gmail.com>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Wed, 2019-03-06 at 13:13 -0800, Dafna Hirschfeld wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> The cedrus stateless decoder requires the use of request, so
> indicate this by setting requires_requests to 1.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Note that this is true for now, but we might need to get rid of the
flag when adding support for decoding JPEG, which may not require the
request API.

Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> ---
>  drivers/staging/media/sunxi/cedrus/cedrus_video.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> index b47854b3bce4..9673874ece10 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> @@ -536,6 +536,7 @@ int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->lock = &ctx->dev->dev_mutex;
>  	src_vq->dev = ctx->dev->dev;
>  	src_vq->supports_requests = true;
> +	src_vq->requires_requests = true;
>  
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

