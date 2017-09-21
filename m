Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:35775 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbdIUUiB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 16:38:01 -0400
Date: Thu, 21 Sep 2017 22:37:59 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 00/11] drm/sun4i: add CEC support
Message-ID: <20170921203759.ggti5ucsbm26plqi@flea>
References: <20170711063044.29849-1-hverkuil@xs4all.nl>
 <20170711203917.gcpod5gcsy6zbkyx@flea>
 <33287848-2050-e36a-05a4-f27487358d5e@xs4all.nl>
 <20170718162914.3zok2ll3ee2mwlte@flea>
 <f2bdbe80-f001-d12f-153d-f5afc3ce8fbc@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dhrxjkhrrksrcedw"
Content-Disposition: inline
In-Reply-To: <f2bdbe80-f001-d12f-153d-f5afc3ce8fbc@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--dhrxjkhrrksrcedw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Fri, Sep 08, 2017 at 10:59:44AM +0000, Hans Verkuil wrote:
> Hi Maxime,
>=20
> On 07/18/17 18:29, Maxime Ripard wrote:
> > Hi,
> >=20
> > On Tue, Jul 11, 2017 at 11:06:52PM +0200, Hans Verkuil wrote:
> >> On 11/07/17 22:39, Maxime Ripard wrote:
> >>> On Tue, Jul 11, 2017 at 08:30:33AM +0200, Hans Verkuil wrote:
> >>>> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>>>
> >>>> This patch series adds CEC support for the sun4i HDMI controller.
> >>>>
> >>>> The CEC hardware support for the A10 is very low-level as it just
> >>>> controls the CEC pin. Since I also wanted to support GPIO-based CEC
> >>>> hardware most of this patch series is in the CEC framework to
> >>>> add a generic low-level CEC pin framework. It is only the final patch
> >>>> that adds the sun4i support.
> >>>>
> >>>> This patch series first makes some small changes in the CEC framework
> >>>> (patches 1-4) to prepare for this CEC pin support.
> >>>>
> >>>> Patch 5-7 adds the new API elements and documents it. Patch 6 reworks
> >>>> the CEC core event handling.
> >>>>
> >>>> Patch 8 adds pin monitoring support (allows userspace to see all
> >>>> CEC pin transitions as they happen).
> >>>>
> >>>> Patch 9 adds the core cec-pin implementation that translates low-lev=
el
> >>>> pin transitions into valid CEC messages. Basically this does what any
> >>>> SoC with a proper CEC hardware implementation does.
> >>>>
> >>>> Patch 10 documents the cec-pin kAPI (and also the cec-notifier kAPI
> >>>> which was missing).
> >>>>
> >>>> Finally patch 11 adds the actual sun4i_hdmi CEC implementation.
> >>>>
> >>>> I tested this on my cubieboard. There were no errors at all
> >>>> after 126264 calls of 'cec-ctl --give-device-vendor-id' while at the
> >>>> same time running a 'make -j4' of the v4l-utils git repository and
> >>>> doing a continuous scp to create network traffic.
> >>>>
> >>>> This patch series is based on top of the mainline kernel as of
> >>>> yesterday (so with all the sun4i and cec patches for 4.13 merged).
> >>>
> >>> For the whole serie:
> >>> Reviewed-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >>>
> >>>> Maxime, patches 1-10 will go through the media subsystem. How do you
> >>>> want to handle the final patch? It can either go through the media
> >>>> subsystem as well, or you can sit on it and handle this yourself dur=
ing
> >>>> the 4.14 merge window. Another option is to separate the Kconfig cha=
nge
> >>>> into its own patch. That way you can merge the code changes and only
> >>>> have to handle the Kconfig patch as a final change during the merge
> >>>> window.
> >>>
> >>> We'll probably have a number of reworks for 4.14, so it would be
> >>> better if I merged it.
> >>>
> >>> However, I guess if we just switch to a depends on CEC_PIN instead of
> >>> a select, everything would just work even if we merge your patches in
> >>> a separate tree, right?
> >>
> >> This small patch will do it:
> >>
> >> diff --git a/drivers/gpu/drm/sun4i/Kconfig b/drivers/gpu/drm/sun4i/Kco=
nfig
> >> index e884d265c0b3..ebad80aefc87 100644
> >> --- a/drivers/gpu/drm/sun4i/Kconfig
> >> +++ b/drivers/gpu/drm/sun4i/Kconfig
> >> @@ -25,7 +25,7 @@ config DRM_SUN4I_HDMI_CEC
> >>         bool "Allwinner A10 HDMI CEC Support"
> >>         depends on DRM_SUN4I_HDMI
> >>         select CEC_CORE
> >> -       select CEC_PIN
> >> +       depends on CEC_PIN
> >>         help
> >>  	  Choose this option if you have an Allwinner SoC with an HDMI
> >>  	  controller and want to use CEC.
>=20
> Just a reminder: now that both this driver and the CEC_PIN code has been
> merged in 4.14, this 'depends on' can become a 'select' again.

Thanks for the reminder.

Would that commit work for you:
http://code.bulix.org/19o9y6-201254

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--dhrxjkhrrksrcedw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZxCMnAAoJEBx+YmzsjxAgUMIQAIU+ULTEGh+BxbVJMKSR2tYK
6dQ0tpDE6LaJqR5xgn3Siaxyd7QWugpcw8U3O8N+oWcCT7oohVGJvMwXRuKKPP32
gymcnjyD0V9PYUrWpUpCEF9EOiCV0kSga6pT4QghNd6KWpf52huqH1WbjGm2geW2
ZWXBzzIa7+Qhanca5T2MoCI2xKJSc1MMxdqSsBk+MkE+ZMD4S2UAPn1DdcHpT1Ve
2Lm6C0wW2si8sxDmmqatf6YxSa3rqMnW5mq2QAhTY53wdi8zRL2NyJv7xtVQg/S7
CC8LQN2LggUe4Ao3pSKxrn8oCJrIQVXEOI8UTWQbrZ0Qzq6HuCtLw7HPJ6hZlWVo
Iso/nGY25CtZTA7BEGH2aDTKx/zGDfzucBDzTaAhS1tbxj9OALnqydos86LyVdqO
8LspFL23sUc/HQ2koRvOFu04RlhQWl88YagYxqrmJkhKA+oAzB9AmO0Sjn4hxsP3
xgivXCuB0kkjPjKDm0kQ6+dtRyYAqv15CCbiFFShbB45LK5N+C1GP1+pUqCEdOyW
AKeOrKOwVKhJEPaVO/s/sNCIVrzRLm3dri+DUIMQ1Nj9kBJ83Kkuo1XIsUoux/CT
s+R8AOK502ysR57ykQUCI2mN2MI1dC1BDFzykqXJSL3kAbwxgVzgnguagl+swPFc
EGftN95qFlL/L+CF9uRb
=2qmz
-----END PGP SIGNATURE-----

--dhrxjkhrrksrcedw--
