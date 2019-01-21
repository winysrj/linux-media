Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4201CC7113B
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 11:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11D552085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 11:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbfAULtP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 06:49:15 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49781 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727766AbfAULtP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 06:49:15 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1glY4n-0002wv-BW; Mon, 21 Jan 2019 12:49:13 +0100
Message-ID: <1548071350.3287.3.camel@pengutronix.de>
Subject: Re: [PATCH v3 1/2] media: imx: csi: Disable SMFC before disabling
 IDMA channel
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Gael PORTAY <gael.portay@collabora.com>,
        Peter Seiderer <ps.report@gmx.net>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 21 Jan 2019 12:49:10 +0100
In-Reply-To: <20190119010457.2623-2-slongerbeam@gmail.com>
References: <20190119010457.2623-1-slongerbeam@gmail.com>
         <20190119010457.2623-2-slongerbeam@gmail.com>
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

Hi,

On Fri, 2019-01-18 at 17:04 -0800, Steve Longerbeam wrote:
> Disable the SMFC before disabling the IDMA channel, instead of after,
> in csi_idmac_unsetup().
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
> The lockup occurs when disabling the IDMA channel at stream off. Stopping
> the video data stream entering the IDMA channel before disabling the
> channel itself appears to be a reliable fix for the hard lockup. That can
> be done either by disabling the SMFC or the CSI before disabling the
> channel. Disabling the SMFC before the channel is the easiest solution,
> so do that.
> 
> Fixes: 4a34ec8e470cb ("[media] media: imx: Add CSI subdev driver")
> 
> Suggested-by: Peter Seiderer <ps.report@gmx.net>
> Reported-by: Gaël PORTAY <gael.portay@collabora.com>
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>

Gaël, could we get a Tested-by: for this as well?

> Cc: stable@vger.kernel.org
> ---
> Changes in v3:
> - switch from disabling the CSI before the channel to disabling the
>   SMFC before the channel.
> Changes in v2:
> - restore an empty line
> - Add Fixes: and Cc: stable
> ---
>  drivers/staging/media/imx/imx-media-csi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index e18f58f56dfb..8610027eac97 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -560,8 +560,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>  static void csi_idmac_unsetup(struct csi_priv *priv,
>  			      enum vb2_buffer_state state)
>  {
> -	ipu_idmac_disable_channel(priv->idmac_ch);
>  	ipu_smfc_disable(priv->smfc);
> +	ipu_idmac_disable_channel(priv->idmac_ch);

Steve, do you have any theory why this helps? It's a bit weird to
disable the SMFC module while the DMA channel is still enabled. I think
this warrants a big comment, given that enable order is SMFC_EN before
IDMAC channel enable.

Also ipu_smfc_disable is refcounted, so if the other CSI is capturing
simultaneously, this change has no effect.

FWIW, I don't see any regressions though.

regards
Philipp
