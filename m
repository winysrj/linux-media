Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728DDC43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40A772084D
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:28:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=renesasgroup.onmicrosoft.com header.i=@renesasgroup.onmicrosoft.com header.b="w093iJ7+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbfCAN26 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:28:58 -0500
Received: from mail-eopbgr1410090.outbound.protection.outlook.com ([40.107.141.90]:36352
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728243AbfCAN26 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 08:28:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector1-bp-renesas-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zLno7YTVFx3Xgl2ChCj+UVEYZLtAQiMGigHNIPgxJPw=;
 b=w093iJ7+F3jLHJfOcCGyAUZfdtJJKCkwdmxbCSMXXTQlVvdjigmGZW9H744iJJ9rlVkFi9tMMZwdcsc2SEjSnWqWZOTwLDXX0zOlXftssltzCTL3YBiTlZaqPpCQwr9D2oLPWgLvKQ34W4P6oobdqo3oC3sipgg0I89oTuSTT9I=
Received: from OSBPR01MB2103.jpnprd01.prod.outlook.com (52.134.242.17) by
 OSBPR01MB2070.jpnprd01.prod.outlook.com (52.134.240.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.20; Fri, 1 Mar 2019 13:28:55 +0000
Received: from OSBPR01MB2103.jpnprd01.prod.outlook.com
 ([fe80::d5b0:ac4:6d54:6285]) by OSBPR01MB2103.jpnprd01.prod.outlook.com
 ([fe80::d5b0:ac4:6d54:6285%5]) with mapi id 15.20.1643.022; Fri, 1 Mar 2019
 13:28:55 +0000
From:   Biju Das <biju.das@bp.renesas.com>
To:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: FW: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
 support
Thread-Topic: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
 support
Thread-Index: AQHUSRPkl3NtQmcXZ0CHMGvDpVFZWaT0ARcAgQPP6WA=
Date:   Fri, 1 Mar 2019 13:28:55 +0000
Message-ID: <OSBPR01MB21035BEEA8CED012605BEFD4B8760@OSBPR01MB2103.jpnprd01.prod.outlook.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
 <5b9f3f73.1c69fb81.a4966.287a@mx.google.com>
In-Reply-To: <5b9f3f73.1c69fb81.a4966.287a@mx.google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=biju.das@bp.renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a0c2c03-beca-4f9b-8ef7-08d69e49da9c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:OSBPR01MB2070;
x-ms-traffictypediagnostic: OSBPR01MB2070:
x-microsoft-exchange-diagnostics: 1;OSBPR01MB2070;20:F9XFQaz6wST3Y+/K02NhCc+Lnapp7F1wotZ49OIeZ8kDjYzwQ8On8MHNblWXtfArcPvPuCy36Lqp4+kZnAxFsjMsTXY6zkbp0I5+6mcQh2SoP866pqyv5X8Zs9KG1iWKUbtsMSi8Pm2WOsSMQsK8bMahxVLPyoHjYUK/5TGvHnw=
x-microsoft-antispam-prvs: <OSBPR01MB2070E82ABFB9EF9A6EC847F4B8760@OSBPR01MB2070.jpnprd01.prod.outlook.com>
x-forefront-prvs: 09634B1196
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(346002)(396003)(13464003)(199004)(189003)(186003)(6116002)(52536013)(478600001)(26005)(6506007)(53546011)(105586002)(2351001)(256004)(106356001)(76176011)(86362001)(71190400001)(71200400001)(102836004)(3846002)(97736004)(7696005)(25786009)(99286004)(33656002)(66066001)(2501003)(8936002)(74316002)(9686003)(2473003)(305945005)(8676002)(81166006)(68736007)(5640700003)(81156014)(55016002)(6436002)(44832011)(446003)(476003)(11346002)(486006)(14454004)(316002)(5660300002)(6916009)(2906002)(7736002)(53936002)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:OSBPR01MB2070;H:OSBPR01MB2103.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ffg5VXfm+pMU1bfeaRYeKv3gSL1Vl/VqSSHwh1fVwC+zaJaNBcFMD12I61OtCcvSnSkP18VV6klQx62XETZLcaFERpmQb8HwxyuVRnNvU2Es6SqynYwKCO2G1Lex+PsoD4njj3tC0HsYI+4ToYYEFhpgz1ee9NEUnhP3qDQiRyUANl9VklYtDvNyCPQoNBzgQD2D8OPRdW5G+pX9ygEizEp9D8PsNEIsAyNMpJCWoEdvQ75ytNLhLoHJiGgeCv88lNY52x+bis8YTSDUkf4DdJaBL2GT+CV1YIAAOvDFPrWXrFIbUUJgzpRgsugGXPlRXnvMczxBPNDkZkUNcd5iJKCPoTWbYNssrGtsbiUZrkOTa6Wu58+WaHbsPiDjp2inLN4hFkcs5/OQWONSZs6bOXesSKlorSNMwiC8lk4M02I=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0c2c03-beca-4f9b-8ef7-08d69e49da9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2019 13:28:55.6067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2070
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



-----Original Message-----
From: Rob Herring <robh@kernel.org>
Sent: 17 September 2018 06:45
To: Biju Das <biju.das@bp.renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>; Mark Rutland <mark.rutland@=
arm.com>; Biju Das <biju.das@bp.renesas.com>; Niklas S=F6derlund <niklas.so=
derlund@ragnatech.se>; linux-media@vger.kernel.org; linux-renesas-soc@vger.=
kernel.org; devicetree@vger.kernel.org; Simon Horman <horms@verge.net.au>; =
Geert Uytterhoeven <geert+renesas@glider.be>; Chris Paterson <Chris.Paterso=
n2@renesas.com>; Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: Re: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1=
 support

On Mon, 10 Sep 2018 15:31:14 +0100, Biju Das wrote:
> Document RZ/G2M (R8A774A1) SoC bindings.
>
> The RZ/G2M SoC is similar to R-Car M3-W (R8A7796).
>
> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>

Reviewed-by: Rob Herring <robh@kernel.org>



Renesas Electronics Europe GmbH,Geschaeftsfuehrer/President : Michael Hanna=
wald, Sitz der Gesellschaft/Registered office: Duesseldorf, Arcadiastrasse =
10, 40472 Duesseldorf, Germany,Handelsregister/Commercial Register: Duessel=
dorf, HRB 3708 USt-IDNr./Tax identification no.: DE 119353406 WEEE-Reg.-Nr.=
/WEEE reg. no.: DE 14978647
