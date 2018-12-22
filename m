Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 008EFC43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 19:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC44A2195D
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 19:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389337AbeLVTKw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 14:10:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37295 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731157AbeLVTKw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 14:10:52 -0500
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 7F5FE80A37; Sat, 22 Dec 2018 20:10:45 +0100 (CET)
Date:   Sat, 22 Dec 2018 20:10:49 +0100
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
Subject: Re: [PATCH 05/14] media: wl128x-radio: remove global
 radio_disconnected
Message-ID: <20181222191049.GA9203@amd>
References: <20181221011752.25627-1-sre@kernel.org>
 <20181221011752.25627-6-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20181221011752.25627-6-sre@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2018-12-21 02:17:43, Sebastian Reichel wrote:
> From: Sebastian Reichel <sebastian.reichel@collabora.com>
>=20
> Move global radio_disconnected into device structure to
> prepare converting this driver into a normal platform
> device driver supporting multiple instances.
>=20
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlwejDkACgkQMOfwapXb+vJBQgCdEsNKIPHRE0ATb/tUDCdeynP0
xp4AoKz8uyM6NcsropZ0eUaYpd48GLD1
=0LUz
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
