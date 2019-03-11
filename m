Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B3DC10F06
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 10:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC16020657
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 10:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbfCKKxH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 06:53:07 -0400
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:59524 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727099AbfCKKxH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 06:53:07 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 3IYHhPTfc4HFn3IYKhDBDS; Mon, 11 Mar 2019 11:53:05 +0100
Subject: Re: [PATCH] rcar-csi2: restart CSI-2 link if error is detected
To:     =?UTF-8?Q?Niklas_S=c3=b6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org
References: <20190218101541.15819-1-niklas.soderlund+renesas@ragnatech.se>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0fb0337f-32f7-729b-c30b-1453c3b6e901@xs4all.nl>
Date:   Mon, 11 Mar 2019 11:53:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190218101541.15819-1-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfIKMvlGYn4oHXtAHRo1LHbDgoJ5biEEJpDuKu4JtQ7X38NxBq27XPdCguEm5ZOoERhTOXXo05x4GxUoXvPfRG5JK/Fg3iiCtyuqhUZ/coCjYA+fNKeGc
 3vTA5jQusPyG1bvjro9U4BcN+Um5FHhoblarLU/M49riZ5nV6qbwALlkrfnxuwQ1AAK2o3j2PGk9j1r6vB+ykn8Y4yLCVSxIx/0rrjGNeS7g2dW4Y9MIDb/c
 MAVwKXzAmFkEx48tAUSKhino9xlGcHhBoFbmWjMv58IgE8yQdwTkiHVTFOoqkp5/4mvg7A4Pf21peZXNRsbQ3m9yCO2JxmOz4NgXAY7eRi4=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/18/19 11:15 AM, Niklas Söderlund wrote:
> Restart the CSI-2 link if the CSI-2 receiver detects an error during
> reception. The driver did nothing when a link error happened and the
> data flow simply stopped without the user knowing why.
> 
> Change the driver to try and recover from errors by restarting the link
> and informing the user that something is not right. For obvious reasons
> it's not possible to recover from all errors (video source disconnected
> for example) but in such cases the user is at least informed of the
> error and the same behavior of the stopped data flow is retained.

What you really would like to have is that when a CSI error is detected,
the CSI driver can ask upstream whether or not a disconnect has taken place.

If that was the case, then there is no point in restarting the CSI.

While a disconnect is very uncommon for a sensor, it is of course perfectly
normal if an HDMI-to-CSI bridge was connected to the CSI port.

Unfortunately, we don't have such functionality, but perhaps this is something
to think about?

This does mean, however, that I don't like the dev_err since it doesn't have
to be an error. I would suggest replacing the first dev_err by dev_info and
the second by dev_warn.

Regards,

	Hans

> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 52 ++++++++++++++++++++-
>  1 file changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index f90b380478775015..0506fe4106d5c012 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -84,6 +84,9 @@ struct rcar_csi2;
>  
>  /* Interrupt Enable */
>  #define INTEN_REG			0x30
> +#define INTEN_INT_AFIFO_OF		BIT(27)
> +#define INTEN_INT_ERRSOTHS		BIT(4)
> +#define INTEN_INT_ERRSOTSYNCHS		BIT(3)
>  
>  /* Interrupt Source Mask */
>  #define INTCLOSE_REG			0x34
> @@ -540,6 +543,10 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
>  	if (mbps < 0)
>  		return mbps;
>  
> +	/* Enable interrupts. */
> +	rcsi2_write(priv, INTEN_REG, INTEN_INT_AFIFO_OF | INTEN_INT_ERRSOTHS
> +		    | INTEN_INT_ERRSOTSYNCHS);
> +
>  	/* Init */
>  	rcsi2_write(priv, TREF_REG, TREF_TREF);
>  	rcsi2_write(priv, PHTC_REG, 0);
> @@ -702,6 +709,43 @@ static const struct v4l2_subdev_ops rcar_csi2_subdev_ops = {
>  	.pad	= &rcar_csi2_pad_ops,
>  };
>  
> +static irqreturn_t rcsi2_irq(int irq, void *data)
> +{
> +	struct rcar_csi2 *priv = data;
> +	u32 status, err_status;
> +
> +	status = rcsi2_read(priv, INTSTATE_REG);
> +	err_status = rcsi2_read(priv, INTERRSTATE_REG);
> +
> +	if (!status)
> +		return IRQ_HANDLED;
> +
> +	rcsi2_write(priv, INTSTATE_REG, status);
> +
> +	if (!err_status)
> +		return IRQ_HANDLED;
> +
> +	rcsi2_write(priv, INTERRSTATE_REG, err_status);
> +
> +	dev_err(priv->dev, "Transfer error, restarting CSI-2 receiver\n");
> +
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +static irqreturn_t rcsi2_irq_thread(int irq, void *data)
> +{
> +	struct rcar_csi2 *priv = data;
> +
> +	mutex_lock(&priv->lock);
> +	rcsi2_stop(priv);
> +	usleep_range(1000, 2000);
> +	if (rcsi2_start(priv))
> +		dev_err(priv->dev, "Failed to restart CSI-2 receiver\n");
> +	mutex_unlock(&priv->lock);
> +
> +	return IRQ_HANDLED;
> +}
> +
>  /* -----------------------------------------------------------------------------
>   * Async handling and registration of subdevices and links.
>   */
> @@ -982,7 +1026,7 @@ static int rcsi2_probe_resources(struct rcar_csi2 *priv,
>  				 struct platform_device *pdev)
>  {
>  	struct resource *res;
> -	int irq;
> +	int irq, ret;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	priv->base = devm_ioremap_resource(&pdev->dev, res);
> @@ -993,6 +1037,12 @@ static int rcsi2_probe_resources(struct rcar_csi2 *priv,
>  	if (irq < 0)
>  		return irq;
>  
> +	ret = devm_request_threaded_irq(&pdev->dev, irq, rcsi2_irq,
> +					rcsi2_irq_thread, IRQF_SHARED,
> +					KBUILD_MODNAME, priv);
> +	if (ret)
> +		return ret;
> +
>  	priv->rstc = devm_reset_control_get(&pdev->dev, NULL);
>  	if (IS_ERR(priv->rstc))
>  		return PTR_ERR(priv->rstc);
> 

