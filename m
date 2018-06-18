Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:51230 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752703AbeFREkf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 00:40:35 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 0/3] mem2mem: Cleanup .job_abort
Date: Mon, 18 Jun 2018 01:38:49 -0300
Message-Id: <20180618043852.13293-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here's the second version of this cleanup series.
Only those patches that haven't been picked are
being submitted. Therefore, just the .job_abort
change is here.

As requested by Hans, I am sending the changes
to rcar_jpu and s5p-g2d drivers independently
so they can be Acked by their maintainers.

The idea in this series is to make .job_abort optional.
Some drivers cannot implement anything rational in
.job_abort, so it does not make much sense for it to be
mandatory.

Regarding rcar and s5p drivers, job_abort is not expected
to wait for a job to complete, so the waits in these
drivers is not needed, and actually suboptimal.

Ezequiel Garcia (3):
  rcar_jpu: Remove unrequired wait in .job_abort
  s5p-g2d: Remove unrequired wait in .job_abort
  mem2mem: Make .job_abort optional

 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c |  5 -----
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c    |  5 -----
 drivers/media/platform/rcar_jpu.c               | 16 ----------------
 drivers/media/platform/rockchip/rga/rga.c       |  6 ------
 drivers/media/platform/s5p-g2d/g2d.c            | 16 ----------------
 drivers/media/platform/s5p-g2d/g2d.h            |  1 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c     |  7 -------
 drivers/media/v4l2-core/v4l2-mem2mem.c          |  6 +++---
 include/media/v4l2-mem2mem.h                    |  2 +-
 9 files changed, 4 insertions(+), 60 deletions(-)

-- 
2.16.3
