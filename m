Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:43710 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750839AbdE1Joc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 05:44:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH for v4.12 0/3] cec: more kernel config cleanups
Date: Sun, 28 May 2017 11:44:23 +0200
Message-Id: <20170528094426.10089-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

While working on drm CEC drivers I realized that the correct config
setup is a pain. The problem is that the CEC subsystem is really independent
of the media subsystem: both media and drm drivers can use it.

So this patch series moves the core CEC kernel config options outside the
"Multimedia support" menu and drivers that want to use CEC should select
CEC_CORE. This also ensures that the cec framework will be correctly build
as either a module or a built-in.

The only missing piece is that drm drivers that use cec-notifier.h need to
add a 'select CEC_CORE if CEC_NOTIFIER' to their Kconfig. That would allow
the removal of the ugly 'IS_REACHABLE' construct in cec-notifier.h.

But that can be done for 4.13.

Enabling the RC integration is still part of the MEDIA_CEC_SUPPORT menu,
since it obviously relies on the media rc core.

The second patch renames MEDIA_CEC_NOTIFIER to CEC_NOTIFIER since
this too is not part of the media subsystem and is instead selected by
drivers that want to use it.

The last patch drops the MEDIA_CEC_DEBUG kernel config option: instead
just rely on DEBUG_FS. There really is no need for this additional option,
and in fact it would require enabled the media subsystem just to enable
the CEC debugfs support when used by a drm driver.

I want to get this in for 4.12 while there are no drm drivers yet that
integrate CEC support.

Regards,

        Hans

Hans Verkuil (3):
  cec: select CEC_CORE instead of depend on it
  cec: rename MEDIA_CEC_NOTIFIER to CEC_NOTIFIER
  cec: drop MEDIA_CEC_DEBUG

 drivers/media/Kconfig                    |  6 ++++++
 drivers/media/Makefile                   |  4 ++--
 drivers/media/cec/Kconfig                | 14 --------------
 drivers/media/cec/Makefile               |  2 +-
 drivers/media/cec/cec-adap.c             |  2 +-
 drivers/media/cec/cec-core.c             |  8 ++++----
 drivers/media/i2c/Kconfig                |  9 ++++++---
 drivers/media/platform/Kconfig           | 10 ++++++----
 drivers/media/platform/vivid/Kconfig     |  3 ++-
 drivers/media/usb/pulse8-cec/Kconfig     |  3 ++-
 drivers/media/usb/rainshadow-cec/Kconfig |  3 ++-
 include/media/cec-notifier.h             |  2 +-
 include/media/cec.h                      |  4 ++--
 13 files changed, 35 insertions(+), 35 deletions(-)

-- 
2.11.0
