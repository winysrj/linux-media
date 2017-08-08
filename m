Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:61984 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751927AbdHHLYB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 07:24:01 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-samsung-soc@vger.kernel.org
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] constify video_subdev structures
Date: Tue,  8 Aug 2017 12:58:26 +0200
Message-Id: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The structures of type v4l2_subdev_ops are only passed as the second
argument of v4l2_subdev_init or as the third argument of
v4l2_i2c_subdev_init, both of which are const.  The structures of type
v4l2_subdev_core_ops, v4l2_subdev_pad_ops, v4l2_subdev_sensor_ops,
v4l2_subdev_video_ops are only stored in fields of v4l2_subdev_ops
structures, all of which are const.  Thus all of these structures can be
declared as const as well.

Done with the help of Coccinelle.

---

 drivers/media/i2c/mt9m111.c                   |    6 +++---
 drivers/media/i2c/mt9t001.c                   |    8 ++++----
 drivers/media/platform/exynos4-is/fimc-isp.c  |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c |    2 +-
 drivers/media/platform/vimc/vimc-debayer.c    |    2 +-
 drivers/media/platform/vimc/vimc-scaler.c     |    2 +-
 drivers/media/platform/vimc/vimc-sensor.c     |    2 +-
 drivers/media/usb/uvc/uvc_entity.c            |    2 +-
 drivers/staging/media/atomisp/i2c/ap1302.c    |    2 +-
 drivers/staging/media/atomisp/i2c/mt9m114.c   |    2 +-
 10 files changed, 15 insertions(+), 15 deletions(-)
