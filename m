Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67988C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 20:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD9692075B
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 20:00:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kemnade.info header.i=@kemnade.info header.b="TMAsJODU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfCEUAx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 15:00:53 -0500
Received: from mail.andi.de1.cc ([85.214.239.24]:51048 "EHLO
        h2641619.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbfCEUAx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 15:00:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=kemnade.info; s=20180802; h=Content-Type:MIME-Version:References:
        In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OP3EDO2qdO553U7x+JUql6kn7fCMsy6F/2fEAB0RU4Q=; b=TMAsJODUf0qpfErWSSLGwT2u6
        MrxLrPkoqRy3mKMWXUxnUOaj0b711L3mTHqPOkYdJKnGnlCnf9M+/6dQziz/O9okJEsdup69GdyYJ
        vJAbE4WHLqDHN5MK/gBuA0WZKnJB2z5PDFP61aHJvyhCAdDSJOhWdtOU4AfndzMpMiuW8=;
Received: from p5dcc39b9.dip0.t-ipconnect.de ([93.204.57.185] helo=aktux)
        by h2641619.stratoserver.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <andreas@kemnade.info>)
        id 1h1GF5-0006iE-Ay; Tue, 05 Mar 2019 21:00:47 +0100
Date:   Tue, 5 Mar 2019 21:00:38 +0100
From:   Andreas Kemnade <andreas@kemnade.info>
To:     Jose Alberto Reguero <jareguero@telefonica.net>
Cc:     Linux media <linux-media@vger.kernel.org>,
        Sean Young <sean@mess.org>, Antti Palosaari <crope@iki.fi>,
        jose.alberto.reguero@gmail.com
Subject: Re: [PATCH V3 1/2] init i2c already in it930x_frontend_attach
Message-ID: <20190305210038.02cef35e@aktux>
In-Reply-To: <0DD4D9CA-C76D-4A8E-956C-F064435301CA@telefonica.net>
References: <0DD4D9CA-C76D-4A8E-956C-F064435301CA@telefonica.net>
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/YlT3GrQY+dMv_uwyCFvdGLQ"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

--Sig_/YlT3GrQY+dMv_uwyCFvdGLQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jose,

On Tue, 05 Mar 2019 19:37:25 +0100
Jose Alberto Reguero <jareguero@telefonica.net> wrote:

> i2c bus is already needed when the frontend is probed, so init it already=
 in it930x_frontend_attach.That prevents errors like
> si2168: probe of 6-0067 failed with error -5
>=20
> Andreas, can I have your Signed-off-by?
>=20
ok, it was already there, but again:

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>

>=20
> From: Andreas Kemnade <andreas@kemnade.info>
> Signed-off-by: Jose Alberto Reguero <jose.alberto.reguero@gmail.com>
>=20
> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c linux.new/drivers/m=
edia/usb/dvb-usb-v2/af9035.c
> --- linux/drivers/media/usb/dvb-usb-v2/af9035.c	2018-09-12 07:40:12.00000=
0000 +0200
> +++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2019-02-20 16:45:17.4=
67869437 +0100
> @@ -1218,6 +1218,48 @@ static int it930x_frontend_attach(struct
> =20
>  	dev_dbg(&intf->dev, "adap->id=3D%d\n", adap->id);
> =20
> +	/* I2C master bus 2 clock speed 300k */
> +	ret =3D af9035_wr_reg(d, 0x00f6a7, 0x07);
> +	if (ret < 0)
> +		goto err;
> +
> +	/* I2C master bus 1,3 clock speed 300k */
> +	ret =3D af9035_wr_reg(d, 0x00f103, 0x07);
> +	if (ret < 0)
> +		goto err;
> +
> +	/* set gpio11 low */
> +	ret =3D af9035_wr_reg_mask(d, 0xd8d4, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret =3D af9035_wr_reg_mask(d, 0xd8d5, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret =3D af9035_wr_reg_mask(d, 0xd8d3, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	/* Tuner enable using gpiot2_en, gpiot2_on and gpiot2_o (reset) */
> +	ret =3D af9035_wr_reg_mask(d, 0xd8b8, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret =3D af9035_wr_reg_mask(d, 0xd8b9, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret =3D af9035_wr_reg_mask(d, 0xd8b7, 0x00, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	msleep(200);
> +
> +	ret =3D af9035_wr_reg_mask(d, 0xd8b7, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
>  	memset(&si2168_config, 0, sizeof(si2168_config));
>  	si2168_config.i2c_adapter =3D &adapter;
>  	si2168_config.fe =3D &adap->fe[0];
> @@ -1575,48 +1617,6 @@ static int it930x_tuner_attach(struct dv
> =20
>  	dev_dbg(&intf->dev, "adap->id=3D%d\n", adap->id);
> =20
> -	/* I2C master bus 2 clock speed 300k */
> -	ret =3D af9035_wr_reg(d, 0x00f6a7, 0x07);
> -	if (ret < 0)
> -		goto err;
> -
> -	/* I2C master bus 1,3 clock speed 300k */
> -	ret =3D af9035_wr_reg(d, 0x00f103, 0x07);
> -	if (ret < 0)
> -		goto err;
> -
> -	/* set gpio11 low */
> -	ret =3D af9035_wr_reg_mask(d, 0xd8d4, 0x01, 0x01);
> -	if (ret < 0)
> -		goto err;
> -
> -	ret =3D af9035_wr_reg_mask(d, 0xd8d5, 0x01, 0x01);
> -	if (ret < 0)
> -		goto err;
> -
> -	ret =3D af9035_wr_reg_mask(d, 0xd8d3, 0x01, 0x01);
> -	if (ret < 0)
> -		goto err;
> -
> -	/* Tuner enable using gpiot2_en, gpiot2_on and gpiot2_o (reset) */
> -	ret =3D af9035_wr_reg_mask(d, 0xd8b8, 0x01, 0x01);
> -	if (ret < 0)
> -		goto err;
> -
> -	ret =3D af9035_wr_reg_mask(d, 0xd8b9, 0x01, 0x01);
> -	if (ret < 0)
> -		goto err;
> -
> -	ret =3D af9035_wr_reg_mask(d, 0xd8b7, 0x00, 0x01);
> -	if (ret < 0)
> -		goto err;
> -
> -	msleep(200);
> -
> -	ret =3D af9035_wr_reg_mask(d, 0xd8b7, 0x01, 0x01);
> -	if (ret < 0)
> -		goto err;
> -
>  	memset(&si2157_config, 0, sizeof(si2157_config));
>  	si2157_config.fe =3D adap->fe[0];
>  	si2157_config.if_port =3D 1;
>=20


--Sig_/YlT3GrQY+dMv_uwyCFvdGLQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE7sDbhY5mwNpwYgrAfb1qx03ikyQFAlx+1WYACgkQfb1qx03i
kyTxjw/+MsnXEWIW9+A06VCXm+GYnOJmHk4PpZmbanDWMUEV9TkofCoftbzinyEp
9Ea4wanHOlKmuS4WYlFj3lRuZCUF5wTSc+36pQYWZx78QkJ274xvFLLsyNeSTesX
Ua8Qa2CyLT6neoHLdP8Q0173U0jc4pLRWVrOIrPhNBYE5CIWrtJ1A3aWBDtcZQIc
JZEY1fSgf1Vy4r/+9RdMoObP2ayS8Xmgh29a5UTdGGeibJuaijiipXjf6dNCmMOZ
cHmvriRmrlv/qKQFGO9BnIqbOezNJ/fJxxyoXgGQ7KNPYB4V69D5GDskQ8knpm1s
i9mwfskysIxTSGqyJVe9wSVUSPN74obdneuxOcEuEbGudoZY/4n6Jwimod6zj2/6
H7lA+amyPhIGBsFAvt8dCpKewSzLK0+8c7wBPjwVlMjVt7mybuh1mw9dFFaI03B6
VB4KnZjSFmYreAKDzGSypV8goBlBhY7LekOLoH1885GyiCJLXbzqpy4yIHvmF8ms
tORVo7ZeDczhN/yN3z2aV8VcTBnUvW8vjAW/MLsNPtmf/0Z2WMjwvgEvIi3o4na9
kTyh4GxQAO9r6D1vEYaKGoi0rqHir8b1bcRLMLcOocjM3PS6eKDOuxhDxP1IHEPJ
tDuLbJ6R+xar3LVUhMrlGus5yGsDuyVjw5d8kd90owUdMLjazeo=
=DemM
-----END PGP SIGNATURE-----

--Sig_/YlT3GrQY+dMv_uwyCFvdGLQ--
