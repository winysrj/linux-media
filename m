Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57844 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab1EQDUc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 23:20:32 -0400
Received: by bwz15 with SMTP id 15so155766bwz.19
        for <linux-media@vger.kernel.org>; Mon, 16 May 2011 20:20:31 -0700 (PDT)
Date: Tue, 17 May 2011 14:23:52 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] xc5000, fix fw upload crash
Message-ID: <20110517142352.7d311ee8@glory.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/DWJrqv6m2ILFCKbd7TmcmJ3"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--MP_/DWJrqv6m2ILFCKbd7TmcmJ3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Fix crash when init tuner and upload twice the firmware into xc5000 at the some time.

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index aa1b2e8..a491a5b 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -996,6 +996,8 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret = 0;
 
+	mutex_lock(&xc5000_list_mutex);
+
 	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
 		ret = xc5000_fwupload(fe);
 		if (ret != XC_RESULT_SUCCESS)
@@ -1015,6 +1017,8 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
 	/* Default to "CABLE" mode */
 	ret |= xc_write_reg(priv, XREG_SIGNALSOURCE, XC_RF_MODE_CABLE);
 
+	mutex_unlock(&xc5000_list_mutex);
+
 	return ret;
 }
 

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.

--MP_/DWJrqv6m2ILFCKbd7TmcmJ3
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=xc5000_load_firmware_fix.diff

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index aa1b2e8..a491a5b 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -996,6 +996,8 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret = 0;
 
+	mutex_lock(&xc5000_list_mutex);
+
 	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
 		ret = xc5000_fwupload(fe);
 		if (ret != XC_RESULT_SUCCESS)
@@ -1015,6 +1017,8 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
 	/* Default to "CABLE" mode */
 	ret |= xc_write_reg(priv, XREG_SIGNALSOURCE, XC_RF_MODE_CABLE);
 
+	mutex_unlock(&xc5000_list_mutex);
+
 	return ret;
 }
 

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/DWJrqv6m2ILFCKbd7TmcmJ3--
