Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6E8C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 12:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 293A520840
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 12:12:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=renesasgroup.onmicrosoft.com header.i=@renesasgroup.onmicrosoft.com header.b="jLm/0gdv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387439AbfCAMM4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 07:12:56 -0500
Received: from mail-eopbgr1410128.outbound.protection.outlook.com ([40.107.141.128]:30439
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbfCAMM4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 07:12:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector1-bp-renesas-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XZzmkh7dhqcekj5Fv/LlvayUfRYzIacTYOk/8+bVZI=;
 b=jLm/0gdvzsxtprjsGK/XlN37gJsMJumnyO/teC4Y3pRJz+jBZiPtwJzz2MzwX5oKu4TeZFGoTTMnTcYHcIdO32PSxBMLc/XTs8W9TYmzYZuRXI/OIdYgH+cfRp3bSXB5cnd3OqaPd1thjribrbAgi9LZpF5j86vggImPm7FMrdw=
Received: from TYXPR01MB1775.jpnprd01.prod.outlook.com (52.133.168.140) by
 TYXPR01MB1871.jpnprd01.prod.outlook.com (52.133.166.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.18; Fri, 1 Mar 2019 12:12:51 +0000
Received: from TYXPR01MB1775.jpnprd01.prod.outlook.com
 ([fe80::88d2:545c:9212:c8cf]) by TYXPR01MB1775.jpnprd01.prod.outlook.com
 ([fe80::88d2:545c:9212:c8cf%5]) with mapi id 15.20.1665.015; Fri, 1 Mar 2019
 12:12:51 +0000
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
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH 3/5] media: dt-bindings: media: rcar_vin: Add r8a774a1
 support
Thread-Topic: [PATCH 3/5] media: dt-bindings: media: rcar_vin: Add r8a774a1
 support
Thread-Index: AQHUSRPq/4lGUFIRpkiCYJguyRsXvqX3vdMg
Date:   Fri, 1 Mar 2019 12:12:51 +0000
Message-ID: <TYXPR01MB17752F6AC01652FE7F65381DC0760@TYXPR01MB1775.jpnprd01.prod.outlook.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-4-git-send-email-biju.das@bp.renesas.com>
In-Reply-To: <1536589878-26218-4-git-send-email-biju.das@bp.renesas.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fabrizio.castro@bp.renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49f8f015-42d1-489b-8e6a-08d69e3f3a50
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:TYXPR01MB1871;
x-ms-traffictypediagnostic: TYXPR01MB1871:
x-microsoft-exchange-diagnostics: 1;TYXPR01MB1871;20:LtfgqjuhOHFzQ0FtrnVUfXEP5xh4ef8POw1JW7wajM8rXlQaS20/ZwceS1x8KPb4yQLfvjc6tgcc91XZ6lFSb+uBG5tYxby5pNwBcdXAs7d2w+PMrbXmuRUjxiOyN1tnMMNiP/MpZMOoi0Ce2sVFzsyV8CsKz1tIMD0PhxkjPPM=
x-microsoft-antispam-prvs: <TYXPR01MB18717AB2817BEEF9FD6CEBDBC0760@TYXPR01MB1871.jpnprd01.prod.outlook.com>
x-forefront-prvs: 09634B1196
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(346002)(39860400002)(396003)(199004)(189003)(55016002)(9686003)(66066001)(8936002)(68736007)(52536013)(186003)(6246003)(54906003)(107886003)(316002)(71200400001)(6916009)(71190400001)(102836004)(53936002)(86362001)(5660300002)(486006)(256004)(11346002)(81166006)(81156014)(53546011)(76176011)(106356001)(8676002)(105586002)(97736004)(14454004)(26005)(25786009)(7696005)(229853002)(99286004)(478600001)(446003)(33656002)(6436002)(2906002)(4326008)(44832011)(305945005)(476003)(6506007)(7736002)(74316002)(6116002)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYXPR01MB1871;H:TYXPR01MB1775.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OaJ36vtID8e2IYmW/+KWb/y02UnradMM+CK4gfjWrcefjk/ELk5U0ESLPv76qTD9fdKfMpIIDHusrwotXrYowmOinEc6UmVwOgJniJZ3/MH+X6pl11lln7FRFkCLyjJPNutW0TBk9wN5tLkoQa/XrrnZ6LpM6dQtWqYWkekoYT73r0/MJfieXy42gg2q6HR/dMYkpTs6CZPhkyiGI+OaAGQjSYL26a3FCNxw6TkqJZWettkiN/yAWq8fepXoxdJCmCBeG908Y+xMluPbdGw3FBrvdrP3tTzUAwlcpUOIAGuIZNx1so/9mFuWf5MCvLJ2tB7iRFo2WLoqg+fxmM43mgFeGlhDtxW3J5eh5FqwZKrcSaIMd+rL8gLZeqEX3nRa4yK3qm0cck9AwSgyf7uY7gC3Opk8gq7Ayyoky72qmg8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f8f015-42d1-489b-8e6a-08d69e3f3a50
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2019 12:12:51.6258
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

This patch has been around for some time, do you think you can take it?

Thanks,
Fab

> From: linux-renesas-soc-owner@vger.kernel.org <linux-renesas-soc-owner@vg=
er.kernel.org> On Behalf Of Biju Das
> Sent: 10 September 2018 15:31
> Subject: [PATCH 3/5] media: dt-bindings: media: rcar_vin: Add r8a774a1 su=
pport
>=20
> Document RZ/G2M (R8A774A1) SoC bindings.
>=20
> The RZ/G2M SoC is similar to R-Car M3-W (R8A7796).
>=20
> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Docum=
entation/devicetree/bindings/media/rcar_vin.txt
> index 2f42005..8c81689 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -12,6 +12,7 @@ on Gen3 platforms to a CSI-2 receiver.
>   - compatible: Must be one or more of the following
>     - "renesas,vin-r8a7743" for the R8A7743 device
>     - "renesas,vin-r8a7745" for the R8A7745 device
> +   - "renesas,vin-r8a774a1" for the R8A774A1 device
>     - "renesas,vin-r8a7778" for the R8A7778 device
>     - "renesas,vin-r8a7779" for the R8A7779 device
>     - "renesas,vin-r8a7790" for the R8A7790 device
> @@ -58,9 +59,9 @@ The per-board settings Gen2 platforms:
>      - data-enable-active: polarity of CLKENB signal, see [1] for
>        description. Default is active high.
>=20
> -The per-board settings Gen3 platforms:
> +The per-board settings Gen3 and RZ/G2 platforms:
>=20
> -Gen3 platforms can support both a single connected parallel input source
> +Gen3 and RZ/G2 platforms can support both a single connected parallel in=
put source
>  from external SoC pins (port@0) and/or multiple parallel input sources
>  from local SoC CSI-2 receivers (port@1) depending on SoC.
>=20
> --
> 2.7.4

