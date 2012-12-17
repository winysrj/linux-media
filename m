Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:3475 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2LQBSQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 20:18:16 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com,
	=?UTF-8?q?Frank=20Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH] tda18271: add missing entries for qam_7 to tda18271_update_std_map() and tda18271_dump_std_map()
Date: Sun, 16 Dec 2012 20:17:48 -0500
Message-Id: <1355707068-25751-1-git-send-email-mkrufky@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Frank Schäfer <fschaefer.oss@googlemail.com>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/tuners/tda18271-fe.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
index 72c26fd..e778686 100644
--- a/drivers/media/tuners/tda18271-fe.c
+++ b/drivers/media/tuners/tda18271-fe.c
@@ -1122,6 +1122,7 @@ static int tda18271_dump_std_map(struct dvb_frontend *fe)
 	tda18271_dump_std_item(dvbt_7, "dvbt 7");
 	tda18271_dump_std_item(dvbt_8, "dvbt 8");
 	tda18271_dump_std_item(qam_6,  "qam 6 ");
+	tda18271_dump_std_item(qam_7,  "qam 7 ");
 	tda18271_dump_std_item(qam_8,  "qam 8 ");
 
 	return 0;
@@ -1149,6 +1150,7 @@ static int tda18271_update_std_map(struct dvb_frontend *fe,
 	tda18271_update_std(dvbt_7, "dvbt 7");
 	tda18271_update_std(dvbt_8, "dvbt 8");
 	tda18271_update_std(qam_6,  "qam 6");
+	tda18271_update_std(qam_7,  "qam 7");
 	tda18271_update_std(qam_8,  "qam 8");
 
 	return 0;
-- 
1.7.10.4

