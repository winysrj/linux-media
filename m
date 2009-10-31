Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:52765 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375AbZJaXQK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:16:10 -0400
Message-ID: <4AECC538.3010605@freemail.hu>
Date: Sun, 01 Nov 2009 00:16:08 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 15/21] gspca pac7302/pac7311: simplify pac_find_sof
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Remove struct sd dependency from pac_find_sof() function implementation,
This step prepares separation of pac7302 and pac7311 specific parts of
struct sd.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN o/drivers/media/video/gspca/mr97310a.c p/drivers/media/video/gspca/mr97310a.c
--- o/drivers/media/video/gspca/mr97310a.c	2009-10-31 08:11:38.000000000 +0100
+++ p/drivers/media/video/gspca/mr97310a.c	2009-10-31 08:20:00.000000000 +0100
@@ -957,9 +957,10 @@ static void sd_pkt_scan(struct gspca_dev
 			__u8 *data,                   /* isoc packet */
 			int len)                      /* iso packet length */
 {
+	struct sd *sd = (struct sd *) gspca_dev;
 	unsigned char *sof;

-	sof = pac_find_sof(gspca_dev, data, len);
+	sof = pac_find_sof(&sd->sof_read, data, len);
 	if (sof) {
 		int n;

diff -uprN o/drivers/media/video/gspca/pac207.c p/drivers/media/video/gspca/pac207.c
--- o/drivers/media/video/gspca/pac207.c	2009-10-23 07:07:59.000000000 +0200
+++ p/drivers/media/video/gspca/pac207.c	2009-10-31 08:18:59.000000000 +0100
@@ -344,7 +344,7 @@ static void sd_pkt_scan(struct gspca_dev
 	struct sd *sd = (struct sd *) gspca_dev;
 	unsigned char *sof;

-	sof = pac_find_sof(gspca_dev, data, len);
+	sof = pac_find_sof(&sd->sof_read, data, len);
 	if (sof) {
 		int n;

diff -uprN o/drivers/media/video/gspca/pac7311.c p/drivers/media/video/gspca/pac7311.c
--- o/drivers/media/video/gspca/pac7311.c	2009-10-31 07:45:27.000000000 +0100
+++ p/drivers/media/video/gspca/pac7311.c	2009-10-31 08:22:45.000000000 +0100
@@ -1035,7 +1035,7 @@ static void pac7302_sd_pkt_scan(struct g
 	struct sd *sd = (struct sd *) gspca_dev;
 	unsigned char *sof;

-	sof = pac_find_sof(gspca_dev, data, len);
+	sof = pac_find_sof(&sd->sof_read, data, len);
 	if (sof) {
 		unsigned char tmpbuf[4];
 		int n, lum_offset, footer_length;
@@ -1099,7 +1099,7 @@ static void pac7311_sd_pkt_scan(struct g
 	struct sd *sd = (struct sd *) gspca_dev;
 	unsigned char *sof;

-	sof = pac_find_sof(gspca_dev, data, len);
+	sof = pac_find_sof(&sd->sof_read, data, len);
 	if (sof) {
 		unsigned char tmpbuf[4];
 		int n, lum_offset, footer_length;
diff -uprN o/drivers/media/video/gspca/pac_common.h p/drivers/media/video/gspca/pac_common.h
--- o/drivers/media/video/gspca/pac_common.h	2009-10-30 16:12:05.000000000 +0100
+++ p/drivers/media/video/gspca/pac_common.h	2009-10-31 08:17:38.000000000 +0100
@@ -72,42 +72,41 @@ static const unsigned char pac_sof_marke
 	   +----------+
 */

-static unsigned char *pac_find_sof(struct gspca_dev *gspca_dev,
+static unsigned char *pac_find_sof(u8 *sof_read,
 					unsigned char *m, int len)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
 	int i;

 	/* Search for the SOF marker (fixed part) in the header */
 	for (i = 0; i < len; i++) {
-		switch (sd->sof_read) {
+		switch (*sof_read) {
 		case 0:
 			if (m[i] == 0xff)
-				sd->sof_read = 1;
+				*sof_read = 1;
 			break;
 		case 1:
 			if (m[i] == 0xff)
-				sd->sof_read = 2;
+				*sof_read = 2;
 			else
-				sd->sof_read = 0;
+				*sof_read = 0;
 			break;
 		case 2:
 			switch (m[i]) {
 			case 0x00:
-				sd->sof_read = 3;
+				*sof_read = 3;
 				break;
 			case 0xff:
 				/* stay in this state */
 				break;
 			default:
-				sd->sof_read = 0;
+				*sof_read = 0;
 			}
 			break;
 		case 3:
 			if (m[i] == 0xff)
-				sd->sof_read = 4;
+				*sof_read = 4;
 			else
-				sd->sof_read = 0;
+				*sof_read = 0;
 			break;
 		case 4:
 			switch (m[i]) {
@@ -117,18 +116,18 @@ static unsigned char *pac_find_sof(struc
 					"SOF found, bytes to analyze: %u."
 					" Frame starts at byte #%u",
 					len, i + 1);
-				sd->sof_read = 0;
+				*sof_read = 0;
 				return m + i + 1;
 				break;
 			case 0xff:
-				sd->sof_read = 2;
+				*sof_read = 2;
 				break;
 			default:
-				sd->sof_read = 0;
+				*sof_read = 0;
 			}
 			break;
 		default:
-			sd->sof_read = 0;
+			*sof_read = 0;
 		}
 	}

