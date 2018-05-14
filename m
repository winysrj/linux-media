Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:59745 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932169AbeENNNv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 09:13:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/7] Fix compiler/sparse warnings
Date: Mon, 14 May 2018 15:13:39 +0200
Message-Id: <20180514131346.15795-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

After upgrading to gcc 8.1 we got new warnings. This series
fixes them.

There is a remaining warning in atomisp, but that's going to
be removed from staging anyway.

Regards,

	Hans

Hans Verkuil (7):
  go7007: fix two sparse warnings
  zoran: fix compiler warning
  s5p-mfc: fix two sparse warnings
  hdpvr: fix compiler warning
  imx: fix compiler warning
  renesas-ceu: fix compiler warning
  soc_camera: fix compiler warning

 drivers/media/platform/renesas-ceu.c                    | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c            | 4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c            | 4 ++--
 drivers/media/platform/soc_camera/soc_camera_platform.c | 3 ++-
 drivers/media/usb/go7007/go7007-fw.c                    | 3 +++
 drivers/media/usb/go7007/go7007-v4l2.c                  | 2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c                   | 2 +-
 drivers/staging/media/imx/imx-media-capture.c           | 4 ++--
 drivers/staging/media/zoran/zoran_driver.c              | 4 ++--
 9 files changed, 16 insertions(+), 12 deletions(-)

-- 
2.17.0
