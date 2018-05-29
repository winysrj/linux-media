Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0087.outbound.protection.outlook.com ([104.47.38.87]:47008
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965433AbeE2S5o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 14:57:44 -0400
From: Vishal Sagar <vishal.sagar@xilinx.com>
To: <hyun.kwon@xilinx.com>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <sakari.ailus@linux.intel.com>, <hans.verkuil@cisco.com>,
        <mchehab@kernel.org>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <dineshk@xilinx.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Vishal Sagar <vishal.sagar@xilinx.com>
Subject: [PATCH 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem
Date: Wed, 30 May 2018 00:24:43 +0530
Message-ID: <1527620084-94864-2-git-send-email-vishal.sagar@xilinx.com>
In-Reply-To: <1527620084-94864-1-git-send-email-vishal.sagar@xilinx.com>
References: <1527620084-94864-1-git-send-email-vishal.sagar@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.

The Xilinx MIPI CSI-2 Rx Subsystem consists of a DPHY, CSI-2 Rx, an
optional I2C controller and an optional Video Format Bridge (VFB). The
active lanes can be configured at run time if enabled in the IP. The
DPHY register interface may also be enabled.

Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
---
 .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 117 +++++++++++++++++=
++++
 1 file changed, 117 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi=
2rxss.txt

diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.t=
xt b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
new file mode 100644
index 0000000..31ed721
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
@@ -0,0 +1,117 @@
+
+Xilinx MIPI CSI2 Receiver Subsystem Device Tree Bindings
+--------------------------------------------------------
+
+The Xilinx MIPI CSI2 Receiver Subsystem is used to capture MIPI CSI2 traff=
ic
+from compliant camera sensors and send the output as AXI4 Stream video dat=
a
+for image processing.
+
+The subsystem consists of a MIPI DPHY in slave mode which captures the
+data packets. This is passed along the MIPI CSI2 Rx IP which extracts the
+packet data. This data is taken in by the Video Format Bridge (VFB),
+if selected, and converted into AXI4 Stream video data at selected
+pixels per clock as per AXI4-Stream Video IP and System Design UG934.
+
+For more details, please refer to PG232 MIPI CSI-2 Receiver Subsystem.
+https://www.xilinx.com/support/documentation/ip_documentation/mipi_csi2_rx=
_subsystem/v3_0/pg232-mipi-csi2-rx.pdf
+
+Required properties:
+
+- compatible: Must contain "xlnx,mipi-csi2-rx-subsystem-2.0" or
+  "xlnx,mipi-csi2-rx-subsystem-3.0"
+
+- reg: Physical base address and length of the registers set for the devic=
e.
+
+- interrupt-parent: specifies the phandle to the parent interrupt controll=
er
+
+- interrupts: Property with a value describing the interrupt number.
+
+- xlnx,max-lanes: Maximum active lanes in the design.
+
+- xlnx,vc: Virtual Channel, specifies virtual channel number to be filtere=
d.
+  If this is 4 then all virtual channels are allowed.
+
+- xlnx,csi-pxl-format: This denotes the CSI Data type selected in hw desig=
n.
+  Packets other than this data type (except for RAW8 and User defined data
+  types) will be filtered out. Possible values are RAW6, RAW7, RAW8, RAW10=
,
+  RAW12, RAW14, RGB444, RGB555, RGB565, RGB666, RGB888 and YUV4228bit.
+
+- xlnx,axis-tdata-width: AXI Stream width, This denotes the AXI Stream wid=
th.
+  It depends on Data type chosen, Video Format Bridge enabled/disabled and
+  pixels per clock. If VFB is disabled then its value is either 0x20 (32 b=
it)
+  or 0x40(64 bit) width.
+
+- xlnx,video-format, xlnx,video-width: Video format and width, as defined =
in
+  video.txt.
+
+- port: Video port, using the DT bindings defined in ../video-interfaces.t=
xt.
+  The CSI 2 Rx Subsystem has a two ports, one input port for connecting to
+  camera sensor and other is output port.
+
+- data-lanes: The number of data lanes through which CSI2 Rx Subsystem is
+  connected to the camera sensor as per video-interfaces.txt
+
+Optional properties:
+
+- xlnx,en-active-lanes: Enable Active lanes configuration in Protocol
+  Configuration Register.
+
+- xlnx,dphy-present: This is equivalent to whether DPHY register interface=
 is
+  enabled or not.
+
+- xlnx,iic-present: This shows whether subsystem's IIC is present or not. =
This
+  affects the base address of the DPHY.
+
+- xlnx,vfb: Video Format Bridge, Denotes if Video Format Bridge is selecte=
d
+  so that output is as per AXI stream documented in UG934.
+
+- xlnx,ppc: Pixels per clock, Number of pixels to be transferred per pixel
+  clock. This is valid only if xlnx,vfb property is present.
+
+Example:
+
+       csiss_1: csiss@a0020000 {
+               compatible =3D "xlnx,mipi-csi2-rx-subsystem-3.0";
+               reg =3D <0x0 0xa0020000 0x0 0x20000>;
+               interrupt-parent =3D <&gic>;
+               interrupts =3D <0 95 4>;
+
+               xlnx,max-lanes =3D <0x4>;
+               xlnx,en-active-lanes;
+               xlnx,dphy-present;
+               xlnx,iic-present;
+               xlnx,vc =3D <0x4>;
+               xlnx,csi-pxl-format =3D "RAW8";
+               xlnx,vfb;
+               xlnx,ppc =3D <0x4>;
+               xlnx,axis-tdata-width =3D <0x20>;
+
+               ports {
+                       #address-cells =3D <1>;
+                       #size-cells =3D <0>;
+
+                       port@0 {
+                               reg =3D <0>;
+
+                               xlnx,video-format =3D <XVIP_VF_YUV_422>;
+                               xlnx,video-width =3D <8>;
+                               csiss_out: endpoint {
+                                       remote-endpoint =3D <&vcap_csiss_in=
>;
+                               };
+                       };
+                       port@1 {
+                               reg =3D <1>;
+
+                               xlnx,video-format =3D <XVIP_VF_YUV_422>;
+                               xlnx,video-width =3D <8>;
+
+                               csiss_in: endpoint {
+                                       data-lanes =3D <1 2 3 4>;
+                                       /* MIPI CSI2 Camera handle */
+                                       remote-endpoint =3D <&vs2016_out>;
+                               };
+
+                       };
+
+               };
+       };
--
2.7.4

This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
