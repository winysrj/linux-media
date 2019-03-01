Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F2AC10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 12:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EB4D218AE
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 12:10:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=renesasgroup.onmicrosoft.com header.i=@renesasgroup.onmicrosoft.com header.b="LVBelYcc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387481AbfCAMKB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 07:10:01 -0500
Received: from mail-eopbgr1410104.outbound.protection.outlook.com ([40.107.141.104]:17488
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727952AbfCAMKB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 07:10:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector1-bp-renesas-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUGPZr5K5vqsb+JUgenJJ82PnQTeaQ028pHDBIvkJiU=;
 b=LVBelYccwvIxhQpLwR45qNssUomNgh+h0QeNEyAvkvRCBjtd2dtpZPtNCQt8NXVzW5LWuux5BN1Yd7D68MTGCoV7es1pCcWE8ioMZaxZb12GX5d+42rRdW9P2WsJ6SEGBAXk49r5pDny2A/lAoTwgw52+UakmY29uJidGnuVsu0=
Received: from TYXPR01MB1775.jpnprd01.prod.outlook.com (52.133.168.140) by
 TYXPR01MB1871.jpnprd01.prod.outlook.com (52.133.166.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.18; Fri, 1 Mar 2019 12:09:56 +0000
Received: from TYXPR01MB1775.jpnprd01.prod.outlook.com
 ([fe80::88d2:545c:9212:c8cf]) by TYXPR01MB1775.jpnprd01.prod.outlook.com
 ([fe80::88d2:545c:9212:c8cf%5]) with mapi id 15.20.1665.015; Fri, 1 Mar 2019
 12:09:56 +0000
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
Subject: RE: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
 support
Thread-Topic: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
 support
Thread-Index: AQHUSRPkccN3Ce6NF0WYXZsqMZnzMqX3vODQ
Date:   Fri, 1 Mar 2019 12:09:55 +0000
Message-ID: <TYXPR01MB1775F18270FB477D010C180EC0760@TYXPR01MB1775.jpnprd01.prod.outlook.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
In-Reply-To: <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fabrizio.castro@bp.renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d45e61e9-b4a7-48de-9602-08d69e3ed1a3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:TYXPR01MB1871;
x-ms-traffictypediagnostic: TYXPR01MB1871:
x-microsoft-exchange-diagnostics: 1;TYXPR01MB1871;20:v67NiWY+EMjnnWYKlXoP49aeEWvvoUjTK3IIxnNywkI2rkk70mw01CqEAMwfKySb+PxXsgbL3jNQCKv+x/cHnSRn8q04KiuY9H3sZBdPHFGeucwOeR0+aignFgqwFbU1BQor3iZfcFW/PB8nVtqzBZ2ktEE85zEeRt+T30EgTmw=
x-microsoft-antispam-prvs: <TYXPR01MB1871099E06083B0FABA3FD10C0760@TYXPR01MB1871.jpnprd01.prod.outlook.com>
x-forefront-prvs: 09634B1196
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(346002)(39860400002)(396003)(199004)(189003)(55016002)(9686003)(66066001)(8936002)(68736007)(52536013)(186003)(6246003)(54906003)(316002)(71200400001)(6916009)(71190400001)(102836004)(53936002)(86362001)(5660300002)(486006)(256004)(11346002)(81166006)(81156014)(53546011)(76176011)(106356001)(8676002)(105586002)(97736004)(14454004)(26005)(25786009)(7696005)(229853002)(99286004)(478600001)(446003)(33656002)(6436002)(2906002)(4326008)(44832011)(305945005)(476003)(6506007)(7736002)(74316002)(6116002)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYXPR01MB1871;H:TYXPR01MB1775.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e/bR6szgHRm309Cwi+um4bHH9Sv6/wtGe6pgMDBJ16oo8Ir29k7LU1fmUdoIcpxiEVIts0vqchnXvtFlaC0R/1f24zGhkeEonmcnTMgIVzr+yVixMi+84A/7KsjZEb8xO3enxbMaFstaxinR0tWAkPwEeF2WxyJ8T7XkYbzrbxveKMG1uOI+xzRWyje6WH4JOF4oRlTov3e7XMWpcZ52/Z9pKuNFWp9511/4VT/AWivhx+bTGQvcrKMbxxlIhumrFJyU+CNKcEVL8ecOz4h9htWHbonES+2InMIpH+YC90mBvLsBh7fWpYB+VwC7Dh6t2jMkQffd2QImrClZIz8T3j5/AXU46kr4fqvNJEBBgsfftEUlfuaRqFK5PrOY9N2WIBQ33Aazo389RgqXTLGhKtZNAf9ebTq6T++kYEIxCy0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d45e61e9-b4a7-48de-9602-08d69e3ed1a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2019 12:09:55.9652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYXPR01MB1871
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Mauro,

This patch has been around for some time now, do you think you can take it?

Cheers,
Fab

> From: Biju Das <biju.das@bp.renesas.com>
> Sent: 10 September 2018 15:31
> Subject: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1 s=
upport
>=20
> Document RZ/G2M (R8A774A1) SoC bindings.
>=20
> The RZ/G2M SoC is similar to R-Car M3-W (R8A7796).
>=20
> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.tx=
t
> b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> index 2d385b6..12fe685 100644
> --- a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> +++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> @@ -2,12 +2,13 @@ Renesas R-Car MIPI CSI-2
>  ------------------------
>=20
>  The R-Car CSI-2 receiver device provides MIPI CSI-2 capabilities for the
> -Renesas R-Car family of devices. It is used in conjunction with the
> -R-Car VIN module, which provides the video capture capabilities.
> +Renesas R-Car Gen3 and RZ/G2 family of devices. It is used in conjunctio=
n
> +with the R-Car VIN module, which provides the video capture capabilities=
.
>=20
>  Mandatory properties
>  --------------------
>   - compatible: Must be one or more of the following
> +   - "renesas,r8a774a1-csi2" for the R8A774A1 device.
>     - "renesas,r8a7795-csi2" for the R8A7795 device.
>     - "renesas,r8a7796-csi2" for the R8A7796 device.
>     - "renesas,r8a77965-csi2" for the R8A77965 device.
> --
> 2.7.4

