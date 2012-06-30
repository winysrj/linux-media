Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab2F3RbK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 13:31:10 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5UHVA7R000841
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 30 Jun 2012 13:31:10 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] tuner-xc2028: use request_firmware_nowait()
Date: Sat, 30 Jun 2012 14:31:05 -0300
Message-Id: <1341077465-4850-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the firmware logic to use request_firmware_nowait(), and
to preserve the loaded firmwares in memory, to reduce the risk
of troubles with buggy userspace apps.

With this change, while the firmware is being loaded, the driver
will return -EAGAIN to any calls. If, for some reason, firmware
failed to be loaded from userspace, it will return -ENODEV.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tuner-xc2028.c |  178 ++++++++++++++++++++--------
 1 file changed, 129 insertions(+), 49 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index b5ee3eb..9638a69 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -90,11 +90,22 @@ struct firmware_properties {
 	int 		scode_nr;
 };
 
+enum xc2028_state {
+	XC2028_NO_FIRMWARE = 0,
+	XC2028_WAITING_FIRMWARE,
+	XC2028_ACTIVE,
+	XC2028_SLEEP,
+	XC2028_NODEV,
+};
+
 struct xc2028_data {
 	struct list_head        hybrid_tuner_instance_list;
 	struct tuner_i2c_props  i2c_props;
 	__u32			frequency;
 
+	enum xc2028_state	state;
+	const char		*fname;
+
 	struct firmware_description *firm;
 	int			firm_size;
 	__u16			firm_version;
@@ -255,6 +266,21 @@ static  v4l2_std_id parse_audio_std_option(void)
 	return 0;
 }
 
+static int check_device_status(struct xc2028_data *priv)
+{
+	switch (priv->state) {
+	case XC2028_NO_FIRMWARE:
+	case XC2028_WAITING_FIRMWARE:
+		return -EAGAIN;
+	case XC2028_ACTIVE:
+	case XC2028_SLEEP:
+		return 0;
+	case XC2028_NODEV:
+		return -ENODEV;
+	}
+	return 0;
+}
+
 static void free_firmware(struct xc2028_data *priv)
 {
 	int i;
@@ -270,45 +296,28 @@ static void free_firmware(struct xc2028_data *priv)
 
 	priv->firm = NULL;
 	priv->firm_size = 0;
+	priv->state = XC2028_NO_FIRMWARE;
 
 	memset(&priv->cur_fw, 0, sizeof(priv->cur_fw));
 }
 
-static int load_all_firmwares(struct dvb_frontend *fe)
+static int load_all_firmwares(struct dvb_frontend *fe,
+			      const struct firmware *fw)
 {
 	struct xc2028_data    *priv = fe->tuner_priv;
-	const struct firmware *fw   = NULL;
 	const unsigned char   *p, *endp;
 	int                   rc = 0;
 	int		      n, n_array;
 	char		      name[33];
-	char		      *fname;
 
 	tuner_dbg("%s called\n", __func__);
 
-	if (!firmware_name[0])
-		fname = priv->ctrl.fname;
-	else
-		fname = firmware_name;
-
-	tuner_dbg("Reading firmware %s\n", fname);
-	rc = request_firmware(&fw, fname, priv->i2c_props.adap->dev.parent);
-	if (rc < 0) {
-		if (rc == -ENOENT)
-			tuner_err("Error: firmware %s not found.\n",
-				   fname);
-		else
-			tuner_err("Error %d while requesting firmware %s \n",
-				   rc, fname);
-
-		return rc;
-	}
 	p = fw->data;
 	endp = p + fw->size;
 
 	if (fw->size < sizeof(name) - 1 + 2 + 2) {
 		tuner_err("Error: firmware file %s has invalid size!\n",
-			  fname);
+			  priv->fname);
 		goto corrupt;
 	}
 
@@ -323,7 +332,7 @@ static int load_all_firmwares(struct dvb_frontend *fe)
 	p += 2;
 
 	tuner_info("Loading %d firmware images from %s, type: %s, ver %d.%d\n",
-		   n_array, fname, name,
+		   n_array, priv->fname, name,
 		   priv->firm_version >> 8, priv->firm_version & 0xff);
 
 	priv->firm = kcalloc(n_array, sizeof(*priv->firm), GFP_KERNEL);
@@ -417,9 +426,10 @@ err:
 	free_firmware(priv);
 
 done:
-	release_firmware(fw);
 	if (rc == 0)
 		tuner_dbg("Firmware files loaded.\n");
+	else
+		priv->state = XC2028_NODEV;
 
 	return rc;
 }
@@ -707,22 +717,15 @@ static int check_firmware(struct dvb_frontend *fe, unsigned int type,
 {
 	struct xc2028_data         *priv = fe->tuner_priv;
 	struct firmware_properties new_fw;
-	int			   rc = 0, retry_count = 0;
+	int			   rc, retry_count = 0;
 	u16			   version, hwmodel;
 	v4l2_std_id		   std0;
 
 	tuner_dbg("%s called\n", __func__);
 
-	if (!priv->firm) {
-		if (!priv->ctrl.fname) {
-			tuner_info("xc2028/3028 firmware name not set!\n");
-			return -EINVAL;
-		}
-
-		rc = load_all_firmwares(fe);
-		if (rc < 0)
-			return rc;
-	}
+	rc = check_device_status(priv);
+	if (rc < 0)
+		return rc;
 
 	if (priv->ctrl.mts && !(type & FM))
 		type |= MTS;
@@ -749,9 +752,13 @@ retry:
 		printk("scode_nr %d\n", new_fw.scode_nr);
 	}
 
-	/* No need to reload base firmware if it matches */
-	if (((BASE | new_fw.type) & BASE_TYPES) ==
-	    (priv->cur_fw.type & BASE_TYPES)) {
+	/*
+	 * No need to reload base firmware if it matches and if the tuner
+	 * is not at sleep mode
+	 */
+	if ((priv->state = XC2028_ACTIVE) &&
+	    (((BASE | new_fw.type) & BASE_TYPES) ==
+	    (priv->cur_fw.type & BASE_TYPES))) {
 		tuner_dbg("BASE firmware not changed.\n");
 		goto skip_base;
 	}
@@ -872,10 +879,13 @@ read_not_reliable:
 	 * 2. Tell whether BASE firmware was just changed the next time through.
 	 */
 	priv->cur_fw.type |= BASE;
+	priv->state = XC2028_ACTIVE;
 
 	return 0;
 
 fail:
+	priv->state = XC2028_SLEEP;
+
 	memset(&priv->cur_fw, 0, sizeof(priv->cur_fw));
 	if (retry_count < 8) {
 		msleep(50);
@@ -897,6 +907,10 @@ static int xc2028_signal(struct dvb_frontend *fe, u16 *strength)
 
 	tuner_dbg("%s called\n", __func__);
 
+	rc = check_device_status(priv);
+	if (rc < 0)
+		return rc;
+
 	mutex_lock(&priv->lock);
 
 	/* Sync Lock Indicator */
@@ -1111,11 +1125,16 @@ static int xc2028_set_params(struct dvb_frontend *fe)
 	u32 delsys = c->delivery_system;
 	u32 bw = c->bandwidth_hz;
 	struct xc2028_data *priv = fe->tuner_priv;
-	unsigned int       type=0;
+	int rc;
+	unsigned int       type = 0;
 	u16                demod = 0;
 
 	tuner_dbg("%s called\n", __func__);
 
+	rc = check_device_status(priv);
+	if (rc < 0)
+		return rc;
+
 	switch (delsys) {
 	case SYS_DVBT:
 	case SYS_DVBT2:
@@ -1201,7 +1220,11 @@ static int xc2028_set_params(struct dvb_frontend *fe)
 static int xc2028_sleep(struct dvb_frontend *fe)
 {
 	struct xc2028_data *priv = fe->tuner_priv;
-	int rc = 0;
+	int rc;
+
+	rc = check_device_status(priv);
+	if (rc < 0)
+		return rc;
 
 	/* Avoid firmware reload on slow devices or if PM disabled */
 	if (no_poweroff || priv->ctrl.disable_power_mgmt)
@@ -1220,7 +1243,7 @@ static int xc2028_sleep(struct dvb_frontend *fe)
 	else
 		rc = send_seq(priv, {0x80, XREG_POWER_DOWN, 0x00, 0x00});
 
-	priv->cur_fw.type = 0;	/* need firmware reload */
+	priv->state = XC2028_SLEEP;
 
 	mutex_unlock(&priv->lock);
 
@@ -1237,8 +1260,9 @@ static int xc2028_dvb_release(struct dvb_frontend *fe)
 
 	/* only perform final cleanup if this is the last instance */
 	if (hybrid_tuner_report_instance_count(priv) == 1) {
-		kfree(priv->ctrl.fname);
 		free_firmware(priv);
+		kfree(priv->ctrl.fname);
+		priv->ctrl.fname = NULL;
 	}
 
 	if (priv)
@@ -1254,14 +1278,42 @@ static int xc2028_dvb_release(struct dvb_frontend *fe)
 static int xc2028_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct xc2028_data *priv = fe->tuner_priv;
+	int rc;
 
 	tuner_dbg("%s called\n", __func__);
 
+	rc = check_device_status(priv);
+	if (rc < 0)
+		return rc;
+
 	*frequency = priv->frequency;
 
 	return 0;
 }
 
+static void load_firmware_cb(const struct firmware *fw,
+			     void *context)
+{
+	struct dvb_frontend *fe = context;
+	struct xc2028_data *priv = fe->tuner_priv;
+	int rc;
+
+	tuner_dbg("request_firmware_nowait(): %s\n", fw ? "OK" : "error");
+	if (!fw) {
+		tuner_err("Could not load firmware %s.\n", priv->fname);
+		priv->state = XC2028_NODEV;
+		return;
+	}
+
+	rc = load_all_firmwares(fe, fw);
+
+	release_firmware(fw);
+
+	if (rc < 0)
+		return;
+	priv->state = XC2028_SLEEP;
+}
+
 static int xc2028_set_config(struct dvb_frontend *fe, void *priv_cfg)
 {
 	struct xc2028_data *priv = fe->tuner_priv;
@@ -1272,21 +1324,49 @@ static int xc2028_set_config(struct dvb_frontend *fe, void *priv_cfg)
 
 	mutex_lock(&priv->lock);
 
+	/*
+	 * Copy the config data.
+	 * For the firmware name, keep a local copy of the string,
+	 * in order to avoid troubles during device release.
+	 */
+	if (priv->ctrl.fname)
+		kfree(priv->ctrl.fname);
 	memcpy(&priv->ctrl, p, sizeof(priv->ctrl));
-	if (priv->ctrl.max_len < 9)
-		priv->ctrl.max_len = 13;
-
 	if (p->fname) {
-		if (priv->ctrl.fname && strcmp(p->fname, priv->ctrl.fname)) {
-			kfree(priv->ctrl.fname);
-			free_firmware(priv);
-		}
-
 		priv->ctrl.fname = kstrdup(p->fname, GFP_KERNEL);
 		if (priv->ctrl.fname == NULL)
 			rc = -ENOMEM;
 	}
 
+	/*
+	 * If firmware name changed, frees firmware. As free_firmware will
+	 * reset the status to NO_FIRMWARE, this forces a new request_firmware
+	 */
+	if (!firmware_name[0] && p->fname &&
+	    priv->fname && strcmp(p->fname, priv->fname))
+		free_firmware(priv);
+
+	if (priv->ctrl.max_len < 9)
+		priv->ctrl.max_len = 13;
+
+	if (priv->state == XC2028_NO_FIRMWARE) {
+		if (!firmware_name[0])
+			priv->fname = priv->ctrl.fname;
+		else
+			priv->fname = firmware_name;
+
+		rc = request_firmware_nowait(THIS_MODULE, 1,
+					     priv->fname,
+					     priv->i2c_props.adap->dev.parent,
+					     GFP_KERNEL,
+					     fe, load_firmware_cb);
+		if (rc < 0) {
+			tuner_err("Failed to request firmware %s\n",
+				  priv->fname);
+			priv->state = XC2028_NODEV;
+		}
+		priv->state = XC2028_WAITING_FIRMWARE;
+	}
 	mutex_unlock(&priv->lock);
 
 	return rc;
-- 
1.7.10.2

