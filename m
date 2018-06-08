Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:41033 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752724AbeFHHx0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Jun 2018 03:53:26 -0400
Subject: Re: [PATCH v7 0/6] Add ChromeOS EC CEC Support
To: Neil Armstrong <narmstrong@baylibre.com>, airlied@linux.ie,
        hans.verkuil@cisco.com, lee.jones@linaro.org, olof@lixom.net,
        seanpaul@google.com
Cc: sadolfsson@google.com, felixe@google.com, bleung@google.com,
        darekm@google.com, marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        eballetbo@gmail.com
References: <1527841154-24832-1-git-send-email-narmstrong@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <04598b47-5099-6695-da43-6e7148145cfa@xs4all.nl>
Date: Fri, 8 Jun 2018 09:53:19 +0200
MIME-Version: 1.0
In-Reply-To: <1527841154-24832-1-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/01/2018 10:19 AM, Neil Armstrong wrote:
> Hi All,
> 
> The new Google "Fizz" Intel-based ChromeOS device is gaining CEC support
> through it's Embedded Controller, to enable the Linux CEC Core to communicate
> with it and get the CEC Physical Address from the correct HDMI Connector, the
> following must be added/changed:
> - Add the CEC sub-device registration in the ChromeOS EC MFD Driver
> - Add the CEC related commands and events definitions into the EC MFD driver
> - Add a way to get a CEC notifier with it's (optional) connector name
> - Add the CEC notifier to the i915 HDMI driver
> - Add the proper ChromeOS EC CEC Driver
> 
> The CEC notifier with the connector name is the tricky point, since even on
> Device-Tree platforms, there is no way to distinguish between multiple HDMI
> connectors from the same DRM driver. The solution I implemented is pretty
> simple and only adds an optional connector name to eventually distinguish
> an HDMI connector notifier from another if they share the same device.

This looks good to me, which brings me to the next question: how to merge
this?

It touches on three subsystems (media, drm, mfd), so that makes this
tricky.

I think there are two options: either the whole series goes through the
media tree, or patches 1+2 go through drm and 3-6 through media. If there
is a high chance of conflicts in the mfd code, then it is also an option to
have patches 3-6 go through the mfd subsystem.

Any opinions?

Regards,

	Hans

> 
> Feel free to comment this patchset !
> 
> Changes since v6:
> - Added stable identifier comment in intel_display.h
> - Renamed to cec_notifier in intel_hdmi.c/intel_drv.h
> - Added Acked-by/Reviewed-By tags
> 
> Changes since v5:
>  - Small fixups on include/linux/mfd/cros_ec_commands.h
>  - Fixed on cros-ec-cec driver accordingly
>  - Added Reviewed-By tags
> 
> Changes since v4:
>  - Split patch 3 to move the mkbp event size change into a separate patch
> 
> Changes since v3 (incorrectly reported as v2):
>  - Renamed "Chrome OS" to "ChromeOS"
>  - Updated cros_ec_commands.h new structs definitions to kernel doc format
>  - Added Reviewed-By tags
> 
> Changes since v2:
>  - Add i915 port_identifier() and use this stable name as cec_notifier conn name
>  - Fixed and cleaned up the CEC commands and events handling
>  - Rebased the CEC sub-device registration on top of Enric's serie
>  - Fixed comments typo on cec driver
>  - Protected the DMI match only with PCI and DMI Kconfigs
> 
> Changes since v1:
>  - Added cec_notifier_put to intel_hdmi
>  - Fixed all small reported issues on the EC CEC driver
>  - Moved the cec_notifier_get out of the #if .. #else .. #endif
> 
> Changes since RFC:
>  - Moved CEC sub-device registration after CEC commands and events definitions patch
>  - Removed get_notifier_get_byname
>  - Added CEC_CORE select into i915 Kconfig
>  - Removed CEC driver fallback if notifier is not configured on HW, added explicit warn
>  - Fixed CEC core return type on error
>  - Moved to cros-ec-cec media platform directory
>  - Use bus_find_device() to find the pci i915 device instead of get_notifier_get_byname()
>  - Fix Logical Address setup
>  - Added comment about HW support
>  - Removed memset of msg structures
> 
> Neil Armstrong (6):
>   media: cec-notifier: Get notifier by device and connector name
>   drm/i915: hdmi: add CEC notifier to intel_hdmi
>   mfd: cros-ec: Increase maximum mkbp event size
>   mfd: cros-ec: Introduce CEC commands and events definitions.
>   mfd: cros_ec_dev: Add CEC sub-device registration
>   media: platform: Add ChromeOS EC CEC driver
> 
>  drivers/gpu/drm/i915/Kconfig                     |   1 +
>  drivers/gpu/drm/i915/intel_display.h             |  24 ++
>  drivers/gpu/drm/i915/intel_drv.h                 |   2 +
>  drivers/gpu/drm/i915/intel_hdmi.c                |  13 +
>  drivers/media/cec/cec-notifier.c                 |  11 +-
>  drivers/media/platform/Kconfig                   |  11 +
>  drivers/media/platform/Makefile                  |   2 +
>  drivers/media/platform/cros-ec-cec/Makefile      |   1 +
>  drivers/media/platform/cros-ec-cec/cros-ec-cec.c | 347 +++++++++++++++++++++++
>  drivers/mfd/cros_ec_dev.c                        |  16 ++
>  drivers/platform/chrome/cros_ec_proto.c          |  40 ++-
>  include/linux/mfd/cros_ec.h                      |   2 +-
>  include/linux/mfd/cros_ec_commands.h             | 100 +++++++
>  include/media/cec-notifier.h                     |  27 +-
>  14 files changed, 581 insertions(+), 16 deletions(-)
>  create mode 100644 drivers/media/platform/cros-ec-cec/Makefile
>  create mode 100644 drivers/media/platform/cros-ec-cec/cros-ec-cec.c
> 
