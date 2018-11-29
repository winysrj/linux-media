Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbeK2RAQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 12:00:16 -0500
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/68] media: vicodec: lower minimum height to 360
Date: Thu, 29 Nov 2018 00:54:52 -0500
Message-Id: <20181129055559.159228-1-sashal@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit 7cf7b2e977abf3f992036939e35a8eab60013aff ]

Lower the minimum height to 360 to be consistent with the webcam input of vivid.

The 480 was rather arbitrary but it made it harder to use vivid as a source for
encoding since the default resolution when you load vivid is 640x360.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vicodec/vicodec-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 408cd55d3580..daa5caa6adc6 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -42,7 +42,7 @@ MODULE_PARM_DESC(debug, " activates debug info");
 #define MAX_WIDTH		4096U
 #define MIN_WIDTH		640U
 #define MAX_HEIGHT		2160U
-#define MIN_HEIGHT		480U
+#define MIN_HEIGHT		360U
 
 #define dprintk(dev, fmt, arg...) \
 	v4l2_dbg(1, debug, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
-- 
2.17.1
