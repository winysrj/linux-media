Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:58246 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776AbaDIW1Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 18:27:25 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so2378204eek.36
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 15:27:24 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 6/7] libdvbv5: cleanup printing of tables and descriptors
Date: Thu, 10 Apr 2014 00:26:59 +0200
Message-Id: <1397082420-31198-6-git-send-email-neolynx@gmail.com>
In-Reply-To: <1397082420-31198-1-git-send-email-neolynx@gmail.com>
References: <1397082420-31198-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- use log info for table and descpritor printing
- cleanup 'out of memory' logs
- fix error condition in desc_ts_info

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/atsc_header.h                 |    2 +-
 lib/libdvbv5/descriptors.c                         |    4 +-
 lib/libdvbv5/descriptors/atsc_eit.c                |   18 ++++----
 lib/libdvbv5/descriptors/cat.c                     |    2 +-
 .../descriptors/desc_atsc_service_location.c       |   12 +++---
 lib/libdvbv5/descriptors/desc_ca.c                 |    6 +--
 lib/libdvbv5/descriptors/desc_ca_identifier.c      |    2 +-
 lib/libdvbv5/descriptors/desc_cable_delivery.c     |   12 +++---
 lib/libdvbv5/descriptors/desc_event_extended.c     |    2 +-
 lib/libdvbv5/descriptors/desc_event_short.c        |    6 +--
 lib/libdvbv5/descriptors/desc_extension.c          |    4 +-
 lib/libdvbv5/descriptors/desc_frequency_list.c     |    4 +-
 lib/libdvbv5/descriptors/desc_hierarchy.c          |    8 ++--
 lib/libdvbv5/descriptors/desc_isdbt_delivery.c     |    8 ++--
 lib/libdvbv5/descriptors/desc_language.c           |    2 +-
 lib/libdvbv5/descriptors/desc_logical_channel.c    |    8 ++--
 lib/libdvbv5/descriptors/desc_network_name.c       |    2 +-
 lib/libdvbv5/descriptors/desc_partial_reception.c  |    4 +-
 lib/libdvbv5/descriptors/desc_sat.c                |   14 +++---
 lib/libdvbv5/descriptors/desc_service.c            |    6 +--
 lib/libdvbv5/descriptors/desc_service_list.c       |    4 +-
 lib/libdvbv5/descriptors/desc_service_location.c   |    8 ++--
 lib/libdvbv5/descriptors/desc_t2_delivery.c        |   28 ++++++------
 .../descriptors/desc_terrestrial_delivery.c        |   26 +++++------
 lib/libdvbv5/descriptors/desc_ts_info.c            |   16 ++++---
 lib/libdvbv5/descriptors/eit.c                     |   26 +++++------
 lib/libdvbv5/descriptors/header.c                  |   22 +++++-----
 lib/libdvbv5/descriptors/mgt.c                     |   22 +++++-----
 lib/libdvbv5/descriptors/mpeg_es.c                 |   30 ++++++-------
 lib/libdvbv5/descriptors/mpeg_pes.c                |    2 +-
 lib/libdvbv5/descriptors/mpeg_ts.c                 |   38 ++++++++---------
 lib/libdvbv5/descriptors/nit.c                     |   17 ++++----
 lib/libdvbv5/descriptors/pat.c                     |    2 +-
 lib/libdvbv5/descriptors/sdt.c                     |   22 +++++-----
 lib/libdvbv5/descriptors/vct.c                     |   45 ++++++++++----------
 lib/libdvbv5/dvb-scan.c                            |    4 +-
 36 files changed, 222 insertions(+), 216 deletions(-)

diff --git a/lib/include/libdvbv5/atsc_header.h b/lib/include/libdvbv5/atsc_header.h
index 12e7379..96bfc11 100644
--- a/lib/include/libdvbv5/atsc_header.h
+++ b/lib/include/libdvbv5/atsc_header.h
@@ -34,7 +34,7 @@
 
 #define ATSC_TABLE_HEADER_PRINT(_parms, _table) \
 	dvb_table_header_print(_parms, &_table->header); \
-	dvb_log("| protocol_version %d", _table->protocol_version); \
+	dvb_loginfo("| protocol_version %d", _table->protocol_version); \
 
 
 #endif
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 54ce933..539f824 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -178,7 +178,7 @@ void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc)
 		dvb_desc_print_func print = dvb_descriptors[desc->type].print;
 		if (!print)
 			print = dvb_desc_default_print;
-		dvb_log("|        0x%02x: %s", desc->type, dvb_descriptors[desc->type].name);
+		dvb_loginfo("|        0x%02x: %s", desc->type, dvb_descriptors[desc->type].name);
 		print(parms, desc);
 		desc = desc->next;
 	}
@@ -1374,6 +1374,6 @@ void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned c
 		for (i = strlen(hex); i < 49; i++)
 			strncat(spaces, " ", sizeof(spaces));
 		ascii[j] = '\0';
-		dvb_log("%s%s %s %s", prefix, hex, spaces, ascii);
+		dvb_loginfo("%s%s %s %s", prefix, hex, spaces, ascii);
 	}
 }
diff --git a/lib/libdvbv5/descriptors/atsc_eit.c b/lib/libdvbv5/descriptors/atsc_eit.c
index 2b446bb..985b055 100644
--- a/lib/libdvbv5/descriptors/atsc_eit.c
+++ b/lib/libdvbv5/descriptors/atsc_eit.c
@@ -138,7 +138,7 @@ void atsc_table_eit_free(struct atsc_table_eit *eit)
 
 void atsc_table_eit_print(struct dvb_v5_fe_parms *parms, struct atsc_table_eit *eit)
 {
-	dvb_log("EIT");
+	dvb_loginfo("EIT");
 	ATSC_TABLE_HEADER_PRINT(parms, eit);
 	const struct atsc_table_eit_event *event = eit->event;
 	uint16_t events = 0;
@@ -147,18 +147,18 @@ void atsc_table_eit_print(struct dvb_v5_fe_parms *parms, struct atsc_table_eit *
 		char start[255];
 
 		strftime(start, sizeof(start), "%F %T", &event->start);
-		dvb_log("|-  event %7d", event->event_id);
-		dvb_log("|   Source                %d", event->source_id);
-		dvb_log("|   Starttime             %d", event->start_time);
-		dvb_log("|   Start                 %s UTC", start);
-		dvb_log("|   Duration              %dh %dm %ds", event->duration / 3600, (event->duration % 3600) / 60, event->duration % 60);
-		dvb_log("|   ETM                   %d", event->etm);
-		dvb_log("|   title length          %d", event->title_length);
+		dvb_loginfo("|-  event %7d", event->event_id);
+		dvb_loginfo("|   Source                %d", event->source_id);
+		dvb_loginfo("|   Starttime             %d", event->start_time);
+		dvb_loginfo("|   Start                 %s UTC", start);
+		dvb_loginfo("|   Duration              %dh %dm %ds", event->duration / 3600, (event->duration % 3600) / 60, event->duration % 60);
+		dvb_loginfo("|   ETM                   %d", event->etm);
+		dvb_loginfo("|   title length          %d", event->title_length);
 		dvb_print_descriptors(parms, event->descriptor);
 		event = event->next;
 		events++;
 	}
-	dvb_log("|_  %d events", events);
+	dvb_loginfo("|_  %d events", events);
 }
 
 void atsc_time(const uint32_t start_time, struct tm *tm)
diff --git a/lib/libdvbv5/descriptors/cat.c b/lib/libdvbv5/descriptors/cat.c
index 04b9416..a8fb00b 100644
--- a/lib/libdvbv5/descriptors/cat.c
+++ b/lib/libdvbv5/descriptors/cat.c
@@ -88,7 +88,7 @@ void dvb_table_cat_free(struct dvb_table_cat *cat)
 
 void dvb_table_cat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_cat *cat)
 {
-	dvb_log("CAT");
+	dvb_loginfo("CAT");
 	dvb_table_header_print(parms, &cat->header);
 	dvb_print_descriptors(parms, cat->descriptor);
 }
diff --git a/lib/libdvbv5/descriptors/desc_atsc_service_location.c b/lib/libdvbv5/descriptors/desc_atsc_service_location.c
index a654adc..3f19e72 100644
--- a/lib/libdvbv5/descriptors/desc_atsc_service_location.c
+++ b/lib/libdvbv5/descriptors/desc_atsc_service_location.c
@@ -64,13 +64,13 @@ void atsc_desc_service_location_print(struct dvb_v5_fe_parms *parms, const struc
 	struct atsc_desc_service_location_elementary *el = s_loc->elementary;
 	int i;
 
-	dvb_log("|           pcr PID               %d", s_loc->pcr_pid);
-	dvb_log("|\\ elementary service - %d elementaries", s_loc->number_elements);
+	dvb_loginfo("|           pcr PID               %d", s_loc->pcr_pid);
+	dvb_loginfo("|\\ elementary service - %d elementaries", s_loc->number_elements);
 	for (i = 0; i < s_loc->number_elements; i++) {
-		dvb_log("|-  elementary %d", i);
-		dvb_log("|-      | stream type 0x%02x", el[i].stream_type);
-		dvb_log("|-      | PID         %d", el[i].elementary_pid);
-		dvb_log("|-      | Language    %c%c%c",
+		dvb_loginfo("|-  elementary %d", i);
+		dvb_loginfo("|-      | stream type 0x%02x", el[i].stream_type);
+		dvb_loginfo("|-      | PID         %d", el[i].elementary_pid);
+		dvb_loginfo("|-      | Language    %c%c%c",
 			el[i].ISO_639_language_code[0],
 			el[i].ISO_639_language_code[1],
 			el[i].ISO_639_language_code[2]);
diff --git a/lib/libdvbv5/descriptors/desc_ca.c b/lib/libdvbv5/descriptors/desc_ca.c
index 791bda2..fa18814 100644
--- a/lib/libdvbv5/descriptors/desc_ca.c
+++ b/lib/libdvbv5/descriptors/desc_ca.c
@@ -48,9 +48,9 @@ int dvb_desc_ca_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct d
 void dvb_desc_ca_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_ca *d = (const struct dvb_desc_ca *) desc;
-	dvb_log("|           ca_id             0x%04x", d->ca_id);
-	dvb_log("|           ca_pid            0x%04x", d->ca_pid);
-	dvb_log("|           privdata length   %d", d->privdata_len);
+	dvb_loginfo("|           ca_id             0x%04x", d->ca_id);
+	dvb_loginfo("|           ca_pid            0x%04x", d->ca_pid);
+	dvb_loginfo("|           privdata length   %d", d->privdata_len);
 	if (d->privdata)
 		hexdump(parms, "|           privdata          ", d->privdata, d->privdata_len);
 }
diff --git a/lib/libdvbv5/descriptors/desc_ca_identifier.c b/lib/libdvbv5/descriptors/desc_ca_identifier.c
index 3102d01..23c8e89 100644
--- a/lib/libdvbv5/descriptors/desc_ca_identifier.c
+++ b/lib/libdvbv5/descriptors/desc_ca_identifier.c
@@ -46,7 +46,7 @@ void dvb_desc_ca_identifier_print(struct dvb_v5_fe_parms *parms, const struct dv
 	int i;
 
 	for (i = 0; i < d->caid_count; i++)
-		dvb_log("|           caid %d            0x%04x", i, d->caids[i]);
+		dvb_loginfo("|           caid %d            0x%04x", i, d->caids[i]);
 }
 
 void dvb_desc_ca_identifier_free(struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_cable_delivery.c b/lib/libdvbv5/descriptors/desc_cable_delivery.c
index 2ba0ce6..852c79e 100644
--- a/lib/libdvbv5/descriptors/desc_cable_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_cable_delivery.c
@@ -41,12 +41,12 @@ int dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *b
 void dvb_desc_cable_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_cable_delivery *cable = (const struct dvb_desc_cable_delivery *) desc;
-	dvb_log("|           length            %d", cable->length);
-	dvb_log("|           frequency         %d", cable->frequency);
-	dvb_log("|           fec outer         %d", cable->fec_outer);
-	dvb_log("|           modulation        %d", cable->modulation);
-	dvb_log("|           symbol_rate       %d", cable->symbol_rate);
-	dvb_log("|           fec inner         %d", cable->fec_inner);
+	dvb_loginfo("|           length            %d", cable->length);
+	dvb_loginfo("|           frequency         %d", cable->frequency);
+	dvb_loginfo("|           fec outer         %d", cable->fec_outer);
+	dvb_loginfo("|           modulation        %d", cable->modulation);
+	dvb_loginfo("|           symbol_rate       %d", cable->symbol_rate);
+	dvb_loginfo("|           fec inner         %d", cable->fec_inner);
 }
 
 const unsigned dvbc_fec_table[] = {
diff --git a/lib/libdvbv5/descriptors/desc_event_extended.c b/lib/libdvbv5/descriptors/desc_event_extended.c
index 346a71c..d0865f9 100644
--- a/lib/libdvbv5/descriptors/desc_event_extended.c
+++ b/lib/libdvbv5/descriptors/desc_event_extended.c
@@ -74,6 +74,6 @@ void dvb_desc_event_extended_free(struct dvb_desc *desc)
 void dvb_desc_event_extended_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_event_extended *event = (const struct dvb_desc_event_extended *) desc;
-	dvb_log("|           '%s'", event->text);
+	dvb_loginfo("|           '%s'", event->text);
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_event_short.c b/lib/libdvbv5/descriptors/desc_event_short.c
index e9d7bd7..535e656 100644
--- a/lib/libdvbv5/descriptors/desc_event_short.c
+++ b/lib/libdvbv5/descriptors/desc_event_short.c
@@ -67,8 +67,8 @@ void dvb_desc_event_short_free(struct dvb_desc *desc)
 void dvb_desc_event_short_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_event_short *event = (const struct dvb_desc_event_short *) desc;
-	dvb_log("|           name          '%s'", event->name);
-	dvb_log("|           language      '%s'", event->language);
-	dvb_log("|           sescription   '%s'", event->text);
+	dvb_loginfo("|           name          '%s'", event->name);
+	dvb_loginfo("|           language      '%s'", event->language);
+	dvb_loginfo("|           sescription   '%s'", event->text);
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_extension.c b/lib/libdvbv5/descriptors/desc_extension.c
index 0aaeba8..7d9337c 100644
--- a/lib/libdvbv5/descriptors/desc_extension.c
+++ b/lib/libdvbv5/descriptors/desc_extension.c
@@ -138,7 +138,7 @@ int extension_descriptor_init(struct dvb_v5_fe_parms *parms,
 			break;
 		/* fall through */
 	case 3:
-		dvb_log("%sextension descriptor %s type 0x%02x, size %d",
+		dvb_logwarn("%sextension descriptor %s type 0x%02x, size %d",
 			dvb_ext_descriptors[desc_type].init ? "" : "Not handled ",
 			dvb_ext_descriptors[desc_type].name, desc_type, desc_len);
 		hexdump(parms, "content: ", p, desc_len);
@@ -180,7 +180,7 @@ void extension_descriptor_print(struct dvb_v5_fe_parms *parms,
 {
 	struct dvb_extension_descriptor *ext = (void *)desc;
 	uint8_t type = ext->extension_code;
-	dvb_log("|           descriptor %s type 0x%02x",
+	dvb_loginfo("|           descriptor %s type 0x%02x",
 		dvb_ext_descriptors[type].name, type);
 
 	if (dvb_ext_descriptors[type].print)
diff --git a/lib/libdvbv5/descriptors/desc_frequency_list.c b/lib/libdvbv5/descriptors/desc_frequency_list.c
index a9a3b9e..5b235d4 100644
--- a/lib/libdvbv5/descriptors/desc_frequency_list.c
+++ b/lib/libdvbv5/descriptors/desc_frequency_list.c
@@ -59,11 +59,11 @@ int dvb_desc_frequency_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *b
 void dvb_desc_frequency_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_frequency_list *d = (const struct dvb_desc_frequency_list *) desc;
-	dvb_log("|           type: %d", d->freq_type);
+	dvb_loginfo("|           type: %d", d->freq_type);
 	int i = 0;
 
 	for (i = 0; i < d->frequencies; i++) {
-		dvb_log("|           frequency : %u", d->frequency[i]);
+		dvb_loginfo("|           frequency : %u", d->frequency[i]);
 	}
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_hierarchy.c b/lib/libdvbv5/descriptors/desc_hierarchy.c
index 17b3699..773068f 100644
--- a/lib/libdvbv5/descriptors/desc_hierarchy.c
+++ b/lib/libdvbv5/descriptors/desc_hierarchy.c
@@ -35,9 +35,9 @@ int dvb_desc_hierarchy_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, s
 void dvb_desc_hierarchy_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_hierarchy *hierarchy = (const struct dvb_desc_hierarchy *) desc;
-	dvb_log("|           type           %d", hierarchy->hierarchy_type);
-	dvb_log("|           layer          %d", hierarchy->layer);
-	dvb_log("|           embedded_layer %d", hierarchy->embedded_layer);
-	dvb_log("|           channel        %d", hierarchy->channel);
+	dvb_loginfo("|           type           %d", hierarchy->hierarchy_type);
+	dvb_loginfo("|           layer          %d", hierarchy->layer);
+	dvb_loginfo("|           embedded_layer %d", hierarchy->embedded_layer);
+	dvb_loginfo("|           channel        %d", hierarchy->channel);
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_isdbt_delivery.c b/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
index 336ca85..e25ce46 100644
--- a/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
@@ -83,14 +83,14 @@ void isdbt_desc_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_d
 	const struct isdbt_desc_terrestrial_delivery_system *d = (const void *) desc;
 	int i;
 
-	dvb_log("|           transmission mode %s (%d)",
+	dvb_loginfo("|           transmission mode %s (%d)",
 		tm_name[d->transmission_mode], d->transmission_mode);
-	dvb_log("|           guard interval    %s (%d)",
+	dvb_loginfo("|           guard interval    %s (%d)",
 		interval_name[d->guard_interval], d->guard_interval);
-	dvb_log("|           area code         %d", d->area_code);
+	dvb_loginfo("|           area code         %d", d->area_code);
 
 	for (i = 0; i < d->num_freqs; i++) {
-		dvb_log("|           frequency[%d]      %ld Hz", i, d->frequency[i] * 1000000l / 7);
+		dvb_loginfo("|           frequency[%d]      %ld Hz", i, d->frequency[i] * 1000000l / 7);
 	}
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_language.c b/lib/libdvbv5/descriptors/desc_language.c
index 7504dd5..617fcc7 100644
--- a/lib/libdvbv5/descriptors/desc_language.c
+++ b/lib/libdvbv5/descriptors/desc_language.c
@@ -37,6 +37,6 @@ int dvb_desc_language_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, st
 void dvb_desc_language_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_language *lang = (const struct dvb_desc_language *) desc;
-	dvb_log("|           lang: %s (type: %d)", lang->language, lang->audio_type);
+	dvb_loginfo("|           lang: %s (type: %d)", lang->language, lang->audio_type);
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_logical_channel.c b/lib/libdvbv5/descriptors/desc_logical_channel.c
index 7137c57..99a4507 100644
--- a/lib/libdvbv5/descriptors/desc_logical_channel.c
+++ b/lib/libdvbv5/descriptors/desc_logical_channel.c
@@ -36,7 +36,7 @@ int dvb_desc_logical_channel_init(struct dvb_v5_fe_parms *parms,
 
 	d->lcn = malloc(d->length);
 	if (!d->lcn) {
-		dvb_perror("Out of memory!");
+		dvb_logerr("%s: out of memory", __func__);
 		return -1;
 	}
 
@@ -60,9 +60,9 @@ void dvb_desc_logical_channel_print(struct dvb_v5_fe_parms *parms, const struct
 	len = d->length / sizeof(d->lcn);
 
 	for (i = 0; i < len; i++) {
-		dvb_log("|           service ID[%d]     %d", i, d->lcn[i].service_id);
-		dvb_log("|           LCN             %d", d->lcn[i].logical_channel_number);
-		dvb_log("|           visible service %d", d->lcn[i].visible_service_flag);
+		dvb_loginfo("|           service ID[%d]     %d", i, d->lcn[i].service_id);
+		dvb_loginfo("|           LCN             %d", d->lcn[i].logical_channel_number);
+		dvb_loginfo("|           visible service %d", d->lcn[i].visible_service_flag);
 	}
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_network_name.c b/lib/libdvbv5/descriptors/desc_network_name.c
index 0fa456f..a34a27f 100644
--- a/lib/libdvbv5/descriptors/desc_network_name.c
+++ b/lib/libdvbv5/descriptors/desc_network_name.c
@@ -42,7 +42,7 @@ void dvb_desc_network_name_print(struct dvb_v5_fe_parms *parms, const struct dvb
 {
 	const struct dvb_desc_network_name *net = (const struct dvb_desc_network_name *) desc;
 
-	dvb_log("|           network name: '%s'", net->network_name);
+	dvb_loginfo("|           network name: '%s'", net->network_name);
 }
 
 void dvb_desc_network_name_free(struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_partial_reception.c b/lib/libdvbv5/descriptors/desc_partial_reception.c
index 0e4d25c..390080c 100644
--- a/lib/libdvbv5/descriptors/desc_partial_reception.c
+++ b/lib/libdvbv5/descriptors/desc_partial_reception.c
@@ -33,7 +33,7 @@ int isdb_desc_partial_reception_init(struct dvb_v5_fe_parms *parms,
 
 	d->partial_reception = malloc(d->length);
 	if (!d->partial_reception) {
-		dvb_perror("Out of memory!");
+		dvb_logerr("%s: out of memory", __func__);
 		return -1;
 	}
 
@@ -62,6 +62,6 @@ void isdb_desc_partial_reception_print(struct dvb_v5_fe_parms *parms, const stru
 	len = d->length / sizeof(d->partial_reception);
 
 	for (i = 0; i < len; i++) {
-		dvb_log("|           service ID[%d]     %d", i, d->partial_reception[i].service_id);
+		dvb_loginfo("|           service ID[%d]     %d", i, d->partial_reception[i].service_id);
 	}
 }
diff --git a/lib/libdvbv5/descriptors/desc_sat.c b/lib/libdvbv5/descriptors/desc_sat.c
index 5494799..f7fb8f1 100644
--- a/lib/libdvbv5/descriptors/desc_sat.c
+++ b/lib/libdvbv5/descriptors/desc_sat.c
@@ -57,13 +57,13 @@ void dvb_desc_sat_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *de
 			pol = 'R';
 			break;
 	}
-	dvb_log("|           modulation_system %s", sat->modulation_system ? "DVB-S2" : "DVB-S");
-	dvb_log("|           frequency         %d %c", sat->frequency, pol);
-	dvb_log("|           symbol_rate       %d", sat->symbol_rate);
-	dvb_log("|           fec               %d", sat->fec);
-	dvb_log("|           modulation_type   %d", sat->modulation_type);
-	dvb_log("|           roll_off          %d", sat->roll_off);
-	dvb_log("|           orbit             %.1f %c", (float) sat->orbit / 10.0, sat->west_east ? 'E' : 'W');
+	dvb_loginfo("|           modulation_system %s", sat->modulation_system ? "DVB-S2" : "DVB-S");
+	dvb_loginfo("|           frequency         %d %c", sat->frequency, pol);
+	dvb_loginfo("|           symbol_rate       %d", sat->symbol_rate);
+	dvb_loginfo("|           fec               %d", sat->fec);
+	dvb_loginfo("|           modulation_type   %d", sat->modulation_type);
+	dvb_loginfo("|           roll_off          %d", sat->roll_off);
+	dvb_loginfo("|           orbit             %.1f %c", (float) sat->orbit / 10.0, sat->west_east ? 'E' : 'W');
 }
 
 const unsigned dvbs_dvbc_dvbs_freq_inner[] = {
diff --git a/lib/libdvbv5/descriptors/desc_service.c b/lib/libdvbv5/descriptors/desc_service.c
index 7289219..069317a 100644
--- a/lib/libdvbv5/descriptors/desc_service.c
+++ b/lib/libdvbv5/descriptors/desc_service.c
@@ -62,8 +62,8 @@ void dvb_desc_service_free(struct dvb_desc *desc)
 void dvb_desc_service_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_service *service = (const struct dvb_desc_service *) desc;
-	dvb_log("|           service type  %d", service->service_type);
-	dvb_log("|           name          '%s'", service->name);
-	dvb_log("|           provider      '%s'", service->provider);
+	dvb_loginfo("|           service type  %d", service->service_type);
+	dvb_loginfo("|           provider      '%s'", service->provider);
+	dvb_loginfo("|           name          '%s'", service->name);
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_service_list.c b/lib/libdvbv5/descriptors/desc_service_list.c
index 3e7e603..4cd4018 100644
--- a/lib/libdvbv5/descriptors/desc_service_list.c
+++ b/lib/libdvbv5/descriptors/desc_service_list.c
@@ -48,8 +48,8 @@ void dvb_desc_service_list_print(struct dvb_v5_fe_parms *parms, const struct dvb
 	/*const struct dvb_desc_service_list *slist = (const struct dvb_desc_service_list *) desc;*/
 	/*int i = 0;*/
 	/*while(slist->services[i].service_id != 0) {*/
-		/*dvb_log("|           service id   : '%d'", slist->services[i].service_id);*/
-		/*dvb_log("|           service type : '%d'", slist->services[i].service_type);*/
+		/*dvb_loginfo("|           service id   : '%d'", slist->services[i].service_id);*/
+		/*dvb_loginfo("|           service type : '%d'", slist->services[i].service_type);*/
 		/*++i;*/
 	/*}*/
 }
diff --git a/lib/libdvbv5/descriptors/desc_service_location.c b/lib/libdvbv5/descriptors/desc_service_location.c
index 3a571fd..95cb342 100644
--- a/lib/libdvbv5/descriptors/desc_service_location.c
+++ b/lib/libdvbv5/descriptors/desc_service_location.c
@@ -65,11 +65,11 @@ void dvb_desc_service_location_print(struct dvb_v5_fe_parms *parms, const struct
 	struct dvb_desc_service_location_element *element = service_location->element;
 	int i;
 
-	dvb_log("|    pcr pid      %d", service_location->pcr_pid);
-	dvb_log("|    streams:");
+	dvb_loginfo("|    pcr pid      %d", service_location->pcr_pid);
+	dvb_loginfo("|    streams:");
 	for (i = 0; i < service_location->elements; i++)
-		dvb_log("|      pid %d, type %d: %s", element[i].elementary_pid, element[i].stream_type, element[i].language);
-	dvb_log("| 	%d elements", service_location->elements);
+		dvb_loginfo("|      pid %d, type %d: %s", element[i].elementary_pid, element[i].stream_type, element[i].language);
+	dvb_loginfo("| 	%d elements", service_location->elements);
 }
 
 void dvb_desc_service_location_free(struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_t2_delivery.c b/lib/libdvbv5/descriptors/desc_t2_delivery.c
index 0d5cab6..498c707 100644
--- a/lib/libdvbv5/descriptors/desc_t2_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_t2_delivery.c
@@ -66,7 +66,7 @@ int dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
 	d->centre_frequency = calloc(d->frequency_loop_length,
 				     sizeof(*d->centre_frequency));
 	if (!d->centre_frequency) {
-		dvb_perror("Out of memory");
+		dvb_logerr("%s: out of memory", __func__);
 		return -3;
 	}
 
@@ -81,7 +81,7 @@ int dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
 
 	d->subcell = calloc(d->subcel_info_loop_length, sizeof(*d->subcell));
 	if (!d->subcell) {
-		dvb_perror("Out of memory");
+		dvb_logerr("%s: out of memory", __func__);
 		return -4;
 	}
 	memcpy(d->subcell, p, sizeof(*d->subcell) * d->subcel_info_loop_length);
@@ -98,26 +98,26 @@ void dvb_desc_t2_delivery_print(struct dvb_v5_fe_parms *parms,
 	const struct dvb_desc_t2_delivery *d = desc;
 	int i;
 
-	dvb_log("|           plp_id                    %d", d->plp_id);
-	dvb_log("|           system_id                 %d", d->system_id);
+	dvb_loginfo("|           plp_id                    %d", d->plp_id);
+	dvb_loginfo("|           system_id                 %d", d->system_id);
 
 	if (ext->length - 1 <= 4)
 		return;
 
-	dvb_log("|           tfs_flag                  %d", d->tfs_flag);
-	dvb_log("|           other_frequency_flag      %d", d->other_frequency_flag);
-	dvb_log("|           transmission_mode         %d", d->transmission_mode);
-	dvb_log("|           guard_interval            %d", d->guard_interval);
-	dvb_log("|           reserved                  %d", d->reserved);
-	dvb_log("|           bandwidth                 %d", d->bandwidth);
-	dvb_log("|           SISO MISO                 %d", d->SISO_MISO);
+	dvb_loginfo("|           tfs_flag                  %d", d->tfs_flag);
+	dvb_loginfo("|           other_frequency_flag      %d", d->other_frequency_flag);
+	dvb_loginfo("|           transmission_mode         %d", d->transmission_mode);
+	dvb_loginfo("|           guard_interval            %d", d->guard_interval);
+	dvb_loginfo("|           reserved                  %d", d->reserved);
+	dvb_loginfo("|           bandwidth                 %d", d->bandwidth);
+	dvb_loginfo("|           SISO MISO                 %d", d->SISO_MISO);
 
 	for (i = 0; i < d->frequency_loop_length; i++)
-		dvb_log("|           centre frequency[%d]   %d", i, d->centre_frequency[i]);
+		dvb_loginfo("|           centre frequency[%d]   %d", i, d->centre_frequency[i]);
 
 	for (i = 0; i < d->subcel_info_loop_length; i++) {
-		dvb_log("|           cell_id_extension[%d]  %d", i, d->subcell[i].cell_id_extension);
-		dvb_log("|           transposer frequency   %d", d->subcell[i].transposer_frequency);
+		dvb_loginfo("|           cell_id_extension[%d]  %d", i, d->subcell[i].cell_id_extension);
+		dvb_loginfo("|           transposer frequency   %d", d->subcell[i].transposer_frequency);
 	}
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c b/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
index 8b6a92d..8df1a53 100644
--- a/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
@@ -39,19 +39,19 @@ int dvb_desc_terrestrial_delivery_init(struct dvb_v5_fe_parms *parms, const uint
 void dvb_desc_terrestrial_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_terrestrial_delivery *tdel = (const struct dvb_desc_terrestrial_delivery *) desc;
-	dvb_log("|           length                %d", tdel->length);
-	dvb_log("|           centre frequency      %d", tdel->centre_frequency * 10);
-	dvb_log("|           mpe_fec_indicator     %d", tdel->mpe_fec_indicator);
-	dvb_log("|           time_slice_indicator  %d", tdel->time_slice_indicator);
-	dvb_log("|           priority              %d", tdel->priority);
-	dvb_log("|           bandwidth             %d", tdel->bandwidth);
-	dvb_log("|           code_rate_hp_stream   %d", tdel->code_rate_hp_stream);
-	dvb_log("|           hierarchy_information %d", tdel->hierarchy_information);
-	dvb_log("|           constellation         %d", tdel->constellation);
-	dvb_log("|           other_frequency_flag  %d", tdel->other_frequency_flag);
-	dvb_log("|           transmission_mode     %d", tdel->transmission_mode);
-	dvb_log("|           guard_interval        %d", tdel->guard_interval);
-	dvb_log("|           code_rate_lp_stream   %d", tdel->code_rate_lp_stream);
+	dvb_loginfo("|           length                %d", tdel->length);
+	dvb_loginfo("|           centre frequency      %d", tdel->centre_frequency * 10);
+	dvb_loginfo("|           mpe_fec_indicator     %d", tdel->mpe_fec_indicator);
+	dvb_loginfo("|           time_slice_indicator  %d", tdel->time_slice_indicator);
+	dvb_loginfo("|           priority              %d", tdel->priority);
+	dvb_loginfo("|           bandwidth             %d", tdel->bandwidth);
+	dvb_loginfo("|           code_rate_hp_stream   %d", tdel->code_rate_hp_stream);
+	dvb_loginfo("|           hierarchy_information %d", tdel->hierarchy_information);
+	dvb_loginfo("|           constellation         %d", tdel->constellation);
+	dvb_loginfo("|           other_frequency_flag  %d", tdel->other_frequency_flag);
+	dvb_loginfo("|           transmission_mode     %d", tdel->transmission_mode);
+	dvb_loginfo("|           guard_interval        %d", tdel->guard_interval);
+	dvb_loginfo("|           code_rate_lp_stream   %d", tdel->code_rate_lp_stream);
 }
 
 const unsigned dvbt_bw[] = {
diff --git a/lib/libdvbv5/descriptors/desc_ts_info.c b/lib/libdvbv5/descriptors/desc_ts_info.c
index 7a6e520..75501af 100644
--- a/lib/libdvbv5/descriptors/desc_ts_info.c
+++ b/lib/libdvbv5/descriptors/desc_ts_info.c
@@ -49,8 +49,10 @@ int dvb_desc_ts_info_init(struct dvb_v5_fe_parms *parms,
 	t = &d->transmission_type;
 
 	d->service_id = malloc(sizeof(*d->service_id) * t->num_of_service);
-	if (!d->service_id)
-		dvb_perror("Out of memory!");
+	if (!d->service_id) {
+		dvb_logerr("%s: out of memory", __func__);
+		return -1;
+	}
 
 	memcpy(d->service_id, p, sizeof(*d->service_id) * t->num_of_service);
 
@@ -69,13 +71,13 @@ void dvb_desc_ts_info_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc
 
 	t = &d->transmission_type;
 
-	dvb_log("|           remote key ID     %d", d->remote_control_key_id);
-	dvb_log("|           name              %s", d->ts_name);
-	dvb_log("|           emphasis name     %s", d->ts_name_emph);
-	dvb_log("|           transmission type %s", d->ts_name_emph);
+	dvb_loginfo("|           remote key ID     %d", d->remote_control_key_id);
+	dvb_loginfo("|           name              %s", d->ts_name);
+	dvb_loginfo("|           emphasis name     %s", d->ts_name_emph);
+	dvb_loginfo("|           transmission type %s", d->ts_name_emph);
 
 	for (i = 0; i < t->num_of_service; i++)
-		dvb_log("|           service ID[%d]     %d", i, d->service_id[i]);
+		dvb_loginfo("|           service ID[%d]     %d", i, d->service_id[i]);
 }
 
 void dvb_desc_ts_info_free(struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/eit.c b/lib/libdvbv5/descriptors/eit.c
index 5197491..d66d492 100644
--- a/lib/libdvbv5/descriptors/eit.c
+++ b/lib/libdvbv5/descriptors/eit.c
@@ -131,29 +131,29 @@ void dvb_table_eit_free(struct dvb_table_eit *eit)
 
 void dvb_table_eit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_eit *eit)
 {
-	dvb_log("EIT");
+	dvb_loginfo("EIT");
 	dvb_table_header_print(parms, &eit->header);
-	dvb_log("|- transport_id       %d", eit->transport_id);
-	dvb_log("|- network_id         %d", eit->network_id);
-	dvb_log("|- last segment       %d", eit->last_segment);
-	dvb_log("|- last table         %d", eit->last_table_id);
-	dvb_log("|\\  event_id");
+	dvb_loginfo("|- transport_id       %d", eit->transport_id);
+	dvb_loginfo("|- network_id         %d", eit->network_id);
+	dvb_loginfo("|- last segment       %d", eit->last_segment);
+	dvb_loginfo("|- last table         %d", eit->last_table_id);
+	dvb_loginfo("|\\  event_id");
 	const struct dvb_table_eit_event *event = eit->event;
 	uint16_t events = 0;
 	while (event) {
 		char start[255];
 		strftime(start, sizeof(start), "%F %T", &event->start);
-		dvb_log("|- %7d", event->event_id);
-		dvb_log("|   Service               %d", event->service_id);
-		dvb_log("|   Start                 %s UTC", start);
-		dvb_log("|   Duration              %dh %dm %ds", event->duration / 3600, (event->duration % 3600) / 60, event->duration % 60);
-		dvb_log("|   free CA mode          %d", event->free_CA_mode);
-		dvb_log("|   running status        %d: %s", event->running_status, dvb_eit_running_status_name[event->running_status] );
+		dvb_loginfo("|- %7d", event->event_id);
+		dvb_loginfo("|   Service               %d", event->service_id);
+		dvb_loginfo("|   Start                 %s UTC", start);
+		dvb_loginfo("|   Duration              %dh %dm %ds", event->duration / 3600, (event->duration % 3600) / 60, event->duration % 60);
+		dvb_loginfo("|   free CA mode          %d", event->free_CA_mode);
+		dvb_loginfo("|   running status        %d: %s", event->running_status, dvb_eit_running_status_name[event->running_status] );
 		dvb_print_descriptors(parms, event->descriptor);
 		event = event->next;
 		events++;
 	}
-	dvb_log("|_  %d events", events);
+	dvb_loginfo("|_  %d events", events);
 }
 
 void dvb_time(const uint8_t data[5], struct tm *tm)
diff --git a/lib/libdvbv5/descriptors/header.c b/lib/libdvbv5/descriptors/header.c
index 3df73af..883283f 100644
--- a/lib/libdvbv5/descriptors/header.c
+++ b/lib/libdvbv5/descriptors/header.c
@@ -32,16 +32,16 @@ int dvb_table_header_init(struct dvb_table_header *t)
 
 void dvb_table_header_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_header *t)
 {
-	dvb_log("| table_id            %d", t->table_id);
-	dvb_log("| section_length      %d", t->section_length);
-	dvb_log("| one                 %d", t->one);
-	dvb_log("| zero                %d", t->zero);
-	dvb_log("| syntax              %d", t->syntax);
-	dvb_log("| transport_stream_id %d", t->id);
-	dvb_log("| current_next        %d", t->current_next);
-	dvb_log("| version             %d", t->version);
-	dvb_log("| one2                %d", t->one2);
-	dvb_log("| section_number      %d", t->section_id);
-	dvb_log("| last_section_number %d", t->last_section);
+	dvb_loginfo("| table_id         0x%02x", t->table_id);
+	dvb_loginfo("| section_length      %d", t->section_length);
+	dvb_loginfo("| one                 %d", t->one);
+	dvb_loginfo("| zero                %d", t->zero);
+	dvb_loginfo("| syntax              %d", t->syntax);
+	dvb_loginfo("| transport_stream_id %d", t->id);
+	dvb_loginfo("| current_next        %d", t->current_next);
+	dvb_loginfo("| version             %d", t->version);
+	dvb_loginfo("| one2                %d", t->one2);
+	dvb_loginfo("| section_number      %d", t->section_id);
+	dvb_loginfo("| last_section_number %d", t->last_section);
 }
 
diff --git a/lib/libdvbv5/descriptors/mgt.c b/lib/libdvbv5/descriptors/mgt.c
index b12d586..29172c3 100644
--- a/lib/libdvbv5/descriptors/mgt.c
+++ b/lib/libdvbv5/descriptors/mgt.c
@@ -95,7 +95,7 @@ ssize_t atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		*head = table;
 		head = &(*head)->next;
 
-		/* get the descriptors for each table */
+		/* parse the descriptors */
 		size = table->desc_length;
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
@@ -133,21 +133,21 @@ void atsc_table_mgt_print(struct dvb_v5_fe_parms *parms, struct atsc_table_mgt *
 	const struct atsc_table_mgt_table *table = mgt->table;
 	uint16_t tables = 0;
 
-	dvb_log("MGT");
+	dvb_loginfo("MGT");
 	ATSC_TABLE_HEADER_PRINT(parms, mgt);
-	dvb_log("| tables           %d", mgt->tables);
+	dvb_loginfo("| tables           %d", mgt->tables);
 	while (table) {
-                dvb_log("|- type %04x    %d", table->type, table->pid);
-                dvb_log("|  one          %d", table->one);
-                dvb_log("|  one2         %d", table->one2);
-                dvb_log("|  type version %d", table->type_version);
-                dvb_log("|  size         %d", table->size);
-                dvb_log("|  one3         %d", table->one3);
-                dvb_log("|  desc_length  %d", table->desc_length);
+                dvb_loginfo("|- type %04x    %d", table->type, table->pid);
+                dvb_loginfo("|  one          %d", table->one);
+                dvb_loginfo("|  one2         %d", table->one2);
+                dvb_loginfo("|  type version %d", table->type_version);
+                dvb_loginfo("|  size         %d", table->size);
+                dvb_loginfo("|  one3         %d", table->one3);
+                dvb_loginfo("|  desc_length  %d", table->desc_length);
 		dvb_print_descriptors(parms, table->descriptor);
 		table = table->next;
 		tables++;
 	}
-	dvb_log("|_  %d tables", tables);
+	dvb_loginfo("|_  %d tables", tables);
 }
 
diff --git a/lib/libdvbv5/descriptors/mpeg_es.c b/lib/libdvbv5/descriptors/mpeg_es.c
index f9cfbd7..e7d750f 100644
--- a/lib/libdvbv5/descriptors/mpeg_es.c
+++ b/lib/libdvbv5/descriptors/mpeg_es.c
@@ -35,17 +35,17 @@ int dvb_mpeg_es_seq_start_init(const uint8_t *buf, ssize_t buflen, struct dvb_mp
 
 void dvb_mpeg_es_seq_start_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_es_seq_start *seq_start)
 {
-	dvb_log("MPEG ES SEQ START");
-        dvb_log(" - width       %d", seq_start->width);
-        dvb_log(" - height      %d", seq_start->height);
-        dvb_log(" - aspect      %d", seq_start->aspect);
-        dvb_log(" - framerate   %d", seq_start->framerate);
-        dvb_log(" - bitrate     %d", seq_start->bitrate);
-        dvb_log(" - one         %d", seq_start->one);
-        dvb_log(" - vbv         %d", seq_start->vbv);
-        dvb_log(" - constrained %d", seq_start->constrained);
-        dvb_log(" - qm_intra    %d", seq_start->qm_intra);
-        dvb_log(" - qm_nonintra %d", seq_start->qm_nonintra);
+	dvb_loginfo("MPEG ES SEQ START");
+        dvb_loginfo(" - width       %d", seq_start->width);
+        dvb_loginfo(" - height      %d", seq_start->height);
+        dvb_loginfo(" - aspect      %d", seq_start->aspect);
+        dvb_loginfo(" - framerate   %d", seq_start->framerate);
+        dvb_loginfo(" - bitrate     %d", seq_start->bitrate);
+        dvb_loginfo(" - one         %d", seq_start->one);
+        dvb_loginfo(" - vbv         %d", seq_start->vbv);
+        dvb_loginfo(" - constrained %d", seq_start->constrained);
+        dvb_loginfo(" - qm_intra    %d", seq_start->qm_intra);
+        dvb_loginfo(" - qm_nonintra %d", seq_start->qm_nonintra);
 }
 
 const char *dvb_mpeg_es_frame_names[5] = {
@@ -68,8 +68,8 @@ int dvb_mpeg_es_pic_start_init(const uint8_t *buf, ssize_t buflen, struct dvb_mp
 
 void dvb_mpeg_es_pic_start_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_es_pic_start *pic_start)
 {
-	dvb_log("MPEG ES PIC START");
-        dvb_log(" - temporal_ref %d", pic_start->temporal_ref);
-        dvb_log(" - coding_type  %d (%s-frame)", pic_start->coding_type, dvb_mpeg_es_frame_names[pic_start->coding_type]);
-        dvb_log(" - vbv_delay    %d", pic_start->vbv_delay);
+	dvb_loginfo("MPEG ES PIC START");
+        dvb_loginfo(" - temporal_ref %d", pic_start->temporal_ref);
+        dvb_loginfo(" - coding_type  %d (%s-frame)", pic_start->coding_type, dvb_mpeg_es_frame_names[pic_start->coding_type]);
+        dvb_loginfo(" - vbv_delay    %d", pic_start->vbv_delay);
 }
diff --git a/lib/libdvbv5/descriptors/mpeg_pes.c b/lib/libdvbv5/descriptors/mpeg_pes.c
index 43a12d8..939c53c 100644
--- a/lib/libdvbv5/descriptors/mpeg_pes.c
+++ b/lib/libdvbv5/descriptors/mpeg_pes.c
@@ -109,7 +109,7 @@ void dvb_mpeg_pes_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_pes *pes)
 		   pes->stream_id == DVB_MPEG_STREAM_DIRECTORY ||
 		   pes->stream_id == DVB_MPEG_STREAM_DSMCC ||
 		   pes->stream_id == DVB_MPEG_STREAM_H222E ) {
-		dvb_log("  mpeg pes unsupported stream type 0x%04x", pes->stream_id);
+		dvb_logwarn("  mpeg pes unsupported stream type 0x%04x", pes->stream_id);
 	} else {
 		dvb_loginfo("  mpeg pes optional");
 		dvb_loginfo("   - two                      %d", pes->optional->two);
diff --git a/lib/libdvbv5/descriptors/mpeg_ts.c b/lib/libdvbv5/descriptors/mpeg_ts.c
index e846b3e..df32484 100644
--- a/lib/libdvbv5/descriptors/mpeg_ts.c
+++ b/lib/libdvbv5/descriptors/mpeg_ts.c
@@ -55,25 +55,25 @@ void dvb_mpeg_ts_free(struct dvb_mpeg_ts *ts)
 
 void dvb_mpeg_ts_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_ts *ts)
 {
-	dvb_log("MPEG TS");
-	dvb_log(" - sync byte        0x%02x", ts->sync_byte);
-	dvb_log(" - tei                %d", ts->tei);
-	dvb_log(" - payload_start      %d", ts->payload_start);
-	dvb_log(" - priority           %d", ts->priority);
-	dvb_log(" - pid              0x%04x", ts->pid);
-	dvb_log(" - scrambling         %d", ts->scrambling);
-	dvb_log(" - adaptation_field   %d", ts->adaptation_field);
-	dvb_log(" - continuity_counter %d", ts->continuity_counter);
+	dvb_loginfo("MPEG TS");
+	dvb_loginfo(" - sync            0x%02x", ts->sync_byte);
+	dvb_loginfo(" - tei                %d", ts->tei);
+	dvb_loginfo(" - payload_start      %d", ts->payload_start);
+	dvb_loginfo(" - priority           %d", ts->priority);
+	dvb_loginfo(" - pid           0x%04x", ts->pid);
+	dvb_loginfo(" - scrambling         %d", ts->scrambling);
+	dvb_loginfo(" - adaptation_field   %d", ts->adaptation_field);
+	dvb_loginfo(" - continuity_counter %d", ts->continuity_counter);
 	if (ts->adaptation_field & 0x2) {
-		dvb_log(" Adaption Field");
-                dvb_log("   - length         %d", ts->adaption->length);
-                dvb_log("   - discontinued   %d", ts->adaption->discontinued);
-                dvb_log("   - random_access  %d", ts->adaption->random_access);
-                dvb_log("   - priority       %d", ts->adaption->priority);
-                dvb_log("   - PCR            %d", ts->adaption->PCR);
-                dvb_log("   - OPCR           %d", ts->adaption->OPCR);
-                dvb_log("   - splicing_point %d", ts->adaption->splicing_point);
-                dvb_log("   - private_data   %d", ts->adaption->private_data);
-                dvb_log("   - extension      %d", ts->adaption->extension);
+		dvb_loginfo(" Adaption Field");
+                dvb_loginfo("   - length         %d", ts->adaption->length);
+                dvb_loginfo("   - discontinued   %d", ts->adaption->discontinued);
+                dvb_loginfo("   - random_access  %d", ts->adaption->random_access);
+                dvb_loginfo("   - priority       %d", ts->adaption->priority);
+                dvb_loginfo("   - PCR            %d", ts->adaption->PCR);
+                dvb_loginfo("   - OPCR           %d", ts->adaption->OPCR);
+                dvb_loginfo("   - splicing_point %d", ts->adaption->splicing_point);
+                dvb_loginfo("   - private_data   %d", ts->adaption->private_data);
+                dvb_loginfo("   - extension      %d", ts->adaption->extension);
 	}
 }
diff --git a/lib/libdvbv5/descriptors/nit.c b/lib/libdvbv5/descriptors/nit.c
index aadebc0..c2c55a4 100644
--- a/lib/libdvbv5/descriptors/nit.c
+++ b/lib/libdvbv5/descriptors/nit.c
@@ -135,7 +135,7 @@ void dvb_table_nit_free(struct dvb_table_nit *nit)
 {
 	struct dvb_table_nit_transport *transport = nit->transport;
 	dvb_free_descriptors((struct dvb_desc **) &nit->descriptor);
-	while(transport) {
+	while (transport) {
 		dvb_free_descriptors((struct dvb_desc **) &transport->descriptor);
 		struct dvb_table_nit_transport *tmp = transport;
 		transport = transport->next;
@@ -146,19 +146,20 @@ void dvb_table_nit_free(struct dvb_table_nit *nit)
 
 void dvb_table_nit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *nit)
 {
-	dvb_log("NIT");
-	dvb_table_header_print(parms, &nit->header);
-	dvb_log("| desc_length   %d", nit->desc_length);
-	dvb_print_descriptors(parms, nit->descriptor);
 	const struct dvb_table_nit_transport *transport = nit->transport;
 	uint16_t transports = 0;
-	while(transport) {
-		dvb_log("|- transport %04x network %04x", transport->transport_id, transport->network_id);
+
+	dvb_loginfo("NIT");
+	dvb_table_header_print(parms, &nit->header);
+	dvb_loginfo("| desc_length   %d", nit->desc_length);
+	dvb_print_descriptors(parms, nit->descriptor);
+	while (transport) {
+		dvb_loginfo("|- transport %04x network %04x", transport->transport_id, transport->network_id);
 		dvb_print_descriptors(parms, transport->descriptor);
 		transport = transport->next;
 		transports++;
 	}
-	dvb_log("|_  %d transports", transports);
+	dvb_loginfo("|_  %d transports", transports);
 }
 
 void nit_descriptor_handler(struct dvb_v5_fe_parms *parms,
diff --git a/lib/libdvbv5/descriptors/pat.c b/lib/libdvbv5/descriptors/pat.c
index efa6811..1a79bca 100644
--- a/lib/libdvbv5/descriptors/pat.c
+++ b/lib/libdvbv5/descriptors/pat.c
@@ -62,7 +62,7 @@ ssize_t dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 
 		prog = malloc(sizeof(struct dvb_table_pat_program));
 		if (!prog) {
-			dvb_perror("Out of memory");
+			dvb_logerr("%s: out of memory", __func__);
 			return -3;
 		}
 
diff --git a/lib/libdvbv5/descriptors/sdt.c b/lib/libdvbv5/descriptors/sdt.c
index 8cee315..c0d32e4 100644
--- a/lib/libdvbv5/descriptors/sdt.c
+++ b/lib/libdvbv5/descriptors/sdt.c
@@ -127,22 +127,24 @@ void dvb_table_sdt_free(struct dvb_table_sdt *sdt)
 
 void dvb_table_sdt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_sdt *sdt)
 {
-	dvb_log("SDT");
+	dvb_loginfo("SDT");
 	dvb_table_header_print(parms, &sdt->header);
-	dvb_log("|- network_id         %d", sdt->network_id);
-	dvb_log("|\\");
+	dvb_loginfo("| network_id          %d", sdt->network_id);
+	dvb_loginfo("| reserved            %d", sdt->reserved);
+	dvb_loginfo("|\\");
 	const struct dvb_table_sdt_service *service = sdt->service;
 	uint16_t services = 0;
-	while(service) {
-		dvb_log("|- service 0x%04x", service->service_id);
-		dvb_log("|   EIT schedule          %d", service->EIT_schedule);
-		dvb_log("|   EIT present following %d", service->EIT_present_following);
-		dvb_log("|   free CA mode          %d", service->free_CA_mode);
-		dvb_log("|   running status        %d", service->running_status);
+	while (service) {
+		dvb_loginfo("|- service 0x%04x", service->service_id);
+		dvb_loginfo("|   EIT schedule          %d", service->EIT_schedule);
+		dvb_loginfo("|   EIT present following %d", service->EIT_present_following);
+		dvb_loginfo("|   free CA mode          %d", service->free_CA_mode);
+		dvb_loginfo("|   running status        %d", service->running_status);
+		dvb_loginfo("|   descriptor length     %d", service->desc_length);
 		dvb_print_descriptors(parms, service->descriptor);
 		service = service->next;
 		services++;
 	}
-	dvb_log("|_  %d services", services);
+	dvb_loginfo("|_  %d services", services);
 }
 
diff --git a/lib/libdvbv5/descriptors/vct.c b/lib/libdvbv5/descriptors/vct.c
index 39d44f4..6b64144 100644
--- a/lib/libdvbv5/descriptors/vct.c
+++ b/lib/libdvbv5/descriptors/vct.c
@@ -145,7 +145,7 @@ ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 void atsc_table_vct_free(struct atsc_table_vct *vct)
 {
 	struct atsc_table_vct_channel *channel = vct->channel;
-	while(channel) {
+	while (channel) {
 		dvb_free_descriptors((struct dvb_desc **) &channel->descriptor);
 		struct atsc_table_vct_channel *tmp = channel;
 		channel = channel->next;
@@ -158,42 +158,43 @@ void atsc_table_vct_free(struct atsc_table_vct *vct)
 
 void atsc_table_vct_print(struct dvb_v5_fe_parms *parms, struct atsc_table_vct *vct)
 {
+	const struct atsc_table_vct_channel *channel = vct->channel;
+	uint16_t channels = 0;
+
 	if (vct->header.table_id == ATSC_TABLE_CVCT)
-		dvb_log("CVCT");
+		dvb_loginfo("CVCT");
 	else
-		dvb_log("TVCT");
+		dvb_loginfo("TVCT");
 
 	ATSC_TABLE_HEADER_PRINT(parms, vct);
 
-	dvb_log("|- #channels        %d", vct->num_channels_in_section);
-	dvb_log("|\\  channel_id");
-	const struct atsc_table_vct_channel *channel = vct->channel;
-	uint16_t channels = 0;
-	while(channel) {
-		dvb_log("|- Channel                %d.%d: %s",
+	dvb_loginfo("|- #channels        %d", vct->num_channels_in_section);
+	dvb_loginfo("|\\  channel_id");
+	while (channel) {
+		dvb_loginfo("|- Channel                %d.%d: %s",
 			channel->major_channel_number,
 			channel->minor_channel_number,
 			channel->short_name);
-		dvb_log("|   modulation mode       %d", channel->modulation_mode);
-		dvb_log("|   carrier frequency     %d", channel->carrier_frequency);
-		dvb_log("|   TS ID                 %d", channel->channel_tsid);
-		dvb_log("|   program number        %d", channel->program_number);
+		dvb_loginfo("|   modulation mode       %d", channel->modulation_mode);
+		dvb_loginfo("|   carrier frequency     %d", channel->carrier_frequency);
+		dvb_loginfo("|   TS ID                 %d", channel->channel_tsid);
+		dvb_loginfo("|   program number        %d", channel->program_number);
 
-		dvb_log("|   ETM location          %d", channel->ETM_location);
-		dvb_log("|   access controlled     %d", channel->access_controlled);
-		dvb_log("|   hidden                %d", channel->hidden);
+		dvb_loginfo("|   ETM location          %d", channel->ETM_location);
+		dvb_loginfo("|   access controlled     %d", channel->access_controlled);
+		dvb_loginfo("|   hidden                %d", channel->hidden);
 
 		if (vct->header.table_id == ATSC_TABLE_CVCT) {
-			dvb_log("|   path select           %d", channel->path_select);
-			dvb_log("|   out of band           %d", channel->out_of_band);
+			dvb_loginfo("|   path select           %d", channel->path_select);
+			dvb_loginfo("|   out of band           %d", channel->out_of_band);
 		}
-		dvb_log("|   hide guide            %d", channel->hide_guide);
-		dvb_log("|   service type          %d", channel->service_type);
-		dvb_log("|   source id            %d", channel->source_id);
+		dvb_loginfo("|   hide guide            %d", channel->hide_guide);
+		dvb_loginfo("|   service type          %d", channel->service_type);
+		dvb_loginfo("|   source id            %d", channel->source_id);
 
 		dvb_print_descriptors(parms, channel->descriptor);
 		channel = channel->next;
 		channels++;
 	}
-	dvb_log("|_  %d channels", channels);
+	dvb_loginfo("|_  %d channels", channels);
 }
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index d8b3953..4fbd6d2 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -147,7 +147,7 @@ static int dvb_parse_section_alloc(struct dvb_v5_fe_parms *parms,
 	*sect->table = NULL;
 	priv = calloc(sizeof(struct dvb_table_filter_priv), 1);
 	if (!priv) {
-		dvb_perror("Out of memory");
+		dvb_logerr("%s: out of memory", __func__);
 		return -1;
 	}
 	priv->last_section = -1;
@@ -280,7 +280,7 @@ int dvb_read_sections(struct dvb_v5_fe_parms *parms, int dmx_fd,
 
 	buf = calloc(DVB_MAX_PAYLOAD_PACKET_SIZE, 1);
 	if (!buf) {
-		dvb_perror("Out of memory");
+		dvb_logerr("%s: out of memory", __func__);
 		dvb_dmx_stop(dmx_fd);
 		dvb_table_filter_free(sect);
 		return -1;
-- 
1.7.10.4

