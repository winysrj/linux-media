Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A6B0C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 224D52084D
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="ZyZsbVq9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfCKJrB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 05:47:01 -0400
Received: from mail-eopbgr780048.outbound.protection.outlook.com ([40.107.78.48]:41632
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727128AbfCKJrA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 05:47:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EV8kSgL1XG238MU+ueOwbwWRWkrkZDZzz24NPAamV5k=;
 b=ZyZsbVq90zxSJ4mxTagyNwh6jAPq1PEaOW4b3+h5IMEqm9r8Q0Au3NPH8PkwyQZgFSqSopeLNpju3TSoOAjhcDh96izIh3SSh1tE2/qp1sa+8R6dnGKcRATDs7o0VmmnMJVnav5u3bPZ3W3pg/O1V85P76vft2QhButPvZo0MLU=
Received: from DM6PR02CA0019.namprd02.prod.outlook.com (2603:10b6:5:1c::32) by
 BY2PR0201MB1864.namprd02.prod.outlook.com (2a01:111:e400:58b5::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1643.16; Mon, 11 Mar
 2019 09:46:55 +0000
Received: from BL2NAM02FT014.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::208) by DM6PR02CA0019.outlook.office365.com
 (2603:10b6:5:1c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1686.18 via Frontend
 Transport; Mon, 11 Mar 2019 09:46:55 +0000
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT014.mail.protection.outlook.com (10.152.76.154) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1686.19
 via Frontend Transport; Mon, 11 Mar 2019 09:46:54 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h3HWI-0000xE-0U; Mon, 11 Mar 2019 02:46:54 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h3HWC-00014I-T9; Mon, 11 Mar 2019 02:46:48 -0700
Received: from xsj-pvapsmtp01 (mailhost.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x2B9kgue013179;
        Mon, 11 Mar 2019 02:46:42 -0700
Received: from [172.23.29.77] (helo=xhdyacto-vnc1.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h3HW6-00012T-84; Mon, 11 Mar 2019 02:46:42 -0700
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
Subject: [PATCH v5 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem
Date:   Mon, 11 Mar 2019 15:10:56 +0530
Message-ID: <1552297257-145919-2-git-send-email-vishal.sagar@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1552297257-145919-1-git-send-email-vishal.sagar@xilinx.com>
References: <1552297257-145919-1-git-send-email-vishal.sagar@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(39860400002)(396003)(2980300002)(189003)(199004)(4326008)(44832011)(106002)(2906002)(106466001)(2201001)(316002)(6346003)(16586007)(110136005)(26005)(486006)(63266004)(8936002)(77096007)(336012)(107886003)(86362001)(305945005)(5660300002)(8676002)(126002)(81156014)(2616005)(6666004)(446003)(81166006)(478600001)(9786002)(6636002)(48376002)(36386004)(50226002)(50466002)(47776003)(51416003)(426003)(476003)(76176011)(356004)(11346002)(186003)(7696005)(7416002)(14444005)(36756003)(921003)(2101003)(1121003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR0201MB1864;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9af95d69-4473-4dee-e7c7-08d6a6067ee3
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:BY2PR0201MB1864;
X-MS-TrafficTypeDiagnostic: BY2PR0201MB1864:
X-Microsoft-Exchange-Diagnostics: 1;BY2PR0201MB1864;20:5MJEjEwLIyDg1COulBnxo7buEy6LshcuL5Zxnae5oxOaer/QhjREse5EyTgjq7NiVIXuqgOPARs5DAzHiy4lkCxOsufnxH8zrk0PssEG3nv8Jryd8oFxU0OnxJDK25t1vSaQfUfnMEdHtnIpVeuIxv7PCPeOucZeMUAxegFWrvd4F1oV4FyyfNvWCR+4G7zoFu25IUerOdLDBYDFf4WrFOgKzeeOYCs52pF3Stz0pcZAtxHJ6zdF35lLGELzZ0G62zR0J9Koo7uJuqYQ2duh6s3e7iB6D2U2IbBk9eeiK4bneAYUrhQn8qB+jtI7/ZqyslrQu3jDWOHLJ1w7NaMtRMRr2jB6y0zNAzQN3sMfX9NS/KzRDr1rPuZWIap5z7/Qx80/q5T4NhBsSDNNpFES8eAecQ63D8UFpw58pUER/gQbMYsTqKEoZvimtSNoyG2sLge3vftE5lKE4lSah2s0XhvXTmXF34hMaYgxz+rKXpkaRPxwJmrZ8rkxHLFXf2SG
X-Microsoft-Antispam-PRVS: <BY2PR0201MB18645D1AF962E804618C4058F6480@BY2PR0201MB1864.namprd02.prod.outlook.com>
X-Forefront-PRVS: 09730BD177
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BY2PR0201MB1864;23:7D21YQNIqb+h4YhML3EUeX3vC42kmDJQRwRrQrY?=
 =?us-ascii?Q?llXWLh8lq9uhyUw6KMeMLJFgbiCr8QAZHr9pdvz85UAxUzB3X4cQnMGO2T7F?=
 =?us-ascii?Q?Hm8YRTdDsKaq/UNSyvJc4DzpVl/RIERR8yMTIgMnj5/YCWP/jLsD+kTLkE7Q?=
 =?us-ascii?Q?YB7BI33oYV1hhqFOEdBANTTxBqf4djoWbvJc+qS+N+Cr9xhL7uu5isGU7ki+?=
 =?us-ascii?Q?vmx9B4wK1ZvDI6t1qiSpnvELXjSrC9/1CLkAdE1W7IgbNTHKRr1121ihEupG?=
 =?us-ascii?Q?w3hb50b6CgnDcBO+yhNPbTI1B7ouyT7p2Yl2Vc/bfDipcxpKbUWRnEANGJ7l?=
 =?us-ascii?Q?9o+KRiY2kJTQ/ureHFbrhEU8bklWepCitMj1wgr/sdXJSRavspHr7mucFw3K?=
 =?us-ascii?Q?TO8aj/SIFf69WOtmEqXw0P7cmkLznNpZHhK/4Y+CSKdwz0p1/d0jJdZInxfG?=
 =?us-ascii?Q?MYkzjWnOIwWjs4qDC+qMuFvE/kbbcVN24PZgvtQ9KCCcz0rWof37tJhJBC40?=
 =?us-ascii?Q?pFwEWzE1JGKKIYsSH8u07NGqLNsAJZrp2mAT46VXiNaAhPR72hJCQx5pU10u?=
 =?us-ascii?Q?L4n4756XpNMP+daMcNkPwj1nM3y9RL+/r2sx8Zl8IYZCw+gSxfVeesXT0MGc?=
 =?us-ascii?Q?FptRtvTBcV7Tz46aKiVH2WOYv8t39wHplGPQErkos6iFil7ixYurxOjA70Zk?=
 =?us-ascii?Q?xcu1rhojMEnb8bVWoY4hEp60IHjzeQkhXuKgkTI94JlKuc1Qbcq2uNkGargH?=
 =?us-ascii?Q?P49GORv4gdtjpxm5Bt2puKD2ePVFvA8fUCSEPJdV8zren2YGKEkwfTCUSCKJ?=
 =?us-ascii?Q?O9OrXSDMBFcwzUIuWXdu1mxn6uBd7C0nn6A6w94pb36vwLELmv/0ZpW8zxAh?=
 =?us-ascii?Q?1lnhrCRr7ep6g5FxktAGYVBC8zHTL8fy/UoESlHPHyAG4i1+SHsmwDty+/uo?=
 =?us-ascii?Q?rgMZWrVQOO+GZcdgBgHEV+NyejHgPDyPDbrT9f5yN40UUqjF1IkrOJk/oij/?=
 =?us-ascii?Q?c5SNk8gQDUyhZxjU9h6VZAQAAMGD47ca5adKZLyIxNVNbDO0VlEraQMYhLN9?=
 =?us-ascii?Q?1VAvRNSNCwlg6waHGbyz9yzt5OTBLyHhUUrbBBZqb4uJVGyzrOhYurCq8kSM?=
 =?us-ascii?Q?MTj6aYaA5YT5XrC+Yh1LzC44HolRGSx8DNVbxVO6W0iUusa32jsBOwAZXQM9?=
 =?us-ascii?Q?bAOXBiYhPtAep6EzvZsb9QKGekEf6fXlsYSmkanmLtDYeQGp/C3Pul+nsD1C?=
 =?us-ascii?Q?BIRJLhc3aVk5Ck+bQVLE=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: uDuyRqb+4VKO368ptvtjuIaBorqxAxxarvXX+N/EdsVaXxBUgYsWIbVVZv/C1OsrlM5UcJUWGyMnfHJOlcIfAjEEwU9K8lO6Ku57YYPEX0X18Bh15xnhvJeqE7ih23UmGNsvCDgKtPcBEv4WUMve9EYF+inR1I7UjnxynaWW2qZJkW/YNdhQvJIDRnAUjEeGT/k+Dimevi3jpDNtSzU3Euk8I41Ze1tiX4E85gwndVp/xQxOCayrVOpAkMYgnBv/H2/8fIAXmuvNY7Z+2kpJ+vXD3zrnTKPwm1xMmThXnAv0oqtUvKHL7DWZeKeT4xG8ACW92UIPFwSt6ASvIfYn6iq25iIWHnFeYtLc/ZTeJ1EAZ/AqVgD8CI6jOC8PHVmqWR8ThNJ3tLBb92F2dQLHzAQBe+TFe7NW+Jbv/Xe/xx0=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2019 09:46:54.5951
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af95d69-4473-4dee-e7c7-08d6a6067ee3
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0201MB1864
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
index 0000000..cdf07c61
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
+  If present, the V4L2_CID_XILINX_MIPICSISS_ACT_LANES is added.
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

