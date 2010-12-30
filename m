Return-path: <mchehab@gaivota>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59254 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab0L3XIr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 18:08:47 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	spi-devel-general@lists.sourceforge.net,
	devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 12/15]drivers:media:video:tvp7002.c Typo change diable to disable.
Date: Thu, 30 Dec 2010 15:08:01 -0800
Message-Id: <1293750484-1161-12-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1293750484-1161-11-git-send-email-justinmattock@gmail.com>
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-3-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-4-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-5-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-6-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-7-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-8-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-9-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-10-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-11-git-send-email-justinmattock@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The below patch fixes a typo "diable" to "disable". Please let me know if this 
is correct or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/video/tvp7002.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/tvp7002.c b/drivers/media/video/tvp7002.c
index e63b40f..c799e4e 100644
--- a/drivers/media/video/tvp7002.c
+++ b/drivers/media/video/tvp7002.c
@@ -789,7 +789,7 @@ static int tvp7002_query_dv_preset(struct v4l2_subdev *sd,
  * Get the value of a TVP7002 decoder device register.
  * Returns zero when successful, -EINVAL if register read fails or
  * access to I2C client fails, -EPERM if the call is not allowed
- * by diabled CAP_SYS_ADMIN.
+ * by disabled CAP_SYS_ADMIN.
  */
 static int tvp7002_g_register(struct v4l2_subdev *sd,
 						struct v4l2_dbg_register *reg)
-- 
1.6.5.2.180.gc5b3e

