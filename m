Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:59749 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932886AbcGLLWF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 07:22:05 -0400
From: weiyj_lk@163.com
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org
Subject: [PATCH -next] [media] rcar_jpu: Add missing clk_disable_unprepare() on error in jpu_open()
Date: Tue, 12 Jul 2016 11:21:46 +0000
Message-Id: <1468322506-32702-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing clk_disable_unprepare() before return from
jpu_open() in the software reset error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/rcar_jpu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 16782ce..8e6c617 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1280,7 +1280,7 @@ static int jpu_open(struct file *file)
 		/* ...issue software reset */
 		ret = jpu_reset(jpu);
 		if (ret)
-			goto device_prepare_rollback;
+			goto jpu_reset_rollback;
 	}
 
 	jpu->ref_count++;
@@ -1288,6 +1288,8 @@ static int jpu_open(struct file *file)
 	mutex_unlock(&jpu->mutex);
 	return 0;
 
+jpu_reset_rollback:
+	clk_disable_unprepare(jpu->clk);
 device_prepare_rollback:
 	mutex_unlock(&jpu->mutex);
 v4l_prepare_rollback:


