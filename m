Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58634 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbeKTUsZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 15:48:25 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jaedon Shin <jaedon.shin@gmail.com>
Subject: [PATCH 1/3] media: dvb_frontend: don't print function names twice
Date: Tue, 20 Nov 2018 08:19:34 -0200
Message-Id: <dc0f3b757454e974eefe7795fbafc7b5cd0f5431.1542709160.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb_frontend dprintk() macro already prints __func__. So,
we don't need to add it again at the printed message.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 961207cf09eb..2a26f9210394 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2587,8 +2587,8 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 			u8 last = 1;
 
 			if (dvb_frontend_debug)
-				dprintk("%s switch command: 0x%04lx\n",
-					__func__, swcmd);
+				dprintk("switch command: 0x%04lx\n",
+					swcmd);
 			nexttime = ktime_get_boottime();
 			if (dvb_frontend_debug)
 				tv[0] = nexttime;
@@ -2611,8 +2611,8 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 					dvb_frontend_sleep_until(&nexttime, 8000);
 			}
 			if (dvb_frontend_debug) {
-				dprintk("%s(%d): switch delay (should be 32k followed by all 8k)\n",
-					__func__, fe->dvb->num);
+				dprintk("(adapter %d): switch delay (should be 32k followed by all 8k)\n",
+					fe->dvb->num);
 				for (i = 1; i < 10; i++)
 					pr_info("%d: %d\n", i,
 						(int)ktime_us_delta(tv[i], tv[i - 1]));
-- 
2.19.1
