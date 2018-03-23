Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46822 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754058AbeCWL5e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 25/30] media: vivid-radio-rx: add a cast to avoid a warning
Date: Fri, 23 Mar 2018 07:57:11 -0400
Message-Id: <5c804c6bc55bcfb217c8001b3ca49cca0f9e7047.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic at vivid_radio_rx_g_tuner() is producint an overflow
warning:

	drivers/media/platform/vivid/vivid-radio-rx.c:250 vivid_radio_rx_g_tuner() warn: potential negative subtraction from max '65535 - (__builtin_choose_expr( ==  ||  == , , __builtin_choose_expr( ==  ||  == , , __builtin_choose_expr( ==  ||  == , , __builtin_choose_expr( ==  ||  == , , __builtin_choose_expr( ==  ||  == , , __builtin_choose_expr( == , , (0))))))) * 65535) / delta'

Add a cast to prevent that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/vivid/vivid-radio-rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-radio-rx.c b/drivers/media/platform/vivid/vivid-radio-rx.c
index acbfea2cce76..1f86d7d4f72f 100644
--- a/drivers/media/platform/vivid/vivid-radio-rx.c
+++ b/drivers/media/platform/vivid/vivid-radio-rx.c
@@ -247,7 +247,7 @@ int vivid_radio_rx_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt)
 	vt->rangehigh = FM_FREQ_RANGE_HIGH;
 	sig_qual = dev->radio_rx_sig_qual;
 	vt->signal = abs(sig_qual) > delta ? 0 :
-		     0xffff - (abs(sig_qual) * 0xffff) / delta;
+		     0xffff - ((unsigned)abs(sig_qual) * 0xffff) / delta;
 	vt->afc = sig_qual > delta ? 0 : sig_qual;
 	if (abs(sig_qual) > delta)
 		vt->rxsubchans = 0;
-- 
2.14.3
