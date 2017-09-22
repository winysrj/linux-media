Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:50061 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdIVGuQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 02:50:16 -0400
Date: Fri, 22 Sep 2017 08:50:15 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 00/11] drm/sun4i: add CEC support
Message-ID: <20170922065015.krhspvz4ofqpxwbb@flea.lan>
References: <20170711063044.29849-1-hverkuil@xs4all.nl>
 <20170711203917.gcpod5gcsy6zbkyx@flea>
 <33287848-2050-e36a-05a4-f27487358d5e@xs4all.nl>
 <20170718162914.3zok2ll3ee2mwlte@flea>
 <f2bdbe80-f001-d12f-153d-f5afc3ce8fbc@xs4all.nl>
 <20170921203759.ggti5ucsbm26plqi@flea>
 <a3dca81e-1c35-b685-c8ad-85ac00cecc8d@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dif5lavpf5i3rjy7"
Content-Disposition: inline
In-Reply-To: <a3dca81e-1c35-b685-c8ad-85ac00cecc8d@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--dif5lavpf5i3rjy7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 21, 2017 at 09:19:43PM +0000, Hans Verkuil wrote:
> On 21/09/17 22:37, Maxime Ripard wrote:
> > Hi Hans,
> >=20
> > On Fri, Sep 08, 2017 at 10:59:44AM +0000, Hans Verkuil wrote:
> >> Hi Maxime,
> >>
> >> On 07/18/17 18:29, Maxime Ripard wrote:
> >>> Hi,
> >>>
> >>> On Tue, Jul 11, 2017 at 11:06:52PM +0200, Hans Verkuil wrote:
> >>>> On 11/07/17 22:39, Maxime Ripard wrote:
> >>>>> On Tue, Jul 11, 2017 at 08:30:33AM +0200, Hans Verkuil wrote:
> >>>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>>>>>
> >>>>>> This patch series adds CEC support for the sun4i HDMI controller.
> >>>>>>
> >>>>>> The CEC hardware support for the A10 is very low-level as it just
> >>>>>> controls the CEC pin. Since I also wanted to support GPIO-based CEC
> >>>>>> hardware most of this patch series is in the CEC framework to
> >>>>>> add a generic low-level CEC pin framework. It is only the final pa=
tch
> >>>>>> that adds the sun4i support.
> >>>>>>
> >>>>>> This patch series first makes some small changes in the CEC framew=
ork
> >>>>>> (patches 1-4) to prepare for this CEC pin support.
> >>>>>>
> >>>>>> Patch 5-7 adds the new API elements and documents it. Patch 6 rewo=
rks
> >>>>>> the CEC core event handling.
> >>>>>>
> >>>>>> Patch 8 adds pin monitoring support (allows userspace to see all
> >>>>>> CEC pin transitions as they happen).
> >>>>>>
> >>>>>> Patch 9 adds the core cec-pin implementation that translates low-l=
evel
> >>>>>> pin transitions into valid CEC messages. Basically this does what =
any
> >>>>>> SoC with a proper CEC hardware implementation does.
> >>>>>>
> >>>>>> Patch 10 documents the cec-pin kAPI (and also the cec-notifier kAPI
> >>>>>> which was missing).
> >>>>>>
> >>>>>> Finally patch 11 adds the actual sun4i_hdmi CEC implementation.
> >>>>>>
> >>>>>> I tested this on my cubieboard. There were no errors at all
> >>>>>> after 126264 calls of 'cec-ctl --give-device-vendor-id' while at t=
he
> >>>>>> same time running a 'make -j4' of the v4l-utils git repository and
> >>>>>> doing a continuous scp to create network traffic.
> >>>>>>
> >>>>>> This patch series is based on top of the mainline kernel as of
> >>>>>> yesterday (so with all the sun4i and cec patches for 4.13 merged).
> >>>>>
> >>>>> For the whole serie:
> >>>>> Reviewed-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >>>>>
> >>>>>> Maxime, patches 1-10 will go through the media subsystem. How do y=
ou
> >>>>>> want to handle the final patch? It can either go through the media
> >>>>>> subsystem as well, or you can sit on it and handle this yourself d=
uring
> >>>>>> the 4.14 merge window. Another option is to separate the Kconfig c=
hange
> >>>>>> into its own patch. That way you can merge the code changes and on=
ly
> >>>>>> have to handle the Kconfig patch as a final change during the merge
> >>>>>> window.
> >>>>>
> >>>>> We'll probably have a number of reworks for 4.14, so it would be
> >>>>> better if I merged it.
> >>>>>
> >>>>> However, I guess if we just switch to a depends on CEC_PIN instead =
of
> >>>>> a select, everything would just work even if we merge your patches =
in
> >>>>> a separate tree, right?
> >>>>
> >>>> This small patch will do it:
> >>>>
> >>>> diff --git a/drivers/gpu/drm/sun4i/Kconfig b/drivers/gpu/drm/sun4i/K=
config
> >>>> index e884d265c0b3..ebad80aefc87 100644
> >>>> --- a/drivers/gpu/drm/sun4i/Kconfig
> >>>> +++ b/drivers/gpu/drm/sun4i/Kconfig
> >>>> @@ -25,7 +25,7 @@ config DRM_SUN4I_HDMI_CEC
> >>>>         bool "Allwinner A10 HDMI CEC Support"
> >>>>         depends on DRM_SUN4I_HDMI
> >>>>         select CEC_CORE
> >>>> -       select CEC_PIN
> >>>> +       depends on CEC_PIN
> >>>>         help
> >>>>  	  Choose this option if you have an Allwinner SoC with an HDMI
> >>>>  	  controller and want to use CEC.
> >>
> >> Just a reminder: now that both this driver and the CEC_PIN code has be=
en
> >> merged in 4.14, this 'depends on' can become a 'select' again.
> >=20
> > Thanks for the reminder.
> >=20
> > Would that commit work for you:
> > http://code.bulix.org/19o9y6-201254
>=20
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> This obviously should be merged for 4.14.

Yep. I just did, thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--dif5lavpf5i3rjy7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZxLKnAAoJEBx+YmzsjxAgoAQP/RQ+UVvbmaqWNQJH2VZZYh+a
3tm7+dX2CZ4tofZfR/73p+eosmnudhqjhD4GLAAeISmDx2gYVHBb9SVcRrq1kf5X
iVERGLVP2Grbm3EYRgKWBF+/sNPiBhnLk5X6N3xUAyrXo8akor5C74W+RSCJWPqH
g1fAMnB15HbCVzkork68VMHFXp8sJ0fLvEkBKWNW7qnG1fXNEFVRRb3JkSd9EpFv
jIFY+0IpyceNOVx9Rp8YyjLt9HAk37wQ4SmJGRVHVLRt70qwrwOYeBFzGjKVgT3l
ZJUhuPFAH/paHvZEraHHdJou1qPxud64SDmYmJsVJ2+3qEhOlmmn5GQHJd2bWLyW
E6yrc40AlxVz2/BUH3pT8rIGhqhqahfJ1enqVN/qjbyIDMxybXnq/DH4JF4uGNUH
YptGaPUbd3mLMRwa4c0QVfZ4tSx0HwvDz2phPIM7MXSO7Hnnady8oU+U23nWwmaa
Jrqe7+BEBqc9CKh6dz1JN5OcMUd0DxzHFBf0DIJj3miGFEPv4ZGz1eL1c2Ok6d1F
zpLHdjAwCW7HpkY7bUkEg0hm18lS14gh1SMrH6UgRIajSAvXk4BdeBd3u4zy+XgA
MZkEPbcTXhxl25Ob60W6ce750QizoT7myXMs1XQbi8ghg/S0oTIAdWUEKxuoAj38
FfeG+weayWfKjNyMoeiL
=luRu
-----END PGP SIGNATURE-----

--dif5lavpf5i3rjy7--
