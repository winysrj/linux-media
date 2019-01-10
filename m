Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03280C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 10:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3DDF21773
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 10:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfAJKyx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 05:54:53 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43693 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfAJKyx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 05:54:53 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ghXz9-0007s4-6G; Thu, 10 Jan 2019 11:54:51 +0100
Message-ID: <1547117689.8943.4.camel@pengutronix.de>
Subject: Re: [PATCH] media: imx-csi: Input connections to CSI should be
 optional
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 10 Jan 2019 11:54:49 +0100
In-Reply-To: <20190109183448.20923-1-slongerbeam@gmail.com>
References: <20190109183448.20923-1-slongerbeam@gmail.com>
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

On Wed, 2019-01-09 at 10:34 -0800, Steve Longerbeam wrote:
> Some imx platforms do not have fwnode connections to all CSI input
> ports, and should not be treated as an error. This includes the
> imx6q SabreAuto, which has no connections to ipu1_csi1 and ipu2_csi0.
> Return -ENOTCONN in imx_csi_parse_endpoint() so that v4l2-fwnode
> endpoint parsing will not treat an unconnected CSI input port as
> an error.
> 
> Fixes: c893500a16baf ("media: imx: csi: Register a subdev notifier")
> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

> ---
>  drivers/staging/media/imx/imx-media-csi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 4223f8d418ae..30b1717982ae 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -1787,7 +1787,7 @@ static int imx_csi_parse_endpoint(struct device *dev,
>  				  struct v4l2_fwnode_endpoint *vep,
>  				  struct v4l2_async_subdev *asd)
>  {
> -	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -EINVAL;
> +	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -ENOTCONN;
>  }
>  
>  static int imx_csi_async_register(struct csi_priv *priv)
