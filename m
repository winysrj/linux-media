Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EE3C31681
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 17:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BFB42085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 17:18:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=renesasgroup.onmicrosoft.com header.i=@renesasgroup.onmicrosoft.com header.b="giZV62Tk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfAURSN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 12:18:13 -0500
Received: from mail-eopbgr1410097.outbound.protection.outlook.com ([40.107.141.97]:17775
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725879AbfAURSM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 12:18:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector1-bp-renesas-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAbozCDCDuUp/fc69ySlujN/9D0whpHzkZqiuRP1BHw=;
 b=giZV62Tkc4FGjmozC3nuUHTMn9kK8hu6BamCJP8F44vr6nI2NfCHw5jwcTTSIPu09zXmreF8uJIycYTNYPNMWxJhPCT0kkYoEt0k8K4V29oBE5RmM5/zEFBM8eSMNqtmi85M7Af6JS/bBE/V0+qHkGII5tBSh5Dkq8g1awPTtYQ=
Received: from TY1PR01MB1770.jpnprd01.prod.outlook.com (52.133.163.147) by
 TY1PR01MB1641.jpnprd01.prod.outlook.com (52.133.162.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.27; Mon, 21 Jan 2019 17:18:08 +0000
Received: from TY1PR01MB1770.jpnprd01.prod.outlook.com
 ([fe80::4a9:6014:ec1d:1122]) by TY1PR01MB1770.jpnprd01.prod.outlook.com
 ([fe80::4a9:6014:ec1d:1122%5]) with mapi id 15.20.1537.031; Mon, 21 Jan 2019
 17:18:08 +0000
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
CC:     Biju Das <biju.das@bp.renesas.com>,
        =?iso-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ragnatech.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH 2/5] media: rcar-csi2: Enable support for r8a774a1
Thread-Topic: [PATCH 2/5] media: rcar-csi2: Enable support for r8a774a1
Thread-Index: AQHUSRPoUK0y72FpU0KOnh43yQrTqaVGSxPQgHR9JnA=
Date:   Mon, 21 Jan 2019 17:18:08 +0000
Message-ID: <TY1PR01MB17709FAA0F79317402C21499C09F0@TY1PR01MB1770.jpnprd01.prod.outlook.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-3-git-send-email-biju.das@bp.renesas.com>
 <TY1PR01MB177038E4E437F02A2E735DE4C0C50@TY1PR01MB1770.jpnprd01.prod.outlook.com>
In-Reply-To: <TY1PR01MB177038E4E437F02A2E735DE4C0C50@TY1PR01MB1770.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fabrizio.castro@bp.renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;TY1PR01MB1641;20:/371su2jjB6glB3BLWEjEjTIObAAUN5UMsFHI8c5kW6bcFtLGwIzzoFvfSHVUAGvJ1JvUpLNbkLukGWWN8wphqxpPZ2hvITS+Y0pu8ZzW4gg4vaxL0JDIi4GMkHDYRzO/j2OMoorKqtJeZQ/Ej95dmeOktSLGlzMFZnhErAuDuI=
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-ms-office365-filtering-correlation-id: 37f28048-3764-43e2-f695-08d67fc469d0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:TY1PR01MB1641;
x-ms-traffictypediagnostic: TY1PR01MB1641:
x-microsoft-antispam-prvs: <TY1PR01MB1641EF018BDE56BD5A04753DC09F0@TY1PR01MB1641.jpnprd01.prod.outlook.com>
x-forefront-prvs: 0924C6A0D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(136003)(366004)(396003)(346002)(376002)(189003)(199004)(476003)(186003)(4326008)(11346002)(2906002)(446003)(44832011)(106356001)(14454004)(105586002)(486006)(76176011)(3846002)(6116002)(53936002)(316002)(25786009)(6916009)(229853002)(8676002)(33656002)(68736007)(54906003)(9686003)(7696005)(55016002)(102836004)(6436002)(6246003)(97736004)(53546011)(6506007)(107886003)(26005)(305945005)(8936002)(81166006)(99286004)(7736002)(71190400001)(71200400001)(14444005)(86362001)(256004)(74316002)(66066001)(81156014)(478600001)(138113003)(98903001);DIR:OUT;SFP:1102;SCL:1;SRVR:TY1PR01MB1641;H:TY1PR01MB1770.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: U50PHnv5aVqW/YKRFYDK6Z5jgBgapGxAd9f/cDhGoDzTgel7shb6ypG6EtvF5TdTYJzjOXWnGEklBviMybUdFgqZtvmiYrGjFFsuxgrky3IAWxjKID2evP4t9lKOY8q1Ct5jzlYfnqpv70RgwgR6NydrvZgJa3HeQvjtZ1k5UYr6BA1TcntguMgrk3D41FWZIQ5LAYm/X+gD2k+SrrxX5DUCCIjvNEJBg1PETTPvI0t7wVMC0UWp+hTB1ntuF72DOG4Kh4cecB5dKSWrHWP5BaAYEN6QUAN5nu3WFAO842gtVxtEgV89ZZgQusOahgPDIFffZm61oFDoOjzKjZB7yfUdwOBn1QKRBEng5y1vWPMG5ss/CWZ2L5biwKce3KZbozeLtkuceOcZhG6u9CWSaXrcao4SNCd77SBqy1UX908=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37f28048-3764-43e2-f695-08d67fc469d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2019 17:18:08.3472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PR01MB1641
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Mauro,

This is a gentle reminder.

Thanks,
Fab

> From: linux-renesas-soc-owner@vger.kernel.org <linux-renesas-soc-owner@vg=
er.kernel.org> On Behalf Of Fabrizio Castro
> Sent: 08 November 2018 14:24
> Subject: RE: [PATCH 2/5] media: rcar-csi2: Enable support for r8a774a1
>
> Hello Mauro,
>
> Does this patch look ok to you?
>
> Thanks,
> Fab
>
> > From: linux-renesas-soc-owner@vger.kernel.org <linux-renesas-soc-owner@=
vger.kernel.org> On Behalf Of Biju Das
> > Sent: 10 September 2018 15:31
> > Subject: [PATCH 2/5] media: rcar-csi2: Enable support for r8a774a1
> >
> > Add the MIPI CSI-2 driver support for RZ/G2M(r8a774a1) SoC.
> > The CSI-2 module of RZ/G2M is similar to R-Car M3-W.
> >
> > Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> > Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/medi=
a/platform/rcar-vin/rcar-csi2.c
> > index daef72d..65c7efb 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -953,6 +953,10 @@ static const struct rcar_csi2_info rcar_csi2_info_=
r8a77970 =3D {
> >
> >  static const struct of_device_id rcar_csi2_of_table[] =3D {
> >  {
> > +.compatible =3D "renesas,r8a774a1-csi2",
> > +.data =3D &rcar_csi2_info_r8a7796,
> > +},
> > +{
> >  .compatible =3D "renesas,r8a7795-csi2",
> >  .data =3D &rcar_csi2_info_r8a7795,
> >  },
> > --
> > 2.7.4
>
>
>
>
> Renesas Electronics Europe Ltd, Dukes Meadow, Millboard Road, Bourne End,=
 Buckinghamshire, SL8 5FH, UK. Registered in England &
> Wales under Registered No. 04586709.



Renesas Electronics Europe Ltd, Dukes Meadow, Millboard Road, Bourne End, B=
uckinghamshire, SL8 5FH, UK. Registered in England & Wales under Registered=
 No. 04586709.
