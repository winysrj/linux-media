Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D00C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 14:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FC8220855
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 14:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfAROgA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 09:36:00 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45194 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727342AbfAROgA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 09:36:00 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gportay)
        with ESMTPSA id 8D42227F68B
Subject: Re: [PATCH v2 2/2] media: imx: prpencvf: Disable CSI immediately
 after last EOF
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190117204912.28456-1-slongerbeam@gmail.com>
 <20190117204912.28456-3-slongerbeam@gmail.com>
From:   Gael PORTAY <gael.portay@collabora.com>
Message-ID: <a90723ee-6da1-e17b-95da-94b23a5a321a@collabora.com>
Date:   Fri, 18 Jan 2019 09:36:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190117204912.28456-3-slongerbeam@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Steve, all,

On 1/17/19 3:49 PM, Steve Longerbeam wrote:
> The CSI must be disabled immediately after receiving the last EOF before
> stream off (and thus before disabling the IDMA channel). This can be
> accomplished by moving upstream stream off to just after receiving the
> last EOF completion in prp_stop(). For symmetry also move upstream
> stream on to end of prp_start().
> 
> This fixes a complete system hard lockup on the SabreAuto when streaming
> from the ADV7180, by repeatedly sending a stream off immediately followed
> by stream on:
> 
> while true; do v4l2-ctl  -d1 --stream-mmap --stream-count=3; done
> 
> Eventually this either causes the system lockup or EOF timeouts at all
> subsequent stream on, until a system reset.
> 
> The lockup occurs when disabling the IDMA channel at stream off. Disabling
> the CSI before disabling the IDMA channel appears to be a reliable fix for
> the hard lockup.
> 
> Fixes: f0d9c8924e2c3 ("[media] media: imx: Add IC subdev drivers")
> 
> Reported-by: Gaël PORTAY <gael.portay@collabora.com>
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> Cc: stable@vger.kernel.org
> ---
> Changes in v2:
> - Add Fixes: and Cc: stable
> ---
>   drivers/staging/media/imx/imx-ic-prpencvf.c | 26 ++++++++++++++-------
>   1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
> index 33ada6612fee..f53cdb608528 100644
> --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
> +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
> @@ -707,12 +707,23 @@ static int prp_start(struct prp_priv *priv)
>   		goto out_free_nfb4eof_irq;
>   	}
>   
> +	/* start upstream */
> +	ret = v4l2_subdev_call(priv->src_sd, video, s_stream, 1);
> +	ret = (ret && ret != -ENOIOCTLCMD) ? ret : 0;
> +	if (ret) {
> +		v4l2_err(&ic_priv->sd,
> +			 "upstream stream on failed: %d\n", ret);
> +		goto out_free_eof_irq;
> +	}
> +
>   	/* start the EOF timeout timer */
>   	mod_timer(&priv->eof_timeout_timer,
>   		  jiffies + msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
>   
>   	return 0;
>   
> +out_free_eof_irq:
> +	devm_free_irq(ic_priv->dev, priv->eof_irq, priv);
>   out_free_nfb4eof_irq:
>   	devm_free_irq(ic_priv->dev, priv->nfb4eof_irq, priv);
>   out_unsetup:
> @@ -744,6 +755,12 @@ static void prp_stop(struct prp_priv *priv)
>   	if (ret == 0)
>   		v4l2_warn(&ic_priv->sd, "wait last EOF timeout\n");
>   
> +	/* stop upstream */
> +	ret = v4l2_subdev_call(priv->src_sd, video, s_stream, 0);
> +	if (ret && ret != -ENOIOCTLCMD)
> +		v4l2_warn(&ic_priv->sd,
> +			  "upstream stream off failed: %d\n", ret);
> +
>   	devm_free_irq(ic_priv->dev, priv->eof_irq, priv);
>   	devm_free_irq(ic_priv->dev, priv->nfb4eof_irq, priv);
>   
> @@ -1174,15 +1191,6 @@ static int prp_s_stream(struct v4l2_subdev *sd, int enable)
>   	if (ret)
>   		goto out;
>   
> -	/* start/stop upstream */
> -	ret = v4l2_subdev_call(priv->src_sd, video, s_stream, enable);
> -	ret = (ret && ret != -ENOIOCTLCMD) ? ret : 0;
> -	if (ret) {
> -		if (enable)
> -			prp_stop(priv);
> -		goto out;
> -	}
> -
>   update_count:
>   	priv->stream_count += enable ? 1 : -1;
>   	if (priv->stream_count < 0)
> 

Tested-by: Gaël PORTAY <gael.portay@collabora.com>

Thanks,
Gael
