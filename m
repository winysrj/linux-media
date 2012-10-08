Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64089 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2JHMcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 08:32:48 -0400
Received: by mail-qc0-f174.google.com with SMTP id d3so2796008qch.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 05:32:48 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 20:32:48 +0800
Message-ID: <CAPgLHd-0c4D0cSVQBZA=bbaDvcu4yHBj_2DPPGrQMKQZxxGqBg@mail.gmail.com>
Subject: [PATCH] [media] s5p-tv: remove unused including <linux/version.h>
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kyungmin.park@samsung.com, t.stanislaws@samsung.com,
	mchehab@infradead.org
Cc: yongjun_wei@trendmicro.com.cn,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/s5p-tv/mixer_video.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 0c1cd89..9b52f3a 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -19,7 +19,6 @@
 #include <linux/videodev2.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/timer.h>
 #include <media/videobuf2-dma-contig.h>
 

