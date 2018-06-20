Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:44342 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754014AbeFTKKI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 06:10:08 -0400
Received: by mail-io0-f196.google.com with SMTP id g7-v6so2935325ioh.11
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2018 03:10:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180620093321.GL17671@n2100.armlinux.org.uk>
References: <20180526155623.12610-1-digetx@gmail.com> <20180526155623.12610-2-digetx@gmail.com>
 <20180528131501.GK23723@intel.com> <efba1801-5b00-1fa1-45df-a5d3a2e3d63a@gmail.com>
 <20180529071103.GL23723@intel.com> <20180619174011.GJ17671@n2100.armlinux.org.uk>
 <20180620091750.GD7186@phenom.ffwll.local> <20180620093321.GL17671@n2100.armlinux.org.uk>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Wed, 20 Jun 2018 12:10:07 +0200
Message-ID: <CAKMK7uGMKs2GgP+nrxDV4LbbmrqcHApLsz9pTc=mQojHtSVaUQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/2] drm: Add generic colorkey properties
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
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
        Dmitry Osipenko <digetx@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 20, 2018 at 11:33 AM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Wed, Jun 20, 2018 at 11:17:50AM +0200, Daniel Vetter wrote:
>> Yes -modesetting (or whichever other driver) would need to set up the
>> properties correctly for Xvideo color keying. Since default assumption for
>> all other (generic) compositors is that planes won't do any color keying
>> in the boot-up state.
>
> Thanks, is that documented anywhere?

With the standardization of properties I'm also trying to get these
expectations better documented, e.g.

https://dri.freedesktop.org/docs/drm/gpu/drm-kms.html#plane-composition-properties

But I think we're not doing a good job yet documenting default
expectations. But the above would be a good place to get that fixed -
this patch here should do that, at least for color keying.
-Daniel

>
> --
> RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
> According to speedtest.net: 8.21Mbps down 510kbps up



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
