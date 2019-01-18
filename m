Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52378C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 14:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23C632086D
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 14:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfAROeq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 09:34:46 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45150 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbfAROeq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 09:34:46 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gportay)
        with ESMTPSA id E5585260704
Subject: Re: [PATCH v2 1/2] media: imx: csi: Disable CSI immediately after
 last EOF
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190117204912.28456-1-slongerbeam@gmail.com>
 <20190117204912.28456-2-slongerbeam@gmail.com>
From:   Gael PORTAY <gael.portay@collabora.com>
Message-ID: <d3f6db48-5ce2-5bd0-8c83-1a92598abf0e@collabora.com>
Date:   Fri, 18 Jan 2019 09:34:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190117204912.28456-2-slongerbeam@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Steeve, all,

On 1/17/19 3:49 PM, Steve Longerbeam wrote:
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
>   drivers/staging/media/imx/imx-media-csi.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index e18f58f56dfb..e0f6f88e2e70 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -681,6 +681,8 @@ static void csi_idmac_stop(struct csi_priv *priv)
>   	if (ret == 0)
>   		v4l2_warn(&priv->sd, "wait last EOF timeout\n");
>   
> +	ipu_csi_disable(priv->csi);
> +
>   	devm_free_irq(priv->dev, priv->eof_irq, priv);
>   	devm_free_irq(priv->dev, priv->nfb4eof_irq, priv);
>   
> @@ -793,9 +795,9 @@ static void csi_stop(struct csi_priv *priv)
>   		/* stop the frame interval monitor */
>   		if (priv->fim)
>   			imx_media_fim_set_stream(priv->fim, NULL, false);
> +	} else {
> +		ipu_csi_disable(priv->csi);
>   	}
> -
> -	ipu_csi_disable(priv->csi);
>   }
>   
>   static const struct csi_skip_desc csi_skip[12] = {
> 

Tested-by: Gaël PORTAY <gael.portay@collabora.com>

Thanks,
Gael
