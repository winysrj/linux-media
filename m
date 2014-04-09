Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36458 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964831AbaDIW10 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 18:27:26 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so2365089eei.33
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 15:27:24 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 7/7] libdvbv5: rename descriptor functions
Date: Thu, 10 Apr 2014 00:27:00 +0200
Message-Id: <1397082420-31198-7-git-send-email-neolynx@gmail.com>
In-Reply-To: <1397082420-31198-1-git-send-email-neolynx@gmail.com>
References: <1397082420-31198-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

prefix the descriptor functions with dvb_desc
for a nice API and code completion support

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/descriptors.h  |    6 +++---
 lib/libdvbv5/descriptors.c          |    6 +++---
 lib/libdvbv5/descriptors/atsc_eit.c |    6 +++---
 lib/libdvbv5/descriptors/cat.c      |    6 +++---
 lib/libdvbv5/descriptors/eit.c      |    6 +++---
 lib/libdvbv5/descriptors/mgt.c      |    8 ++++----
 lib/libdvbv5/descriptors/nit.c      |   12 ++++++------
 lib/libdvbv5/descriptors/pmt.c      |   12 ++++++------
 lib/libdvbv5/descriptors/sdt.c      |    6 +++---
 lib/libdvbv5/descriptors/vct.c      |   10 +++++-----
 10 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/descriptors.h
index d08ab3e..8b38977 100644
--- a/lib/include/libdvbv5/descriptors.h
+++ b/lib/include/libdvbv5/descriptors.h
@@ -82,9 +82,9 @@ uint32_t bcd(uint32_t bcd);
 
 void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned char *buf, int len);
 
-int dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf, uint16_t section_length, struct dvb_desc **head_desc);
-void dvb_free_descriptors(struct dvb_desc **list);
-void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc);
+int  dvb_desc_parse(struct dvb_v5_fe_parms *parms, const uint8_t *buf, uint16_t section_length, struct dvb_desc **head_desc);
+void dvb_desc_free (struct dvb_desc **list);
+void dvb_desc_print(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 539f824..c2b0293 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -98,7 +98,7 @@ const struct dvb_table_init dvb_table_initializers[] = {
 char *default_charset = "iso-8859-1";
 char *output_charset = "utf-8";
 
-int dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
+int dvb_desc_parse(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			   uint16_t buflen, struct dvb_desc **head_desc)
 {
 	const uint8_t *ptr = buf, *endbuf = buf + buflen;
@@ -172,7 +172,7 @@ int dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	return 0;
 }
 
-void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc)
+void dvb_desc_print(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc)
 {
 	while (desc) {
 		dvb_desc_print_func print = dvb_descriptors[desc->type].print;
@@ -184,7 +184,7 @@ void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc)
 	}
 }
 
-void dvb_free_descriptors(struct dvb_desc **list)
+void dvb_desc_free(struct dvb_desc **list)
 {
 	struct dvb_desc *desc = *list;
 	while (desc) {
diff --git a/lib/libdvbv5/descriptors/atsc_eit.c b/lib/libdvbv5/descriptors/atsc_eit.c
index 985b055..38f3810 100644
--- a/lib/libdvbv5/descriptors/atsc_eit.c
+++ b/lib/libdvbv5/descriptors/atsc_eit.c
@@ -113,7 +113,7 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 				   endbuf - p, size);
 			return -5;
 		}
-		dvb_parse_descriptors(parms, p, size, &event->descriptor);
+		dvb_desc_parse(parms, p, size, &event->descriptor);
 
 		p += size;
 	}
@@ -129,7 +129,7 @@ void atsc_table_eit_free(struct atsc_table_eit *eit)
 	while (event) {
 		struct atsc_table_eit_event *tmp = event;
 
-		dvb_free_descriptors((struct dvb_desc **) &event->descriptor);
+		dvb_desc_free((struct dvb_desc **) &event->descriptor);
 		event = event->next;
 		free(tmp);
 	}
@@ -154,7 +154,7 @@ void atsc_table_eit_print(struct dvb_v5_fe_parms *parms, struct atsc_table_eit *
 		dvb_loginfo("|   Duration              %dh %dm %ds", event->duration / 3600, (event->duration % 3600) / 60, event->duration % 60);
 		dvb_loginfo("|   ETM                   %d", event->etm);
 		dvb_loginfo("|   title length          %d", event->title_length);
-		dvb_print_descriptors(parms, event->descriptor);
+		dvb_desc_print(parms, event->descriptor);
 		event = event->next;
 		events++;
 	}
diff --git a/lib/libdvbv5/descriptors/cat.c b/lib/libdvbv5/descriptors/cat.c
index a8fb00b..5acc88e 100644
--- a/lib/libdvbv5/descriptors/cat.c
+++ b/lib/libdvbv5/descriptors/cat.c
@@ -65,7 +65,7 @@ ssize_t dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	/* parse the descriptors */
 	if (endbuf > p) {
 		uint16_t desc_length = endbuf - p;
-		if (dvb_parse_descriptors(parms, p, desc_length,
+		if (dvb_desc_parse(parms, p, desc_length,
 				      head_desc) != 0) {
 			return -4;
 		}
@@ -82,7 +82,7 @@ ssize_t dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 
 void dvb_table_cat_free(struct dvb_table_cat *cat)
 {
-	dvb_free_descriptors((struct dvb_desc **) &cat->descriptor);
+	dvb_desc_free((struct dvb_desc **) &cat->descriptor);
 	free(cat);
 }
 
@@ -90,6 +90,6 @@ void dvb_table_cat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_cat *ca
 {
 	dvb_loginfo("CAT");
 	dvb_table_header_print(parms, &cat->header);
-	dvb_print_descriptors(parms, cat->descriptor);
+	dvb_desc_print(parms, cat->descriptor);
 }
 
diff --git a/lib/libdvbv5/descriptors/eit.c b/lib/libdvbv5/descriptors/eit.c
index d66d492..21f7897 100644
--- a/lib/libdvbv5/descriptors/eit.c
+++ b/lib/libdvbv5/descriptors/eit.c
@@ -103,7 +103,7 @@ ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 					   endbuf - p, desc_length);
 				desc_length = endbuf - p;
 			}
-			if (dvb_parse_descriptors(parms, p, desc_length,
+			if (dvb_desc_parse(parms, p, desc_length,
 					      &event->descriptor) != 0) {
 				return -4;
 			}
@@ -121,7 +121,7 @@ void dvb_table_eit_free(struct dvb_table_eit *eit)
 {
 	struct dvb_table_eit_event *event = eit->event;
 	while (event) {
-		dvb_free_descriptors((struct dvb_desc **) &event->descriptor);
+		dvb_desc_free((struct dvb_desc **) &event->descriptor);
 		struct dvb_table_eit_event *tmp = event;
 		event = event->next;
 		free(tmp);
@@ -149,7 +149,7 @@ void dvb_table_eit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_eit *ei
 		dvb_loginfo("|   Duration              %dh %dm %ds", event->duration / 3600, (event->duration % 3600) / 60, event->duration % 60);
 		dvb_loginfo("|   free CA mode          %d", event->free_CA_mode);
 		dvb_loginfo("|   running status        %d: %s", event->running_status, dvb_eit_running_status_name[event->running_status] );
-		dvb_print_descriptors(parms, event->descriptor);
+		dvb_desc_print(parms, event->descriptor);
 		event = event->next;
 		events++;
 	}
diff --git a/lib/libdvbv5/descriptors/mgt.c b/lib/libdvbv5/descriptors/mgt.c
index 29172c3..f32bc2d 100644
--- a/lib/libdvbv5/descriptors/mgt.c
+++ b/lib/libdvbv5/descriptors/mgt.c
@@ -102,7 +102,7 @@ ssize_t atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 				   endbuf - p, size);
 			return -3;
 		}
-		dvb_parse_descriptors(parms, p, size, &table->descriptor);
+		dvb_desc_parse(parms, p, size, &table->descriptor);
 
 		p += size;
 	}
@@ -117,11 +117,11 @@ void atsc_table_mgt_free(struct atsc_table_mgt *mgt)
 {
 	struct atsc_table_mgt_table *table = mgt->table;
 
-	dvb_free_descriptors((struct dvb_desc **) &mgt->descriptor);
+	dvb_desc_free((struct dvb_desc **) &mgt->descriptor);
 	while (table) {
 		struct atsc_table_mgt_table *tmp = table;
 
-		dvb_free_descriptors((struct dvb_desc **) &table->descriptor);
+		dvb_desc_free((struct dvb_desc **) &table->descriptor);
 		table = table->next;
 		free(tmp);
 	}
@@ -144,7 +144,7 @@ void atsc_table_mgt_print(struct dvb_v5_fe_parms *parms, struct atsc_table_mgt *
                 dvb_loginfo("|  size         %d", table->size);
                 dvb_loginfo("|  one3         %d", table->one3);
                 dvb_loginfo("|  desc_length  %d", table->desc_length);
-		dvb_print_descriptors(parms, table->descriptor);
+		dvb_desc_print(parms, table->descriptor);
 		table = table->next;
 		tables++;
 	}
diff --git a/lib/libdvbv5/descriptors/nit.c b/lib/libdvbv5/descriptors/nit.c
index c2c55a4..644a861 100644
--- a/lib/libdvbv5/descriptors/nit.c
+++ b/lib/libdvbv5/descriptors/nit.c
@@ -77,7 +77,7 @@ ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			   endbuf - p, size);
 		return -3;
 	}
-	dvb_parse_descriptors(parms, p, size, head_desc);
+	dvb_desc_parse(parms, p, size, head_desc);
 	p += size;
 
 	size = sizeof(union dvb_table_nit_transport_header);
@@ -117,7 +117,7 @@ ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 					   endbuf - p, desc_length);
 				desc_length = endbuf - p;
 			}
-			if (dvb_parse_descriptors(parms, p, desc_length,
+			if (dvb_desc_parse(parms, p, desc_length,
 					      &transport->descriptor) != 0) {
 				return -6;
 			}
@@ -134,9 +134,9 @@ ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 void dvb_table_nit_free(struct dvb_table_nit *nit)
 {
 	struct dvb_table_nit_transport *transport = nit->transport;
-	dvb_free_descriptors((struct dvb_desc **) &nit->descriptor);
+	dvb_desc_free((struct dvb_desc **) &nit->descriptor);
 	while (transport) {
-		dvb_free_descriptors((struct dvb_desc **) &transport->descriptor);
+		dvb_desc_free((struct dvb_desc **) &transport->descriptor);
 		struct dvb_table_nit_transport *tmp = transport;
 		transport = transport->next;
 		free(tmp);
@@ -152,10 +152,10 @@ void dvb_table_nit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *ni
 	dvb_loginfo("NIT");
 	dvb_table_header_print(parms, &nit->header);
 	dvb_loginfo("| desc_length   %d", nit->desc_length);
-	dvb_print_descriptors(parms, nit->descriptor);
+	dvb_desc_print(parms, nit->descriptor);
 	while (transport) {
 		dvb_loginfo("|- transport %04x network %04x", transport->transport_id, transport->network_id);
-		dvb_print_descriptors(parms, transport->descriptor);
+		dvb_desc_print(parms, transport->descriptor);
 		transport = transport->next;
 		transports++;
 	}
diff --git a/lib/libdvbv5/descriptors/pmt.c b/lib/libdvbv5/descriptors/pmt.c
index e1f07f8..426c3dc 100644
--- a/lib/libdvbv5/descriptors/pmt.c
+++ b/lib/libdvbv5/descriptors/pmt.c
@@ -87,7 +87,7 @@ ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 				   desc_length, endbuf - p);
 			desc_length = endbuf - p;
 		}
-		if (dvb_parse_descriptors(parms, p, desc_length,
+		if (dvb_desc_parse(parms, p, desc_length,
 				      head_desc) != 0) {
 			return -3;
 		}
@@ -123,7 +123,7 @@ ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 					   endbuf - p, desc_length);
 				desc_length = endbuf - p;
 			}
-			if (dvb_parse_descriptors(parms, p, desc_length,
+			if (dvb_desc_parse(parms, p, desc_length,
 					      &stream->descriptor) != 0) {
 				return -4;
 			}
@@ -142,12 +142,12 @@ void dvb_table_pmt_free(struct dvb_table_pmt *pmt)
 {
 	struct dvb_table_pmt_stream *stream = pmt->stream;
 	while(stream) {
-		dvb_free_descriptors((struct dvb_desc **) &stream->descriptor);
+		dvb_desc_free((struct dvb_desc **) &stream->descriptor);
 		struct dvb_table_pmt_stream *tmp = stream;
 		stream = stream->next;
 		free(tmp);
 	}
-	dvb_free_descriptors((struct dvb_desc **) &pmt->descriptor);
+	dvb_desc_free((struct dvb_desc **) &pmt->descriptor);
 	free(pmt);
 }
 
@@ -160,7 +160,7 @@ void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_p
 	dvb_loginfo("|  descriptor length   %d", pmt->desc_length);
 	dvb_loginfo("|  zero3               %d", pmt->zero3);
 	dvb_loginfo("|  reserved3          %d", pmt->reserved3);
-	dvb_print_descriptors(parms, pmt->descriptor);
+	dvb_desc_print(parms, pmt->descriptor);
 	dvb_loginfo("|\\");
 	const struct dvb_table_pmt_stream *stream = pmt->stream;
 	uint16_t streams = 0;
@@ -168,7 +168,7 @@ void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_p
 		dvb_loginfo("|- stream 0x%04x: %s (%x)", stream->elementary_pid,
 				pmt_stream_name[stream->type], stream->type);
 		dvb_loginfo("|    descriptor length   %d", stream->desc_length);
-		dvb_print_descriptors(parms, stream->descriptor);
+		dvb_desc_print(parms, stream->descriptor);
 		stream = stream->next;
 		streams++;
 	}
diff --git a/lib/libdvbv5/descriptors/sdt.c b/lib/libdvbv5/descriptors/sdt.c
index c0d32e4..561ec66 100644
--- a/lib/libdvbv5/descriptors/sdt.c
+++ b/lib/libdvbv5/descriptors/sdt.c
@@ -97,7 +97,7 @@ ssize_t dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 					   endbuf - p, desc_length);
 				desc_length = endbuf - p;
 			}
-			if (dvb_parse_descriptors(parms, p, desc_length,
+			if (dvb_desc_parse(parms, p, desc_length,
 					      &service->descriptor) != 0) {
 				return -4;
 			}
@@ -117,7 +117,7 @@ void dvb_table_sdt_free(struct dvb_table_sdt *sdt)
 {
 	struct dvb_table_sdt_service *service = sdt->service;
 	while(service) {
-		dvb_free_descriptors((struct dvb_desc **) &service->descriptor);
+		dvb_desc_free((struct dvb_desc **) &service->descriptor);
 		struct dvb_table_sdt_service *tmp = service;
 		service = service->next;
 		free(tmp);
@@ -141,7 +141,7 @@ void dvb_table_sdt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_sdt *sd
 		dvb_loginfo("|   free CA mode          %d", service->free_CA_mode);
 		dvb_loginfo("|   running status        %d", service->running_status);
 		dvb_loginfo("|   descriptor length     %d", service->desc_length);
-		dvb_print_descriptors(parms, service->descriptor);
+		dvb_desc_print(parms, service->descriptor);
 		service = service->next;
 		services++;
 	}
diff --git a/lib/libdvbv5/descriptors/vct.c b/lib/libdvbv5/descriptors/vct.c
index 6b64144..387c6e8 100644
--- a/lib/libdvbv5/descriptors/vct.c
+++ b/lib/libdvbv5/descriptors/vct.c
@@ -115,7 +115,7 @@ ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		}
 
 		/* get the descriptors for each program */
-		dvb_parse_descriptors(parms, p, channel->descriptors_length,
+		dvb_desc_parse(parms, p, channel->descriptors_length,
 				      &channel->descriptor);
 
 		p += channel->descriptors_length;
@@ -132,7 +132,7 @@ ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 				   d->descriptor_length, endbuf - p);
 			return -3;
 		}
-		dvb_parse_descriptors(parms, p, d->descriptor_length,
+		dvb_desc_parse(parms, p, d->descriptor_length,
 				      &vct->descriptor);
 	}
 	if (endbuf - p)
@@ -146,12 +146,12 @@ void atsc_table_vct_free(struct atsc_table_vct *vct)
 {
 	struct atsc_table_vct_channel *channel = vct->channel;
 	while (channel) {
-		dvb_free_descriptors((struct dvb_desc **) &channel->descriptor);
+		dvb_desc_free((struct dvb_desc **) &channel->descriptor);
 		struct atsc_table_vct_channel *tmp = channel;
 		channel = channel->next;
 		free(tmp);
 	}
-	dvb_free_descriptors((struct dvb_desc **) &vct->descriptor);
+	dvb_desc_free((struct dvb_desc **) &vct->descriptor);
 
 	free(vct);
 }
@@ -192,7 +192,7 @@ void atsc_table_vct_print(struct dvb_v5_fe_parms *parms, struct atsc_table_vct *
 		dvb_loginfo("|   service type          %d", channel->service_type);
 		dvb_loginfo("|   source id            %d", channel->source_id);
 
-		dvb_print_descriptors(parms, channel->descriptor);
+		dvb_desc_print(parms, channel->descriptor);
 		channel = channel->next;
 		channels++;
 	}
-- 
1.7.10.4

