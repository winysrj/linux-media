Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CFE0C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0684F20850
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:47:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="eTEipgRC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfCKJrR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 05:47:17 -0400
Received: from mail-eopbgr730083.outbound.protection.outlook.com ([40.107.73.83]:38497
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727107AbfCKJq7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 05:46:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7KqO4V8xYHyMVTUJQEaQ7J2U81RUofDDv/U6qINI+s=;
 b=eTEipgRCd4bRtviMsVbyHq4mz2XdsAUmkljvkN9XqyCcLYVRtlMLhAjktvQRJr3P+VgbVTHoD/ylweur0AG4ne6eLYuZaDXieUWk/Qbc/1Cm4XnamIsAsnJSgNUz9cTleofLz9GInDy6WJOFCrD60wAlBt6nPy0zY4PIWjU9dWA=
Received: from SN4PR0201CA0022.namprd02.prod.outlook.com
 (2603:10b6:803:2b::32) by MWHPR02MB2382.namprd02.prod.outlook.com
 (2603:10b6:300:5d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1686.21; Mon, 11 Mar
 2019 09:46:56 +0000
Received: from CY1NAM02FT033.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::200) by SN4PR0201CA0022.outlook.office365.com
 (2603:10b6:803:2b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1686.16 via Frontend
 Transport; Mon, 11 Mar 2019 09:46:55 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT033.mail.protection.outlook.com (10.152.75.179) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1686.19
 via Frontend Transport; Mon, 11 Mar 2019 09:46:54 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h3HWH-0000xD-VD; Mon, 11 Mar 2019 02:46:53 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h3HWC-00014I-Rf; Mon, 11 Mar 2019 02:46:48 -0700
Received: from xsj-pvapsmtp01 (xsj-smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x2B9kcEr011351;
        Mon, 11 Mar 2019 02:46:38 -0700
Received: from [172.23.29.77] (helo=xhdyacto-vnc1.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h3HW2-00012T-0h; Mon, 11 Mar 2019 02:46:38 -0700
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
Subject: [PATCH v5 0/2] Add support for Xilinx CSI2 Receiver Subsystem
Date:   Mon, 11 Mar 2019 15:10:55 +0530
Message-ID: <1552297257-145919-1-git-send-email-vishal.sagar@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(39860400002)(376002)(2980300002)(189003)(199004)(36756003)(486006)(2616005)(6636002)(2906002)(305945005)(48376002)(426003)(50466002)(476003)(107886003)(316002)(8936002)(50226002)(44832011)(126002)(36386004)(47776003)(336012)(14444005)(110136005)(7416002)(106002)(77096007)(26005)(2201001)(16586007)(186003)(4326008)(86362001)(6666004)(356004)(7696005)(8676002)(51416003)(9786002)(106466001)(81156014)(81166006)(478600001)(63266004)(5660300002)(921003)(1121003)(2101003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR02MB2382;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 632a0301-af47-42fe-cab0-08d6a6067f07
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:MWHPR02MB2382;
X-MS-TrafficTypeDiagnostic: MWHPR02MB2382:
X-Microsoft-Exchange-Diagnostics: 1;MWHPR02MB2382;20:7fuisnr8/1023YjQCXB7PkE7EeX6JW/3JM5CSce0HV3X7zOMmIgj6XqBakXmfNPN4gkRU37l1001QYnTVRklHBaIVy8o2h8WlVjhXkQxncKBDsuM/WH9JseZ4YG0mNPXqBG3c62z627+jOcle8SZZBJPlxo8coPZE8/ETOpX1t2/SdXBUwRzZhzgXt1W+JkaM3upPiXV+fhlhQMoUYcoD5OaGiEXS6SSZ55tF0X6gm00F1d6712QVDgwT3/fUfqR9eMzJl8fQ7IGJWSKAPfTstNDk5fMBvtq5fKnUAzAJLhKTt2Q33N/+bVk0OQSiF0RPWB1MT1XdLte7MWk/8hK4HU3+JlCIHB2B5+xrJXGGJYTOqO5RobFQ2crZmtJvfU0Nh41IHN5q9l+FEnMIRNicgNhS2nNonFSyuz5FSrnzhJBSCJm/QzY0EezuyIye25YPBFOZXnn/1HvnqwFcBTLqBZal88hJY8FRDdCJxCQzwVauzkxLO99dzOQvjb7WB0F
X-Microsoft-Antispam-PRVS: <MWHPR02MB23828BABD43FC224285F261BF6480@MWHPR02MB2382.namprd02.prod.outlook.com>
X-Forefront-PRVS: 09730BD177
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;MWHPR02MB2382;23:I9ydWNeAIQcZO/OA0M63vIU1ZYOsHYHYNCeqXiQyx?=
 =?us-ascii?Q?F+U4TEUvoNcgxoSb+VxYMtU4U9MJrLomJFuvLL6SaeoztphvT4UMaakuB0P1?=
 =?us-ascii?Q?q+0QRdSkgdl5/9TegOd5sMrPlCg3oeWYDimEFxVaibmr1IVgaQ4CmoOEmEE3?=
 =?us-ascii?Q?qBgMsdJFLXH9R6ieEQa9/SblxJeiCA06B+IDnxvY8z7q5uTTH3x4iqoz/bGm?=
 =?us-ascii?Q?3nVPKXCHRH1mYpKYvcTtP47EB4YE7c4fkfscvI5J76v3H/gukvWJryeYDVkQ?=
 =?us-ascii?Q?4cUsqPt3NwFeUHPi4Dfc26nwRWCQFDBby7VSkjPxP3PkxFNrxUpTkp1T0t7c?=
 =?us-ascii?Q?NdywoPHzl7uuksAGi6KpKKctHJWCl+uxmffOM2CldK8c98dXURDDX/FGJZcU?=
 =?us-ascii?Q?irpMlfEp/4iv8eHTpR6xO04qTIFqEnEcu39zXTCAXCqQ0JFvPDZeHGoApLJL?=
 =?us-ascii?Q?Cw+yBK5+3BoaXVz/URy9LBxsQbWdc+jpRIzH/x8OGi07ruBJlInpwbz+EwHZ?=
 =?us-ascii?Q?zIMjkW8KsTdO4LwnykN+pkjyd89HAzgv5iHqFJyenL/J9x6nDiOVd5sFRnhJ?=
 =?us-ascii?Q?FTMLm6IOeydYA129WKHjnOerplrh/XDlHtZaaOd4ygm7F7NVLQPJo2Pwofuq?=
 =?us-ascii?Q?aD0KLsQN/dQlGnBV8/gLV1Ha08X2elAyNCfWTlVcN84LVCsCjoSq14ogK5CY?=
 =?us-ascii?Q?Zke6ZroPd3HQhRRYMNMlYzQsi0K1sUQkTZMEN7cN9d5D4en4I66c8wn7KZof?=
 =?us-ascii?Q?Z5xqD7OgsskZRNWwM270g0MlieFs4fQCMWYbYd6s0dtjn84XyhMG0uW4jeAz?=
 =?us-ascii?Q?N5NhN+NKklK+VFSzN0Z7wwFnihNl3ahk0wqeExeMJ4HdKTJ0iDpl7fZ/qWiE?=
 =?us-ascii?Q?88pmSnGH28A9EQZydrrsA1A7gl+ivijMsBa+SQmhX4Acnc8Yn5N4CymSHkDe?=
 =?us-ascii?Q?NenA2tInYiU8VmEMCSQzrbs4GQ/QnDPOTdq96bxrijH12urxPseyZblm5rE+?=
 =?us-ascii?Q?ptww6No2ancX5RAgfHpMXdj2kjiXhKTvTT6UJDZJJ/PO1epqRh1dHTWpF+LR?=
 =?us-ascii?Q?axB5ez21SfCop1FqHhMroYsbpUYTW1HKO016s7CFhAF2EilN5Hd6zqre7NWN?=
 =?us-ascii?Q?UsWC46QGRw0OQbhZqZTBvmQv54ykfDlnd3KYPUYMj7aaSIY7+aBWIDPw2MLP?=
 =?us-ascii?Q?LAT6ZFz8CMx/o4=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: UaA59QP/u0MsJ+WXZkji82tjV2D/irC9x/kk4ALGzTHmJWzvM4XDYplCIYXEH4JAUH+D/G+XSZ7gNyJslpDaeS3A9KGLnnjw3sTwsB10TJSNTCpwYlHLlD/LwrS+XYokH7r74HxN4eaa63k/4xMxOtvdd5qrNIUkS7GvZdkrbhycfv8B5S2bPliXZ9/jlGkcVvaGlmHjD3qm3wUL1jRbTCIAkK37saeoi4gmkQEL69ah2Dx34BnNmLqgwhqwD2iP2GspUAZMEL+9lzjnuv1NJBeZKd8E6InAFN4wM5v/S9w7tQXkScgWaDLRSYhO33XroxeWzZ0XcSbC/lWCkv9TU/s6zbYxeRLUA5qpIP+GAZoIaOZeRLaDL+IqYdzAn1PEjl0N/TDBfQs+JeugpFqgOFA4jKqIdm/PjuvwQlKLH7w=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2019 09:46:54.4287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 632a0301-af47-42fe-cab0-08d6a6067f07
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2382
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Xilinx MIPI CSI-2 Receiver Subsystem
------------------------------------

The Xilinx MIPI CSI-2 Receiver Subsystem Soft IP consists of a DPHY which
gets the data, an optional I2C, a CSI-2 Receiver which parses the data and
converts it into AXIS data.
This stream output maybe connected to a Xilinx Video Format Bridge.
The maximum number of lanes supported is fixed in the design.
The number of active lanes can be programmed.
For e.g. the design may set maximum lanes as 4 but if the camera sensor has
only 1 lane then the active lanes shall be set as 1.

The pixel format set in design acts as a filter allowing only the selected
data type or RAW8 data packets. The D-PHY register access can be gated in
the design. The base address of the DPHY depends on whether the internal
Xilinx I2C controller is enabled or not in design.

The device driver registers the MIPI CSI2 Rx Subsystem as a V4L2 sub device
having 2 pads. The sink pad is connected to the MIPI camera sensor and
output pad is connected to the video node.
Refer to xlnx,csi2rxss.txt for device tree node details.

This driver helps configure the number of active lanes to be set, setting
and handling interrupts and IP core enable. It logs the number of events
occurring according to their type between streaming ON and OFF.
It generates a v4l2 event for each short packet data received.
The application can then dequeue this event and get the requisite data
from the event structure.

It adds new V4L2 controls which are used to get the event counter values
and reset the subsystem.

The Xilinx CSI-2 Rx Subsystem outputs an AXI4 Stream data which can be
used for image processing. This data follows the video formats mentioned
in Xilinx UG934 when the Video Format Bridge is enabled.

v5
- 1/2
  - Removed the DPHY clock description and dt node.
  - removed bayer pattern as CSI doesn't deal with it.
- 2/2
  - removed bayer pattern as CSI doesn't deal with it.
  - add YUV422 10bpc media bus format.

v4
- 1/2
  - Added reviewed by Hyun Kwon
- 2/2
  - Removed irq member from core structure
  - Consolidated IP config prints in xcsi2rxss_log_ipconfig()
  - Return -EINVAL in case of invalid ioctl
  - Code formatting
  - Added reviewed by Hyun Kwon

v3
- 1/2
  - removed interrupt parent as suggested by Rob
  - removed dphy clock
  - moved vfb to optional properties
  - Added required and optional port properties section
  - Added endpoint property section
- 2/2
 - Fixed comments given by Hyun.
 - Removed DPHY 200 MHz clock. This will be controlled by DPHY driver
 - Minor code formatting
 - en_csi_v20 and vfb members removed from struct and made local to dt parsing
 - lock description updated
 - changed to ratelimited type for all dev prints in irq handler
 - Removed YUV 422 10bpc media format

v2
- 1/2
  - updated the compatible string to latest version supported
  - removed DPHY related parameters
  - added CSI v2.0 related property (including VCX for supporting upto 16
    virtual channels).
  - modified csi-pxl-format from string to unsigned int type where the value
    is as per the CSI specification
  - Defined port 0 and port 1 as sink and source ports.
  - Removed max-lanes property as suggested by Rob and Sakari

- 2/2
  - Fixed comments given by Hyun and Sakari.
  - Made all bitmask using BIT() and GENMASK()
  - Removed unused definitions
  - Removed DPHY access. This will be done by separate DPHY PHY driver.
  - Added support for CSI v2.0 for YUV 422 10bpc, RAW16, RAW20 and extra
    virtual channels
  - Fixed the ports as sink and source
  - Now use the v4l2fwnode API to get number of data-lanes
  - Added clock framework support
  - Removed the close() function
  - updated the set format function
  - Support only VFB enabled config

Vishal Sagar (2):
  media: dt-bindings: media: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem
  media: v4l: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem driver

 .../bindings/media/xilinx/xlnx,csi2rxss.txt        |  118 ++
 drivers/media/platform/xilinx/Kconfig              |   10 +
 drivers/media/platform/xilinx/Makefile             |    1 +
 drivers/media/platform/xilinx/xilinx-csi2rxss.c    | 1465 ++++++++++++++++++++
 include/uapi/linux/xilinx-v4l2-controls.h          |   14 +
 include/uapi/linux/xilinx-v4l2-events.h            |   25 +
 6 files changed, 1633 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
 create mode 100644 drivers/media/platform/xilinx/xilinx-csi2rxss.c
 create mode 100644 include/uapi/linux/xilinx-v4l2-events.h

-- 
2.7.4

