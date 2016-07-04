Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:62794 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbcGDNTZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 09:19:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Leandro Costantino <lcostantino@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] gspca: avoid unused variable warnings
Date: Mon,  4 Jul 2016 15:21:40 +0200
Message-Id: <20160704132212.1166461-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_INPUT is disabled, multiple gspca backend drivers
print compile-time warnings about unused variables:

media/usb/gspca/cpia1.c: In function 'sd_stopN':
media/usb/gspca/cpia1.c:1627:13: error: unused variable 'sd' [-Werror=unused-variable]
media/usb/gspca/konica.c: In function 'sd_stopN':
media/usb/gspca/konica.c:246:13: error: unused variable 'sd' [-Werror=unused-variable]

This annotates the variables as __maybe_unused, to let the compiler
know that they are declared intentionally.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: ee186fd96a5f ("[media] gscpa_t613: Add support for the camera button")
Fixes: c2f644aeeba3 ("[media] gspca_cpia1: Add support for button")
Fixes: b517af722860 ("V4L/DVB: gspca_konica: New gspca subdriver for konica chipset using cams")
---
This is one of two approaches to avoid the warning, please pick either
this or the other one.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/gspca/cpia1.c  | 2 +-
 drivers/media/usb/gspca/konica.c | 2 +-
 drivers/media/usb/gspca/t613.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/gspca/cpia1.c b/drivers/media/usb/gspca/cpia1.c
index f23df4a9d8c5..52b88e9e656b 100644
--- a/drivers/media/usb/gspca/cpia1.c
+++ b/drivers/media/usb/gspca/cpia1.c
@@ -1624,7 +1624,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 static void sd_stopN(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct sd *sd __maybe_unused = (struct sd *) gspca_dev;
 
 	command_pause(gspca_dev);
 
diff --git a/drivers/media/usb/gspca/konica.c b/drivers/media/usb/gspca/konica.c
index 39c96bb4c985..0712b1bc90b4 100644
--- a/drivers/media/usb/gspca/konica.c
+++ b/drivers/media/usb/gspca/konica.c
@@ -243,7 +243,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 static void sd_stopN(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct sd *sd __maybe_unused = (struct sd *) gspca_dev;
 
 	konica_stream_off(gspca_dev);
 #if IS_ENABLED(CONFIG_INPUT)
diff --git a/drivers/media/usb/gspca/t613.c b/drivers/media/usb/gspca/t613.c
index e2cc4e5a0ccb..bb52fc1fe598 100644
--- a/drivers/media/usb/gspca/t613.c
+++ b/drivers/media/usb/gspca/t613.c
@@ -837,7 +837,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 			u8 *data,			/* isoc packet */
 			int len)			/* iso packet length */
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct sd *sd __maybe_unused = (struct sd *) gspca_dev;
 	int pkt_type;
 
 	if (data[0] == 0x5a) {
-- 
2.9.0

