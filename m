Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:35612 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751522AbcKYLcy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 06:32:54 -0500
To: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.10] cec: pass parent device in register(), not
 allocate()
Message-ID: <e62b59c4-076a-14b6-fe5e-d0b09f7d2303@xs4all.nl>
Date: Fri, 25 Nov 2016 12:31:37 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

It's just a single patch, but I'd like to get that into 4.10. Now that the
cec framework moves out of staging I prefer to get this kernel API change
in before more CEC drivers are added.

Regards,

	Hans

The following changes since commit 4cc5bed1caeb6d40f2f41c4c5eb83368691fbffb:

  [media] uvcvideo: Use memdup_user() rather than duplicating its implementation (2016-11-23 20:06:41 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec-reg

for you to fetch changes up to f2684fe2abba97b9ca2c5966c4113644afca181b:

  cec: pass parent device in register(), not allocate() (2016-11-25 09:23:34 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      cec: pass parent device in register(), not allocate()

 Documentation/media/kapi/cec-core.rst     | 14 ++++++--------
 drivers/media/cec/cec-api.c               |  2 +-
 drivers/media/cec/cec-core.c              | 18 ++++++++++--------
 drivers/media/i2c/adv7511.c               |  5 +++--
 drivers/media/i2c/adv7604.c               |  6 +++---
 drivers/media/i2c/adv7842.c               |  6 +++---
 drivers/media/platform/vivid/vivid-cec.c  |  3 +--
 drivers/media/platform/vivid/vivid-cec.h  |  1 -
 drivers/media/platform/vivid/vivid-core.c |  9 ++++-----
 drivers/media/usb/pulse8-cec/pulse8-cec.c |  4 ++--
 drivers/staging/media/s5p-cec/s5p_cec.c   |  5 ++---
 drivers/staging/media/st-cec/stih-cec.c   |  5 ++---
 include/media/cec.h                       | 10 ++++------
 13 files changed, 41 insertions(+), 47 deletions(-)
