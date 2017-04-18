Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50231 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932080AbdDRIqH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 04:46:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH for v4.12 0/3] cec: clean up Kconfig, headers
Date: Tue, 18 Apr 2017 10:45:58 +0200
Message-Id: <20170418084601.1590-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

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

I would like to see this merged for 4.12 before more CEC drivers get
merged.

Regards,

	Hans

Hans Verkuil (3):
  cec: Kconfig cleanup
  cec.h: merge cec-edid.h into cec.h
  cec: add MEDIA_CEC_RC config option

 MAINTAINERS                              |   3 -
 drivers/media/Kconfig                    |  26 +++-----
 drivers/media/Makefile                   |  14 +----
 drivers/media/cec/Kconfig                |  19 ++++++
 drivers/media/cec/Makefile               |   8 ++-
 drivers/media/cec/cec-adap.c             |   4 +-
 drivers/media/cec/cec-core.c             |  12 ++--
 drivers/media/{ => cec}/cec-edid.c       |   6 +-
 drivers/media/{ => cec}/cec-notifier.c   |   1 +
 drivers/media/i2c/Kconfig                |   9 +--
 drivers/media/platform/Kconfig           |  56 ++++++++---------
 drivers/media/platform/s5p-cec/s5p_cec.c |   1 -
 drivers/media/platform/vivid/Kconfig     |   3 +-
 drivers/media/usb/pulse8-cec/Kconfig     |   2 +-
 drivers/media/usb/rainshadow-cec/Kconfig |   2 +-
 include/media/cec-edid.h                 | 104 -------------------------------
 include/media/cec-notifier.h             |   2 +-
 include/media/cec.h                      | 104 ++++++++++++++++++++++++++++++-
 18 files changed, 180 insertions(+), 196 deletions(-)
 create mode 100644 drivers/media/cec/Kconfig
 rename drivers/media/{ => cec}/cec-edid.c (96%)
 rename drivers/media/{ => cec}/cec-notifier.c (99%)
 delete mode 100644 include/media/cec-edid.h

-- 
2.11.0
