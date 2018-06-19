Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:52610 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966650AbeFSRkn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 13:40:43 -0400
Date: Tue, 19 Jun 2018 18:40:12 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: Dmitry Osipenko <digetx@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] drm: Add generic colorkey properties
Message-ID: <20180619174011.GJ17671@n2100.armlinux.org.uk>
References: <20180526155623.12610-1-digetx@gmail.com>
 <20180526155623.12610-2-digetx@gmail.com>
 <20180528131501.GK23723@intel.com>
 <efba1801-5b00-1fa1-45df-a5d3a2e3d63a@gmail.com>
 <20180529071103.GL23723@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180529071103.GL23723@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 29, 2018 at 10:11:03AM +0300, Ville Syrjälä wrote:
> On Tue, May 29, 2018 at 02:48:22AM +0300, Dmitry Osipenko wrote:
> > Though maybe "color components replacement" and "replacement with a complete
> > transparency" could be factored out into a specific color keying modes.
> 
> Yes. I've never seen those in any hardware. In fact I'm wondering where
> is the userspace for all these complex modes? Ie. should we even bother
> with them at this time?

Such hardware does exist - here's what Armada 510 supports (and is
supported via armada-drm):

Color Key Mode
0 = Disable: Disable color key function.
1 = EnableY: Video Y color key is enabled.
2 = EnableU: Video U color key is enabled.
3 = EnableRGB: Graphic RGB color key is enabled.
4 = EnableV: Video V color key is enabled.
5 = EnableR: Graphic R color key is enabled.
6 = EnableG: Graphic G color key is enabled.
7 = EnableB: Graphic B color key is enabled.

The description of how the colour keying works isn't particularly good,
which is rather unfortunate, but basically, there's three 32-bit
registers named LCD_SPU_COLORKEY_Y, LCD_SPU_COLORKEY_U and
LCD_SPU_COLORKEY_V.

When a graphic mode is selected, then:
 LCD_SPU_COLORKEY_Y is the R or B component depending on the red/blue swap
 LCD_SPU_COLORKEY_U is the G component
 LCD_SPU_COLORKEY_V is the B or R component according to the swap

31:24 is the high bound for the component (inclusive)
23:16 is the low bound for the component (inclusive)
15:8  is the replacement value for the component
 7:0  is the alpha value - seems to only be for LCD_SPU_COLORKEY_Y and
	ignored in the other registers when in RGB mode, but I've not
	fully tested this.  I suspect it's used with the single-channel
	colour keying modes.

The colour key stage provides an alpha value to the next stage - which
is alpha blending between the graphic (primary) plane and video
(overlay) plane.  Zero gives overlay only, 255 gives graphic only.

So, it's possible to use an 0x0101fe (RGB) colour key, and have it
appear as "black" on the screen if you disable the overlay plane,
rather than the unsightly bright blue.

One point to make though is about what userspace expects _today_ from
overlay.  VLC, for example, expects overlay to be colour keyed, so it
can display its full-screen controller when the user moves the mouse.
I don't believe it explicitly sets up colour keying, but just expects
it to be there and functional.  It _is_ rather necessary when you
consider that overlay via the Xvideo extension is supposed to be
"drawn" into the specified drawable, which may be a mapped window
partially obscured by other mapped windows.

Maybe if the kernel DRM components doesn't want to do that, it'd be
something that an Xorg DDX would have to default-enable to ensure
that existing applications and expected Xorg behaviour doesn't break.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
