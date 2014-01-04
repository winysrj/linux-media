Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:37530 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaADRIp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 12:08:45 -0500
Received: by mail-ee0-f53.google.com with SMTP id b57so7239923eek.12
        for <linux-media@vger.kernel.org>; Sat, 04 Jan 2014 09:08:43 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 06/11] libdvbv5: cleanup printing tables and descriptors
Date: Sat,  4 Jan 2014 18:07:56 +0100
Message-Id: <1388855282-19295-6-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
References: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- log hex values where appropriate
- cleanup indents

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/descriptors.c                            |    4 ++--
 lib/libdvbv5/descriptors/cat.c                        |    2 +-
 lib/libdvbv5/descriptors/desc_atsc_service_location.c |    1 -
 lib/libdvbv5/descriptors/desc_ca.c                    |    4 ++--
 lib/libdvbv5/descriptors/desc_ca_identifier.c         |    2 +-
 lib/libdvbv5/descriptors/desc_cable_delivery.c        |    1 -
 lib/libdvbv5/descriptors/desc_event_extended.c        |    2 +-
 lib/libdvbv5/descriptors/desc_event_short.c           |    6 +++---
 lib/libdvbv5/descriptors/desc_extension.c             |    2 +-
 lib/libdvbv5/descriptors/desc_frequency_list.c        |    4 ++--
 lib/libdvbv5/descriptors/desc_hierarchy.c             |    1 -
 lib/libdvbv5/descriptors/desc_isdbt_delivery.c        |    1 -
 lib/libdvbv5/descriptors/desc_language.c              |    2 +-
 lib/libdvbv5/descriptors/desc_service.c               |    7 +++----
 lib/libdvbv5/descriptors/desc_t2_delivery.c           |    1 -
 lib/libdvbv5/descriptors/desc_terrestrial_delivery.c  |    1 -
 lib/libdvbv5/descriptors/desc_ts_info.c               |    1 -
 lib/libdvbv5/descriptors/mpeg_pes.c                   |   10 +++++-----
 lib/libdvbv5/descriptors/mpeg_ts.c                    |    6 +++---
 lib/libdvbv5/descriptors/nit.c                        |    2 +-
 lib/libdvbv5/descriptors/pat.c                        |    4 ++--
 lib/libdvbv5/descriptors/pmt.c                        |    7 ++++---
 lib/libdvbv5/descriptors/sdt.c                        |    6 +++---
 23 files changed, 35 insertions(+), 42 deletions(-)

diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 93239e6..4bf9d59 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -75,8 +75,7 @@ void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc
 {
 	if (!parms)
 		parms = dvb_fe_dummy();
-	dvb_log("|                   %s (%#02x)", dvb_descriptors[desc->type].name, desc->type);
-	hexdump(parms, "|                       ", desc->data, desc->length);
+	hexdump(parms, "|           ", desc->data, desc->length);
 }
 
 const struct dvb_table_init dvb_table_initializers[] = {
@@ -168,6 +167,7 @@ void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc)
 		dvb_desc_print_func print = dvb_descriptors[desc->type].print;
 		if (!print)
 			print = dvb_desc_default_print;
+		dvb_log("|        0x%02x: %s", desc->type, dvb_descriptors[desc->type].name);
 		print(parms, desc);
 		desc = desc->next;
 	}
diff --git a/lib/libdvbv5/descriptors/cat.c b/lib/libdvbv5/descriptors/cat.c
index e6fc64e..82da031 100644
--- a/lib/libdvbv5/descriptors/cat.c
+++ b/lib/libdvbv5/descriptors/cat.c
@@ -59,7 +59,7 @@ void dvb_table_cat_free(struct dvb_table_cat *cat)
 
 void dvb_table_cat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_cat *cat)
 {
-	dvb_log("cat");
+	dvb_log("CAT");
 	dvb_table_header_print(parms, &cat->header);
 	dvb_print_descriptors(parms, cat->descriptor);
 }
diff --git a/lib/libdvbv5/descriptors/desc_atsc_service_location.c b/lib/libdvbv5/descriptors/desc_atsc_service_location.c
index 5e3f461..6da43b6 100644
--- a/lib/libdvbv5/descriptors/desc_atsc_service_location.c
+++ b/lib/libdvbv5/descriptors/desc_atsc_service_location.c
@@ -64,7 +64,6 @@ void atsc_desc_service_location_print(struct dvb_v5_fe_parms *parms, const struc
 	struct atsc_desc_service_location_elementary *el = s_loc->elementary;
 	int i;
 
-	dvb_log("|       service location");
 	dvb_log("|           pcr PID               %d", s_loc->pcr_pid);
 	dvb_log("|\\ elementary service - %d elementaries", s_loc->number_elements);
 	for (i = 0; i < s_loc->number_elements; i++) {
diff --git a/lib/libdvbv5/descriptors/desc_ca.c b/lib/libdvbv5/descriptors/desc_ca.c
index 6b48175..40edfde 100644
--- a/lib/libdvbv5/descriptors/desc_ca.c
+++ b/lib/libdvbv5/descriptors/desc_ca.c
@@ -48,8 +48,8 @@ void dvb_desc_ca_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct
 void dvb_desc_ca_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_ca *d = (const struct dvb_desc_ca *) desc;
-	dvb_log("|           ca_id             %04x", d->ca_id);
-	dvb_log("|           ca_pid            %04x", d->ca_pid);
+	dvb_log("|           ca_id             0x%04x", d->ca_id);
+	dvb_log("|           ca_pid            0x%04x", d->ca_pid);
 	dvb_log("|           privdata length   %d", d->privdata_len);
 	if (d->privdata)
 		hexdump(parms, "|           privdata          ", d->privdata, d->privdata_len);
diff --git a/lib/libdvbv5/descriptors/desc_ca_identifier.c b/lib/libdvbv5/descriptors/desc_ca_identifier.c
index 4740a01..95e0569 100644
--- a/lib/libdvbv5/descriptors/desc_ca_identifier.c
+++ b/lib/libdvbv5/descriptors/desc_ca_identifier.c
@@ -46,7 +46,7 @@ void dvb_desc_ca_identifier_print(struct dvb_v5_fe_parms *parms, const struct dv
 	int i;
 
 	for (i = 0; i < d->caid_count; i++)
-		dvb_log("|           caid %d            %04x", i, d->caids[i]);
+		dvb_log("|           caid %d            0x%04x", i, d->caids[i]);
 }
 
 void dvb_desc_ca_identifier_free(struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_cable_delivery.c b/lib/libdvbv5/descriptors/desc_cable_delivery.c
index 0aa7719..6a1c7bb 100644
--- a/lib/libdvbv5/descriptors/desc_cable_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_cable_delivery.c
@@ -41,7 +41,6 @@ void dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *
 void dvb_desc_cable_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_cable_delivery *cable = (const struct dvb_desc_cable_delivery *) desc;
-	dvb_log("|        cable delivery");
 	dvb_log("|           length            %d", cable->length);
 	dvb_log("|           frequency         %d", cable->frequency);
 	dvb_log("|           fec outer         %d", cable->fec_outer);
diff --git a/lib/libdvbv5/descriptors/desc_event_extended.c b/lib/libdvbv5/descriptors/desc_event_extended.c
index bb05951..0970484 100644
--- a/lib/libdvbv5/descriptors/desc_event_extended.c
+++ b/lib/libdvbv5/descriptors/desc_event_extended.c
@@ -74,6 +74,6 @@ void dvb_desc_event_extended_free(struct dvb_desc *desc)
 void dvb_desc_event_extended_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_event_extended *event = (const struct dvb_desc_event_extended *) desc;
-	dvb_log("|   Description   '%s'", event->text);
+	dvb_log("|           '%s'", event->text);
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_event_short.c b/lib/libdvbv5/descriptors/desc_event_short.c
index 1978beb..98809a5 100644
--- a/lib/libdvbv5/descriptors/desc_event_short.c
+++ b/lib/libdvbv5/descriptors/desc_event_short.c
@@ -67,8 +67,8 @@ void dvb_desc_event_short_free(struct dvb_desc *desc)
 void dvb_desc_event_short_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_event_short *event = (const struct dvb_desc_event_short *) desc;
-	dvb_log("|   Name          '%s'", event->name);
-	dvb_log("|   Language      '%s'", event->language);
-	dvb_log("|   Description   '%s'", event->text);
+	dvb_log("|           name          '%s'", event->name);
+	dvb_log("|           language      '%s'", event->language);
+	dvb_log("|           sescription   '%s'", event->text);
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_extension.c b/lib/libdvbv5/descriptors/desc_extension.c
index 400372f..0adf9c0 100644
--- a/lib/libdvbv5/descriptors/desc_extension.c
+++ b/lib/libdvbv5/descriptors/desc_extension.c
@@ -178,7 +178,7 @@ void extension_descriptor_print(struct dvb_v5_fe_parms *parms,
 {
 	struct dvb_extension_descriptor *ext = (void *)desc;
 	uint8_t type = ext->extension_code;
-	dvb_log("Extension descriptor %s type 0x%02x",
+	dvb_log("|           descriptor %s type 0x%02x",
 		dvb_ext_descriptors[type].name, type);
 
 	if (dvb_ext_descriptors[type].print)
diff --git a/lib/libdvbv5/descriptors/desc_frequency_list.c b/lib/libdvbv5/descriptors/desc_frequency_list.c
index 447e412..28ba068 100644
--- a/lib/libdvbv5/descriptors/desc_frequency_list.c
+++ b/lib/libdvbv5/descriptors/desc_frequency_list.c
@@ -59,11 +59,11 @@ void dvb_desc_frequency_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *
 void dvb_desc_frequency_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_frequency_list *d = (const struct dvb_desc_frequency_list *) desc;
-	dvb_log("|       frequency list type: %d", d->freq_type);
+	dvb_log("|           type: %d", d->freq_type);
 	int i = 0;
 
 	for (i = 0; i < d->frequencies; i++) {
-		dvb_log("|       frequency : %d", d->frequency[i]);
+		dvb_log("|           frequency : %d", d->frequency[i]);
 	}
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_hierarchy.c b/lib/libdvbv5/descriptors/desc_hierarchy.c
index a591ed8..346a9c0 100644
--- a/lib/libdvbv5/descriptors/desc_hierarchy.c
+++ b/lib/libdvbv5/descriptors/desc_hierarchy.c
@@ -35,7 +35,6 @@ void dvb_desc_hierarchy_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 void dvb_desc_hierarchy_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_hierarchy *hierarchy = (const struct dvb_desc_hierarchy *) desc;
-	dvb_log("|	Hierarchy");
 	dvb_log("|           type           %d", hierarchy->hierarchy_type);
 	dvb_log("|           layer          %d", hierarchy->layer);
 	dvb_log("|           embedded_layer %d", hierarchy->embedded_layer);
diff --git a/lib/libdvbv5/descriptors/desc_isdbt_delivery.c b/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
index df04580..bd22456 100644
--- a/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
@@ -83,7 +83,6 @@ void isdbt_desc_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_d
 	const struct isdbt_desc_terrestrial_delivery_system *d = (const void *) desc;
 	int i;
 
-	dvb_log("|        ISDB-T delivery");
 	dvb_log("|           transmission mode %s (%d)",
 		tm_name[d->transmission_mode], d->transmission_mode);
 	dvb_log("|           guard interval    %s (%d)",
diff --git a/lib/libdvbv5/descriptors/desc_language.c b/lib/libdvbv5/descriptors/desc_language.c
index 0b47371..264be55 100644
--- a/lib/libdvbv5/descriptors/desc_language.c
+++ b/lib/libdvbv5/descriptors/desc_language.c
@@ -37,6 +37,6 @@ void dvb_desc_language_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, s
 void dvb_desc_language_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_language *lang = (const struct dvb_desc_language *) desc;
-	dvb_log("|                   lang: %s (type: %d)", lang->language, lang->audio_type);
+	dvb_log("|           lang: %s (type: %d)", lang->language, lang->audio_type);
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_service.c b/lib/libdvbv5/descriptors/desc_service.c
index 2f1b6ef..1e38451 100644
--- a/lib/libdvbv5/descriptors/desc_service.c
+++ b/lib/libdvbv5/descriptors/desc_service.c
@@ -30,7 +30,6 @@ void dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, st
 	uint8_t len;        /* the length of the string in the input data */
 	uint8_t len1, len2; /* the lenght of the output strings */
 
-        /*hexdump(parms, "service desc: ", buf - 2, desc->length + 2);*/
 	service->service_type = buf[0];
 	buf++;
 
@@ -63,8 +62,8 @@ void dvb_desc_service_free(struct dvb_desc *desc)
 void dvb_desc_service_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_service *service = (const struct dvb_desc_service *) desc;
-	dvb_log("|   service type     %d", service->service_type);
-	dvb_log("|           name     '%s'", service->name);
-	dvb_log("|           provider '%s'", service->provider);
+	dvb_log("|           service type  %d", service->service_type);
+	dvb_log("|           name          '%s'", service->name);
+	dvb_log("|           provider      '%s'", service->provider);
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_t2_delivery.c b/lib/libdvbv5/descriptors/desc_t2_delivery.c
index a563164..31c6974 100644
--- a/lib/libdvbv5/descriptors/desc_t2_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_t2_delivery.c
@@ -98,7 +98,6 @@ void dvb_desc_t2_delivery_print(struct dvb_v5_fe_parms *parms,
 	const struct dvb_desc_t2_delivery *d = desc;
 	int i;
 
-	dvb_log("|       DVB-T2 delivery");
 	dvb_log("|           plp_id                    %d", d->plp_id);
 	dvb_log("|           system_id                 %d", d->system_id);
 
diff --git a/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c b/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
index 745813f..889ded3 100644
--- a/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
@@ -39,7 +39,6 @@ void dvb_desc_terrestrial_delivery_init(struct dvb_v5_fe_parms *parms, const uin
 void dvb_desc_terrestrial_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_terrestrial_delivery *tdel = (const struct dvb_desc_terrestrial_delivery *) desc;
-	dvb_log("|       terrestrial delivery");
 	dvb_log("|           length                %d", tdel->length);
 	dvb_log("|           centre frequency      %d", tdel->centre_frequency * 10);
 	dvb_log("|           mpe_fec_indicator     %d", tdel->mpe_fec_indicator);
diff --git a/lib/libdvbv5/descriptors/desc_ts_info.c b/lib/libdvbv5/descriptors/desc_ts_info.c
index 02fcb82..233d331 100644
--- a/lib/libdvbv5/descriptors/desc_ts_info.c
+++ b/lib/libdvbv5/descriptors/desc_ts_info.c
@@ -69,7 +69,6 @@ void dvb_desc_ts_info_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc
 
 	t = &d->transmission_type;
 
-	dvb_log("|        TS Information");
 	dvb_log("|           remote key ID     %d", d->remote_control_key_id);
 	dvb_log("|           name              %s", d->ts_name);
 	dvb_log("|           emphasis name     %s", d->ts_name_emph);
diff --git a/lib/libdvbv5/descriptors/mpeg_pes.c b/lib/libdvbv5/descriptors/mpeg_pes.c
index ab1cadf..65f5cf1 100644
--- a/lib/libdvbv5/descriptors/mpeg_pes.c
+++ b/lib/libdvbv5/descriptors/mpeg_pes.c
@@ -34,7 +34,7 @@ void dvb_mpeg_pes_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_
 	bswap16(pes->length);
 
 	if (pes->sync != 0x000001) {
-		dvb_logerr("mpeg pes invalid");
+		dvb_logerr("mpeg pes invalid, sync 0x%06x should be 0x000001", pes->sync);
 		return;
 	}
 
@@ -47,7 +47,7 @@ void dvb_mpeg_pes_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_
 		   pes->stream_id == DVB_MPEG_STREAM_DIRECTORY ||
 		   pes->stream_id == DVB_MPEG_STREAM_DSMCC ||
 		   pes->stream_id == DVB_MPEG_STREAM_H222E ) {
-		dvb_logerr("mpeg pes: unsupported stream type %#04x", pes->stream_id);
+		dvb_logerr("mpeg pes: unsupported stream type 0x%04x", pes->stream_id);
 	} else {
 		memcpy(pes->optional, p, sizeof(struct dvb_mpeg_pes_optional) -
 					 sizeof(pes->optional->pts) -
@@ -94,8 +94,8 @@ void dvb_mpeg_pes_free(struct dvb_mpeg_pes *ts)
 void dvb_mpeg_pes_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_pes *pes)
 {
 	dvb_log("MPEG PES");
-	dvb_log(" - sync      %#08x", pes->sync);
-	dvb_log(" - stream_id %#04x", pes->stream_id);
+	dvb_log(" - sync      0x%08x", pes->sync);
+	dvb_log(" - stream_id 0x%04x", pes->stream_id);
 	dvb_log(" - length    %d", pes->length);
 	if (pes->stream_id == DVB_MPEG_STREAM_PADDING) {
 	} else if (pes->stream_id == DVB_MPEG_STREAM_MAP ||
@@ -105,7 +105,7 @@ void dvb_mpeg_pes_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_pes *pes)
 		   pes->stream_id == DVB_MPEG_STREAM_DIRECTORY ||
 		   pes->stream_id == DVB_MPEG_STREAM_DSMCC ||
 		   pes->stream_id == DVB_MPEG_STREAM_H222E ) {
-		dvb_log("  mpeg pes unsupported stream type %#04x", pes->stream_id);
+		dvb_log("  mpeg pes unsupported stream type 0x%04x", pes->stream_id);
 	} else {
 		dvb_log("  mpeg pes optional");
 		dvb_log("   - two                      %d", pes->optional->two);
diff --git a/lib/libdvbv5/descriptors/mpeg_ts.c b/lib/libdvbv5/descriptors/mpeg_ts.c
index 83e983a..c2154af 100644
--- a/lib/libdvbv5/descriptors/mpeg_ts.c
+++ b/lib/libdvbv5/descriptors/mpeg_ts.c
@@ -25,7 +25,7 @@
 ssize_t dvb_mpeg_ts_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
 {
 	if (buf[0] != DVB_MPEG_TS) {
-		dvb_logerr("mpeg ts invalid marker %#02x, sould be %#02x", buf[0], DVB_MPEG_TS);
+		dvb_logerr("mpeg ts invalid marker 0x%02x, sould be 0x%02x", buf[0], DVB_MPEG_TS);
 		*table_length = 0;
 		return 0;
 	}
@@ -58,11 +58,11 @@ void dvb_mpeg_ts_free(struct dvb_mpeg_ts *ts)
 void dvb_mpeg_ts_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_ts *ts)
 {
 	dvb_log("MPEG TS");
-	dvb_log(" - sync byte          %#02x", ts->sync_byte);
+	dvb_log(" - sync byte        0x%02x", ts->sync_byte);
 	dvb_log(" - tei                %d", ts->tei);
 	dvb_log(" - payload_start      %d", ts->payload_start);
 	dvb_log(" - priority           %d", ts->priority);
-	dvb_log(" - pid                %d", ts->pid);
+	dvb_log(" - pid              0x%04x", ts->pid);
 	dvb_log(" - scrambling         %d", ts->scrambling);
 	dvb_log(" - adaptation_field   %d", ts->adaptation_field);
 	dvb_log(" - continuity_counter %d", ts->continuity_counter);
diff --git a/lib/libdvbv5/descriptors/nit.c b/lib/libdvbv5/descriptors/nit.c
index ca565dd..b351a6b 100644
--- a/lib/libdvbv5/descriptors/nit.c
+++ b/lib/libdvbv5/descriptors/nit.c
@@ -143,7 +143,7 @@ void dvb_table_nit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *ni
 	const struct dvb_table_nit_transport *transport = nit->transport;
 	uint16_t transports = 0;
 	while(transport) {
-		dvb_log("|- Transport: %-7d Network: %-7d", transport->transport_id, transport->network_id);
+		dvb_log("|- transport %04x network %04x", transport->transport_id, transport->network_id);
 		dvb_print_descriptors(parms, transport->descriptor);
 		transport = transport->next;
 		transports++;
diff --git a/lib/libdvbv5/descriptors/pat.c b/lib/libdvbv5/descriptors/pat.c
index 67d267b..1d1c124 100644
--- a/lib/libdvbv5/descriptors/pat.c
+++ b/lib/libdvbv5/descriptors/pat.c
@@ -94,10 +94,10 @@ void dvb_table_pat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_pat *pa
 
 	dvb_log("PAT");
 	dvb_table_header_print(parms, &pat->header);
-	dvb_log("|\\  program  service (%d programs)", pat->programs);
+	dvb_log("|\\ %d program%s", pat->programs, pat->programs != 1 ? "s" : "");
 
 	while (pgm) {
-		dvb_log("|- %7d %7d", pgm->pid, pgm->service_id);
+		dvb_log("|- program 0x%04x  ->  service 0x%04x", pgm->pid, pgm->service_id);
 		pgm = pgm->next;
 	}
 }
diff --git a/lib/libdvbv5/descriptors/pmt.c b/lib/libdvbv5/descriptors/pmt.c
index 5d42eb7..954a51f 100644
--- a/lib/libdvbv5/descriptors/pmt.c
+++ b/lib/libdvbv5/descriptors/pmt.c
@@ -109,16 +109,17 @@ void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_p
 {
 	dvb_log("PMT");
 	dvb_table_header_print(parms, &pmt->header);
-	dvb_log("|- pcr_pid       %d", pmt->pcr_pid);
+	dvb_log("|- pcr_pid       %04x", pmt->pcr_pid);
 	dvb_log("|  reserved2     %d", pmt->reserved2);
 	dvb_log("|  prog length   %d", pmt->prog_length);
 	dvb_log("|  zero3         %d", pmt->zero3);
 	dvb_log("|  reserved3     %d", pmt->reserved3);
-	dvb_log("|\\  pid     type");
+	dvb_print_descriptors(parms, pmt->descriptor);
+	dvb_log("|\\");
 	const struct dvb_table_pmt_stream *stream = pmt->stream;
 	uint16_t streams = 0;
 	while(stream) {
-		dvb_log("|- %5d   %s (%d)", stream->elementary_pid,
+		dvb_log("|- stream 0x%04x: %s (%x)", stream->elementary_pid,
 				pmt_stream_name[stream->type], stream->type);
 		dvb_print_descriptors(parms, stream->descriptor);
 		stream = stream->next;
diff --git a/lib/libdvbv5/descriptors/sdt.c b/lib/libdvbv5/descriptors/sdt.c
index c15512f..861a352 100644
--- a/lib/libdvbv5/descriptors/sdt.c
+++ b/lib/libdvbv5/descriptors/sdt.c
@@ -73,7 +73,7 @@ void dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		p += service->section_length;
 	}
 	if (endbuf - p)
-		dvb_logerr("PAT table has %zu spurious bytes at the end.",
+		dvb_logerr("SDT table has %zu spurious bytes at the end.",
 			   endbuf - p);
 }
 
@@ -94,11 +94,11 @@ void dvb_table_sdt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_sdt *sd
 	dvb_log("SDT");
 	dvb_table_header_print(parms, &sdt->header);
 	dvb_log("|- network_id         %d", sdt->network_id);
-	dvb_log("|\\  service_id");
+	dvb_log("|\\");
 	const struct dvb_table_sdt_service *service = sdt->service;
 	uint16_t services = 0;
 	while(service) {
-		dvb_log("|- %7d", service->service_id);
+		dvb_log("|- service 0x%04x", service->service_id);
 		dvb_log("|   EIT schedule          %d", service->EIT_schedule);
 		dvb_log("|   EIT present following %d", service->EIT_present_following);
 		dvb_log("|   free CA mode          %d", service->free_CA_mode);
-- 
1.7.10.4

