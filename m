Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:47689 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726650AbeGLNLr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jul 2018 09:11:47 -0400
Subject: Re: [PATCH v8 0/6] Add ChromeOS EC CEC Support
To: Neil Armstrong <narmstrong@baylibre.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: airlied@linux.ie, hans.verkuil@cisco.com, olof@lixom.net,
        seanpaul@google.com, sadolfsson@google.com, felixe@google.com,
        bleung@google.com, darekm@google.com, marcheu@chromium.org,
        fparent@baylibre.com, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, eballetbo@gmail.com
References: <1530716901-30164-1-git-send-email-narmstrong@baylibre.com>
 <20180712122645.GE4641@dell>
 <35fcf84e-f8a3-af79-013a-1c54ed5063ae@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0aaf878e-b028-617a-86a8-434cbc45d4fc@xs4all.nl>
Date: Thu, 12 Jul 2018 15:02:14 +0200
MIME-Version: 1.0
In-Reply-To: <35fcf84e-f8a3-af79-013a-1c54ed5063ae@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/07/18 14:42, Neil Armstrong wrote:
> Hi Lee,
> 
> On 12/07/2018 14:26, Lee Jones wrote:
>> On Wed, 04 Jul 2018, Neil Armstrong wrote:
>>
>>> Hi All,
>>>
>>> The new Google "Fizz" Intel-based ChromeOS device is gaining CEC support
>>> through it's Embedded Controller, to enable the Linux CEC Core to communicate
>>> with it and get the CEC Physical Address from the correct HDMI Connector, the
>>> following must be added/changed:
>>> - Add the CEC sub-device registration in the ChromeOS EC MFD Driver
>>> - Add the CEC related commands and events definitions into the EC MFD driver
>>> - Add a way to get a CEC notifier with it's (optional) connector name
>>> - Add the CEC notifier to the i915 HDMI driver
>>> - Add the proper ChromeOS EC CEC Driver
>>>
>>> The CEC notifier with the connector name is the tricky point, since even on
>>> Device-Tree platforms, there is no way to distinguish between multiple HDMI
>>> connectors from the same DRM driver. The solution I implemented is pretty
>>> simple and only adds an optional connector name to eventually distinguish
>>> an HDMI connector notifier from another if they share the same device.
>>>
>>> Feel free to comment this patchset !
>>>
>>> Changes since v7:
>>> - rebased on v4.18-rc1
>>> - Fixed whitespace issues on patch 3
>>> - Added Lee's tags
>>>
>>> Changes since v6:
>>> - Added stable identifier comment in intel_display.h
>>> - Renamed to cec_notifier in intel_hdmi.c/intel_drv.h
>>> - Added Acked-by/Reviewed-By tags
>>>
>>> Changes since v5:
>>>  - Small fixups on include/linux/mfd/cros_ec_commands.h
>>>  - Fixed on cros-ec-cec driver accordingly
>>>  - Added Reviewed-By tags
>>>
>>> Changes since v4:
>>>  - Split patch 3 to move the mkbp event size change into a separate patch
>>>
>>> Changes since v3 (incorrectly reported as v2):
>>>  - Renamed "Chrome OS" to "ChromeOS"
>>>  - Updated cros_ec_commands.h new structs definitions to kernel doc format
>>>  - Added Reviewed-By tags
>>>
>>> Changes since v2:
>>>  - Add i915 port_identifier() and use this stable name as cec_notifier conn name
>>>  - Fixed and cleaned up the CEC commands and events handling
>>>  - Rebased the CEC sub-device registration on top of Enric's serie
>>>  - Fixed comments typo on cec driver
>>>  - Protected the DMI match only with PCI and DMI Kconfigs
>>>
>>> Changes since v1:
>>>  - Added cec_notifier_put to intel_hdmi
>>>  - Fixed all small reported issues on the EC CEC driver
>>>  - Moved the cec_notifier_get out of the #if .. #else .. #endif
>>>
>>> Changes since RFC:
>>>  - Moved CEC sub-device registration after CEC commands and events definitions patch
>>>  - Removed get_notifier_get_byname
>>>  - Added CEC_CORE select into i915 Kconfig
>>>  - Removed CEC driver fallback if notifier is not configured on HW, added explicit warn
>>>  - Fixed CEC core return type on error
>>>  - Moved to cros-ec-cec media platform directory
>>>  - Use bus_find_device() to find the pci i915 device instead of get_notifier_get_byname()
>>>  - Fix Logical Address setup
>>>  - Added comment about HW support
>>>  - Removed memset of msg structures
>>>
>>> Neil Armstrong (6):
>>>   media: cec-notifier: Get notifier by device and connector name
>>>   drm/i915: hdmi: add CEC notifier to intel_hdmi
>>>   mfd: cros-ec: Increase maximum mkbp event size
>>>   mfd: cros-ec: Introduce CEC commands and events definitions.
>>>   mfd: cros_ec_dev: Add CEC sub-device registration
>>>   media: platform: Add ChromeOS EC CEC driver
>>>
>>>  drivers/gpu/drm/i915/Kconfig                     |   1 +
>>>  drivers/gpu/drm/i915/intel_display.h             |  24 ++
>>>  drivers/gpu/drm/i915/intel_drv.h                 |   2 +
>>>  drivers/gpu/drm/i915/intel_hdmi.c                |  13 +
>>>  drivers/media/cec/cec-notifier.c                 |  11 +-
>>>  drivers/media/platform/Kconfig                   |  11 +
>>>  drivers/media/platform/Makefile                  |   2 +
>>>  drivers/media/platform/cros-ec-cec/Makefile      |   1 +
>>>  drivers/media/platform/cros-ec-cec/cros-ec-cec.c | 347 +++++++++++++++++++++++
>>>  drivers/mfd/cros_ec_dev.c                        |  16 ++
>>>  drivers/platform/chrome/cros_ec_proto.c          |  40 ++-
>>>  include/linux/mfd/cros_ec.h                      |   2 +-
>>>  include/linux/mfd/cros_ec_commands.h             |  97 +++++++
>>>  include/media/cec-notifier.h                     |  27 +-
>>>  14 files changed, 578 insertions(+), 16 deletions(-)
>>>  create mode 100644 drivers/media/platform/cros-ec-cec/Makefile
>>>  create mode 100644 drivers/media/platform/cros-ec-cec/cros-ec-cec.c
>>
>> How would you like to handle this set?
>>
> 
> Hans proposed you take all the patches throught mfd,
> then drm-intel could merge your immutable branch to avoid any conflicts.
> 
> Rodrigo Vivi gave an ack to merge it through other trees on the v6 patchset.
> 
> Hans, should the media tree also merge the branch ?

No, there is no need for that. It's fine if it all goes through the mfd tree.

Regards,

	Hans

> 
> Neil
> 
