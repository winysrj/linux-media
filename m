Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F17AC07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 261FA20989
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:02:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 261FA20989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbeLGNCH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:02:07 -0500
Received: from mail.bootlin.com ([62.4.15.54]:56766 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbeLGNCH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 08:02:07 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 065F320784; Fri,  7 Dec 2018 14:02:05 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id BA60120510;
        Fri,  7 Dec 2018 14:02:04 +0100 (CET)
Message-ID: <fef52c8e926cebbf58e9b84b1c7e07d783f1ff28.camel@bootlin.com>
Subject: Re: [PATCH] media: cetrus: return an error if alloc fails
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
Date:   Fri, 07 Dec 2018 14:02:05 +0100
In-Reply-To: <7d746ddf408ab1bc100d4d676daf3e2400637fbe.1544181226.git.mchehab+samsung@kernel.org>
References: <7d746ddf408ab1bc100d4d676daf3e2400637fbe.1544181226.git.mchehab+samsung@kernel.org>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Fri, 2018-12-07 at 06:13 -0500, Mauro Carvalho Chehab wrote:
> As warned by smatch:
> 
> 	drivers/staging/media/sunxi/cedrus/cedrus.c: drivers/staging/media/sunxi/cedrus/cedrus.c:93 cedrus_init_ctrls() error: potential null dereference 'ctx->ctrls'.  (kzalloc returns null)
> 
> While here, remove the memset(), as kzalloc() already zeroes the
> struct.

Good catch, thanks for the patch!

> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

> ---
>  drivers/staging/media/sunxi/cedrus/cedrus.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
> index 44c45c687503..24b89cd2b692 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
> @@ -72,7 +72,8 @@ static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx *ctx)
>  	ctrl_size = sizeof(ctrl) * CEDRUS_CONTROLS_COUNT + 1;
>  
>  	ctx->ctrls = kzalloc(ctrl_size, GFP_KERNEL);
> -	memset(ctx->ctrls, 0, ctrl_size);
> +	if (!ctx->ctrls)
> +		return -ENOMEM;
>  
>  	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
>  		struct v4l2_ctrl_config cfg = { NULL };
-- 
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

