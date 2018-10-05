Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:57993 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727701AbeJEUgg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 16:36:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Subject: [PATCHv2 0/6] cec/adv/cec-gpio: fixes and new status flags
Date: Fri,  5 Oct 2018 15:37:39 +0200
Message-Id: <20181005133745.8593-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series replaces patches 1-3 of:

https://www.spinics.net/lists/linux-media/msg141216.html

Patches 4 & 5 of that series remain as-is and are omap4 bug fixes.

This patch series can be applied to the media subsystem since it
has no drm changes.

Changes since the previous patch series are:

- Added a new patch improving the documentation of the cec_transmit_done
  function to hopefully avoid the omap4 bug in the future.

- Add a new patch that fixes a bug in the Signal Free Time calculation
  of the CEC framework. This affects hardware that relies on the framework
  for this value. This bug could basically cause a 'denial of service'
  situation on the CEC bus. Found with the cec-compliance adapter test,
  which does really nasty things :-)

- Improve cec-gpio to fixup the Signal Free Time if a transmit is delayed
  because a new message was received first (thus requiring a lower SFT).

All patches are meant for 4.20, and patches 2-5 will get a CC to stable
for 4.18 and up.

The adv patches could go back to older kernels, but it's not very important.

I'll post a pull request for this series soon.

Regards,

	Hans

Hans Verkuil (6):
  cec-core.rst: improve cec_transmit_done documentation
  cec: add new tx/rx status bits to detect aborts/timeouts
  adv7604: when the EDID is cleared, unconfigure CEC as well
  adv7842: when the EDID is cleared, unconfigure CEC as well
  cec: fix the Signal Free Time calculation
  cec-gpio: select correct Signal Free Time

 Documentation/media/kapi/cec-core.rst         |  4 +
 .../media/uapi/cec/cec-ioc-receive.rst        | 25 ++++-
 drivers/media/cec/cec-adap.c                  | 92 +++++--------------
 drivers/media/cec/cec-pin.c                   | 20 ++++
 drivers/media/i2c/adv7604.c                   |  4 +-
 drivers/media/i2c/adv7842.c                   |  4 +-
 include/media/cec.h                           |  2 +-
 include/uapi/linux/cec.h                      |  3 +
 8 files changed, 82 insertions(+), 72 deletions(-)

-- 
2.18.0
