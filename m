Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:64879 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab3JIX5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Oct 2013 19:57:55 -0400
Received: by mail-oa0-f73.google.com with SMTP id n10so348475oag.2
        for <linux-media@vger.kernel.org>; Wed, 09 Oct 2013 16:57:53 -0700 (PDT)
From: John Sheu <sheu@google.com>
To: linux-media@vger.kernel.org
Cc: John Sheu <sheu@google.com>, m.chehab@samsung.com,
	k.debski@samsung.com, pawel@osciak.com
Subject: [PATCH 0/6] Exynos video fixes from ChromeOS
Date: Wed,  9 Oct 2013 16:49:43 -0700
Message-Id: <1381362589-32237-1-git-send-email-sheu@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are various video processing driver fixes for the s5p-mfc and gsc-m2m
hardware blocks on the Samsung Exynos (ARM) platform, that have been carried
in the ChromeOS kernel tree for a while and should be pushed upstream.

John Sheu (6):
  [media] s5p-mfc: fix DISPLAY_DELAY
  [media] s5p-mfc: fix encoder crash after VIDIOC_STREAMOFF
  [media] s5p-mfc: add support for VIDIOC_{G,S}_CROP to encoder
  [media] s5p-mfc: support dynamic encoding parameter changes
  [media] gsc-m2m: report correct format bytesperline and sizeimage
  [media] v4l2-mem2mem: allow reqbufs(0) with "in use" MMAP buffers

 drivers/media/platform/exynos-gsc/gsc-core.c    | 153 +++++++++++++-----------
 drivers/media/platform/exynos-gsc/gsc-core.h    |  16 +--
 drivers/media/platform/exynos-gsc/gsc-regs.c    |  40 ++++---
 drivers/media/platform/exynos-gsc/gsc-regs.h    |   4 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |   4 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  38 ++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   7 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 126 ++++++++++++++++---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  29 +++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 119 +++++++++---------
 drivers/media/v4l2-core/videobuf2-core.c        |  26 +---
 11 files changed, 339 insertions(+), 223 deletions(-)

-- 
1.8.4

