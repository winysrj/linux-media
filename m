Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:35927 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760412AbdDSHqF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 03:46:05 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] cec: clean up Kconfig, headers
Message-ID: <4fe738dd-d6c5-8464-8154-e88ff02fe910@xs4all.nl>
Date: Wed, 19 Apr 2017 09:45:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This should be merged for 4.12 before more CEC drivers are merged.

>From the cover letter of the patch series:

-----------------------------
This patch series cleans up the various CEC config options.

In particular it adds a CEC_CORE config option which is what CEC drivers
should depend on, and it removes the MEDIA_CEC_EDID config option which
was rather pointless.

Finally it adds a new option to explicitly enable the RC passthrough
support in CEC.

It also moves cec-edid.c and cec-notifier.c to the media/cec directory
and merges them into the cec module instead of having separate modules
for these. And the cec-edid.h header is merged into cec.h.

CEC drivers now just depend on CEC_CORE. And if the CEC drivers needs
the CEC notifier framework, then it has to select CEC_NOTIFIER.
-----------------------------

Now is a good time to merge this since all CEC drivers are currently in
media. For 4.13 I expect CEC drivers to appear in drm as well (omap4 among
others), so cleaning this up now while we don't have to deal with
cross-subsystem complications make this a lot easier.

Regards,

	Hans


The following changes since commit ee0fe833d96793853335844b6d99fb76bd12cbeb:

  [media] zr364xx: enforce minimum size when reading header (2017-04-18 12:57:29 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec

for you to fetch changes up to 27f54990cf6beec89e439e21e532fab15d973af4:

  cec: add MEDIA_CEC_RC config option (2017-04-18 23:26:03 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
      cec: Kconfig cleanup
      cec.h: merge cec-edid.h into cec.h
      cec: add MEDIA_CEC_RC config option

 MAINTAINERS                              |   3 --
 drivers/media/Kconfig                    |  26 ++++-----------
 drivers/media/Makefile                   |  14 ++------
 drivers/media/cec/Kconfig                |  19 +++++++++++
 drivers/media/cec/Makefile               |   8 +++--
 drivers/media/cec/cec-adap.c             |   4 +--
 drivers/media/cec/cec-core.c             |  12 +++----
 drivers/media/{ => cec}/cec-edid.c       |   6 +---
 drivers/media/{ => cec}/cec-notifier.c   |   1 +
 drivers/media/i2c/Kconfig                |   9 ++----
 drivers/media/platform/Kconfig           |  56 ++++++++++++++++----------------
 drivers/media/platform/s5p-cec/s5p_cec.c |   1 -
 drivers/media/platform/vivid/Kconfig     |   3 +-
 drivers/media/usb/pulse8-cec/Kconfig     |   2 +-
 drivers/media/usb/rainshadow-cec/Kconfig |   2 +-
 include/media/cec-edid.h                 | 104 -----------------------------------------------------------
 include/media/cec-notifier.h             |   2 +-
 include/media/cec.h                      | 104 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 18 files changed, 180 insertions(+), 196 deletions(-)
 create mode 100644 drivers/media/cec/Kconfig
 rename drivers/media/{ => cec}/cec-edid.c (96%)
 rename drivers/media/{ => cec}/cec-notifier.c (99%)
 delete mode 100644 include/media/cec-edid.h
