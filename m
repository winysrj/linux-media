Return-path: <linux-media-owner@vger.kernel.org>
Received: from zose-mta11.web4all.fr ([178.33.204.87]:33360 "EHLO
	zose-mta11.web4all.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759696Ab3BZSkm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 13:40:42 -0500
From: =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?=
	<benoit.thebaudeau@advansee.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?=
	<benoit.thebaudeau@advansee.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	=?UTF-8?q?Micka=C3=ABl=20Guivarc=27h?=
	<mickael.guivarch@advansee.com>, <linux-media@vger.kernel.org>
Subject: [PATCH] soc-camera: mt9m111: Fix auto-exposure control
Date: Tue, 26 Feb 2013 19:32:49 +0100
Message-Id: <1361903569-30244-1-git-send-email-benoit.thebaudeau@advansee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit f9bd5843658e18a7097fc7258c60fb840109eaa8 changed V4L2_CID_EXPOSURE_AUTO
from boolean to enum, and commit af8425c54beb3c32cbb503a379132b3975535289
changed the creation of this control into a menu for the mt9m111. However,
mt9m111_set_autoexposure() is still interpreting the value set for this control
as a boolean, which also conflicts with the default value of this control set to
V4L2_EXPOSURE_AUTO (0).

This patch makes mt9m111_set_autoexposure() interpret the value set for
V4L2_CID_EXPOSURE_AUTO as defined by enum v4l2_exposure_auto_type.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mickaël Guivarc'h <mickael.guivarch@advansee.com>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 drivers/media/i2c/soc_camera/mt9m111.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index bbc4ff9..0b0ebaa 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -701,11 +701,11 @@ static int mt9m111_set_global_gain(struct mt9m111 *mt9m111, int gain)
 	return reg_write(GLOBAL_GAIN, val);
 }
 
-static int mt9m111_set_autoexposure(struct mt9m111 *mt9m111, int on)
+static int mt9m111_set_autoexposure(struct mt9m111 *mt9m111, int val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 
-	if (on)
+	if (val == V4L2_EXPOSURE_AUTO)
 		return reg_set(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
 	return reg_clear(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
 }
-- 
1.7.10.4

