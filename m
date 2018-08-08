Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:47037 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbeHHQur (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 12:50:47 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?=
        <ville.syrjala@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/2] drm: Add generic colorkey properties for display planes
Date: Wed, 08 Aug 2018 17:30:45 +0300
Message-ID: <2089566.PDTrKWWE8Q@dimapc>
In-Reply-To: <20180808081608.GK30658@n2100.armlinux.org.uk>
References: <20180807172202.1961-1-digetx@gmail.com> <20180807172202.1961-2-digetx@gmail.com> <20180808081608.GK30658@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, 8 August 2018 11:16:09 MSK Russell King - ARM Linux wrote:
> On Tue, Aug 07, 2018 at 08:22:01PM +0300, Dmitry Osipenko wrote:
> > + * Glossary:
> > + *
> > + * Destination plane:
> > + *	Plane to which color keying properties are applied, this planes takes
> > + *	the effect of color keying operation. The effect is determined by a
> > + *	given color keying mode.
> > + *
> > + * Source plane:
> > + *	Pixels of this plane are the source for color key matching operation.
> 
> ...
> 
> > +	/**
> > +	 * @DRM_PLANE_COLORKEY_MODE_TRANSPARENT:
> > +	 *
> > +	 * Destination plane pixels are completely transparent in areas
> > +	 * where pixels of a source plane are matching a given color key
> > +	 * range, in other cases pixels of a destination plane are 
unaffected.
> > +	 * In areas where two or more source planes overlap, the topmost
> > +	 * plane takes precedence.
> > +	 */
> 
> This seems confusing to me.
> 
> What you seem to be saying is that the "destination" plane would be the
> one which is (eg0 the graphic plane, and the "source" plane would be the
> the plane containing (eg) the video.  You seem to be saying that the
> colorkey matches the video and determines whether the pixels in the
> graphic plane are opaque or transparent.

Your example is correct.

With the "plane_mask" property we can specify any plane as the "source" for 
color key, so it can been either a video plane or graphic plane and even both 
at the same time.

> Surely that is the wrong way round - in video overlay, you want to
> colorkey match the contents of the graphic plane to determine which
> pixels from the video plane to overlay.

The "transparent" mode makes the color-matched pixels to become transparent, 
you want the inversion effect and hence that should be called something like a 
"transparent-inverted" mode. Maarten Lankhorst was asking for that mode in his 
comment to v3, I'm leaving for somebody else to add that mode later since 
there is no real use for it on Tegra right now.

So in your case the graphic plane will be the "source" plane (specified via 
the colorkey.plane_mask property), video plane will be the "destination" plane 
(plane to which the colorkey properties are applied) and the colorkey.mode 
will be "transparent-inverted". Pixels of the "source" plane are being matched 
and "destination" plane takes the effect of color keying operation, i.e. the 
color-matched pixels of graphic plane leave the video plane pixels unaffected 
and the unmatched pixels make the video plane pixels transparent.

> If it's the other way around (source is the graphic, destination is the
> video) it makes less sense to use the "source" and "destination" terms,
> I can't see how you could describe a plane that is being overlaid on
> top of another plane as a "destination".

Tegra has a bit annoying limitations in regard to a reduced plane blending 
functionality when color keying is enabled. I found that the best variant to 
work around the limitations is to move the graphic plane on top of the video 
plane and to make the graphic plane to match itself. I.e. the matched pixels 
of graphic plane become transparent and hence poked by video plane.

> I guess the terminology has come from a thought about using a GPU to
> physically do the colorkeying when combining two planes - if the GPU
> were to write to the "destination" plane, then this would be the wrong
> way around.  For starters, taking the above example, the video plane
> may well be smaller than the graphic plane.  If it's the other way
> around, that has other problems, like destroying the colorkey in the
> graphic plane when writing the video plane's contents to it.

It all depends on a use-case scenario. It won't be easy for userspace to 
generalize the usage of color keying, at best the color keying interface could 
be generalized and then userspace may choose the best fitting variant based on 
available HW capabilities.

> So, in summary, I don't think "destination" and "source" are
> particularly good terms to describe the operation, and I think you have
> them swapped in your description of
> "DRM_PLANE_COLORKEY_MODE_TRANSPARENT".

Maybe the DRM_PLANE_COLORKEY_MODE_TRANSPARENT should become 
DRM_PLANE_COLORKEY_MODE_TRANSPARENT_INVERTED? 

Any more opinions?
