Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55759 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab2J3Ntj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 09:49:39 -0400
Received: by mail-qc0-f174.google.com with SMTP id o22so159658qcr.19
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2012 06:49:38 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 30 Oct 2012 21:49:38 +0800
Message-ID: <CAPgLHd-p6=0ay8ZKJ=sNzyS5C6x0dJTH=EO1SqwiYciO2gTUJg@mail.gmail.com>
Subject: [PATCH] [media] vpif_display: fix condition logic in vpif_enum_dv_timings()
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
 drivers/media/platform/davinci/vpif_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index b716fbd..977ee43 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1380,7 +1380,7 @@ vpif_enum_dv_timings(struct file *file, void *priv,
 	int ret;
 
 	ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
-	if (ret == -ENOIOCTLCMD && ret == -ENODEV)
+	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
 		return -EINVAL;
 	return ret;
 }


