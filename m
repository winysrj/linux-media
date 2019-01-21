Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F045FC31688
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 17:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B785420879
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 17:17:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=renesasgroup.onmicrosoft.com header.i=@renesasgroup.onmicrosoft.com header.b="uOtWK6yE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfAURRM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 12:17:12 -0500
Received: from mail-eopbgr1410131.outbound.protection.outlook.com ([40.107.141.131]:20653
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725879AbfAURRM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 12:17:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector1-bp-renesas-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O17smv20DPgsJiOj3mN15DT5yUNXpWLkEKg6TOoKKCg=;
 b=uOtWK6yE6HFX2qBeGVCkSRYzrnNepN/wafveXiJyVjgoSUT3D1J6Pc7v239SqMOagjBnmFccVAp8PDNgjZGmsZfl6so4g7+tQrLpHiSYKWJu9z0r6SlGkMWMfXXT4VUYV5TxWPSAGpjRXBvPXroEt9ow//2916GT7ryaZYM9ztU=
Received: from TY1PR01MB1770.jpnprd01.prod.outlook.com (52.133.163.147) by
 TY1PR01MB1641.jpnprd01.prod.outlook.com (52.133.162.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.27; Mon, 21 Jan 2019 17:17:06 +0000
Received: from TY1PR01MB1770.jpnprd01.prod.outlook.com
 ([fe80::4a9:6014:ec1d:1122]) by TY1PR01MB1770.jpnprd01.prod.outlook.com
 ([fe80::4a9:6014:ec1d:1122%5]) with mapi id 15.20.1537.031; Mon, 21 Jan 2019
 17:17:06 +0000
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
CC:     Biju Das <biju.das@bp.renesas.com>,
        =?iso-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ragnatech.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: RE: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
 support
Thread-Topic: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
 support
Thread-Index: AQHUSRPkccN3Ce6NF0WYXZsqMZnzMqVGSaiwgHR+KQA=
Date:   Mon, 21 Jan 2019 17:17:05 +0000
Message-ID: <TY1PR01MB1770CFD7B98C8376C0E6712BC09F0@TY1PR01MB1770.jpnprd01.prod.outlook.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
 <TY1PR01MB177032BB126E89F93C43558EC0C50@TY1PR01MB1770.jpnprd01.prod.outlook.com>
In-Reply-To: <TY1PR01MB177032BB126E89F93C43558EC0C50@TY1PR01MB1770.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fabrizio.castro@bp.renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;TY1PR01MB1641;20:u+cfqJpiTZGlDKBI82sFVGLaSBhNtPPy/gyo9/FcaOIHja8tW/fUdBlgIR7KQCTmjG9bvo3skA/VPypQKqOLBfaa93BlK/hRtqsMIpRbPbKhLb6pZllOd5ILIfR7wa6PK6VVfREyznWOoiuej87VteXxircR7399WoPlXLzCIFc=
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-ms-office365-filtering-correlation-id: d5d5579b-e76e-4d8d-df7d-08d67fc444ab
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:TY1PR01MB1641;
x-ms-traffictypediagnostic: TY1PR01MB1641:
x-microsoft-antispam-prvs: <TY1PR01MB164101F1E83EC6D68259792AC09F0@TY1PR01MB1641.jpnprd01.prod.outlook.com>
x-forefront-prvs: 0924C6A0D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(136003)(366004)(396003)(346002)(376002)(189003)(199004)(476003)(186003)(4326008)(11346002)(2906002)(446003)(44832011)(106356001)(14454004)(105586002)(486006)(76176011)(3846002)(6116002)(53936002)(316002)(25786009)(6916009)(229853002)(8676002)(33656002)(68736007)(54906003)(9686003)(7696005)(55016002)(102836004)(6436002)(6246003)(97736004)(53546011)(6506007)(26005)(305945005)(8936002)(81166006)(99286004)(7736002)(71190400001)(71200400001)(14444005)(86362001)(256004)(74316002)(66066001)(81156014)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:TY1PR01MB1641;H:TY1PR01MB1770.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ec7EsGGH7bbz+bveseUsll1pok9TCEUzFaV01AXgQcNTIKL5himtvZdLQV7rTiep8pT9zcbHsZNJNzJ5g2usOvex4LVDo8iEcNjEy0/+UfhHNMvQ2xXnDoHwyrfu+I4JeYmcd44aU3g6pXmkN5Je8UYQrZXSJAcj1+kBbI4Adyv/1wzQUS15WEc6UFe2OgHef271zxFoSnF3s9Yj783tL3iPcHzbyWDBPdEMS4lziIuvK65UE/N8PBBGiX7hmEXLj+x0DRk34CL4lUMEe7zF9VofSCbtvWAyPgzRLEw4ualX9y8FYZjdyGUzhKfmczCHyOaMaLtgfY3+W2jN0Gh9SX/vTsfaROK+zN5dO4VQztb4FFKbXs4OtYWnxThEaJHuZTCvL1SXi8jqVFerCYhh7ZSka4qLdXcq1hwR7+awWfI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d5579b-e76e-4d8d-df7d-08d67fc444ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2019 17:17:05.9644
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
> Sent: 08 November 2018 14:19
> Subject: RE: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774=
a1 support
>
> Hello Mauro,
>
> Does this patch look ok to you?
>
> Thanks,
> Fab
>
> > From: Biju Das <biju.das@bp.renesas.com>
> > Sent: 10 September 2018 15:31
> > Subject: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1=
 support
> >
> > Document RZ/G2M (R8A774A1) SoC bindings.
> >
> > The RZ/G2M SoC is similar to R-Car M3-W (R8A7796).
> >
> > Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> > Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> > ---
> >  Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 5 +++-=
-
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.=
txt
> > b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> > index 2d385b6..12fe685 100644
> > --- a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> > +++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> > @@ -2,12 +2,13 @@ Renesas R-Car MIPI CSI-2
> >  ------------------------
> >
> >  The R-Car CSI-2 receiver device provides MIPI CSI-2 capabilities for t=
he
> > -Renesas R-Car family of devices. It is used in conjunction with the
> > -R-Car VIN module, which provides the video capture capabilities.
> > +Renesas R-Car Gen3 and RZ/G2 family of devices. It is used in conjunct=
ion
> > +with the R-Car VIN module, which provides the video capture capabiliti=
es.
> >
> >  Mandatory properties
> >  --------------------
> >   - compatible: Must be one or more of the following
> > +   - "renesas,r8a774a1-csi2" for the R8A774A1 device.
> >     - "renesas,r8a7795-csi2" for the R8A7795 device.
> >     - "renesas,r8a7796-csi2" for the R8A7796 device.
> >     - "renesas,r8a77965-csi2" for the R8A77965 device.
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
