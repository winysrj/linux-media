Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:37060 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752078AbdFMNhe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 09:37:34 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] CEC helper functions and CEC_CAP_NEEDS_HPD
 capability
Message-ID: <557bbead-4420-f029-c91a-351de5001560@xs4all.nl>
Date: Tue, 13 Jun 2017 15:37:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds various useful helper functions (esp. for
upcoming CEC support in drm drivers).

The other addition is support for the new CEC_CAP_NEEDS_HPD capability: it
turns out there is a lot of hardware out there that cannot use the CEC pin
when there is no HPD. The CEC specification allows this in order to wake up
displays that pull the HPD low when in standby, but CEC still works.

But hardware like the Odroid U3 that hooks the HPD to a level-shifter and
that powers it off when the HPD goes low will also block the CEC signal from
reaching the SoC. So even though the SoC can handle this, the board design
prevents it from working.

There are more upcoming drivers (e.g. DisplayPort CEC-over-AUX tunneling)
that have the same limitation, so this capability is needed for 4.13.

The final two patches generalizes the CEC DT bindings at the request of Rob
Herring.

Regards,

	Hans

The following changes since commit 47f910f0e0deb880c2114811f7ea1ec115a19ee4:

  [media] v4l: subdev: tolerate null in media_entity_to_v4l2_subdev (2017-06-08 16:55:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec-hpd

for you to fetch changes up to a1aba50d302888f607a2e50f9240dd64b9a2bea5:

  dt-bindings: media/s5p-cec.txt, media/stih-cec.txt: refer to cec.txt (2017-06-13 15:00:22 +0200)

----------------------------------------------------------------
Hans Verkuil (10):
      cec: add cec_s_phys_addr_from_edid helper function
      cec: add cec_phys_addr_invalidate() helper function
      cec: add cec_transmit_attempt_done helper function
      stih-cec/vivid/pulse8/rainshadow: use cec_transmit_attempt_done
      cec: add CEC_CAP_NEEDS_HPD
      cec-ioc-adap-g-caps.rst: document CEC_CAP_NEEDS_HPD
      dt-bindings: media/s5p-cec.txt: document needs-hpd property
      s5p_cec: set the CEC_CAP_NEEDS_HPD flag if needed
      dt-bindings: add media/cec.txt
      dt-bindings: media/s5p-cec.txt, media/stih-cec.txt: refer to cec.txt

 Documentation/devicetree/bindings/media/cec.txt      |  8 ++++++++
 Documentation/devicetree/bindings/media/s5p-cec.txt  |  6 +++++-
 Documentation/devicetree/bindings/media/stih-cec.txt |  2 +-
 Documentation/media/kapi/cec-core.rst                | 18 ++++++++++++++++++
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst |  8 ++++++++
 MAINTAINERS                                          |  1 +
 drivers/media/cec/cec-adap.c                         | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 drivers/media/cec/cec-api.c                          |  5 ++++-
 drivers/media/cec/cec-core.c                         |  1 +
 drivers/media/platform/s5p-cec/s5p_cec.c             |  4 +++-
 drivers/media/platform/sti/cec/stih-cec.c            |  9 ++++-----
 drivers/media/platform/vivid/vivid-cec.c             |  6 +++---
 drivers/media/usb/pulse8-cec/pulse8-cec.c            |  9 +++------
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c    |  9 +++------
 include/media/cec.h                                  | 29 +++++++++++++++++++++++++++++
 include/uapi/linux/cec.h                             |  2 ++
 16 files changed, 147 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/cec.txt
