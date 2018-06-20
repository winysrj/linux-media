Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:38272 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753594AbeFTMUe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 08:20:34 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?=
        <ville.syrjala@linux.intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        "open list:DRM DRIVERS FOR RENESAS"
        <linux-renesas-soc@vger.kernel.org>, linux-tegra@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/2] drm: Add generic colorkey properties
Date: Wed, 20 Jun 2018 15:20:31 +0300
Message-ID: <18882685.yDnGXdaDdQ@dimapc>
In-Reply-To: <CAKMK7uGMKs2GgP+nrxDV4LbbmrqcHApLsz9pTc=mQojHtSVaUQ@mail.gmail.com>
References: <20180526155623.12610-1-digetx@gmail.com> <20180620093321.GL17671@n2100.armlinux.org.uk> <CAKMK7uGMKs2GgP+nrxDV4LbbmrqcHApLsz9pTc=mQojHtSVaUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, 20 June 2018 13:10:07 MSK Daniel Vetter wrote:
> On Wed, Jun 20, 2018 at 11:33 AM, Russell King - ARM Linux
> 
> <linux@armlinux.org.uk> wrote:
> > On Wed, Jun 20, 2018 at 11:17:50AM +0200, Daniel Vetter wrote:
> >> Yes -modesetting (or whichever other driver) would need to set up the
> >> properties correctly for Xvideo color keying. Since default assumption
> >> for
> >> all other (generic) compositors is that planes won't do any color keying
> >> in the boot-up state.
> > 
> > Thanks, is that documented anywhere?
> 
> With the standardization of properties I'm also trying to get these
> expectations better documented, e.g.
> 
> https://dri.freedesktop.org/docs/drm/gpu/drm-kms.html#plane-composition-prop
> erties
> 
> But I think we're not doing a good job yet documenting default
> expectations. But the above would be a good place to get that fixed -
> this patch here should do that, at least for color keying.
> -Daniel

There is a comment in this patch that says:

+ * colorkey.mode:
+ *     The mode is an enumerated property that controls how color keying
+ *     operates. The "disabled" mode that disables color keying and is
+ *     very likely to exist if color keying is supported, it should be the
+ *     default mode.

So the default-disabled state is kinda documented. Though that comment is 
omitted in the v3, I'll correct that in the next revision.

For now one question that keeps this patchset in RFC state is about how to 
expose the color key value properties to userspace, whether having drivers to 
perform RGB->YUV conversion is a viable way (see the v3 of the patchset).
