Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:35768 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751338AbdGRQ3Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 12:29:16 -0400
Date: Tue, 18 Jul 2017 18:29:14 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 00/11] drm/sun4i: add CEC support
Message-ID: <20170718162914.3zok2ll3ee2mwlte@flea>
References: <20170711063044.29849-1-hverkuil@xs4all.nl>
 <20170711203917.gcpod5gcsy6zbkyx@flea>
 <33287848-2050-e36a-05a4-f27487358d5e@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="m4ghusgasvvy4zly"
Content-Disposition: inline
In-Reply-To: <33287848-2050-e36a-05a4-f27487358d5e@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--m4ghusgasvvy4zly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 11, 2017 at 11:06:52PM +0200, Hans Verkuil wrote:
> On 11/07/17 22:39, Maxime Ripard wrote:
> > On Tue, Jul 11, 2017 at 08:30:33AM +0200, Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> This patch series adds CEC support for the sun4i HDMI controller.
> >>
> >> The CEC hardware support for the A10 is very low-level as it just
> >> controls the CEC pin. Since I also wanted to support GPIO-based CEC
> >> hardware most of this patch series is in the CEC framework to
> >> add a generic low-level CEC pin framework. It is only the final patch
> >> that adds the sun4i support.
> >>
> >> This patch series first makes some small changes in the CEC framework
> >> (patches 1-4) to prepare for this CEC pin support.
> >>
> >> Patch 5-7 adds the new API elements and documents it. Patch 6 reworks
> >> the CEC core event handling.
> >>
> >> Patch 8 adds pin monitoring support (allows userspace to see all
> >> CEC pin transitions as they happen).
> >>
> >> Patch 9 adds the core cec-pin implementation that translates low-level
> >> pin transitions into valid CEC messages. Basically this does what any
> >> SoC with a proper CEC hardware implementation does.
> >>
> >> Patch 10 documents the cec-pin kAPI (and also the cec-notifier kAPI
> >> which was missing).
> >>
> >> Finally patch 11 adds the actual sun4i_hdmi CEC implementation.
> >>
> >> I tested this on my cubieboard. There were no errors at all
> >> after 126264 calls of 'cec-ctl --give-device-vendor-id' while at the
> >> same time running a 'make -j4' of the v4l-utils git repository and
> >> doing a continuous scp to create network traffic.
> >>
> >> This patch series is based on top of the mainline kernel as of
> >> yesterday (so with all the sun4i and cec patches for 4.13 merged).
> >=20
> > For the whole serie:
> > Reviewed-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >=20
> >> Maxime, patches 1-10 will go through the media subsystem. How do you
> >> want to handle the final patch? It can either go through the media
> >> subsystem as well, or you can sit on it and handle this yourself during
> >> the 4.14 merge window. Another option is to separate the Kconfig change
> >> into its own patch. That way you can merge the code changes and only
> >> have to handle the Kconfig patch as a final change during the merge
> >> window.
> >=20
> > We'll probably have a number of reworks for 4.14, so it would be
> > better if I merged it.
> >=20
> > However, I guess if we just switch to a depends on CEC_PIN instead of
> > a select, everything would just work even if we merge your patches in
> > a separate tree, right?
>=20
> This small patch will do it:
>=20
> diff --git a/drivers/gpu/drm/sun4i/Kconfig b/drivers/gpu/drm/sun4i/Kconfig
> index e884d265c0b3..ebad80aefc87 100644
> --- a/drivers/gpu/drm/sun4i/Kconfig
> +++ b/drivers/gpu/drm/sun4i/Kconfig
> @@ -25,7 +25,7 @@ config DRM_SUN4I_HDMI_CEC
>         bool "Allwinner A10 HDMI CEC Support"
>         depends on DRM_SUN4I_HDMI
>         select CEC_CORE
> -       select CEC_PIN
> +       depends on CEC_PIN
>         help
>  	  Choose this option if you have an Allwinner SoC with an HDMI
>  	  controller and want to use CEC.
> diff --git a/drivers/gpu/drm/sun4i/sun4i_hdmi.h b/drivers/gpu/drm/sun4i/s=
un4i_hdmi.h
> index 8263de225b36..82bc6923b90f 100644
> --- a/drivers/gpu/drm/sun4i/sun4i_hdmi.h
> +++ b/drivers/gpu/drm/sun4i/sun4i_hdmi.h
> @@ -15,7 +15,7 @@
>  #include <drm/drm_connector.h>
>  #include <drm/drm_encoder.h>
>=20
> -#include <media/cec-pin.h>
> +#include <media/cec.h>
>=20
>  #define SUN4I_HDMI_CTRL_REG		0x004
>  #define SUN4I_HDMI_CTRL_ENABLE			BIT(31)
>=20
>=20
> Unfortunately you need to change the header as well since cec-pin.h doesn=
't
> exist without the cec patches. It might be better to
>=20
> And once the cec patch series and the sun4i_hdmi patch is merged the patc=
h above
> can be applied with -R and all will work fine.
>=20
> This seems a sensible way forward.

I just tested this serie, it works just fine. I've applied the patch
11 with my Tested-by and that small patch above.

Thanks a lot!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--m4ghusgasvvy4zly
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZbjdaAAoJEBx+YmzsjxAgMzQP/R99Sm2cvj8nVwwzNgq51k//
t08R/y7Pl/GWvGpuI7a80JnFwAvPhOLIntpnXiHUbKGbeJw/uJIb6sp8G6hmedJX
gjGmuJMHwn1jr4wEiuVNThrZEcCNLM75hrGdExeEbNujD9FGm80eGrgI8123rqBe
8Xwn/uMVdu6vBH+rCet39ZO+kFBFcuG5uTFdgd1XClsjnHCAEhIBBaw5JdfBaf7Y
N5bIgxzwJP5hzl3+6YjnGu3NrDam9VoQ7JaeaGiVpqDipi0RDo0aRtcFNDzcO0/e
BUssqv3YEleAasgCH5I7Zpb7xYNjItUMlcDS1lUoGShz8iQGlLXyEgGJBXo/Q3Wy
UH17wwz7hOkugXnz/oPPIGbKR5v2yG5bzzxDBgegtY2whXRkIifqIAwnvyt+GU+Q
OpoR/v0HS03Uhu1PnJ3yYXldoCqFTCxxOWIjrH8dZ6gy4j3yNaBPoWs155MXHwnf
8mDC1sikJqDUW8GniEg5Ml1LpcdtGQ6SJNERmDt+u7cHnMmpZMbt1JvoQMMH0pA8
VrF0d5M8oq5fXj8iEDGtGX76HALl5ogKYjf26DCTs7zW+LdSCsRLWYgyS5rXksS4
pRWNNk43m5a6fCottyhZpTkNfbvKig1GKcKMJL5YoCUMlx/7vnhosjbKFA2IQqaN
PvHKM2ePFNk2BhZHRAII
=u/6l
-----END PGP SIGNATURE-----

--m4ghusgasvvy4zly--
