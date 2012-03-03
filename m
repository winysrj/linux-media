Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33406 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2CCP2D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2012 10:28:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 05/10] mt9m032: Enclose to_dev() macro argument in brackets
Date: Sat,  3 Mar 2012 16:28:10 +0100
Message-Id: <1330788495-18762-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com>
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

