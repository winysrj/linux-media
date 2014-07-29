Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:47068 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbaG2XWJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 19:22:09 -0400
From: weiyj_lk@163.com
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org
Subject: [PATCH -next] [media] radio-miropcm20: fix sparse NULL pointer warning
Date: Wed, 30 Jul 2014 07:21:59 +0800
Message-Id: <1406676119-26537-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

drivers/media/radio/radio-miropcm20.c:193:33: warning:
 Using plain integer as NULL pointer

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/radio/radio-miropcm20.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index ac9915d..998919e 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -190,7 +190,7 @@ static int pcm20_setfreq(struct pcm20 *dev, unsigned long freq)
 	freql = freq & 0xff;
 	freqh = freq >> 8;
 
-	rds_cmd(aci, RDS_RESET, 0, 0);
+	rds_cmd(aci, RDS_RESET, NULL, 0);
 	return snd_aci_cmd(aci, ACI_WRITE_TUNE, freql, freqh);
 }
 

