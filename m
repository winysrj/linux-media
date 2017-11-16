Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:38702 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753507AbdKPLCR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 06:02:17 -0500
Date: Thu, 16 Nov 2017 12:02:04 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Giulio Benetti <giulio.benetti@micronovasrl.com>
Cc: Andreas Baierl <list@imkreisrum.de>, linux-sunxi@googlegroups.com,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        thomas@vitsch.nl, linux-media@vger.kernel.org
Subject: Re: [linux-sunxi] Cedrus driver
Message-ID: <20171116110204.poakahqjz4sj7pmu@flea>
References: <1510059543-7064-1-git-send-email-giulio.benetti@micronovasrl.com>
 <1b12fa21-bfe6-9ba7-ae1d-8131ac6f4668@micronovasrl.com>
 <6fcdc0d9-d0f8-785a-bb00-b1b41c684e59@imkreisrum.de>
 <693e8786-af83-9d77-0fd4-50fa1f6a135f@micronovasrl.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zcvj57jrsaryoph5"
Content-Disposition: inline
In-Reply-To: <693e8786-af83-9d77-0fd4-50fa1f6a135f@micronovasrl.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zcvj57jrsaryoph5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I'm not sure why there's so many recipients (Russell, Rob or Mark have
a limited interest in this I assume), and why you're also missing some
key ones (like the v4l2 list).

On Thu, Nov 16, 2017 at 11:37:30AM +0100, Giulio Benetti wrote:
> Il 16/11/2017 11:31, Andreas Baierl ha scritto:
> > Am 16.11.2017 um 11:13 schrieb Giulio Benetti:
> > > Hello,
> > >=20
> > Hello,
> > > I'm wondering why cedrus
> > > https://github.com/FlorentRevest/linux-sunxi-cedrus has never been
> > > merged with linux-sunxi sunxi-next.
> > >=20
> > Because it is not ready to be merged. It depends on the v4l2 request
> > API, which was not merged and which is re-worked atm.
> > Also, sunxi-cedrus itself is not in a finished state and is not as
> > feature-complete to be merged. Anyway it might be something for
> > staging... Has there been a [RFC] on the mailing list at all?
>=20
> Where can I find a list of TODOs to get it ready to be merged?

Assuming that the request API is in, we'd need to:
  - Finish the MPEG4 support
  - Work on more useful codecs (H264 comes to my mind)
  - Implement the DRM planes support for the custom frame format
  - Implement the DRM planes support for scaling
  - Test it on more SoCs

Or something along those lines.

> > > I see it seems to be dead, no commit in 1 year.
> >
> > Yes, because the author did this during an internship, which ended ...
> > Afaik nobody picked up his work yet.

That's not entirely true. Some work has been done by Thomas (in CC),
especially on the display engine side, but last time we talked his
work was not really upstreamable.

We will also resume that effort starting next march.

> > > since we need video acceleration on A20 and A33.
> > >=20
> > ack.
>=20
> By the way, when you answer to google group, is it right that all CC I
> inserted are not inserted too?
> Because this causes mess with mailing lists (seems to me).

Yes, that's one of the many brain-damaged thing happening on that
list...

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--zcvj57jrsaryoph5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJaDXAsAAoJEBx+YmzsjxAg/xMP/i1nxPRvq2+VktZQMoQAe72d
59duVsp/+GuMQ0VQV58+grfb/7jGQCU4HotodDk92/bXQTQIcnZulq35FTiJ9xzy
iA28p2a2ybr6MsUpy7R+/MVireb/LbCKDqWZgSJcIk0wq1Z/2/2N48MYhKrN5r5z
hScu6BfI+dWTQxNnS6x3W83t4B/YhoDpjV/AfOw5LaU05TBpeLIM+Lg8BYMGsQSt
m9q0QNWeR4zeFzvighozlCHmyggo1WKpPYbrqF0ZQ/pHQnWH3lcmeG1AfFxeXvZ9
s1tJcFCJeGZA9LRSJbp0FWWnioQFbFZA4dR9vNsm6H04xWoMWQtXwL6Ku6dQ1dy6
6lW9dLtxFF/hLDCmN9Dm5WtJDhGeQ98xrkiV5X5h9MmAX+qet2rECxGGJQaMlurn
Ew4wDsO5QWlxxmCKsSVkQKcHPvzlREqcFo6eggcNyTM0ZURpnuVarXhe9OYfuv/V
ywNY2uI+rUG2b/JGi8kd3Whte4kGgCOdu2Exo17Rx68KglkT0hAsYtXYmiSinjUU
H0g4w3b00UdMib0lVIGmICGPUzglGrSa8K1zHsbGOxGwvwJRmYZ4GC22NHyquqM3
M9yFfDQzj/raNT32kB4ssYRkssjehnOaHBHuDUeEvxKt6bB24F9Loj/6ye/JYKVl
wq21nhJUgvS/2llt6A4P
=zwho
-----END PGP SIGNATURE-----

--zcvj57jrsaryoph5--
