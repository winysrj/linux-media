Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FC7C43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 18:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F392520661
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 18:15:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="V2t14GW+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfCHSPH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 13:15:07 -0500
Received: from mail-eopbgr800072.outbound.protection.outlook.com ([40.107.80.72]:42176
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726761AbfCHSPH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 13:15:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9zVEsOPjei0EqOkzIICHtL35OQsx7QC2a18ff0Cn8g=;
 b=V2t14GW+zfm8AJwC84FKLzs7cvXtKZPe/FoKpeuDsd/PfcxJlM8/AllEJAZ4wIVAXPB80RDH0+rsmB1HM4sUVAfdl3lu8EpdbhEfi5sqRjg6AiG63ocVaXaBh+MeWSWVAB4XEUJFIZZw4BOdqnUl6Oma/NO3bd4mU66MkuV5KTI=
Received: from CY4PR02MB2709.namprd02.prod.outlook.com (10.175.80.9) by
 CY4PR02MB2728.namprd02.prod.outlook.com (10.175.60.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.18; Fri, 8 Mar 2019 18:13:22 +0000
Received: from CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::bc8d:c1a1:e7d9:2983]) by CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::bc8d:c1a1:e7d9:2983%11]) with mapi id 15.20.1686.018; Fri, 8 Mar 2019
 18:13:22 +0000
From:   Vishal Sagar <vsagar@xilinx.com>
To:     Vishal Sagar <vishal.sagar@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        Michal Simek <michals@xilinx.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinesh Kumar <dineshk@xilinx.com>,
        Sandip Kothari <sandipk@xilinx.com>
Subject: RE: [PATCH v4 0/2] Add support for Xilinx CSI2 Receiver Subsystem
Thread-Topic: [PATCH v4 0/2] Add support for Xilinx CSI2 Receiver Subsystem
Thread-Index: AQHU1dWTlxX3cEKB1kuu0S98N+Oij6YCCCNA
Date:   Fri, 8 Mar 2019 18:13:22 +0000
Message-ID: <CY4PR02MB27098D65DA1F1903DB8854E0A74D0@CY4PR02MB2709.namprd02.prod.outlook.com>
References: <1552066288-58404-1-git-send-email-vishal.sagar@xilinx.com>
In-Reply-To: <1552066288-58404-1-git-send-email-vishal.sagar@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vsagar@xilinx.com; 
x-originating-ip: [122.169.237.165]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e48b337-fc4d-4848-5d6b-08d6a3f1c01f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:CY4PR02MB2728;
x-ms-traffictypediagnostic: CY4PR02MB2728:
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;CY4PR02MB2728;23:U+brQ1ByGe/H4e/0/3+5+dqX+zH30/770ckJvwo6A?=
 =?us-ascii?Q?DXOgdoF9qpYwjVVMv6knIp8NHqD7y5xYVAd3QNTD5v7jUmJVtLSIuVMYFqNx?=
 =?us-ascii?Q?Kl4774YkWJpOUZs5jBgH0Azdnt7OyIDPuWSI9V1D7zGUwzJXy4bd9IKz2zAo?=
 =?us-ascii?Q?iKKLZJFUHwhJ5HGHZUfD8QQ7r9Ghv2BhOKfUl4Sx8NNbk53v6jOz0ZgwV9Wz?=
 =?us-ascii?Q?r8Qm0EMO2uPfu/b9PESgUsVm3bZb37hrJZjGLRveoEKP0+YYrACfbKAO78Sk?=
 =?us-ascii?Q?YmyfAHxX0mmz5EVoHWyKAdVvNy4v8UmCZ7P/KykT9UFMBGdYS1pEsZRxCPux?=
 =?us-ascii?Q?a/SOdEYpDYMsjN+tbQeWkswhWIZ5x2tgWXnRVtM3y/k4R2Ula98VvlZ67mI7?=
 =?us-ascii?Q?/hPj1t3tsFThkcsb2lXMcZxG9/RKCIr1sO1SHJOATXh7OIiUXzXSaAwwG6aD?=
 =?us-ascii?Q?AAfdnM1oY+L1rhSurQR4gfbZUqZZxK3zg2oTyltY0agXn80ViEe4jo+OMJ6a?=
 =?us-ascii?Q?F+Lxg3pbtSo+i2r7gcLJg7e8vJSc0Pkh+t5LMgXDxY+S5sOKiuZD9d1DkdSH?=
 =?us-ascii?Q?mvYm10dVjcAeNaR8pzNz8MT1TLkDechmz8xcXpmI3R/IA73OhZm3KpmJVqws?=
 =?us-ascii?Q?+H517uxgGNPB+tDw+tB78l+GiysytvCLgsZeo4wCIJL5vRXJo8dghbPd+wLX?=
 =?us-ascii?Q?yZPA30Mg89J5VoIV8y8aKJNCimlHifcBnw73QSl7qVAD1rGmPHDHV9zfr+4W?=
 =?us-ascii?Q?59Rwqo8kh59vYvQeoKJVH89klorPcaLjZzgHjNFu4bSMIDZvCPLX2A/2ljHd?=
 =?us-ascii?Q?ZQot3vrM66JzzNO11xiC36zeRwUthlBX5l9T+G9oXQAFYcDe15yepzZO18HA?=
 =?us-ascii?Q?WFpdnkWH+AZ5W6bThHgmn75FQYdegN54GxxOEy3GhYglNKnIE7U28Zz+dbit?=
 =?us-ascii?Q?QCDr8qIBwSpvauKH7OIgC3qQNiTuAUJh82YpIQHKRzLLIaXBnc4KykBdMD8q?=
 =?us-ascii?Q?3zCPtCWw2mXM2CxPT2YRHXRB/OCMjVOH4rOcvWP+AMftHFPOA8vc+yvmCaDP?=
 =?us-ascii?Q?PS3uvYU3rCa9RlGghCQFqlPQE8NwdGuztUuzPhn/OnCSO19P7EF5lm7OOal2?=
 =?us-ascii?Q?BQQ5GtpAesZFVTXu/zVVTcE6wdIL0CmguWsFLQMEN8Qgrz1edAHXRf2oPnwX?=
 =?us-ascii?Q?1VF3G6efzJi9lJQhoFLcH9br0U2TYH3dWdOzTQ73HcIsSXtDJXl9PNHBv7tt?=
 =?us-ascii?Q?vhXlDfFv8rU0FeiU+ttqVg1q/zdQ7JPTgf0LqmAO+WI3qEIHK0rmigPvAOX7?=
 =?us-ascii?Q?pkAWjfeROhPwYygSorcC3Cp7FS9Br2RQqD9n1aoPocezeycmSam31C1UOKoq?=
 =?us-ascii?Q?bVOQg=3D=3D?=
x-microsoft-antispam-prvs: <CY4PR02MB2728B32BD57275FCAABF4596A74D0@CY4PR02MB2728.namprd02.prod.outlook.com>
x-forefront-prvs: 0970508454
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(376002)(396003)(366004)(13464003)(53754006)(199004)(189003)(76176011)(6636002)(5660300002)(6116002)(3846002)(6436002)(2906002)(55016002)(97736004)(102836004)(6506007)(476003)(53546011)(486006)(53936002)(68736007)(6246003)(74316002)(14444005)(256004)(9686003)(446003)(11346002)(186003)(7696005)(26005)(99286004)(105586002)(71200400001)(14454004)(478600001)(25786009)(2501003)(52536013)(7416002)(305945005)(2201001)(110136005)(8936002)(229853002)(316002)(106356001)(66066001)(81166006)(71190400001)(81156014)(7736002)(86362001)(33656002)(8676002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR02MB2728;H:CY4PR02MB2709.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WGUT8Flf0AN4fLSkixnoUm+dLwmo/r7xOBU2qvFJavJJVQSrAmmaYiNCDpQYYMKyEwrAp3VB1C2mxOyU6d8zIMPPEuNKEdxdXEyKEfMK8+1GozNtO2pMteW7Zsjv/HBKjIj4hMstIOJ7KvntTF0z4EChBb+hV/5LhnJHdcXyk64FafU4PDbXpC6WyDnYByjGV5DMEvSnI80ig+dREOWQDU33dcGHvLjCSq6VaikpUldTUgm3nA9jjU8zoPn30ahgctD0VsABnrR9XygKvFQz9MTZZX/2mof67AfGGjuQm8K1kjKSIIn7vR7kY2+I5W+latwLo3hwn8EbHH0dhj8nR45pMx7tJe87M0yaJusXoVeqncf5Ox1T+rn1P/uWYEUVI95c6Dc7qG0neOHm5BWIdZi88phEY/Gat70fD1dC1L8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e48b337-fc4d-4848-5d6b-08d6a3f1c01f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2019 18:13:22.4399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR02MB2728
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi all,

Please ignore this patch series as I missed addressing some comments in thi=
s patch.
I will address them in the next series.=20

Regards
Vishal Sagar

> -----Original Message-----
> From: Vishal Sagar [mailto:vishal.sagar@xilinx.com]
> Sent: Friday, March 08, 2019 11:01 PM
> To: Hyun Kwon <hyunk@xilinx.com>; laurent.pinchart@ideasonboard.com;
> mchehab@kernel.org; robh+dt@kernel.org; mark.rutland@arm.com; Michal
> Simek <michals@xilinx.com>; linux-media@vger.kernel.org;
> devicetree@vger.kernel.org; sakari.ailus@linux.intel.com;
> hans.verkuil@cisco.com; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; Dinesh Kumar <dineshk@xilinx.com>; Sandip Kothari
> <sandipk@xilinx.com>
> Cc: Vishal Sagar <vishal.sagar@xilinx.com>
> Subject: [PATCH v4 0/2] Add support for Xilinx CSI2 Receiver Subsystem
>=20
> Xilinx MIPI CSI-2 Receiver Subsystem
> ------------------------------------
>=20
> The Xilinx MIPI CSI-2 Receiver Subsystem Soft IP consists of a DPHY which
> gets the data, an optional I2C, a CSI-2 Receiver which parses the data an=
d
> converts it into AXIS data.
> This stream output maybe connected to a Xilinx Video Format Bridge.
> The maximum number of lanes supported is fixed in the design.
> The number of active lanes can be programmed.
> For e.g. the design may set maximum lanes as 4 but if the camera sensor h=
as
> only 1 lane then the active lanes shall be set as 1.
>=20
> The pixel format set in design acts as a filter allowing only the selecte=
d
> data type or RAW8 data packets. The D-PHY register access can be gated in
> the design. The base address of the DPHY depends on whether the internal
> Xilinx I2C controller is enabled or not in design.
>=20
> The device driver registers the MIPI CSI2 Rx Subsystem as a V4L2 sub devi=
ce
> having 2 pads. The sink pad is connected to the MIPI camera sensor and
> output pad is connected to the video node.
> Refer to xlnx,csi2rxss.txt for device tree node details.
>=20
> This driver helps configure the number of active lanes to be set, setting
> and handling interrupts and IP core enable. It logs the number of events
> occurring according to their type between streaming ON and OFF.
> It generates a v4l2 event for each short packet data received.
> The application can then dequeue this event and get the requisite data
> from the event structure.
>=20
> It adds new V4L2 controls which are used to get the event counter values
> and reset the subsystem.
>=20
> The Xilinx CSI-2 Rx Subsystem outputs an AXI4 Stream data which can be
> used for image processing. This data follows the video formats mentioned
> in Xilinx UG934 when the Video Format Bridge.
>=20
> v4
> - 1/2
>   - Added reviewed by Hyun Kwon
> - 2/2
>   - Removed irq member from core structure
>   - Consolidated IP config prints in xcsi2rxss_log_ipconfig()
>   - Return -EINVAL in case of invalid ioctl
>   - Code formatting
>   - Added reviewed by Hyun Kwon
>=20
> v3
> - 1/2
>   - removed interrupt parent as suggested by Rob
>   - removed dphy clock
>   - moved vfb to optional properties
>   - Added required and optional port properties section
>   - Added endpoint property section
> - 2/2
>  - Fixed comments given by Hyun.
>  - Removed DPHY 200 MHz clock. This will be controlled by DPHY driver
>  - Minor code formatting
>  - en_csi_v20 and vfb members removed from struct and made local to dt
> parsing
>  - lock description updated
>  - changed to ratelimited type for all dev prints in irq handler
>  - Removed YUV 422 10bpc media format
>=20
> v2
> - 1/2
>   - updated the compatible string to latest version supported
>   - removed DPHY related parameters
>   - added CSI v2.0 related property (including VCX for supporting upto 16
>     virtual channels).
>   - modified csi-pxl-format from string to unsigned int type where the va=
lue
>     is as per the CSI specification
>   - Defined port 0 and port 1 as sink and source ports.
>   - Removed max-lanes property as suggested by Rob and Sakari
>=20
> - 2/2
>   - Fixed comments given by Hyun and Sakari.
>   - Made all bitmask using BIT() and GENMASK()
>   - Removed unused definitions
>   - Removed DPHY access. This will be done by separate DPHY PHY driver.
>   - Added support for CSI v2.0 for YUV 422 10bpc, RAW16, RAW20 and extra
>     virtual channels
>   - Fixed the ports as sink and source
>   - Now use the v4l2fwnode API to get number of data-lanes
>   - Added clock framework support
>   - Removed the close() function
>   - updated the set format function
>   - Support only VFB enabled config
>=20
> Vishal Sagar (2):
>   media: dt-bindings: media: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem
>   media: v4l: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem driver
>=20
>  .../bindings/media/xilinx/xlnx,csi2rxss.txt        |  123 ++
>  drivers/media/platform/xilinx/Kconfig              |   10 +
>  drivers/media/platform/xilinx/Makefile             |    1 +
>  drivers/media/platform/xilinx/xilinx-csi2rxss.c    | 1557
> ++++++++++++++++++++
>  include/uapi/linux/xilinx-v4l2-controls.h          |   14 +
>  include/uapi/linux/xilinx-v4l2-events.h            |   25 +
>  6 files changed, 1730 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
>  create mode 100644 drivers/media/platform/xilinx/xilinx-csi2rxss.c
>  create mode 100644 include/uapi/linux/xilinx-v4l2-events.h
>=20
> --
> 2.7.4

