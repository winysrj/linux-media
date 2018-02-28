Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:43453 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964887AbeB1XUA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Feb 2018 18:20:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jacopo Mondi <jacopo@jmondi.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: renesas-ceu: mark PM functions as __maybe_unused
Date: Thu,  1 Mar 2018 00:19:37 +0100
Message-Id: <20180228231951.460060-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The PM runtime operations are unused when CONFIG_PM is disabled,
leading to a harmless warning:

drivers/media/platform/renesas-ceu.c:1003:12: error: 'ceu_runtime_suspend' defined but not used [-Werror=unused-function]
 static int ceu_runtime_suspend(struct device *dev)
            ^~~~~~~~~~~~~~~~~~~
drivers/media/platform/renesas-ceu.c:987:12: error: 'ceu_runtime_resume' defined but not used [-Werror=unused-function]
 static int ceu_runtime_resume(struct device *dev)
            ^~~~~~~~~~~~~~~~~~

This adds a __maybe_unused annotation to shut up the warning.

Fixes: 32e5a70dc8f4 ("media: platform: Add Renesas CEU driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/renesas-ceu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
index 22330c0c2f6a..eccd60a7ebec 100644
--- a/drivers/media/platform/renesas-ceu.c
+++ b/drivers/media/platform/renesas-ceu.c
@@ -984,7 +984,7 @@ static int ceu_init_mbus_fmt(struct ceu_device *ceudev)
 /*
  * ceu_runtime_resume() - soft-reset the interface and turn sensor power on.
  */
-static int ceu_runtime_resume(struct device *dev)
+static int __maybe_unused ceu_runtime_resume(struct device *dev)
 {
 	struct ceu_device *ceudev = dev_get_drvdata(dev);
 	struct v4l2_subdev *v4l2_sd = ceudev->sd->v4l2_sd;
@@ -1000,7 +1000,7 @@ static int ceu_runtime_resume(struct device *dev)
  * ceu_runtime_suspend() - disable capture and interrupts and soft-reset.
  *			   Turn sensor power off.
  */
-static int ceu_runtime_suspend(struct device *dev)
+static int __maybe_unused ceu_runtime_suspend(struct device *dev)
 {
 	struct ceu_device *ceudev = dev_get_drvdata(dev);
 	struct v4l2_subdev *v4l2_sd = ceudev->sd->v4l2_sd;
-- 
2.9.0
