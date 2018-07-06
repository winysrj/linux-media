Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45986 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933949AbeGFRB7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2018 13:01:59 -0400
Date: Fri, 6 Jul 2018 18:01:36 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Ville =?iso-8859-1?Q?Syrj=E4l=E4?=
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
Subject: Re: [RFC PATCH v3 1/2] drm: Add generic colorkey properties for DRM
 planes
Message-ID: <20180706170136.GC17271@n2100.armlinux.org.uk>
References: <20180603220059.17670-1-digetx@gmail.com>
 <2295190.xHWjP7Ltc3@dimapc>
 <20180706154027.GB17271@n2100.armlinux.org.uk>
 <2513788.CeRymH5ehq@dimapc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2513788.CeRymH5ehq@dimapc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 06, 2018 at 07:33:14PM +0300, Dmitry Osipenko wrote:
> On Friday, 6 July 2018 18:40:27 MSK Russell King - ARM Linux wrote:
> > On Fri, Jul 06, 2018 at 05:58:50PM +0300, Dmitry Osipenko wrote:
> > > On Friday, 6 July 2018 17:10:10 MSK Ville Syrjälä wrote:
> > > > IIRC my earlier idea was to have different colorkey modes for the
> > > > min+max and value+mask modes. That way userspace might actually have
> > > > some chance of figuring out which bits of state actually do something.
> > > > Although for Intel hw I think the general rule is that min+max for YUV,
> > > > value+mask for RGB, so it's still not 100% clear what to pick if the
> > > > plane supports both.
> > > > 
> > > > I guess one alternative would be to have min+max only, and the driver
> > > > would reject 'min != max' if it only uses a single value?
> > > 
> > > You should pick both and reject unsupported property values based on the
> > > planes framebuffer format. So it will be possible to set unsupported
> > > values
> > > while plane is disabled because it doesn't have an associated framebuffer
> > > and then atomic check will fail to enable plane if property values are
> > > invalid for the given format.
> > 
> > The colorkey which is attached to a plane 'A' is not applied to plane
> > 'A', so the format of plane 'A' is not relevant.  The colorkey is
> > applied to some other plane which will be below this plane in terms
> > of the plane blending operation.
> > 
> > What if you have several planes below plane 'A' with differing
> > framebuffer formats - maybe an ARGB8888 plane and a ARGB1555 plane -
> > do you decide to limit the colorkey to 8bits per channel, or to
> > ARGB1555 format?
> > 
> > The answer is, of course, hardware dependent - generic code can't
> > know the details of the colorkey implementation, which could be one
> > of:
> > 
> >   lower plane data -> expand to 8bpc -> match ARGB8888 colorkey
> >   lower plane data -> match ARGB8888 reduced to plane compatible colorkey
> > 
> > which will give different results depending on the format of the
> > lower plane data.
> 
> All unsupportable cases should be rejected in the atomic check. If your HW 
> can't handle the case where multiple bottom planes have a different format, 
> then in the planes atomic check you'll have to walk up all the bottom planes 
> and verify their formats.

That is *not* what I'm trying to point out.

You are claiming that we should check the validity of the colorkey
format in relation to the lower planes, and it sounds like you're
suggesting it in generic code.  I'm trying to get you to think a
bit more about what you're suggesting by considering a theoretical
(or maybe not so theoretical) case.

We do have hardware out there which can have multiple planes that
are merged together - I seem to remember that Tegra? hardware has
that ability, but it isn't implemented in the driver yet.

So, I'm asking how you forsee the validity check working in the
presence of different formats for multiple lower planes.

I'm not talking about whether the hardware supports it or not - I'm
assuming that the hardware _does_ support multiple lower planes with
differing formats.

>From what I understand, to take the simple case of one lower plane,
you are proposing:

- if the lower plane is ARGB1555, then specifying a colorkey with
  an alpha of anything except 0 or 0xffff would be invalid and should
  be rejected.

- if a lower plane is ARGB8888, then specifying a colorkey which
  is anything except 0...0xffff in 0x101 (65535 / 255) steps would
  be invalid and should be rejected.

Now consider the case I mentioned above.  What if there are two lower
planes, one with ARGB1555 and the other with ARGB8888.  Does this mean
that (eg) the alpha colorkey component should be rejected if:

- the alpha in the colorkey is not 0 or 0xffff, or
- it's anything except 0...0xffff in 0x101 steps?

My assertion is that this is only a decision that can be made by the
driver and not by generic code, because it is hardware dependent.

I am _not_ disagreeing with the general principle of validating that
the requested state is possible with the hardware.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 13.8Mbps down 630kbps up
According to speedtest.net: 13Mbps down 490kbps up
