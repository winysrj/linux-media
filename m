Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73224C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 10:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4421820823
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 10:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfARKYH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 05:24:07 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56195 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbfARKYH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 05:24:07 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gkRJl-00021k-Nj; Fri, 18 Jan 2019 11:24:05 +0100
Message-ID: <1547807043.3375.3.camel@pengutronix.de>
Subject: Re: [PATCH v2 1/2] media: imx: csi: Disable CSI immediately after
 last EOF
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Fri, 18 Jan 2019 11:24:03 +0100
In-Reply-To: <20190117204912.28456-2-slongerbeam@gmail.com>
References: <20190117204912.28456-1-slongerbeam@gmail.com>
         <20190117204912.28456-2-slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 2019-01-17 at 12:49 -0800, Steve Longerbeam wrote:
> Disable the CSI immediately after receiving the last EOF before stream
> off (and thus before disabling the IDMA channel).
> 
> This fixes a complete system hard lockup on the SabreAuto when streaming
> from the ADV7180, by repeatedly sending a stream off immediately followed
> by stream on:
> 
> while true; do v4l2-ctl  -d4 --stream-mmap --stream-count=3; done
> 
> Eventually this either causes the system lockup or EOF timeouts at all
> subsequent stream on, until a system reset.
> 
> The lockup occurs when disabling the IDMA channel at stream off. Disabling
> the CSI before disabling the IDMA channel appears to be a reliable fix for
> the hard lockup.
>
> Fixes: 4a34ec8e470cb ("[media] media: imx: Add CSI subdev driver")
> 
> Reported-by: Gaël PORTAY <gael.portay@collabora.com>
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> Cc: stable@vger.kernel.org
> ---
> Changes in v2:
> - restore an empty line
> - Add Fixes: and Cc: stable
> ---
>  drivers/staging/media/imx/imx-media-csi.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index e18f58f56dfb..e0f6f88e2e70 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -681,6 +681,8 @@ static void csi_idmac_stop(struct csi_priv *priv)
>  	if (ret == 0)
>  		v4l2_warn(&priv->sd, "wait last EOF timeout\n");
>  
> +	ipu_csi_disable(priv->csi);
> +

Can you add a short comment why this call is here? Since now
csi_idmac_stop is kind of a misnomer and symmetry with csi(_idmac)_start
is broken, I think this is a bit un-obvious.

Also note that now the error path of csi_start() will now call
ipu_csi_disable() while the CSI is disabled. This happens to work
because that just calls ipu_module_disable(), which is not refcounted.

>  	devm_free_irq(priv->dev, priv->eof_irq, priv);
>  	devm_free_irq(priv->dev, priv->nfb4eof_irq, priv);
>  
> @@ -793,9 +795,9 @@ static void csi_stop(struct csi_priv *priv)
>  		/* stop the frame interval monitor */
>  		if (priv->fim)
>  			imx_media_fim_set_stream(priv->fim, NULL, false);
> +	} else {
> +		ipu_csi_disable(priv->csi);
>  	}
> -
> -	ipu_csi_disable(priv->csi);

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
