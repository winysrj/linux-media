Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33590 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932134AbdC2RsD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 13:48:03 -0400
Received: by mail-wr0-f195.google.com with SMTP id u18so5090968wrc.0
        for <linux-media@vger.kernel.org>; Wed, 29 Mar 2017 10:48:02 -0700 (PDT)
Date: Wed, 29 Mar 2017 19:47:58 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCHv5 00/11] video/exynos/sti/cec: add CEC notifier & use in
 drivers
Message-ID: <20170329174758.55vasy2gxqpg3yb5@phenom.ffwll.local>
References: <20170329141543.32935-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170329141543.32935-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 29, 2017 at 04:15:32PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series adds the CEC physical address notifier code, based on
> Russell's code:
> 
> https://patchwork.kernel.org/patch/9277043/
> 
> It adds support for it to the exynos_hdmi drm driver, adds support for
> it to the CEC framework and finally adds support to the s5p-cec driver,
> which now can be moved out of staging.
> 
> Also included is similar code for the STI platform, contributed by
> Benjamin Gaignard.
> 
> Tested the exynos code with my Odroid U3 exynos4 devboard.
> 
> After discussions with Daniel Vetter and Russell King I have removed
> the EDID/ELD/HPD connect/disconnect events from the notifier and now
> just use it to report the CEC physical address. This also means that
> it is now renamed to CEC notifier instead of HPD notifier and that
> it is now in drivers/media. The block_notifier was dropped as well
> and instead a simple callback is registered. This means that the
> relationship between HDMI and CEC is now 1:1 and no longer 1:n, but
> should this be needed in the future, then that can easily be added
> back.
> 
> Daniel, regarding your suggestions here:
> 
> http://www.spinics.net/lists/dri-devel/msg133907.html
> 
> this patch series maps to your mail above as follows:
> 
> struct cec_pin == struct cec_notifier
> cec_(un)register_pin == cec_notifier_get/put
> cec_set_address == cec_notifier_set_phys_addr
> cec_(un)register_callbacks == cec_notifier_(un)register
> 
> Comments are welcome. I'd like to get this in for the 4.12 kernel as
> this is a missing piece needed to integrate CEC drivers.
> 
> Regards,
> 
> 	Hans
> 
> Changes since v4:
> - Dropped EDID/ELD/connect/disconnect support. Instead, just report the
>   CEC physical address (and use INVALID when disconnecting).
> - Since this is now completely CEC specific, move it to drivers/media
>   and rename to cec-notifier.
> - Drop block_notifier. Instead just set a callback for the notifier.
> - Use 'hdmi-phandle' in the bindings for both exynos and sti. So no
>   vendor prefix and 'hdmi-phandle' instead of 'hdmi-handle'.
> - Make struct cec_notifier opaque. Add a helper function to get the
>   physical address from a cec_notifier struct.
> - Provide dummy functions in cec-notifier.h so it can be used when
>   CONFIG_MEDIA_CEC_NOTIFIER is undefined.
> - Don't select the CEC notifier in the HDMI drivers. It should only
>   be enabled by actual CEC drivers.

I just quickly scaned through it, but this seems to address all my
concerns fully. Thanks for respinning. On the entire pile (or just the
core cec notifier bits):

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> 
> Changes since v3:
> - Added the STI patches
> - Split the exynos4 binding patches in one for documentation and one
>   for the dts change itself, also use the correct subject and CC to
>   the correct mailinglists (I hope  )
> 
> Changes since v2:
> - Split off the dts changes of the s5p-cec patch into a separate patch
> - Renamed HPD_NOTIFIERS to HPD_NOTIFIER to be consistent with the name
>   of the source.
> 
> Changes since v1:
> 
> Renamed HDMI notifier to HPD (hotplug detect) notifier since this code is
> not HDMI specific, but is interesting for any video source that has to
> deal with hotplug detect and EDID/ELD (HDMI, DVI, VGA, DP, ....).
> Only the use with CEC adapters is HDMI specific, but the HPD notifier
> is more generic.
> 
> 
> 
> 
> Benjamin Gaignard (4):
>   sti: hdmi: add CEC notifier support
>   stih-cec.txt: document new hdmi phandle
>   stih-cec: add CEC notifier support
>   arm: sti: update sti-cec for CEC notifier support
> 
> Hans Verkuil (7):
>   cec-edid: rename cec_get_edid_phys_addr
>   media: add CEC notifier support
>   cec: integrate CEC notifier support
>   exynos_hdmi: add CEC notifier support
>   ARM: dts: exynos: add HDMI controller phandle to exynos4.dtsi
>   s5p-cec.txt: document the HDMI controller phandle
>   s5p-cec: add cec-notifier support, move out of staging
> 
>  .../devicetree/bindings/media/s5p-cec.txt          |   2 +
>  .../devicetree/bindings/media/stih-cec.txt         |   2 +
>  MAINTAINERS                                        |   4 +-
>  arch/arm/boot/dts/exynos4.dtsi                     |   1 +
>  arch/arm/boot/dts/stih407-family.dtsi              |  12 ---
>  arch/arm/boot/dts/stih410.dtsi                     |  13 +++
>  drivers/gpu/drm/exynos/exynos_hdmi.c               |  20 +++-
>  drivers/gpu/drm/sti/sti_hdmi.c                     |  11 ++
>  drivers/gpu/drm/sti/sti_hdmi.h                     |   3 +
>  drivers/media/Kconfig                              |   3 +
>  drivers/media/Makefile                             |   4 +
>  drivers/media/cec-edid.c                           |  15 ++-
>  drivers/media/cec-notifier.c                       | 116 +++++++++++++++++++++
>  drivers/media/cec/cec-core.c                       |  21 ++++
>  drivers/media/i2c/adv7511.c                        |   5 +-
>  drivers/media/i2c/adv7604.c                        |   3 +-
>  drivers/media/i2c/adv7842.c                        |   2 +-
>  drivers/media/platform/Kconfig                     |  28 +++++
>  drivers/media/platform/Makefile                    |   2 +
>  .../media => media/platform}/s5p-cec/Makefile      |   0
>  .../platform}/s5p-cec/exynos_hdmi_cec.h            |   0
>  .../platform}/s5p-cec/exynos_hdmi_cecctrl.c        |   0
>  .../media => media/platform}/s5p-cec/regs-cec.h    |   0
>  .../media => media/platform}/s5p-cec/s5p_cec.c     |  35 ++++++-
>  .../media => media/platform}/s5p-cec/s5p_cec.h     |   3 +
>  .../st-cec => media/platform/sti/cec}/Makefile     |   0
>  .../st-cec => media/platform/sti/cec}/stih-cec.c   |  31 +++++-
>  drivers/media/platform/vivid/vivid-vid-cap.c       |   3 +-
>  drivers/staging/media/Kconfig                      |   4 -
>  drivers/staging/media/Makefile                     |   2 -
>  drivers/staging/media/s5p-cec/Kconfig              |   9 --
>  drivers/staging/media/s5p-cec/TODO                 |   7 --
>  drivers/staging/media/st-cec/Kconfig               |   8 --
>  drivers/staging/media/st-cec/TODO                  |   7 --
>  include/media/cec-edid.h                           |  17 ++-
>  include/media/cec-notifier.h                       |  93 +++++++++++++++++
>  include/media/cec.h                                |   6 ++
>  37 files changed, 421 insertions(+), 71 deletions(-)
>  create mode 100644 drivers/media/cec-notifier.c
>  rename drivers/{staging/media => media/platform}/s5p-cec/Makefile (100%)
>  rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cec.h (100%)
>  rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cecctrl.c (100%)
>  rename drivers/{staging/media => media/platform}/s5p-cec/regs-cec.h (100%)
>  rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.c (89%)
>  rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.h (97%)
>  rename drivers/{staging/media/st-cec => media/platform/sti/cec}/Makefile (100%)
>  rename drivers/{staging/media/st-cec => media/platform/sti/cec}/stih-cec.c (93%)
>  delete mode 100644 drivers/staging/media/s5p-cec/Kconfig
>  delete mode 100644 drivers/staging/media/s5p-cec/TODO
>  delete mode 100644 drivers/staging/media/st-cec/Kconfig
>  delete mode 100644 drivers/staging/media/st-cec/TODO
>  create mode 100644 include/media/cec-notifier.h
> 
> -- 
> 2.11.0
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
