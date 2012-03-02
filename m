Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46838 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab2CBKn6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 05:43:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v2 05/10] mt9m032: Enclose to_dev() macro argument in brackets
Date: Fri,  2 Mar 2012 11:44:02 +0100
Message-Id: <1330685047-12742-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1330685047-12742-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1330685047-12742-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To make the macro safer to use, enclose its argument in brackets in the
macro's body.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9m032.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index a821b91..74f0cdd 100644
--- a/drivers/media/video/mt9m032.c
+++ b/drivers/media/video/mt9m032.c
@@ -121,7 +121,8 @@ struct mt9m032 {
 };
 
 #define to_mt9m032(sd)	container_of(sd, struct mt9m032, subdev)
-#define to_dev(sensor)	&((struct i2c_client *)v4l2_get_subdevdata(&sensor->subdev))->dev
+#define to_dev(sensor) \
+	(&((struct i2c_client *)v4l2_get_subdevdata(&(sensor)->subdev))->dev)
 
 static int mt9m032_read_reg(struct mt9m032 *sensor, u8 reg)
 {
-- 
1.7.3.4

