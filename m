Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:56364 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592AbaDIMV4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 08:21:56 -0400
Received: by mail-bk0-f49.google.com with SMTP id my13so2224989bkb.36
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 05:21:55 -0700 (PDT)
Date: Wed, 9 Apr 2014 14:21:01 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Denis Carikli <denis@eukrea.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, devel@driverdev.osuosl.org,
	Russell King <linux@arm.linux.org.uk>,
	Eric =?utf-8?Q?B=C3=A9nard?= <eric@eukrea.com>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v12][ 09/12] drm/panel: Add Eukrea mbimxsd51 displays.
Message-ID: <20140409122058.GA20753@ulmo>
References: <1396874691-27954-1-git-send-email-denis@eukrea.com>
 <1396874691-27954-9-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <1396874691-27954-9-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 07, 2014 at 02:44:48PM +0200, Denis Carikli wrote:
[...]
> +static const struct panel_desc eukrea_mbimxsd51_dvisvga = {
> +	.modes = &eukrea_mbimxsd51_dvisvga_mode,
> +	.num_modes = 1,
> +	.size = {
> +		.width = 0,
> +		.height = 0,
> +	},
> +};
[...]
> +static const struct panel_desc eukrea_mbimxsd51_dvivga = {
> +	.modes = &eukrea_mbimxsd51_dvivga_mode,
> +	.num_modes = 1,
> +	.size = {
> +		.width = 0,
> +		.height = 0,
> +	},
> +};

Surely these two panels have a physical size?

Thierry

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTRTsqAAoJEN0jrNd/PrOhP2sP/2iFj56/RMQqJrSFshG9gXmZ
AD5Xu1toD2JlP+ffQdeLK/JLNXY7xYzjwnfB/SsL8E1i3pdPpphqonkPD2PXem6z
VxmnLe1Q2SreP+N/2IWpYpLp7O0Yb+9A1Ai7xNWzdpYsozJYsI//l0sU5bf9QY3a
pznSK6g4+mvDw4S4inbnUHW1IfsZ29otPopJDsDjmIAne4faIXok3pjX7VFc8wkp
/toNWf0Xp4r8V1yJKop9H1UQMtaszAnQ9Q+gCSi/M+9LtH8y0KrV+Kp8wKatlcUk
wim2CCEhGNdCX+6R/ea9/G2GiQYJEkYTdSQNvamt1OoOFXldC8GlVSqZ1JyGx3bH
0tIMcewOcjactNeYmyWvd8QlTHPrnOMoqrBq0mSQA1NhhQzQp1EliytbYefWuDby
waZLI/3BoeoTWj7cDEAqkC8Wvz/mct9pNhLz318qu1SBs7iIvWzO8oNXAMoajf8I
2NU401q6x14rYASVpjy0sppXtetYYQi9ibhG9Z1HDT7wbnWFLl3PQQdz0R60lAGs
lSLIxIEuVdQsP8p1FVCooRE2M3yYYO8lQb0G2IqLTxORzUB8V/LL4sIsAG+Wjjbp
yXtERHJnoUN44pxkf3c57868EXosY7rB/5qE8eMRM5d6cVyJUHetDl4O7U9GAdXL
1B74PRvu/B7tGww+Js2m
=dY21
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
