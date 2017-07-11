Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41093 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755877AbdGKNaT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 09:30:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 0/3] drm/i915: add DisplayPort CEC-Tunneling-over-AUX support
Date: Tue, 11 Jul 2017 15:30:08 +0200
Message-Id: <20170711133011.41139-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds support for the DisplayPort CEC-Tunneling-over-AUX
feature. This patch series is based on the latest mainline kernel (as of today)
which has all the needed cec and drm 4.13 patches merged.

This patch series has been tested with my NUC7i5BNK and a Samsung USB-C to 
HDMI adapter.

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

I suspect that the reason so few adapters support this is that this
tunneling protocol was never supported by any OS. So there was no 
easy way of testing it, and no incentive to correctly wire up the
CEC pin.

Hopefully by creating this driver it will be easier for vendors to 
finally fix their adapters and test the CEC functionality.

I keep a list of known working adapters here:

https://hverkuil.home.xs4all.nl/cec-status.txt

Please mail me (hverkuil@xs4all.nl) if you find an adapter that works
and is not yet listed there.
----------------------------------------------------------------------

I really hope that this work will provide an incentive for vendors to
finally connect the CEC pin. It's a shame that there are so few adapters
that work (I found only two USB-C to HDMI adapters that work, and no
(mini-)DP to HDMI adapters at all).

Daniel, I incorporated all your suggestions/comments from the RFC patch
series from about 2 months ago.

Regards,

        Hans

Hans Verkuil (3):
  drm: add support for DisplayPort CEC-Tunneling-over-AUX
  drm-kms-helpers.rst: document the DP CEC helpers
  drm/i915: add DisplayPort CEC-Tunneling-over-AUX support

 Documentation/gpu/drm-kms-helpers.rst |   9 +
 drivers/gpu/drm/Kconfig               |  10 ++
 drivers/gpu/drm/Makefile              |   1 +
 drivers/gpu/drm/drm_dp_cec.c          | 308 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_dp.c       |  18 +-
 include/drm/drm_dp_helper.h           |  24 +++
 6 files changed, 366 insertions(+), 4 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_dp_cec.c

-- 
2.11.0
