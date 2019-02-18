Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F439C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 10:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E0212176F
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 10:52:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fpond.eu header.i=@fpond.eu header.b="PHsjkO6F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbfBRKwr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 05:52:47 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.22]:32873 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbfBRKwq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 05:52:46 -0500
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2019 05:52:45 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1550487164;
        s=strato-dkim-0002; d=fpond.eu;
        h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=Dq/VKDUukO6GsLyB7ZEVdcBrDDl1AHkFMWbGQuwqA2M=;
        b=PHsjkO6F5YhjmPlcV3iMlMJvDrwrCtuu903zFkkop9PyYdtVAu9broLoU9eDD/C3tj
        f4YeVJtVv3xopfZDimGjWxyrLZJ2SwBml7mLLiSmULIJZkALPO578fFEdgsBOyB1ginO
        oRplFHRXe19BYo0ZPsb4flosU7tcn/kRn3vK7AHYzYC8VaArg7netHumjjEOAOeVYlr3
        MIJGDymvNyp8nX8+t/3LPwq+JFFWrUXiAP+px+bqTgt/woABeyE7qiTkAZYhTH9jxhVv
        eHRAo+YXNHJzJBrkOtPxt32BVngso3vPzE4bIkNrOMLywFkJqL+p6RDMUyz58ad5p/fE
        Qvbg==
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzmt2bYDnKIKaws6YXTsc4="
X-RZG-CLASS-ID: mo00
Received: from oxapp01-03.back.ox.d0m.de
        by smtp-ox.front (RZmta 44.9 AUTH)
        with ESMTPSA id V028b8v1IAeVPsB
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Mon, 18 Feb 2019 11:40:31 +0100 (CET)
Date:   Mon, 18 Feb 2019 11:40:30 +0100 (CET)
From:   Ulrich Hecht <uli@fpond.eu>
To:     =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org
Message-ID: <1139737677.514003.1550486431036@webmail.strato.com>
In-Reply-To: <20190218100313.14529-2-niklas.soderlund+renesas@ragnatech.se>
References: <20190218100313.14529-1-niklas.soderlund+renesas@ragnatech.se>
 <20190218100313.14529-2-niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH 1/3] rcar-csi2: Update V3M and E3 start procedure
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev50
X-Originating-IP: 188.192.207.28
X-Originating-Client: open-xchange-appsuite
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


> On February 18, 2019 at 11:03 AM Niklas S=C3=B6derlund <niklas.soderlund+=
renesas@ragnatech.se> wrote:
>=20
>=20
> The latest datasheet (rev 1.50) updates the start procedure for V3M and
> E3. Update the driver to match these changes.
>=20
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/=
platform/rcar-vin/rcar-csi2.c
> index 664d3784be2b9db9..fbbe86a7a0fe14ab 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -940,11 +940,11 @@ static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 =
*priv, unsigned int mbps)
>  static int rcsi2_confirm_start_v3m_e3(struct rcar_csi2 *priv)
>  {
>  =09static const struct phtw_value step1[] =3D {
> -=09=09{ .data =3D 0xed, .code =3D 0x34 },
> -=09=09{ .data =3D 0xed, .code =3D 0x44 },
> -=09=09{ .data =3D 0xed, .code =3D 0x54 },
> -=09=09{ .data =3D 0xed, .code =3D 0x84 },
> -=09=09{ .data =3D 0xed, .code =3D 0x94 },
> +=09=09{ .data =3D 0xee, .code =3D 0x34 },
> +=09=09{ .data =3D 0xee, .code =3D 0x44 },
> +=09=09{ .data =3D 0xee, .code =3D 0x54 },
> +=09=09{ .data =3D 0xee, .code =3D 0x84 },
> +=09=09{ .data =3D 0xee, .code =3D 0x94 },
>  =09=09{ /* sentinel */ },
>  =09};

Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>

CU
Uli
