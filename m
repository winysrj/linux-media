Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:50698 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752458AbeGBPr7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 11:47:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, ville.syrjala@linux.intel.com,
        seanpaul@chromium.org, daniel.vetter@ffwll.ch,
        carlos.santa@intel.com
Subject: [PATCHv8 0/3] drm/i915: add DisplayPort CEC-Tunneling-over-AUX support
Date: Mon,  2 Jul 2018 17:47:53 +0200
Message-Id: <20180702154756.117244-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds support for the DisplayPort CEC-Tunneling-over-AUX
feature. This patch series is based on the current media master branch
(https://git.linuxtv.org/media_tree.git/log/) but it applies fine on top
of the current mainline tree.

This patch series has been tested with my NUC7i5BNK, a Google USB-C to 
HDMI adapter and a Club 3D DisplayPort MST Hub + modified UpTab DP-to-HDMI
adapter (where the CEC pin is wired up). The latter is to check that
replacing a USB-C to HDMI adapter by a USB-C MST Hub works correctly.
CEC for MST is currently not supported.

Please note this comment at the start of drm_dp_cec.c:

----------------------------------------------------------------------
Unfortunately it turns out that we have a chicken-and-egg situation
here. Quite a few active (mini-)DP-to-HDMI or USB-C-to-HDMI adapters
have a converter chip that supports CEC-Tunneling-over-AUX (usually the
Parade PS176), but they do not wire up the CEC pin, thus making CEC
useless.

Sadly there is no way for this driver to know this. What happens is
that a /dev/cecX device is created that is isolated and unable to see
any of the other CEC devices. Quite literally the CEC wire is cut
(or in this case, never connected in the first place).

The reason so few adapters support this is that this tunneling protocol
was never supported by any OS. So there was no easy way of testing it,
and no incentive to correctly wire up the CEC pin.

Hopefully by creating this driver it will be easier for vendors to
finally fix their adapters and test the CEC functionality.

I keep a list of known working adapters here:

https://hverkuil.home.xs4all.nl/cec-status.txt

Please mail me (hverkuil@xs4all.nl) if you find an adapter that works
and is not yet listed there.

Note that the current implementation does not support CEC over an MST hub.
As far as I can see there is no mechanism defined in the DisplayPort
standard to transport CEC interrupts over an MST device. It might be
possible to do this through polling, but I have not been able to get that
to work.
----------------------------------------------------------------------

I really hope that this work will provide an incentive for vendors to
finally connect the CEC pin. It's a shame that there are so few adapters
that work (I found only three USB-C to HDMI adapters that work, and no
(mini-)DP to HDMI adapters at all). It is a very nice feature for HTPC
boxes.

This v8 incorporates Ville's suggested cleanups from his review of v7
and it adds his Reviewed-by tag.

Regards,

        Hans

Changes since v7:

- Drop unnecessary aux->cec.adap check from drm_dp_cec_unregister_work()
- Cancel unregister_work at the start of drm_dp_cec_unset_edid(). This
  simplifies the remainder of the code in that function.

Changes since v6:

- Made struct edid const in drm_dp_cec_set_edid()
- Changed drm_dp_cec_unregister_delay behavior: 0 == no unregister delay,
  >= 1000 == never unregister.
- Fixed potential deadlock in drm_dp_cec_unset_edid().
- Moved all cec fields in struct drm_dp_aux to a struct drm_dp_aux_cec.

Changes since v5:

- Moved the logic of when to unregister a CEC adapter to the drm core
  code, since this is independent of the actual driver implementation.
- Simplified the calls the driver needs to make: the core code is
  informed when a connector is (un)registered, when the EDID is
  unset or set and when a DP short pulse is seen and you need to check
  if that is for a CEC interrupt.
- Added the drm_dp_cec_unregister_delay module option to set the delay
  between unsetting the EDID and unregistering the CEC adapter.

Changes since v4:

- Updated comment at the start of drm_dp_cec.c
- Add edid pointer to drm_dp_cec_configure_adapter
- Reworked the last patch (adding CEC to i915) based on Ville's comments
  and my MST testing:
	- register/unregister CEC in intel_dp_connector_register/unregister
	- add comment and check if connector is registered in long_pulse
	- unregister CEC if an MST 'connector' is detected.


Hans Verkuil (3):
  drm: add support for DisplayPort CEC-Tunneling-over-AUX
  drm-kms-helpers.rst: document the DP CEC helpers
  drm/i915: add DisplayPort CEC-Tunneling-over-AUX support

 Documentation/gpu/drm-kms-helpers.rst |   9 +
 drivers/gpu/drm/Kconfig               |  10 +
 drivers/gpu/drm/Makefile              |   1 +
 drivers/gpu/drm/drm_dp_cec.c          | 427 ++++++++++++++++++++++++++
 drivers/gpu/drm/drm_dp_helper.c       |   1 +
 drivers/gpu/drm/i915/intel_dp.c       |  17 +-
 include/drm/drm_dp_helper.h           |  56 ++++
 7 files changed, 519 insertions(+), 2 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_dp_cec.c

-- 
2.18.0
