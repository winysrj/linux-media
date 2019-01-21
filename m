Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16ABEC31681
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 17:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0F842085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 17:19:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=renesasgroup.onmicrosoft.com header.i=@renesasgroup.onmicrosoft.com header.b="OjFwEBcc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfAURTH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 12:19:07 -0500
Received: from mail-eopbgr1410095.outbound.protection.outlook.com ([40.107.141.95]:46539
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725879AbfAURTG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 12:19:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector1-bp-renesas-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q9L9ltc0Ypq1KCFQRtfVrCfTozDck0qbjK2IEiEJJhk=;
 b=OjFwEBccVHsIpbAxKXYz/1XufGBcADCVrvo8t9Tp7IFMgdI+WDg6gGo8Iz9EaIZTDqWRs3HeuEF62CQma4+pQBzmnhGIrm1hAu/8D/1cmZuAhh/N/54ljemzqcOGlOzPJ0gC2TeqEwMKRTIWq1+d9uLJTWfEru+R4HD7AoesuMM=
Received: from TY1PR01MB1770.jpnprd01.prod.outlook.com (52.133.163.147) by
 TY1PR01MB1641.jpnprd01.prod.outlook.com (52.133.162.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.27; Mon, 21 Jan 2019 17:19:02 +0000
Received: from TY1PR01MB1770.jpnprd01.prod.outlook.com
 ([fe80::4a9:6014:ec1d:1122]) by TY1PR01MB1770.jpnprd01.prod.outlook.com
 ([fe80::4a9:6014:ec1d:1122%5]) with mapi id 15.20.1537.031; Mon, 21 Jan 2019
 17:19:02 +0000
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
        Biju Das <biju.das@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: RE: [PATCH 3/5] media: dt-bindings: media: rcar_vin: Add r8a774a1
 support
Thread-Topic: [PATCH 3/5] media: dt-bindings: media: rcar_vin: Add r8a774a1
 support
Thread-Index: AQHUSRPq/4lGUFIRpkiCYJguyRsXvqVGS5AQgHR88uA=
Date:   Mon, 21 Jan 2019 17:19:02 +0000
Message-ID: <TY1PR01MB1770D20B930232D643AF25D5C09F0@TY1PR01MB1770.jpnprd01.prod.outlook.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-4-git-send-email-biju.das@bp.renesas.com>
 <TY1PR01MB1770D5713E00E0DB8A3060A5C0C50@TY1PR01MB1770.jpnprd01.prod.outlook.com>
In-Reply-To: <TY1PR01MB1770D5713E00E0DB8A3060A5C0C50@TY1PR01MB1770.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fabrizio.castro@bp.renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;TY1PR01MB1641;20:58odVizSJl8nxQQ/BBvLm5VV4QhaFf+OBlzo7Qk4R74iOeUKuZlI4fWBR3h6mevweSU8jfLUnzzGtl5m4zNUfq5FkddM67VHC9xPPbBYMNRXA0BKsNW1L+A1hWZscktkzco5eVgG0R5Y68Q/x8gDfu2vpucu5VpGzsSGeMfSDWw=
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-ms-office365-filtering-correlation-id: dff49088-0cb3-439b-823e-08d67fc48a21
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:TY1PR01MB1641;
x-ms-traffictypediagnostic: TY1PR01MB1641:
x-microsoft-antispam-prvs: <TY1PR01MB1641AB8297198E337AE49846C09F0@TY1PR01MB1641.jpnprd01.prod.outlook.com>
x-forefront-prvs: 0924C6A0D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(136003)(366004)(396003)(346002)(376002)(189003)(199004)(476003)(186003)(4326008)(11346002)(2906002)(446003)(44832011)(106356001)(14454004)(105586002)(486006)(76176011)(3846002)(6116002)(53936002)(316002)(25786009)(6916009)(229853002)(8676002)(33656002)(68736007)(54906003)(9686003)(7696005)(55016002)(102836004)(6436002)(6246003)(97736004)(53546011)(6506007)(26005)(305945005)(8936002)(81166006)(99286004)(7736002)(71190400001)(71200400001)(14444005)(86362001)(256004)(74316002)(66066001)(81156014)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:TY1PR01MB1641;H:TY1PR01MB1770.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P+Nd9zjyz3xamCVx/UxILvz6r03VQWbYlxKk3nwFiLq48BOlcaqQXFh0In2AkihwPMAIe3uS1SvshDgyVSw037MNBp91JVynXAt7ebnSfBHu349sxwUFvYGVJ8nut1GPNlVw/UBXZNpKdnFr4S9SL2IUSbjMmGEqjk5e6ZYtiiKKSl5qby1YKC4a7L9LzbGfCw4SpaEENQti81lHep7skf25jtZG8218v2cmIEf2x4OYMWzhX1qCRqu59fZg/qgfY9CgCP7+fBJUsXdXT9LZtKsC9YjqzA/aMHKD8xyvq9r6uxOWO7LIRdC0yHzDNT8KDnNOsg3NNPsG+zUrAMjllYm5pAbEUYJsDjJj9JTsVnAKIXWc/RgEbwFY/ZoTnJfBk8lmv9zrLwo9vBZ6a3/rfzKTZPIVe997qLWF2MiPf0c=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dff49088-0cb3-439b-823e-08d67fc48a21
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2019 17:19:02.5542
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

> From: Fabrizio Castro
> Sent: 08 November 2018 14:26
> Subject: RE: [PATCH 3/5] media: dt-bindings: media: rcar_vin: Add r8a774a=
1 support
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
> > Subject: [PATCH 3/5] media: dt-bindings: media: rcar_vin: Add r8a774a1 =
support
> >
> > Document RZ/G2M (R8A774A1) SoC bindings.
> >
> > The RZ/G2M SoC is similar to R-Car M3-W (R8A7796).
> >
> > Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> > Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> > ---
> >  Documentation/devicetree/bindings/media/rcar_vin.txt | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Doc=
umentation/devicetree/bindings/media/rcar_vin.txt
> > index 2f42005..8c81689 100644
> > --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> > +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> > @@ -12,6 +12,7 @@ on Gen3 platforms to a CSI-2 receiver.
> >   - compatible: Must be one or more of the following
> >     - "renesas,vin-r8a7743" for the R8A7743 device
> >     - "renesas,vin-r8a7745" for the R8A7745 device
> > +   - "renesas,vin-r8a774a1" for the R8A774A1 device
> >     - "renesas,vin-r8a7778" for the R8A7778 device
> >     - "renesas,vin-r8a7779" for the R8A7779 device
> >     - "renesas,vin-r8a7790" for the R8A7790 device
> > @@ -58,9 +59,9 @@ The per-board settings Gen2 platforms:
> >      - data-enable-active: polarity of CLKENB signal, see [1] for
> >        description. Default is active high.
> >
> > -The per-board settings Gen3 platforms:
> > +The per-board settings Gen3 and RZ/G2 platforms:
> >
> > -Gen3 platforms can support both a single connected parallel input sour=
ce
> > +Gen3 and RZ/G2 platforms can support both a single connected parallel =
input source
> >  from external SoC pins (port@0) and/or multiple parallel input sources
> >  from local SoC CSI-2 receivers (port@1) depending on SoC.
> >
> > --
> > 2.7.4




Renesas Electronics Europe Ltd, Dukes Meadow, Millboard Road, Bourne End, B=
uckinghamshire, SL8 5FH, UK. Registered in England & Wales under Registered=
 No. 04586709.
