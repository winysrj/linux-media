Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57612 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaIMUJA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Sep 2014 16:09:00 -0400
Received: by mail-wi0-f176.google.com with SMTP id ex7so2280577wid.15
        for <linux-media@vger.kernel.org>; Sat, 13 Sep 2014 13:08:58 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 1/2] libdvbv5: cleanup logging, some memory checks
Date: Sat, 13 Sep 2014 22:08:27 +0200
Message-Id: <1410638908-24637-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- use loginfo in hexdump
- use C comments
- memory checking in desc_sat and desc_service

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/desc_service_list.h |  3 +-
 lib/libdvbv5/descriptors.c               |  2 +-
 lib/libdvbv5/descriptors/desc_sat.c      | 12 +++++---
 lib/libdvbv5/descriptors/desc_service.c  | 50 ++++++++++++++++++++++++++------
 4 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/lib/include/libdvbv5/desc_service_list.h b/lib/include/libdvbv5/desc_service_list.h
index e08ea3c..1773ebd 100644
--- a/lib/include/libdvbv5/desc_service_list.h
+++ b/lib/include/libdvbv5/desc_service_list.h
@@ -34,7 +34,8 @@ struct dvb_desc_service_list {
 	uint8_t length;
 	struct dvb_desc *next;
 
-	//struct dvb_desc_service_list_table services[];
+	/* FIXME */
+	/* struct dvb_desc_service_list_table services[]; */
 } __attribute__((packed));
 
 struct dvb_v5_fe_parms;
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index eaee148..63ce939 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -1345,7 +1345,7 @@ void dvb_hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsign
 			strncat(hex, " ", sizeof(hex) - 1);
 		if (j == 16) {
 			ascii[j] = '\0';
-			dvb_log("%s%s  %s", prefix, hex, ascii);
+			dvb_loginfo("%s%s  %s", prefix, hex, ascii);
 			j = 0;
 			hex[0] = '\0';
 		}
diff --git a/lib/libdvbv5/descriptors/desc_sat.c b/lib/libdvbv5/descriptors/desc_sat.c
index 326f534..7268239 100644
--- a/lib/libdvbv5/descriptors/desc_sat.c
+++ b/lib/libdvbv5/descriptors/desc_sat.c
@@ -25,10 +25,14 @@
 int dvb_desc_sat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_sat *sat = (struct dvb_desc_sat *) desc;
-	/* copy from .length */
-	memcpy(((uint8_t *) sat ) + sizeof(sat->type) + sizeof(sat->next) + sizeof(sat->length),
-		buf,
-		sat->length);
+	ssize_t size = sizeof(struct dvb_desc_sat) - sizeof(struct dvb_desc);
+
+	if (size > desc->length) {
+		dvb_logerr("dvb_desc_sat_init short read %d/%zd bytes", desc->length, size);
+		return -1;
+	}
+
+	memcpy(desc->data, buf, size);
 	bswap16(sat->orbit);
 	bswap32(sat->bitfield);
 	bswap32(sat->frequency);
diff --git a/lib/libdvbv5/descriptors/desc_service.c b/lib/libdvbv5/descriptors/desc_service.c
index 01ab33e..8db681a 100644
--- a/lib/libdvbv5/descriptors/desc_service.c
+++ b/lib/libdvbv5/descriptors/desc_service.c
@@ -26,27 +26,59 @@
 int dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_service *service = (struct dvb_desc_service *) desc;
+	const uint8_t *endbuf = buf + desc->length;
 	uint8_t len;        /* the length of the string in the input data */
 	uint8_t len1, len2; /* the lenght of the output strings */
 
+	service->provider = NULL;
+	service->provider_emph = NULL;
+	service->name = NULL;
+	service->name_emph = NULL;
+
+	if (buf + 1 > endbuf) {
+		dvb_logerr("%s: short read %d bytes", __func__, 1);
+		return -1;
+	}
 	service->service_type = buf[0];
 	buf++;
 
-	service->provider = NULL;
-	service->provider_emph = NULL;
+	if (buf + 1 > endbuf) {
+		dvb_logerr("%s: a short read %d bytes", __func__, 1);
+		return -1;
+	}
+
 	len = buf[0];
-	buf++;
 	len1 = len;
-	dvb_parse_string(parms, &service->provider, &service->provider_emph, buf, len1);
-	buf += len;
+	buf++;
+
+	if (buf + len > endbuf) {
+		dvb_logerr("%s: b short read %d bytes", __func__, len);
+		return -1;
+	}
+
+	if (len) {
+		dvb_parse_string(parms, &service->provider, &service->provider_emph, buf, len1);
+		buf += len;
+	}
+
+	if (buf + 1 > endbuf) {
+		dvb_logerr("%s: c short read %d bytes", __func__, 1);
+		return -1;
+	}
 
-	service->name = NULL;
-	service->name_emph = NULL;
 	len = buf[0];
 	len2 = len;
 	buf++;
-	dvb_parse_string(parms, &service->name, &service->name_emph, buf, len2);
-	buf += len;
+
+	if (buf + len > endbuf) {
+		dvb_logerr("%s: d short read %d bytes", __func__, len);
+		return -1;
+	}
+
+	if (len) {
+		dvb_parse_string(parms, &service->name, &service->name_emph, buf, len2);
+		buf += len;
+	}
 	return 0;
 }
 
-- 
1.9.1

