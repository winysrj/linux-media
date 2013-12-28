Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:38096 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab3L1PqV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 10:46:21 -0500
Received: by mail-ee0-f54.google.com with SMTP id e51so3819469eek.27
        for <linux-media@vger.kernel.org>; Sat, 28 Dec 2013 07:46:20 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 05/13] libdvbv5: eit parsing updated
Date: Sat, 28 Dec 2013 16:45:53 +0100
Message-Id: <1388245561-8751-5-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors.h      |  6 ++++++
 lib/include/descriptors/eit.h  |  1 +
 lib/include/dvb-fe.h           |  2 ++
 lib/libdvbv5/descriptors.c     |  1 +
 lib/libdvbv5/descriptors/eit.c | 28 +++++++++++++++++++++++-----
 lib/libdvbv5/dvb-fe.c          |  7 +++++++
 lib/libdvbv5/dvb-scan.c        | 22 +++++++---------------
 7 files changed, 47 insertions(+), 20 deletions(-)

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
diff --git a/lib/include/descriptors/eit.h b/lib/include/descriptors/eit.h
index 2af9696..d2ebdb4 100644
--- a/lib/include/descriptors/eit.h
+++ b/lib/include/descriptors/eit.h
@@ -56,6 +56,7 @@ struct dvb_table_eit_event {
 	struct dvb_table_eit_event *next;
 	struct tm start;
 	uint32_t duration;
+	uint16_t service_id;
 } __attribute__((packed));
 
 struct dvb_table_eit {
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
index 437b2f4..18884b0 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -69,6 +69,7 @@ void dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, st
 
 void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
+	if (!parms) parms = dvb_fe_dummy();
 	dvb_log("|                   %s (%#02x)", dvb_descriptors[desc->type].name, desc->type);
 	hexdump(parms, "|                       ", desc->data, desc->length);
 }
diff --git a/lib/libdvbv5/descriptors/eit.c b/lib/libdvbv5/descriptors/eit.c
index ccfe1a6..d13b14c 100644
--- a/lib/libdvbv5/descriptors/eit.c
+++ b/lib/libdvbv5/descriptors/eit.c
@@ -29,6 +29,11 @@ void dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize
 	struct dvb_table_eit_event **head;
 
 	if (*table_length > 0) {
+		memcpy(eit, p, sizeof(struct dvb_table_eit) - sizeof(eit->event));
+
+		bswap16(eit->transport_id);
+		bswap16(eit->network_id);
+
 		/* find end of curent list */
 		head = &eit->event;
 		while (*head != NULL)
@@ -48,8 +53,18 @@ void dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize
 	struct dvb_table_eit_event *last = NULL;
 	while ((uint8_t *) p < buf + buflen - 4) {
 		struct dvb_table_eit_event *event = (struct dvb_table_eit_event *) malloc(sizeof(struct dvb_table_eit_event));
-		memcpy(event, p, sizeof(struct dvb_table_eit_event) - sizeof(event->descriptor) - sizeof(event->next) - sizeof(event->start) - sizeof(event->duration));
-		p += sizeof(struct dvb_table_eit_event) - sizeof(event->descriptor) - sizeof(event->next) - sizeof(event->start) - sizeof(event->duration);
+		memcpy(event, p, sizeof(struct dvb_table_eit_event) -
+				 sizeof(event->descriptor) -
+				 sizeof(event->next) -
+				 sizeof(event->start) -
+				 sizeof(event->duration) -
+				 sizeof(event->service_id));
+		p += sizeof(struct dvb_table_eit_event) -
+		     sizeof(event->descriptor) -
+		     sizeof(event->next) -
+		     sizeof(event->start) -
+		     sizeof(event->duration) -
+		     sizeof(event->service_id);
 
 		bswap16(event->event_id);
 		bswap16(event->bitfield);
@@ -57,9 +72,11 @@ void dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize
 		event->descriptor = NULL;
 		event->next = NULL;
 		dvb_time(event->dvbstart, &event->start);
-		event->duration = bcd(event->dvbduration[0]) * 3600 +
-				  bcd(event->dvbduration[1]) * 60 +
-				  bcd(event->dvbduration[2]);
+		event->duration = bcd((uint32_t) event->dvbduration[0]) * 3600 +
+				  bcd((uint32_t) event->dvbduration[1]) * 60 +
+				  bcd((uint32_t) event->dvbduration[2]);
+
+		event->service_id = eit->header.id;
 
 		if(!*head)
 			*head = event;
@@ -102,6 +119,7 @@ void dvb_table_eit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_eit *ei
 		char start[255];
 		strftime(start, sizeof(start), "%F %T", &event->start);
 		dvb_log("|- %7d", event->event_id);
+		dvb_log("|   Service               %d", event->service_id);
 		dvb_log("|   Start                 %s UTC", start);
 		dvb_log("|   Duration              %dh %dm %ds", event->duration / 3600, (event->duration % 3600) / 60, event->duration % 60);
 		dvb_log("|   free CA mode          %d", event->free_CA_mode);
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
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 9751f9d..421434e 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -102,7 +102,7 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 	int start_section = -1;
 	int first_section = -1;
 	int last_section = -1;
-	int table_id = -1;
+	/*int table_id = -1;*/
 	int sections = 0;
 	struct dmx_sct_filter_params f;
 	struct dvb_table_header *h;
@@ -112,7 +112,6 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 	*table = NULL;
 
 	// FIXME: verify known table
-
 	memset(&f, 0, sizeof(f));
 	f.pid = pid;
 	f.filter.filter[0] = tid;
@@ -202,21 +201,11 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 			continue;
 		}
 
-		/*if (id != -1) {*/
-			/*if (table_id == -1)*/
-				/*table_id = h->id;*/
-			/*else if (h->id != table_id) {*/
-				/*dvb_logwarn("dvb_read_section: table ID mismatch reading multi section table: %d != %d", h->id, table_id);*/
-				/*free(buf);*/
-				/*continue;*/
-			/*}*/
-		/*}*/
-
-		dvb_logerr("dvb_read_section: got section %d, last %di, filter %d", h->section_id, h->last_section, id );
+		/*dvb_logerr("dvb_read_section: got section %d, last %d, filter %d", h->section_id, h->last_section, id );*/
 		/* handle the sections */
 		if (first_section == -1)
 			first_section = h->section_id;
-		else if (h->section_id == first_section)
+		else if (start_id == h->id && h->section_id == first_section)
 			break;
 
 		if (last_section == -1)
@@ -248,8 +237,11 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 		if (id != -1 && ++sections == last_section + 1) {
 			dvb_logerr("dvb_read_section: ++sections == last_section + 1");
 			break;
+		}
 	}
-	free(buf);
+
+	if (buf)
+		free(buf);
 
 	dvb_dmx_stop(dmx_fd);
 
-- 
1.8.3.2

