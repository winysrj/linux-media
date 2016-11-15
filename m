Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49542 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932783AbcKOX2D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 18:28:03 -0500
Date: Tue, 15 Nov 2016 23:27:54 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Pierre-Hugues Husson <phh@phh.me>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFCv2 PATCH 2/5] drm/bridge: dw_hdmi: remove CEC engine
 register definitions
Message-ID: <20161115232754.GB1041@n2100.armlinux.org.uk>
References: <1479136968-24477-1-git-send-email-hverkuil@xs4all.nl>
 <1479136968-24477-3-git-send-email-hverkuil@xs4all.nl>
 <CAJ-oXjS-VVkBuYh0inTGAvJbsKzvEqKYrgoSeG6UBQtW_1BEyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ-oXjS-VVkBuYh0inTGAvJbsKzvEqKYrgoSeG6UBQtW_1BEyQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 16, 2016 at 12:23:50AM +0100, Pierre-Hugues Husson wrote:
> Hi,
> 
> 
> 2016-11-14 16:22 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:
> > From: Russell King <rmk+kernel@arm.linux.org.uk>
> >
> > We don't need the CEC engine register definitions, so let's remove them.
> >
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > ---
> >  drivers/gpu/drm/bridge/dw-hdmi.h | 45 ----------------------------------------
> >  1 file changed, 45 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/bridge/dw-hdmi.h b/drivers/gpu/drm/bridge/dw-hdmi.h
> > index fc9a560..26d6845 100644
> > --- a/drivers/gpu/drm/bridge/dw-hdmi.h
> > +++ b/drivers/gpu/drm/bridge/dw-hdmi.h
> > @@ -478,51 +478,6 @@
> >  #define HDMI_A_PRESETUP                         0x501A
> >  #define HDMI_A_SRM_BASE                         0x5020
> >
> > -/* CEC Engine Registers */
> > -#define HDMI_CEC_CTRL                           0x7D00
> > -#define HDMI_CEC_STAT                           0x7D01
> > -#define HDMI_CEC_MASK                           0x7D02
> I don't know if this is relevant for a submission, but the build stops
> working here because of a missing definition HDMI_CEC_MASK
> Perhaps this should be inverted with 3/5 to make bissecting easier?
> I was trying to bissect a kernel panic, and I had to fix this by hand

Doesn't make sense - patch 3 doesn't reference HDMI_CEC_MASK.

Please show the build error in full.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
