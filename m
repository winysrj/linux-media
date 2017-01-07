Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34707 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933292AbdAGCL6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2017 21:11:58 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v3 01/24] [media] dt-bindings: Add bindings for i.MX media driver
Date: Fri,  6 Jan 2017 18:11:19 -0800
Message-Id: <1483755102-24785-2-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bindings documentation for the i.MX media driver.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 Documentation/devicetree/bindings/media/imx.txt | 57 +++++++++++++++++++++++++
 1 file changed, 57 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/imx.txt

diff --git a/Documentation/devicetree/bindings/media/imx.txt b/Documentation/devicetree/bindings/media/imx.txt
new file mode 100644
index 0000000..254b64a
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/imx.txt
@@ -0,0 +1,57 @@
+Freescale i.MX Media Video Devices
+
+Video Media Controller node
+---------------------------
+
+This is the parent media controller node for video capture support.
+
+Required properties:
+- compatible : "fsl,imx-media";
+- ports      : Should contain a list of phandles pointing to camera
+  	       sensor interface ports of IPU devices
+
+
+fim child node
+--------------
+
+This is an optional child node of the ipu_csi port nodes. If present and
+available, it enables the Frame Interval Monitor. Its properties can be
+used to modify the method in which the FIM measures frame intervals.
+Refer to Documentation/media/v4l-drivers/imx.rst for more info on the
+Frame Interval Monitor.
+
+Optional properties:
+- fsl,input-capture-channel: an input capture channel and channel flags,
+			     specified as <chan flags>. The channel number
+			     must be 0 or 1. The flags can be
+			     IRQ_TYPE_EDGE_RISING, IRQ_TYPE_EDGE_FALLING, or
+			     IRQ_TYPE_EDGE_BOTH, and specify which input
+			     capture signal edge will trigger the input
+			     capture event. If an input capture channel is
+			     specified, the FIM will use this method to
+			     measure frame intervals instead of via the EOF
+			     interrupt. The input capture method is much
+			     preferred over EOF as it is not subject to
+			     interrupt latency errors. However it requires
+			     routing the VSYNC or FIELD output signals of
+			     the camera sensor to one of the i.MX input
+			     capture pads (SD1_DAT0, SD1_DAT1), which also
+			     gives up support for SD1.
+
+
+mipi_csi2 node
+--------------
+
+This is the device node for the MIPI CSI-2 Receiver, required for MIPI
+CSI-2 sensors.
+
+Required properties:
+- compatible	: "fsl,imx6-mipi-csi2";
+- reg           : physical base address and length of the register set;
+- clocks	: the MIPI CSI-2 receiver requires three clocks: hsi_tx
+                  (the DPHY clock), video_27m, and eim_sel;
+- clock-names	: must contain "dphy", "cfg", "pix";
+
+Optional properties:
+- interrupts	: must contain two level-triggered interrupts,
+                  in order: 100 and 101;
-- 
2.7.4

