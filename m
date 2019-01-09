Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D106BC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E2BC20859
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:17:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hj+pQYwj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbfAISRO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:17:14 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38846 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbfAISRI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:17:08 -0500
Received: by mail-pg1-f195.google.com with SMTP id g189so3653032pgc.5;
        Wed, 09 Jan 2019 10:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hz8OoQS0GJ1ohgapnMRdb0o/+ZyITL4nFVXmQPKhgCE=;
        b=hj+pQYwjoaNaaNYcWEtmEMAWjBnZqCwVpvoGmQvbNn8zYw3BiffIfiWMI9dwZ2cE2F
         lx1L9i2EAYjFkv1SMFGpHWvWDa0JkNWPl3/AxQqNyEWAwHF9lMr4XY7TgE4Hp6ll2fIk
         sLV/TX0szSB+HdmmMHDc1d2FCytT4gL1WC70aHRXlxDkJs9WAnG4XhojzNqAof13ixp8
         ofAxOGJ6sNlpMklLLCePS+m9V6bsug8McjRybxsiFWqL/+f52rcvTPkIt1twSox2uFZ+
         XqYJknXAxyU4xQhsbtTgtS1dM3HMhKNh3JQojDTugErlt+8HRlo63H6EsNUoa7IORddD
         rgDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hz8OoQS0GJ1ohgapnMRdb0o/+ZyITL4nFVXmQPKhgCE=;
        b=rYJoRmT5Kjas+2RqX2rTiysQxJxxo0U/DXJzHCrZv7d8JR/idleZfbYcvIShXhmfCL
         h7LTDhx+vW58Iw3Qz108Own/DAR73ZeWlKUoAbn2bmdf1wg/c/+8jzQD0fto5a75B7w7
         EXojGoNhkIqxzBFxvUc1XkkPDaYTPLYBHhaZfGa1OVxnzXk7y2mK5+txuZ59k8WRlR9F
         3qtoNvoTkI891R07/zo37ic2Q58TcjxamZ98nxhY1gGofj1Ky6JFv8XX6L6f1ohZSmlv
         CIfzqq57WQAYCVQuLPR+e+RBJJCOH/gRmzzMMN1ggJIrsaZjOvaAwMQ+9QL/ATakN4dX
         NUzw==
X-Gm-Message-State: AJcUukcZ/Y9pvCk0IvEnRr98l6CJIxF8+1/eqKIz7qv1+9ZRhbUB9xcf
        GD8DMsjzSQFVchB2VYomcYsvNYYb
X-Google-Smtp-Source: ALg8bN5hBM/T/CYsNPxhrrlICMWit2OBJtDNVNiYWMTQHpePhW2tZUsW7X/WsVfuOVt2SA+8Gd8+tQ==
X-Received: by 2002:a63:413:: with SMTP id 19mr4121564pge.7.1547057827064;
        Wed, 09 Jan 2019 10:17:07 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id h19sm97030004pfn.114.2019.01.09.10.17.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:17:06 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v7 11/11] media: imx.rst: Update doc to reflect fixes to interlaced capture
Date:   Wed,  9 Jan 2019 10:16:41 -0800
Message-Id: <20190109181642.19378-12-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109181642.19378-1-slongerbeam@gmail.com>
References: <20190109181642.19378-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Also add an example pipeline for unconverted capture with interweave
on SabreAuto.

Cleanup some language in various places in the process.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
Changes since v4:
- Make clear that it is IDMAC channel that does pixel reordering and
  interweave, not the CSI. Caught by Philipp Zabel.
Changes since v3:
- none.
Changes since v2:
- expand on idmac interweave behavior in CSI subdev.
- switch second SabreAuto pipeline example to PAL to give
  both NTSC and PAL examples.
- Cleanup some language in various places.
---
 Documentation/media/v4l-drivers/imx.rst | 103 +++++++++++++++---------
 1 file changed, 66 insertions(+), 37 deletions(-)

diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
index 6922dde4a82b..9314af00d067 100644
--- a/Documentation/media/v4l-drivers/imx.rst
+++ b/Documentation/media/v4l-drivers/imx.rst
@@ -24,8 +24,8 @@ memory. Various dedicated DMA channels exist for both video capture and
 display paths. During transfer, the IDMAC is also capable of vertical
 image flip, 8x8 block transfer (see IRT description), pixel component
 re-ordering (for example UYVY to YUYV) within the same colorspace, and
-even packed <--> planar conversion. It can also perform a simple
-de-interlacing by interleaving even and odd lines during transfer
+packed <--> planar conversion. The IDMAC can also perform a simple
+de-interlacing by interweaving even and odd lines during transfer
 (without motion compensation which requires the VDIC).
 
 The CSI is the backend capture unit that interfaces directly with
@@ -175,15 +175,21 @@ via the SMFC and an IDMAC channel, bypassing IC pre-processing. This
 source pad is routed to a capture device node, with a node name of the
 format "ipuX_csiY capture".
 
-Note that since the IDMAC source pad makes use of an IDMAC channel, it
-can do pixel reordering within the same colorspace. For example, the
-sink pad can take UYVY2X8, but the IDMAC source pad can output YUYV2X8.
-If the sink pad is receiving YUV, the output at the capture device can
-also be converted to a planar YUV format such as YUV420.
-
-It will also perform simple de-interlace without motion compensation,
-which is activated if the sink pad's field type is an interlaced type,
-and the IDMAC source pad field type is set to none.
+Note that since the IDMAC source pad makes use of an IDMAC channel,
+pixel reordering within the same colorspace can be carried out by the
+IDMAC channel. For example, if the CSI sink pad is receiving in UYVY
+order, the capture device linked to the IDMAC source pad can capture
+in YUYV order. Also, if the CSI sink pad is receiving a packed YUV
+format, the capture device can capture a planar YUV format such as
+YUV420.
+
+The IDMAC channel at the IDMAC source pad also supports simple
+interweave without motion compensation, which is activated if the source
+pad's field type is sequential top-bottom or bottom-top, and the
+requested capture interface field type is set to interlaced (t-b, b-t,
+or unqualified interlaced). The capture interface will enforce the same
+field order as the source pad field order (interlaced-bt if source pad
+is seq-bt, interlaced-tb if source pad is seq-tb).
 
 This subdev can generate the following event when enabling the second
 IDMAC source pad:
@@ -325,14 +331,14 @@ ipuX_vdic
 
 The VDIC carries out motion compensated de-interlacing, with three
 motion compensation modes: low, medium, and high motion. The mode is
-specified with the menu control V4L2_CID_DEINTERLACING_MODE. It has
-two sink pads and a single source pad.
+specified with the menu control V4L2_CID_DEINTERLACING_MODE. The VDIC
+has two sink pads and a single source pad.
 
 The direct sink pad receives from an ipuX_csiY direct pad. With this
 link the VDIC can only operate in high motion mode.
 
 When the IDMAC sink pad is activated, it receives from an output
-or mem2mem device node. With this pipeline, it can also operate
+or mem2mem device node. With this pipeline, the VDIC can also operate
 in low and medium modes, because these modes require receiving
 frames from memory buffers. Note that an output or mem2mem device
 is not implemented yet, so this sink pad currently has no links.
@@ -345,8 +351,8 @@ ipuX_ic_prp
 This is the IC pre-processing entity. It acts as a router, routing
 data from its sink pad to one or both of its source pads.
 
-It has a single sink pad. The sink pad can receive from the ipuX_csiY
-direct pad, or from ipuX_vdic.
+This entity has a single sink pad. The sink pad can receive from the
+ipuX_csiY direct pad, or from ipuX_vdic.
 
 This entity has two source pads. One source pad routes to the
 pre-process encode task entity (ipuX_ic_prpenc), the other to the
@@ -369,8 +375,8 @@ color-space conversion, resizing (downscaling and upscaling),
 horizontal and vertical flip, and 90/270 degree rotation. Flip
 and rotation are provided via standard V4L2 controls.
 
-Like the ipuX_csiY IDMAC source, it can also perform simple de-interlace
-without motion compensation, and pixel reordering.
+Like the ipuX_csiY IDMAC source, this entity also supports simple
+de-interlace without motion compensation, and pixel reordering.
 
 ipuX_ic_prpvf
 -------------
@@ -380,18 +386,18 @@ pad from ipuX_ic_prp, and a single source pad. The source pad is routed
 to a capture device node, with a node name of the format
 "ipuX_ic_prpvf capture".
 
-It is identical in operation to ipuX_ic_prpenc, with the same resizing
-and CSC operations and flip/rotation controls. It will receive and
-process de-interlaced frames from the ipuX_vdic if ipuX_ic_prp is
+This entity is identical in operation to ipuX_ic_prpenc, with the same
+resizing and CSC operations and flip/rotation controls. It will receive
+and process de-interlaced frames from the ipuX_vdic if ipuX_ic_prp is
 receiving from ipuX_vdic.
 
-Like the ipuX_csiY IDMAC source, it can perform simple de-interlace
-without motion compensation. However, note that if the ipuX_vdic is
-included in the pipeline (ipuX_ic_prp is receiving from ipuX_vdic),
-it's not possible to use simple de-interlace in ipuX_ic_prpvf, since
-the ipuX_vdic has already carried out de-interlacing (with motion
-compensation) and therefore the field type output from ipuX_ic_prp can
-only be none.
+Like the ipuX_csiY IDMAC source, this entity supports simple
+interweaving without motion compensation. However, note that if the
+ipuX_vdic is included in the pipeline (ipuX_ic_prp is receiving from
+ipuX_vdic), it's not possible to use interweave in ipuX_ic_prpvf,
+since the ipuX_vdic has already carried out de-interlacing (with
+motion compensation) and therefore the field type output from
+ipuX_vdic can only be none (progressive).
 
 Capture Pipelines
 -----------------
@@ -516,10 +522,33 @@ On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
 parallel bus input on the internal video mux to IPU1 CSI0.
 
 The following example configures a pipeline to capture from the ADV7180
-video decoder, assuming NTSC 720x480 input signals, with Motion
-Compensated de-interlacing. Pad field types assume the adv7180 outputs
-"interlaced". $outputfmt can be any format supported by the ipu1_ic_prpvf
-entity at its output pad:
+video decoder, assuming NTSC 720x480 input signals, using simple
+interweave (unconverted and without motion compensation). The adv7180
+must output sequential or alternating fields (field type 'seq-bt' for
+NTSC, or 'alternate'):
+
+.. code-block:: none
+
+   # Setup links
+   media-ctl -l "'adv7180 3-0021':0 -> 'ipu1_csi0_mux':1[1]"
+   media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
+   media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
+   # Configure pads
+   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
+   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
+   media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
+   # Configure "ipu1_csi0 capture" interface (assumed at /dev/video4)
+   v4l2-ctl -d4 --set-fmt-video=field=interlaced_bt
+
+Streaming can then begin on /dev/video4. The v4l2-ctl tool can also be
+used to select any supported YUV pixelformat on /dev/video4.
+
+This example configures a pipeline to capture from the ADV7180
+video decoder, assuming PAL 720x576 input signals, with Motion
+Compensated de-interlacing. The adv7180 must output sequential or
+alternating fields (field type 'seq-tb' for PAL, or 'alternate').
+$outputfmt can be any format supported by the ipu1_ic_prpvf entity
+at its output pad:
 
 .. code-block:: none
 
@@ -531,11 +560,11 @@ entity at its output pad:
    media-ctl -l "'ipu1_ic_prp':2 -> 'ipu1_ic_prpvf':0[1]"
    media-ctl -l "'ipu1_ic_prpvf':1 -> 'ipu1_ic_prpvf capture':0[1]"
    # Configure pads
-   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480]"
-   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480 field:interlaced]"
-   media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x480 field:interlaced]"
-   media-ctl -V "'ipu1_vdic':2 [fmt:AYUV32/720x480 field:none]"
-   media-ctl -V "'ipu1_ic_prp':2 [fmt:AYUV32/720x480 field:none]"
+   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x576 field:seq-tb]"
+   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x576]"
+   media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x576]"
+   media-ctl -V "'ipu1_vdic':2 [fmt:AYUV32/720x576 field:none]"
+   media-ctl -V "'ipu1_ic_prp':2 [fmt:AYUV32/720x576 field:none]"
    media-ctl -V "'ipu1_ic_prpvf':1 [fmt:$outputfmt field:none]"
 
 Streaming can then begin on the capture device node at
-- 
2.17.1

