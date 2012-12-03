Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55888 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab2LCRSR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2012 12:18:17 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1721938eek.19
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2012 09:18:16 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mkrufky@linuxtv.org
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] tda18271: add missing entries for qam_7 to tda18271_update_std_map() and tda18271_dump_std_map()
Date: Mon,  3 Dec 2012 18:18:02 +0100
Message-Id: <1354555082-11308-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/tuners/tda18271-fe.c |    2 ++
 1 Datei geändert, 2 Zeilen hinzugefügt(+)

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

