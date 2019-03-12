Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA39C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 04:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D2742087C
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 04:39:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="AjM+hife"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfCLEjA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 00:39:00 -0400
Received: from mail-eopbgr760070.outbound.protection.outlook.com ([40.107.76.70]:47462
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbfCLEjA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 00:39:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BzUaijgA+tso8g91qAKKbGPfPVV8rlWyBQT2/Q0RQ2U=;
 b=AjM+hifeFDLRY89Ogqnqd7Q3QVN1Quk5bCxk6wqATjZ5Zjq+r5B51hAVUlPnp30J+jlD0Ar3KFHweV17ux44QXdfE8C943FKz0BmoSCNJq+Hrt2JsSrBVu18ktM2rL0IQMOTWOQqERQzqG8QRN9MauwRRf480rqlqqHp7mWKHkc=
Received: from CY4PR02MB2709.namprd02.prod.outlook.com (10.175.80.9) by
 CY4PR02MB3253.namprd02.prod.outlook.com (10.165.88.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.18; Tue, 12 Mar 2019 04:38:17 +0000
Received: from CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::bc8d:c1a1:e7d9:2983]) by CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::bc8d:c1a1:e7d9:2983%11]) with mapi id 15.20.1686.021; Tue, 12 Mar
 2019 04:38:17 +0000
From:   Vishal Sagar <vsagar@xilinx.com>
To:     Rob Herring <robh@kernel.org>,
        Vishal Sagar <vishal.sagar@xilinx.com>
CC:     Hyun Kwon <hyunk@xilinx.com>,
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
        Sandip Kothari <sandipk@xilinx.com>,
        Vishal Sagar <vishal.sagar@xilinx.com>
Subject: RE: [PATCH v5 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
 CSI-2 Rx Subsystem
Thread-Topic: [PATCH v5 1/2] media: dt-bindings: media: xilinx: Add Xilinx
 MIPI CSI-2 Rx Subsystem
Thread-Index: AQHU1+9k1Y7bX2mJwEG8jY2Ju1imtKYHB1AAgABjSuA=
Date:   Tue, 12 Mar 2019 04:38:17 +0000
Message-ID: <CY4PR02MB27096C056A79EDF5B62AC7E6A7490@CY4PR02MB2709.namprd02.prod.outlook.com>
References: <1552297257-145919-1-git-send-email-vishal.sagar@xilinx.com>
 <1552297257-145919-2-git-send-email-vishal.sagar@xilinx.com>
 <20190311224140.GA23484@bogus>
In-Reply-To: <20190311224140.GA23484@bogus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vsagar@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9654e4c1-1956-49bb-8f47-08d6a6a48c4a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:CY4PR02MB3253;
x-ms-traffictypediagnostic: CY4PR02MB3253:
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;CY4PR02MB3253;23:EtCyG34+QhAV62CAnN0K9jBRN7XsmHMOnpcjniHrV?=
 =?us-ascii?Q?KYU2qo5o/WCKnx/tt6i55Si5tY+YHADCUGvUaEqn3Cu1OgztgsFaumpF6mVt?=
 =?us-ascii?Q?q9/fFb7hNvKu8XohVrr1WmG/PVwLH3LTWTXoDIL8muVXoDoUKv9srQWSZehO?=
 =?us-ascii?Q?WsLdv/EApyGq/Mb0Vc+Ny2Xnk9r2kak7yUMuqhsDCp/oyzqCk03jgBNijhu8?=
 =?us-ascii?Q?Z3nXS0cCk4S34U8EMmIAwTU1mT78/SpBYpRqsrSUpgKwD2qxDrHHkAeDQEkD?=
 =?us-ascii?Q?oUg3FkiTdrqg0puzJLsSYFWUkQ695vjtQgPPaJ9k61tEc/v5n1s6QPU9OUEB?=
 =?us-ascii?Q?JT7ThDSfGhZo+n5420VJoK7gN6GqOGrbjXXtLyXhyOn0hROWKJJkofNnJYlB?=
 =?us-ascii?Q?26/3wIze1+BqGbkedClCM92IVBpLlPiJoBtAGgZk+FZKTc9NdCS2ihrntB3u?=
 =?us-ascii?Q?zpHpkx4fkBUKSZ4Oi6IWFEIMZUduXcH2+w4nlk1R6kmQmmjLFWoHy+FzOHMd?=
 =?us-ascii?Q?pDUuWqDqEajhFTLAub/aX5LFKP9A+tF/1qq1+MoAi6Xgn1eBFbVljSFn/FvO?=
 =?us-ascii?Q?c7O678qDUSMT1A7Pypwpi6cFlS3awMagqHpiOYgm1WkckmVemKw+KxXp/ADJ?=
 =?us-ascii?Q?JDsyJp4cKxkWvE77oY16iQSX+bm9R4c2ezJUXsbvT/cVEDSdwlJ5WvfS7nSb?=
 =?us-ascii?Q?Y5CjCfMxtTjdweJ22O6F6tcS4rG08bD1uzsvbj4SZGGgH2kct9lnCgTc6YUb?=
 =?us-ascii?Q?nQMOFQHlvYi1vzv54fWs1S3cKEM2TSQ888AuFOzH25nfRqo5cNRVp9OM+9ir?=
 =?us-ascii?Q?0iN0moEFhyfRrMBBy0gyNdNMuY7a06pfSa2GMFHGY079AtwI4saQqwnOVeGE?=
 =?us-ascii?Q?KqFnN6AD86zRhbtcHirjJYIjqsDsRGsnT91d5igOPJ2woy0zgtEFIZy/hAsf?=
 =?us-ascii?Q?bZplbMbC29wSBrQbCRfIPWItdPPRi8tJqhr3KDEpOruqGAhVOj9tx4CS/STw?=
 =?us-ascii?Q?y77yxBdg2YEsgW+Yrnsx49Iv9kJFBkzkmWt5sTpgLeQKRuF9g+k4bXYmcPGy?=
 =?us-ascii?Q?Zfa+xcr6Pa1T5woKBDe+iL6Hiy3UJ4Tkd6vM3J07j9qH+p2TVOAfIdQJr3Dj?=
 =?us-ascii?Q?RvEK3fKW0Q7WhrkU/oY4oU6VYUw8MgNCNjLt6ZlLvDLuBj5bONyLONR+ePZS?=
 =?us-ascii?Q?jhRu7XKYvzhcO282cpR40DhIZR8i+3mbYd6SJ2Lz/gkGlvfr/qUfOFbenNs6?=
 =?us-ascii?Q?2yXJVU9nRQa+aVPSDoUR5DxYEL6gq9b7JmJg6vjfJidSTUBBCmeJywQMHZbe?=
 =?us-ascii?Q?+iKmsbcPH1iFE0FpU5PoDo0IFZkoZd/TWmPHzfJNdZ7?=
x-microsoft-antispam-prvs: <CY4PR02MB3253BE90C46572E29C3DE232A7490@CY4PR02MB3253.namprd02.prod.outlook.com>
x-forefront-prvs: 09749A275C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(39850400004)(136003)(366004)(376002)(199004)(189003)(51914003)(13464003)(26005)(11346002)(316002)(6246003)(7416002)(2906002)(446003)(7736002)(105586002)(6636002)(107886003)(186003)(25786009)(4326008)(14454004)(106356001)(68736007)(8676002)(74316002)(305945005)(8936002)(81156014)(81166006)(99286004)(478600001)(486006)(33656002)(476003)(102836004)(3846002)(6116002)(7696005)(229853002)(76176011)(66066001)(53546011)(6506007)(97736004)(6436002)(110136005)(86362001)(5660300002)(256004)(54906003)(53936002)(71190400001)(71200400001)(9686003)(52536013)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR02MB3253;H:CY4PR02MB2709.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /VvmXPoJFbOY8IW4lJxzfl2QN057GN1hpRoEbJ0Xteo7489yxU8MHyOlZfnSKREM4YZowN/14eIQU2PrOa3FT8CcybE9AT0bD+phaEAacTx9/FbOtbummk4+1ns4ODBaDzOZkbSrKot0xdCKv1tnV5gLVYyKpc8ED48L/kDLIGVQ5U1EPwLdwC/EUONWz0At0MOjuqEBwvJM19pjJrs1w7U1k4TksCIAP3ROeUSyyocOFHBN65yDvkzB1YsA7zw88qfqMVIdrkSbnnHi3QDHL1JjMzvBO4dRWn/NdLrhgq0FYI26wHHFEcQuIWBHYpts+RRADWVaOcXqTuKgBh+Vrd7VMVIq5mNTkfIVmymL9pk6BoXiT2OB4L0SVDSA4Yys64HqQhJhC6WjDVzNlhjiEgkk65y3JJ6tOwrxvrUxtwY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9654e4c1-1956-49bb-8f47-08d6a6a48c4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2019 04:38:17.6796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR02MB3253
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Rob,

> -----Original Message-----
> From: Rob Herring [mailto:robh@kernel.org]
> Sent: Tuesday, March 12, 2019 4:12 AM
> To: Vishal Sagar <vishal.sagar@xilinx.com>
> Cc: Hyun Kwon <hyunk@xilinx.com>; laurent.pinchart@ideasonboard.com;
> mchehab@kernel.org; robh+dt@kernel.org; mark.rutland@arm.com; Michal
> Simek <michals@xilinx.com>; linux-media@vger.kernel.org;
> devicetree@vger.kernel.org; sakari.ailus@linux.intel.com;
> hans.verkuil@cisco.com; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; Dinesh Kumar <dineshk@xilinx.com>; Sandip Kothari
> <sandipk@xilinx.com>; Vishal Sagar <vishal.sagar@xilinx.com>
> Subject: Re: [PATCH v5 1/2] media: dt-bindings: media: xilinx: Add Xilinx=
 MIPI
> CSI-2 Rx Subsystem
>=20
> EXTERNAL EMAIL
>=20
> On Mon, 11 Mar 2019 15:10:56 +0530, Vishal Sagar wrote:
> > Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.
> >
> > The Xilinx MIPI CSI-2 Rx Subsystem consists of a CSI-2 Rx controller, a
> > DPHY in Rx mode, an optional I2C controller and a Video Format Bridge.
> >
> > Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
> > Reviewed-by: Hyun Kwon <hyun.kwon@xilinx.com>
> > ---
> > v5
> > - Incorporated comments by Luca Cersoli
> > - Removed DPHY clock from description and example
> > - Removed bayer pattern from device tree MIPI CSI IP
> >   doesn't deal with bayer pattern.
> >
> > v4
> > - Added reviewed by Hyun Kwon
> >
> > v3
> > - removed interrupt parent as suggested by Rob
> > - removed dphy clock
> > - moved vfb to optional properties
> > - Added required and optional port properties section
> > - Added endpoint property section
> >
> > v2
> > - updated the compatible string to latest version supported
> > - removed DPHY related parameters
> > - added CSI v2.0 related property (including VCX for supporting upto 16
> >   virtual channels).
> > - modified csi-pxl-format from string to unsigned int type where the va=
lue
> >   is as per the CSI specification
> > - Defined port 0 and port 1 as sink and source ports.
> > - Removed max-lanes property as suggested by Rob and Sakari
> >
> >  .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 118
> +++++++++++++++++++++
> >  1 file changed, 118 insertions(+)
> >  create mode 100644
> Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> >
>=20
> Reviewed-by: Rob Herring <robh@kernel.org>

Thanks for the review. :)=20

Regards
Vishal Sagar
