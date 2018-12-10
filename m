Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEFCC04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 17:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C6AB2081F
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 17:50:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nZTsNvdn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C6AB2081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbeLJRut (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 12:50:49 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:56112 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbeLJRus (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 12:50:48 -0500
Received: by mail-it1-f193.google.com with SMTP id o19so18621947itg.5
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 09:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=35kntMjXIZDAJdcjTu4qrAxInxdYQ9hco7YUtpblGAo=;
        b=nZTsNvdnUI923JudGwYViOuBYyE9A66lHShjAspqzztBNaMStygvafylqylCcmR5Jr
         owmFhwC3lWeNP3fjZppE4nahNNbD6iZq9lt0Sp7A3sYQnFuXgPIk1vJPsWdq0f8ymzCu
         5mFduDw4JRFLQfdWAc8uU/r0OzJge7Nlvzb9tbGUyl3J6tGF0hcE0CDBE6zJ2uy9cJT7
         Q5zCLpIF2GtrQi7wbslW7S9iJPtbCNOuuZ/C3TwIF5Azsu3iMRK/7PuQU0JcgjiTEUAk
         Dpr70O4NLmYJHuE7UJ6SrXWzKjgU1xN40CZ4d1Ni67gPmLqt6HWZ2aBgCgGRQqqr93+x
         HK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=35kntMjXIZDAJdcjTu4qrAxInxdYQ9hco7YUtpblGAo=;
        b=unYRvyBnhtG20oS04OStb5+UbplpgLErc0vdT+ym8CNgoz5fxmcTXEoxDN/Tw1g8jk
         uvyP94A1uf8Fe10cgudUuHE2W1knqWlWIkHzqTHB2uCFgey64RdCVWSUOkVkQH53mh0i
         rRli5Mfph1TDSaif5HILhN/7RH9Ouk5ZN4z4/aZCb2xJ/mBTsmAW/zrduJD5RSXij8ai
         dbb2Fvcryrw+b+BzDBeeLWwR4Pq3ungIxDj7qrMPhOLhYNxqYm26ehjtzYsDbvNqtI+W
         d3kyqoz7vZPK1pBJvQEvzZJZMFdB8qYieUH7yaOTZQ9/7V6ymgUANOYz6WLEUfvp4s/y
         quDw==
X-Gm-Message-State: AA+aEWaQ/EjBL+1SI86U97KvA+dwAIRh2Z87YSg1w/BAibuqIxj3Iee8
        VVPQPhMihaTLoK+0aElHdJo=
X-Google-Smtp-Source: AFSGD/WrCFIX2wOgq7ZojNceBBGGgiyArm9ymZSbSzSuu5AhMk4EtWFQ2IlnKgRroyw9/qKlvtS9Bg==
X-Received: by 2002:a24:4606:: with SMTP id j6mr10285043itb.10.1544464247251;
        Mon, 10 Dec 2018 09:50:47 -0800 (PST)
Received: from eggsbenedict.adamsnet (24-220-35-37-dynamic.midco.net. [24.220.35.37])
        by smtp.gmail.com with ESMTPSA id h140sm6802129itb.23.2018.12.10.09.50.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Dec 2018 09:50:46 -0800 (PST)
Date:   Mon, 10 Dec 2018 12:50:44 -0500
From:   Adam Stylinski <kungfujesus06@gmail.com>
To:     "French, Nicholas A." <naf@ou.edu>
Cc:     linux-media@vger.kernel.org
Subject: Re: [PATCH] media: lgdt330x: fix lock status reporting
Message-ID: <20181210175044.GA30987@eggsbenedict.adamsnet>
References: <20181209071054.GA14422@tivo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20181209071054.GA14422@tivo>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 09, 2018 at 07:11:18AM +0000, French, Nicholas A. wrote:
> A typo in code cleanup commit db9c1007bc07 ("media: lgdt330x: do
> some cleanups at status logic") broke the FE_HAS_LOCK reporting
> for 3303 chips by inadvertently modifying the register mask.
>=20
> The broken lock status is critial as it prevents video capture
> cards from reporting signal strength, scanning for channels,
> and capturing video.
>=20
> Fix regression by reverting mask change.
>=20
> Signed-off-by: Nick French <naf@ou.edu>
> ---
>  drivers/media/dvb-frontends/lgdt330x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-f=
rontends/lgdt330x.c
> index 96807e134886..8abb1a510a81 100644
> --- a/drivers/media/dvb-frontends/lgdt330x.c
> +++ b/drivers/media/dvb-frontends/lgdt330x.c
> @@ -783,7 +783,7 @@ static int lgdt3303_read_status(struct dvb_frontend *=
fe,
> =20
>  		if ((buf[0] & 0x02) =3D=3D 0x00)
>  			*status |=3D FE_HAS_SYNC;
> -		if ((buf[0] & 0xfd) =3D=3D 0x01)
> +		if ((buf[0] & 0x01) =3D=3D 0x01)
>  			*status |=3D FE_HAS_VITERBI | FE_HAS_LOCK;
>  		break;
>  	default:
> --=20
> 2.19.2
>=20

Patch worked for me.

Tested-by: Adam Stylinski <kungfujesus06@gmail.com>

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEDgVoSkwBBLuwA/n/PqxEcTpO+acFAlwOp3IACgkQPqxEcTpO
+afMrxAA0Pv36WRnyz34a0PM8LZfO2WegGT0gQfVbLL9EKystd75YoAJVqfaeLmn
HZayOwWTP9faPsHfjxiTUSalSNBtfB8ngLaD4WpkmqWObOlvj2IaQtnxMpxr0mGW
YDNBNQAhKcxQyZyL2CElh03kUj5RxssjYlQPjTNj52C+wVbWzHbLSLFiVWu4Tf+i
ay4HCStaTnhu5rIrQCTh+XuiJReL4rNPxqavoUY2FR3xwDPlfoxWcERaOJiHTm60
RuoSPQe6PXvCug0hl35RzmYwBz4HzZ7+F0rmPKjTmIYW2wz97xMCdqGlHWlg9tv7
/F8kguu1zf3meiaM9HIGW5Hqt83b7q5VEmVOYh4FO2f1bwIwqSvKs+4BR6z8nQ5b
ISYpoanpLG+7un+3i75Xb6NT+PbpMokWb6eglnnA5EbGd3UszSpcUv1pJKD100vQ
/AF3sl+vcHbEn4ID9ollp3U2tBQlcLh2XoJWZ0Z2QflI9J/pjDLRFLWwdraw2Ddi
CpYDUPAQ+punLW904+VcUOgXSW67XAgRRLtvBv7FwZc342YuZzS4k91LcNZpeA3y
Ur0UCQgZtm7+JE71ySobWPMj8UMhGJyefqOW/4Ych+TVsA5epku49TLJEfMQRE5m
w8MvZdDlSAuD2zPyTl/il6eDJ4r4CcwXpzYLw3B9uIZZrzXv3Ws=
=h3Dz
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
