Return-Path: <SRS0=IHcP=PI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA38C43387
	for <linux-media@archiver.kernel.org>; Mon, 31 Dec 2018 10:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1859D21019
	for <linux-media@archiver.kernel.org>; Mon, 31 Dec 2018 10:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbeLaKae (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 31 Dec 2018 05:30:34 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55343 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbeLaKae (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Dec 2018 05:30:34 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gduq7-00009P-Ti; Mon, 31 Dec 2018 11:30:31 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gduq5-0001UZ-4z; Mon, 31 Dec 2018 11:30:29 +0100
Date:   Mon, 31 Dec 2018 11:30:29 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Akinobu Mita <akinobu.mita@gmail.com>
Cc:     linux-media@vger.kernel.org,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 1/4] media: mt9m111: fix setting pixclk polarity
Message-ID: <20181231103029.4qlr5fd2l3vwyeb7@pengutronix.de>
References: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
 <1546103258-29025-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546103258-29025-2-git-send-email-akinobu.mita@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:12:10 up 101 days, 22:26, 35 users,  load average: 0.19, 0.08,
 0.03
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Akinobu,

On 18-12-30 02:07, Akinobu Mita wrote:
> Since commit 98480d65c48c ("media: mt9m111: allow to setup pixclk
> polarity"), the MT9M111_OUTFMT_INV_PIX_CLOCK bit in the output format
> control 2 register has to be changed depending on the pclk-sample property
> setting.
> 
> Without this change, the MT9M111_OUTFMT_INV_PIX_CLOCK bit is unchanged.

I don't know what you mean, it will get applied depending on the
property.

8<------------------------------------------------------------------------
static int mt9m111_set_pixfmt(struct mt9m111 *mt9m111,
			      u32 code)
{

	...

	/* receiver samples on falling edge, chip-hw default is rising */
	if (mt9m111->pclk_sample == 0)
		mask_outfmt2 |= MT9M111_OUTFMT_INV_PIX_CLOCK;

	...
}

8<------------------------------------------------------------------------

Isn't this right?

Can you cc me the other patches too, so I can keep track of it easier?

Regards,
Marco

> 
> Fixes: 98480d65c48c ("media: mt9m111: allow to setup pixclk polarity")
> Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Cc: Marco Felsch <m.felsch@pengutronix.de>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/i2c/mt9m111.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
> index d639b9b..f0e47fd 100644
> --- a/drivers/media/i2c/mt9m111.c
> +++ b/drivers/media/i2c/mt9m111.c
> @@ -542,6 +542,7 @@ static int mt9m111_set_pixfmt(struct mt9m111 *mt9m111,
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
>  	u16 data_outfmt2, mask_outfmt2 = MT9M111_OUTFMT_PROCESSED_BAYER |
> +		MT9M111_OUTFMT_INV_PIX_CLOCK |
>  		MT9M111_OUTFMT_BYPASS_IFP | MT9M111_OUTFMT_RGB |
>  		MT9M111_OUTFMT_RGB565 | MT9M111_OUTFMT_RGB555 |
>  		MT9M111_OUTFMT_RGB444x | MT9M111_OUTFMT_RGBx444 |
> -- 
> 2.7.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
