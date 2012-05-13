Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42304 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab2EMMSR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 08:18:17 -0400
Received: by wibhn6 with SMTP id hn6so1584101wib.1
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 05:18:16 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 4/8] use extern C for c++
Date: Sun, 13 May 2012 14:17:26 +0200
Message-Id: <1336911450-23661-4-git-send-email-neolynx@gmail.com>
In-Reply-To: <1336911450-23661-1-git-send-email-neolynx@gmail.com>
References: <1336911450-23661-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 lib/include/dvb-fe.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index a453424..4207ffe 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -88,6 +88,10 @@ struct dvb_v5_fe_parms {
 
 /* Open/close methods */
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend,
 				    unsigned verbose, unsigned use_legacy_call);
 void dvb_fe_close(struct dvb_v5_fe_parms *parms);
@@ -150,6 +154,10 @@ int dvb_fe_diseqc_cmd(struct dvb_v5_fe_parms *parms, const unsigned len,
 int dvb_fe_diseqc_reply(struct dvb_v5_fe_parms *parms, unsigned *len, char *buf,
 		       int timeout);
 
+#ifdef __cplusplus
+}
+#endif
+
 /* Arrays from dvb-v5.h */
 
 extern const unsigned fe_bandwidth_name[8];
-- 
1.7.2.5

