Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA2BC282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 16:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAF4F217FA
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 16:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbfBLQJY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 11:09:24 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59087 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730755AbfBLQJX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 11:09:23 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gtacU-0002oq-Jr; Tue, 12 Feb 2019 17:09:14 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gtacS-0007WE-TY; Tue, 12 Feb 2019 17:09:12 +0100
Date:   Tue, 12 Feb 2019 17:09:12 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        sakari.ailus@linux.intel.com
Cc:     devicetree@vger.kernel.org, kernel@pengutronix.de,
        javierm@redhat.com, laurent.pinchart@ideasonboard.com,
        p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v4 0/7] TVP5150 new features
Message-ID: <20190212160912.jsmcrz4yhkzatawr@pengutronix.de>
References: <20190129160757.2314-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190129160757.2314-1-m.felsch@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:08:44 up 24 days, 20:50, 33 users,  load average: 0.13, 0.09,
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

Hi Mauro,

gentle ping..

On 19-01-29 17:07, Marco Felsch wrote:
> Hi,
> 
> this is the v4 of my TVP5150 series which adds the of_graph support.
> Basically this series was just rebased on top of the media-tree/master
> as mentioned by Mauro [1].
> 
> I dropped commit ("media: tvp5150: fix irq_request error path during
> probe") since it was already applied and commit ("media: v4l2-subdev:
> fix v4l2_subdev_get_try_* dependency") as mentioned by Sakari [2].
> 
> To have a quick overview I added the range-diff to the v3 below.
> 
> [1] https://www.spinics.net/lists/devicetree/msg262787.html
> [2] https://www.spinics.net/lists/devicetree/msg249354.html
> 
> Javier Martinez Canillas (1):
>   partial revert of "[media] tvp5150: add HW input connectors support"
> 
> Marco Felsch (5):
>   media: tvp5150: add input source selection of_graph support
>   media: dt-bindings: tvp5150: Add input port connectors DT bindings
>   media: v4l2-subdev: add stubs for v4l2_subdev_get_try_*
>   media: tvp5150: add FORMAT_TRY support for get/set selection handlers
>   media: tvp5150: add s_power callback
> 
> Michael Tretter (1):
>   media: tvp5150: initialize subdev before parsing device tree
> 
>  .../devicetree/bindings/media/i2c/tvp5150.txt |  92 ++-
>  drivers/media/i2c/tvp5150.c                   | 652 +++++++++++++-----
>  include/dt-bindings/media/tvp5150.h           |   2 -
>  include/media/v4l2-subdev.h                   |  15 +-
>  4 files changed, 579 insertions(+), 182 deletions(-)
> 
> Range-diff against v3:
>  1:  c3d26f4af009 !  1:  4a35a7fb3a24 partial revert of "[media] tvp5150: add HW input connectors support"
>     @@ -21,6 +21,7 @@
>          [m.felsch@pengutronix.de: rm TVP5150_INPUT_NUM define]
>          Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
>          Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>     +    Acked-by: Rob Herring <robh@kernel.org>
>      
>       diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
>       --- a/drivers/media/i2c/tvp5150.c
>     @@ -131,7 +132,7 @@
>        ****************************************************************************/
>      @@
>       {
>     - 	struct v4l2_fwnode_endpoint bus_cfg;
>     + 	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
>       	struct device_node *ep;
>      -#ifdef CONFIG_MEDIA_CONTROLLER
>      -	struct device_node *connectors, *child;
>  2:  88f4c4a30a08 <  -:  ------------ media: tvp5150: fix irq_request error path during probe
>  3:  48b34c9c9e5f !  2:  f5ca703e5523 media: tvp5150: add input source selection of_graph support
>     @@ -21,6 +21,11 @@
>          ---
>          Changelog:
>      
>     +    v4:
>     +     - rebase on top of media_tree/master, fix merge conflict due to commit
>     +       60359a28d592 ("media: v4l: fwnode: Initialise the V4L2 fwnode endpoints
>     +       to zero")
>     +
>          v3:
>          - probe(): s/err/err_free_v4l2_ctrls
>          - drop MC dependency for tvp5150_pads
>     @@ -49,13 +54,11 @@
>       #define dprintk0(__dev, __arg...) dev_dbg_lvl(__dev, 0, 0, __arg)
>       
>       enum tvp5150_pads {
>     --       TVP5150_PAD_IF_INPUT,
>     --       TVP5150_PAD_VID_OUT,
>     --       TVP5150_NUM_PADS
>     +-	TVP5150_PAD_IF_INPUT,
>      +	TVP5150_PAD_AIP1A = TVP5150_COMPOSITE0,
>      +	TVP5150_PAD_AIP1B,
>     -+	TVP5150_PAD_VID_OUT,
>     -+	TVP5150_NUM_PADS
>     + 	TVP5150_PAD_VID_OUT,
>     + 	TVP5150_NUM_PADS
>       };
>       
>      +#if defined(CONFIG_MEDIA_CONTROLLER)
>     @@ -345,7 +348,7 @@
>      +#if defined(CONFIG_MEDIA_CONTROLLER)
>      +static int tvp5150_add_of_connectors(struct tvp5150 *decoder)
>       {
>     --	struct v4l2_fwnode_endpoint bus_cfg;
>     +-	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
>      -	struct device_node *ep;
>      -	unsigned int flags;
>      -	int ret = 0;
>     @@ -464,7 +467,7 @@
>      +static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
>      +{
>      +	struct device *dev = decoder->sd.dev;
>     -+	struct v4l2_fwnode_endpoint bus_cfg;
>     ++	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
>      +	struct device_node *ep_np;
>      +	unsigned int flags;
>      +	int ret, i = 0, in = 0;
>  4:  0b168180f4a4 !  3:  a7d06df79366 media: dt-bindings: tvp5150: Add input port connectors DT bindings
>     @@ -15,6 +15,7 @@
>          how the input connectors for these devices should be defined in a DT.
>      
>          Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
>     +    Reviewed-by: Rob Herring <robh@kernel.org>
>      
>          ---
>          Changelog:
>  5:  871eb653fcf3 =  4:  860087e6c286 media: v4l2-subdev: add stubs for v4l2_subdev_get_try_*
>  6:  fb141d6c8098 <  -:  ------------ media: v4l2-subdev: fix v4l2_subdev_get_try_* dependency
>  7:  795b4a45cb68 !  5:  fcd223cd1563 media: tvp5150: add FORMAT_TRY support for get/set selection handlers
>     @@ -13,6 +13,13 @@
>      
>          Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
>      
>     +    ---
>     +    Changelog:
>     +
>     +    v4:
>     +     - fix merge conflict due to rebase on top of media-tree/master
>     +     - __tvp5150_get_pad_crop(): cosmetic alignment fixes
>     +
>       diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
>       --- a/drivers/media/i2c/tvp5150.c
>       +++ b/drivers/media/i2c/tvp5150.c
>     @@ -148,19 +155,19 @@
>       
>      -	regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_START, rect.top);
>      -	regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_STOP,
>     --		      rect.top + rect.height - hmax);
>     +-		     rect.top + rect.height - hmax);
>      -	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_ST_MSB,
>     --		      rect.left >> TVP5150_CROP_SHIFT);
>     +-		     rect.left >> TVP5150_CROP_SHIFT);
>      -	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_ST_LSB,
>     --		      rect.left | (1 << TVP5150_CROP_SHIFT));
>     +-		     rect.left | (1 << TVP5150_CROP_SHIFT));
>      -	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_STP_MSB,
>     --		      (rect.left + rect.width - TVP5150_MAX_CROP_LEFT) >>
>     --		      TVP5150_CROP_SHIFT);
>     +-		     (rect.left + rect.width - TVP5150_MAX_CROP_LEFT) >>
>     +-		     TVP5150_CROP_SHIFT);
>      -	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_STP_LSB,
>     --		      rect.left + rect.width - TVP5150_MAX_CROP_LEFT);
>     -+	__crop = __tvp5150_get_pad_crop(decoder, cfg, sel->pad,
>     -+						  sel->which);
>     -+
>     +-		     rect.left + rect.width - TVP5150_MAX_CROP_LEFT);
>     ++	__crop = __tvp5150_get_pad_crop(decoder, cfg, sel->pad, sel->which);
>     + 
>     +-	decoder->rect = rect;
>      +	/*
>      +	 * Update output image size if the selection (crop) rectangle size or
>      +	 * position has been modified.
>     @@ -168,8 +175,7 @@
>      +	if (!v4l2_rect_equal(&rect, __crop))
>      +		if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE)
>      +			__tvp5150_set_selection(sd, rect);
>     - 
>     --	decoder->rect = rect;
>     ++
>      +	*__crop = rect;
>       
>       	return 0;
>     @@ -183,14 +189,14 @@
>      -
>       	switch (sel->target) {
>       	case V4L2_SEL_TGT_CROP_BOUNDS:
>     - 	case V4L2_SEL_TGT_CROP_DEFAULT:
>     + 		sel->r.left = 0;
>      @@
>       			sel->r.height = TVP5150_V_MAX_OTHERS;
>       		return 0;
>       	case V4L2_SEL_TGT_CROP:
>      -		sel->r = decoder->rect;
>      +		sel->r = *__tvp5150_get_pad_crop(decoder, cfg, sel->pad,
>     -+						      sel->which);
>     ++						 sel->which);
>       		return 0;
>       	default:
>       		return -EINVAL;
>  8:  8d88797ba94c =  6:  08cc83bcb513 media: tvp5150: initialize subdev before parsing device tree
>  9:  b152e29bc83e =  7:  1249b386cce0 media: tvp5150: add s_power callback
> -- 
> 2.20.1
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
