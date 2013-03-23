Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab3CWMfV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 08:35:21 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2NCZIJj031614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 23 Mar 2013 08:35:18 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 4/4] [media] dvb-usb/dvb-usb-v2: use IS_ENABLED
Date: Sat, 23 Mar 2013 09:35:11 -0300
Message-Id: <1364042111-24708-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1364042111-24708-1-git-send-email-mchehab@redhat.com>
References: <1364042111-24708-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking everywhere there for 3 symbols, use instead
IS_ENABLED macro.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h | 4 ++--
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h | 5 ++---
 drivers/media/usb/dvb-usb/dibusb-common.c     | 5 +++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
index 432706a..3f3f8bf 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
@@ -21,6 +21,7 @@
 #ifndef __MXL111SF_DEMOD_H__
 #define __MXL111SF_DEMOD_H__
 
+#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 #include "mxl111sf.h"
 
@@ -31,8 +32,7 @@ struct mxl111sf_demod_config {
 			    struct mxl111sf_reg_ctrl_info *ctrl_reg_info);
 };
 
-#if defined(CONFIG_DVB_USB_MXL111SF) || \
-	(defined(CONFIG_DVB_USB_MXL111SF_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_USB_MXL111SF)
 extern
 struct dvb_frontend *mxl111sf_demod_attach(struct mxl111sf_state *mxl_state,
 					   struct mxl111sf_demod_config *cfg);
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
index ff33396..90f583e 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
@@ -21,8 +21,8 @@
 #ifndef __MXL111SF_TUNER_H__
 #define __MXL111SF_TUNER_H__
 
+#include <linux/kconfig.h>
 #include "dvb_frontend.h"
-
 #include "mxl111sf.h"
 
 enum mxl_if_freq {
@@ -60,8 +60,7 @@ struct mxl111sf_tuner_config {
 
 /* ------------------------------------------------------------------------ */
 
-#if defined(CONFIG_DVB_USB_MXL111SF) || \
-	(defined(CONFIG_DVB_USB_MXL111SF_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_USB_MXL111SF)
 extern
 struct dvb_frontend *mxl111sf_tuner_attach(struct dvb_frontend *fe,
 					   struct mxl111sf_state *mxl_state,
diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index af0d432..c2dded9 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -8,6 +8,8 @@
  *
  * see Documentation/dvb/README.dvb-usb for more information
  */
+
+#include <linux/kconfig.h>
 #include "dibusb.h"
 
 static int debug;
@@ -232,8 +234,7 @@ static struct dibx000_agc_config dib3000p_panasonic_agc_config = {
 	.agc2_slope2 = 0x1e,
 };
 
-#if defined(CONFIG_DVB_DIB3000MC) || 					\
-	(defined(CONFIG_DVB_DIB3000MC_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DIB3000MC)
 
 static struct dib3000mc_config mod3000p_dib3000p_config = {
 	&dib3000p_panasonic_agc_config,
-- 
1.8.1.4

