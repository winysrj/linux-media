Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:48332 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753741AbdJNNeO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Oct 2017 09:34:14 -0400
Date: Sat, 14 Oct 2017 15:34:10 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCHv4 0/4] tegra-cec: add Tegra HDMI CEC support
Message-ID: <20171014133410.GA13205@ulmo>
References: <20170911122952.33980-1-hverkuil@xs4all.nl>
 <9314614a-446d-b76d-640b-033cc74e3879@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <9314614a-446d-b76d-640b-033cc74e3879@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 14, 2017 at 02:08:31PM +0200, Hans Verkuil wrote:
> Hi Thierry,
>=20
> On 09/11/2017 02:29 PM, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> >=20
> > This patch series adds support for the Tegra CEC functionality.
> >=20
> > This v4 has been rebased to the latest 4.14 pre-rc1 mainline.
> >=20
> > Please review! Other than for the bindings that are now Acked I have not
> > received any feedback.
>=20
> Can you or someone else from the Tegra maintainers review this?
>=20
> I have not heard anything about this patch series, nor of the previous
> versions of this series. What's the hold-up?

Sorry about that. I've been meaning to look at this for a while now, but
never got around to it. From a quick glance this looks good. Let me take
this for a quick test-drive when I'm back at the office next week and
I'll report back.

Is there any particular ordering that we need to observe in order to
merge this? Looks to me like it would be safe to merge patches 1 and 3
through the CEC (media?) tree and take the others through DRM and Tegra
separately without breaking anything.

Thierry

> > The first patch documents the CEC bindings, the second adds support
> > for this to tegra124.dtsi and enables it for the Jetson TK1.
> >=20
> > The third patch adds the CEC driver itself and the final patch adds
> > the cec notifier support to the drm/tegra driver in order to notify
> > the CEC driver whenever the physical address changes.
> >=20
> > I expect that the dts changes apply as well to the Tegra X1/X2 and poss=
ibly
> > other Tegra SoCs, but I can only test this with my Jetson TK1 board.
> >=20
> > The dt-bindings and the tegra-cec driver would go in through the media
> > subsystem, the drm/tegra part through the drm subsystem and the dts
> > changes through (I guess) the linux-tegra developers. Luckily they are
> > all independent of one another.
> >=20
> > To test this you need the CEC utilities from git://linuxtv.org/v4l-util=
s.git.
> >=20
> > To build this:
> >=20
> > git clone git://linuxtv.org/v4l-utils.git
> > cd v4l-utils
> > ./bootstrap.sh; ./configure
> > make
> > sudo make install # optional, you really only need utils/cec*
> >=20
> > To test:
> >=20
> > cec-ctl --playback # configure as playback device
> > cec-ctl -S # detect all connected CEC devices
> >=20
> > See here for the public CEC API:
> >=20
> > https://hverkuil.home.xs4all.nl/spec/uapi/cec/cec-api.html
> >=20
> > Regards,
> >=20
> > 	Hans
> >=20
> > Changes since v3:
> >=20
> > - Use the new CEC_CAP_DEFAULTS define
> > - Use IS_ERR(cec->adap) instead of IS_ERR_OR_NULL(cec->adap)
> >   (cec_allocate_adapter never returns a NULL pointer)
> > - Drop the device_init_wakeup: wakeup is not (yet) supported by
> >   the CEC framework and I have never tested it.
> >=20
> > Hans Verkuil (4):
> >   dt-bindings: document the tegra CEC bindings
> >   ARM: tegra: add CEC support to tegra124.dtsi
> >   tegra-cec: add Tegra HDMI CEC driver
> >   drm/tegra: add cec-notifier support
> >=20
> >  .../devicetree/bindings/media/tegra-cec.txt        |  27 ++
> >  MAINTAINERS                                        |   8 +
> >  arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   4 +
> >  arch/arm/boot/dts/tegra124.dtsi                    |  12 +-
> >  drivers/gpu/drm/tegra/Kconfig                      |   1 +
> >  drivers/gpu/drm/tegra/drm.h                        |   3 +
> >  drivers/gpu/drm/tegra/hdmi.c                       |   9 +
> >  drivers/gpu/drm/tegra/output.c                     |   6 +
> >  drivers/media/platform/Kconfig                     |  11 +
> >  drivers/media/platform/Makefile                    |   2 +
> >  drivers/media/platform/tegra-cec/Makefile          |   1 +
> >  drivers/media/platform/tegra-cec/tegra_cec.c       | 501 +++++++++++++=
++++++++
> >  drivers/media/platform/tegra-cec/tegra_cec.h       | 127 ++++++
> >  13 files changed, 711 insertions(+), 1 deletion(-)
> >  create mode 100644 Documentation/devicetree/bindings/media/tegra-cec.t=
xt
> >  create mode 100644 drivers/media/platform/tegra-cec/Makefile
> >  create mode 100644 drivers/media/platform/tegra-cec/tegra_cec.c
> >  create mode 100644 drivers/media/platform/tegra-cec/tegra_cec.h
> >=20
>=20

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlniElIACgkQ3SOs138+
s6F6dhAAq1Lgh+s9MXcqzjD3KBI9713BD0n+g8+biXveQ6q1cFrEojiPc6UW9GpA
VLEaT1T6bTi2p5tzD8TnWnxdXFi5tHLpnKX/t0YGcsXA1eebM2ZY4JcPARlZx9pr
n16c6NwhGCHDaJwtVquE1TNd8u22Qz03xyEJrZZiXVAX9eQliHz6Qs8XE1AJItq6
Pu/aT/v/P5KUvYMJsuUqxREVu2SCKWdX/+Hv6Ye9TEH6a7/9HCNW6/flCsonUFtC
GHQnMhr1g3A0U29iM58q3s1+sUaFPRq3GfB7RXq7bEEGgnvS3YyWhzlZd16EJwX4
TlcNJ/xJsTHo0HD3vAvTHJJwyOS7FCKYXbjI8AwWALXNJBJVcM51ojrnE37cf6Wb
Hcavac286WktvU3C4NJUKTdLy7WVwu5TqeUYSW2QsqlCuM27SJl18ZqHQCOQbEDL
Z09jVcUnzmvQqa3iIbjW2F1nC1Zjo/UEUGSBOMlGFsMjqYCVGtfmZl4r/ucNlGFx
XgCUhvTReuGF0bPiJKRfbFo4edyT7Ko9LABqTY9fn4unfxDhM2UcbEJlSFK3EiA+
9KB6LYd3owCJ98l/IbStlj9NOQ+Or0qCjOgAzbFni6kaKo52dLVmqKzaNFo2r9CQ
kTNlNZtasZrdxELbmXq6X0sHl7iKMLwl9XBSTgaHgNbagfnV0a8=
=fJV+
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
