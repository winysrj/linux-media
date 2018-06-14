Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55316 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755269AbeFNPfo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 11:35:44 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 0/3] mem2mem low-hanging fruit removal
Date: Thu, 14 Jun 2018 12:34:02 -0300
Message-Id: <20180614153405.5697-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While working with memory-to-memory drivers, noticed some
minor cleaning opportunities.

First, the lock/unlock v4l2_m2m_ops are no longer in use,
and can be dropped.

Second, the job_abort v4l2_m2m_ops is not really used
by some drivers, and so it makes sense to make it
optional.

This series is based on https://patchwork.kernel.org/patch/10444325/.

Ezequiel Garcia (3):
  mem2mem: Remove unused v4l2_m2m_ops .lock/.unlock
  mem2mem: Make .job_abort optional
  rcar_vpu: Drop unneeded job_ready

 drivers/media/platform/coda/coda-common.c          | 26 ++++------------------
 drivers/media/platform/m2m-deinterlace.c           | 20 ++---------------
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    |  5 -----
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       |  5 -----
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 18 ---------------
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 16 -------------
 drivers/media/platform/mx2_emmaprp.c               | 16 -------------
 drivers/media/platform/rcar_jpu.c                  | 22 ------------------
 drivers/media/platform/rockchip/rga/rga.c          |  6 -----
 drivers/media/platform/s5p-g2d/g2d.c               | 14 ------------
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  7 ------
 drivers/media/platform/sti/delta/delta-v4l2.c      | 18 ---------------
 drivers/media/platform/ti-vpe/vpe.c                | 19 ----------------
 drivers/media/v4l2-core/v4l2-mem2mem.c             |  6 ++---
 include/media/v4l2-mem2mem.h                       |  8 +------
 15 files changed, 10 insertions(+), 196 deletions(-)

-- 
2.16.3
