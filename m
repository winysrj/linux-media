Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:40426 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933616AbeGFQdU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2018 12:33:20 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Ville =?ISO-8859-1?Q?Syrj=E4l=E4?=
        <ville.syrjala@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/2] drm: Add generic colorkey properties for DRM planes
Date: Fri, 06 Jul 2018 19:33:14 +0300
Message-ID: <2513788.CeRymH5ehq@dimapc>
In-Reply-To: <20180706154027.GB17271@n2100.armlinux.org.uk>
References: <20180603220059.17670-1-digetx@gmail.com> <2295190.xHWjP7Ltc3@dimapc> <20180706154027.GB17271@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, 6 July 2018 18:40:27 MSK Russell King - ARM Linux wrote:
> On Fri, Jul 06, 2018 at 05:58:50PM +0300, Dmitry Osipenko wrote:
> > On Friday, 6 July 2018 17:10:10 MSK Ville Syrj=E4l=E4 wrote:
> > > IIRC my earlier idea was to have different colorkey modes for the
> > > min+max and value+mask modes. That way userspace might actually have
> > > some chance of figuring out which bits of state actually do something.
> > > Although for Intel hw I think the general rule is that min+max for YU=
V,
> > > value+mask for RGB, so it's still not 100% clear what to pick if the
> > > plane supports both.
> > >=20
> > > I guess one alternative would be to have min+max only, and the driver
> > > would reject 'min !=3D max' if it only uses a single value?
> >=20
> > You should pick both and reject unsupported property values based on the
> > planes framebuffer format. So it will be possible to set unsupported
> > values
> > while plane is disabled because it doesn't have an associated framebuff=
er
> > and then atomic check will fail to enable plane if property values are
> > invalid for the given format.
>=20
> The colorkey which is attached to a plane 'A' is not applied to plane
> 'A', so the format of plane 'A' is not relevant.  The colorkey is
> applied to some other plane which will be below this plane in terms
> of the plane blending operation.
>=20
> What if you have several planes below plane 'A' with differing
> framebuffer formats - maybe an ARGB8888 plane and a ARGB1555 plane -
> do you decide to limit the colorkey to 8bits per channel, or to
> ARGB1555 format?
>=20
> The answer is, of course, hardware dependent - generic code can't
> know the details of the colorkey implementation, which could be one
> of:
>=20
>   lower plane data -> expand to 8bpc -> match ARGB8888 colorkey
>   lower plane data -> match ARGB8888 reduced to plane compatible colorkey
>=20
> which will give different results depending on the format of the
> lower plane data.

All unsupportable cases should be rejected in the atomic check. If your HW=
=20
can't handle the case where multiple bottom planes have a different format,=
=20
then in the planes atomic check you'll have to walk up all the bottom plane=
s=20
and verify their formats.

I'm not sure whether it's worth to check the planes intersection and fail o=
nly=20
if top plane intersects with multiple bottom planes having different format=
s.=20
Perhaps that could be a driver-specific implementation detail, userspace=20
should take into account that atomic commit may fail on changing planes=20
position.
