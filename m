Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34489 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754435AbdC3U3P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 16:29:15 -0400
Date: Thu, 30 Mar 2017 23:29:10 +0300
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>, Daniel Vetter <daniel@ffwll.ch>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCHv5 00/11] video/exynos/sti/cec: add CEC notifier & use in
 drivers
Message-ID: <20170330202910.7wpzv4yyh4w67ocu@kozik-lap>
References: <20170329141543.32935-1-hverkuil@xs4all.nl>
 <20170329174758.55vasy2gxqpg3yb5@phenom.ffwll.local>
 <41757527-6953-6095-a18b-e5c75d93c966@xs4all.nl>
 <20170330074700.57gudirdrcrvi6al@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170330074700.57gudirdrcrvi6al@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 30, 2017 at 09:47:00AM +0200, Daniel Vetter wrote:
> On Wed, Mar 29, 2017 at 09:59:34PM +0200, Hans Verkuil wrote:
> > Hi Daniel,
> > 
> > On 29/03/17 19:47, Daniel Vetter wrote:
> > > On Wed, Mar 29, 2017 at 04:15:32PM +0200, Hans Verkuil wrote:
> > >> From: Hans Verkuil <hans.verkuil@cisco.com>
> > >>
> > >> This patch series adds the CEC physical address notifier code, based on
> > >> Russell's code:
> > >>
> > >> https://patchwork.kernel.org/patch/9277043/
> > >>
> > >> It adds support for it to the exynos_hdmi drm driver, adds support for
> > >> it to the CEC framework and finally adds support to the s5p-cec driver,
> > >> which now can be moved out of staging.
> > >>
> > >> Also included is similar code for the STI platform, contributed by
> > >> Benjamin Gaignard.
> > >>
> > >> Tested the exynos code with my Odroid U3 exynos4 devboard.
> > >>
> > >> After discussions with Daniel Vetter and Russell King I have removed
> > >> the EDID/ELD/HPD connect/disconnect events from the notifier and now
> > >> just use it to report the CEC physical address. This also means that
> > >> it is now renamed to CEC notifier instead of HPD notifier and that
> > >> it is now in drivers/media. The block_notifier was dropped as well
> > >> and instead a simple callback is registered. This means that the
> > >> relationship between HDMI and CEC is now 1:1 and no longer 1:n, but
> > >> should this be needed in the future, then that can easily be added
> > >> back.
> > >>
> > >> Daniel, regarding your suggestions here:
> > >>
> > >> http://www.spinics.net/lists/dri-devel/msg133907.html
> > >>
> > >> this patch series maps to your mail above as follows:
> > >>
> > >> struct cec_pin == struct cec_notifier
> > >> cec_(un)register_pin == cec_notifier_get/put
> > >> cec_set_address == cec_notifier_set_phys_addr
> > >> cec_(un)register_callbacks == cec_notifier_(un)register
> > >>
> > >> Comments are welcome. I'd like to get this in for the 4.12 kernel as
> > >> this is a missing piece needed to integrate CEC drivers.
> > >>
> > >> Regards,
> > >>
> > >> 	Hans
> > >>
> > >> Changes since v4:
> > >> - Dropped EDID/ELD/connect/disconnect support. Instead, just report the
> > >>   CEC physical address (and use INVALID when disconnecting).
> > >> - Since this is now completely CEC specific, move it to drivers/media
> > >>   and rename to cec-notifier.
> > >> - Drop block_notifier. Instead just set a callback for the notifier.
> > >> - Use 'hdmi-phandle' in the bindings for both exynos and sti. So no
> > >>   vendor prefix and 'hdmi-phandle' instead of 'hdmi-handle'.
> > >> - Make struct cec_notifier opaque. Add a helper function to get the
> > >>   physical address from a cec_notifier struct.
> > >> - Provide dummy functions in cec-notifier.h so it can be used when
> > >>   CONFIG_MEDIA_CEC_NOTIFIER is undefined.
> > >> - Don't select the CEC notifier in the HDMI drivers. It should only
> > >>   be enabled by actual CEC drivers.
> > > 
> > > I just quickly scaned through it, but this seems to address all my
> > > concerns fully. Thanks for respinning. On the entire pile (or just the
> > > core cec notifier bits):
> > > 
> > > Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > 
> > Fantastic! Thank you very much for your comments.
> > 
> > One last question: the patches for drivers/gpu/drm: can they go through
> > the media subsystem or do you want to take them? They do depend on the first
> > two patches of this series (cec-edid and cec-notifier), so it is a bit more
> > coordination if they have to go through the drm subsystem.
> 
> Doesn't seem to touch anything where I expect conflicts, so as long as it
> shows up in linux-next timely I think that's good. Please poke driver
> maintainers for their ack though, but if they fail to respond within a few
> days you can take my ack for merging the entire pile through media.
> 
> Cheers, Daniel

Hi Hans,

I will take the exynos DTS patch through samsung-soc. If anyone needs it
for bisectability, I can provide a tag.

For the drm and media exynos code, I am not the one to ack.

Best regards,
Krzysztof
