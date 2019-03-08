Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA85BC43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 17:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AC6220868
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 17:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="p07OGDYR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfCHRh0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:37:26 -0500
Received: from mail-eopbgr680076.outbound.protection.outlook.com ([40.107.68.76]:55943
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726249AbfCHRhZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 12:37:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iXKPk/PYhvlOsLfzbqPhcTyqD9wqHRtDWn2oAnXfjpw=;
 b=p07OGDYRB271V9EcdBfi7j/CJzEKPbkzdl8XiCWOTpzI/84nTYKG2AeoM814+N1247DzSMb5OztnPVHC/uSh87lyQlJC0huKlea+cUqyq0a9KDd6NI+r1AHsdZ5MAoLmMNJ+ZwyOe0AhsPtL8G/Eb5Gk+nyeOfDUllvwlgOY+cw=
Received: from BYAPR02CA0058.namprd02.prod.outlook.com (2603:10b6:a03:54::35)
 by MWHPR02MB2381.namprd02.prod.outlook.com (2603:10b6:300:5d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1665.18; Fri, 8 Mar
 2019 17:37:21 +0000
Received: from SN1NAM02FT053.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::206) by BYAPR02CA0058.outlook.office365.com
 (2603:10b6:a03:54::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1665.16 via Frontend
 Transport; Fri, 8 Mar 2019 17:37:21 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT053.mail.protection.outlook.com (10.152.72.102) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1686.19
 via Frontend Transport; Fri, 8 Mar 2019 17:37:20 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h2JQu-0003jk-1j; Fri, 08 Mar 2019 09:37:20 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h2JQo-0001oh-Uc; Fri, 08 Mar 2019 09:37:14 -0800
Received: from xsj-pvapsmtp01 (mailhub.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x28HbCwd001139;
        Fri, 8 Mar 2019 09:37:12 -0800
Received: from [172.23.29.77] (helo=xhdyacto-vnc1.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1h2JQl-0001nL-OD; Fri, 08 Mar 2019 09:37:12 -0800
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
Subject: [PATCH v4 0/2] Add support for Xilinx CSI2 Receiver Subsystem
Date:   Fri, 8 Mar 2019 23:01:26 +0530
Message-ID: <1552066288-58404-1-git-send-email-vishal.sagar@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(39860400002)(346002)(136003)(376002)(2980300002)(199004)(189003)(26005)(110136005)(7696005)(2201001)(16586007)(77096007)(2906002)(81156014)(8676002)(81166006)(6636002)(5660300002)(476003)(2616005)(47776003)(107886003)(316002)(6666004)(356004)(186003)(336012)(86362001)(14444005)(48376002)(36756003)(126002)(478600001)(106002)(8936002)(486006)(51416003)(7416002)(426003)(50226002)(4326008)(50466002)(63266004)(44832011)(106466001)(9786002)(36386004)(305945005)(921003)(2101003)(1121003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR02MB2381;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa867fb4-7825-408b-648c-08d6a3ecb7b6
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:MWHPR02MB2381;
X-MS-TrafficTypeDiagnostic: MWHPR02MB2381:
X-Microsoft-Exchange-Diagnostics: 1;MWHPR02MB2381;20:9qN8OWu5FXagSbUHNRgeQKFYbQSQok0VXIgOT9XKH1N3CWI3RPuDEdccj9vOdb6W3IGHl3jhMl1Pa6+sWkGLXndKyPzoJWTZiKOXqNrf5NDfTZUR815i05txf3qKWzfDYVB9+cZkNJOBQJgERP94pSpx+dQUA/p1mweuwGzI0xBa43d5jzO+BJLxibCFDA1RKYJBice4Nf/aleU+8ZLd2q4zX0El9nEPMByt0QeCJ9v46m0T/SsLRBesKaHqOVV0UQbxZaIcDjZWX1WFIadE+A9n8FGROM3VbUvq+0pQ8XPRInG+SoUo3NgyXc+Gn0O6/oP1ZnQj0p8LcS6abJTjid++Us1UzO68uVL0KQf+bCBe6OJwWmN4nLPgUqSmKvwQUgSLZ4wYH7mNmCR+GvI7wUPG4UsBsVwp7lY6y+ftIUgNE1WAZUDzLP/7z6ITC3U4wkLV9oAeEbsakCDM+iSvObHV9beuhptODrb2CluvcHaVquMXp0SxVwQSV4jxvvmy
X-Microsoft-Antispam-PRVS: <MWHPR02MB2381293FD32709BF25A4FC0BF64D0@MWHPR02MB2381.namprd02.prod.outlook.com>
X-Forefront-PRVS: 0970508454
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;MWHPR02MB2381;23:LOx7UsETwzg6cNkQk1Qio34aClTnmVZSuFJSLENqP?=
 =?us-ascii?Q?gwaf/MCfztnaz+/Lz1XORhLAO0tWxW0qV/Tdh8deLW3OLPjU0DBTbrNpYBG6?=
 =?us-ascii?Q?VpB6EEVI9/vZJViAruJY5kKIha+SMCb6lz15xs+iBzbAgPMAdHUd2wRwlzFo?=
 =?us-ascii?Q?DrsiNy0DBUD50sdq1iIK87Q0sJ2P4crvLlnV0OmImbNOULrkzjJxxIdiCexP?=
 =?us-ascii?Q?87hJhMBrG+YrS1VlAdiwpi7kV5QrpqdjLvBVdjJeQQD3CsTi9jHN7VMRLmFu?=
 =?us-ascii?Q?wkQ2WarDL3bO9t0vP65D36llSfkUzvq7nAEbE6MppJtOmKg2ruePlF+mNjGX?=
 =?us-ascii?Q?1oOqnTGfFkupbInVt27NxfdHqHtFt2IcC9Ljz6RrBmons+BfWf68MXYx5URl?=
 =?us-ascii?Q?9CpPYPGuID8VA4ogiHUoGDkgSW0CCEc6+jWy1vp7SfMG1m/eou7SQvBXHuVI?=
 =?us-ascii?Q?WGrX+lubSJgLlMFZx9ejTqDoy33TGM/DN15bGj8VGEDrfR6pZvhxohLTHL0r?=
 =?us-ascii?Q?h3qFy53rASEoLp1lVbs57ABBaztxULeNFnWUWqq1hD1C52PLNi6wLbtT2odZ?=
 =?us-ascii?Q?d6JxlgHvz7/NEkfAGIyY6XZCJSX7Wmqf83Lk6LDdRa2USnrYJ3ZXA4oCVYio?=
 =?us-ascii?Q?qVEhsLs33Am2hbkIKxXEV1Kw/V3/h2J7YqxfvCs6dn+LOw2YK2mM+Gc+fh2F?=
 =?us-ascii?Q?L/seMXPy33fMXRtj6edqT5CNuh89Jl/qwo2FhJq+EScuyBXurCbezU+Z2u30?=
 =?us-ascii?Q?aR7JfnAt6LH3nEMfh4+nyIQOADyRTlO5V4BTLzRbkLA2TkAmpVJkL+f2qRXH?=
 =?us-ascii?Q?Eg5b2aoQw5l+8NSP5mJ5xpWv9TgPnkm7L0WKZaSg11TUmOnfTH/3XyMvjj5L?=
 =?us-ascii?Q?Z2CY4RD+CclBexW5+gPk7WFkp0gZ7fz1b/btTJDgppEM3mGPDJSJLjXr61Wb?=
 =?us-ascii?Q?onGdfQzX1J7PVosxwQGVXya82upExg96IaRSV6e4PQyEWXiofDP6G1XZUg9H?=
 =?us-ascii?Q?clyEdGQiuAv/mp44WQhddL/MiULM/bvTDzAB9CeX5FMRK6vpIosJu3E1/CAe?=
 =?us-ascii?Q?3Eh1aGKp9bHdWbTpbVEAwNBPODW7GnW5SlHb/xEX86wmih5u6kOWpn+lmoZD?=
 =?us-ascii?Q?7CrKexHs1mSHEQh1/rHIkNX7xOAgpdb+hGCHFwPPl/NTSIaZOMwnny11Qe+l?=
 =?us-ascii?Q?gnPdF6/xXJNXOs=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: hCoD+kA5hpuduF0h9AX+aOKpNvkmKBPUnC4eqx6BctokBejpXcqIkM9uKiTIF6yisp22sohi5x6GCJLf11tLp5OtlYHC1Ifxp+krQ0aPGonEXCVrwl15HGciHAvFZjleYYSFVXiIATEcTsVzHAuyW0k1GX5GpAN0N0TqWgPzLROdmJosc8r6qBkjiM0g/G3UQcl5qDakor5uBFQcmG7XucWZp2IvwxE8cSKTsyCm2w14dNjF1xLYWQ6VidKM8GcZ6YPcXwYSMN2ek9j6rSXEjbDCiCYDMBR/kpE+Flk/pcRC+0J7oV6/Y9MQytkjYYiNDKAuOgOVUDzNlvV0OGY84ZsKxKISHqtBLSZw7jXSp6/m31YngV9antmXPN5z9aT28hbm4JIVwXZm3A4wOY7o8rg9odmlMUtRRY2/aZb9Tlw=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2019 17:37:20.4823
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa867fb4-7825-408b-648c-08d6a3ecb7b6
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2381
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
in Xilinx UG934 when the Video Format Bridge.

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

 .../bindings/media/xilinx/xlnx,csi2rxss.txt        |  123 ++
 drivers/media/platform/xilinx/Kconfig              |   10 +
 drivers/media/platform/xilinx/Makefile             |    1 +
 drivers/media/platform/xilinx/xilinx-csi2rxss.c    | 1557 ++++++++++++++++++++
 include/uapi/linux/xilinx-v4l2-controls.h          |   14 +
 include/uapi/linux/xilinx-v4l2-events.h            |   25 +
 6 files changed, 1730 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
 create mode 100644 drivers/media/platform/xilinx/xilinx-csi2rxss.c
 create mode 100644 include/uapi/linux/xilinx-v4l2-events.h

-- 
2.7.4

