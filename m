Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:40596 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755572AbdCGOns (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 09:43:48 -0500
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: CARLOS.PALMINHA@synopsys.com,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Benoit Parrot <bparrot@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Rick Chang <rick.chang@mediatek.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH 1/4] Documentation: dt: Add bindings documentation for DW MIPI CSI-2 Host
Date: Tue,  7 Mar 2017 14:37:48 +0000
Message-Id: <3478bf7c84fd8c8bdcff4f0170ee0344eca13f60.1488885081.git.roliveir@synopsys.com>
In-Reply-To: <cover.1488885081.git.roliveir@synopsys.com>
References: <cover.1488885081.git.roliveir@synopsys.com>
In-Reply-To: <cover.1488885081.git.roliveir@synopsys.com>
References: <cover.1488885081.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create device tree bindings documentation for the Synopsys DW MIPI CSI-2
 Host.

Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
---
 .../devicetree/bindings/media/snps,dw-mipi-csi.txt | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt

diff --git a/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt b/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt
new file mode 100644
index 000000000000..5b24eb43d760
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt
@@ -0,0 +1,37 @@
+Synopsys DesignWare CSI-2 Host controller
+
+Description
+-----------
+
+This HW block is used to receive image coming from an MIPI CSI-2 compatible
+camera.
+
+Required properties:
+- compatible: shall be "snps,dw-mipi-csi"
+- reg		: physical base address and size of the device memory mapped
+  registers;
+- interrupts	: CSI-2 Host interrupt
+- output-type   : Core output to be used (IPI-> 0 or IDI->1 or BOTH->2) These
+  values choose which of the Core outputs will be used, it can be Image Data
+  Interface or Image Pixel Interface.
+- phys: List of one PHY specifier (as defined in
+  Documentation/devicetree/bindings/phy/phy-bindings.txt). This PHY is a MIPI
+  DPHY working in RX mode.
+- resets: Reference to a reset controller (optional)
+
+Optional properties(if in IPI mode):
+- ipi-mode 	: Mode to be used when in IPI(Camera -> 0 or Controller -> 1)
+  This property defines if the controller will use the video timings available
+  in the video stream or if it will use pre-defined ones.
+- ipi-color-mode: Bus depth to be used in IPI (48 bits -> 0 or 16 bits -> 1)
+  This property defines the width of the IPI bus.
+- ipi-auto-flush: Data auto-flush (1 -> Yes or 0 -> No). This property defines
+  if the data is automatically flushed in each vsync or if this process is done
+  manually
+- virtual-channel: Virtual channel where data is present when in IPI mode. This
+  property chooses the virtual channel which IPI will use to retrieve the video
+  stream.
+
+The per-board settings:
+ - port sub-node describing a single endpoint connected to the camera as
+   described in video-interfaces.txt[1].
-- 
2.11.0
