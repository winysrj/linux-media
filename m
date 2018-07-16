Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38279 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730571AbeGPIEL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 04:04:11 -0400
Received: by mail-wr1-f66.google.com with SMTP id v14-v6so1017538wro.5
        for <linux-media@vger.kernel.org>; Mon, 16 Jul 2018 00:38:09 -0700 (PDT)
Subject: Re: [GIT PULL] Immutable branch between MFD and DRM/i915, Media and
 Platform due for the v4.19 merge window
To: airlied@linux.ie, Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, hans.verkuil@cisco.com,
        olof@lixom.net, seanpaul@google.com, sadolfsson@google.com,
        felixe@google.com, bleung@google.com, darekm@google.com,
        marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        eballetbo@gmail.com
References: <1530716901-30164-1-git-send-email-narmstrong@baylibre.com>
 <20180713074620.GW4641@dell>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <274ecbb8-7fa7-b706-6572-cb32f379001b@baylibre.com>
Date: Mon, 16 Jul 2018 09:38:06 +0200
MIME-Version: 1.0
In-Reply-To: <20180713074620.GW4641@dell>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave, Rodrigo.

On 13/07/2018 09:46, Lee Jones wrote:
> Enjoy!
> 
> The following changes since commit ce397d215ccd07b8ae3f71db689aedb85d56ab40:
> 
>   Linux 4.18-rc1 (2018-06-17 08:04:49 +0900)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git ib-mfd-i915-media-platform-v4.19
> 
> for you to fetch changes up to cd70de2d356ee692477276bd5d6bc88c71a48733:
> 
>   media: platform: Add ChromeOS EC CEC driver (2018-07-13 08:44:46 +0100)
> 
> ----------------------------------------------------------------
> Immutable branch between MFD and DRM/i915, Media and Platform due for the v4.19 merge window


This PR is here to solve a complex interdependency over this patchset,
Hans agreed all the media patches go to the MFD tree and Rodrigo acked the i915
patch so it could be applied to another tree,
but who is suposed to take this PR to the DRM tree ?

Neil

> 
> ----------------------------------------------------------------
> Neil Armstrong (6):
>       media: cec-notifier: Get notifier by device and connector name
>       drm/i915: hdmi: add CEC notifier to intel_hdmi
>       mfd: cros-ec: Increase maximum mkbp event size
>       mfd: cros-ec: Introduce CEC commands and events definitions.
>       mfd: cros_ec_dev: Add CEC sub-device registration
>       media: platform: Add ChromeOS EC CEC driver
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
>  include/linux/mfd/cros_ec_commands.h             |  97 +++++++
>  include/media/cec-notifier.h                     |  27 +-
>  14 files changed, 578 insertions(+), 16 deletions(-)
>  create mode 100644 drivers/media/platform/cros-ec-cec/Makefile
>  create mode 100644 drivers/media/platform/cros-ec-cec/cros-ec-cec.c
> 
