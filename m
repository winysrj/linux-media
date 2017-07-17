Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:58606 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751286AbdGQOJF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 10:09:05 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] Coda driver fixes
Message-ID: <b281a151-f4c5-4176-b5a7-ea1aadac6bcf@xs4all.nl>
Date: Mon, 17 Jul 2017 16:09:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 2748e76ddb2967c4030171342ebdd3faa6a5e8e8:

  media: staging: cxd2099: Activate cxd2099 buffer mode (2017-06-26 08:19:13 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git coda

for you to fetch changes up to b3c669248a03eca02984813f96681f6dbfc1ec0b:

  coda: wake up capture queue on encoder stop after output streamoff (2017-07-17 15:56:53 +0200)

----------------------------------------------------------------
Philipp Zabel (8):
      coda: add h264 and mpeg4 profile and level controls
      coda: do not reassign ctx->tiled_map_type in coda_s_fmt
      coda: extend GOP size range
      coda: set field of destination buffers
      coda: align internal mpeg4 framebuffers to 16x16 macroblocks
      coda: set MPEG-4 encoder class register
      coda: mark CODA960 firmware versions 2.3.10 and 3.1.1 as supported
      coda: wake up capture queue on encoder stop after output streamoff

 drivers/media/platform/coda/coda-bit.c    | 16 +++++++++++++---
 drivers/media/platform/coda/coda-common.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/media/platform/coda/coda_regs.h   |  1 +
 3 files changed, 68 insertions(+), 7 deletions(-)
