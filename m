Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294Ab1FCNLv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 09:11:51 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p53DBorC029868
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 3 Jun 2011 09:11:50 -0400
Received: from [10.11.9.109] (vpn-9-109.rdu.redhat.com [10.11.9.109])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p53DBnxu018938
	for <linux-media@vger.kernel.org>; Fri, 3 Jun 2011 09:11:49 -0400
Message-ID: <4DE8DD94.5040609@redhat.com>
Date: Fri, 03 Jun 2011 10:11:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Fwd: XC4000: code cleanup
Content-Type: multipart/mixed;
 boundary="------------040103090708040302080007"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------040103090708040302080007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



-------- Mensagem original --------
Assunto: XC4000: code cleanup
Data: Fri, 03 Jun 2011 12:02:15 +0200
De: istvan_v@mailbox.hu <istvan_v@mailbox.hu>
Para: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Dmitri Belimov <d.belimov@gmail.com>,        Mauro Carvalho Chehab <mchehab@redhat.com>, thunder.m@email.cz,        linux-dvb@linuxtv.org

This is the first of a set of patches that update the original xc4000
sources to my modified version. It removes some unused code, and makes
a few minor formatting changes.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------040103090708040302080007
Content-Type: text/x-patch;
 name="xc4000_cleanup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_cleanup.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-02 17:36:36.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-03 11:50:53.000000000 +0200
@@ -55,8 +55,6 @@
 /* Note that the last version digit is my internal build number (so I can
    rev the firmware even if the core Xceive firmware was unchanged) */
 #define XC4000_DEFAULT_FIRMWARE "dvb-fe-xc4000-1.4.1.fw"
-#define XC4000_DEFAULT_FIRMWARE_SIZE 18643
-
 
 /* struct for storing firmware table */
 struct firmware_description {
@@ -80,18 +78,18 @@
 	struct tuner_i2c_props i2c_props;
 	struct list_head hybrid_tuner_instance_list;
 	struct firmware_description *firm;
-	int			firm_size;
-	__u16			firm_version;
-	u32 if_khz;
-	u32 freq_hz;
-	u32 bandwidth;
-	u8  video_standard;
-	u8  rf_mode;
-//	struct xc2028_ctrl	ctrl;
+	int	firm_size;
+	__u16	firm_version;
+	u32	if_khz;
+	u32	freq_hz;
+	u32	bandwidth;
+	u8	video_standard;
+	u8	rf_mode;
+	u8	ignore_i2c_write_errors;
+ /*	struct xc2028_ctrl	ctrl; */
 	struct firmware_properties cur_fw;
-	__u16			hwmodel;
-	__u16			hwvers;
-	u8 ignore_i2c_write_errors;
+	__u16	hwmodel;
+	__u16	hwvers;
 };
 
 /* Misc Defines */
@@ -167,12 +165,12 @@
 
    For the RESET and WAIT commands, the two following bytes will contain
    immediately the length of the following transaction.
-
 */
+
 struct XC_TV_STANDARD {
-	char *Name;
-	u16 AudioMode;
-	u16 VideoMode;
+	const char  *Name;
+	u16	    AudioMode;
+	u16	    VideoMode;
 };
 
 /* Tuner standards */
@@ -200,33 +198,6 @@
 #define XC4000_FM_Radio_INPUT2		21
 #define XC4000_FM_Radio_INPUT1	22
 
-/* WAS :
-static struct XC_TV_STANDARD XC4000_Standard[MAX_TV_STANDARD] = {
-	{"M/N-NTSC/PAL-BTSC", 0x0400, 0x8020},
-	{"M/N-NTSC/PAL-A2",   0x0600, 0x8020},
-	{"M/N-NTSC/PAL-EIAJ", 0x0440, 0x8020},
-	{"M/N-NTSC/PAL-Mono", 0x0478, 0x8020},
-	{"B/G-PAL-A2",        0x0A00, 0x8049},
-	{"B/G-PAL-NICAM",     0x0C04, 0x8049},
-	{"B/G-PAL-MONO",      0x0878, 0x8059},
-	{"I-PAL-NICAM",       0x1080, 0x8009},
-	{"I-PAL-NICAM-MONO",  0x0E78, 0x8009},
-	{"D/K-PAL-A2",        0x1600, 0x8009},
-	{"D/K-PAL-NICAM",     0x0E80, 0x8009},
-	{"D/K-PAL-MONO",      0x1478, 0x8009},
-	{"D/K-SECAM-A2 DK1",  0x1200, 0x8009},
-	{"D/K-SECAM-A2 L/DK3", 0x0E00, 0x8009},
-	{"D/K-SECAM-A2 MONO", 0x1478, 0x8009},
-	{"L-SECAM-NICAM",     0x8E82, 0x0009},
-	{"L'-SECAM-NICAM",    0x8E82, 0x4009},
-	{"DTV6",              0x00C0, 0x8002},
-	{"DTV8",              0x00C0, 0x800B},
-	{"DTV7/8",            0x00C0, 0x801B},
-	{"DTV7",              0x00C0, 0x8007},
-	{"FM Radio-INPUT2",   0x9802, 0x9002},
-	{"FM Radio-INPUT1",   0x0208, 0x9002}
-};*/
-
 static struct XC_TV_STANDARD XC4000_Standard[MAX_TV_STANDARD] = {
 	{"M/N-NTSC/PAL-BTSC", 0x0000, 0x8020},
 	{"M/N-NTSC/PAL-A2",   0x0000, 0x8020},
@@ -253,7 +224,6 @@
 	{"FM Radio-INPUT1",   0x0008, 0x9000}
 };
 
-static int xc4000_is_firmware_loaded(struct dvb_frontend *fe);
 static int xc4000_readreg(struct xc4000_priv *priv, u16 reg, u16 *val);
 static int xc4000_TunerReset(struct dvb_frontend *fe);
 
@@ -275,10 +245,6 @@
 	return XC_RESULT_SUCCESS;
 }
 
-/* This routine is never used because the only time we read data from the
-   i2c bus is when we read registers, and we want that to be an atomic i2c
-   transaction in case we are on a multi-master bus */
-
 static void xc_wait(int wait_ms)
 {
 	msleep(wait_ms);
@@ -431,7 +397,6 @@
 	return xc_write_reg(priv, XREG_RF_FREQ, freq_code); /* WAS: XREG_FINERFREQ */
 }
 
-
 static int xc_get_ADC_Envelope(struct xc4000_priv *priv, u16 *adc_envelope)
 {
 	return xc4000_readreg(priv, XREG_ADC_ENV, adc_envelope);
@@ -476,12 +441,6 @@
 	return 0;
 }
 
-/* WAS THERE
-static int xc_get_buildversion(struct xc4000_priv *priv, u16 *buildrev)
-{
-	return xc4000_readreg(priv, XREG_BUILD, buildrev);
-}*/
-
 static int xc_get_hsync_freq(struct xc4000_priv *priv, u32 *hsync_freq_hz)
 {
 	u16 regData;
@@ -520,12 +479,10 @@
 	return lockState;
 }
 
-#define XC_TUNE_ANALOG  0
-#define XC_TUNE_DIGITAL 1
 static int xc_tune_channel(struct xc4000_priv *priv, u32 freq_hz, int mode)
 {
-	int found = 0;
-	int result = 0;
+	int	found = 0;
+	int	result = 0;
 
 	dprintk(1, "%s(%u)\n", __func__, freq_hz);
 
@@ -694,7 +651,6 @@
 	if (best_nr_matches > 0) {
 		printk("Selecting best matching firmware (%d bits) for "
 			  "type=", best_nr_matches);
-//		dump_firm_type(type);
 		printk("(%x), id %016llx:\n", type, (unsigned long long)*id);
 		i = best_i;
 		goto found;
@@ -749,7 +705,7 @@
 	int                   rc = 0;
 	int		      n, n_array;
 	char		      name[33];
-	char		      *fname;
+	const char	      *fname;
 
 	fname = XC4000_DEFAULT_FIRMWARE;
 
@@ -770,7 +726,7 @@
 
 	if (fw->size < sizeof(name) - 1 + 2 + 2) {
 		printk("Error: firmware file %s has invalid size!\n",
-			  fname);
+		       fname);
 		goto corrupt;
 	}
 
@@ -805,7 +761,7 @@
 		n++;
 		if (n >= n_array) {
 			printk("More firmware images in file than "
-				  "were expected!\n");
+			       "were expected!\n");
 			goto corrupt;
 		}
 
@@ -831,7 +787,6 @@
 
 		if (!size || size > endp - p) {
 			printk("Firmware type ");
-//			dump_firm_type(type);
 			printk("(%x), id %llx is corrupted "
 			       "(size=%d, expected %d)\n",
 			       type, (unsigned long long)id,
@@ -877,7 +832,6 @@
 
 err:
 	printk("Releasing partially loaded firmware file.\n");
-//	free_firmware(priv);
 
 done:
 	release_firmware(fw);
@@ -986,8 +940,7 @@
 	new_fw.type = type;
 	new_fw.id = std;
 	new_fw.std_req = std;
-//	new_fw.scode_table = SCODE | priv->ctrl.scode_table;
-	new_fw.scode_table = SCODE;
+	new_fw.scode_table = SCODE /* | priv->ctrl.scode_table */;
 	new_fw.scode_nr = 0;
 	new_fw.int_freq = int_freq;
 
@@ -1108,7 +1061,7 @@
 	} else if (priv->hwmodel == 0 || priv->hwmodel != hwmodel ||
 		   priv->hwvers != (version & 0xff00)) {
 		printk("Read invalid device hardware information - tuner "
-			  "hung?\n");
+		       "hung?\n");
 		goto fail;
 	}
 
@@ -1140,15 +1093,14 @@
 
 static void xc_debug_dump(struct xc4000_priv *priv)
 {
-	u16 adc_envelope;
-	u32 freq_error_hz = 0;
-	u16 lock_status;
-	u32 hsync_freq_hz = 0;
-	u16 frame_lines;
-	u16 quality;
-	u8 hw_majorversion = 0, hw_minorversion = 0;
-	u8 fw_majorversion = 0, fw_minorversion = 0;
-//	u16 fw_buildversion = 0;
+	u16	adc_envelope;
+	u32	freq_error_hz = 0;
+	u16	lock_status;
+	u32	hsync_freq_hz = 0;
+	u16	frame_lines;
+	u16	quality;
+	u8	hw_majorversion = 0, hw_minorversion = 0;
+	u8	fw_majorversion = 0, fw_minorversion = 0;
 
 	/* Wait for stats to stabilize.
 	 * Frame Lines needs two frame times after initial lock
@@ -1156,35 +1108,30 @@
 	 */
 	xc_wait(100);
 
-	xc_get_ADC_Envelope(priv,  &adc_envelope);
+	xc_get_ADC_Envelope(priv, &adc_envelope);
 	dprintk(1, "*** ADC envelope (0-1023) = %d\n", adc_envelope);
 
 	xc_get_frequency_error(priv, &freq_error_hz);
 	dprintk(1, "*** Frequency error = %d Hz\n", freq_error_hz);
 
-	xc_get_lock_status(priv,  &lock_status);
+	xc_get_lock_status(priv, &lock_status);
 	dprintk(1, "*** Lock status (0-Wait, 1-Locked, 2-No-signal) = %d\n",
 		lock_status);
 
-	xc_get_version(priv,  &hw_majorversion, &hw_minorversion,
-		&fw_majorversion, &fw_minorversion);
-// WAS:
-//	xc_get_buildversion(priv,  &fw_buildversion);
-//	dprintk(1, "*** HW: V%02x.%02x, FW: V%02x.%02x.%04x\n",
-//		hw_majorversion, hw_minorversion,
-//		fw_majorversion, fw_minorversion, fw_buildversion);
-// NOW:
+	xc_get_version(priv, &hw_majorversion, &hw_minorversion,
+		       &fw_majorversion, &fw_minorversion);
+
 	dprintk(1, "*** HW: V%02x.%02x, FW: V%02x.%02x\n",
 		hw_majorversion, hw_minorversion,
 		fw_majorversion, fw_minorversion);
 
-	xc_get_hsync_freq(priv,  &hsync_freq_hz);
+	xc_get_hsync_freq(priv, &hsync_freq_hz);
 	dprintk(1, "*** Horizontal sync frequency = %d Hz\n", hsync_freq_hz);
 
-	xc_get_frame_lines(priv,  &frame_lines);
+	xc_get_frame_lines(priv, &frame_lines);
 	dprintk(1, "*** Frame lines = %d\n", frame_lines);
 
-	xc_get_quality(priv,  &quality);
+	xc_get_quality(priv, &quality);
 	dprintk(1, "*** Quality (0:<8dB, 7:>56dB) = %d\n", quality);
 }
 
@@ -1193,7 +1140,7 @@
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
 	unsigned int type;
-	int ret;
+	int	ret;
 
 	dprintk(1, "%s() frequency=%d (Hz)\n", __func__, params->frequency);
 
@@ -1290,30 +1237,11 @@
 	return 0;
 }
 
-static int xc4000_is_firmware_loaded(struct dvb_frontend *fe)
-{
-	struct xc4000_priv *priv = fe->tuner_priv;
-	int ret;
-	u16 id;
-
-	ret = xc4000_readreg(priv, XREG_PRODUCT_ID, &id);
-	if (ret == XC_RESULT_SUCCESS) {
-		if (id == XC_PRODUCT_ID_FW_NOT_LOADED)
-			ret = XC_RESULT_RESET_FAILURE;
-		else
-			ret = XC_RESULT_SUCCESS;
-	}
-
-	dprintk(1, "%s() returns %s id = 0x%x\n", __func__,
-		ret == XC_RESULT_SUCCESS ? "True" : "False", id);
-	return ret;
-}
-
 static int xc4000_set_analog_params(struct dvb_frontend *fe,
 	struct analog_parameters *params)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
-	int ret;
+	int	ret;
 
 	dprintk(1, "%s() frequency=%d (in units of 62.5khz)\n",
 		__func__, params->frequency);
@@ -1420,7 +1348,7 @@
 static int xc4000_get_status(struct dvb_frontend *fe, u32 *status)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
-	u16 lock_status = 0;
+	u16	lock_status = 0;
 
 	xc_get_lock_status(priv, &lock_status);
 
@@ -1495,8 +1423,8 @@
 				   struct xc4000_config *cfg)
 {
 	struct xc4000_priv *priv = NULL;
-	int instance;
-	u16 id = 0;
+	int	instance;
+	u16	id = 0;
 
 	dprintk(1, "%s(%d-%04x)\n", __func__,
 		i2c ? i2c_adapter_id(i2c) : -1,
diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.h xc4000/drivers/media/common/tuners/xc4000.h
--- xc4000_orig/drivers/media/common/tuners/xc4000.h	2011-06-02 17:36:52.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.h	2011-06-03 11:51:29.000000000 +0200
@@ -28,8 +28,8 @@
 struct i2c_adapter;
 
 struct xc4000_config {
-	u8   i2c_address;
-	u32  if_khz;
+	u8	i2c_address;
+	u32	if_khz;
 };
 
 /* xc4000 callback command */


--------------040103090708040302080007--
