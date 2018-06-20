Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35174 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754652AbeFTJdr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 05:33:47 -0400
Date: Wed, 20 Jun 2018 10:33:21 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Daniel Vetter <daniel@ffwll.ch>
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
Message-ID: <20180620093321.GL17671@n2100.armlinux.org.uk>
References: <20180526155623.12610-1-digetx@gmail.com>
 <20180526155623.12610-2-digetx@gmail.com>
 <20180528131501.GK23723@intel.com>
 <efba1801-5b00-1fa1-45df-a5d3a2e3d63a@gmail.com>
 <20180529071103.GL23723@intel.com>
 <20180619174011.GJ17671@n2100.armlinux.org.uk>
 <20180620091750.GD7186@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180620091750.GD7186@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 20, 2018 at 11:17:50AM +0200, Daniel Vetter wrote:
> Yes -modesetting (or whichever other driver) would need to set up the
> properties correctly for Xvideo color keying. Since default assumption for
> all other (generic) compositors is that planes won't do any color keying
> in the boot-up state.

Thanks, is that documented anywhere?

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
