Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423EEC10F02
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 10:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10B0F217D7
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 10:52:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fpond.eu header.i=@fpond.eu header.b="YwIKSDqn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbfBRKwt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 05:52:49 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:29723 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbfBRKwt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 05:52:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1550487164;
        s=strato-dkim-0002; d=fpond.eu;
        h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=AZbivXQdBnZq9S7vf/wVtEyh4Ns7m12fv5ZdDskGhiU=;
        b=YwIKSDqnNmklPgpwBhSHeOHQcmcXnMURE4xqT/cYb/0aYCwDZFdv2GNkISoCLbnMd0
        KU/zE61YqRDuI+G8O+j4uR3rGja9UxarjLegUNcl1tZ7lgT856/weNd1OwIuF3UE2sXo
        DiQNDsViDLF1HbMxGVcSYu1zy8CmlSxg+5K/zI6y44wKBkDl4XEuenWSTvOPH44KgnkW
        LO2kGfVwtsY+8jJssRgg5aBONJpKF+xLnJSS/qi61CR9oP4ZTrZFKWJE3IZpJ11L/EHo
        4mPaXcjXD6q8/7TtiNnWufUisPdvEgtNHKvVRK8cW6bnf3vEiX7kClShU6rODpXY0FL2
        5xmg==
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzmt2bYDnKIKaws6YXTsc4="
X-RZG-CLASS-ID: mo00
Received: from oxapp01-03.back.ox.d0m.de
        by smtp-ox.front (RZmta 44.9 AUTH)
        with ESMTPSA id V028b8v1IAqiQ4H
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Mon, 18 Feb 2019 11:52:44 +0100 (CET)
Date:   Mon, 18 Feb 2019 11:52:44 +0100 (CET)
From:   Ulrich Hecht <uli@fpond.eu>
To:     =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org
Message-ID: <1661834718.515092.1550487164857@webmail.strato.com>
In-Reply-To: <20190218100313.14529-4-niklas.soderlund+renesas@ragnatech.se>
References: <20190218100313.14529-1-niklas.soderlund+renesas@ragnatech.se>
 <20190218100313.14529-4-niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH 3/3] rcar-csi2: Move setting of Field Detection Control
 Register
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
> Latest datasheet (rev 1.50) clarifies that the FLD register should be
> set after LINKCNT.
>=20
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/=
platform/rcar-vin/rcar-csi2.c
> index 50486301c21b4bae..f90b380478775015 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -545,7 +545,6 @@ static int rcsi2_start_receiver(struct rcar_csi2 *pri=
v)
>  =09rcsi2_write(priv, PHTC_REG, 0);
> =20
>  =09/* Configure */
> -=09rcsi2_write(priv, FLD_REG, fld);
>  =09rcsi2_write(priv, VCDT_REG, vcdt);
>  =09if (vcdt2)
>  =09=09rcsi2_write(priv, VCDT2_REG, vcdt2);
> @@ -576,6 +575,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *pri=
v)
>  =09rcsi2_write(priv, PHYCNT_REG, phycnt);
>  =09rcsi2_write(priv, LINKCNT_REG, LINKCNT_MONITOR_EN |
>  =09=09    LINKCNT_REG_MONI_PACT_EN | LINKCNT_ICLK_NONSTOP);
> +=09rcsi2_write(priv, FLD_REG, fld);
>  =09rcsi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ);
>  =09rcsi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ | PHYCNT_RSTZ=
);

Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>

CU
Uli
