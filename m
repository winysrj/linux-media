Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:62468 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab3L3Mt2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 07:49:28 -0500
Received: by mail-ee0-f48.google.com with SMTP id e49so4963353eek.21
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 04:49:27 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 06/18] libdvbv5: implement dvb_fe_dummy for logging
Date: Mon, 30 Dec 2013 13:48:39 +0100
Message-Id: <1388407731-24369-6-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvbv5 functions use the dvb_v5_fe_parms struct for logging.
This struct is normally obtained by opening a dvb device. For
situations where the opening of a dvb device is not desired,
the dvb_fe_dummy can be used.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors.h  | 6 ++++++
 lib/include/dvb-fe.h       | 2 ++
 lib/libdvbv5/descriptors.c | 2 ++
 lib/libdvbv5/dvb-fe.c      | 7 +++++++
 4 files changed, 17 insertions(+)

diff --git a/lib/include/descriptors.h b/lib/include/descriptors.h
index 5ab29a0..6f89aeb 100644
--- a/lib/include/descriptors.h
+++ b/lib/include/descriptors.h
@@ -63,7 +63,13 @@ struct dvb_desc {
 } __attribute__((packed));
 
 void dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+#ifdef __cplusplus
+extern "C" {
+#endif
 void dvb_desc_default_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+#ifdef __cplusplus
+}
+#endif
 
 #define dvb_desc_foreach( _desc, _tbl ) \
 	for( struct dvb_desc *_desc = _tbl->descriptor; _desc; _desc = _desc->next ) \
diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index b0e2bf9..8cf2697 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -119,6 +119,8 @@ struct dvb_v5_fe_parms {
 extern "C" {
 #endif
 
+struct dvb_v5_fe_parms *dvb_fe_dummy();
+
 struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend,
 				    unsigned verbose, unsigned use_legacy_call);
 struct dvb_v5_fe_parms *dvb_fe_open2(int adapter, int frontend,
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 437b2f4..bc3d51a 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -69,6 +69,8 @@ void dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, st
 
 void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
+	if (!parms)
+		parms = dvb_fe_dummy();
 	dvb_log("|                   %s (%#02x)", dvb_descriptors[desc->type].name, desc->type);
 	hexdump(parms, "|                       ", desc->data, desc->length);
 }
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index cc32ec0..4672267 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -35,6 +35,13 @@ static void dvb_v5_free(struct dvb_v5_fe_parms *parms)
 	free(parms);
 }
 
+struct dvb_v5_fe_parms dummy_fe;
+struct dvb_v5_fe_parms *dvb_fe_dummy()
+{
+	dummy_fe.logfunc = dvb_default_log;
+	return &dummy_fe;
+}
+
 struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend, unsigned verbose,
 				    unsigned use_legacy_call)
 {
-- 
1.8.3.2

