Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56998 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab3ADS3d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 13:29:33 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Fabio Estevam <festevam@gmail.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC] dvb_usb_v2: use IS_ENABLED() macro
Date: Fri,  4 Jan 2013 20:28:30 +0200
Message-Id: <1357324110-19607-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

replace:
 #if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
with:
 #if IS_ENABLED(CONFIG_RC_CORE)

Reported-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c       | 2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c       | 2 +-
 drivers/media/usb/dvb-usb-v2/anysee.c       | 2 +-
 drivers/media/usb/dvb-usb-v2/az6007.c       | 2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 2 +-
 drivers/media/usb/dvb-usb-v2/it913x.c       | 2 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c     | 4 ++--
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 51505d1..b86d0f2 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -1156,7 +1156,7 @@ error:
 	return ret;
 }
 
-#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
+#if IS_ENABLED(CONFIG_RC_CORE)
 struct af9015_rc_setup {
 	unsigned int id;
 	char *rc_codes;
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index ae5708b..19e4621 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -971,7 +971,7 @@ err:
 	return ret;
 }
 
-#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
+#if IS_ENABLED(CONFIG_RC_CORE)
 static int af9035_rc_query(struct dvb_usb_device *d)
 {
 	unsigned int key;
diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index 5f45037..a20d691 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -1019,7 +1019,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 	return ret;
 }
 
-#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
+#if IS_ENABLED(CONFIG_RC_CORE)
 static int anysee_rc_query(struct dvb_usb_device *d)
 {
 	u8 buf[] = {CMD_GET_IR_CODE};
diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index 3b33f1e..70ec80d 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -189,7 +189,7 @@ static int az6007_streaming_ctrl(struct dvb_frontend *fe, int onoff)
 	return az6007_write(d, 0xbc, onoff, 0, NULL, 0);
 }
 
-#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
+#if IS_ENABLED(CONFIG_RC_CORE)
 /* remote control stuff (does not work with my box) */
 static int az6007_rc_query(struct dvb_usb_device *d)
 {
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 95968d3..0867920 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -102,7 +102,7 @@ static int dvb_usbv2_i2c_exit(struct dvb_usb_device *d)
 	return 0;
 }
 
-#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
+#if IS_ENABLED(CONFIG_RC_CORE)
 static void dvb_usb_read_remote_control(struct work_struct *work)
 {
 	struct dvb_usb_device *d = container_of(work,
diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
index 3d20e38..cddbca4 100644
--- a/drivers/media/usb/dvb-usb-v2/it913x.c
+++ b/drivers/media/usb/dvb-usb-v2/it913x.c
@@ -308,7 +308,7 @@ static struct i2c_algorithm it913x_i2c_algo = {
 };
 
 /* Callbacks for DVB USB */
-#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
+#if IS_ENABLED(CONFIG_RC_CORE)
 static int it913x_rc_query(struct dvb_usb_device *d)
 {
 	u8 ibuf[4];
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 923beef..cb9a4e4 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1120,7 +1120,7 @@ err:
 	return ret;
 }
 
-#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
+#if IS_ENABLED(CONFIG_RC_CORE)
 static int rtl2831u_rc_query(struct dvb_usb_device *d)
 {
 	int ret, i;
@@ -1207,7 +1207,7 @@ static int rtl2831u_get_rc_config(struct dvb_usb_device *d,
 	#define rtl2831u_get_rc_config NULL
 #endif
 
-#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
+#if IS_ENABLED(CONFIG_RC_CORE)
 static int rtl2832u_rc_query(struct dvb_usb_device *d)
 {
 	int ret, i;
-- 
1.7.11.7

