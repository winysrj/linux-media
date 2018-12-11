Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2795CC5CFFE
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E05A320811
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:39:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UayxCGXj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E05A320811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbeLKJjY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 04:39:24 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34755 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbeLKJjY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 04:39:24 -0500
Received: by mail-ed1-f65.google.com with SMTP id b3so11960792ede.1;
        Tue, 11 Dec 2018 01:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=thWT28Vg6RcuDnmgcnIJ8hAFmM6xHSY5tRvJ572kfQw=;
        b=UayxCGXjiUqpOdmU6Y/2qOoAJe2cCrPjqdM8W+2K7VGmRilM+3yPZiendyK9gbRGFc
         iXZaL9hjWoGPKVH1V3xVw6Sxuv2TER+OcTH9s3l02WC14Q3J9Qb7nqEubXJst8XbnEWq
         AE2dE2aX6FcaCxNMdrwjAS2J0tDBDDxnoZN7ayaAZuHc9+2JKwxkiUgNe8nZ5kXbRFCM
         I6titE5Vo2aCUB1GUgqnWKfgd9r0fQ7wLWM4FkEYtgQC5ihuuxx8cUgwpJ1BudS/yNNE
         ttQqgBZCEWr0M+o+CrT21Zh4LnNYO4pEw+DffSeHAsNfoRKmUtiln5CSvnO5P+2jr8S9
         IB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=thWT28Vg6RcuDnmgcnIJ8hAFmM6xHSY5tRvJ572kfQw=;
        b=ZJnAZ+PvtYWyIXCuSVlwRmyS42btSuIJNO6WGZKIvMv5E3DqPPaCJMi8KDtp6LaaUG
         8UMWdLd7vPCnldm8jCXnvCTllqmIn3Dxjg1xoYvI+IgLPKKR5qssNPerxDxR/UfC+CJA
         Lk23RbgyvUoiua0Tp+qeoWG8gpHeaSkJBIHXQffYWZzGixvNOIj6Hh8SVm4dqd5P5r/z
         KQd19+ttUe+yLetHe6u5JyYUIkiDf/W5SXOGnSl8D0YyGctE4mR1BLLdNY0LmWTP+jLa
         6BPhiPzz9EVzuASslz/Brpoalg26LGefvTwpOy8D2D808Uu/bfJO+JdbeFEuGrjEZHhn
         tcBw==
X-Gm-Message-State: AA+aEWbwZ8d6cwewEzEmQR5jmMF01n86KYmhkGqnKp+KGJpdHEQQcOVT
        eHLH7hsckqEbn9zUssUQd+IXw1Bx
X-Google-Smtp-Source: AFSGD/UIfwcmN9X4UxHDfBUq8JQFSCZhX9cRwuqG+B1A84rUM2gdvvsAdDYJ+2EzWWJTejrt1O/yNg==
X-Received: by 2002:a17:906:c288:: with SMTP id r8-v6mr12121962ejz.9.1544521161085;
        Tue, 11 Dec 2018 01:39:21 -0800 (PST)
Received: from localhost (pD9E51040.dip0.t-ipconnect.de. [217.229.16.64])
        by smtp.gmail.com with ESMTPSA id n10sm4030289edq.33.2018.12.11.01.39.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Dec 2018 01:39:20 -0800 (PST)
Date:   Tue, 11 Dec 2018 10:39:19 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] media: tegra-cec: Support Tegra186 and Tegra194
Message-ID: <20181211093919.GB14426@ulmo>
References: <20181210160038.16122-1-thierry.reding@gmail.com>
 <13d8fdb8-fc0e-9ad5-6405-110dd37ca5d5@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <13d8fdb8-fc0e-9ad5-6405-110dd37ca5d5@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 11, 2018 at 10:26:14AM +0100, Hans Verkuil wrote:
> On 12/10/18 5:00 PM, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > The CEC controller found on Tegra186 and Tegra194 is the same as on
> > earlier generations.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/media/platform/tegra-cec/tegra_cec.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >=20
> > diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/med=
ia/platform/tegra-cec/tegra_cec.c
> > index aba488cd0e64..8a1e10d008d0 100644
> > --- a/drivers/media/platform/tegra-cec/tegra_cec.c
> > +++ b/drivers/media/platform/tegra-cec/tegra_cec.c
> > @@ -472,6 +472,8 @@ static const struct of_device_id tegra_cec_of_match=
[] =3D {
> >  	{ .compatible =3D "nvidia,tegra114-cec", },
> >  	{ .compatible =3D "nvidia,tegra124-cec", },
> >  	{ .compatible =3D "nvidia,tegra210-cec", },
> > +	{ .compatible =3D "nvidia,tegra186-cec", },
> > +	{ .compatible =3D "nvidia,tegra194-cec", },
> >  	{},
> >  };
> > =20
> >=20
>=20
> Applying: media: tegra-cec: Support Tegra186 and Tegra194
> WARNING: DT compatible string "nvidia,tegra186-cec" appears un-documented=
 -- check ./Documentation/devicetree/bindings/
> #9: FILE: drivers/media/platform/tegra-cec/tegra_cec.c:475:
> +       { .compatible =3D "nvidia,tegra186-cec", },
>=20
> WARNING: DT compatible string "nvidia,tegra194-cec" appears un-documented=
 -- check ./Documentation/devicetree/bindings/
> #10: FILE: drivers/media/platform/tegra-cec/tegra_cec.c:476:
> +       { .compatible =3D "nvidia,tegra194-cec", },

Ugh... I usually have a git hook in place to catch this kind of mistake,
but it's currently disabled because it was getting in the way of some
large rebases I've been doing lately...

> I need an additional patch adding the new bindings to
> Documentation/devicetree/bindings/media/tegra-cec.txt.

Will send a patch right away.

Thanks,
Thierry

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlwPhccACgkQ3SOs138+
s6FZ0BAAtM9wgdQOGtY9Dlb6zHFlRQr8mrq/8rYmjL8On3KPKmWJyxs4wZGtsSoK
f/RGog2WyosZk/rP1bcuEoT8ItkhvYeITeZCwaf7etqyZK3bdWTEVGfVNuijHUgy
7L25kfDBGRF3XZ2k+d5qmFg1xtOsj4MTtl9+UPMGEcrTjIn6YSdbQVTrPWn9aOvz
faq2FysJqAMGs/oPBLOypfHUoTtXvkdQ/MVrSZG/ECZaxg8s1kU4SZuCKj6IQa6/
04eGmB4i2C3N3UeKNaKb+pDevW7aVVYC+aFQPRvFfEJ1JltqOahLijl9KpA7moRd
HmJUNRo/yZVrcQQJl6cGhwlogD5y47Qql3PmPYR+/OYUAtJTPJmqXCjYmgsY050f
JiiMfDFaUn9X1+B5J0sy3ZjrW5ZhwsMnWWc+6YmWxmbkV7YBz/NRjsmTupbnGnQ7
vqyLV9X5Z6Y17ae7AS9eXb6vWLaxiEzsSvvaSMXaHRXjdpIB+p7bGAX9QCryOMsJ
78yFv1gB6OaZfOwqBEHK34a4reePrCKhlOCSYzq9ZTYZ62AErNrVy0dwIwUO9fB3
lGYW1Wcm4CwxDRF7BtiGnY3nIbqas3JcWOh0YKreiRRTTSRDyxIa+wqD8sZDvN1E
+jtn18jgplPS4UJmXxuEa1K/4xBxebu43qR7L1gLTqVXa4/cu/o=
=znl3
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
