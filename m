Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6314EC43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 11:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2775E20854
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 11:31:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="CuM6BiPL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfCNLa5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 07:30:57 -0400
Received: from mail-eopbgr750071.outbound.protection.outlook.com ([40.107.75.71]:28392
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726726AbfCNLa5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 07:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPfdSjjPe9QI+ZGuK2UkwniPZGlhNj2TtDmrEEMLJAQ=;
 b=CuM6BiPL3fFseQwImymW93Um7hp6d6jDq6DL/WIkQ8J1h5FKkbD6w3jzPjZeRlkLTIsRj3h/vEJAX6LGEOJ4s+lB6GK+tEuEgIO/8ANIZ3YlDvQu/YGZQtoq9dicFfCvvZPs6qxLdcMDVh/ZiS+SpTXSEPXkAtdNzMVyCE68woA=
Received: from CY4PR02CA0003.namprd02.prod.outlook.com (2603:10b6:903:18::13)
 by DM5PR02MB2812.namprd02.prod.outlook.com (2603:10b6:3:108::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1686.22; Thu, 14 Mar
 2019 11:30:48 +0000
Received: from BL2NAM02FT026.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::200) by CY4PR02CA0003.outlook.office365.com
 (2603:10b6:903:18::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1709.13 via Frontend
 Transport; Thu, 14 Mar 2019 11:30:48 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; ideasonboard.com; dkim=none (message not signed)
 header.d=none;ideasonboard.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 BL2NAM02FT026.mail.protection.outlook.com (10.152.77.156) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1709.13
 via Frontend Transport; Thu, 14 Mar 2019 11:30:47 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:41069 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h4OZT-0007v0-6G; Thu, 14 Mar 2019 04:30:47 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h4OZO-0002iJ-2M; Thu, 14 Mar 2019 04:30:42 -0700
Received: from [172.23.29.77] (helo=xhdyacto-vnc1.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h4OZK-0002df-0f; Thu, 14 Mar 2019 04:30:38 -0700
From:   Vishal Sagar <vishal.sagar@xilinx.com>
To:     Hyun Kwon <hyunk@xilinx.com>, <laurent.pinchart@ideasonboard.com>,
        <mchehab@kernel.org>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        Michal Simek <michals@xilinx.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <sakari.ailus@linux.intel.com>, <hans.verkuil@cisco.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Dinesh Kumar <dineshk@xilinx.com>,
        Sandip Kothari <sandipk@xilinx.com>,
        Luca Ceresoli <luca@lucaceresoli.net>
CC:     Vishal Sagar <vishal.sagar@xilinx.com>
Subject: [PATCH v7 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem
Date:   Thu, 14 Mar 2019 16:54:50 +0530
Message-ID: <1552562691-14445-2-git-send-email-vishal.sagar@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1552562691-14445-1-git-send-email-vishal.sagar@xilinx.com>
References: <1552562691-14445-1-git-send-email-vishal.sagar@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(39860400002)(376002)(396003)(2980300002)(189003)(199004)(48376002)(426003)(14444005)(106466001)(63266004)(2616005)(36756003)(50226002)(126002)(7416002)(4326008)(36386004)(11346002)(77096007)(2906002)(356004)(6666004)(107886003)(26005)(446003)(476003)(8936002)(110136005)(8676002)(86362001)(16586007)(47776003)(486006)(316002)(106002)(76176011)(2201001)(5660300002)(7696005)(9786002)(478600001)(81156014)(81166006)(50466002)(186003)(305945005)(336012)(44832011)(51416003)(921003)(1121003)(83996005)(2101003)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR02MB2812;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-100.xilinx.com,xapps1.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cbf522e-ae7e-4e51-5746-08d6a8708165
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:DM5PR02MB2812;
X-MS-TrafficTypeDiagnostic: DM5PR02MB2812:
X-Microsoft-Exchange-Diagnostics: 1;DM5PR02MB2812;20:ggt2oyEgB/24zE7JRrTkp8bwitAJVLfWjCh7VsSrcyFiwc5hnPziZCvmcsdOwDEVHbQwmdAYe3H4p6agSjpZQ2XRpAeYdd8DsVOFUNbbbuj6Zy5JZ1F1LbHaJJlKrOJqjqsuK/CWzG4cVtFXZaXjrlfkaNK4yXQ+x3GoSAyeJdtyI4qTUG7/EtxPscnSaVlR+1WHvyLNoWtTL5GDnlGHW7fmp0YIYOUalGp8E6etokGTyOR1v1v4kecz//hxdZpMRFUZgvtss/JOkbI5mkWbZeaXMqQ7pEDSETpmRs0N4NqAK8hyoFULaQsFi1eS4BOTSycR56FsdJb7SZvHAIRV2VA6r3iOQCJnSIeyAzX1hc+1atOO5JNuHVEIMoGJfCfyYi/wOQfgZ4H1UFtyHRAk62fW3XrVlIyex57In3sPPN62yW1kLnErMg7nOASUgtJwl2kjVDaw4PIwwBh5dK9txJEveXUZGcOOUZkIUXCgIdGer9SXVBAqPIplaNtG2jpa
X-Microsoft-Antispam-PRVS: <DM5PR02MB28122FD536D055F87651D5E0F64B0@DM5PR02MB2812.namprd02.prod.outlook.com>
X-Forefront-PRVS: 09760A0505
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;DM5PR02MB2812;23:cJrR5jpCr6u9f6muyj1jMZj9d0ai+STnYMaE4h5rs?=
 =?us-ascii?Q?4UbRDrKNnJETyH9vVWtwgksuQ5gV6xdSATN6ek3A6UgReQsT6GetQmb6W+Uh?=
 =?us-ascii?Q?8B5lhV63ybxca41xsaRC0XzEJXOsbOl+vxi/OAJZmnufG1GQUPYZkPW7tO6J?=
 =?us-ascii?Q?sv2d1Ht8WQY7Ts9oTX08kMTeJWWmjY40eVgH2Iqvv9o6Ms5jQxZPI7ymsgPB?=
 =?us-ascii?Q?RPEyvW7nQIsW2M3vbWj8Mr5YkoLXrqDLBD7cKTpbb/XDx/sQFMKM/0rodVZd?=
 =?us-ascii?Q?Vox1asdqPzPN12yEoDdFPkHjaDq8U0WvItrrbD8wi6nQBLlojyK6gJOw/iA6?=
 =?us-ascii?Q?54tj2JLKuygjcO3hnUF7PX5duChKVsq2D0++v7PSpwsBZbB3FCrsZAW0C1ew?=
 =?us-ascii?Q?Fgkx+vGzyXYjmAA0rOpHgaf2hcQ8m8Ys1tGQcWHzD8f1JzRPD6iBJoV+Lh7O?=
 =?us-ascii?Q?mhINGfHBW2dWcLZV17qxYA3as5Si7Q8WOZk7grzFHDPjZxhJ8+FAB/ghMRFZ?=
 =?us-ascii?Q?OfOnQadzs5gy/Iq6V/pIf8/ZoTPYlYuaq60HhZCRqAChDjPnA3zh8lgVYCDn?=
 =?us-ascii?Q?gwgWkbZL/YxLIQXa7GYccm3O5TQNacAObofhej/FcpmQhnvDGm9ovLvdfIQt?=
 =?us-ascii?Q?OiZtGEk28gktjY/vpEB0N9q3ngmvpsqkeYJNkPclWvhBljNau2P0WCm/PJgX?=
 =?us-ascii?Q?ym8I+FTU/Pq++n9S6uenBXiXMFv78vPzvQ2I14b1iwuXqfGDSHtxcaYQcwo8?=
 =?us-ascii?Q?yUwM51bvmMalOlbnrEvDyxDuecoCPjSmztLGPztJjbxMZ1Qa2VNt/+xqIN/f?=
 =?us-ascii?Q?YnYRPnSYk2oxz8qtYz6e4kmhqVXwZKCLTmkz7CQQf4XaM6u11tLobvMLHjV+?=
 =?us-ascii?Q?RfitZIHjz29SnHUloY8iUuIq471eDn0qN+U+5UBBnR4Ep0lL4W8FrI8+af8t?=
 =?us-ascii?Q?oCPKzsn7G87HMI+CK9+bBFFbLR+g51T+OiK8cs3b3jTnT+GGOLzabhakD9wm?=
 =?us-ascii?Q?J6PPp7d+bwCbMcIvUeLihKNGgcHotwvV3adkyfOpaI4KK0Fdy/KLironPShn?=
 =?us-ascii?Q?wLOTtgk/9JyrXKsinyWLkYEJ/F5zJzWC9ihV9VGowAfPE0obTLvG/SL3TEoE?=
 =?us-ascii?Q?/dd4yFlKk3HVwz5qFj6mz65ITqIOlQDBdlVEHvjb4MCkGLrbu8ML0OLhQdgP?=
 =?us-ascii?Q?6+SmZH8uJD88LB6iQBG1PFM0QHhVjyN47OrZbl6jVXdgLd7TYBgDEliDIkws?=
 =?us-ascii?Q?lYptqvDsrvumjk8xAc=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: WrsrBI4k/KPErKr7HPAVKskvqfK9Nv2c/TF7KwX2mzIG7b+KshVHs2yySSASFBz5/yVHMW+TGmfHpVCnuuumw0jFk0J60GjZd44xvwx9WPw3q2K9lSDsAYenHLlVD4vm1zugUIxPum4031ZreloQ9cDyfs6qhYX5x27fQkJAfooQjK+je8iDCCxfTY/Kfv2mQZOgh/6RIkc9St3j5edswZDjI1pV9I/PhQg5PbI/27Q7gKViqpgrJ1sB88YIFAxb/TAth/D0KDstjww91l/5v6gSoWKVnb1Faw56gae1fHdnpkoeo8YHZP254za+MKG+XE/Ih7SVa2U8tc01AMatwVFm+LcY+lC5I7MnuopdQQeCU0q5rR3EcBJQ9HIxlWEh/7RnMv87PAGMTY2qty5D94VckyGiSOsJB6ToGR+mRGw=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2019 11:30:47.7787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cbf522e-ae7e-4e51-5746-08d6a8708165
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB2812
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.

The Xilinx MIPI CSI-2 Rx Subsystem consists of a CSI-2 Rx controller, a
DPHY in Rx mode, an optional I2C controller and a Video Format Bridge.

Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
Reviewed-by: Hyun Kwon <hyun.kwon@xilinx.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
v7
- Removed the control name from dt bindings
- Updated the example dt node name to csi2rx

v6
- Added "control" after V4L2_CID_XILINX_MIPICSISS_ACT_LANES as suggested by Luca
- Added reviewed by Rob Herring

v5
- Incorporated comments by Luca Cersoli
- Removed DPHY clock from description and example
- Removed bayer pattern from device tree MIPI CSI IP
  doesn't deal with bayer pattern.

v4
- Added reviewed by Hyun Kwon

v3
- removed interrupt parent as suggested by Rob
- removed dphy clock
- moved vfb to optional properties
- Added required and optional port properties section
- Added endpoint property section

v2
- updated the compatible string to latest version supported
- removed DPHY related parameters
- added CSI v2.0 related property (including VCX for supporting upto 16
  virtual channels).
- modified csi-pxl-format from string to unsigned int type where the value
  is as per the CSI specification
- Defined port 0 and port 1 as sink and source ports.
- Removed max-lanes property as suggested by Rob and Sakari

 .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 117 +++++++++++++++++++++
 1 file changed, 117 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt

diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
new file mode 100644
index 0000000..73c18bc
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
@@ -0,0 +1,117 @@
+Xilinx MIPI CSI2 Receiver Subsystem Device Tree Bindings
+--------------------------------------------------------
+
+The Xilinx MIPI CSI2 Receiver Subsystem is used to capture MIPI CSI2 traffic
+from compliant camera sensors and send the output as AXI4 Stream video data
+for image processing.
+
+The subsystem consists of a MIPI DPHY in slave mode which captures the
+data packets. This is passed along the MIPI CSI2 Rx IP which extracts the
+packet data. The optional Video Format Bridge (VFB) converts this data to
+AXI4 Stream video data.
+
+For more details, please refer to PG232 Xilinx MIPI CSI-2 Receiver Subsystem.
+
+Required properties:
+--------------------
+- compatible: Must contain "xlnx,mipi-csi2-rx-subsystem-4.0".
+- reg: Physical base address and length of the registers set for the device.
+- interrupts: Property with a value describing the interrupt number.
+- clocks: List of phandles to AXI Lite and Video clocks.
+- clock-names: Must contain "lite_aclk" and "video_aclk" in the same order
+  as clocks listed in clocks property.
+- xlnx,csi-pxl-format: This denotes the CSI Data type selected in hw design.
+  Packets other than this data type (except for RAW8 and User defined data
+  types) will be filtered out. Possible values are as below -
+  0x1E - YUV4228B
+  0x1F - YUV42210B
+  0x20 - RGB444
+  0x21 - RGB555
+  0x22 - RGB565
+  0x23 - RGB666
+  0x24 - RGB888
+  0x28 - RAW6
+  0x29 - RAW7
+  0x2A - RAW8
+  0x2B - RAW10
+  0x2C - RAW12
+  0x2D - RAW14
+  0x2E - RAW16
+  0x2F - RAW20
+
+
+Optional properties:
+--------------------
+- xlnx,vfb: This is present when Video Format Bridge is enabled.
+  Without this property the driver won't be loaded as IP won't be able to generate
+  media bus format compliant stream output.
+- xlnx,en-csi-v2-0: Present if CSI v2 is enabled in IP configuration.
+- xlnx,en-vcx: When present, there are maximum 16 virtual channels, else
+  only 4. This is present only if xlnx,en-csi-v2-0 is present.
+- xlnx,en-active-lanes: present if the number of active lanes can be
+  re-configured at runtime in the Protocol Configuration Register.
+  Otherwise all lanes, as set in IP configuration, are always active.
+
+Ports
+-----
+The device node shall contain two 'port' child nodes as defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+The port@0 is a sink port and shall connect to CSI2 source like camera.
+It must have the data-lanes property.
+
+The port@1 is a source port and can be connected to any video processing IP
+which can work with AXI4 Stream data.
+
+Required port properties:
+--------------------
+- reg: 0 - for sink port.
+       1 - for source port.
+
+Optional endpoint property:
+---------------------------
+- data-lanes: specifies MIPI CSI-2 data lanes as covered in video-interfaces.txt.
+  This should be in the sink port endpoint which connects to MIPI CSI2 source
+  like sensor. The possible values are:
+  1       - For 1 lane enabled in IP.
+  1 2     - For 2 lanes enabled in IP.
+  1 2 3   - For 3 lanes enabled in IP.
+  1 2 3 4 - For 4 lanes enabled in IP.
+
+Example:
+
+	xcsi2rxss_1: csi2rx@a0020000 {
+		compatible = "xlnx,mipi-csi2-rx-subsystem-4.0";
+		reg = <0x0 0xa0020000 0x0 0x10000>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 95 4>;
+		xlnx,csi-pxl-format = <0x2a>;
+		xlnx,vfb;
+		xlnx,en-active-lanes;
+		xlnx,en-csi-v2-0;
+		xlnx,en-vcx;
+		clock-names = "lite_aclk", "video_aclk";
+		clocks = <&misc_clk_0>, <&misc_clk_1>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				/* Sink port */
+				reg = <0>;
+				csiss_in: endpoint {
+					data-lanes = <1 2 3 4>;
+					/* MIPI CSI2 Camera handle */
+					remote-endpoint = <&camera_out>;
+				};
+			};
+			port@1 {
+				/* Source port */
+				reg = <1>;
+				csiss_out: endpoint {
+					remote-endpoint = <&vproc_in>;
+				};
+			};
+		};
+	};
-- 
2.7.4

