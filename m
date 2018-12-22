Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E15D7C43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 19:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8BF821939
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 19:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404201AbeLVT3i (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 14:29:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37863 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730700AbeLVT3i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 14:29:38 -0500
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 24B7880A5F; Sat, 22 Dec 2018 20:29:31 +0100 (CET)
Date:   Sat, 22 Dec 2018 20:29:34 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sebastian Reichel <sre@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-bluetooth@vger.kernel.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: Re: [PATCH 10/14] media: wl128x-radio: simplify
 fmc_prepare/fmc_release
Message-ID: <20181222192934.GA15237@amd>
References: <20181221011752.25627-1-sre@kernel.org>
 <20181221011752.25627-11-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20181221011752.25627-11-sre@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2018-12-21 02:17:48, Sebastian Reichel wrote:
> From: Sebastian Reichel <sebastian.reichel@collabora.com>
>=20
> Remove unused return code from fmc_prepare() and fmc_release() to
> simplify the code a bit.


>  /*
>   * This function will be called from FM V4L2 release function.
>   * Unregister from ST driver.
>   */
> -int fmc_release(struct fmdev *fmdev)
> +void fmc_release(struct fmdev *fmdev)
>  {
>  	static struct st_proto_s fm_st_proto;
>  	int ret;
> =20
>  	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
>  		fmdbg("FM Core is already down\n");
> -		return 0;
> +		return;
>  	}
>  	/* Service pending read */
>  	wake_up_interruptible(&fmdev->rx.rds.read_queue);
> @@ -1611,7 +1606,6 @@ int fmc_release(struct fmdev *fmdev)
>  		fmdbg("Successfully unregistered from ST\n");
> =20
>  	clear_bit(FM_CORE_READY, &fmdev->flag);
> -	return ret;
>  }


You probably leave unused variable (ret) here. I guess that's okay as
you remove it later in the series...?

Also... I'd kind of expect _prepare routine to return int. Even if it
currently does not do anything that could return error, I'd kind of
expect allocations being done there...

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlwekJ4ACgkQMOfwapXb+vKjZwCgo0T/gvVxIQhBqehwM3Lusxjf
evMAoIxFUWAOaEjLi73wgK/IdM6sKuam
=0wrD
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
