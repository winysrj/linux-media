Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:48632 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaC3QVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 12:21:50 -0400
Received: by mail-ee0-f53.google.com with SMTP id b57so5772768eek.40
        for <linux-media@vger.kernel.org>; Sun, 30 Mar 2014 09:21:49 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 1/8] libdvbv5: cleanup printing tables and descriptors
Date: Sun, 30 Mar 2014 18:21:11 +0200
Message-Id: <1396196478-996-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- log hex values where appropriate
- cleanup indents

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/descriptors.c                         |  6 +--
 lib/libdvbv5/descriptors/cat.c                     |  2 +-
 .../descriptors/desc_atsc_service_location.c       |  1 -
 lib/libdvbv5/descriptors/desc_ca.c                 |  4 +-
 lib/libdvbv5/descriptors/desc_ca_identifier.c      |  2 +-
 lib/libdvbv5/descriptors/desc_cable_delivery.c     |  1 -
 lib/libdvbv5/descriptors/desc_event_extended.c     |  2 +-
 lib/libdvbv5/descriptors/desc_event_short.c        |  6 +--
 lib/libdvbv5/descriptors/desc_extension.c          |  2 +-
 lib/libdvbv5/descriptors/desc_frequency_list.c     |  4 +-
 lib/libdvbv5/descriptors/desc_hierarchy.c          |  1 -
 lib/libdvbv5/descriptors/desc_isdbt_delivery.c     |  1 -
 lib/libdvbv5/descriptors/desc_language.c           |  2 +-
 lib/libdvbv5/descriptors/desc_service.c            |  7 ++--
 lib/libdvbv5/descriptors/desc_t2_delivery.c        |  1 -
 .../descriptors/desc_terrestrial_delivery.c        |  1 -
 lib/libdvbv5/descriptors/desc_ts_info.c            |  1 -
 lib/libdvbv5/descriptors/mpeg_pes.c                |  2 +-
 lib/libdvbv5/descriptors/mpeg_ts.c                 | 43 +++++++++++-----------
 lib/libdvbv5/descriptors/nit.c                     |  2 +-
 lib/libdvbv5/descriptors/pat.c                     |  4 +-
 lib/libdvbv5/descriptors/sdt.c                     |  6 +--
 22 files changed, 46 insertions(+), 55 deletions(-)

diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 15696f0..4694b98 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -75,8 +75,7 @@ void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc
 {
 	if (!parms)
 		parms = dvb_fe_dummy();
-	dvb_log("|                   %s (0x%02x)", dvb_descriptors[desc->type].name, desc->type);
-	hexdump(parms, "|                       ", desc->data, desc->length);
+	hexdump(parms, "|           ", desc->data, desc->length);
 }
 
 const struct dvb_table_init dvb_table_initializers[] = {
@@ -167,6 +166,7 @@ void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc)
 		dvb_desc_print_func print = dvb_descriptors[desc->type].print;
 		if (!print)
 			print = dvb_desc_default_print;
+		dvb_log("|        0x%02x: %s", desc->type, dvb_descriptors[desc->type].name);
 		print(parms, desc);
 		desc = desc->next;
 	}
@@ -1362,6 +1362,6 @@ void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned c
 		for (i = strlen(hex); i < 49; i++)
 			strncat(spaces, " ", sizeof(spaces));
 		ascii[j] = '\0';
-		dvb_log("%s %s %s %s", prefix, hex, spaces, ascii);
+		dvb_log("%s%s %s %s", prefix, hex, spaces, ascii);
 	}
 }
diff --git a/lib/libdvbv5/descriptors/cat.c b/lib/libdvbv5/descriptors/cat.c
index 4069923..20376de 100644
--- a/lib/libdvbv5/descriptors/cat.c
+++ b/lib/libdvbv5/descriptors/cat.c
@@ -65,7 +65,7 @@ void dvb_table_cat_free(struct dvb_table_cat *cat)
 
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
index 2cfc679..2214133 100644
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
index 51c7d2b..c3bfc33 100644
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
index 8525579..81f7b36 100644
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
index 9a911a3..fa6d2cd 100644
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
-		dvb_log("|       frequency : %u", d->frequency[i]);
+		dvb_log("|           frequency : %u", d->frequency[i]);
 	}
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_hierarchy.c b/lib/libdvbv5/descriptors/desc_hierarchy.c
index b6e0adc..cf14824 100644
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
index 3d234e1..dfdf40f 100644
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
index e73bf78..c86de91 100644
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
index d7ebe1d..2cb3a01 100644
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
index 6ce9f66..43a12d8 100644
--- a/lib/libdvbv5/descriptors/mpeg_pes.c
+++ b/lib/libdvbv5/descriptors/mpeg_pes.c
@@ -109,7 +109,7 @@ void dvb_mpeg_pes_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_pes *pes)
 		   pes->stream_id == DVB_MPEG_STREAM_DIRECTORY ||
 		   pes->stream_id == DVB_MPEG_STREAM_DSMCC ||
 		   pes->stream_id == DVB_MPEG_STREAM_H222E ) {
-		dvb_log("  mpeg pes unsupported stream type %#04x", pes->stream_id);
+		dvb_log("  mpeg pes unsupported stream type 0x%04x", pes->stream_id);
 	} else {
 		dvb_loginfo("  mpeg pes optional");
 		dvb_loginfo("   - two                      %d", pes->optional->two);
diff --git a/lib/libdvbv5/descriptors/mpeg_ts.c b/lib/libdvbv5/descriptors/mpeg_ts.c
index e1e115f..e846b3e 100644
--- a/lib/libdvbv5/descriptors/mpeg_ts.c
+++ b/lib/libdvbv5/descriptors/mpeg_ts.c
@@ -28,7 +28,7 @@ ssize_t dvb_mpeg_ts_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssiz
 	const uint8_t *p = buf;
 
 	if (buf[0] != DVB_MPEG_TS) {
-		dvb_logerr("mpeg ts invalid marker %#02x, sould be %#02x", buf[0], DVB_MPEG_TS);
+		dvb_logerr("mpeg ts invalid marker 0x%02x, sould be 0x%02x", buf[0], DVB_MPEG_TS);
 		*table_length = 0;
 		return -1;
 	}
@@ -55,26 +55,25 @@ void dvb_mpeg_ts_free(struct dvb_mpeg_ts *ts)
 
 void dvb_mpeg_ts_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_ts *ts)
 {
-	dvb_loginfo("MPEG TS");
-	dvb_loginfo(" - sync byte       0x%02x", ts->sync_byte);
-	dvb_loginfo(" - tei                %d", ts->tei);
-	dvb_loginfo(" - payload_start      %d", ts->payload_start);
-	dvb_loginfo(" - priority           %d", ts->priority);
-	dvb_loginfo(" - pid           0x%04x", ts->pid);
-	dvb_loginfo(" - scrambling         %d", ts->scrambling);
-	dvb_loginfo(" - adaptation_field   %d", ts->adaptation_field);
-	dvb_loginfo(" - payload present    %d", ts->payload);
-	dvb_loginfo(" - continuity_counter %d", ts->continuity_counter);
-	if (ts->adaptation_field) {
-		dvb_loginfo(" Adaption Field");
-                dvb_loginfo("   - length         %d", ts->adaption->length);
-                dvb_loginfo("   - discontinued   %d", ts->adaption->discontinued);
-                dvb_loginfo("   - random_access  %d", ts->adaption->random_access);
-                dvb_loginfo("   - priority       %d", ts->adaption->priority);
-                dvb_loginfo("   - PCR            %d", ts->adaption->PCR);
-                dvb_loginfo("   - OPCR           %d", ts->adaption->OPCR);
-                dvb_loginfo("   - splicing_point %d", ts->adaption->splicing_point);
-                dvb_loginfo("   - private_data   %d", ts->adaption->private_data);
-                dvb_loginfo("   - extension      %d", ts->adaption->extension);
+	dvb_log("MPEG TS");
+	dvb_log(" - sync byte        0x%02x", ts->sync_byte);
+	dvb_log(" - tei                %d", ts->tei);
+	dvb_log(" - payload_start      %d", ts->payload_start);
+	dvb_log(" - priority           %d", ts->priority);
+	dvb_log(" - pid              0x%04x", ts->pid);
+	dvb_log(" - scrambling         %d", ts->scrambling);
+	dvb_log(" - adaptation_field   %d", ts->adaptation_field);
+	dvb_log(" - continuity_counter %d", ts->continuity_counter);
+	if (ts->adaptation_field & 0x2) {
+		dvb_log(" Adaption Field");
+                dvb_log("   - length         %d", ts->adaption->length);
+                dvb_log("   - discontinued   %d", ts->adaption->discontinued);
+                dvb_log("   - random_access  %d", ts->adaption->random_access);
+                dvb_log("   - priority       %d", ts->adaption->priority);
+                dvb_log("   - PCR            %d", ts->adaption->PCR);
+                dvb_log("   - OPCR           %d", ts->adaption->OPCR);
+                dvb_log("   - splicing_point %d", ts->adaption->splicing_point);
+                dvb_log("   - private_data   %d", ts->adaption->private_data);
+                dvb_log("   - extension      %d", ts->adaption->extension);
 	}
 }
diff --git a/lib/libdvbv5/descriptors/nit.c b/lib/libdvbv5/descriptors/nit.c
index 054a924..1c08f0e 100644
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
index 2000729..ac5b5d4 100644
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
diff --git a/lib/libdvbv5/descriptors/sdt.c b/lib/libdvbv5/descriptors/sdt.c
index 5e0c924..5c354f1 100644
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
1.8.3.2

