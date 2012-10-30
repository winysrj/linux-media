Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61018 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2J3NpB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 09:45:01 -0400
Received: by mail-qa0-f46.google.com with SMTP id c26so2159143qad.19
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2012 06:45:00 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 30 Oct 2012 21:45:00 +0800
Message-ID: <CAPgLHd-QVvRuOFHz0nLKgShmJ383sNs4HD6vxMi4ym75c-q-Zg@mail.gmail.com>
Subject: [PATCH] [media] vpif_capture: fix condition logic in vpif_capture.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@infradead.org, prabhakar.lad@ti.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The pattern E == C1 && E == C2 is always false. This patch
fix this according to the assumption that && should be ||.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/davinci/vpif_capture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index fcabc02..2d28a96 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1715,7 +1715,7 @@ vpif_enum_dv_timings(struct file *file, void *priv,
 	int ret;
 
 	ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
-	if (ret == -ENOIOCTLCMD && ret == -ENODEV)
+	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
 		return -EINVAL;
 	return ret;
 }
@@ -1735,7 +1735,7 @@ vpif_query_dv_timings(struct file *file, void *priv,
 	int ret;
 
 	ret = v4l2_subdev_call(ch->sd, video, query_dv_timings, timings);
-	if (ret == -ENOIOCTLCMD && ret == -ENODEV)
+	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
 		return -ENODATA;
 	return ret;
 }


