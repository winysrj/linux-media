Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE22BC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 04:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83F66214D8
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 04:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="qtGE5g61"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfCLEli (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 00:41:38 -0400
Received: from mail-eopbgr780057.outbound.protection.outlook.com ([40.107.78.57]:6816
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725710AbfCLElh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 00:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtHI25o0JHzNVrXQAeyUyrZCLFuY+HXJ0XL2G8NGIWA=;
 b=qtGE5g61ndE8THk81Kk/kEXBQWuO5pSZcokqOpa9u3b44eHqj20osKesvp5cJwXxlT+8ySjNgtscjul00FEZKWR4g48qDycLQq4NpOiWxBLGb7jM1dt6Q3caQo8C5hXL4eA4aBCQ/IkIfSF7ksvaBswoynrz0M32A84Xm3nkSxI=
Received: from BYAPR02CA0061.namprd02.prod.outlook.com (2603:10b6:a03:54::38)
 by BY2PR0201MB1862.namprd02.prod.outlook.com (2a01:111:e400:58b5::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1643.20; Tue, 12 Mar
 2019 04:41:34 +0000
Received: from CY1NAM02FT063.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::206) by BYAPR02CA0061.outlook.office365.com
 (2603:10b6:a03:54::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1665.19 via Frontend
 Transport; Tue, 12 Mar 2019 04:41:33 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT063.mail.protection.outlook.com (10.152.75.161) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1686.19
 via Frontend Transport; Tue, 12 Mar 2019 04:41:33 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h3ZEK-0000Fh-NA; Mon, 11 Mar 2019 21:41:32 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h3ZEF-00021w-Ja; Mon, 11 Mar 2019 21:41:27 -0700
Received: from xsj-pvapsmtp01 (xsj-mail.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x2C4fN7u014057;
        Mon, 11 Mar 2019 21:41:24 -0700
Received: from [172.23.29.77] (helo=xhdyacto-vnc1.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h3ZEB-0001yN-Fq; Mon, 11 Mar 2019 21:41:23 -0700
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
Subject: [PATCH v6 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem
Date:   Tue, 12 Mar 2019 10:05:29 +0530
Message-ID: <1552365330-21155-2-git-send-email-vishal.sagar@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1552365330-21155-1-git-send-email-vishal.sagar@xilinx.com>
References: <1552365330-21155-1-git-send-email-vishal.sagar@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(376002)(136003)(39860400002)(346002)(2980300002)(189003)(199004)(76176011)(7416002)(7696005)(51416003)(50226002)(26005)(9786002)(2906002)(81156014)(50466002)(186003)(8936002)(316002)(110136005)(16586007)(106002)(81166006)(2201001)(47776003)(44832011)(63266004)(48376002)(446003)(426003)(77096007)(6636002)(356004)(305945005)(36386004)(336012)(486006)(36756003)(14444005)(2616005)(476003)(126002)(86362001)(8676002)(11346002)(5660300002)(4326008)(107886003)(106466001)(478600001)(921003)(2101003)(1121003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR0201MB1862;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47bb5580-3f23-43e1-73a7-08d6a6a5011c
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:BY2PR0201MB1862;
X-MS-TrafficTypeDiagnostic: BY2PR0201MB1862:
X-Microsoft-Exchange-Diagnostics: 1;BY2PR0201MB1862;20:i8cgeGQiZp4z1tYJq6Vk0JzkGkRkhU2HMcB+1Go5qekvUbWpTWl/E5NLr/QWx+1ZncsKzLuqAs7XJkSyts9QSK1KvZist7Ew20btiCoaVv87tRWFyU1GqUKLvT6z1EbIcHMsnI5LpmNmNjBDbxRmvF1jxkPKV0KENpD5nO6VmRFUMh0rt+EsRMTPTca8T3Kpl09jXtMQgY+mhbIFvlmedkETJWt/wgFgj0Ka/nSuMIphGWy6g/+DlOF4+fP41Kv8e777VPbUq1yl/NDjugTYb42aLcAuoPTRGfLix0lT5QvKkKUfQFEk1JMge2cS2e+8QqD1VOtoYVTv/lI0D+aRDThyec9H07RRn6d7QWNgQVJgpLO2L9EJ7SiBL1xDHcXA/yjsXUXoJ/TfIon4Fw4HkZ/pMVIJbU3GQ3mVwOVA4XXlKCw2L37qOHy7D19m96HjmrtC9HDKxoB4jXeQkvZ9dBwIl2pZYfJo7+OqX1RENax1jFyqBKpRd8OvaYBbWx99
X-Microsoft-Antispam-PRVS: <BY2PR0201MB186228BCCF963DC8C5326E51F6490@BY2PR0201MB1862.namprd02.prod.outlook.com>
X-Forefront-PRVS: 09749A275C
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BY2PR0201MB1862;23:I0ge0KLqFg5dclmWDZbxDz8MllVoBR/5+D5JsgZ?=
 =?us-ascii?Q?PF4LUIynQKTNYMmsH0M7xar6To8nKzm8l4uFL4eBvyAzxYhUOGf03xeUX1Cb?=
 =?us-ascii?Q?foNr3Bc461UKFENRDe7f6kyY/mCwhzaZTLyNqhb5ibR65kN3aQLB9L2a0O7R?=
 =?us-ascii?Q?H93EZziVqig1RICaWy3rTA0hvnL02mgjbCrJuXOpt4gYiemBBhq/gdS8tW9O?=
 =?us-ascii?Q?iX7DL4hyXhY1h+bOTdbKkmnO98p3Rw6n47g67lKLjdy4VUXidxlDmylwD/U0?=
 =?us-ascii?Q?ykEa2+KdPaxfsWEaORPZ6q/29NobYSXXmXqtvnqYTg/5nL2Z5lZ0CZY61Kh3?=
 =?us-ascii?Q?vwiWKV8I03zTEkRAsik91zv3AoBK+byhhkWEwH/48E43IFyKta6HOQG0YDl+?=
 =?us-ascii?Q?nGJiiPef0BGWcBfd48U0UxJfZp6+txn83q95bLi5jjIav14Nvxow5OLNDyCS?=
 =?us-ascii?Q?VCWlTx2R4IFo0E2rvS/x/ozmLZpGh5EM0LHeNEFjnaE9/i3rrA8yVxRfI3fc?=
 =?us-ascii?Q?tkivrpg8aM0pTOGuRa+3FHoh5Z3rsLiXIWrjR9cfvTF89qnF/OxofnBZ/COL?=
 =?us-ascii?Q?5fRjmpv8rMysLTnQwWLcRrvV71RbkDt3MY9EhV1RVtKzGQ61OteyJKMxpgNx?=
 =?us-ascii?Q?2OOfZ9leI7ixbUe9RXTIHdidTguLovPZvYmne0A5CrmjpJY5zweraNj53c1e?=
 =?us-ascii?Q?oGsRIy6tRccneBRD0GT6gUHhAh/DZxmR7VyLumGG7DPhIbRPFpNlx4CpHCgz?=
 =?us-ascii?Q?b/+Z+Yw+5yOrxZ2hBjR+3424qZdnLAeNBTF0V872+eZ7MxddUUKqMdnSH5Yy?=
 =?us-ascii?Q?sgKNQ3A4c/mmtBTeuUvbicS5pXvjGVPyDDD6ZlS/OF6+9tCa3VctEuy3PQ+t?=
 =?us-ascii?Q?j9vP63qv+z3jaY8clIgoYOOqB7P/QnYCRiztuIou54hI3i81z15LPWp+cSlV?=
 =?us-ascii?Q?ubNceDG2qZ+vsPBMq2XlQcj4DPQRlra2ORbqKGW/tuoLeo0KQm22+1WNS/ZG?=
 =?us-ascii?Q?ifzfXFwhlfS6bpPLoETEeGpiqHOENsRaR8JVqpzAzm0CBaf8Ah1vueIPHz79?=
 =?us-ascii?Q?PqeOXxh6OMVsEjtUmdpBxmaOF2iR35ZMzVnMIB42NOZcTyzlzwlZBijeMQuq?=
 =?us-ascii?Q?nKVffhUAOliHXlgw/Zt2fL3A6hiUwanjR1YRvV4T8dcANYwiAC1MVPaTfqg1?=
 =?us-ascii?Q?QZWim6mYzWstyX4+Xpi1r3U9Tcj/a51JBbT0rbE5PPSU1N7AN4tzcBjMLBA?=
 =?us-ascii?Q?=3D=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Sszpmf85x1DliLtA/m4wy5pGKrzXhOtK0R82oHcTlqjTLyiL7WRDj9siqZUk/jmoXUo4S/zBnMDZkhUXwbaGk3qC/NE2Nx/tYeNp7AkJCpoJLG++vO6dWOafK70yH0aGWIMR3m0rsI6bYDPfmpyy3RZFU+RWbGi+nxenaJuBWlL7nhuEqc/2fzvqiKLQBbNKDjTOwWhQJ4NNl58u9wbq5Sp5RruYxwVQC/2qKGFTdINzeRsFXXg0O3GLaaQ5idHYLLYsMY8x9P4kctXxAjeHneorGXSt7cMF7RuWZU1vE6GnUUOsYz6qRuUBkPqZ6iOey2Oas3kkWDvoSyJtQeHxW9PJLtGjf+z+jdyyOFZ8OAKPOLgR9slKM04F4uDx92fqlhhgsyxrW4ajVGOag5dyGqb1u+N2+d597F5Xmdm5R3g=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2019 04:41:33.1585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47bb5580-3f23-43e1-73a7-08d6a6a5011c
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0201MB1862
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

 .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 118 +++++++++++++++++++++
 1 file changed, 118 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt

diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
new file mode 100644
index 0000000..5b8170f
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
@@ -0,0 +1,118 @@
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
+  reconfigured at runtime in the Protocol Configuration Register.
+  If present, the V4L2_CID_XILINX_MIPICSISS_ACT_LANES control is added.
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

