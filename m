Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35006 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932135AbdHWQKK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 12:10:10 -0400
Received: by mail-wr0-f194.google.com with SMTP id p8so360161wrf.2
        for <linux-media@vger.kernel.org>; Wed, 23 Aug 2017 09:10:09 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH 4/5] [media] staging/cxd2099: Add module parameter for buffer mode
Date: Wed, 23 Aug 2017 18:10:01 +0200
Message-Id: <20170823161002.25459-5-d.scheller.oss@gmail.com>
In-Reply-To: <20170823161002.25459-1-d.scheller.oss@gmail.com>
References: <20170823161002.25459-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The buffer mode of the cxd2099 driver requires more work regarding error
handling and thus can cause issues in some cases, so disable it by default
and make that mode of operation controllable by users via a module
parameter (ie. 'modprobe cxd2099 buffermode=1' enables current behaviour).

The upstream codebase also has the buffer mode disabled by default, so
we should match this (but users still can test things out using the
modparm).

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Jasmin Jessich <jasmin@anw.at>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/staging/media/cxd2099/cxd2099.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index f28916ea69f1..3e30f4864e2b 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -33,8 +33,9 @@
 
 #include "cxd2099.h"
 
-/* comment this line to deactivate the cxd2099ar buffer mode */
-#define BUFFER_MODE 1
+static int buffermode;
+module_param(buffermode, int, 0444);
+MODULE_PARM_DESC(buffermode, "Enable use of the CXD2099AR buffer mode (default: disabled)");
 
 static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount);
 
@@ -221,7 +222,6 @@ static int write_reg(struct cxd *ci, u8 reg, u8 val)
 	return write_regm(ci, reg, val, 0xff);
 }
 
-#ifdef BUFFER_MODE
 static int write_block(struct cxd *ci, u8 adr, u8 *data, u16 n)
 {
 	int status = 0;
@@ -248,7 +248,6 @@ static int write_block(struct cxd *ci, u8 adr, u8 *data, u16 n)
 	}
 	return status;
 }
-#endif
 
 static void set_mode(struct cxd *ci, int mode)
 {
@@ -642,8 +641,6 @@ static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 	return len;
 }
 
-#ifdef BUFFER_MODE
-
 static int write_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 {
 	struct cxd *ci = ca->data;
@@ -658,7 +655,6 @@ static int write_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 	mutex_unlock(&ci->lock);
 	return ecount;
 }
-#endif
 
 static struct dvb_ca_en50221 en_templ = {
 	.read_attribute_mem  = read_attribute_mem,
@@ -669,11 +665,8 @@ static struct dvb_ca_en50221 en_templ = {
 	.slot_shutdown       = slot_shutdown,
 	.slot_ts_enable      = slot_ts_enable,
 	.poll_slot_status    = poll_slot_status,
-#ifdef BUFFER_MODE
 	.read_data           = read_data,
 	.write_data          = write_data,
-#endif
-
 };
 
 struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
@@ -703,6 +696,14 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 	ci->en.data = ci;
 	init(ci);
 	dev_info(&i2c->dev, "Attached CXD2099AR at %02x\n", ci->cfg.adr);
+
+	if (!buffermode) {
+		ci->en.read_data = NULL;
+		ci->en.write_data = NULL;
+	} else {
+		dev_info(&i2c->dev, "Using CXD2099AR buffer mode");
+	}
+
 	return &ci->en;
 }
 EXPORT_SYMBOL(cxd2099_attach);
-- 
2.13.0
