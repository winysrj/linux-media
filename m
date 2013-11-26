Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:51741 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3KZOPa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 09:15:30 -0500
Received: by mail-ie0-f177.google.com with SMTP id tp5so9255659ieb.36
        for <linux-media@vger.kernel.org>; Tue, 26 Nov 2013 06:15:29 -0800 (PST)
From: Mauro Dreissig <mukadr@gmail.com>
To: linux-media@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
	Mauro Dreissig <mukadr@gmail.com>
Subject: [PATCH 1/2] staging: as102: Declare local variables as static
Date: Tue, 26 Nov 2013 09:15:20 -0500
Message-Id: <1385475321-4245-2-git-send-email-mukadr@gmail.com>
In-Reply-To: <1385475321-4245-1-git-send-email-mukadr@gmail.com>
References: <1385475321-4245-1-git-send-email-mukadr@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As pointed out by sparse:

drivers/staging/media/as102/as102_fw.c:29:6: warning: symbol 'as102_st_fw1' was not declared. Should it be static?
drivers/staging/media/as102/as102_fw.c:30:6: warning: symbol 'as102_st_fw2' was not declared. Should it be static?
drivers/staging/media/as102/as102_fw.c:31:6: warning: symbol 'as102_dt_fw1' was not declared. Should it be static?
drivers/staging/media/as102/as102_fw.c:32:6: warning: symbol 'as102_dt_fw2' was not declared. Should it be static?
drivers/staging/media/as102/as102_usb_drv.c:194:25: warning: symbol 'as102_priv_ops' was not declared. Should it be static?

Also use the const qualifier on the firmware name strings.

Signed-off-by: Mauro Dreissig <mukadr@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/as102/as102_fw.c      | 10 +++++-----
 drivers/staging/media/as102/as102_usb_drv.c |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/as102/as102_fw.c b/drivers/staging/media/as102/as102_fw.c
index b9670ee..9e7c6d7 100644
--- a/drivers/staging/media/as102/as102_fw.c
+++ b/drivers/staging/media/as102/as102_fw.c
@@ -26,10 +26,10 @@
 #include "as102_drv.h"
 #include "as102_fw.h"
 
-char as102_st_fw1[] = "as102_data1_st.hex";
-char as102_st_fw2[] = "as102_data2_st.hex";
-char as102_dt_fw1[] = "as102_data1_dt.hex";
-char as102_dt_fw2[] = "as102_data2_dt.hex";
+static const char as102_st_fw1[] = "as102_data1_st.hex";
+static const char as102_st_fw2[] = "as102_data2_st.hex";
+static const char as102_dt_fw1[] = "as102_data1_dt.hex";
+static const char as102_dt_fw2[] = "as102_data2_dt.hex";
 
 static unsigned char atohx(unsigned char *dst, char *src)
 {
@@ -167,7 +167,7 @@ int as102_fw_upload(struct as10x_bus_adapter_t *bus_adap)
 	int errno = -EFAULT;
 	const struct firmware *firmware = NULL;
 	unsigned char *cmd_buf = NULL;
-	char *fw1, *fw2;
+	const char *fw1, *fw2;
 	struct usb_device *dev = bus_adap->usb_dev;
 
 	ENTER();
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index 9f275f0..0eaced3 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -191,7 +191,7 @@ static int as102_read_ep2(struct as10x_bus_adapter_t *bus_adap,
 	return ret ? ret : actual_len;
 }
 
-struct as102_priv_ops_t as102_priv_ops = {
+static struct as102_priv_ops_t as102_priv_ops = {
 	.upload_fw_pkt	= as102_send_ep1,
 	.xfer_cmd	= as102_usb_xfer_cmd,
 	.as102_read_ep2	= as102_read_ep2,
-- 
1.8.5.rc3

