Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5E6C4360F
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 12:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B8D020851
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 12:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=renesasgroup.onmicrosoft.com header.i=@renesasgroup.onmicrosoft.com header.b="i7fFu7e6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387818AbfCAMOw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 07:14:52 -0500
Received: from mail-eopbgr1410092.outbound.protection.outlook.com ([40.107.141.92]:50528
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbfCAMOv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 07:14:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector1-bp-renesas-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGDCtH2U++OcqFhac6HMQ3V1x3fhOsFLkm+sUCZSoHg=;
 b=i7fFu7e6GYRRYaFsguNb7y1Eg2FNrWxnLfipzUKWNAHq3xbv7TYJBUOexoWor4OU0GTTjF/PsMh1tuHoKTn8VQoJASiZ/UTskGThxke0G2KBs6V41R50Z1BWDJEsXZ6fhofH0McKT1+jENGDYlmk8OHE5/ykSkHI06NJPgNxy98=
Received: from TYXPR01MB1775.jpnprd01.prod.outlook.com (52.133.168.140) by
 TYXPR01MB1871.jpnprd01.prod.outlook.com (52.133.166.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.18; Fri, 1 Mar 2019 12:14:47 +0000
Received: from TYXPR01MB1775.jpnprd01.prod.outlook.com
 ([fe80::88d2:545c:9212:c8cf]) by TYXPR01MB1775.jpnprd01.prod.outlook.com
 ([fe80::88d2:545c:9212:c8cf%5]) with mapi id 15.20.1665.015; Fri, 1 Mar 2019
 12:14:47 +0000
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Biju Das <biju.das@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC:     Biju Das <biju.das@bp.renesas.com>,
        =?iso-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ragnatech.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>
Subject: RE: [PATCH 4/5] media: rcar-vin: Enable support for r8a774a1
Thread-Topic: [PATCH 4/5] media: rcar-vin: Enable support for r8a774a1
Thread-Index: AQHUSRPokRDuBdHgLkGxD5X9AUMCrqX3vh+w
Date:   Fri, 1 Mar 2019 12:14:47 +0000
Message-ID: <TYXPR01MB17757093AE5B9F72A5A93568C0760@TYXPR01MB1775.jpnprd01.prod.outlook.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-5-git-send-email-biju.das@bp.renesas.com>
In-Reply-To: <1536589878-26218-5-git-send-email-biju.das@bp.renesas.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fabrizio.castro@bp.renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b447b70-2a3c-4972-c4fe-08d69e3f7f83
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:TYXPR01MB1871;
x-ms-traffictypediagnostic: TYXPR01MB1871:
x-microsoft-exchange-diagnostics: 1;TYXPR01MB1871;20:KWxahapwNQyU8LMYPY0ezADjdkhtbc83cit6fo8OqGp9Tc5PF2rhVnMElCO81SW8ZGDUsi0bfCPYRBsXHWOS0GaIS63TmMTBJOnw5vho0m/CFNgeySDX+IhBE0Ph+vmjp0KFz41Sn7EO7S3QAOiaWTa7RaJBlyah91KBvhjwCvE=
x-microsoft-antispam-prvs: <TYXPR01MB18712D53BCBA2477AB734F64C0760@TYXPR01MB1871.jpnprd01.prod.outlook.com>
x-forefront-prvs: 09634B1196
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(346002)(39860400002)(396003)(199004)(189003)(55016002)(9686003)(66066001)(8936002)(68736007)(52536013)(186003)(6246003)(54906003)(107886003)(316002)(71200400001)(71190400001)(102836004)(53936002)(86362001)(5660300002)(110136005)(486006)(256004)(11346002)(81166006)(81156014)(53546011)(76176011)(106356001)(8676002)(105586002)(97736004)(14454004)(26005)(25786009)(7696005)(229853002)(99286004)(478600001)(446003)(33656002)(6436002)(2906002)(4326008)(44832011)(305945005)(476003)(6506007)(7736002)(74316002)(6116002)(3846002)(138113003)(98903001);DIR:OUT;SFP:1102;SCL:1;SRVR:TYXPR01MB1871;H:TYXPR01MB1775.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sIkF97KP5R3BF0ZqVGIJmDoNS/iN+pQrCJrKBa8durPwe5hZXbhVkZr8fdoUYsh7bwvAbwtQT+wmb7uSYAlWnOrYs2KPfG9yV32SQI10sS119fXsmLR8wKvN6kEz3+x2zdVdUlrYfWxJsufGGkk3c8ezcGY2l1/g4S4CbUNg1aNy8kpUMWBmNYt2VF0KgqreU1TFH9vt03f0NbduIPXAuAmZpnWkE9WenK4Nft0oPs3EJCYVHd2EhYvhns5jClwtB7gbjlpl6zRD1ASTcc4t/YOyAgwtjIFhdVm1QpskqcmVWRvlnK5jZSV80BFVRptX31jGFWDCeeybUM31rsUl6kLFNaCYO19vGTiYk48sLEVbPhT/2EZXPRuGW92trnEqllRdMAIuyWF5S+YxGOZnHyjbn/Mydb1E00dM5tFXcq4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b447b70-2a3c-4972-c4fe-08d69e3f7f83
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2019 12:14:47.7002
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

> From: Biju Das <biju.das@bp.renesas.com>
> Sent: 10 September 2018 15:31
> Subject: [PATCH 4/5] media: rcar-vin: Enable support for r8a774a1
>=20
> Add the SoC specific information for RZ/G2M(r8a774a1) SoC.
> The VIN module of RZ/G2M is similar to R-Car M3-W.
>=20
> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/=
platform/rcar-vin/rcar-core.c
> index d3072e1..c0c84d1 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -995,6 +995,10 @@ static const struct rvin_info rcar_info_r8a77970 =3D=
 {
>=20
>  static const struct of_device_id rvin_of_id_table[] =3D {
>  	{
> +		.compatible =3D "renesas,vin-r8a774a1",
> +		.data =3D &rcar_info_r8a7796,
> +	},
> +	{
>  		.compatible =3D "renesas,vin-r8a7778",
>  		.data =3D &rcar_info_m1,
>  	},
> --
> 2.7.4

