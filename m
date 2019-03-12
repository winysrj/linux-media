Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A996C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 04:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11798214AF
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 04:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="IGjFpx+N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfCLElj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 00:41:39 -0400
Received: from mail-eopbgr710042.outbound.protection.outlook.com ([40.107.71.42]:8992
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbfCLEli (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 00:41:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkXKKQ3yIwmzLmJ+JXVKRegBOGrfhgrFdtsBxENWbrM=;
 b=IGjFpx+N9yvMcOpxlNUDfvZCgbrFNE+yWVSSLVC56TwpRJIZ2wJL/B1aoBtNJNrvC696mG5Vlv8xqGSWRWUHXzLHxRpg6bJY4J0miqBRMzhDZFhYTSCT5ynrjynKZLeXvrUqYIhDyybfQWYiRhiTMZtIORyWVhsIfmWy00l4BpA=
Received: from MN2PR02CA0024.namprd02.prod.outlook.com (2603:10b6:208:fc::37)
 by BN6PR02MB2369.namprd02.prod.outlook.com (2603:10b6:404:2d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1686.18; Tue, 12 Mar
 2019 04:41:34 +0000
Received: from CY1NAM02FT056.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::206) by MN2PR02CA0024.outlook.office365.com
 (2603:10b6:208:fc::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1686.18 via Frontend
 Transport; Tue, 12 Mar 2019 04:41:34 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT056.mail.protection.outlook.com (10.152.74.160) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1686.19
 via Frontend Transport; Tue, 12 Mar 2019 04:41:33 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h3ZEK-0000Fg-Jx; Mon, 11 Mar 2019 21:41:32 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h3ZEF-00021w-GQ; Mon, 11 Mar 2019 21:41:27 -0700
Received: from xsj-pvapsmtp01 (mail.xilinx.com [149.199.38.66] (may be forged))
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x2C4fJON014041;
        Mon, 11 Mar 2019 21:41:19 -0700
Received: from [172.23.29.77] (helo=xhdyacto-vnc1.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h3ZE7-0001yN-8y; Mon, 11 Mar 2019 21:41:19 -0700
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
Subject: [PATCH v6 0/2] Add support for Xilinx CSI2 Receiver Subsystem
Date:   Tue, 12 Mar 2019 10:05:28 +0530
Message-ID: <1552365330-21155-1-git-send-email-vishal.sagar@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(39860400002)(396003)(2980300002)(199004)(189003)(48376002)(50226002)(2906002)(16586007)(36386004)(316002)(6636002)(50466002)(305945005)(14444005)(478600001)(9786002)(81156014)(4326008)(106002)(63266004)(8676002)(81166006)(110136005)(51416003)(7416002)(7696005)(107886003)(8936002)(2201001)(126002)(26005)(44832011)(106466001)(476003)(86362001)(486006)(356004)(2616005)(6666004)(5660300002)(426003)(47776003)(336012)(77096007)(186003)(36756003)(921003)(42866002)(83996005)(1121003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR02MB2369;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2ae5a72-df0c-4435-ee08-08d6a6a50105
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:BN6PR02MB2369;
X-MS-TrafficTypeDiagnostic: BN6PR02MB2369:
X-Microsoft-Exchange-Diagnostics: 1;BN6PR02MB2369;20:RMCQUz8SwnXN0wuFeiz1C0HJDQvCX70lDjZtrT7XmoVq9oYSVPDt8XHEtt71mDeVpczpTHmftVCVzdDh+g4GSlq51yvQQquf6g66NKOc0/rJlAFCRp7FhUjCYGVfwElOR2GQdph6Wraqr0p0aKTA3Ox53Z3r6JOSY39OIvDwqU8+pgVn07t1sA2dzcGjUynz5olKneE/uEdqh3XNlcIgdha5vQPKM6KW473gSnlBAFMA+d7pHjEQb02xz+U+/vWgSfhPkCI3hojKt5Cggr5KLUVtjqLI+b/R68xVoCxkDMmoEWtzMtvmaVi3eclF0a5+4xjU4hi3tYVyr2U4yswq4cpBXpqKxketz34tx4zECW5z5GUaZEyZD1k+IPOzweQNtvgOfjePFHMtyNK0uFh7tCxS5FVKsmHzSpkN2BJpZpDuqwFr1YhSUOjdbwWIL/pD4Vg2qSEzyJaVX1WjBt24UOtN9KUykYz33/zELbDDeCQPzqHVKB0I4BB6gwjK0rGs
X-Microsoft-Antispam-PRVS: <BN6PR02MB236909D37CD4495C0329854FF6490@BN6PR02MB2369.namprd02.prod.outlook.com>
X-Forefront-PRVS: 09749A275C
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BN6PR02MB2369;23:aQ9zy7OoMrevQHHy4MotDlrfXdDOhqR3fB6eZ2HNr?=
 =?us-ascii?Q?i7GNJz1v8ARPjE3tClJNcCQuWZ04XBX3rx7yeAzKl5fmXZKjTJgfzVM3tzin?=
 =?us-ascii?Q?Fe+PCnrZk9O5my+gUedtihBAENTfo/i4044UJ0cMxJM74cX9pBgwSpKAbPvl?=
 =?us-ascii?Q?Xn6eOW83BRSr0Z5gqlESnfgVMcyir6gay/g0c1S5OeiDeCeOHkO7Qh0R3WL+?=
 =?us-ascii?Q?mZZeboK7ueX+qgeqyY6j6FP7H1OF5JY1r38R15cCgbpCeu+f6vt31dMbXd3x?=
 =?us-ascii?Q?9hKvsvw8on1xPxMc4c5AoAhZtts3rIh2zYviGF2svXJIKMUBM1SNawjwdNNM?=
 =?us-ascii?Q?7K9z9I03wQnaBGqSaokkwrlziKiUIB+AjnB1jhJ2pSP7xxlC4BygNPJ4xTOo?=
 =?us-ascii?Q?FUYa6xZKp6Q0mV4MZMISicl9scWwmwtTGi5sj3c8StchdfmTS9vu0kBehAet?=
 =?us-ascii?Q?nToDa/e1gFegm8rLhgYM8CM81NX0ebpXD5cpmSoDBuppz4C+CUx+/NAvDOzw?=
 =?us-ascii?Q?xdrikzSDphNR5vmNSLp4QVt0Qy/V35Ntu1+GiK0A2x+fwsIxhcLpA+vVMwP6?=
 =?us-ascii?Q?pVEDvV4G7l0OykyGELM/vs0OBMRwYtUGGnTQT+Oatpx/7Qs4/9zxYldvHeNQ?=
 =?us-ascii?Q?a4ksZ8nAjbOOpTk5AA/TzPG5uzH+8P9Gk9o3o3WBLQQt3Xwcub3kd8MgdPEw?=
 =?us-ascii?Q?edY0R6Y3xAYxNBe0IsI4VKwoGJosxq7hRq6tOh0+JRjHBvlyl5eJAy0R970D?=
 =?us-ascii?Q?18MIDdeFMRH5o3qMiQH6usaNyBd1YPpwigqWTMABmJN6NMppcwBuWJnAXmFM?=
 =?us-ascii?Q?ipYzF2hM6vlvxb0fxe08CqmU6LCyrI3ii35ie5rGLqe83jrC3s4IB30acbF7?=
 =?us-ascii?Q?LlB2vaypAJYbOqgz855AUswS5vmxIhfT1W0mDDb87KEl5t+fBT7WpeAddzED?=
 =?us-ascii?Q?KmqZIWPYFUsjCyoZmrkDWAaYeE6zR1lzQ3i0ZBXYO88Hszryz+89MTL7PBS1?=
 =?us-ascii?Q?YKG7beV3fwFMiftL19xHjXDO3/TUVkXrgyEMlQr/tZPK298rMocc1yeN6vNR?=
 =?us-ascii?Q?oc7wgn/yjWNo8bPBJQlh0A/w/uyKSgEZNSbP0VHY7tC1FoqqtuqfnoMfLraN?=
 =?us-ascii?Q?+nyXjWFHnm7hy0rCt197Arw25Pnq8zTlB0BaNLcU1i0qc7GF9fjKRslkSUVe?=
 =?us-ascii?Q?n7/zxKPlCNcHNzHEerJOu8p0lRBzjF+jzNb?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: bmZyrWypDyZeR+cfSwz6TJFqFP8Yqz6qgfniw1qBV9qi0Hio6LKxOAskeCjbNabE1C0ncEX/8nKhRKB+HsYUK2XY3gV5C42rPk9Kaz5bhjviL+50Ijf3HZSksBAW+b8GO9LnePUFhghhWGxzCqSA9aQpcyrK2hHm/fWbSfZsOqI/IAChhWPg5B2V9VZL8xyT0FxCy5qT+BRmfm2sHHpW4oKvbY/7hbh4e3FQ0UDB5h+QKhPdPEyB5nr1ZJIaTBDGbR2wxKbiQxibvEisKyoDJoH4DrZ5JbwI8tW9nmDtYFmUbxWxVv9z8KWvBVt34DFSc2iEm03Mb2WTUKeKHUCRSbLOO63+gW9nqlifFDHq5Uyek+tJ4c/IGetycRPPJaHfrVaCnmV1k+LcJE7LF6eoShR+dg6ExQfik/T9jTb1auc=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2019 04:41:33.0549
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ae5a72-df0c-4435-ee08-08d6a6a50105
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB2369
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

v6
- 1/2
  - Added minor comment by Luca
  - Added Reviewed by Rob Herring
- 2/2
  - No change

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

