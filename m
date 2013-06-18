Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:40303 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab3FRFAT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 01:00:19 -0400
Received: by mail-bk0-f50.google.com with SMTP id ik8so1519034bkc.23
        for <linux-media@vger.kernel.org>; Mon, 17 Jun 2013 22:00:17 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 18 Jun 2013 13:00:17 +0800
Message-ID: <CAPgLHd9hFGfuQ2Esm-7C1YdSgWojDJRADwv8_m5DnJ6UAFJtpQ@mail.gmail.com>
Subject: [PATCH -next] [media] coda: fix missing unlock on error in coda_stop_streaming()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@redhat.com, grant.likely@linaro.org,
	rob.herring@calxeda.com, p.zabel@pengutronix.de,
	javier.martin@vista-silicon.com, k.debski@samsung.com,
	hans.verkuil@cisco.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function coda_stop_streaming()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/coda.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index df4ada88..2c3cd17 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1347,6 +1347,7 @@ static int coda_stop_streaming(struct vb2_queue *q)
 	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
 		v4l2_err(&dev->v4l2_dev,
 			 "CODA_COMMAND_SEQ_END failed\n");
+		mutex_unlock(&dev->coda_mutex);
 		return -ETIMEDOUT;
 	}
 	mutex_unlock(&dev->coda_mutex);

