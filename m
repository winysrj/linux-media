Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:37295 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932516AbeAJPhg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 10:37:36 -0500
Date: Wed, 10 Jan 2018 16:37:24 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hugues FRUCHET <hugues.fruchet@st.com>,
        Yong Deng <yong.deng@magewell.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v5 0/5] Add OV5640 parallel interface and RGB565/YUYV
 support
Message-ID: <20180110153724.l77zpdgxfbzkznuf@flea>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
 <20180108153811.5xrvbaekm6nxtoa6@flea>
 <3010811e-ed37-4489-6a9f-6cc835f41575@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yy36qmxeqrgaten3"
Content-Disposition: inline
In-Reply-To: <3010811e-ed37-4489-6a9f-6cc835f41575@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yy36qmxeqrgaten3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hugues,

On Mon, Jan 08, 2018 at 05:13:39PM +0000, Hugues FRUCHET wrote:
> I'm using a ST board with OV5640 wired in parallel bus output in order=20
> to interface to my STM32 DCMI parallel interface.
> Perhaps could you describe your setup so I could help on understanding=20
> the problem on your side. From my past experience with this sensor=20
> module, you can first check hsync/vsync polarities, the datasheet is=20
> buggy on VSYNC polarity as documented in patch 4/5.

It turns out that it was indeed a polarity issue.

It looks like that in order to operate properly, I need to setup the
opposite polarity on HSYNC and VSYNC on the interface. I looked at the
signals under a scope, and VSYNC is obviously inversed as you
described. HSYNC, I'm not so sure since the HBLANK period seems very
long, almost a line.

Since VSYNC at least looks correct, I'd be inclined to think that the
polarity is inversed on at least the SoC I'm using it on.

Yong, did you test the V3S CSI driver with a parallel interface? With
what sensor driver? Have you found some polarities issues like this?

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--yy36qmxeqrgaten3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpWMyQACgkQ0rTAlCFN
r3R+WQ/+PpWKwzSUt4jRJ8W/ScArU4/gCpyJ90zzHEpU5YibSFD+Etb6WdYIwqoq
l4AIotyMvFEfpMxHV5xEJhOEO8wPiU52YwzhKbcnL4spKJPA4/x7OBxczGkgqZ04
N0UcCoc//jFHggsO9gwLSE+gOXMS3hUdj4ty6zu6qbP1DKPSte9VEezr9haPy8/Y
QHUGPUWRA4wVEvNfDbz46xg6GUfBcjxm/FwdMRpyH73FXlPL9dvc1HvL9Z6Tauf0
6+YSE8g6VM2JV8jhSYp3tmAcrrXOOa/jVApoXgvyivChqUHCLECVAKEaGGktnFgF
YVKKYFnf0FhyOVxcu5ydyKZYMzZgEXXPHTiQ2ZnI5qnT19zDx+0qT3JpIYia1ua3
5FQFSc2dQ0V9RnLEpT5CFaoQhElJjPOdAf1Bm+fdOYT0BbBgUo8zNhwQO5DE1u7t
PJ+cISh8Cm/EwwtWeEk+vHf/+UURVhIM4L9TZ5ayHy5GQQv2T+RG5U35b9f/p08s
RwkJlSToH8tO3f6e3XpFBBqBvVDwWHzYiI6Ad2GCjXW7aI1Q7Qlb71rJX9kp+z7S
JNVvlw0AVGKDGOUMoapqEXaniFkhQ0ipWSE7tylHI2zrcSDu142fcLJ4nSb/yaW4
XDcJ6Jj4Ulq8lRGNGV679JmRMcublqIZlUq2/9I2xWWorRW34Kc=
=6cVj
-----END PGP SIGNATURE-----

--yy36qmxeqrgaten3--
