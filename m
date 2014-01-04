Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:56360 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbaADRIr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 12:08:47 -0500
Received: by mail-ee0-f49.google.com with SMTP id c41so7182441eek.36
        for <linux-media@vger.kernel.org>; Sat, 04 Jan 2014 09:08:45 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 09/11] libdvbv5: use TABLE_INIT macro
Date: Sat,  4 Jan 2014 18:07:59 +0100
Message-Id: <1388855282-19295-9-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
References: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/descriptors.h |    2 +-
 lib/libdvbv5/descriptors.c         |   24 +++++++++++++-----------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/descriptors.h
index d5feb4f..bc80940 100644
--- a/lib/include/libdvbv5/descriptors.h
+++ b/lib/include/libdvbv5/descriptors.h
@@ -35,7 +35,7 @@
 
 struct dvb_v5_fe_parms;
 
-typedef void (*dvb_table_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+typedef void (*dvb_table_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, void *table, ssize_t *table_length);
 
 struct dvb_table_init {
 	dvb_table_init_func init;
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 48f3fe7..c7d535c 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -78,18 +78,20 @@ static void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct d
 	hexdump(parms, "|           ", desc->data, desc->length);
 }
 
+#define TABLE_INIT( _x ) { (dvb_table_init_func) _x##_init, sizeof(struct _x) }
+
 const struct dvb_table_init dvb_table_initializers[] = {
-	[DVB_TABLE_PAT]          = { dvb_table_pat_init, sizeof(struct dvb_table_pat) },
-	[DVB_TABLE_CAT]          = { dvb_table_cat_init, sizeof(struct dvb_table_cat) },
-	[DVB_TABLE_PMT]          = { dvb_table_pmt_init, sizeof(struct dvb_table_pmt) },
-	[DVB_TABLE_NIT]          = { dvb_table_nit_init, sizeof(struct dvb_table_nit) },
-	[DVB_TABLE_SDT]          = { dvb_table_sdt_init, sizeof(struct dvb_table_sdt) },
-	[DVB_TABLE_EIT]          = { dvb_table_eit_init, sizeof(struct dvb_table_eit) },
-	[DVB_TABLE_EIT_SCHEDULE] = { dvb_table_eit_init, sizeof(struct dvb_table_eit) },
-	[ATSC_TABLE_MGT]         = { atsc_table_mgt_init, sizeof(struct atsc_table_mgt) },
-	[ATSC_TABLE_EIT]         = { atsc_table_eit_init, sizeof(struct atsc_table_eit) },
-	[ATSC_TABLE_TVCT]        = { atsc_table_vct_init, sizeof(struct atsc_table_vct) },
-	[ATSC_TABLE_CVCT]        = { atsc_table_vct_init, sizeof(struct atsc_table_vct) },
+	[DVB_TABLE_PAT]          = TABLE_INIT(dvb_table_pat),
+	[DVB_TABLE_CAT]          = TABLE_INIT(dvb_table_cat),
+	[DVB_TABLE_PMT]          = TABLE_INIT(dvb_table_pmt),
+	[DVB_TABLE_NIT]          = TABLE_INIT(dvb_table_nit),
+	[DVB_TABLE_SDT]          = TABLE_INIT(dvb_table_sdt),
+	[DVB_TABLE_EIT]          = TABLE_INIT(dvb_table_eit),
+	[DVB_TABLE_EIT_SCHEDULE] = TABLE_INIT(dvb_table_eit),
+	[ATSC_TABLE_MGT]         = TABLE_INIT(atsc_table_mgt),
+	[ATSC_TABLE_EIT]         = TABLE_INIT(atsc_table_eit),
+	[ATSC_TABLE_TVCT]        = TABLE_INIT(atsc_table_vct),
+	[ATSC_TABLE_CVCT]        = TABLE_INIT(atsc_table_vct),
 };
 
 char *default_charset = "iso-8859-1";
-- 
1.7.10.4

