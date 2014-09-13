Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50375 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaIMVA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Sep 2014 17:00:59 -0400
Received: by mail-wg0-f46.google.com with SMTP id n12so2253490wgh.29
        for <linux-media@vger.kernel.org>; Sat, 13 Sep 2014 14:00:57 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH] libdvbv5: fix dvb_fe_dummy()
Date: Sat, 13 Sep 2014 23:00:36 +0200
Message-Id: <1410642036-26083-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

initialize the parms structure correctly

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/dvb-fe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 6745694..f733b27 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -43,6 +43,9 @@ struct dvb_v5_fe_parms *dvb_fe_dummy()
 	if (!parms)
 		return NULL;
 	parms->p.logfunc = dvb_default_log;
+	parms->fd = -1;
+	parms->p.default_charset = "iso-8859-1";
+	parms->p.output_charset = "utf-8";
 	return &parms->p;
 }
 
-- 
1.9.1

