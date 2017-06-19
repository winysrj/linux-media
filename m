Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56952 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752434AbdFSRCW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 13:02:22 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, jgebben@codeaurora.org,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v5 12/12] [media] vimc: sen: Declare vimc_sen_video_ops as static
Date: Mon, 19 Jun 2017 14:00:21 -0300
Message-Id: <1497891629-1562-13-git-send-email-helen.koike@collabora.com>
In-Reply-To: <1497891629-1562-1-git-send-email-helen.koike@collabora.com>
References: <1497891629-1562-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Declare vimc_sen_video_ops as static, remove warning from sparse tool

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Changes in v5:
[media] vimc: sen: Declare vimc_sen_video_ops as static
	- This is a new patch in the series

Changes in v4: None
Changes in v3: None
Changes in v2: None


---
 drivers/media/platform/vimc/vimc-sensor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 5ea7b08..ebdbbe8 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -282,7 +282,7 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-struct v4l2_subdev_video_ops vimc_sen_video_ops = {
+static struct v4l2_subdev_video_ops vimc_sen_video_ops = {
 	.s_stream = vimc_sen_s_stream,
 };
 
-- 
2.7.4
