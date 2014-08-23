Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57938 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaHWQnL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Aug 2014 12:43:11 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so11317813wgh.13
        for <linux-media@vger.kernel.org>; Sat, 23 Aug 2014 09:43:10 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 5/5] libdvbv5: Make dummy_fe static
Date: Sat, 23 Aug 2014 18:42:43 +0200
Message-Id: <1408812163-18309-6-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1408812163-18309-1-git-send-email-gjasny@googlemail.com>
References: <1408812163-18309-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 lib/libdvbv5/dvb-fe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 6471f68..c260674 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -35,7 +35,7 @@ static void dvb_v5_free(struct dvb_v5_fe_parms *parms)
 	free(parms);
 }
 
-struct dvb_v5_fe_parms dummy_fe;
+static struct dvb_v5_fe_parms dummy_fe;
 struct dvb_v5_fe_parms *dvb_fe_dummy()
 {
 	dummy_fe.logfunc = dvb_default_log;
-- 
2.1.0

