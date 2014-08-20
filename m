Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3398 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaHTW7o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/29] mxl111sf: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:06 +0200
Message-Id: <1408575568-20562-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/dvb-usb-v2/mxl111sf.c:34:5: warning: symbol 'dvb_usb_mxl111sf_isoc' was not declared. Should it be static?
drivers/media/usb/dvb-usb-v2/mxl111sf.c:38:5: warning: symbol 'dvb_usb_mxl111sf_spi' was not declared. Should it be static?
drivers/media/usb/dvb-usb-v2/mxl111sf.c:46:5: warning: symbol 'dvb_usb_mxl111sf_rfswitch' was not declared. Should it be static?
drivers/media/usb/dvb-usb-v2/mxl111sf.c:890:22: warning: symbol 'mxl111sf_i2c_algo' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index b8a707e..c3447ea 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -31,11 +31,11 @@ module_param_named(debug, dvb_usb_mxl111sf_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level "
 		 "(1=info, 2=xfer, 4=i2c, 8=reg, 16=adv (or-able)).");
 
-int dvb_usb_mxl111sf_isoc;
+static int dvb_usb_mxl111sf_isoc;
 module_param_named(isoc, dvb_usb_mxl111sf_isoc, int, 0644);
 MODULE_PARM_DESC(isoc, "enable usb isoc xfer (0=bulk, 1=isoc).");
 
-int dvb_usb_mxl111sf_spi;
+static int dvb_usb_mxl111sf_spi;
 module_param_named(spi, dvb_usb_mxl111sf_spi, int, 0644);
 MODULE_PARM_DESC(spi, "use spi rather than tp for data xfer (0=tp, 1=spi).");
 
@@ -43,7 +43,7 @@ MODULE_PARM_DESC(spi, "use spi rather than tp for data xfer (0=tp, 1=spi).");
 #define ANT_PATH_EXTERNAL 1
 #define ANT_PATH_INTERNAL 2
 
-int dvb_usb_mxl111sf_rfswitch =
+static int dvb_usb_mxl111sf_rfswitch =
 #if 0
 		ANT_PATH_AUTO;
 #else
@@ -887,7 +887,7 @@ static u32 mxl111sf_i2c_func(struct i2c_adapter *adapter)
 	return I2C_FUNC_I2C;
 }
 
-struct i2c_algorithm mxl111sf_i2c_algo = {
+static struct i2c_algorithm mxl111sf_i2c_algo = {
 	.master_xfer   = mxl111sf_i2c_xfer,
 	.functionality = mxl111sf_i2c_func,
 #ifdef NEED_ALGO_CONTROL
-- 
2.1.0.rc1

