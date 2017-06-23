Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40551 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751182AbdFWLor (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 07:44:47 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] Various fixes
Message-ID: <0fe77d1f-7a9b-6099-5559-90bd71188684@xs4all.nl>
Date: Fri, 23 Jun 2017 13:44:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Little things all over the place.

	Hans

The following changes since commit 76724b30f222067faf00874dc277f6c99d03d800:

  [media] media: venus: enable building with COMPILE_TEST (2017-06-20 10:57:08 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.13g

for you to fetch changes up to 49218d3c042530071783f7c1c6c0e70e17679ae7:

  coda: rename the picture run timeout error handler (2017-06-23 13:15:54 +0200)

----------------------------------------------------------------
Arnd Bergmann (2):
      Revert "[media] et8ek8: Export OF device ID as module aliases"
      rainshadow-cec: avoid -Wmaybe-uninitialized warning again

Colin Ian King (1):
      media: venus: fix loop wrap in cleanup of clks

Gustavo A. R. Silva (1):
      radio: wl1273: add check on core->write() return value

Joe Perches (2):
      stkwebcam: Use more common logging styles
      tuner-core: Remove unused #define PREFIX

Markus Elfring (1):
      bdisp-debug: Replace a seq_puts() call by seq_putc() in seven functions

Philipp Zabel (2):
      coda: ctx->codec is not NULL in coda_alloc_framebuffers
      coda: rename the picture run timeout error handler

 drivers/media/i2c/et8ek8/et8ek8_driver.c          |  1 -
 drivers/media/platform/coda/coda-bit.c            |  8 ++++----
 drivers/media/platform/coda/coda-common.c         |  4 ++--
 drivers/media/platform/coda/coda.h                |  2 +-
 drivers/media/platform/qcom/venus/core.c          |  2 +-
 drivers/media/platform/sti/bdisp/bdisp-debug.c    | 14 +++++++-------
 drivers/media/radio/radio-wl1273.c                | 15 +++++++++++++--
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 18 ++++++++----------
 drivers/media/usb/stkwebcam/stk-sensor.c          | 32 ++++++++++++++++++--------------
 drivers/media/usb/stkwebcam/stk-webcam.c          | 70 ++++++++++++++++++++++++++++++++++------------------------------------
 drivers/media/usb/stkwebcam/stk-webcam.h          |  6 ------
 drivers/media/v4l2-core/tuner-core.c              |  2 --
 12 files changed, 88 insertions(+), 86 deletions(-)
