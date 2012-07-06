Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46238 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019Ab2GFTX7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 15:23:59 -0400
Received: by wibhr14 with SMTP id hr14so1171047wib.1
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 12:23:57 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 5/5] libdvbv5: Support multi section DVB tables, string parsing
Date: Fri,  6 Jul 2012 21:23:12 +0200
Message-Id: <1341602592-29508-5-git-send-email-neolynx@gmail.com>
In-Reply-To: <1341602592-29508-1-git-send-email-neolynx@gmail.com>
References: <1341602592-29508-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors.h                          |   15 ++-
 lib/include/descriptors/desc_cable_delivery.h      |    2 +-
 lib/include/descriptors/desc_frequency_list.h      |    2 +-
 lib/include/descriptors/desc_language.h            |    2 +-
 lib/include/descriptors/desc_network_name.h        |    2 +-
 lib/include/descriptors/desc_sat.h                 |    2 +-
 lib/include/descriptors/desc_service.h             |    2 +-
 lib/include/descriptors/desc_service_list.h        |    2 +-
 .../descriptors/desc_terrestrial_delivery.h        |    2 +-
 lib/include/descriptors/nit.h                      |    2 +-
 lib/include/descriptors/pat.h                      |    2 +-
 lib/include/descriptors/pmt.h                      |   12 +-
 lib/include/descriptors/sdt.h                      |    2 +-
 lib/include/dvb-scan.h                             |    2 +-
 lib/libdvbv5/descriptors.c                         |   88 +++++++++----
 lib/libdvbv5/descriptors/desc_network_name.c       |   24 +++-
 lib/libdvbv5/descriptors/desc_service.c            |   46 +++++-
 lib/libdvbv5/descriptors/nit.c                     |   65 ++++++----
 lib/libdvbv5/descriptors/pat.c                     |   37 +++---
 lib/libdvbv5/descriptors/pmt.c                     |   87 ++++++------
 lib/libdvbv5/descriptors/sdt.c                     |   57 +++++---
 lib/libdvbv5/dvb-scan.c                            |  143 +++++++++++--------
 lib/libdvbv5/parse_string.c                        |   16 ++-
 lib/libdvbv5/parse_string.h                        |    4 +-
 utils/dvb/dvbv5-scan.c                             |    2 +-
 25 files changed, 391 insertions(+), 229 deletions(-)

diff --git a/lib/include/descriptors.h b/lib/include/descriptors.h
index 8ecb13d..0493e80 100644
--- a/lib/include/descriptors.h
+++ b/lib/include/descriptors.h
@@ -35,13 +35,15 @@
 
 struct dvb_v5_fe_parms;
 
-typedef void *(*dvb_table_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size);
+typedef void (*dvb_table_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen);
 
 struct dvb_table_init {
 	dvb_table_init_func init;
 };
 
 extern const struct dvb_table_init dvb_table_initializers[];
+extern char *default_charset;
+extern char *output_charset;
 
 #define bswap16(b) do {\
 	b = be16toh(b); \
@@ -53,11 +55,15 @@ extern const struct dvb_table_init dvb_table_initializers[];
 
 struct dvb_desc {
 	uint8_t type;
-	struct dvb_desc *next;
 	uint8_t length;
+	struct dvb_desc *next;
+
 	uint8_t data[];
 } __attribute__((packed));
 
+ssize_t dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_default_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+
 #define dvb_desc_foreach( _desc, _tbl ) \
 	for( struct dvb_desc *_desc = _tbl->descriptor; _desc; _desc = _desc->next ) \
 
@@ -69,7 +75,10 @@ ssize_t dvb_desc_init(const uint8_t *buf, struct dvb_desc *desc);
 
 uint32_t bcd(uint32_t bcd);
 
+void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned char *buf, int len);
+
 ssize_t dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf, uint8_t *dest, uint16_t section_length, struct dvb_desc **head_desc);
+void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc);
 
 struct dvb_v5_fe_parms;
 
@@ -381,7 +390,7 @@ struct dvb_v5_descriptors {
 	unsigned cur_ts;
 };
 
-void parse_descriptor(enum dvb_tables type,
+void parse_descriptor(struct dvb_v5_fe_parms *parms, enum dvb_tables type,
 		struct dvb_v5_descriptors *dvb_desc,
 		const unsigned char *buf, int len);
 
diff --git a/lib/include/descriptors/desc_cable_delivery.h b/lib/include/descriptors/desc_cable_delivery.h
index 4d10a29..bdbe706 100644
--- a/lib/include/descriptors/desc_cable_delivery.h
+++ b/lib/include/descriptors/desc_cable_delivery.h
@@ -27,8 +27,8 @@
 
 struct dvb_desc_cable_delivery {
 	uint8_t type;
-	struct dvb_desc *next;
 	uint8_t length;
+	struct dvb_desc *next;
 
 	uint32_t frequency;
 	union {
diff --git a/lib/include/descriptors/desc_frequency_list.h b/lib/include/descriptors/desc_frequency_list.h
index 21f0256..80a7fb9 100644
--- a/lib/include/descriptors/desc_frequency_list.h
+++ b/lib/include/descriptors/desc_frequency_list.h
@@ -27,8 +27,8 @@
 
 struct dvb_desc_frequency_list {
 	uint8_t type;
-	struct dvb_desc *next;
 	uint8_t length;
+	struct dvb_desc *next;
 
 	union {
 		uint8_t bitfield;
diff --git a/lib/include/descriptors/desc_language.h b/lib/include/descriptors/desc_language.h
index 321a948..eca9cdb 100644
--- a/lib/include/descriptors/desc_language.h
+++ b/lib/include/descriptors/desc_language.h
@@ -27,8 +27,8 @@
 
 struct dvb_desc_language {
 	uint8_t type;
-	struct dvb_desc *next;
 	uint8_t length;
+	struct dvb_desc *next;
 
 	unsigned char language[4];
 	uint8_t audio_type;
diff --git a/lib/include/descriptors/desc_network_name.h b/lib/include/descriptors/desc_network_name.h
index 011cba9..706b36c 100644
--- a/lib/include/descriptors/desc_network_name.h
+++ b/lib/include/descriptors/desc_network_name.h
@@ -27,8 +27,8 @@
 
 struct dvb_desc_network_name {
 	uint8_t type;
-	struct dvb_desc *next;
 	uint8_t length;
+	struct dvb_desc *next;
 
 	unsigned char network_name[];
 } __attribute__((packed));
diff --git a/lib/include/descriptors/desc_sat.h b/lib/include/descriptors/desc_sat.h
index a287685..820d8f1 100644
--- a/lib/include/descriptors/desc_sat.h
+++ b/lib/include/descriptors/desc_sat.h
@@ -27,8 +27,8 @@
 
 struct dvb_desc_sat {
 	uint8_t type;
-	struct dvb_desc *next;
 	uint8_t length;
+	struct dvb_desc *next;
 
 	uint32_t frequency;
 	uint16_t orbit;
diff --git a/lib/include/descriptors/desc_service.h b/lib/include/descriptors/desc_service.h
index c5b01cb..a89b3ed 100644
--- a/lib/include/descriptors/desc_service.h
+++ b/lib/include/descriptors/desc_service.h
@@ -27,8 +27,8 @@
 
 struct dvb_desc_service {
 	uint8_t type;
-	struct dvb_desc *next;
 	uint8_t length;
+	struct dvb_desc *next;
 
 	uint8_t service_type;
 	char *name;
diff --git a/lib/include/descriptors/desc_service_list.h b/lib/include/descriptors/desc_service_list.h
index cb60eb5..919623f 100644
--- a/lib/include/descriptors/desc_service_list.h
+++ b/lib/include/descriptors/desc_service_list.h
@@ -32,8 +32,8 @@ struct dvb_desc_service_list_table {
 
 struct dvb_desc_service_list {
 	uint8_t type;
-	struct dvb_desc *next;
 	uint8_t length;
+	struct dvb_desc *next;
 
 	struct dvb_desc_service_list_table services[];
 } __attribute__((packed));
diff --git a/lib/include/descriptors/desc_terrestrial_delivery.h b/lib/include/descriptors/desc_terrestrial_delivery.h
index da86cb4..482f4b0 100644
--- a/lib/include/descriptors/desc_terrestrial_delivery.h
+++ b/lib/include/descriptors/desc_terrestrial_delivery.h
@@ -27,8 +27,8 @@
 
 struct dvb_desc_terrestrial_delivery {
 	uint8_t type;
-	struct dvb_desc *next;
 	uint8_t length;
+	struct dvb_desc *next;
 
 	uint32_t centre_frequency;
 	uint8_t reserved_future_use1:2;
diff --git a/lib/include/descriptors/nit.h b/lib/include/descriptors/nit.h
index 6a7e472..013a842 100644
--- a/lib/include/descriptors/nit.h
+++ b/lib/include/descriptors/nit.h
@@ -76,7 +76,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void *dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size);
+void dvb_table_nit_init (struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen);
 void dvb_table_nit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *nit);
 
 #ifdef __cplusplus
diff --git a/lib/include/descriptors/pat.h b/lib/include/descriptors/pat.h
index 8a7cd60..69e1956 100644
--- a/lib/include/descriptors/pat.h
+++ b/lib/include/descriptors/pat.h
@@ -53,7 +53,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void *dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size);
+void dvb_table_pat_init (struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen);
 void dvb_table_pat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_pat *t);
 
 #ifdef __cplusplus
diff --git a/lib/include/descriptors/pmt.h b/lib/include/descriptors/pmt.h
index d1cad30..b923677 100644
--- a/lib/include/descriptors/pmt.h
+++ b/lib/include/descriptors/pmt.h
@@ -35,15 +35,15 @@ struct dvb_table_pmt_stream {
 		uint16_t bitfield;
 		struct {
 			uint16_t elementary_pid:13;
-			uint16_t  reserved:3;
+			uint16_t reserved:3;
 		};
 	};
 	union {
 		uint16_t bitfield2;
 		struct {
 			uint16_t section_length:10;
-			uint16_t  zero:2;
-			uint16_t  reserved2:4;
+			uint16_t zero:2;
+			uint16_t reserved2:4;
 		};
 	};
 	struct dvb_desc *descriptor;
@@ -64,8 +64,8 @@ struct dvb_table_pmt {
 		uint16_t bitfield2;
 		struct {
 			uint16_t prog_length:10;
-			uint16_t  zero3:2;
-			uint16_t  reserved3:4;
+			uint16_t zero3:2;
+			uint16_t reserved3:4;
 		};
 	};
 	struct dvb_table_pmt_stream *stream;
@@ -80,7 +80,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void *dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size);
+void dvb_table_pmt_init (struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen);
 void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_pmt *pmt);
 
 #ifdef __cplusplus
diff --git a/lib/include/descriptors/sdt.h b/lib/include/descriptors/sdt.h
index 5cea2d8..877442a 100644
--- a/lib/include/descriptors/sdt.h
+++ b/lib/include/descriptors/sdt.h
@@ -64,7 +64,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void *dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size);
+void dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen);
 void dvb_table_sdt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_sdt *sdt);
 
 #ifdef __cplusplus
diff --git a/lib/include/dvb-scan.h b/lib/include/dvb-scan.h
index 284a9b6..9f4b914 100644
--- a/lib/include/dvb-scan.h
+++ b/lib/include/dvb-scan.h
@@ -34,7 +34,7 @@ extern "C" {
 int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char table, uint16_t pid, unsigned char **buf,
 		unsigned *length, unsigned timeout);
 
-struct dvb_v5_descriptors *dvb_get_ts_tables(int dmx_fd,
+struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms, int dmx_fd,
 					  uint32_t delivery_system,
 					  unsigned other_nit,
 					  unsigned timeout_multiply,
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 288fc58..46957a3 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -46,11 +46,23 @@
 ssize_t dvb_desc_init(const uint8_t *buf, struct dvb_desc *desc)
 {
 	desc->type   = buf[0];
-	desc->next   = NULL;
 	desc->length = buf[1];
+	desc->next   = NULL;
 	return 2;
 }
 
+ssize_t dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	memcpy(desc->data, buf, desc->length);
+	return sizeof(struct dvb_desc) + desc->length;
+}
+
+void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	dvb_log("|                   %s (%d)", dvb_descriptors[desc->type].name, desc->type);
+	hexdump(parms, "|                       ", desc->data, desc->length);
+}
+
 const struct dvb_table_init dvb_table_initializers[] = {
 	[DVB_TABLE_PAT] = { dvb_table_pat_init },
 	[DVB_TABLE_PMT] = { dvb_table_pmt_init },
@@ -58,8 +70,8 @@ const struct dvb_table_init dvb_table_initializers[] = {
 	[DVB_TABLE_SDT] = { dvb_table_sdt_init },
 };
 
-static char *default_charset = "iso-8859-1";
-static char *output_charset = "utf-8";
+char *default_charset = "iso-8859-1";
+char *output_charset = "utf-8";
 
 static char *table[] = {
 	[PAT] = "PAT",
@@ -75,25 +87,35 @@ ssize_t dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	struct dvb_desc *current = NULL;
 	struct dvb_desc *last = NULL;
 	while (ptr < buf + section_length) {
-	    current = (struct dvb_desc *) dest;
-	    ptr += dvb_desc_init(ptr, current); /* the standard header was read */
-		if (dvb_descriptors[current->type].init) {
-			ssize_t len = dvb_descriptors[current->type].init(parms, ptr, current);
-			if(!*head_desc)
-				*head_desc = current;
-			if (last)
-				last->next = current;
-			last = current;
-			dest += len;
-			length += len;
-		} else {
-			dvb_logdbg("no parser for descriptor %s (%d)", dvb_descriptors[current->type].name, current->type);
-		}
+		current = (struct dvb_desc *) dest;
+		ptr += dvb_desc_init(ptr, current); /* the standard header was read */
+		dvb_desc_init_func init = dvb_descriptors[current->type].init;
+		if (!init)
+			init = dvb_desc_default_init;
+		ssize_t len = init(parms, ptr, current);
+		if(!*head_desc)
+			*head_desc = current;
+		if (last)
+			last->next = current;
+		last = current;
+		dest += len;
+		length += len;
 		ptr += current->length;     /* standard descriptor header plus descriptor length */
 	}
 	return length;
 }
 
+void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc)
+{
+	while (desc) {
+		dvb_desc_print_func print = dvb_descriptors[desc->type].print;
+		if (!print)
+			print = dvb_desc_default_print;
+		print(parms, desc);
+		desc = desc->next;
+	}
+}
+
 const struct dvb_descriptor dvb_descriptors[] = {
 	[0 ...255 ] = { "Unknown descriptor", NULL, NULL },
 	[video_stream_descriptor] = { "video_stream_descriptor", NULL, NULL },
@@ -682,10 +704,10 @@ static int parse_extension_descriptor(enum dvb_tables type,
 	return 0;
 };
 
-static void parse_net_name(struct nit_table *nit_table,
+static void parse_net_name(struct dvb_v5_fe_parms *parms, struct nit_table *nit_table,
 		const unsigned char *buf, int dlen, int verbose)
 {
-	parse_string(&nit_table->network_name, &nit_table->network_alias,
+	parse_string(parms, &nit_table->network_name, &nit_table->network_alias,
 			&buf[2], dlen, default_charset, output_charset);
 	if (verbose) {
 		printf("Network");
@@ -723,16 +745,16 @@ static void parse_lcn(struct nit_table *nit_table,
 	}
 }
 
-static void parse_service(struct service_table *service_table,
+static void parse_service(struct dvb_v5_fe_parms *parms, struct service_table *service_table,
 		const unsigned char *buf, int dlen, int verbose)
 {
 	service_table->type = buf[2];
-	parse_string(&service_table->provider_name,
+	parse_string(parms, &service_table->provider_name,
 			&service_table->provider_alias,
 			&buf[4], buf[3],
 			default_charset, output_charset);
 	buf += 4 + buf[3];
-	parse_string(&service_table->service_name,
+	parse_string(parms, &service_table->service_name,
 			&service_table->service_alias,
 			&buf[1], buf[0],
 			default_charset, output_charset);
@@ -756,7 +778,7 @@ static void parse_service(struct service_table *service_table,
 	}
 }
 
-void parse_descriptor(enum dvb_tables type,
+void parse_descriptor(struct dvb_v5_fe_parms *parms, enum dvb_tables type,
 		struct dvb_v5_descriptors *dvb_desc,
 		const unsigned char *buf, int len)
 {
@@ -818,7 +840,7 @@ void parse_descriptor(enum dvb_tables type,
 					err = 1;
 					break;
 				}
-				parse_net_name(&dvb_desc->nit_table, buf, dlen,
+				parse_net_name(parms, &dvb_desc->nit_table, buf, dlen,
 						dvb_desc->verbose);
 				break;
 
@@ -910,7 +932,7 @@ void parse_descriptor(enum dvb_tables type,
 								 err = 1;
 								 break;
 							 }
-							 parse_service(&dvb_desc->sdt_table.service_table[dvb_desc->cur_service],
+							 parse_service(parms, &dvb_desc->sdt_table.service_table[dvb_desc->cur_service],
 									 buf, dlen, dvb_desc->verbose);
 							 break;
 						 }
@@ -947,6 +969,22 @@ int has_descriptor(struct dvb_v5_descriptors *dvb_desc,
 	return 0;
 }
 
+void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned char *buf, int len)
+{
+	int i, j;
+	char tmp[256];
+	/*printf("size %d", len);*/
+	for (i = 0, j = 0; i < len; i++, j++) {
+		if (i && !(i % 16)) {
+			dvb_log("%s%s", prefix, tmp);
+			j = 0;
+		}
+		sprintf( tmp + j * 3, "%02x ", (uint8_t) *(buf + i));
+	}
+	if (i && (i % 16))
+		dvb_log("%s%s", prefix, tmp);
+}
+
 #if 0
 /* TODO: remove those stuff */
 
diff --git a/lib/libdvbv5/descriptors/desc_network_name.c b/lib/libdvbv5/descriptors/desc_network_name.c
index 10e18c3..e89bd2d 100644
--- a/lib/libdvbv5/descriptors/desc_network_name.c
+++ b/lib/libdvbv5/descriptors/desc_network_name.c
@@ -22,15 +22,33 @@
 #include "descriptors/desc_network_name.h"
 #include "descriptors.h"
 #include "dvb-fe.h"
+#include "parse_string.h"
 
 ssize_t dvb_desc_network_name_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_network_name *net = (struct dvb_desc_network_name *) desc;
+	char *name, *emph;
+	uint8_t len;  /* the length of the string in the input data */
+	uint8_t len1; /* the lenght of the output strings */
 
-	memcpy(net->network_name, buf, net->length);
-	net->network_name[net->length] = '\0';
+	len = desc->length;
+	len1 = len;
+	name = NULL;
+	emph = NULL;
+	parse_string(parms, &name, &emph, buf, len1, default_charset, output_charset);
+	buf += len;
+	if (emph)
+		free(emph);
+	if (name) {
+		len1 = strlen(name);
+		memcpy(net->network_name, name, len1);
+		free(name);
+	} else {
+		memcpy(net->network_name, buf, len1);
+	}
+	net->network_name[len1] = '\0';
 
-	return sizeof(struct dvb_desc_network_name) + net->length + sizeof(net->network_name[0]);
+	return sizeof(struct dvb_desc_network_name) + len1 + 1;
 }
 
 void dvb_desc_network_name_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_service.c b/lib/libdvbv5/descriptors/desc_service.c
index 0507e5c..78c8d63 100644
--- a/lib/libdvbv5/descriptors/desc_service.c
+++ b/lib/libdvbv5/descriptors/desc_service.c
@@ -22,25 +22,55 @@
 #include "descriptors/desc_service.h"
 #include "descriptors.h"
 #include "dvb-fe.h"
+#include "parse_string.h"
 
 ssize_t dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_service *service = (struct dvb_desc_service *) desc;
+	char *name, *emph;
+	uint8_t len;        /* the length of the string in the input data */
+	uint8_t len1, len2; /* the lenght of the output strings */
 
+	/*hexdump(parms, "service desc: ", buf - 2, desc->length + 2);*/
 	service->service_type = buf[0];
 	buf++;
 
 	service->provider = ((char *) desc) + sizeof(struct dvb_desc_service);
-	uint8_t len1 = buf[0];
+	len = buf[0];
 	buf++;
-	memcpy(service->provider, buf, len1);
+	len1 = len;
+	name = NULL;
+	emph = NULL;
+	parse_string(parms, &name, &emph, buf, len1, default_charset, output_charset);
+	buf += len;
+	if (emph)
+		free(emph);
+	if (name) {
+		len1 = strlen(name);
+		memcpy(service->provider, name, len1);
+		free(name);
+	} else {
+		memcpy(service->provider, buf, len1);
+	}
 	service->provider[len1] = '\0';
-	buf += len1;
 
 	service->name = service->provider + len1 + 1;
-	uint8_t len2 = buf[0];
+	len = buf[0];
+	len2 = len;
 	buf++;
-	memcpy(service->name, buf, len2);
+	name = NULL;
+	emph = NULL;
+	parse_string(parms, &name, &emph, buf, len2, default_charset, output_charset);
+	buf += len;
+	if (emph)
+		free(emph);
+	if (name) {
+		len2 = strlen(name);
+		memcpy(service->name, name, len2);
+		free(name);
+	} else {
+		memcpy(service->name, buf, len2);
+	}
 	service->name[len2] = '\0';
 
 	return sizeof(struct dvb_desc_service) + len1 + 1 + len2 + 1;
@@ -49,8 +79,8 @@ ssize_t dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 void dvb_desc_service_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_service *srv = (const struct dvb_desc_service *) desc;
-	dvb_log("|           type    : '%d'", srv->service_type);
-	dvb_log("|           name    : '%s'", srv->name);
-	dvb_log("|           provider: '%s'", srv->provider);
+	dvb_log("|   service type     %d", srv->service_type);
+	dvb_log("|           name     '%s'", srv->name);
+	dvb_log("|           provider '%s'", srv->provider);
 }
 
diff --git a/lib/libdvbv5/descriptors/nit.c b/lib/libdvbv5/descriptors/nit.c
index 1a429bb..bf596fc 100644
--- a/lib/libdvbv5/descriptors/nit.c
+++ b/lib/libdvbv5/descriptors/nit.c
@@ -22,33 +22,56 @@
 #include "descriptors/nit.h"
 #include "dvb-fe.h"
 
-void *dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size)
+void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen)
 {
-	uint8_t *d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 2);
-	const uint8_t *p = buf;
-	struct dvb_table_nit *nit = (struct dvb_table_nit *) d;
+	uint8_t *d;
+	const uint8_t *p = ptr;
+	struct dvb_table_nit *nit;
+	struct dvb_desc **head_desc;
+	struct dvb_table_nit_transport **head;
 
-	memcpy(nit, p, sizeof(struct dvb_table_nit) - sizeof(nit->descriptor) - sizeof(nit->transport));
-	p += sizeof(struct dvb_table_nit) - sizeof(nit->descriptor) - sizeof(nit->transport);
-	d += sizeof(struct dvb_table_nit);
+	if (!*buf) {
+		d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 4);
+		*buf = d;
+		*buflen = 0;
+		nit = (struct dvb_table_nit *) d;
+
+		memcpy(d + *buflen, p, sizeof(struct dvb_table_nit) - sizeof(nit->descriptor) - sizeof(nit->transport));
+		*buflen += sizeof(struct dvb_table_nit);
+
+		nit->descriptor = NULL;
+		nit->transport = NULL;
+		head_desc = &nit->descriptor;
+		head = &nit->transport;
+	} else {
+		// should realloc d
+		d = *buf;
 
-	dvb_table_header_init(&nit->header);
+		// find end of curent list
+		nit = (struct dvb_table_nit *) d;
+		head_desc = &nit->descriptor;
+		while (*head_desc != NULL)
+			head_desc = &(*head_desc)->next;
+		head = &nit->transport;
+		while (*head != NULL)
+			head = &(*head)->next;
+		// read new table
+		nit = (struct dvb_table_nit *) p; // FIXME: should be copied to tmp, cause bswap in const
+	}
 	bswap16(nit->bitfield);
-	nit->descriptor = NULL;
-	nit->transport = NULL;
+	p += sizeof(struct dvb_table_nit) - sizeof(nit->descriptor) - sizeof(nit->transport);
 
-	d += dvb_parse_descriptors(parms, p, d, nit->desc_length, &nit->descriptor);
+	*buflen += dvb_parse_descriptors(parms, p, d + *buflen, nit->desc_length, head_desc);
 	p += nit->desc_length;
 
 	p += sizeof(union dvb_table_nit_transport_header);
 
 	struct dvb_table_nit_transport *last = NULL;
-	struct dvb_table_nit_transport **head = &nit->transport;
-	while ((uint8_t *) p < buf + size - 4) {
-		struct dvb_table_nit_transport *transport = (struct dvb_table_nit_transport *) d;
-		memcpy(d, p, sizeof(struct dvb_table_nit_transport) - sizeof(transport->descriptor) - sizeof(transport->next));
+	while ((uint8_t *) p < ptr + size - 4) {
+		struct dvb_table_nit_transport *transport = (struct dvb_table_nit_transport *) (d + *buflen);
+		memcpy(d + *buflen, p, sizeof(struct dvb_table_nit_transport) - sizeof(transport->descriptor) - sizeof(transport->next));
 		p += sizeof(struct dvb_table_nit_transport) - sizeof(transport->descriptor) - sizeof(transport->next);
-		d += sizeof(struct dvb_table_nit_transport);
+		*buflen += sizeof(struct dvb_table_nit_transport);
 
 		bswap16(transport->transport_id);
 		bswap16(transport->network_id);
@@ -63,12 +86,11 @@ void *dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssiz
 
 		/* get the descriptors for each transport */
 		struct dvb_desc **head_desc = &transport->descriptor;
-		d += dvb_parse_descriptors(parms, p, d, transport->section_length, head_desc);
+		*buflen += dvb_parse_descriptors(parms, p, d + *buflen, transport->section_length, head_desc);
 
 		p += transport->section_length;
 		last = transport;
 	}
-	return nit;
 }
 
 void dvb_table_nit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *nit)
@@ -86,12 +108,7 @@ void dvb_table_nit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *ni
 	uint16_t transports = 0;
 	while(transport) {
 		dvb_log("|- Transport: %-7d Network: %-7d", transport->transport_id, transport->network_id);
-		desc = transport->descriptor;
-		while (desc) {
-			if (dvb_descriptors[desc->type].print)
-				dvb_descriptors[desc->type].print(parms, desc);
-			desc = desc->next;
-		}
+		dvb_print_descriptors(parms, transport->descriptor);
 		transport = transport->next;
 		transports++;
 	}
diff --git a/lib/libdvbv5/descriptors/pat.c b/lib/libdvbv5/descriptors/pat.c
index d1fb30b..eb076fd 100644
--- a/lib/libdvbv5/descriptors/pat.c
+++ b/lib/libdvbv5/descriptors/pat.c
@@ -23,25 +23,30 @@
 #include "descriptors.h"
 #include "dvb-fe.h"
 
-void *dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size)
+void dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen)
 {
-	struct dvb_table_pat *pat = malloc(size + sizeof(uint16_t));
-	memcpy(pat, buf, sizeof(struct dvb_table_pat) - sizeof(uint16_t));
+	uint8_t *d;
+	struct dvb_table_pat *pat;
+	if (!*buf) {
+		d = malloc(size + sizeof(uint16_t));
+		*buf = d;
+		*buflen = size + sizeof(uint16_t);
+		pat = (struct dvb_table_pat *) d;
+		memcpy(pat, ptr, sizeof(struct dvb_table_pat) - sizeof(uint16_t));
 
-	dvb_table_header_init(&pat->header);
-
-	struct dvb_table_pat_program *p = (struct dvb_table_pat_program *)
-		                          (buf + sizeof(struct dvb_table_pat) - sizeof(uint16_t));
-	int i = 0;
-	while ((uint8_t *) p < buf + size - 4) {
-		memcpy(pat->program + i, p, sizeof(struct dvb_table_pat_program));
-		bswap16(pat->program[i].program_id);
-		bswap16(pat->program[i].bitfield);
-		p++;
-		i++;
+		struct dvb_table_pat_program *p = (struct dvb_table_pat_program *)
+			                          (ptr + sizeof(struct dvb_table_pat) - sizeof(uint16_t));
+		pat->programs = 0;
+		while ((uint8_t *) p < ptr + size - 4) {
+			memcpy(pat->program + pat->programs, p, sizeof(struct dvb_table_pat_program));
+			bswap16(pat->program[pat->programs].program_id);
+			bswap16(pat->program[pat->programs].bitfield);
+			p++;
+			pat->programs++;
+		}
+	} else {
+		dvb_logerr("multisecttion PAT table not implemented");
 	}
-	pat->programs = i;
-	return pat;
 }
 
 void dvb_table_pat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_pat *t)
diff --git a/lib/libdvbv5/descriptors/pmt.c b/lib/libdvbv5/descriptors/pmt.c
index 293a970..9f4300c 100644
--- a/lib/libdvbv5/descriptors/pmt.c
+++ b/lib/libdvbv5/descriptors/pmt.c
@@ -25,53 +25,59 @@
 
 #include <string.h> /* memcpy */
 
-void *dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size)
+void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen)
 {
-	uint8_t *d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 2);
-	const uint8_t *p = buf;
-	struct dvb_table_pmt *pmt = (struct dvb_table_pmt *) d;
+	uint8_t *d;
+	const uint8_t *p = ptr;
+	struct dvb_table_pmt *pmt;
 
-	memcpy(pmt, p, sizeof(struct dvb_table_pmt) - sizeof(pmt->stream));
-	p += sizeof(struct dvb_table_pmt) - sizeof(pmt->stream);
-	d += sizeof(struct dvb_table_pmt);
+	if (!*buf) {
+		d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 2);
+		*buf = d;
+		*buflen = 0;
+		pmt = (struct dvb_table_pmt *) d;
 
-	dvb_table_header_init(&pmt->header);
-	bswap16(pmt->bitfield);
-	bswap16(pmt->bitfield2);
-	pmt->stream = NULL;
+		memcpy(d + *buflen, p, sizeof(struct dvb_table_pmt) - sizeof(pmt->stream));
+		p += sizeof(struct dvb_table_pmt) - sizeof(pmt->stream);
+		*buflen += sizeof(struct dvb_table_pmt);
 
-	/* skip prog section */
-	p += pmt->prog_length;
+		bswap16(pmt->bitfield);
+		bswap16(pmt->bitfield2);
+		pmt->stream = NULL;
 
-	/* get the stream entries */
-	struct dvb_table_pmt_stream *last = NULL;
-	struct dvb_table_pmt_stream **head = &pmt->stream;
-	while (p < buf + size - 4) {
-		struct dvb_table_pmt_stream *stream = (struct dvb_table_pmt_stream *) d;
-		memcpy(d, p, sizeof(struct dvb_table_pmt_stream) - sizeof(stream->descriptor) - sizeof(stream->next));
-		p += sizeof(struct dvb_table_pmt_stream) - sizeof(stream->descriptor) - sizeof(stream->next);
-		d += sizeof(struct dvb_table_pmt_stream);
+		/* skip prog section */
+		p += pmt->prog_length;
 
-		bswap16(stream->bitfield);
-		bswap16(stream->bitfield2);
-		stream->descriptor = NULL;
-		stream->next = NULL;
+		/* get the stream entries */
+		struct dvb_table_pmt_stream *last = NULL;
+		struct dvb_table_pmt_stream **head = &pmt->stream;
+		while (p < ptr + size - 4) {
+			struct dvb_table_pmt_stream *stream = (struct dvb_table_pmt_stream *) (d + *buflen);
+			memcpy(d + *buflen, p, sizeof(struct dvb_table_pmt_stream) - sizeof(stream->descriptor) - sizeof(stream->next));
+			p += sizeof(struct dvb_table_pmt_stream) - sizeof(stream->descriptor) - sizeof(stream->next);
+			*buflen += sizeof(struct dvb_table_pmt_stream);
 
-		if(!*head)
-			*head = stream;
-		if(last)
-			last->next = stream;
+			bswap16(stream->bitfield);
+			bswap16(stream->bitfield2);
+			stream->descriptor = NULL;
+			stream->next = NULL;
 
-		/* get the descriptors for each program */
-		struct dvb_desc **head_desc = &stream->descriptor;
-		d += dvb_parse_descriptors(parms, p, d, stream->section_length, head_desc);
+			if(!*head)
+				*head = stream;
+			if(last)
+				last->next = stream;
 
-		p += stream->section_length;
-		last = stream;
-	}
+			/* get the descriptors for each program */
+			struct dvb_desc **head_desc = &stream->descriptor;
+			*buflen += dvb_parse_descriptors(parms, p, d + *buflen, stream->section_length, head_desc);
+
+			p += stream->section_length;
+			last = stream;
+		}
 
-	// FIXME: realloc
-	return pmt;
+	} else {
+		dvb_logerr("multisecttion PMT table not implemented");
+	}
 }
 
 void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_pmt *pmt)
@@ -89,12 +95,7 @@ void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_p
 	while(stream) {
 		dvb_log("|- %5d    %4d  %s (%d)", stream->elementary_pid, stream->section_length,
 				dvb_descriptors[stream->type].name, stream->type);
-		struct dvb_desc *desc = stream->descriptor;
-		while (desc) {
-			if (dvb_descriptors[desc->type].print)
-				dvb_descriptors[desc->type].print(parms, desc);
-			desc = desc->next;
-		}
+		dvb_print_descriptors(parms, stream->descriptor);
 		stream = stream->next;
 		streams++;
 	}
diff --git a/lib/libdvbv5/descriptors/sdt.c b/lib/libdvbv5/descriptors/sdt.c
index e9d576b..2194703 100644
--- a/lib/libdvbv5/descriptors/sdt.c
+++ b/lib/libdvbv5/descriptors/sdt.c
@@ -22,26 +22,45 @@
 #include "descriptors/sdt.h"
 #include "dvb-fe.h"
 
-void *dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size)
+void dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen)
 {
-	uint8_t *d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 2);
-	const uint8_t *p = buf;
-	struct dvb_table_sdt *sdt = (struct dvb_table_sdt *) d;
+	uint8_t *d;
+	const uint8_t *p = ptr;
+	struct dvb_table_sdt *sdt;
+	struct dvb_table_sdt_service **head;
 
-	memcpy(sdt, p, sizeof(struct dvb_table_sdt) - sizeof(sdt->service));
-	p += sizeof(struct dvb_table_sdt) - sizeof(sdt->service);
-	d += sizeof(struct dvb_table_sdt);
+	if (!*buf) {
+		d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 2);
+		*buf = d;
+		*buflen = 0;
+		sdt = (struct dvb_table_sdt *) d;
+		memcpy(sdt, p, sizeof(struct dvb_table_sdt) - sizeof(sdt->service));
+		*buflen += sizeof(struct dvb_table_sdt);
+
+		sdt->service = NULL;
+		head = &sdt->service;
+
+	} else {
+		// should realloc d
+		d = *buf;
 
-	dvb_table_header_init(&sdt->header);
-	sdt->service = NULL;
+		// find end of curent list
+		sdt = (struct dvb_table_sdt *) d;
+		head = &sdt->service;
+		while (*head != NULL)
+			head = &(*head)->next;
+
+		// read new table
+		sdt = (struct dvb_table_sdt *) p;
+	}
+	p += sizeof(struct dvb_table_sdt) - sizeof(sdt->service);
 
 	struct dvb_table_sdt_service *last = NULL;
-	struct dvb_table_sdt_service **head = &sdt->service;
-	while ((uint8_t *) p < buf + size - 4) {
-		struct dvb_table_sdt_service *service = (struct dvb_table_sdt_service *) d;
-		memcpy(d, p, sizeof(struct dvb_table_sdt_service) - sizeof(service->descriptor) - sizeof(service->next));
+	while ((uint8_t *) p < ptr + size - 4) {
+		struct dvb_table_sdt_service *service = (struct dvb_table_sdt_service *) (d + *buflen);
+		memcpy(d + *buflen, p, sizeof(struct dvb_table_sdt_service) - sizeof(service->descriptor) - sizeof(service->next));
 		p += sizeof(struct dvb_table_sdt_service) - sizeof(service->descriptor) - sizeof(service->next);
-		d += sizeof(struct dvb_table_sdt_service);
+		*buflen += sizeof(struct dvb_table_sdt_service);
 
 		bswap16(service->service_id);
 		bswap16(service->bitfield);
@@ -55,12 +74,11 @@ void *dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssiz
 
 		/* get the descriptors for each program */
 		struct dvb_desc **head_desc = &service->descriptor;
-		d += dvb_parse_descriptors(parms, p, d, service->section_length, head_desc);
+		*buflen += dvb_parse_descriptors(parms, p, d + *buflen, service->section_length, head_desc);
 
 		p += service->section_length;
 		last = service;
 	}
-	return sdt;
 }
 
 void dvb_table_sdt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_sdt *sdt)
@@ -74,12 +92,7 @@ void dvb_table_sdt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_sdt *sd
 		dvb_log("|- %7d", service->service_id);
 		dvb_log("|   EIT_schedule: %d", service->EIT_schedule);
 		dvb_log("|   EIT_present_following: %d", service->EIT_present_following);
-		struct dvb_desc *desc = service->descriptor;
-		while (desc) {
-			if (dvb_descriptors[desc->type].print)
-				dvb_descriptors[desc->type].print(parms, desc);
-			desc = desc->next;
-		}
+		dvb_print_descriptors(parms, service->descriptor);
 		service = service->next;
 		services++;
 	}
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index b9a0946..5b496bb 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -30,6 +30,9 @@
 #include "descriptors.h"
 #include "parse_string.h"
 #include "crc32.h"
+#include "dvb-fe.h"
+#include "dvb-log.h"
+#include "descriptors/header.h"
 
 #include <errno.h>
 #include <fcntl.h>
@@ -111,7 +114,7 @@ static void add_otherpid(struct pid_table *pid_table,
 	pid_table->other_el_pid[i].pid = pid;
 }
 
-static void parse_pmt(struct dvb_v5_descriptors *dvb_desc,
+static void parse_pmt(struct dvb_v5_fe_parms *parms, struct dvb_v5_descriptors *dvb_desc,
 		const unsigned char *buf, int *section_length,
 		int id, int version,
 		struct pid_table *pid_table)
@@ -130,7 +133,7 @@ static void parse_pmt(struct dvb_v5_descriptors *dvb_desc,
 				pmt_table->program_number, pmt_table->version,
 				pmt_table->pcr_pid, len);
 
-	parse_descriptor(PMT, dvb_desc, &buf[4], len);
+	parse_descriptor(parms, PMT, dvb_desc, &buf[4], len);
 
 	buf += 4 + len;
 	*section_length -= 4 + len;
@@ -170,14 +173,14 @@ static void parse_pmt(struct dvb_v5_descriptors *dvb_desc,
 				break;
 		};
 
-		parse_descriptor(PMT, dvb_desc, &buf[5], len);
+		parse_descriptor(parms, PMT, dvb_desc, &buf[5], len);
 		buf += len + 5;
 		*section_length -= len + 5;
 		dvb_desc->cur_pmt++;
 	};
 }
 
-static void parse_nit(struct dvb_v5_descriptors *dvb_desc,
+static void parse_nit(struct dvb_v5_fe_parms *parms, struct dvb_v5_descriptors *dvb_desc,
 		const unsigned char *buf, int *section_length,
 		int id, int version)
 {
@@ -194,7 +197,7 @@ static void parse_nit(struct dvb_v5_descriptors *dvb_desc,
 		return;
 	}
 
-	parse_descriptor(NIT, dvb_desc, &buf[2], len);
+	parse_descriptor(parms, NIT, dvb_desc, &buf[2], len);
 
 	*section_length -= len + 4;
 	buf += len + 4;
@@ -217,7 +220,7 @@ static void parse_nit(struct dvb_v5_descriptors *dvb_desc,
 				printf("Transport stream #%d ID 0x%04x, len %d\n",
 						n, nit_table->tr_table[n].tr_id, len);
 
-			parse_descriptor(NIT, dvb_desc, &buf[6], len);
+			parse_descriptor(parms, NIT, dvb_desc, &buf[6], len);
 		}
 
 		n++;
@@ -228,7 +231,7 @@ static void parse_nit(struct dvb_v5_descriptors *dvb_desc,
 	nit_table->tr_table_len = n;
 }
 
-static void parse_sdt(struct dvb_v5_descriptors *dvb_desc,
+static void parse_sdt(struct dvb_v5_fe_parms *parms, struct dvb_v5_descriptors *dvb_desc,
 		const unsigned char *buf, int *section_length,
 		int id, int version)
 {
@@ -263,7 +266,7 @@ static void parse_sdt(struct dvb_v5_descriptors *dvb_desc,
 						sdt_table->service_table[n].running,
 						sdt_table->service_table[n].scrambled);
 
-			parse_descriptor(SDT, dvb_desc, &buf[5], len);
+			parse_descriptor(parms, SDT, dvb_desc, &buf[5], len);
 		}
 
 		n++;
@@ -274,19 +277,6 @@ static void parse_sdt(struct dvb_v5_descriptors *dvb_desc,
 	sdt_table->service_table_len = n;
 }
 
-static void hexdump(const unsigned char *buf, int len)
-{
-	int i;
-
-	printf("size %d", len);
-	for (i = 0; i < len; i++) {
-		if (!(i % 16))
-			printf("\n\t");
-		printf("%02x ", (uint8_t) *(buf + i));
-	}
-	printf("\n");
-}
-
 static int poll(int filedes, unsigned int seconds)
 {
 	fd_set set;
@@ -313,9 +303,12 @@ int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char ta
 		unsigned *length, unsigned timeout)
 {
 	int available;
-	ssize_t count = 0;
+	ssize_t count;
 	struct dmx_sct_filter_params f;
-	uint8_t *tmp;
+	uint8_t *tmp = NULL;
+	uint64_t sections_read = 0;
+	uint64_t sections_total = 0;
+	ssize_t table_length = 0;
 
 	// FIXME: verify known table
 	*buf = NULL;
@@ -327,41 +320,71 @@ int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char ta
 	f.timeout = 0;
 	f.flags = DMX_IMMEDIATE_START | DMX_CHECK_CRC;
 	if (ioctl(dmx_fd, DMX_SET_FILTER, &f) == -1) {
-		perror("ioctl DMX_SET_FILTER failed");
+		dvb_perror("dvb_read_section: ioctl DMX_SET_FILTER failed");
 		return -1;
 	}
 
 	do {
-		available = poll(dmx_fd, timeout);
-		if (available > 0) {
-			tmp = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE);
-			count = read(dmx_fd, tmp,
-					DVB_MAX_PAYLOAD_PACKET_SIZE);
+		count = 0;
+		do {
+			available = poll(dmx_fd, timeout);
+		} while (available < 0 && errno == EOVERFLOW);
+		if (available <= 0) {
+			dvb_logerr("dvb_read_section: no data read" );
+			return -1;
+		}
+		tmp = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE);
+		count = read(dmx_fd, tmp, DVB_MAX_PAYLOAD_PACKET_SIZE);
+		if (!count) {
+			dvb_logerr("dvb_read_section: no data read" );
+			free(tmp);
+			return -1;
+		}
+		if (count < 0) {
+			dvb_perror("dvb_read_section: read error");
+			free(tmp);
+			return -2;
 		}
-	} while (available < 0 && errno == EOVERFLOW);
-	if (!count) {
-		printf("no data read\n" );
-		return -1;
-	}
-	if (count < 0) {
-		perror("read_sections: read error");
-		return -2;
-	}
 
-	uint32_t crc = crc32(tmp, count, 0xFFFFFFFF);
-	if (crc != 0) {
-		printf("crc error\n");
-		return -3;
-	}
+		uint32_t crc = crc32(tmp, count, 0xFFFFFFFF);
+		if (crc != 0) {
+			dvb_logerr("dvb_read_section: crc error");
+			free(tmp);
+			return -3;
+		}
+
+		//ARRAY_SIZE(vb_table_initializers) >= table
+
+		struct dvb_table_header *h = (struct dvb_table_header *) tmp;
+		dvb_table_header_init(h);
+		/*dvb_log("dvb_read_section: got section %d/%d", h->section_id + 1, h->last_section + 1);*/
+		if (!sections_total) {
+			if (h->last_section + 1 > 32) {
+				dvb_logerr("dvb_read_section: cannot read more than 32 sections, %d requested", h->last_section);
+				h->last_section = 31;
+			}
+			sections_total = (1 << (h->last_section + 1)) - 1;
+		}
+		if (sections_read & (1 << h->section_id)) {
+			dvb_logwarn("dvb_read_section: section %d already read", h->section_id);
+		}
+		sections_read  |= 1 << h->section_id;
+		/*if (sections_read != sections_total)*/
+			/*dvb_logwarn("dvb_read_section: sections are missing: %d != %d", sections_read, sections_total);*/
+
+		dvb_table_initializers[table].init(parms, tmp, count, buf, &table_length);
+
+		free(tmp);
+		tmp = NULL;
+	} while(sections_read != sections_total);
+	// FIXME: log incomplete sections
 
-	//ARRAY_SIZE(vb_table_initializers) >= table
-	*buf = dvb_table_initializers[table].init(parms, tmp, count);
 	if (length)
-		*length = count;
+		*length = table_length;
 	return 0;
 }
 
-static int read_section(int dmx_fd, struct dvb_v5_descriptors *dvb_desc,
+static int read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, struct dvb_v5_descriptors *dvb_desc,
 		uint16_t pid, unsigned char table, void *ptr,
 		unsigned timeout)
 {
@@ -414,7 +437,7 @@ static int read_section(int dmx_fd, struct dvb_v5_descriptors *dvb_desc,
 		if (dvb_desc->verbose) {
 			printf("PID 0x%04x, TableID 0x%02x ID=0x%04x, version %d, ",
 					pid, table_id, id, version);
-			hexdump(buf, count);
+			hexdump(parms, "", buf, count);
 			printf("\tsection_length = %d ", section_length);
 			printf("section %d, last section %d\n", buf[6], buf[7]);
 		}
@@ -428,17 +451,17 @@ static int read_section(int dmx_fd, struct dvb_v5_descriptors *dvb_desc,
 						id, version);
 				break;
 			case 0x02:	/* PMT */
-				parse_pmt(dvb_desc, p, &section_length,
+				parse_pmt(parms, dvb_desc, p, &section_length,
 						id, version, ptr);
 				break;
 			case 0x40:	/* NIT */
 			case 0x41:	/* NIT other */
-				parse_nit(dvb_desc, p, &section_length,
+				parse_nit(parms, dvb_desc, p, &section_length,
 						id, version);
 				break;
-			case 0x42:	/* SAT */
-			case 0x46:	/* SAT other */
-				parse_sdt(dvb_desc, p, &section_length,
+			case 0x42:	/* SDT */
+			case 0x46:	/* SDT other */
+				parse_sdt(parms, dvb_desc, p, &section_length,
 						id, version);
 				break;
 		}
@@ -447,7 +470,7 @@ static int read_section(int dmx_fd, struct dvb_v5_descriptors *dvb_desc,
 	return 0;
 }
 
-struct dvb_v5_descriptors *dvb_get_ts_tables(int dmx_fd,
+struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms, int dmx_fd,
 		uint32_t delivery_system,
 		unsigned other_nit,
 		unsigned timeout_multiply,
@@ -504,7 +527,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(int dmx_fd,
 	};
 
 	/* PAT table */
-	rc = read_section(dmx_fd, dvb_desc, 0, 0, NULL,
+	rc = read_section(parms, dmx_fd, dvb_desc, 0, 0, NULL,
 			pat_pmt_time * timeout_multiply);
 	if (rc < 0) {
 		fprintf(stderr, "error while waiting for PAT table\n");
@@ -519,7 +542,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(int dmx_fd,
 		/* Skip PAT, CAT, reserved and NULL packets */
 		if (!pn)
 			continue;
-		rc = read_section(dmx_fd, dvb_desc, pid_table->pid, 0x02,
+		rc = read_section(parms, dmx_fd, dvb_desc, pid_table->pid, 0x02,
 				pid_table, pat_pmt_time * timeout_multiply);
 		if (rc < 0)
 			fprintf(stderr, "error while reading the PMT table for service 0x%04x\n",
@@ -527,13 +550,13 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(int dmx_fd,
 	}
 
 	/* NIT table */
-	rc = read_section(dmx_fd, dvb_desc, 0x0010, 0x40, NULL,
+	rc = read_section(parms, dmx_fd, dvb_desc, 0x0010, 0x40, NULL,
 			nit_time * timeout_multiply);
 	if (rc < 0)
 		fprintf(stderr, "error while reading the NIT table\n");
 
 	/* SDT table */
-	rc = read_section(dmx_fd, dvb_desc, 0x0011, 0x42, NULL,
+	rc = read_section(parms, dmx_fd, dvb_desc, 0x0011, 0x42, NULL,
 			sdt_time * timeout_multiply);
 	if (rc < 0)
 		fprintf(stderr, "error while reading the SDT table\n");
@@ -542,9 +565,9 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(int dmx_fd,
 	if (other_nit) {
 		if (verbose)
 			printf("Parsing other NIT/SDT\n");
-		rc = read_section(dmx_fd, dvb_desc, 0x0010, 0x41, NULL,
+		rc = read_section(parms, dmx_fd, dvb_desc, 0x0010, 0x41, NULL,
 				nit_time * timeout_multiply);
-		rc = read_section(dmx_fd, dvb_desc, 0x0011, 0x46, NULL,
+		rc = read_section(parms, dmx_fd, dvb_desc, 0x0011, 0x46, NULL,
 				sdt_time * timeout_multiply);
 	}
 
diff --git a/lib/libdvbv5/parse_string.c b/lib/libdvbv5/parse_string.c
index fc8d5f3..21368b6 100644
--- a/lib/libdvbv5/parse_string.c
+++ b/lib/libdvbv5/parse_string.c
@@ -29,6 +29,8 @@
 #include <string.h>
 
 #include "parse_string.h"
+#include "dvb-log.h"
+#include "dvb-fe.h"
 
 #define CS_OPTIONS "//TRANSLIT"
 
@@ -297,7 +299,7 @@ static struct charset_conv en300468_latin_00_to_utf8[256] = {
 	[0xff] = { 2, {0xc2, 0xad, } },
 };
 
-static void charset_conversion(char **dest, const unsigned char *s,
+static void charset_conversion(struct dvb_v5_fe_parms *parms, char **dest, const unsigned char *s,
 			       size_t len,
 			       char *type, char *output_charset)
 {
@@ -342,7 +344,7 @@ static void charset_conversion(char **dest, const unsigned char *s,
 		if (cd == (iconv_t)(-1)) {
 			memcpy(p, s, len);
 			p[len] = '\0';
-			fprintf(stderr, "Conversion from %s to %s not supported\n",
+			dvb_logerr("Conversion from %s to %s not supported\n",
 				 type, output_charset);
 		} else {
 			iconv(cd, (ICONV_CONST char **)&s, &len, &p, &destlen);
@@ -352,7 +354,7 @@ static void charset_conversion(char **dest, const unsigned char *s,
 	}
 }
 
-void parse_string(char **dest, char **emph,
+void parse_string(struct dvb_v5_fe_parms *parms, char **dest, char **emph,
 		  const unsigned char *src, size_t len,
 		  char *default_charset, char *output_charset)
 {
@@ -392,6 +394,8 @@ void parse_string(char **dest, char **emph,
 		case 0x14:	type = "BIG5";			break;
 		case 0x15:	type = "ISO-10646/UTF-8";	break;
 		case 0x10: /* ISO8859 */
+			if (len < 2)
+				break;
 			if ((*(src + 1) != 0) || *(src + 2) > 0x0f)
 				break;
 			src+=2;
@@ -452,6 +456,7 @@ void parse_string(char **dest, char **emph,
 		len = p - (char *)tmp1;
 		len2 = p2 - (char *)tmp2;
 	} else {
+		dvb_logerr("charset %s not implemented", type);
 		/*
 		 * FIXME: need to handle the ISO/IEC 10646 2-byte control codes
 		 * (EN 300 468 v1.11.1 Table A.2)
@@ -463,7 +468,7 @@ void parse_string(char **dest, char **emph,
 	else
 		s = src;
 
-	charset_conversion(dest, s, len, type, output_charset);
+	charset_conversion(parms, dest, s, len, type, output_charset);
 	/* The code had over-sized the space. Fix it. */
 	if (*dest)
 		*dest = realloc(*dest, strlen(*dest) + 1);
@@ -473,10 +478,11 @@ void parse_string(char **dest, char **emph,
 		free (*emph);
 		*emph = NULL;
 	} else {
-		charset_conversion(emph, tmp2, len2, type, output_charset);
+		charset_conversion(parms, emph, tmp2, len2, type, output_charset);
 		*emph = realloc(*emph, strlen(*emph) + 1);
 	}
 
 	if (tmp1)
 		free(tmp1);
 }
+
diff --git a/lib/libdvbv5/parse_string.h b/lib/libdvbv5/parse_string.h
index ca30a23..15dd5ce 100644
--- a/lib/libdvbv5/parse_string.h
+++ b/lib/libdvbv5/parse_string.h
@@ -17,6 +17,8 @@
  * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
  */
 
-void parse_string(char **dest, char **emph,
+struct dvb_v5_fe_parms;
+
+void parse_string(struct dvb_v5_fe_parms *parms, char **dest, char **emph,
 		  const unsigned char *src, size_t len,
 		  char *default_charset, char *output_charset);
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index 33032a9..937b9dd 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -412,7 +412,7 @@ static int run_scan(struct arguments *args,
 		if (rc < 0)
 			continue;
 
-		dvb_desc = dvb_get_ts_tables(dmx_fd,
+		dvb_desc = dvb_get_ts_tables(parms, dmx_fd,
 					     parms->current_sys,
 					     args->other_nit,
 					     args->timeout_multiply,
-- 
1.7.2.5

