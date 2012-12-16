Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59216 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2LPSXb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 13:23:31 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so2824295eek.19
        for <linux-media@vger.kernel.org>; Sun, 16 Dec 2012 10:23:30 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 1/5] em28xx: clean up the data type mess of the i2c transfer function parameters
Date: Sun, 16 Dec 2012 19:23:27 +0100
Message-Id: <1355682211-13604-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1355682211-13604-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1355682211-13604-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |   28 +++++++++++-----------------
 1 Datei geändert, 11 Zeilen hinzugefügt(+), 17 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 1683bd9..44533e4 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -53,12 +53,11 @@ do {							\
  * em2800_i2c_send_max4()
  * send up to 4 bytes to the i2c device
  */
-static int em2800_i2c_send_max4(struct em28xx *dev, unsigned char addr,
-				char *buf, int len)
+static int em2800_i2c_send_max4(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 {
 	int ret;
 	int write_timeout;
-	unsigned char b2[6];
+	u8 b2[6];
 	BUG_ON(len < 1 || len > 4);
 	b2[5] = 0x80 + len - 1;
 	b2[4] = addr;
@@ -89,15 +88,13 @@ static int em2800_i2c_send_max4(struct em28xx *dev, unsigned char addr,
 /*
  * em2800_i2c_send_bytes()
  */
-static int em2800_i2c_send_bytes(void *data, unsigned char addr, char *buf,
-				 short len)
+static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 {
-	char *bufPtr = buf;
+	u8 *bufPtr = buf;
 	int ret;
 	int wrcount = 0;
 	int count;
 	int maxLen = 4;
-	struct em28xx *dev = (struct em28xx *)data;
 	while (len > 0) {
 		count = (len > maxLen) ? maxLen : len;
 		ret = em2800_i2c_send_max4(dev, addr, bufPtr, count);
@@ -115,9 +112,9 @@ static int em2800_i2c_send_bytes(void *data, unsigned char addr, char *buf,
  * em2800_i2c_check_for_device()
  * check if there is a i2c_device at the supplied address
  */
-static int em2800_i2c_check_for_device(struct em28xx *dev, unsigned char addr)
+static int em2800_i2c_check_for_device(struct em28xx *dev, u8 addr)
 {
-	char msg;
+	u8 msg;
 	int ret;
 	int write_timeout;
 	msg = addr;
@@ -150,8 +147,7 @@ static int em2800_i2c_check_for_device(struct em28xx *dev, unsigned char addr)
  * em2800_i2c_recv_bytes()
  * read from the i2c device
  */
-static int em2800_i2c_recv_bytes(struct em28xx *dev, unsigned char addr,
-				 char *buf, int len)
+static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 {
 	int ret;
 	/* check for the device and set i2c read address */
@@ -174,11 +170,10 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, unsigned char addr,
 /*
  * em28xx_i2c_send_bytes()
  */
-static int em28xx_i2c_send_bytes(void *data, unsigned char addr, char *buf,
-				 short len, int stop)
+static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
+				 u16 len, int stop)
 {
 	int wrcount = 0;
-	struct em28xx *dev = (struct em28xx *)data;
 	int write_timeout, ret;
 
 	wrcount = dev->em28xx_write_regs_req(dev, stop ? 2 : 3, addr, buf, len);
@@ -199,8 +194,7 @@ static int em28xx_i2c_send_bytes(void *data, unsigned char addr, char *buf,
  * em28xx_i2c_recv_bytes()
  * read a byte from the i2c device
  */
-static int em28xx_i2c_recv_bytes(struct em28xx *dev, unsigned char addr,
-				 char *buf, int len)
+static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 {
 	int ret;
 	ret = dev->em28xx_read_reg_req_len(dev, 2, addr, buf, len);
@@ -217,7 +211,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, unsigned char addr,
  * em28xx_i2c_check_for_device()
  * check if there is a i2c_device at the supplied address
  */
-static int em28xx_i2c_check_for_device(struct em28xx *dev, unsigned char addr)
+static int em28xx_i2c_check_for_device(struct em28xx *dev, u16 addr)
 {
 	int ret;
 
-- 
1.7.10.4

