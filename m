Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:63041 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab3L3Mta (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 07:49:30 -0500
Received: by mail-ea0-f169.google.com with SMTP id l9so4438430eaj.28
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 04:49:28 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 07/18] libdvbv5: fix EIT parsing
Date: Mon, 30 Dec 2013 13:48:40 +0100
Message-Id: <1388407731-24369-7-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

the dvb_table_eit_event now contains the service_id,
indicating where the events belong to.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors/eit.h  |  3 ++-
 lib/libdvbv5/descriptors/eit.c | 35 ++++++++++++++++++++++++++---------
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/lib/include/descriptors/eit.h b/lib/include/descriptors/eit.h
index 2af9696..ca08fd4 100644
--- a/lib/include/descriptors/eit.h
+++ b/lib/include/descriptors/eit.h
@@ -40,7 +40,7 @@
 struct dvb_table_eit_event {
 	uint16_t event_id;
 	union {
-		uint16_t bitfield;
+		uint16_t bitfield1; /* first 2 bytes are MJD, they need to be bswapped */
 		uint8_t dvbstart[5];
 	} __attribute__((packed));
 	uint8_t dvbduration[3];
@@ -56,6 +56,7 @@ struct dvb_table_eit_event {
 	struct dvb_table_eit_event *next;
 	struct tm start;
 	uint32_t duration;
+	uint16_t service_id;
 } __attribute__((packed));
 
 struct dvb_table_eit {
diff --git a/lib/libdvbv5/descriptors/eit.c b/lib/libdvbv5/descriptors/eit.c
index ccfe1a6..c2d01c3 100644
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
@@ -48,18 +53,30 @@ void dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize
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
-		bswap16(event->bitfield);
+		bswap16(event->bitfield1);
 		bswap16(event->bitfield2);
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
@@ -137,9 +155,8 @@ void dvb_time(const uint8_t data[5], struct tm *tm)
   tm->tm_mday  = day;
   tm->tm_mon   = month - 1;
   tm->tm_year  = year;
-  tm->tm_isdst = -1;
-  tm->tm_wday  = 0;
-  tm->tm_yday  = 0;
+  tm->tm_isdst = 1; /* dst in effect, do not adjust */
+  mktime( tm );
 }
 
 
-- 
1.8.3.2

