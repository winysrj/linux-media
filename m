Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:39093 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934654AbeGFTsj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2018 15:48:39 -0400
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
Date: Fri, 06 Jul 2018 22:48:26 +0300
Message-ID: <1862420.zvYl24lURK@dimapc>
In-Reply-To: <20180706170136.GC17271@n2100.armlinux.org.uk>
References: <20180603220059.17670-1-digetx@gmail.com> <2513788.CeRymH5ehq@dimapc> <20180706170136.GC17271@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, 6 July 2018 20:01:36 MSK Russell King - ARM Linux wrote:
> On Fri, Jul 06, 2018 at 07:33:14PM +0300, Dmitry Osipenko wrote:
> > On Friday, 6 July 2018 18:40:27 MSK Russell King - ARM Linux wrote:
> > > On Fri, Jul 06, 2018 at 05:58:50PM +0300, Dmitry Osipenko wrote:
> > > > On Friday, 6 July 2018 17:10:10 MSK Ville Syrj=E4l=E4 wrote:
> > > > > IIRC my earlier idea was to have different colorkey modes for the
> > > > > min+max and value+mask modes. That way userspace might actually h=
ave
> > > > > some chance of figuring out which bits of state actually do
> > > > > something.
> > > > > Although for Intel hw I think the general rule is that min+max for
> > > > > YUV,
> > > > > value+mask for RGB, so it's still not 100% clear what to pick if =
the
> > > > > plane supports both.
> > > > >=20
> > > > > I guess one alternative would be to have min+max only, and the
> > > > > driver
> > > > > would reject 'min !=3D max' if it only uses a single value?
> > > >=20
> > > > You should pick both and reject unsupported property values based on
> > > > the
> > > > planes framebuffer format. So it will be possible to set unsupported
> > > > values
> > > > while plane is disabled because it doesn't have an associated
> > > > framebuffer
> > > > and then atomic check will fail to enable plane if property values =
are
> > > > invalid for the given format.
> > >=20
> > > The colorkey which is attached to a plane 'A' is not applied to plane
> > > 'A', so the format of plane 'A' is not relevant.  The colorkey is
> > > applied to some other plane which will be below this plane in terms
> > > of the plane blending operation.
> > >=20
> > > What if you have several planes below plane 'A' with differing
> > > framebuffer formats - maybe an ARGB8888 plane and a ARGB1555 plane -
> > > do you decide to limit the colorkey to 8bits per channel, or to
> > > ARGB1555 format?
> > >=20
> > > The answer is, of course, hardware dependent - generic code can't
> > > know the details of the colorkey implementation, which could be one
> > >=20
> > > of:
> > >   lower plane data -> expand to 8bpc -> match ARGB8888 colorkey
> > >   lower plane data -> match ARGB8888 reduced to plane compatible
> > >   colorkey
> > >=20
> > > which will give different results depending on the format of the
> > > lower plane data.
> >=20
> > All unsupportable cases should be rejected in the atomic check. If your=
 HW
> > can't handle the case where multiple bottom planes have a different
> > format,
> > then in the planes atomic check you'll have to walk up all the bottom
> > planes and verify their formats.
>=20
> That is *not* what I'm trying to point out.
>=20
> You are claiming that we should check the validity of the colorkey
> format in relation to the lower planes, and it sounds like you're
> suggesting it in generic code.  I'm trying to get you to think a
> bit more about what you're suggesting by considering a theoretical
> (or maybe not so theoretical) case.
>=20
> We do have hardware out there which can have multiple planes that
> are merged together - I seem to remember that Tegra? hardware has
> that ability, but it isn't implemented in the driver yet.
>=20

I'm not sure what you're meaning by planes "merging", could you please=20
elaborate?

> So, I'm asking how you forsee the validity check working in the
> presence of different formats for multiple lower planes.
>=20
> I'm not talking about whether the hardware supports it or not - I'm
> assuming that the hardware _does_ support multiple lower planes with
> differing formats.
>=20
> From what I understand, to take the simple case of one lower plane,
> you are proposing:
>=20
> - if the lower plane is ARGB1555, then specifying a colorkey with
>   an alpha of anything except 0 or 0xffff would be invalid and should
>   be rejected.
>=20
> - if a lower plane is ARGB8888, then specifying a colorkey which
>   is anything except 0...0xffff in 0x101 (65535 / 255) steps would
>   be invalid and should be rejected.
>=20
> Now consider the case I mentioned above.  What if there are two lower
> planes, one with ARGB1555 and the other with ARGB8888.  Does this mean
> that (eg) the alpha colorkey component should be rejected if:
>=20
> - the alpha in the colorkey is not 0 or 0xffff, or
> - it's anything except 0...0xffff in 0x101 steps?
>=20
> My assertion is that this is only a decision that can be made by the
> driver and not by generic code, because it is hardware dependent.
>=20

Definitely the conversion rule must be defined explicitly, otherwise colork=
ey=20
property values can't be considered generic. Thank you for pointing at it. =
I=20
think rounding to a closest value should be the generic conversion rule.

I'll document the conversion rule in the next revision. Please let me know =
if=20
you see any problems with the rounding to a closest value.

The final decision will be made by the driver, but driver and userspace wil=
l=20
have to take into account the defined generic conversion rule.

> I am _not_ disagreeing with the general principle of validating that
> the requested state is possible with the hardware.

Thank you for the clarification.
