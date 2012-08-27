Return-path: <linux-media-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56424 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab2H0HZZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Aug 2012 03:25:25 -0400
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 3/5] media:dvb:fix up ENOIOCTLCMD error handling
Date: Mon, 27 Aug 2012 15:23:14 +0800
Message-Id: <1346052196-32682-4-git-send-email-gaowanlong@cn.fujitsu.com>
In-Reply-To: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At commit 07d106d0, Linus pointed out that ENOIOCTLCMD should be
translated as ENOTTY to user mode.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/media/dvb/dvb-core/dvbdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index 39eab73..d33101a 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -420,7 +420,7 @@ int dvb_usercopy(struct file *file,
 	/* call driver */
 	mutex_lock(&dvbdev_mutex);
 	if ((err = func(file, cmd, parg)) == -ENOIOCTLCMD)
-		err = -EINVAL;
+		err = -ENOTTY;
 	mutex_unlock(&dvbdev_mutex);
 
 	if (err < 0)
-- 
1.7.12

