Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:35065 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752280AbeF0GRt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 02:17:49 -0400
Subject: Re: [PATCHv6 0/3] drm/i915: add DisplayPort CEC-Tunneling-over-AUX
 support
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        dri-devel@lists.freedesktop.org,
        Carlos Santa <carlos.santa@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
References: <20180612111831.58210-1-hverkuil@xs4all.nl>
Message-ID: <7474ddf5-29ea-c390-f428-7d24811de6ca@xs4all.nl>
Date: Wed, 27 Jun 2018 08:17:38 +0200
MIME-Version: 1.0
In-Reply-To: <20180612111831.58210-1-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping!

Adding Ville to the CC list, I think I forgot to add you, sorry about that.

Regards,

	Hans

On 06/12/2018 01:18 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series adds support for the DisplayPort CEC-Tunneling-over-AUX
> feature. This patch series is based on the current media master branch
> (https://git.linuxtv.org/media_tree.git/log/) but it applies fine on top
> of the current mainline tree.
> 
> This patch series has been tested with my NUC7i5BNK, a Google USB-C to 
> HDMI adapter and a Club 3D DisplayPort MST Hub + modified UpTab DP-to-HDMI
> adapter (where the CEC pin is wired up). The latter is to check that
> replacing a USB-C to HDMI adapter by a USB-C MST Hub works correctly.
> CEC for MST is currently not supported.
> 
> Please note this comment at the start of drm_dp_cec.c:
> 
> ----------------------------------------------------------------------
> Unfortunately it turns out that we have a chicken-and-egg situation
> here. Quite a few active (mini-)DP-to-HDMI or USB-C-to-HDMI adapters
> have a converter chip that supports CEC-Tunneling-over-AUX (usually the
> Parade PS176), but they do not wire up the CEC pin, thus making CEC
> useless.
> 
> Sadly there is no way for this driver to know this. What happens is
> that a /dev/cecX device is created that is isolated and unable to see
> any of the other CEC devices. Quite literally the CEC wire is cut
> (or in this case, never connected in the first place).
> 
> The reason so few adapters support this is that this tunneling protocol
> was never supported by any OS. So there was no easy way of testing it,
> and no incentive to correctly wire up the CEC pin.
> 
> Hopefully by creating this driver it will be easier for vendors to
> finally fix their adapters and test the CEC functionality.
> 
> I keep a list of known working adapters here:
> 
> https://hverkuil.home.xs4all.nl/cec-status.txt
> 
> Please mail me (hverkuil@xs4all.nl) if you find an adapter that works
> and is not yet listed there.
> 
> Note that the current implementation does not support CEC over an MST hub.
> As far as I can see there is no mechanism defined in the DisplayPort
> standard to transport CEC interrupts over an MST device. It might be
> possible to do this through polling, but I have not been able to get that
> to work.
> ----------------------------------------------------------------------
> 
> I really hope that this work will provide an incentive for vendors to
> finally connect the CEC pin. It's a shame that there are so few adapters
> that work (I found only three USB-C to HDMI adapters that work, and no
> (mini-)DP to HDMI adapters at all). It is a very nice feature for HTPC
> boxes.
> 
> Apologies for the long delay between v5 and this v6: too many other
> projects needed my attention.
> 
> The main change since v5 is that the CEC adapter is now unregistered
> after a user-defined time (by default 1 second) if the EDID is unset.
> If the EDID comes back within that time, then the existing CEC adapter
> is used as this is assumed to be a HPD off-and-on toggle from the
> display. The delay can also be set to 0 through a module option. In
> that case the CEC adapter will never be unregistered as long as the
> connector remains registered (or if a new HDMI adapter was connected
> with different capabilities from the previous adapter).
> 
> Note that I removed the Tested-by tag from Carlos Santa due to the
> substantial rework of the code. Carlos, can you test this again?
> 
> Regards,
> 
>         Hans
> 
> Changes since v5:
> 
> - Moved the logic of when to unregister a CEC adapter to the drm core
>   code, since this is independent of the actual driver implementation.
> - Simplified the calls the driver needs to make: the core code is
>   informed when a connector is (un)registered, when the EDID is
>   unset or set and when a DP short pulse is seen and you need to check
>   if that is for a CEC interrupt.
> - Added the drm_dp_cec_unregister_delay module option to set the delay
>   between unsetting the EDID and unregistering the CEC adapter.
> 
> Changes since v4:
> 
> - Updated comment at the start of drm_dp_cec.c
> - Add edid pointer to drm_dp_cec_configure_adapter
> - Reworked the last patch (adding CEC to i915) based on Ville's comments
>   and my MST testing:
> 	- register/unregister CEC in intel_dp_connector_register/unregister
> 	- add comment and check if connector is registered in long_pulse
> 	- unregister CEC if an MST 'connector' is detected.
> 
> Hans Verkuil (3):
>   drm: add support for DisplayPort CEC-Tunneling-over-AUX
>   drm-kms-helpers.rst: document the DP CEC helpers
>   drm/i915: add DisplayPort CEC-Tunneling-over-AUX support
> 
>  Documentation/gpu/drm-kms-helpers.rst |   9 +
>  drivers/gpu/drm/Kconfig               |  10 +
>  drivers/gpu/drm/Makefile              |   1 +
>  drivers/gpu/drm/drm_dp_cec.c          | 423 ++++++++++++++++++++++++++
>  drivers/gpu/drm/drm_dp_helper.c       |   1 +
>  drivers/gpu/drm/i915/intel_dp.c       |  17 +-
>  include/drm/drm_dp_helper.h           |  56 ++++
>  7 files changed, 515 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/gpu/drm/drm_dp_cec.c
> 
