Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbaCJL74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:56 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 11/15] drx-j: re-add get_sig_strength()
Date: Mon, 10 Mar 2014 08:59:03 -0300
Message-Id: <1394452747-5426-12-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
References: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We'll need to use this function. Restore it from the
git history.

This function will be used on the next patch.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 77 +++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 7022a69f56bd..ca807b1fc67c 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -9352,6 +9352,83 @@ rw_error:
 /*============================================================================*/
 
 /**
+ * \fn int get_sig_strength()
+ * \brief Retrieve signal strength for VSB and QAM.
+ * \param demod Pointer to demod instance
+ * \param u16-t Pointer to signal strength data; range 0, .. , 100.
+ * \return int.
+ * \retval 0 sig_strength contains valid data.
+ * \retval -EINVAL sig_strength is NULL.
+ * \retval -EIO Erroneous data, sig_strength contains invalid data.
+ */
+#define DRXJ_AGC_TOP    0x2800
+#define DRXJ_AGC_SNS    0x1600
+#define DRXJ_RFAGC_MAX  0x3fff
+#define DRXJ_RFAGC_MIN  0x800
+
+static int get_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
+{
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
+	int rc;
+	u16 rf_gain = 0;
+	u16 if_gain = 0;
+	u16 if_agc_sns = 0;
+	u16 if_agc_top = 0;
+	u16 rf_agc_max = 0;
+	u16 rf_agc_min = 0;
+
+	rc = drxj_dap_read_reg16(dev_addr, IQM_AF_AGC_IF__A, &if_gain, 0);
+	if (rc != 0) {
+		pr_err("error %d\n", rc);
+		goto rw_error;
+	}
+	if_gain &= IQM_AF_AGC_IF__M;
+	rc = drxj_dap_read_reg16(dev_addr, IQM_AF_AGC_RF__A, &rf_gain, 0);
+	if (rc != 0) {
+		pr_err("error %d\n", rc);
+		goto rw_error;
+	}
+	rf_gain &= IQM_AF_AGC_RF__M;
+
+	if_agc_sns = DRXJ_AGC_SNS;
+	if_agc_top = DRXJ_AGC_TOP;
+	rf_agc_max = DRXJ_RFAGC_MAX;
+	rf_agc_min = DRXJ_RFAGC_MIN;
+
+	if (if_gain > if_agc_top) {
+		if (rf_gain > rf_agc_max)
+			*sig_strength = 100;
+		else if (rf_gain > rf_agc_min) {
+			if (rf_agc_max == rf_agc_min) {
+				pr_err("error: rf_agc_max == rf_agc_min\n");
+				return -EIO;
+			}
+			*sig_strength =
+			75 + 25 * (rf_gain - rf_agc_min) / (rf_agc_max -
+								rf_agc_min);
+		} else
+			*sig_strength = 75;
+	} else if (if_gain > if_agc_sns) {
+		if (if_agc_top == if_agc_sns) {
+			pr_err("error: if_agc_top == if_agc_sns\n");
+			return -EIO;
+		}
+		*sig_strength =
+		20 + 55 * (if_gain - if_agc_sns) / (if_agc_top - if_agc_sns);
+	} else {
+		if (!if_agc_sns) {
+			pr_err("error: if_agc_sns is zero!\n");
+			return -EIO;
+		}
+		*sig_strength = (20 * if_gain / if_agc_sns);
+	}
+
+	return 0;
+	rw_error:
+	return -EIO;
+}
+
+/**
 * \fn int ctrl_get_qam_sig_quality()
 * \brief Retreive QAM signal quality from device.
 * \param devmod Pointer to demodulator instance.
-- 
1.8.5.3

