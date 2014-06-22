Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:48542 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaFVMu2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jun 2014 08:50:28 -0400
Received: by mail-wg0-f47.google.com with SMTP id k14so5597300wgh.30
        for <linux-media@vger.kernel.org>; Sun, 22 Jun 2014 05:50:27 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 2/2] Prefix exported functions with dvb_
Date: Sun, 22 Jun 2014 14:49:47 +0200
Message-Id: <1403441387-31604-3-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1403441387-31604-1-git-send-email-gjasny@googlemail.com>
References: <1403441387-31604-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 lib/include/libdvbv5/crc32.h                   |   2 +-
 lib/include/libdvbv5/desc_extension.h          |   8 +-
 lib/include/libdvbv5/descriptors.h             |   4 +-
 lib/include/libdvbv5/dvb-demux.h               |   2 +-
 lib/include/libdvbv5/dvb-file.h                |  38 +++---
 lib/include/libdvbv5/dvb-sat.h                 |   4 +-
 lib/include/libdvbv5/dvb-scan.h                |   6 +-
 lib/include/libdvbv5/nit.h                     |   3 +-
 lib/libdvbv5/crc32.c                           |   2 +-
 lib/libdvbv5/descriptors.c                     |  16 +--
 lib/libdvbv5/descriptors/desc_ca.c             |   4 +-
 lib/libdvbv5/descriptors/desc_cable_delivery.c |   4 +-
 lib/libdvbv5/descriptors/desc_event_extended.c |   2 +-
 lib/libdvbv5/descriptors/desc_event_short.c    |   2 +-
 lib/libdvbv5/descriptors/desc_extension.c      |  10 +-
 lib/libdvbv5/descriptors/desc_sat.c            |   6 +-
 lib/libdvbv5/dvb-demux.c                       |   2 +-
 lib/libdvbv5/dvb-file.c                        |  80 ++++++------
 lib/libdvbv5/dvb-sat.c                         |   6 +-
 lib/libdvbv5/dvb-scan.c                        | 163 +++++++++++++------------
 lib/libdvbv5/tables/eit.c                      |  12 +-
 lib/libdvbv5/tables/nit.c                      |   3 +-
 utils/dvb/dvb-fe-tool.c                        |   2 +-
 utils/dvb/dvb-format-convert.c                 |  10 +-
 utils/dvb/dvbv5-scan.c                         |  24 ++--
 utils/dvb/dvbv5-zap.c                          |  12 +-
 26 files changed, 216 insertions(+), 211 deletions(-)

diff --git a/lib/include/libdvbv5/crc32.h b/lib/include/libdvbv5/crc32.h
index d1968e8..c886862 100644
--- a/lib/include/libdvbv5/crc32.h
+++ b/lib/include/libdvbv5/crc32.h
@@ -25,7 +25,7 @@
 #include <stdint.h>
 #include <unistd.h> /* size_t */
 
-uint32_t crc32(uint8_t *data, size_t datalen, uint32_t crc);
+uint32_t dvb_crc32(uint8_t *data, size_t datalen, uint32_t crc);
 
 #endif
 
diff --git a/lib/include/libdvbv5/desc_extension.h b/lib/include/libdvbv5/desc_extension.h
index 8b2606a..dcf267a 100644
--- a/lib/include/libdvbv5/desc_extension.h
+++ b/lib/include/libdvbv5/desc_extension.h
@@ -71,10 +71,10 @@ struct dvb_ext_descriptor {
 extern "C" {
 #endif
 
-int extension_descriptor_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
-void extension_descriptor_free(struct dvb_desc *descriptor);
-void extension_descriptor_print(struct dvb_v5_fe_parms *parms,
-				const struct dvb_desc *desc);
+int dvb_extension_descriptor_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_extension_descriptor_free(struct dvb_desc *descriptor);
+void dvb_extension_descriptor_print(struct dvb_v5_fe_parms *parms,
+				    const struct dvb_desc *desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/descriptors.h
index 94d85a9..de2c39b 100644
--- a/lib/include/libdvbv5/descriptors.h
+++ b/lib/include/libdvbv5/descriptors.h
@@ -72,9 +72,9 @@ struct dvb_desc {
 extern "C" {
 #endif
 
-uint32_t bcd(uint32_t bcd);
+uint32_t dvb_bcd(uint32_t bcd);
 
-void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned char *buf, int len);
+void dvb_hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned char *buf, int len);
 
 int  dvb_desc_parse(struct dvb_v5_fe_parms *parms, const uint8_t *buf, uint16_t section_length, struct dvb_desc **head_desc);
 void dvb_desc_free (struct dvb_desc **list);
diff --git a/lib/include/libdvbv5/dvb-demux.h b/lib/include/libdvbv5/dvb-demux.h
index fc3df0b..8ab78a2 100644
--- a/lib/include/libdvbv5/dvb-demux.h
+++ b/lib/include/libdvbv5/dvb-demux.h
@@ -48,7 +48,7 @@ int dvb_set_section_filter(int dmxfd, int pid, unsigned filtsize,
 			   unsigned char *mode,
 			   unsigned int flags);
 
-int get_pmt_pid(const char *dmxdev, int sid);
+int dvb_get_pmt_pid(const char *dmxdev, int sid);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/libdvbv5/dvb-file.h b/lib/include/libdvbv5/dvb-file.h
index 51b53cd..38ac3c1 100644
--- a/lib/include/libdvbv5/dvb-file.h
+++ b/lib/include/libdvbv5/dvb-file.h
@@ -121,38 +121,36 @@ extern const struct parse_file channel_file_format;
 extern const struct parse_file channel_file_zap_format;
 
 /* From dvb-file.c */
-struct dvb_file *parse_format_oneline(const char *fname,
-				      uint32_t delsys,
-				      const struct parse_file *parse_file);
-int write_format_oneline(const char *fname,
-			 struct dvb_file *dvb_file,
-			 uint32_t delsys,
-			 const struct parse_file *parse_file);
+struct dvb_file *dvb_parse_format_oneline(const char *fname,
+					  uint32_t delsys,
+					  const struct parse_file *parse_file);
+int dvb_write_format_oneline(const char *fname,
+			     struct dvb_file *dvb_file,
+			     uint32_t delsys,
+			     const struct parse_file *parse_file);
 
+struct dvb_file *dvb_read_file(const char *fname);
 
+int dvb_write_file(const char *fname, struct dvb_file *dvb_file);
 
-struct dvb_file *read_dvb_file(const char *fname);
-
-int write_dvb_file(const char *fname, struct dvb_file *dvb_file);
-
-int store_entry_prop(struct dvb_entry *entry,
+int dvb_store_entry_prop(struct dvb_entry *entry,
 		     uint32_t cmd, uint32_t value);
-int retrieve_entry_prop(struct dvb_entry *entry,
+int dvb_retrieve_entry_prop(struct dvb_entry *entry,
 			uint32_t cmd, uint32_t *value);
 
-int store_dvb_channel(struct dvb_file **dvb_file,
+int dvb_store_channel(struct dvb_file **dvb_file,
 		      struct dvb_v5_fe_parms *parms,
 		      struct dvb_v5_descriptors *dvb_desc,
 		      int get_detected, int get_nit);
-int parse_delsys(const char *name);
-enum file_formats parse_format(const char *name);
+int dvb_parse_delsys(const char *name);
+enum file_formats dvb_parse_format(const char *name);
 struct dvb_file *dvb_read_file_format(const char *fname,
 					   uint32_t delsys,
 					   enum file_formats format);
-int write_file_format(const char *fname,
-		      struct dvb_file *dvb_file,
-		      uint32_t delsys,
-		      enum file_formats format);
+int dvb_write_file_format(const char *fname,
+			  struct dvb_file *dvb_file,
+			  uint32_t delsys,
+			  enum file_formats format);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/libdvbv5/dvb-sat.h b/lib/include/libdvbv5/dvb-sat.h
index a5d1698..a414448 100644
--- a/lib/include/libdvbv5/dvb-sat.h
+++ b/lib/include/libdvbv5/dvb-sat.h
@@ -45,8 +45,8 @@ extern "C" {
 
 /* From libsat.c */
 int dvb_sat_search_lnb(const char *name);
-int print_lnb(int i);
-void print_all_lnb(void);
+int dvb_print_lnb(int i);
+void dvb_print_all_lnb(void);
 const struct dvb_sat_lnb *dvb_sat_get_lnb(int i);
 int dvb_sat_set_parms(struct dvb_v5_fe_parms *parms);
 
diff --git a/lib/include/libdvbv5/dvb-scan.h b/lib/include/libdvbv5/dvb-scan.h
index 8f0e553..943d999 100644
--- a/lib/include/libdvbv5/dvb-scan.h
+++ b/lib/include/libdvbv5/dvb-scan.h
@@ -133,10 +133,10 @@ struct dvb_v5_descriptors *dvb_scan_transponder(struct dvb_v5_fe_parms *parms,
 						unsigned other_nit,
 						unsigned timeout_multiply);
 
-int estimate_freq_shift(struct dvb_v5_fe_parms *parms);
+int dvb_estimate_freq_shift(struct dvb_v5_fe_parms *parms);
 
-int new_freq_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
-		       uint32_t freq, enum dvb_sat_polarization pol, int shift);
+int dvb_new_freq_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
+			   uint32_t freq, enum dvb_sat_polarization pol, int shift);
 
 struct dvb_entry *dvb_scan_add_entry(struct dvb_v5_fe_parms *parms,
 				     struct dvb_entry *first_entry,
diff --git a/lib/include/libdvbv5/nit.h b/lib/include/libdvbv5/nit.h
index 63ffcd5..82475e6 100644
--- a/lib/include/libdvbv5/nit.h
+++ b/lib/include/libdvbv5/nit.h
@@ -89,7 +89,8 @@ ssize_t dvb_table_nit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, s
 void dvb_table_nit_free(struct dvb_table_nit *nit);
 void dvb_table_nit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *nit);
 
-void nit_descriptor_handler(struct dvb_v5_fe_parms *parms,
+void dvb_table_nit_descriptor_handler(
+			    struct dvb_v5_fe_parms *parms,
 			    struct dvb_table_nit *nit,
 			    enum descriptors descriptor,
 			    nit_handler_callback_t *call_nit,
diff --git a/lib/libdvbv5/crc32.c b/lib/libdvbv5/crc32.c
index 69d0be3..bc6b171 100644
--- a/lib/libdvbv5/crc32.c
+++ b/lib/libdvbv5/crc32.c
@@ -67,7 +67,7 @@ static uint32_t crctab[256] = {
   0xbcb4666d, 0xb8757bda, 0xb5365d03, 0xb1f740b4
 };
 
-inline uint32_t crc32(uint8_t *data, size_t len, uint32_t crc)
+inline uint32_t dvb_crc32(uint8_t *data, size_t len, uint32_t crc)
 {
   while(len--)
     crc = (crc << 8) ^ crctab[((crc >> 24) ^ *data++) & 0xff];
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index bfbf529..5f61332 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -76,7 +76,7 @@ static void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct d
 {
 	if (!parms)
 		parms = dvb_fe_dummy();
-	hexdump(parms, "|           ", desc->data, desc->length);
+	dvb_hexdump(parms, "|           ", desc->data, desc->length);
 }
 
 #define TABLE_INIT(_x) (dvb_table_init_func) _x##_init
@@ -138,7 +138,7 @@ int dvb_desc_parse(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			dvb_log("%sdescriptor %s type 0x%02x, size %d",
 				dvb_descriptors[desc_type].init ? "" : "Not handled ",
 				dvb_descriptors[desc_type].name, desc_type, desc_len);
-			hexdump(parms, "content: ", ptr + 2, desc_len);
+			dvb_hexdump(parms, "content: ", ptr + 2, desc_len);
 		}
 
 		dvb_desc_init_func init = dvb_descriptors[desc_type].init;
@@ -894,9 +894,9 @@ const struct dvb_descriptor dvb_descriptors[] = {
 	},
 	[extension_descriptor] = {
 		.name  = "extension_descriptor",
-		.init  = extension_descriptor_init,
-		.print = extension_descriptor_print,
-		.free  = extension_descriptor_free,
+		.init  = dvb_extension_descriptor_init,
+		.print = dvb_extension_descriptor_print,
+		.free  = dvb_extension_descriptor_free,
 		.size  = sizeof(struct dvb_extension_descriptor),
 	},
 
@@ -1311,7 +1311,7 @@ const struct dvb_descriptor dvb_descriptors[] = {
 	},
 };
 
-uint32_t bcd(uint32_t bcd)
+uint32_t dvb_bcd(uint32_t bcd)
 {
 	uint32_t ret = 0, mult = 1;
 	while (bcd) {
@@ -1322,7 +1322,7 @@ uint32_t bcd(uint32_t bcd)
 	return ret;
 }
 
-int bcd_to_int(const unsigned char *bcd, int bits)
+static int bcd_to_int(const unsigned char *bcd, int bits)
 {
 	int nibble = 0;
 	int ret = 0;
@@ -1341,7 +1341,7 @@ int bcd_to_int(const unsigned char *bcd, int bits)
 	return ret;
 }
 
-void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned char *data, int length)
+void dvb_hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned char *data, int length)
 {
 	char ascii[17];
 	char hex[50];
diff --git a/lib/libdvbv5/descriptors/desc_ca.c b/lib/libdvbv5/descriptors/desc_ca.c
index fa18814..bb915f7 100644
--- a/lib/libdvbv5/descriptors/desc_ca.c
+++ b/lib/libdvbv5/descriptors/desc_ca.c
@@ -40,7 +40,7 @@ int dvb_desc_ca_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct d
 		d->privdata = NULL;
 		d->privdata_len = 0;
 	}
-	/*hexdump(parms, "desc ca ", buf, desc->length);*/
+	/*dvb_hexdump(parms, "desc ca ", buf, desc->length);*/
 	/*dvb_desc_ca_print(parms, desc);*/
 	return 0;
 }
@@ -52,7 +52,7 @@ void dvb_desc_ca_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *des
 	dvb_loginfo("|           ca_pid            0x%04x", d->ca_pid);
 	dvb_loginfo("|           privdata length   %d", d->privdata_len);
 	if (d->privdata)
-		hexdump(parms, "|           privdata          ", d->privdata, d->privdata_len);
+		dvb_hexdump(parms, "|           privdata          ", d->privdata, d->privdata_len);
 }
 
 void dvb_desc_ca_free(struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_cable_delivery.c b/lib/libdvbv5/descriptors/desc_cable_delivery.c
index 852c79e..9d815d8 100644
--- a/lib/libdvbv5/descriptors/desc_cable_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_cable_delivery.c
@@ -33,8 +33,8 @@ int dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *b
 	bswap32(cable->frequency);
 	bswap16(cable->bitfield1);
 	bswap32(cable->bitfield2);
-	cable->frequency   = bcd(cable->frequency) * 100;
-	cable->symbol_rate = bcd(cable->symbol_rate) * 100;
+	cable->frequency   = dvb_bcd(cable->frequency) * 100;
+	cable->symbol_rate = dvb_bcd(cable->symbol_rate) * 100;
 	return 0;
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_event_extended.c b/lib/libdvbv5/descriptors/desc_event_extended.c
index d0865f9..6af38f2 100644
--- a/lib/libdvbv5/descriptors/desc_event_extended.c
+++ b/lib/libdvbv5/descriptors/desc_event_extended.c
@@ -29,7 +29,7 @@ int dvb_desc_event_extended_init(struct dvb_v5_fe_parms *parms, const uint8_t *b
 	uint8_t len;  /* the length of the string in the input data */
 	uint8_t len1; /* the lenght of the output strings */
 
-	/*hexdump(parms, "event extended desc: ", buf - 2, desc->length + 2);*/
+	/*dvb_hexdump(parms, "event extended desc: ", buf - 2, desc->length + 2);*/
 
 	event->ids = buf[0];
 	event->language[0] = buf[1];
diff --git a/lib/libdvbv5/descriptors/desc_event_short.c b/lib/libdvbv5/descriptors/desc_event_short.c
index 535e656..adb38fe 100644
--- a/lib/libdvbv5/descriptors/desc_event_short.c
+++ b/lib/libdvbv5/descriptors/desc_event_short.c
@@ -29,7 +29,7 @@ int dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	uint8_t len;        /* the length of the string in the input data */
 	uint8_t len1, len2; /* the lenght of the output strings */
 
-	/*hexdump(parms, "event short desc: ", buf - 2, desc->length + 2);*/
+	/*dvb_hexdump(parms, "event short desc: ", buf - 2, desc->length + 2);*/
 
 	event->language[0] = buf[0];
 	event->language[1] = buf[1];
diff --git a/lib/libdvbv5/descriptors/desc_extension.c b/lib/libdvbv5/descriptors/desc_extension.c
index 7d9337c..3d859a7 100644
--- a/lib/libdvbv5/descriptors/desc_extension.c
+++ b/lib/libdvbv5/descriptors/desc_extension.c
@@ -116,8 +116,8 @@ const struct dvb_ext_descriptor dvb_ext_descriptors[] = {
 	},
 };
 
-int extension_descriptor_init(struct dvb_v5_fe_parms *parms,
-				     const uint8_t *buf, struct dvb_desc *desc)
+int dvb_extension_descriptor_init(struct dvb_v5_fe_parms *parms,
+				  const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_extension_descriptor *ext = (void *)desc;
 	unsigned char *p = (unsigned char *)buf;
@@ -141,7 +141,7 @@ int extension_descriptor_init(struct dvb_v5_fe_parms *parms,
 		dvb_logwarn("%sextension descriptor %s type 0x%02x, size %d",
 			dvb_ext_descriptors[desc_type].init ? "" : "Not handled ",
 			dvb_ext_descriptors[desc_type].name, desc_type, desc_len);
-		hexdump(parms, "content: ", p, desc_len);
+		dvb_hexdump(parms, "content: ", p, desc_len);
 	}
 
 	init = dvb_ext_descriptors[desc_type].init;
@@ -161,7 +161,7 @@ int extension_descriptor_init(struct dvb_v5_fe_parms *parms,
 	return 0;
 }
 
-void extension_descriptor_free(struct dvb_desc *descriptor)
+void dvb_extension_descriptor_free(struct dvb_desc *descriptor)
 {
 	struct dvb_extension_descriptor *ext = (void *)descriptor;
 	uint8_t type = ext->extension_code;
@@ -175,7 +175,7 @@ void extension_descriptor_free(struct dvb_desc *descriptor)
 	free(ext->descriptor);
 }
 
-void extension_descriptor_print(struct dvb_v5_fe_parms *parms,
+void dvb_extension_descriptor_print(struct dvb_v5_fe_parms *parms,
 				const struct dvb_desc *desc)
 {
 	struct dvb_extension_descriptor *ext = (void *)desc;
diff --git a/lib/libdvbv5/descriptors/desc_sat.c b/lib/libdvbv5/descriptors/desc_sat.c
index f7fb8f1..326f534 100644
--- a/lib/libdvbv5/descriptors/desc_sat.c
+++ b/lib/libdvbv5/descriptors/desc_sat.c
@@ -32,9 +32,9 @@ int dvb_desc_sat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct
 	bswap16(sat->orbit);
 	bswap32(sat->bitfield);
 	bswap32(sat->frequency);
-	sat->orbit = bcd(sat->orbit);
-	sat->frequency   = bcd(sat->frequency) * 10;
-	sat->symbol_rate = bcd(sat->symbol_rate) * 100;
+	sat->orbit = dvb_bcd(sat->orbit);
+	sat->frequency   = dvb_bcd(sat->frequency) * 10;
+	sat->symbol_rate = dvb_bcd(sat->symbol_rate) * 100;
 
 	return 0;
 }
diff --git a/lib/libdvbv5/dvb-demux.c b/lib/libdvbv5/dvb-demux.c
index 919e7cb..0bb3d48 100644
--- a/lib/libdvbv5/dvb-demux.c
+++ b/lib/libdvbv5/dvb-demux.c
@@ -125,7 +125,7 @@ int dvb_set_section_filter(int dmxfd, int pid, unsigned filtsize,
 	return 0;
 }
 
-int get_pmt_pid(const char *dmxdev, int sid)
+int dvb_get_pmt_pid(const char *dmxdev, int sid)
 {
 	int patfd, count;
 	int pmt_pid = 0;
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index 41e2e38..f938c8f 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -49,8 +49,8 @@
 #include <libdvbv5/desc_atsc_service_location.h>
 #include <libdvbv5/desc_hierarchy.h>
 
-int store_entry_prop(struct dvb_entry *entry,
-		     uint32_t cmd, uint32_t value)
+int dvb_store_entry_prop(struct dvb_entry *entry,
+			 uint32_t cmd, uint32_t value)
 {
 	int i;
 
@@ -73,8 +73,8 @@ int store_entry_prop(struct dvb_entry *entry,
 	return 0;
 }
 
-int retrieve_entry_prop(struct dvb_entry *entry,
-			uint32_t cmd, uint32_t *value)
+int dvb_retrieve_entry_prop(struct dvb_entry *entry,
+			    uint32_t cmd, uint32_t *value)
 {
 	int i;
 
@@ -92,13 +92,13 @@ static void adjust_delsys(struct dvb_entry *entry)
 {
 	uint32_t delsys = SYS_UNDEFINED;
 
-	retrieve_entry_prop(entry, DTV_DELIVERY_SYSTEM, &delsys);
+	dvb_retrieve_entry_prop(entry, DTV_DELIVERY_SYSTEM, &delsys);
 	switch (delsys) {
 	case SYS_ATSC:
 	case SYS_DVBC_ANNEX_B: {
 		uint32_t modulation = VSB_8;
 
-		retrieve_entry_prop(entry, DTV_MODULATION, &modulation);
+		dvb_retrieve_entry_prop(entry, DTV_MODULATION, &modulation);
 		switch (modulation) {
 		case VSB_8:
 		case VSB_16:
@@ -108,7 +108,7 @@ static void adjust_delsys(struct dvb_entry *entry)
 			delsys = SYS_DVBC_ANNEX_B;
 			break;
 		}
-		store_entry_prop(entry, DTV_DELIVERY_SYSTEM, delsys);
+		dvb_store_entry_prop(entry, DTV_DELIVERY_SYSTEM, delsys);
 		break;
 	}
 	} /* switch */
@@ -118,9 +118,9 @@ static void adjust_delsys(struct dvb_entry *entry)
  * Generic parse function for all formats each channel is contained into
  * just one line.
  */
-struct dvb_file *parse_format_oneline(const char *fname,
-				      uint32_t delsys,
-				      const struct parse_file *parse_file)
+struct dvb_file *dvb_parse_format_oneline(const char *fname,
+					  uint32_t delsys,
+					  const struct parse_file *parse_file)
 {
 	const char *delimiter = parse_file->delimiter;
 	const struct parse_struct *formats = parse_file->formats;
@@ -309,10 +309,10 @@ static uint32_t get_compat_format(uint32_t delivery_system)
 	}
 }
 
-int write_format_oneline(const char *fname,
-			 struct dvb_file *dvb_file,
-			 uint32_t delsys,
-			 const struct parse_file *parse_file)
+int dvb_write_format_oneline(const char *fname,
+			     struct dvb_file *dvb_file,
+			     uint32_t delsys,
+			     const struct parse_file *parse_file)
 {
 	const char delimiter = parse_file->delimiter[0];
 	const struct parse_struct *formats = parse_file->formats;
@@ -527,7 +527,7 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
 				break;
 		if (j == ARRAY_SIZE(dvb_sat_pol_name))
 			return -2;
-		store_entry_prop(entry, DTV_POLARIZATION, j);
+		dvb_store_entry_prop(entry, DTV_POLARIZATION, j);
 		return 0;
 	} else if (!strncasecmp(key,"PID_", 4)){
 		type = strtol(&key[4], NULL, 16);
@@ -585,7 +585,7 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
 }
 
 
-struct dvb_file *read_dvb_file(const char *fname)
+struct dvb_file *dvb_read_file(const char *fname)
 {
 	char *buf = NULL, *p, *key, *value;
 	size_t size = 0;
@@ -688,7 +688,7 @@ error:
 	return NULL;
 };
 
-int write_dvb_file(const char *fname, struct dvb_file *dvb_file)
+int dvb_write_file(const char *fname, struct dvb_file *dvb_file)
 {
 	FILE *fp;
 	int i;
@@ -1050,7 +1050,7 @@ static char *sdt_services[256] = {
 	[0x80 ...0xfe] = "user defined",
 };
 
-int store_dvb_channel(struct dvb_file **dvb_file,
+int dvb_store_channel(struct dvb_file **dvb_file,
 		      struct dvb_v5_fe_parms *parms,
 		      struct dvb_v5_descriptors *dvb_scan_handler,
 		      int get_detected, int get_nit)
@@ -1141,7 +1141,7 @@ int store_dvb_channel(struct dvb_file **dvb_file,
 	return 0;
 }
 
-enum file_formats parse_format(const char *name)
+enum file_formats dvb_parse_format(const char *name)
 {
 	if (!strcasecmp(name, "ZAP"))
 		return FILE_ZAP;
@@ -1171,7 +1171,7 @@ static struct {
 	{ SYS_DMBTH,		"DMB-TH" },
 };
 
-int parse_delsys(const char *name)
+int dvb_parse_delsys(const char *name)
 {
 	int i, cnt = 0;
 
@@ -1224,17 +1224,17 @@ struct dvb_file *dvb_read_file_format(const char *fname,
 
 	switch (format) {
 	case FILE_CHANNEL:		/* DVB channel/transponder old format */
-		dvb_file = parse_format_oneline(fname,
-						SYS_UNDEFINED,
-						&channel_file_format);
+		dvb_file = dvb_parse_format_oneline(fname,
+						    SYS_UNDEFINED,
+						    &channel_file_format);
 		break;
 	case FILE_ZAP:
-		dvb_file = parse_format_oneline(fname,
-						delsys,
-						&channel_file_zap_format);
+		dvb_file = dvb_parse_format_oneline(fname,
+						    delsys,
+						    &channel_file_zap_format);
 		break;
 	case FILE_DVBV5:
-		dvb_file = read_dvb_file(fname);
+		dvb_file = dvb_read_file(fname);
 		break;
 	default:
 		fprintf(stderr, "Format is not supported\n");
@@ -1244,28 +1244,28 @@ struct dvb_file *dvb_read_file_format(const char *fname,
 	return dvb_file;
 }
 
-int write_file_format(const char *fname,
-		      struct dvb_file *dvb_file,
-		      uint32_t delsys,
-		      enum file_formats format)
+int dvb_write_file_format(const char *fname,
+			  struct dvb_file *dvb_file,
+			  uint32_t delsys,
+			  enum file_formats format)
 {
 	int ret;
 
 	switch (format) {
 	case FILE_CHANNEL:		/* DVB channel/transponder old format */
-		ret = write_format_oneline(fname,
-					   dvb_file,
-					   SYS_UNDEFINED,
-					   &channel_file_format);
+		ret = dvb_write_format_oneline(fname,
+					       dvb_file,
+					       SYS_UNDEFINED,
+					       &channel_file_format);
 		break;
 	case FILE_ZAP:
-		ret = write_format_oneline(fname,
-					   dvb_file,
-					   delsys,
-					   &channel_file_zap_format);
+		ret = dvb_write_format_oneline(fname,
+					       dvb_file,
+					       delsys,
+					       &channel_file_zap_format);
 		break;
 	case FILE_DVBV5:
-		ret = write_dvb_file(fname, dvb_file);
+		ret = dvb_write_file(fname, dvb_file);
 		break;
 	default:
 		return -1;
diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index df2ffcd..c601325 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -95,7 +95,7 @@ int dvb_sat_search_lnb(const char *name)
 	return -1;
 }
 
-int print_lnb(int i)
+int dvb_print_lnb(int i)
 {
 	if (i < 0 || i >= ARRAY_SIZE(lnb))
 		return -1;
@@ -122,12 +122,12 @@ int print_lnb(int i)
 	return 0;
 }
 
-void print_all_lnb(void)
+void dvb_print_all_lnb(void)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(lnb); i++) {
-		print_lnb(i);
+		dvb_print_lnb(i);
 		printf("\n");
 	}
 }
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 9a7997b..3d6b435 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -300,7 +300,7 @@ int dvb_read_sections(struct dvb_v5_fe_parms *parms, int dmx_fd,
 			break;
 		}
 
-		crc = crc32(buf, buf_length, 0xFFFFFFFF);
+		crc = dvb_crc32(buf, buf_length, 0xFFFFFFFF);
 		if (crc != 0) {
 			dvb_logerr("%s: crc error", __func__);
 			ret = -3;
@@ -568,7 +568,7 @@ struct dvb_v5_descriptors *dvb_scan_transponder(struct dvb_v5_fe_parms *parms,
 	int i, rc;
 
 	/* First of all, set the delivery system */
-	retrieve_entry_prop(entry, DTV_DELIVERY_SYSTEM, &delsys);
+	dvb_retrieve_entry_prop(entry, DTV_DELIVERY_SYSTEM, &delsys);
 	dvb_set_compat_delivery_system(parms, delsys);
 
 	/* Copy data into parms */
@@ -615,7 +615,7 @@ struct dvb_v5_descriptors *dvb_scan_transponder(struct dvb_v5_fe_parms *parms,
 	return dvb_scan_handler;
 }
 
-int estimate_freq_shift(struct dvb_v5_fe_parms *parms)
+int dvb_estimate_freq_shift(struct dvb_v5_fe_parms *parms)
 {
 	uint32_t shift = 0, bw = 0, symbol_rate, ro;
 	int rolloff = 0;
@@ -681,8 +681,8 @@ int estimate_freq_shift(struct dvb_v5_fe_parms *parms)
 	return shift;
 }
 
-int new_freq_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
-		       uint32_t freq, enum dvb_sat_polarization pol, int shift)
+int dvb_new_freq_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
+			   uint32_t freq, enum dvb_sat_polarization pol, int shift)
 {
 	int i;
 	uint32_t data;
@@ -713,7 +713,7 @@ struct dvb_entry *dvb_scan_add_entry(struct dvb_v5_fe_parms *parms,
 	struct dvb_entry *new_entry;
 	int i, n = 2;
 
-	if (!new_freq_is_needed(first_entry, NULL, freq, pol, shift))
+	if (!dvb_new_freq_is_needed(first_entry, NULL, freq, pol, shift))
 		return NULL;
 
 	/* Clone the current entry into a new entry */
@@ -786,10 +786,10 @@ static void add_update_nit_dvbc(struct dvb_table_nit *nit,
 	}
 
 	/* Set NIT props for the transponder */
-	store_entry_prop(new, DTV_MODULATION,
-			 dvbc_modulation_table[d->modulation]);
-	store_entry_prop(new, DTV_SYMBOL_RATE, d->symbol_rate);
-	store_entry_prop(new, DTV_INNER_FEC, dvbc_fec_table[d->fec_inner]);
+	dvb_store_entry_prop(new, DTV_MODULATION,
+			     dvbc_modulation_table[d->modulation]);
+	dvb_store_entry_prop(new, DTV_SYMBOL_RATE, d->symbol_rate);
+	dvb_store_entry_prop(new, DTV_INNER_FEC, dvbc_fec_table[d->fec_inner]);
 
 }
 
@@ -807,8 +807,8 @@ static void add_update_nit_isdbt(struct dvb_table_nit *nit,
 		uint32_t mode = isdbt_mode[d->transmission_mode];
 		uint32_t guard = isdbt_interval[d->guard_interval];
 
-		store_entry_prop(tr->entry, DTV_TRANSMISSION_MODE, mode);
-		store_entry_prop(tr->entry, DTV_GUARD_INTERVAL, guard);
+		dvb_store_entry_prop(tr->entry, DTV_TRANSMISSION_MODE, mode);
+		dvb_store_entry_prop(tr->entry, DTV_GUARD_INTERVAL, guard);
 		return;
 	}
 
@@ -837,12 +837,12 @@ static void add_update_nit_1seg(struct dvb_table_nit *nit,
 
 	for (i = 0; i < len; i++) {
 		if (tr->entry->service_id == d->partial_reception[i].service_id) {
-			store_entry_prop(tr->entry,
-					 DTV_ISDBT_PARTIAL_RECEPTION, 1);
+			dvb_store_entry_prop(tr->entry,
+					     DTV_ISDBT_PARTIAL_RECEPTION, 1);
 			return;
 		}
 	}
-	store_entry_prop(tr->entry, DTV_ISDBT_PARTIAL_RECEPTION, 0);
+	dvb_store_entry_prop(tr->entry, DTV_ISDBT_PARTIAL_RECEPTION, 0);
 }
 
 static void add_update_nit_dvbt2(struct dvb_table_nit *nit,
@@ -866,20 +866,20 @@ static void add_update_nit_dvbt2(struct dvb_table_nit *nit,
 		if (tr->entry->service_id != t2->system_id)
 			return;
 
-		store_entry_prop(tr->entry, DTV_DELIVERY_SYSTEM,
-				SYS_DVBT2);
-		store_entry_prop(tr->entry, DTV_STREAM_ID,
-				t2->plp_id);
+		dvb_store_entry_prop(tr->entry, DTV_DELIVERY_SYSTEM,
+				     SYS_DVBT2);
+		dvb_store_entry_prop(tr->entry, DTV_STREAM_ID,
+				     t2->plp_id);
 
 		if (d->length -1 <= 4)
 			return;
 
-		store_entry_prop(tr->entry, DTV_BANDWIDTH_HZ,
-				dvbt2_bw[t2->bandwidth]);
-		store_entry_prop(tr->entry, DTV_GUARD_INTERVAL,
-				dvbt2_interval[t2->guard_interval]);
-		store_entry_prop(tr->entry, DTV_TRANSMISSION_MODE,
-				dvbt2_transmission_mode[t2->transmission_mode]);
+		dvb_store_entry_prop(tr->entry, DTV_BANDWIDTH_HZ,
+				     dvbt2_bw[t2->bandwidth]);
+		dvb_store_entry_prop(tr->entry, DTV_GUARD_INTERVAL,
+				     dvbt2_interval[t2->guard_interval]);
+		dvb_store_entry_prop(tr->entry, DTV_TRANSMISSION_MODE,
+				     dvbt2_transmission_mode[t2->transmission_mode]);
 
 		return;
 	}
@@ -894,16 +894,16 @@ static void add_update_nit_dvbt2(struct dvb_table_nit *nit,
 		if (!new)
 			return;
 
-		store_entry_prop(new, DTV_DELIVERY_SYSTEM,
-				 SYS_DVBT2);
-		store_entry_prop(new, DTV_STREAM_ID,
-				t2->plp_id);
-		store_entry_prop(new, DTV_BANDWIDTH_HZ,
-				dvbt2_bw[t2->bandwidth]);
-		store_entry_prop(new, DTV_GUARD_INTERVAL,
-				dvbt2_interval[t2->guard_interval]);
-		store_entry_prop(new, DTV_TRANSMISSION_MODE,
-				dvbt2_transmission_mode[t2->transmission_mode]);
+		dvb_store_entry_prop(new, DTV_DELIVERY_SYSTEM,
+				     SYS_DVBT2);
+		dvb_store_entry_prop(new, DTV_STREAM_ID,
+				     t2->plp_id);
+		dvb_store_entry_prop(new, DTV_BANDWIDTH_HZ,
+				     dvbt2_bw[t2->bandwidth]);
+		dvb_store_entry_prop(new, DTV_GUARD_INTERVAL,
+				     dvbt2_interval[t2->guard_interval]);
+		dvb_store_entry_prop(new, DTV_TRANSMISSION_MODE,
+				     dvbt2_transmission_mode[t2->transmission_mode]);
 	}
 }
 
@@ -925,19 +925,19 @@ static void add_update_nit_dvbt(struct dvb_table_nit *nit,
 		return;
 
 	/* Set NIT DVB-T props for the transponder */
-	store_entry_prop(new, DTV_MODULATION,
+	dvb_store_entry_prop(new, DTV_MODULATION,
 				dvbt_modulation[d->constellation]);
-	store_entry_prop(new, DTV_BANDWIDTH_HZ,
+	dvb_store_entry_prop(new, DTV_BANDWIDTH_HZ,
 				dvbt_bw[d->bandwidth]);
-	store_entry_prop(new, DTV_CODE_RATE_HP,
+	dvb_store_entry_prop(new, DTV_CODE_RATE_HP,
 				dvbt_code_rate[d->code_rate_hp_stream]);
-	store_entry_prop(new, DTV_CODE_RATE_LP,
+	dvb_store_entry_prop(new, DTV_CODE_RATE_LP,
 				dvbt_code_rate[d->code_rate_lp_stream]);
-	store_entry_prop(new, DTV_GUARD_INTERVAL,
+	dvb_store_entry_prop(new, DTV_GUARD_INTERVAL,
 				dvbt_interval[d->guard_interval]);
-	store_entry_prop(new, DTV_TRANSMISSION_MODE,
+	dvb_store_entry_prop(new, DTV_TRANSMISSION_MODE,
 				dvbt_transmission_mode[d->transmission_mode]);
-	store_entry_prop(new, DTV_HIERARCHY,
+	dvb_store_entry_prop(new, DTV_HIERARCHY,
 				dvbt_hierarchy[d->hierarchy_information]);
 }
 
@@ -966,27 +966,27 @@ static void add_update_nit_dvbs(struct dvb_table_nit *nit,
 
 	/* Set NIT DVB-S props for the transponder */
 
-	store_entry_prop(new, DTV_MODULATION,
-			dvbs_modulation[d->modulation_system]);
-	store_entry_prop(new, DTV_POLARIZATION,
-			dvbs_polarization[d->polarization]);
-	store_entry_prop(new, DTV_SYMBOL_RATE,
-			d->symbol_rate);
-	store_entry_prop(new, DTV_INNER_FEC,
-			dvbs_dvbc_dvbs_freq_inner[d->fec]);
-	store_entry_prop(new, DTV_ROLLOFF,
-				dvbs_rolloff[d->roll_off]);
+	dvb_store_entry_prop(new, DTV_MODULATION,
+			     dvbs_modulation[d->modulation_system]);
+	dvb_store_entry_prop(new, DTV_POLARIZATION,
+			     dvbs_polarization[d->polarization]);
+	dvb_store_entry_prop(new, DTV_SYMBOL_RATE,
+			     d->symbol_rate);
+	dvb_store_entry_prop(new, DTV_INNER_FEC,
+			     dvbs_dvbc_dvbs_freq_inner[d->fec]);
+	dvb_store_entry_prop(new, DTV_ROLLOFF,
+			     dvbs_rolloff[d->roll_off]);
 	if (d->roll_off != 0)
-		store_entry_prop(new, DTV_DELIVERY_SYSTEM,
-					SYS_DVBS2);
+		dvb_store_entry_prop(new, DTV_DELIVERY_SYSTEM,
+				     SYS_DVBS2);
 }
 
 
-void __dvb_add_update_transponders(struct dvb_v5_fe_parms *parms,
-				   struct dvb_v5_descriptors *dvb_scan_handler,
-				   struct dvb_entry *first_entry,
-				   struct dvb_entry *entry,
-				   uint32_t update)
+static void __dvb_add_update_transponders(struct dvb_v5_fe_parms *parms,
+					  struct dvb_v5_descriptors *dvb_scan_handler,
+					  struct dvb_entry *first_entry,
+					  struct dvb_entry *entry,
+					  uint32_t update)
 {
 	struct update_transponders tr = {
 		.parms = parms,
@@ -1000,38 +1000,43 @@ void __dvb_add_update_transponders(struct dvb_v5_fe_parms *parms,
 	if (!dvb_scan_handler->nit)
 		return;
 
-	tr.shift = estimate_freq_shift(parms);
+	tr.shift = dvb_estimate_freq_shift(parms);
 
 	switch (parms->current_sys) {
 	case SYS_DVBC_ANNEX_A:
 	case SYS_DVBC_ANNEX_C:
-		nit_descriptor_handler(parms, dvb_scan_handler->nit,
-				       cable_delivery_system_descriptor,
-				       NULL, add_update_nit_dvbc, &tr);
+		dvb_table_nit_descriptor_handler(
+				parms, dvb_scan_handler->nit,
+				cable_delivery_system_descriptor,
+				NULL, add_update_nit_dvbc, &tr);
 		return;
 	case SYS_ISDBT:
-		nit_descriptor_handler(parms, dvb_scan_handler->nit,
-				       partial_reception_descriptor,
-				       NULL, add_update_nit_1seg, &tr);
-		nit_descriptor_handler(parms, dvb_scan_handler->nit,
-				       ISDBT_delivery_system_descriptor,
-				       NULL, add_update_nit_isdbt, &tr);
+		dvb_table_nit_descriptor_handler(
+				parms, dvb_scan_handler->nit,
+				partial_reception_descriptor,
+				NULL, add_update_nit_1seg, &tr);
+		dvb_table_nit_descriptor_handler(parms, dvb_scan_handler->nit,
+				ISDBT_delivery_system_descriptor,
+				NULL, add_update_nit_isdbt, &tr);
 		return;
 	case SYS_DVBT:
 	case SYS_DVBT2:
-		nit_descriptor_handler(parms, dvb_scan_handler->nit,
-				       extension_descriptor,
-				       NULL, add_update_nit_dvbt2, &tr);
-
-		nit_descriptor_handler(parms, dvb_scan_handler->nit,
-				       terrestrial_delivery_system_descriptor,
-				       NULL, add_update_nit_dvbt, &tr);
+		dvb_table_nit_descriptor_handler(
+				parms, dvb_scan_handler->nit,
+				extension_descriptor,
+				NULL, add_update_nit_dvbt2, &tr);
+
+		dvb_table_nit_descriptor_handler(
+				parms, dvb_scan_handler->nit,
+				terrestrial_delivery_system_descriptor,
+				NULL, add_update_nit_dvbt, &tr);
 		return;
 	case SYS_DVBS:
 	case SYS_DVBS2:
-		nit_descriptor_handler(parms, dvb_scan_handler->nit,
-				       satellite_delivery_system_descriptor,
-				       NULL, add_update_nit_dvbs, &tr);
+		dvb_table_nit_descriptor_handler(
+				parms, dvb_scan_handler->nit,
+				satellite_delivery_system_descriptor,
+				NULL, add_update_nit_dvbs, &tr);
 		return;
 	default:
 		dvb_log("Transponders detection not implemented for this standard yet.");
diff --git a/lib/libdvbv5/tables/eit.c b/lib/libdvbv5/tables/eit.c
index b17ff32..f9c15b8 100644
--- a/lib/libdvbv5/tables/eit.c
+++ b/lib/libdvbv5/tables/eit.c
@@ -86,9 +86,9 @@ ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		event->descriptor = NULL;
 		event->next = NULL;
 		dvb_time(event->dvbstart, &event->start);
-		event->duration = bcd((uint32_t) event->dvbduration[0]) * 3600 +
-				  bcd((uint32_t) event->dvbduration[1]) * 60 +
-				  bcd((uint32_t) event->dvbduration[2]);
+		event->duration = dvb_bcd((uint32_t) event->dvbduration[0]) * 3600 +
+				  dvb_bcd((uint32_t) event->dvbduration[1]) * 60 +
+				  dvb_bcd((uint32_t) event->dvbduration[2]);
 
 		event->service_id = eit->header.id;
 
@@ -163,9 +163,9 @@ void dvb_time(const uint8_t data[5], struct tm *tm)
   uint16_t mjd;
 
   mjd   = *(uint16_t *) data;
-  hour  = bcd(data[2]);
-  min   = bcd(data[3]);
-  sec   = bcd(data[4]);
+  hour  = dvb_bcd(data[2]);
+  min   = dvb_bcd(data[3]);
+  sec   = dvb_bcd(data[4]);
   year  = ((mjd - 15078.2) / 365.25);
   month = ((mjd - 14956.1 - (int) (year * 365.25)) / 30.6001);
   day   = mjd - 14956 - (int) (year * 365.25) - (int) (month * 30.6001);
diff --git a/lib/libdvbv5/tables/nit.c b/lib/libdvbv5/tables/nit.c
index 08b156c..a29c6da 100644
--- a/lib/libdvbv5/tables/nit.c
+++ b/lib/libdvbv5/tables/nit.c
@@ -158,7 +158,8 @@ void dvb_table_nit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *ni
 	dvb_loginfo("|_  %d transports", transports);
 }
 
-void nit_descriptor_handler(struct dvb_v5_fe_parms *parms,
+void dvb_table_nit_descriptor_handler(
+			    struct dvb_v5_fe_parms *parms,
 			    struct dvb_table_nit *nit,
 			    enum descriptors descriptor,
 			    nit_handler_callback_t *call_nit,
diff --git a/utils/dvb/dvb-fe-tool.c b/utils/dvb/dvb-fe-tool.c
index d9d63af..0d7f291 100644
--- a/utils/dvb/dvb-fe-tool.c
+++ b/utils/dvb/dvb-fe-tool.c
@@ -63,7 +63,7 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 		frontend = atoi(arg);
 		break;
 	case 'd':
-		delsys = parse_delsys(arg);
+		delsys = dvb_parse_delsys(arg);
 		if (delsys < 0)
 			return ARGP_ERR_UNKNOWN;
 		break;
diff --git a/utils/dvb/dvb-format-convert.c b/utils/dvb/dvb-format-convert.c
index ab3cd79..d5a3bea 100644
--- a/utils/dvb/dvb-format-convert.c
+++ b/utils/dvb/dvb-format-convert.c
@@ -58,13 +58,13 @@ static error_t parse_opt(int k, char *optarg, struct argp_state *state)
 	struct arguments *args = state->input;
 	switch (k) {
 	case 'I':
-		args->input_format = parse_format(optarg);
+		args->input_format = dvb_parse_format(optarg);
 		break;
 	case 'O':
-		args->output_format = parse_format(optarg);
+		args->output_format = dvb_parse_format(optarg);
 		break;
 	case 's':
-		args->delsys = parse_delsys(optarg);
+		args->delsys = dvb_parse_delsys(optarg);
 		break;
 	default:
 		return ARGP_ERR_UNKNOWN;
@@ -87,8 +87,8 @@ static int convert_file(struct arguments *args)
 	}
 
 	printf("Writing file %s\n", args->output_file);
-	ret = write_file_format(args->output_file, dvb_file,
-				args->delsys, args->output_format);
+	ret = dvb_write_file_format(args->output_file, dvb_file,
+				    args->delsys, args->output_format);
 
 	return ret;
 }
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index 7eb3bf5..8694aaf 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -243,16 +243,16 @@ static int run_scan(struct arguments *args,
 		 * If the channel file has duplicated frequencies, or some
 		 * entries without any frequency at all, discard.
 		 */
-		if (retrieve_entry_prop(entry, DTV_FREQUENCY, &freq))
+		if (dvb_retrieve_entry_prop(entry, DTV_FREQUENCY, &freq))
 			continue;
 
-		shift = estimate_freq_shift(parms);
+		shift = dvb_estimate_freq_shift(parms);
 
-		if (retrieve_entry_prop(entry, DTV_POLARIZATION, &pol))
+		if (dvb_retrieve_entry_prop(entry, DTV_POLARIZATION, &pol))
 			pol = POLARIZATION_OFF;
 
-		if (!new_freq_is_needed(dvb_file->first_entry, entry,
-					freq, pol, shift))
+		if (!dvb_new_freq_is_needed(dvb_file->first_entry, entry,
+					    freq, pol, shift))
 			continue;
 
 		count++;
@@ -277,7 +277,7 @@ static int run_scan(struct arguments *args,
 		/*
 		 * Store the service entry
 		 */
-		store_dvb_channel(&dvb_file_new, parms, dvb_scan_handler,
+		dvb_store_channel(&dvb_file_new, parms, dvb_scan_handler,
 				  args->get_detected, args->get_nit);
 
 		/*
@@ -295,8 +295,8 @@ static int run_scan(struct arguments *args,
 	}
 
 	if (dvb_file_new)
-		write_file_format(args->output, dvb_file_new,
-				  parms->current_sys, args->output_format);
+		dvb_write_file_format(args->output, dvb_file_new,
+				      parms->current_sys, args->output_format);
 
 	dvb_file_free(dvb_file);
 	if (dvb_file_new)
@@ -370,10 +370,10 @@ static error_t parse_opt(int k, char *optarg, struct argp_state *state)
 		args->timeout_multiply = strtoul(optarg, NULL, 0);
 		break;
 	case 'I':
-		args->input_format = parse_format(optarg);
+		args->input_format = dvb_parse_format(optarg);
 		break;
 	case 'O':
-		args->output_format = parse_format(optarg);
+		args->output_format = dvb_parse_format(optarg);
 		break;
 	case 'o':
 		args->output = optarg;
@@ -437,11 +437,11 @@ int main(int argc, char **argv)
 		lnb = dvb_sat_search_lnb(args.lnb_name);
 		if (lnb < 0) {
 			printf("Please select one of the LNBf's below:\n");
-			print_all_lnb();
+			dvb_print_all_lnb();
 			exit(1);
 		} else {
 			printf("Using LNBf ");
-			print_lnb(lnb);
+			dvb_print_lnb(lnb);
 		}
 	}
 
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index 14e8fd9..5977a67 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -174,7 +174,7 @@ static int parse(struct arguments *args,
 		if (freq) {
 			for (entry = dvb_file->first_entry; entry != NULL;
 			entry = entry->next) {
-				retrieve_entry_prop(entry, DTV_FREQUENCY, &f);
+				dvb_retrieve_entry_prop(entry, DTV_FREQUENCY, &f);
 				if (f == freq)
 					break;
 			}
@@ -226,7 +226,7 @@ static int parse(struct arguments *args,
 	*sid = entry->service_id;
 
         /* First of all, set the delivery system */
-	retrieve_entry_prop(entry, DTV_DELIVERY_SYSTEM, &sys);
+	dvb_retrieve_entry_prop(entry, DTV_DELIVERY_SYSTEM, &sys);
 	dvb_set_compat_delivery_system(parms, sys);
 
 	/* Copy data into parms */
@@ -454,7 +454,7 @@ static error_t parse_opt(int k, char *optarg, struct argp_state *state)
 		args->timeout = strtoul(optarg, NULL, 0);
 		break;
 	case 'I':
-		args->input_format = parse_format(optarg);
+		args->input_format = dvb_parse_format(optarg);
 		break;
 	case 'o':
 		args->filename = strdup(optarg);
@@ -732,11 +732,11 @@ int main(int argc, char **argv)
 		lnb = dvb_sat_search_lnb(args.lnb_name);
 		if (lnb < 0) {
 			printf("Please select one of the LNBf's below:\n");
-			print_all_lnb();
+			dvb_print_all_lnb();
 			exit(1);
 		} else {
 			printf("Using LNBf ");
-			print_lnb(lnb);
+			dvb_print_lnb(lnb);
 		}
 	}
 
@@ -811,7 +811,7 @@ int main(int argc, char **argv)
 				sid);
 			goto err;
 		}
-		pmtpid = get_pmt_pid(args.demux_dev, sid);
+		pmtpid = dvb_get_pmt_pid(args.demux_dev, sid);
 		if (pmtpid <= 0) {
 			fprintf(stderr, "couldn't find pmt-pid for sid %04x\n",
 				sid);
-- 
1.9.1

