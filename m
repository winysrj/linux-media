Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EE2C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 10:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE8EF206B6
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 10:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfAJKyp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 05:54:45 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51179 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfAJKyo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 05:54:44 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ghXz1-0007pK-C1; Thu, 10 Jan 2019 11:54:43 +0100
Message-ID: <1547117681.8943.3.camel@pengutronix.de>
Subject: Re: [PATCH v2 3/3] media: imx: lift CSI and PRP ENC/VF width
 alignment restriction
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, kernel@pengutronix.de
Date:   Thu, 10 Jan 2019 11:54:41 +0100
In-Reply-To: <fe63e40b-08ae-5ff1-c222-f5a624b83569@gmail.com>
References: <20190109110831.23395-1-p.zabel@pengutronix.de>
         <20190109110831.23395-3-p.zabel@pengutronix.de>
         <fe63e40b-08ae-5ff1-c222-f5a624b83569@gmail.com>
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

On Wed, 2019-01-09 at 11:21 -0800, Steve Longerbeam wrote:
> 
> On 1/9/19 3:08 AM, Philipp Zabel wrote:
> > The CSI, PRP ENC, and PRP VF subdevices shouldn't have to care about
> > IDMAC line start address alignment. With compose rectangle support in
> > the capture driver, they don't have to anymore.
> > If the direct CSI -> IC path is enabled, the CSI output width must
> > still be aligned to 8 pixels (IC burst length).
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > Changes since v1:
> >   - Relax PRP ENC and PRP VF source pad width alignment as well
> >   - Relax CSI crop width alignment to 2 pixels if direct CSI -> IC path
> >     is not enabled
> > ---
> >   drivers/staging/media/imx/imx-ic-prpencvf.c |  2 +-
> >   drivers/staging/media/imx/imx-media-csi.c   | 21 +++++++++++++++++++--
> >   drivers/staging/media/imx/imx-media-utils.c | 15 ++++++++++++---
> >   3 files changed, 32 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
> > index fe5a77baa592..7bb754cb703e 100644
> > --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
> > +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
> > @@ -48,7 +48,7 @@
> >   
> >   #define MAX_W_SRC  1024
> >   #define MAX_H_SRC  1024
> > -#define W_ALIGN_SRC   4 /* multiple of 16 pixels */
> > +#define W_ALIGN_SRC   1 /* multiple of 2 pixels */
> >   #define H_ALIGN_SRC   1 /* multiple of 2 lines */
> >   
> >   #define S_ALIGN       1 /* multiple of 2 */
> > diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> > index c4523afe7b48..1b4962b8b192 100644
> > --- a/drivers/staging/media/imx/imx-media-csi.c
> > +++ b/drivers/staging/media/imx/imx-media-csi.c
> > @@ -41,7 +41,7 @@
> >   #define MIN_H       144
> >   #define MAX_W      4096
> >   #define MAX_H      4096
> > -#define W_ALIGN    4 /* multiple of 16 pixels */
> > +#define W_ALIGN    1 /* multiple of 2 pixels */
> >   #define H_ALIGN    1 /* multiple of 2 lines */
> >   #define S_ALIGN    1 /* multiple of 2 */
> >   
> > @@ -1130,6 +1130,20 @@ __csi_get_compose(struct csi_priv *priv, struct v4l2_subdev_pad_config *cfg,
> >   		return &priv->compose;
> >   }
> >   
> > +static bool csi_src_pad_enabled(struct media_pad *pad)
> > +{
> > +	struct media_link *link;
> > +
> > +	list_for_each_entry(link, &pad->entity->links, list) {
> > +		if (link->source->entity == pad->entity &&
> > +		    link->source->index == pad->index &&
> > +		    link->flags & MEDIA_LNK_FL_ENABLED)
> > +			return true;
> > +	}
> > +
> > +	return false;
> > +}
> 
> I don't think this function is needed, first it is basically equivalent to
> media_entity_remote_pad(), but also...
>
> > +
> >   static void csi_try_crop(struct csi_priv *priv,
> >   			 struct v4l2_rect *crop,
> >   			 struct v4l2_subdev_pad_config *cfg,
> > @@ -1141,7 +1155,10 @@ static void csi_try_crop(struct csi_priv *priv,
> >   		crop->left = infmt->width - crop->width;
> >   	/* adjust crop left/width to h/w alignment restrictions */
> >   	crop->left &= ~0x3;
> > -	crop->width &= ~0x7;
> > +	if (csi_src_pad_enabled(&priv->pad[CSI_SRC_PAD_DIRECT]))
> 
> why not just use "if (priv->active_output_pad == CSI_SRC_PAD_DIRECT) ..." ?

While both source pad links are disabled, whether or not IC burst
alignment is applied would depend on hidden state. This should be
consistent, regardless of previously enabled source pad links.

We could achieve that with your suggested change if csi_link_setup()
would always set active_output_pad = CSI_SRC_PAD_IDMAC when disabling
source pad links:

----------8<----------
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index dd911313fca2..e593fd7774ff 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1000,6 +1000,8 @@ static int csi_link_setup(struct media_entity *entity,
 		v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
 		v4l2_ctrl_handler_init(&priv->ctrl_hdlr, 0);
 		priv->sink = NULL;
+		/* do not apply IC burst alignment in csi_try_crop */
+		priv->active_output_pad = CSI_SRC_PAD_IDMAC;
 		goto out;
 	}
 
---------->8----------

regards
Philipp
