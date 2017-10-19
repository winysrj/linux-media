Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:56192 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751933AbdJSJjO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 05:39:14 -0400
Date: Thu, 19 Oct 2017 11:39:10 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCHv4 0/4] tegra-cec: add Tegra HDMI CEC support
Message-ID: <20171019093910.GH9005@ulmo>
References: <20170911122952.33980-1-hverkuil@xs4all.nl>
 <20171019092054.GC9005@ulmo>
 <0f43276f-0a89-8caa-6522-253458e3ad08@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jHkwA2TBA/ec6v+"
Content-Disposition: inline
In-Reply-To: <0f43276f-0a89-8caa-6522-253458e3ad08@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9jHkwA2TBA/ec6v+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 19, 2017 at 11:36:14AM +0200, Hans Verkuil wrote:
> On 10/19/17 11:20, Thierry Reding wrote:
> > On Mon, Sep 11, 2017 at 02:29:48PM +0200, Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> This patch series adds support for the Tegra CEC functionality.
> >>
> >> This v4 has been rebased to the latest 4.14 pre-rc1 mainline.
> >>
> >> Please review! Other than for the bindings that are now Acked I have n=
ot
> >> received any feedback.
> >>
> >> The first patch documents the CEC bindings, the second adds support
> >> for this to tegra124.dtsi and enables it for the Jetson TK1.
> >>
> >> The third patch adds the CEC driver itself and the final patch adds
> >> the cec notifier support to the drm/tegra driver in order to notify
> >> the CEC driver whenever the physical address changes.
> >>
> >> I expect that the dts changes apply as well to the Tegra X1/X2 and pos=
sibly
> >> other Tegra SoCs, but I can only test this with my Jetson TK1 board.
> >>
> >> The dt-bindings and the tegra-cec driver would go in through the media
> >> subsystem, the drm/tegra part through the drm subsystem and the dts
> >> changes through (I guess) the linux-tegra developers. Luckily they are
> >> all independent of one another.
> >>
> >> To test this you need the CEC utilities from git://linuxtv.org/v4l-uti=
ls.git.
> >>
> >> To build this:
> >>
> >> git clone git://linuxtv.org/v4l-utils.git
> >> cd v4l-utils
> >> ./bootstrap.sh; ./configure
> >> make
> >> sudo make install # optional, you really only need utils/cec*
> >>
> >> To test:
> >>
> >> cec-ctl --playback # configure as playback device
> >> cec-ctl -S # detect all connected CEC devices
> >=20
> > I finally got around to test this. Unfortunately I wasn't able to
> > properly show connected CEC devices, but I think that may just be
> > because the monitor I was testing against doesn't support CEC. I
> > will have to check against a different device eventually to check
> > that it properly enumerates, though I suspect you've already done
> > quite extensive testing yourself.
>=20
> Yes, you need a TV with CEC. Most (all?) PC monitors do not support this.
> I never understood why not.
>=20
> So just to confirm: you've merged this driver for 4.15?

I've applied the drm/tegra bits to drm/tegra/for-next and pulled the ARM
DT changes into the Tegra tree for v4.15. I think we had agreed that you
would take the DT bindings and CEC driver through your tree?

Thierry

--9jHkwA2TBA/ec6v+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlnocr4ACgkQ3SOs138+
s6F4jRAAqhFfIv/KiO7VYFtGDT7Vl2LkY6hgkIdEFFa39GEVT+VzKg5ttI8ge1bC
SLsfq41XZurW1TxZzJSec27Jm2ZnpSt0wLhD39BA5SzwQiRFyaOOumVFCfZEHskr
xIuCT3rbzCwgLpbgSGAYY1A0I3isDQ40hh2S6wi1wce8aJcrE7xPAvTS+B/7017b
daZ9M7bs4GMViMrVA6AQSyt6m2AOIlAv8/PZ07OceqP3C9egKACzrWebnHhN1PI5
giQAA9L6h0NzFUgju97DH71RH4xyBTXm2Ph0BMfwgBhYXwGD8967EmMqXa16Jb/I
7cLjfsNwt2v8vfQD5rAsteyZ1O2BInOHZh2jEQmYztYqKnBL63+hs6+JjgFAA+nC
gGNhqTVYlNiGDYfV4BffjYTPf/ruBC8gx9XDzzFsw1PDX3tLp6mEV+HdPYJ+t6wD
ifNGfYQ4l1Qwx2t18xNvpTpNGmRtUv5pF0nZ9X6EVILkBU2YmJXJYNRiwceDW6Yq
zTIKoE3aF5DrrVGqtWFp4JnFb0aXyVid+z0hczxElMqdsL4rxtdSHmylom4Nk2kn
SGXtJ7UhJc4tMwcY4Pml8LyonHjNICSqE2C/RjYNsFNevhxIkrXRECPVQCMBKVxb
42EaF34iWfHrPdg3To84wIYTPp4EFzgCmPePnVOWwQCLguHEL7g=
=MqOJ
-----END PGP SIGNATURE-----

--9jHkwA2TBA/ec6v+--
