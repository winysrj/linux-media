Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:55488 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754345AbeFTJRy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 05:17:54 -0400
Received: by mail-wm0-f66.google.com with SMTP id v16-v6so4772174wmh.5
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2018 02:17:53 -0700 (PDT)
Date: Wed, 20 Jun 2018 11:17:50 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Ville =?iso-8859-1?Q?Syrj=E4l=E4?=
        <ville.syrjala@linux.intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        linux-renesas-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] drm: Add generic colorkey properties
Message-ID: <20180620091750.GD7186@phenom.ffwll.local>
References: <20180526155623.12610-1-digetx@gmail.com>
 <20180526155623.12610-2-digetx@gmail.com>
 <20180528131501.GK23723@intel.com>
 <efba1801-5b00-1fa1-45df-a5d3a2e3d63a@gmail.com>
 <20180529071103.GL23723@intel.com>
 <20180619174011.GJ17671@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180619174011.GJ17671@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 19, 2018 at 06:40:12PM +0100, Russell King - ARM Linux wrote:
> On Tue, May 29, 2018 at 10:11:03AM +0300, Ville Syrjälä wrote:
> > On Tue, May 29, 2018 at 02:48:22AM +0300, Dmitry Osipenko wrote:
> > > Though maybe "color components replacement" and "replacement with a complete
> > > transparency" could be factored out into a specific color keying modes.
> > 
> > Yes. I've never seen those in any hardware. In fact I'm wondering where
> > is the userspace for all these complex modes? Ie. should we even bother
> > with them at this time?
> 
> Such hardware does exist - here's what Armada 510 supports (and is
> supported via armada-drm):
> 
> Color Key Mode
> 0 = Disable: Disable color key function.
> 1 = EnableY: Video Y color key is enabled.
> 2 = EnableU: Video U color key is enabled.
> 3 = EnableRGB: Graphic RGB color key is enabled.
> 4 = EnableV: Video V color key is enabled.
> 5 = EnableR: Graphic R color key is enabled.
> 6 = EnableG: Graphic G color key is enabled.
> 7 = EnableB: Graphic B color key is enabled.
> 
> The description of how the colour keying works isn't particularly good,
> which is rather unfortunate, but basically, there's three 32-bit
> registers named LCD_SPU_COLORKEY_Y, LCD_SPU_COLORKEY_U and
> LCD_SPU_COLORKEY_V.
> 
> When a graphic mode is selected, then:
>  LCD_SPU_COLORKEY_Y is the R or B component depending on the red/blue swap
>  LCD_SPU_COLORKEY_U is the G component
>  LCD_SPU_COLORKEY_V is the B or R component according to the swap
> 
> 31:24 is the high bound for the component (inclusive)
> 23:16 is the low bound for the component (inclusive)
> 15:8  is the replacement value for the component
>  7:0  is the alpha value - seems to only be for LCD_SPU_COLORKEY_Y and
> 	ignored in the other registers when in RGB mode, but I've not
> 	fully tested this.  I suspect it's used with the single-channel
> 	colour keying modes.
> 
> The colour key stage provides an alpha value to the next stage - which
> is alpha blending between the graphic (primary) plane and video
> (overlay) plane.  Zero gives overlay only, 255 gives graphic only.
> 
> So, it's possible to use an 0x0101fe (RGB) colour key, and have it
> appear as "black" on the screen if you disable the overlay plane,
> rather than the unsightly bright blue.
> 
> One point to make though is about what userspace expects _today_ from
> overlay.  VLC, for example, expects overlay to be colour keyed, so it
> can display its full-screen controller when the user moves the mouse.
> I don't believe it explicitly sets up colour keying, but just expects
> it to be there and functional.  It _is_ rather necessary when you
> consider that overlay via the Xvideo extension is supposed to be
> "drawn" into the specified drawable, which may be a mapped window
> partially obscured by other mapped windows.
> 
> Maybe if the kernel DRM components doesn't want to do that, it'd be
> something that an Xorg DDX would have to default-enable to ensure
> that existing applications and expected Xorg behaviour doesn't break.

Yes -modesetting (or whichever other driver) would need to set up the
properties correctly for Xvideo color keying. Since default assumption for
all other (generic) compositors is that planes won't do any color keying
in the boot-up state.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
