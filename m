Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:56896 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966383AbeEXP4Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 11:56:25 -0400
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
Date: Thu, 24 May 2018 17:56:22 +0200
In-Reply-To: <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com> (Steve
        Longerbeam's message of "Mon, 21 May 2018 14:25:40 -0700")
Message-ID: <m3h8mxqc7t.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've experimented with the ADV7180 a bit and this is what I found.

First, I'm using (with a NTSC camera but I guess PAL won't be much
different):
media-ctl -V '"adv7180 2-0020":0[fmt:UYVY2X8 720x480 field:interlaced]'
media-ctl -V '"ipu2_csi1_mux":1[fmt:UYVY2X8 720x480 field:interlaced]'
media-ctl -V '"ipu2_csi1_mux":2[fmt:UYVY2X8 720x480 field:interlaced]'
media-ctl -V '"ipu2_csi1":0[fmt:UYVY2X8 720x480 field:interlaced]'
media-ctl -V '"ipu2_csi1":2[fmt:UYVY2X8 720x480 field:interlaced]'

IOW I set all of the parts to interlaced mode. If i set the last element
to "none", the CSI is not set for interlaced input, and nothing works at
the low level.

This requires a quick temporary hack:
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -474,8 +474,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 
 	ipu_smfc_set_burstsize(priv->smfc, burst_size);
 
-	if (image.pix.field == V4L2_FIELD_NONE &&
-	    V4L2_FIELD_HAS_BOTH(infmt->field))
+	if (1 || (image.pix.field == V4L2_FIELD_NONE &&
+		  V4L2_FIELD_HAS_BOTH(infmt->field)))
 		ipu_cpmem_interlaced_scan(priv->idmac_ch,
 					  image.pix.bytesperline);
 

I.e., I need to set CPMEM to interlaced mode when I operate CSI in
interlaced mode. The original code is a bit unclear to me in fact.

The following is required as well. Now the question is why we can't skip
writing those odd UV rows. Anyway, with these 2 changes, I get a stable
NTSC (and probably PAL) interlaced video stream.

The manual says: Reduce Double Read or Writes (RDRW):
This bit is relevant for YUV4:2:0 formats. For write channels:
U and V components are not written to odd rows.

How could it be so? With YUV420, are they normally written?
OTOH it seems that not only UV is broken with this bit set.
Y is broken as well.

--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -413,14 +413,12 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 		passthrough_bits = 16;
 		break;
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_NV12:
 		burst_size = (image.pix.width & 0x3f) ?
 			     ((image.pix.width & 0x1f) ?
 			      ((image.pix.width & 0xf) ? 8 : 16) : 32) : 64;
 		passthrough = is_parallel_16bit_bus(&priv->upstream_ep);
 		passthrough_bits = 16;
-		/* Skip writing U and V components to odd rows */
-		ipu_cpmem_skip_odd_chroma_rows(priv->idmac_ch);
 		break;
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_UYVY:
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
