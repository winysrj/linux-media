Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C342C4360F
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 11:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA16F20854
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 11:31:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="GtQkOLxu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfCNLa5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 07:30:57 -0400
Received: from mail-eopbgr770048.outbound.protection.outlook.com ([40.107.77.48]:33941
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727255AbfCNLa5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 07:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdPAhG3JCWKaDoOq6sZ3449J+XtGUCHJdP1c3aj+DWQ=;
 b=GtQkOLxuuGDHiNPVijfYAm8RQarqGqpq0sD+/5jNYlOzTRlQEYU1hax+S8iDJdfLxFlBWuy7ofZ/1cWy+QfDZN0//kOeO3q7tBH+Z+aVH6vhShblHbW6hQKJaqESf9p8rTNg9eeW3DpyGkXS/H3dFZGUGln7PU14DBJYi0rRtW8=
Received: from BYAPR02CA0065.namprd02.prod.outlook.com (2603:10b6:a03:54::42)
 by BYAPR02MB4341.namprd02.prod.outlook.com (2603:10b6:a03:56::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1686.19; Thu, 14 Mar
 2019 11:30:53 +0000
Received: from BL2NAM02FT062.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::208) by BYAPR02CA0065.outlook.office365.com
 (2603:10b6:a03:54::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1709.13 via Frontend
 Transport; Thu, 14 Mar 2019 11:30:48 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; ideasonboard.com; dkim=none (message not signed)
 header.d=none;ideasonboard.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT062.mail.protection.outlook.com (10.152.77.57) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1709.13
 via Frontend Transport; Thu, 14 Mar 2019 11:30:47 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h4OZT-0007Sf-3c; Thu, 14 Mar 2019 04:30:47 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h4OZN-0002iJ-VQ; Thu, 14 Mar 2019 04:30:42 -0700
Received: from [172.23.29.77] (helo=xhdyacto-vnc1.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h4OZF-0002df-02; Thu, 14 Mar 2019 04:30:33 -0700
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
Subject: [PATCH v7 0/2] Add support for Xilinx CSI2 Receiver Subsystem
Date:   Thu, 14 Mar 2019 16:54:49 +0530
Message-ID: <1552562691-14445-1-git-send-email-vishal.sagar@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(136003)(39860400002)(2980300002)(199004)(189003)(16586007)(356004)(48376002)(9786002)(126002)(63266004)(81156014)(81166006)(47776003)(26005)(77096007)(2201001)(8676002)(6666004)(36756003)(305945005)(86362001)(316002)(50226002)(8936002)(106002)(7416002)(186003)(107886003)(106466001)(110136005)(50466002)(336012)(51416003)(478600001)(7696005)(5660300002)(486006)(36386004)(4326008)(476003)(2906002)(2616005)(44832011)(426003)(14444005)(921003)(2101003)(1121003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB4341;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7b39ba3-d918-4796-27c3-08d6a8708159
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:BYAPR02MB4341;
X-MS-TrafficTypeDiagnostic: BYAPR02MB4341:
X-Microsoft-Exchange-Diagnostics: 1;BYAPR02MB4341;20:VV6afK2HAy8QuW2+WlM3o9asIte/4jfYpBaQw3aXBOlosnoXile9+olZ3MAqmMveYBgpNVFbugLELOVgx6UsJ1Lp/p99x+kp0tEnfaCDFg1NxsG+qn3wb1WBlnra0JGizvfmxVF3lt/oXqCTlhj2cyi7Q9eBcjrfK9i6+UKDtql4xOLvYht6gmL5RHg8qOF7q7rK0Q8XIHV2spkt4u4vJPU/gg1PQpAGoshWwualerWFXv2vuuqOMzMaSW4Mo9DbKSTAzGYTr/bQejsThTp6V0cny0WMka8Q/G0PsKiJb2gO19STCE0weV0X+rxV4XPDaauz5Wuc6u4aKsScZ2jnZ0aKtVr4i8H1sYsE+yOYTdBv9H9edJvq+Za0zSgKwiwP8DDiwWMlEGBuUZqPd2GmFVkiBWcZQzU6U9mjuR7FHt2HXxsHZu6vrp8LH/SFXtmLO/9OkzDYs0C9GSolMt3dWbDcJS+00o2MCkkHCCkO8dJBTdOv0mfxg7W46JGdqsMh
X-Microsoft-Antispam-PRVS: <BYAPR02MB434162DFB988071E5063A1FBF64B0@BYAPR02MB4341.namprd02.prod.outlook.com>
X-Forefront-PRVS: 09760A0505
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR02MB4341;23:9bY1CgSCe9TH0FsEQiRluK48fhMRcyGr92EFjW/bj?=
 =?us-ascii?Q?opo/IconTp1Z4nqmOiBP+EuP4kuLQeI6qqg72N8E3qtqYs92dgVqx1SfIKxy?=
 =?us-ascii?Q?ZgepGWCTBiJwg1Xw5BG0F+3/5PqP+wIngczYVoIoMXy68AtAbdKAZBucHpGD?=
 =?us-ascii?Q?JLozvvN7olyR+hbMUdOsKJPJr6MSEAuEIkQUJrvrzZgbQMMI9e+KSeI3dG4Q?=
 =?us-ascii?Q?evkG6k4PZWVIqFFJxAq9GCUU9GbqhkrBk+XFrRuz3qhU5Ux43hQRtCaEpEOA?=
 =?us-ascii?Q?z5/edHDflzsUyBDMZImrMsYCmXmKiBJXoqWb/kUtiXU/gGj7NBcBL+ft80oC?=
 =?us-ascii?Q?ZCgWrd+VNunDq5iOzJW0NGOwrC5165QcUCZ8tSZKpFsFoIYT1aIssgjURIB1?=
 =?us-ascii?Q?fTTJ5PyIq2TXHs7UfYbCRGifhV4hUaOFfIwooESDg9k7VCsncNHmyplP2jc4?=
 =?us-ascii?Q?qIvQefzd1bfur9lR5nbl88L2PcTYjA2Ro9L9Kq8RPdJc0ZldclX8JIjoVPxE?=
 =?us-ascii?Q?CtbfueADtCWGQd6+NC9xUbP/bWlPLjKrAE8YkUOF0pvagxnFaIh/mQPZEaRz?=
 =?us-ascii?Q?5PGk+G81eSHFUNAma6+i9LlOxEfuTzVqmnozZnGrXdRYFkp4VOWtmtlSOq7F?=
 =?us-ascii?Q?ifPZxr7ZbFOoBys3U2Br1NhREzdCPcy/AxOXtSDPJBF5v6Wv8mJklaCLtsQu?=
 =?us-ascii?Q?WmtjqCXn0VzNICyKFjYIk5b+9BCaH3/EuPg847DtdRgmfAcHLDdO5v7e/qwu?=
 =?us-ascii?Q?EMEBe1CK7fW9pG8BLXQSAo8ilmKa1+eTOI/ixDwJgMfMv/34/wU3Rhis1jMN?=
 =?us-ascii?Q?+YkKsbtCFxVjIQpe+5uu83nnaBlXYDfbaa2spz5JcHeRBVKr3Or8AHnHRL9f?=
 =?us-ascii?Q?VW+WnwsWJjfMzbkZJ5j4foJgN7+WVTc8P6Axxir/405G3ut6uSB7KH2J5uc2?=
 =?us-ascii?Q?gcMkU0l1VrCjBlqPlK+jRUtJjRhWIMxYhPj/8AvOOjGj2odqRHoXUp93Z+ab?=
 =?us-ascii?Q?3Nq/EebEQm09EgT2Lb5ru19G1QeusyfwsFW2ofhw2oWz0VMIZMmJsdxcL7cP?=
 =?us-ascii?Q?2+2oUXHTJxlQSPexriVgnJ4/k2T12y7MsblULbZ+3wBEK4TtEOOnqE4AO6FI?=
 =?us-ascii?Q?WXm6lWP0ep9xHx/XimaeHssFOh3T0HkDye0cTRPDXCMlciZwJ4Ayg=3D=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 7RSAqPXtklxwy1aAwkYattQXIfe4ooctWVuIrWrLFlmS76AxV/DoBKymw4K3HDtFjDLpMylwpXoelaY6lHnN+fAxy63TY1LRrKjVaRR8py6FMEO7t4n5c4qaKP3G9EpjfrMGVGEXgiKvpcEsf7yByj3NU6VAXUbC2ob4PJcQt8gdeqXx1Vz04TOtbffIhvS8vp8ooT6KModl46xGsrlbar1TC1bmoOC0Rz3v1vfqQQkyX5pdnN8Kj2VL/0tfWfzSWJ9DRNSolKYTX1JIWXUFsSqsy3Nbit1Yj4/lGmCBxZtqY7VWuT0zE/4Uoumg+GDlIgNL9Zmeokfbx4Clb8YUM/wpbvdSJq0BuBcNdmE3Zx97sUAj+jLieoZD9KoDQSua9VEd7Z2Z2aX2UkkpO3IAJTF1wfqqFcBUAMPv1AKLbjM=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2019 11:30:47.6999
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b39ba3-d918-4796-27c3-08d6a8708159
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4341
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

v7
- 1/2
  - Removed the name of control from en-active-lanes as suggested by Sakari
  - Updated the dt node name to csi2rx
- 2/2
  - No change

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

 .../bindings/media/xilinx/xlnx,csi2rxss.txt        |  117 ++
 drivers/media/platform/xilinx/Kconfig              |   10 +
 drivers/media/platform/xilinx/Makefile             |    1 +
 drivers/media/platform/xilinx/xilinx-csi2rxss.c    | 1465 ++++++++++++++++++++
 include/uapi/linux/xilinx-v4l2-controls.h          |   14 +
 include/uapi/linux/xilinx-v4l2-events.h            |   25 +
 6 files changed, 1632 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
 create mode 100644 drivers/media/platform/xilinx/xilinx-csi2rxss.c
 create mode 100644 include/uapi/linux/xilinx-v4l2-events.h

-- 
2.7.4

