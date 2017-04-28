Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:37128 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S968584AbdD1OMP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 10:12:15 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] Various fixes/regressions for 4.12.
Message-ID: <2ffca2c4-4b13-4148-1282-cf059fd2b6cc@xs4all.nl>
Date: Fri, 28 Apr 2017 16:12:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 9eb9db3a0f92b75ec710066202e0b2accb45afa9:

  [media] atmel-isc: Fix the static checker warning (2017-04-19 09:02:47 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.12h

for you to fetch changes up to 82fd29fb6372a9d15c39e2bcf87768cb52aa9cba:

  vb2: Fix an off by one error in 'vb2_plane_vaddr' (2017-04-28 11:42:54 +0200)

----------------------------------------------------------------
Arnd Bergmann (3):
      rainshadow-cec: use strlcat instead of strncat
      rainshadow-cec: avoid -Wmaybe-uninitialized warning
      cec: improve MEDIA_CEC_RC dependencies

Christophe JAILLET (1):
      vb2: Fix an off by one error in 'vb2_plane_vaddr'

Petr Cvek (1):
      pxa_camera: fix module remove codepath for v4l2 clock

Wei Yongjun (2):
      rainshadow-cec: Fix missing spin_lock_init()
      s5p-cec: remove unused including <linux/version.h>

 drivers/media/cec/Kconfig                         |  1 +
 drivers/media/platform/pxa_camera.c               | 14 +++++++++++++-
 drivers/media/platform/s5p-cec/s5p_cec.h          |  1 -
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c |  6 ++++--
 drivers/media/v4l2-core/videobuf2-core.c          |  2 +-
 5 files changed, 19 insertions(+), 5 deletions(-)
