Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:54784 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752074AbdEPMQy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 08:16:54 -0400
To: linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] Various fixes/regressions for 4.12.
Message-ID: <9abf8d78-fad4-66e4-10e5-4b0d12cde695@xs4all.nl>
Date: Tue, 16 May 2017 14:16:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This supersedes this earlier pull request:

https://patchwork.linuxtv.org/patch/41065/

This new pull request adds the 'cec-notifier.h: handle unreachable CONFIG_CEC_CORE'
patch. Otherwise it is unchanged.

Regards,

	Hans

The following changes since commit 3622d3e77ecef090b5111e3c5423313f11711dfa:

  [media] ov2640: print error if devm_*_optional*() fails (2017-04-25 07:08:21 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.12h

for you to fetch changes up to 6ea28a0a88d3e8c0bb1603459b24d650c8305cbd:

  cec-notifier.h: handle unreachable CONFIG_CEC_CORE (2017-05-16 14:14:04 +0200)

----------------------------------------------------------------
Arnd Bergmann (4):
      rainshadow-cec: use strlcat instead of strncat
      rainshadow-cec: avoid -Wmaybe-uninitialized warning
      cec: improve MEDIA_CEC_RC dependencies
      cec-notifier.h: handle unreachable CONFIG_CEC_CORE

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
 include/media/cec-notifier.h                      | 12 +++++++++++-
 6 files changed, 30 insertions(+), 6 deletions(-)
