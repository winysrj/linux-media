Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE1AC2F45C
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 16:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0272520663
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 16:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbfAUQuO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 11:50:14 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51511 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729815AbfAUQuO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 11:50:14 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1glcm4-0006ej-3G; Mon, 21 Jan 2019 17:50:12 +0100
Message-ID: <1548089410.3287.16.camel@pengutronix.de>
Subject: Re: [PATCH 1/4] media: imx: csi: Allow unknown nearest upstream
 entities
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 21 Jan 2019 17:50:10 +0100
In-Reply-To: <20190119214600.30897-2-slongerbeam@gmail.com>
References: <20190119214600.30897-1-slongerbeam@gmail.com>
         <20190119214600.30897-2-slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, 2019-01-19 at 13:45 -0800, Steve Longerbeam wrote:
> On i.MX6, the nearest upstream entity to the CSI can only be the
> CSI video muxes or the Synopsys DW MIPI CSI-2 receiver.
> 
> However the i.MX53 has no CSI video muxes or a MIPI CSI-2 receiver.
> So allow for the nearest upstream entity to the CSI to be something
> other than those.
> 
> Fixes: bf3cfaa712e5c ("media: staging/imx: get CSI bus type from nearest
> upstream entity")
> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/staging/media/imx/imx-media-csi.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 555aa45e02e3..b9af7d3d4974 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -154,9 +154,10 @@ static inline bool requires_passthrough(struct v4l2_fwnode_endpoint *ep,
>  /*
>   * Parses the fwnode endpoint from the source pad of the entity
>   * connected to this CSI. This will either be the entity directly
> - * upstream from the CSI-2 receiver, or directly upstream from the
> - * video mux. The endpoint is needed to determine the bus type and
> - * bus config coming into the CSI.
> + * upstream from the CSI-2 receiver, directly upstream from the
> + * video mux, or directly upstream from the CSI itself. The endpoint
> + * is needed to determine the bus type and bus config coming into
> + * the CSI.
>   */
>  static int csi_get_upstream_endpoint(struct csi_priv *priv,
>  				     struct v4l2_fwnode_endpoint *ep)
> @@ -172,7 +173,8 @@ static int csi_get_upstream_endpoint(struct csi_priv *priv,
>  	if (!priv->src_sd)
>  		return -EPIPE;
>  
> -	src = &priv->src_sd->entity;
> +	sd = priv->src_sd;
> +	src = &sd->entity;
>  
>  	if (src->function == MEDIA_ENT_F_VID_MUX) {
>  		/*
> @@ -186,6 +188,14 @@ static int csi_get_upstream_endpoint(struct csi_priv *priv,
>  			src = &sd->entity;
>  	}
>  
> +	/*
> +	 * If the source is neither the video mux nor the CSI-2 receiver,
> +	 * get the source pad directly upstream from CSI itself.
> +	 */
> +	if (src->function != MEDIA_ENT_F_VID_MUX &&

Will it work correctly if there's an external MUX connected to the CSI?

> +	    sd->grp_id != IMX_MEDIA_GRP_ID_CSI2)
> +		src = &priv->sd.entity;
> +
>  	/* get source pad of entity directly upstream from src */
>  	pad = imx_media_find_upstream_pad(priv->md, src, 0);
>  	if (IS_ERR(pad))

regards
Philipp
