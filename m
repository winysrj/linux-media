Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:45500 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935179AbeEYFVf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 01:21:35 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
References: <m37eobudmo.fsf@t19.piap.pl>
        <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com>
        <m3tvresqfw.fsf@t19.piap.pl>
        <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com>
        <m3fu2oswjh.fsf@t19.piap.pl> <m3603hsa4o.fsf@t19.piap.pl>
        <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
        <m3h8mxqc7t.fsf@t19.piap.pl>
        <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
        <aad7c874-ee05-ef9b-733c-609b6928fc3c@gmail.com>
Date: Fri, 25 May 2018 07:21:32 +0200
In-Reply-To: <aad7c874-ee05-ef9b-733c-609b6928fc3c@gmail.com> (Steve
        Longerbeam's message of "Thu, 24 May 2018 13:48:56 -0700")
Message-ID: <m3d0xkqpib.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam <slongerbeam@gmail.com> writes:

> Sorry I did find a bug. Please try this patch:

Ok, your patch fixes the first problem (sets the CSI interlaced mode
on input when field = NOE is requested on output). Posting in full since
your mail came somehow mangled with UTF-8.

--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -629,7 +629,6 @@ static int csi_setup(struct csi_priv *priv)
 {
 	struct v4l2_mbus_framefmt *infmt, *outfmt;
 	struct v4l2_mbus_config mbus_cfg;
-	struct v4l2_mbus_framefmt if_fmt;
 
 	infmt = &priv->format_mbus[CSI_SINK_PAD];
 	outfmt = &priv->format_mbus[priv->active_output_pad];
@@ -640,20 +639,13 @@ static int csi_setup(struct csi_priv *priv)
 		priv->upstream_ep.bus.mipi_csi2.flags :
 		priv->upstream_ep.bus.parallel.flags;
 
-	/*
-	 * we need to pass input frame to CSI interface, but
-	 * with translated field type from output format
-	 */
-	if_fmt = *infmt;
-	if_fmt.field = outfmt->field;
-
 	ipu_csi_set_window(priv->csi, &priv->crop);
 
 	ipu_csi_set_downsize(priv->csi,
 			     priv->crop.width == 2 * priv->compose.width,
 			     priv->crop.height == 2 * priv->compose.height);
 
-	ipu_csi_init_interface(priv->csi, &mbus_cfg, &if_fmt);
+	ipu_csi_init_interface(priv->csi, &mbus_cfg, infmt);
 
 	ipu_csi_set_dest(priv->csi, priv->dest);
 

> (the removed code was meant to deal with field type at sink pad being
> "alternate", which ipu_csi_init_interface() doesn't currently recognize, but
> that should be dealt with in IPUv3 driver).

I see.

> With that you should be able to set pad ipu2_csi1:2 to field type
> "none", e.g.
> set pipeline to:
>
> media-ctl -V '"adv7180 2-0020":0[fmt:UYVY2X8 720x480 field:interlaced]'
> media-ctl -V '"ipu2_csi1_mux":1[fmt:UYVY2X8 720x480 field:interlaced]'
> media-ctl -V '"ipu2_csi1_mux":2[fmt:UYVY2X8 720x480 field:interlaced]'
> media-ctl -V '"ipu2_csi1":0[fmt:UYVY2X8 720x480 field:interlaced]'
> media-ctl -V '"ipu2_csi1":2[fmt:UYVY2X8 720x480 field:none]'
>
> With the above patch, capture from ipu1_csi0:2 is fixed for me on
> SabreAuto.

Right, it also works fine for me on Ventana GW5300 (with
ipu_cpmem_skip_odd_chroma_rows() removed as well, of course).

> You may also want to try adding a ~500 msec delay after adv7180 power on
> as I explained earlier:

Ok. In fact I don't have a sync problem even without it, the rolling
image always eventually syncs. Maybe I'll investigate the data stream
(from ADV7180 to CSI) and see what's on. I't a bit complicated since
what I have is just an oscilloscope.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
