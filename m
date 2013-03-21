Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab3CUTjX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 15:39:23 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4/4] [media] dvb-usb/dvb-usb-v2: use IS_ENABLED
Date: Thu, 21 Mar 2013 16:39:08 -0300
Message-Id: <1363894748-28000-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363894748-28000-1-git-send-email-mchehab@redhat.com>
References: <1363894748-28000-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking everywhere there for 3 symbols, use instead
IS_ENABLED macro.

This replacement was done using this small perl script:

my $data;
$data .= $_ while (<>);
if ($data =~ m/CONFIG_([A-Z\_\d]*)_MODULE/) {
        $data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
        $data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
        $data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
        $data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)\!]+defined\(CONFIG_($f)_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;

        $data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)\)\)*,IS_ENABLED(CONFIG_$f),g;
        $data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)\)\)*,IS_ENABLED(CONFIG_$f),g;
        $data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
        $data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
}
print $data;

Cc: Michael Krufky <mkrufky@linuxtv.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h | 3 +--
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h | 3 +--
 drivers/media/usb/dvb-usb/dibusb-common.c     | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
index 432706a..40dd409 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
@@ -31,8 +31,7 @@ struct mxl111sf_demod_config {
 			    struct mxl111sf_reg_ctrl_info *ctrl_reg_info);
 };
 
-#if defined(CONFIG_DVB_USB_MXL111SF) || \
-	(defined(CONFIG_DVB_USB_MXL111SF_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_USB_MXL111SF)
 extern
 struct dvb_frontend *mxl111sf_demod_attach(struct mxl111sf_state *mxl_state,
 					   struct mxl111sf_demod_config *cfg);
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
index ff33396..634eee3 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
@@ -60,8 +60,7 @@ struct mxl111sf_tuner_config {
 
 /* ------------------------------------------------------------------------ */
 
-#if defined(CONFIG_DVB_USB_MXL111SF) || \
-	(defined(CONFIG_DVB_USB_MXL111SF_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_USB_MXL111SF)
 extern
 struct dvb_frontend *mxl111sf_tuner_attach(struct dvb_frontend *fe,
 					   struct mxl111sf_state *mxl_state,
diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index af0d432..ecb9360 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -232,8 +232,7 @@ static struct dibx000_agc_config dib3000p_panasonic_agc_config = {
 	.agc2_slope2 = 0x1e,
 };
 
-#if defined(CONFIG_DVB_DIB3000MC) || 					\
-	(defined(CONFIG_DVB_DIB3000MC_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DIB3000MC)
 
 static struct dib3000mc_config mod3000p_dib3000p_config = {
 	&dib3000p_panasonic_agc_config,
-- 
1.8.1.4

