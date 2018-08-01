Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42158 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbeHAVAP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 17:00:15 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 14/14] media: imx.rst: Update doc to reflect fixes to interlaced capture
Date: Wed,  1 Aug 2018 12:12:27 -0700
Message-Id: <1533150747-30677-15-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also add an example pipeline for unconverted capture with interweave
on SabreAuto.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes since v2:
- expand on idmac interweave behavior in CSI subdev.
- switch second SabreAuto pipeline example to PAL to give
  both NTSC and PAL examples.
- Cleanup some language in various places.
---
 Documentation/media/v4l-drivers/imx.rst | 93 +++++++++++++++++++++------------
 1 file changed, 60 insertions(+), 33 deletions(-)

diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
index 65d3d15..1f6279d 100644
--- a/Documentation/media/v4l-drivers/imx.rst
+++ b/Documentation/media/v4l-drivers/imx.rst
@@ -22,8 +22,8 @@ memory. Various dedicated DMA channels exist for both video capture and
 display paths. During transfer, the IDMAC is also capable of vertical
 image flip, 8x8 block transfer (see IRT description), pixel component
 re-ordering (for example UYVY to YUYV) within the same colorspace, and
-even packed <--> planar conversion. It can also perform a simple
-de-interlacing by interleaving even and odd lines during transfer
+packed <--> planar conversion. The IDMAC can also perform a simple
+de-interlacing by interweaving even and odd lines during transfer
 (without motion compensation which requires the VDIC).
 
 The CSI is the backend capture unit that interfaces directly with
@@ -173,15 +173,19 @@ via the SMFC and an IDMAC channel, bypassing IC pre-processing. This
 source pad is routed to a capture device node, with a node name of the
 format "ipuX_csiY capture".
 
-Note that since the IDMAC source pad makes use of an IDMAC channel, it
-can do pixel reordering within the same colorspace. For example, the
+Note that since the IDMAC source pad makes use of an IDMAC channel, the
+CSI can do pixel reordering within the same colorspace. For example, the
 sink pad can take UYVY2X8, but the IDMAC source pad can output YUYV2X8.
 If the sink pad is receiving YUV, the output at the capture device can
 also be converted to a planar YUV format such as YUV420.
 
-It will also perform simple de-interlace without motion compensation,
-which is activated if the sink pad's field type is an interlaced type,
-and the IDMAC source pad field type is set to none.
+The CSI will also perform simple interweave without motion compensation,
+which is activated if the source pad's field type is sequential top-bottom
+or bottom-top or alternate, and the capture interface field type is set
+to interlaced (t-b, b-t, or unqualified interlaced). The capture interface
+will enforce the same field order if the source pad field type is seq-bt
+or seq-tb. However if the source pad's field type is alternate, any
+interlaced type at the capture interface will be accepted.
 
 This subdev can generate the following event when enabling the second
 IDMAC source pad:
@@ -323,14 +327,14 @@ ipuX_vdic
 
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
@@ -343,8 +347,8 @@ ipuX_ic_prp
 This is the IC pre-processing entity. It acts as a router, routing
 data from its sink pad to one or both of its source pads.
 
-It has a single sink pad. The sink pad can receive from the ipuX_csiY
-direct pad, or from ipuX_vdic.
+This entity has a single sink pad. The sink pad can receive from the
+ipuX_csiY direct pad, or from ipuX_vdic.
 
 This entity has two source pads. One source pad routes to the
 pre-process encode task entity (ipuX_ic_prpenc), the other to the
@@ -367,8 +371,8 @@ color-space conversion, resizing (downscaling and upscaling),
 horizontal and vertical flip, and 90/270 degree rotation. Flip
 and rotation are provided via standard V4L2 controls.
 
-Like the ipuX_csiY IDMAC source, it can also perform simple de-interlace
-without motion compensation, and pixel reordering.
+Like the ipuX_csiY IDMAC source, this entity can also perform simple
+de-interlace without motion compensation, and pixel reordering.
 
 ipuX_ic_prpvf
 -------------
@@ -378,18 +382,18 @@ pad from ipuX_ic_prp, and a single source pad. The source pad is routed
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
+Like the ipuX_csiY IDMAC source, this entity can perform simple
+interweaving without motion compensation. However, note that if the
+ipuX_vdic is included in the pipeline (ipuX_ic_prp is receiving from
+ipuX_vdic), it's not possible to use interweave in ipuX_ic_prpvf,
+since the ipuX_vdic has already carried out de-interlacing (with
+motion compensation) and therefore the field type output from
+ipuX_vdic can only be none (progressive).
 
 Capture Pipelines
 -----------------
@@ -514,10 +518,33 @@ On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
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
 
@@ -529,11 +556,11 @@ entity at its output pad:
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
2.7.4
