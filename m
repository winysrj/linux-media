Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:44181 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752037AbdHHLYC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 07:24:02 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Helen Koike <helen.koike@collabora.com>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] [media] vimc: constify video_subdev structures
Date: Tue,  8 Aug 2017 12:58:28 +0200
Message-Id: <1502189912-28794-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These structures are all only stored in fields of v4l2_subdev_ops
structures, all of which are const, so these structures can be const
as well.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/platform/vimc/vimc-debayer.c |    2 +-
 drivers/media/platform/vimc/vimc-scaler.c  |    2 +-
 drivers/media/platform/vimc/vimc-sensor.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
index 033a131..4d663e8 100644
--- a/drivers/media/platform/vimc/vimc-debayer.c
+++ b/drivers/media/platform/vimc/vimc-debayer.c
@@ -373,7 +373,7 @@ static int vimc_deb_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static struct v4l2_subdev_video_ops vimc_deb_video_ops = {
+static const struct v4l2_subdev_video_ops vimc_deb_video_ops = {
 	.s_stream = vimc_deb_s_stream,
 };
 
diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
index 0a3e086..e1602e0 100644
--- a/drivers/media/platform/vimc/vimc-scaler.c
+++ b/drivers/media/platform/vimc/vimc-scaler.c
@@ -267,7 +267,7 @@ static int vimc_sca_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static struct v4l2_subdev_video_ops vimc_sca_video_ops = {
+static const struct v4l2_subdev_video_ops vimc_sca_video_ops = {
 	.s_stream = vimc_sca_s_stream,
 };
 
diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 615c2b1..02e68c8 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -282,7 +282,7 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static struct v4l2_subdev_video_ops vimc_sen_video_ops = {
+static const struct v4l2_subdev_video_ops vimc_sen_video_ops = {
 	.s_stream = vimc_sen_s_stream,
 };
 
