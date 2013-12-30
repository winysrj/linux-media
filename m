Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:61572 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab3L3Mtg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 07:49:36 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so4969241eae.5
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 04:49:35 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 15/18] libdvbv5: remove c99 comments
Date: Mon, 30 Dec 2013 13:48:48 +0100
Message-Id: <1388407731-24369-15-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/descriptors/atsc_eit.c              |  2 +-
 lib/libdvbv5/descriptors/desc_service_list.c     |  4 +++-
 lib/libdvbv5/descriptors/desc_service_location.c |  2 +-
 lib/libdvbv5/dvb-file.c                          | 21 +++++++++++----------
 lib/libdvbv5/dvb-log.c                           |  2 +-
 lib/libdvbv5/dvb-sat.c                           |  2 --
 lib/libdvbv5/dvb-scan.c                          |  4 ++--
 7 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/lib/libdvbv5/descriptors/atsc_eit.c b/lib/libdvbv5/descriptors/atsc_eit.c
index 4ee38ae..8d3791d 100644
--- a/lib/libdvbv5/descriptors/atsc_eit.c
+++ b/lib/libdvbv5/descriptors/atsc_eit.c
@@ -68,7 +68,7 @@ void atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssiz
                 atsc_time(event->start_time, &event->start);
 		event->source_id = eit->header.id;
 
-                //FIXME: title
+                /* FIXME: title */
                 p += event->title_length - 1;
 
 		if(!*head)
diff --git a/lib/libdvbv5/descriptors/desc_service_list.c b/lib/libdvbv5/descriptors/desc_service_list.c
index ab91622..18aa313 100644
--- a/lib/libdvbv5/descriptors/desc_service_list.c
+++ b/lib/libdvbv5/descriptors/desc_service_list.c
@@ -23,6 +23,8 @@
 #include "descriptors.h"
 #include "dvb-fe.h"
 
+/* FIXME: implement */
+
 void dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	/*struct dvb_desc_service_list *slist = (struct dvb_desc_service_list *) desc;*/
@@ -38,7 +40,7 @@ void dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *bu
 	/*}*/
 
 	/*return sizeof(struct dvb_desc_service_list) + slist->length + sizeof(struct dvb_desc_service_list_table);*/
-	//FIXME: make linked list
+	/* FIXME: make linked list */
 }
 
 void dvb_desc_service_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_service_location.c b/lib/libdvbv5/descriptors/desc_service_location.c
index 3759665..b205428 100644
--- a/lib/libdvbv5/descriptors/desc_service_location.c
+++ b/lib/libdvbv5/descriptors/desc_service_location.c
@@ -36,7 +36,7 @@ void dvb_desc_service_location_init(struct dvb_v5_fe_parms *parms, const uint8_t
 
 	bswap16(service_location->bitfield);
 
-	// FIXME: handle elements == 0
+	 /* FIXME: handle elements == 0 */
 	service_location->element = malloc(service_location->elements * sizeof(struct dvb_desc_service_location_element));
 	int i;
 	struct dvb_desc_service_location_element *element = service_location->element;
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index 1e41fbb..de19dc5 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -784,20 +784,21 @@ static char *dvb_vchannel(struct dvb_table_nit *nit, uint16_t service_id)
 	if (!nit)
 		return NULL;
 
-for( struct dvb_desc_logical_channel *desc = (struct dvb_desc_logical_channel *) nit->descriptor; desc; desc = (struct dvb_desc_logical_channel *) desc->next ) \
+	/* FIXME: use dvb_desc_find(struct dvb_desc_logical_channel, desc, nit, logical_channel_number_descriptor) { */
+	for( struct dvb_desc_logical_channel *desc = (struct dvb_desc_logical_channel *) nit->descriptor; desc; desc = (struct dvb_desc_logical_channel *) desc->next ) {
 		if(desc->type == logical_channel_number_descriptor) {
-//	dvb_desc_find(struct dvb_desc_logical_channel, desc, nit, logical_channel_number_descriptor) {
-		struct dvb_desc_logical_channel *d = (void *)desc;
+			struct dvb_desc_logical_channel *d = (void *)desc;
 
-		size_t len;
+			size_t len;
 
-		len = d->length / sizeof(d->lcn);
+			len = d->length / sizeof(d->lcn);
 
-		for (i = 0; i < len; i++) {
-			if (service_id == d->lcn[i].service_id) {
-				asprintf(&buf, "%d.%d",
-					d->lcn[i].logical_channel_number, i);
-				return buf;
+			for (i = 0; i < len; i++) {
+				if (service_id == d->lcn[i].service_id) {
+					asprintf(&buf, "%d.%d",
+						d->lcn[i].logical_channel_number, i);
+					return buf;
+				}
 			}
 		}
 	}
diff --git a/lib/libdvbv5/dvb-log.c b/lib/libdvbv5/dvb-log.c
index 7fa811f..2be056a 100644
--- a/lib/libdvbv5/dvb-log.c
+++ b/lib/libdvbv5/dvb-log.c
@@ -44,7 +44,7 @@ static const struct loglevel {
 
 void dvb_default_log(int level, const char *fmt, ...)
 {
-	if(level > sizeof(loglevels) / sizeof(struct loglevel) - 2) // ignore LOG_COLOROFF as well
+	if(level > sizeof(loglevels) / sizeof(struct loglevel) - 2) /* ignore LOG_COLOROFF as well */
 		level = LOG_INFO;
 	va_list ap;
 	va_start(ap, fmt);
diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index 09eb4d1..ea3e2c1 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -214,8 +214,6 @@ static void dvbsat_diseqc_prep_frame_addr(struct diseqc_cmd *cmd,
 	cmd->address = diseqc_addr[type];
 }
 
-//struct dvb_v5_fe_parms *parms; // legacy code, used for parms->fd, FIXME anyway
-
 /* Inputs are numbered from 1 to 16, according with the spec */
 static int dvbsat_diseqc_write_to_port_group(struct dvb_v5_fe_parms *parms, struct diseqc_cmd *cmd,
 					     int high_band,
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index d0f0b39..5f8596e 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -98,7 +98,7 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 	uint8_t *tbl = NULL;
 	ssize_t table_length = 0;
 
-	// handle sections
+	/* handle sections */
 	int start_id = -1;
 	int start_section = -1;
 	int first_section = -1;
@@ -112,7 +112,7 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 		return -4;
 	*table = NULL;
 
-	// FIXME: verify known table
+	 /* FIXME: verify known table */
 	memset(&f, 0, sizeof(f));
 	f.pid = pid;
 	f.filter.filter[0] = tid;
-- 
1.8.3.2

