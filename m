Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1564C43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 17:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81DCA208E4
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 17:37:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="a0rdhqLi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfCHRhg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:37:36 -0500
Received: from mail-eopbgr820041.outbound.protection.outlook.com ([40.107.82.41]:10272
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726747AbfCHRhg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 12:37:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/ZeZXnZb6252rnhVCw38qItIdjVjvElSlJck2yYisY=;
 b=a0rdhqLiP5m3cIxl5vbBDJklNztDiHvqbvKaUtLroS6oHWm4qohbsWgbnVwHKVyE8SMkrxA3bwHzUCfbzTGI2AqgrRN7ePUSMho5EaG2UoBFXDNzRuJaIX1Ijre45UgpaNxyc0RBbaeD8/ZkJcsoAS5sbn+2POEfN1cQ6f8EGc0=
Received: from MN2PR02CA0030.namprd02.prod.outlook.com (2603:10b6:208:fc::43)
 by DM5PR02MB2379.namprd02.prod.outlook.com (2603:10b6:3:51::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1665.18; Fri, 8 Mar
 2019 17:37:31 +0000
Received: from BL2NAM02FT054.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::208) by MN2PR02CA0030.outlook.office365.com
 (2603:10b6:208:fc::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1686.18 via Frontend
 Transport; Fri, 8 Mar 2019 17:37:31 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 BL2NAM02FT054.mail.protection.outlook.com (10.152.77.107) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1686.19
 via Frontend Transport; Fri, 8 Mar 2019 17:37:30 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:57884 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h2JR4-0002sL-62; Fri, 08 Mar 2019 09:37:30 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h2JQz-0001pw-1v; Fri, 08 Mar 2019 09:37:25 -0800
Received: from xsj-pvapsmtp01 (xsj-smtp1.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x28HbG74001162;
        Fri, 8 Mar 2019 09:37:16 -0800
Received: from [172.23.29.77] (helo=xhdyacto-vnc1.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h2JQp-0001nL-VG; Fri, 08 Mar 2019 09:37:16 -0800
From:   Vishal Sagar <vishal.sagar@xilinx.com>
To:     Hyun Kwon <hyunk@xilinx.com>, <laurent.pinchart@ideasonboard.com>,
        <mchehab@kernel.org>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        Michal Simek <michals@xilinx.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <sakari.ailus@linux.intel.com>, <hans.verkuil@cisco.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Dinesh Kumar <dineshk@xilinx.com>,
        Sandip Kothari <sandipk@xilinx.com>
CC:     Vishal Sagar <vishal.sagar@xilinx.com>
Subject: [PATCH v4 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem
Date:   Fri, 8 Mar 2019 23:01:27 +0530
Message-ID: <1552066288-58404-2-git-send-email-vishal.sagar@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1552066288-58404-1-git-send-email-vishal.sagar@xilinx.com>
References: <1552066288-58404-1-git-send-email-vishal.sagar@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(39860400002)(396003)(2980300002)(189003)(199004)(51416003)(426003)(110136005)(486006)(126002)(316002)(36386004)(16586007)(4326008)(305945005)(6636002)(7416002)(50226002)(2906002)(63266004)(44832011)(106466001)(47776003)(478600001)(336012)(36756003)(107886003)(81166006)(8936002)(81156014)(9786002)(8676002)(11346002)(356004)(6666004)(2616005)(48376002)(186003)(446003)(86362001)(77096007)(106002)(76176011)(26005)(2201001)(5660300002)(7696005)(50466002)(14444005)(476003)(921003)(83996005)(5001870100001)(1121003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR02MB2379;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-100.xilinx.com,xapps1.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c4fe503-466b-420f-ee0d-08d6a3ecbdc0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:DM5PR02MB2379;
X-MS-TrafficTypeDiagnostic: DM5PR02MB2379:
X-Microsoft-Exchange-Diagnostics: 1;DM5PR02MB2379;20:dxZ5Mq7viZolijO6tiOkWLT50iMkd8Re/WZR3NhY/hKpkhakP4fgETApY+TpaKuyE0yIwYT8JCxAj1TrdQK6A2gmFHubazjEPrp1b3drlOsJQc7/WLvVg7ICpAMNCih73BQes1kvswUnB6de+FTh3aD/GGvIWnD0Olg7MpS6HiCOcdkJXQz2Hyu1sxd9W5ou1Yke6qDnM7u+iO5Qg/oar0WIMzcxngidsAWy2Uskx6o1SaMzByNU0WJao7Gdfii6iUzkoljw81mtTY4rGvAHVZ8tLZDNGXEpoLaE57HQ+abVh38XuLYKGv5uPlUZwHraMAmbonQK47vBnSre6HiaE7GVDmRtbmt2GSfcIutzD4uCr8n61IG5zbT1xdtKkKK3xHxN5Ly3SaO+0ho5Iz253FPSTMIxyQ6MdrHVjMR8NnMCuG0iHjZGMKqacLFSLGYu57Dbq2YL3Uf/xkMKH/1puASARhMk+pobxHevHDsqn+C4hXNyxTcreIN+yCmtNwTs
X-Microsoft-Antispam-PRVS: <DM5PR02MB23795E3BD1DB4985FC5D5543F64D0@DM5PR02MB2379.namprd02.prod.outlook.com>
X-Forefront-PRVS: 0970508454
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;DM5PR02MB2379;23:bfwJX1ABb0CL6VaQbKDsXrfgiHqj7O5+BbrJ+QfSE?=
 =?us-ascii?Q?tT2+MeBkut/JJRo+qbW364IdCXi+ruSNAWcgnLbcewkZ+Nztk2eRWtTh2O4d?=
 =?us-ascii?Q?hMenydKn8sy/g97zVte5GuLzvYs6xk/KkopCzEVCf67PTkYIcQEHTEv4epv6?=
 =?us-ascii?Q?QtaIYAmqsu5DvhygwlMSRea1IrctoqOXO7UR9SkTKZ8kv9F+iwdvtqvnSCxj?=
 =?us-ascii?Q?qDyg71dnmjjtmeYn0FAWgwh4J4uvVw5IFvQDazjZGxI2xQy6NHcbf4NLhmit?=
 =?us-ascii?Q?gLH780YmOZbAgU6x+Uk7aDuEkwop4o41a3zxhObli2sgn0qCkxLjcEBANpIN?=
 =?us-ascii?Q?2rrgc25AQkErEbvXPmK394tpS9RwYgnDJHXm4KaGZb/CA7fqyxab6mqwa35a?=
 =?us-ascii?Q?fygxBqIfeX7s66nd0c/6L0DfaZI7Ldm6XP8TNU/9Ncd/tORG8b+dnKeqC0Hu?=
 =?us-ascii?Q?gPjAvKLetbx6CZ4QRpxvuokGoW5GJpFAL+lEi3Jwsu3yON6YOMh/HvUb4XvX?=
 =?us-ascii?Q?z42d4Br8h5l4fxjqe6Va5vI8a0BN7HgX0CTs3j3m2xzngILprLZYtZfaqYhO?=
 =?us-ascii?Q?+5M9YwZ5iIcz8R5EB5lTKAT0BIvt+TR0vDfSproOXEbJLgYeE73BozB5ARhP?=
 =?us-ascii?Q?nQTYc4Apr2FKdehf9hhKY5CMjWVSWZCKfkKEd7FfZ8fSgx3v5ibh3W5RaaTM?=
 =?us-ascii?Q?p8ayW9n37NqbLGCvIny4EpdCD9TyUiGWzjEbJKXDISbs/C9YjvEZfZHSJnIA?=
 =?us-ascii?Q?p1N+aN6qqnSHxdEWfKFEuS5TWXc4HbRzL4OU/Mp53JwL6Ot+qfuVs5lHApv5?=
 =?us-ascii?Q?x3/p3PVMw5QcETtdP4T0Tupq2cykFAGbwbtQG7PHrjQNooDnQRawWPaEIhW6?=
 =?us-ascii?Q?opWP8b+usLB/F0GHX2UtvBs7dVPdsPq2zqgxUbG/sQXUNU0ky7TBwFs/hvKt?=
 =?us-ascii?Q?bI3XX1vXU/orRX8mef/zRnbM/5IAFJlUnKqgBqcgCy4+rtGzwI+aQmNUzGq8?=
 =?us-ascii?Q?9rM1OyNfb7bJ5MW95PFpCJPLjPeiGlofSJ8NRK2kJA2BJMO/qojrEocHkOsW?=
 =?us-ascii?Q?ZGtt2E5Jm6BvoMsxWbKKCPU0puZmIcxaXPB3QpaNMQ1RXLRDPoQRsGBLVS1d?=
 =?us-ascii?Q?9jFLRV1N+vDW7tFuaw34RMPgDahzi5P32nJUSyQPaPhQ2R8vBCik1hyl2cMk?=
 =?us-ascii?Q?xgQAUs/+/33bd3n4V+p4bXol/EdEisNDwM80B7v79XarXm1diwg0XpPuNtUL?=
 =?us-ascii?Q?EF0ffOqjki577v+BIM2DV2995lT9o7QX1LbOcHu?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: fNHBM1e7em72p6JF5/zcbl0L3iyWNMlXGoGrEzAesbWZIizhinqzR3uia60sTR/fBJr8P7lpl1A4vGt88eoqM2qMxe2emVVF/9/jeJjlVTYB5uT/qUAHd86LeXmnn6VPbWgIm/ktsj7hUpg6jV0VucSDPx557ElnmLVE3A6mGkk8Lt2K0o7gio+lR5fE4tFPCC8OuPQWAKEB4aU5jSSKbT7HGwnYNfGVyS+/Ww7552NXI/RNQw/Q97Yay6z8XyBveaF6j0zilumEZc4arlvL8+eP3MPPrWTyPwd884aciJyS2udVVduQ39U4YPMkrJq2rPEJSPGXBLPWnN2e5xR91LccF6SHRmndGHH9FGAIR/1TEj1i/dSRLYVAh1oKLr98fRb58AT+DwI3Ny/i3xf4DrU17Kk6/3xHfN+hJgHWhRs=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2019 17:37:30.8239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c4fe503-466b-420f-ee0d-08d6a3ecbdc0
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB2379
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.

The Xilinx MIPI CSI-2 Rx Subsystem consists of a CSI-2 Rx controller, a
DPHY in Rx mode, an optional I2C controller and a Video Format Bridge.

Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
Reviewed-by: Hyun Kwon <hyun.kwon@xilinx.com>
---
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

 .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 123 +++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt

diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
new file mode 100644
index 0000000..399f7fa
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
@@ -0,0 +1,123 @@
+Xilinx MIPI CSI2 Receiver Subsystem Device Tree Bindings
+--------------------------------------------------------
+
+The Xilinx MIPI CSI2 Receiver Subsystem is used to capture MIPI CSI2 traffic
+from compliant camera sensors and send the output as AXI4 Stream video data
+for image processing.
+
+The subsystem consists of a MIPI DPHY in slave mode which captures the
+data packets. This is passed along the MIPI CSI2 Rx IP which extracts the
+packet data. The Video Format Bridge (VFB) converts this data to AXI4 Stream
+video data.
+
+For more details, please refer to PG232 Xilinx MIPI CSI-2 Receiver Subsystem.
+
+Required properties:
+--------------------
+- compatible: Must contain "xlnx,mipi-csi2-rx-subsystem-4.0".
+- reg: Physical base address and length of the registers set for the device.
+- interrupts: Property with a value describing the interrupt number.
+- clocks: List of phandles to AXI Lite, Video and 200 MHz DPHY clocks.
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
+- xlnx,en-active-lanes: Enable Active lanes configuration in Protocol
+  Configuration Register.
+
+Ports
+-----
+The device node shall contain two 'port' child nodes as defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+The port@0 is sink port and shall connect to CSI2 source like camera.
+It must have the data-lanes property. It may have the xlnx,cfa-pattern
+property to indicate bayer pattern of source.
+
+The port@1 is source port could be connected to any video processing IP
+which can work with AXI4 Stream data.
+
+Required port properties:
+--------------------
+- reg: 0 - for sink port.
+       1 - for source port.
+
+Optional port properties:
+--------------------
+- xlnx,cfa-pattern: This goes in the sink port to indicate bayer pattern.
+  Valid values are "bggr", "rggb", "gbrg" and "grbg".
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
+	csiss_1: csiss@a0020000 {
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
+		clocks = <&misc_clk_0>, <&misc_clk_1>, <&misc_clk_2>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				/* Sink port */
+				reg = <0>;
+				xlnx,cfa-pattern = "bggr"
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

