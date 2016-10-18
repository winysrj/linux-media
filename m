Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51653 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935750AbcJRUqZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Sean Young <sean@mess.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Nicolas Sugino <nsugino@3way.com.ar>,
        Alejandro Torrado <aletorrado@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Olli Salonen <olli.salonen@iki.fi>,
        Jonathan McDowell <noodles@earth.li>,
        Jiri Kosina <jkosina@suse.cz>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH v2 35/58] dvb-usb: don't break long lines
Date: Tue, 18 Oct 2016 18:45:47 -0200
Message-Id: <2e8daf1ce69245c48b9b4a00a5be329e133a26ca.1476822925.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/cinergyT2-core.c   |  6 ++----
 drivers/media/usb/dvb-usb/cinergyT2-fe.c     |  4 ++--
 drivers/media/usb/dvb-usb/dib0700_core.c     |  5 +----
 drivers/media/usb/dvb-usb/dib0700_devices.c  |  3 +--
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c      |  3 +--
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c |  6 ++----
 drivers/media/usb/dvb-usb/dw2102.c           | 10 ++--------
 drivers/media/usb/dvb-usb/friio.c            |  4 ++--
 drivers/media/usb/dvb-usb/gp8psk.c           |  3 +--
 drivers/media/usb/dvb-usb/opera1.c           |  3 +--
 drivers/media/usb/dvb-usb/pctv452e.c         |  3 +--
 drivers/media/usb/dvb-usb/technisat-usb2.c   |  3 +--
 12 files changed, 17 insertions(+), 36 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/media/usb/dvb-usb/cinergyT2-core.c
index 9fd1527494eb..f4d9122245ac 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
@@ -34,8 +34,7 @@
 int dvb_usb_cinergyt2_debug;
 
 module_param_named(debug, dvb_usb_cinergyt2_debug, int, 0644);
-MODULE_PARM_DESC(debug, "set debugging level (1=info, xfer=2, rc=4 "
-		"(or-able)).");
+MODULE_PARM_DESC(debug, "set debugging level (1=info, xfer=2, rc=4 (or-able)).");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -74,8 +73,7 @@ static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
 	ret = dvb_usb_generic_rw(adap->dev, query, sizeof(query), state,
 				sizeof(state), 0);
 	if (ret < 0) {
-		deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep "
-			"state info\n");
+		deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep state info\n");
 	}
 
 	/* Copy this pointer as we are gonna need it in the release phase */
diff --git a/drivers/media/usb/dvb-usb/cinergyT2-fe.c b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
index b3ec743a7a2e..93f0cae36d1f 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
@@ -219,8 +219,8 @@ static int cinergyt2_fe_read_signal_strength(struct dvb_frontend *fe,
 	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (char *)&status,
 				sizeof(status), 0);
 	if (ret < 0) {
-		err("cinergyt2_fe_read_signal_strength() Failed!"
-			" (Error=%d)\n", ret);
+		err("cinergyt2_fe_read_signal_strength() Failed! (Error=%d)\n",
+		    ret);
 		return ret;
 	}
 	*strength = (0xffff - le16_to_cpu(status.gain));
diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index f3196658fb70..855cfc7bf309 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -16,10 +16,7 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info,2=fw,4=fwdata,8=data (or-ab
 static int nb_packet_buffer_size = 21;
 module_param(nb_packet_buffer_size, int, 0644);
 MODULE_PARM_DESC(nb_packet_buffer_size,
-	"Set the dib0700 driver data buffer size. This parameter "
-	"corresponds to the number of TS packets. The actual size of "
-	"the data buffer corresponds to this parameter "
-	"multiplied by 188 (default: 21)");
+	"Set the dib0700 driver data buffer size. This parameter corresponds to the number of TS packets. The actual size of the data buffer corresponds to this parameter multiplied by 188 (default: 21)");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 0857b56e652c..5668d8d69917 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -26,8 +26,7 @@
 
 static int force_lna_activation;
 module_param(force_lna_activation, int, 0644);
-MODULE_PARM_DESC(force_lna_activation, "force the activation of Low-Noise-Amplifyer(s) (LNA), "
-		"if applicable for the device (default: 0=automatic/off).");
+MODULE_PARM_DESC(force_lna_activation, "force the activation of Low-Noise-Amplifyer(s) (LNA), if applicable for the device (default: 0=automatic/off).");
 
 struct dib0700_adapter_state {
 	int (*set_param_save) (struct dvb_frontend *);
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index a04c0a250625..e5675da286cb 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -277,8 +277,7 @@ int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
 	for (i = 0; i < adap->props.num_frontends; i++) {
 
 		if (adap->props.fe[i].frontend_attach == NULL) {
-			err("strange: '%s' #%d,%d "
-			    "doesn't want to attach a frontend.",
+			err("strange: '%s' #%d,%d doesn't want to attach a frontend.",
 			    adap->dev->desc->name, adap->id, i);
 
 			return 0;
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
index dd048a7c461c..f0023dbb7276 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
@@ -49,8 +49,7 @@ int usb_cypress_load_firmware(struct usb_device *udev, const struct firmware *fw
 		ret = usb_cypress_writemem(udev,hx.addr,hx.data,hx.len);
 
 		if (ret != hx.len) {
-			err("error while transferring firmware "
-				"(transferred size: %d, block size: %d)",
+			err("error while transferring firmware (transferred size: %d, block size: %d)",
 				ret,hx.len);
 			ret = -EINVAL;
 			break;
@@ -81,8 +80,7 @@ int dvb_usb_download_firmware(struct usb_device *udev, struct dvb_usb_device_pro
 	const struct firmware *fw = NULL;
 
 	if ((ret = request_firmware(&fw, props->firmware, &udev->dev)) != 0) {
-		err("did not find the firmware file. (%s) "
-			"Please see linux/Documentation/dvb/ for more details on firmware-problems. (%d)",
+		err("did not find the firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems. (%d)",
 			props->firmware,ret);
 		return ret;
 	}
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 5fb0c650926e..008d71905f2e 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -86,8 +86,7 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info 2=xfer 4=rc(or-able))."
 /* demod probe */
 static int demod_probe = 1;
 module_param_named(demod, demod_probe, int, 0644);
-MODULE_PARM_DESC(demod, "demod to probe (1=cx24116 2=stv0903+stv6110 "
-			"4=stv0903+stb6100(or-able)).");
+MODULE_PARM_DESC(demod, "demod to probe (1=cx24116 2=stv0903+stv6110 4=stv0903+stb6100(or-able)).");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -2343,12 +2342,7 @@ static struct usb_driver dw2102_driver = {
 module_usb_driver(dw2102_driver);
 
 MODULE_AUTHOR("Igor M. Liplianin (c) liplianin@me.by");
-MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104,"
-			" DVB-C 3101 USB2.0,"
-			" TeVii S421, S480, S482, S600, S630, S632, S650,"
-			" TeVii S660, S662, Prof 1100, 7500 USB2.0,"
-			" Geniatech SU3000, T220,"
-			" TechnoTrend S2-4600, Terratec Cinergy S2 devices");
+MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104, DVB-C 3101 USB2.0, TeVii S421, S480, S482, S600, S630, S632, S650, TeVii S660, S662, Prof 1100, 7500 USB2.0, Geniatech SU3000, T220, TechnoTrend S2-4600, Terratec Cinergy S2 devices");
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(DW2101_FIRMWARE);
diff --git a/drivers/media/usb/dvb-usb/friio.c b/drivers/media/usb/dvb-usb/friio.c
index 474a17e4db0c..62abe6c43a32 100644
--- a/drivers/media/usb/dvb-usb/friio.c
+++ b/drivers/media/usb/dvb-usb/friio.c
@@ -320,8 +320,8 @@ static int friio_initialize(struct dvb_usb_device *d)
  */
 	if (rbuf[0] & 0x80) {	/* still in PowerOnReset state? */
 		if (++retry > 3) {
-			deb_info("failed to get the correct"
-				 " FE demod status:0x%02x\n", rbuf[0]);
+			deb_info("failed to get the correct FE demod status:0x%02x\n",
+				 rbuf[0]);
 			goto error;
 		}
 		msleep(100);
diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
index 5d0384dd45b5..1587dc7c4eb3 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -117,8 +117,7 @@ static int gp8psk_load_bcm4500fw(struct dvb_usb_device *d)
 	u8 *buf;
 	if ((ret = request_firmware(&fw, bcm4500_firmware,
 					&d->udev->dev)) != 0) {
-		err("did not find the bcm4500 firmware file. (%s) "
-			"Please see linux/Documentation/dvb/ for more details on firmware-problems. (%d)",
+		err("did not find the bcm4500 firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems. (%d)",
 			bcm4500_firmware,ret);
 		return ret;
 	}
diff --git a/drivers/media/usb/dvb-usb/opera1.c b/drivers/media/usb/dvb-usb/opera1.c
index 2566d2f1c2ad..946a5ccc8f1a 100644
--- a/drivers/media/usb/dvb-usb/opera1.c
+++ b/drivers/media/usb/dvb-usb/opera1.c
@@ -453,8 +453,7 @@ static int opera1_xilinx_load_firmware(struct usb_device *dev,
 	info("start downloading fpga firmware %s",filename);
 
 	if ((ret = request_firmware(&fw, filename, &dev->dev)) != 0) {
-		err("did not find the firmware file. (%s) "
-			"Please see linux/Documentation/dvb/ for more details on firmware-problems.",
+		err("did not find the firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems.",
 			filename);
 		return ret;
 	} else {
diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index c05de1b088a4..56484da1d428 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -446,8 +446,7 @@ static int pctv452e_i2c_msg(struct dvb_usb_device *d, u8 addr,
 	return rcv_len;
 
 failed:
-	err("I2C error %d; %02X %02X  %02X %02X %02X -> "
-	     "%02X %02X  %02X %02X %02X.",
+	err("I2C error %d; %02X %02X  %02X %02X %02X -> %02X %02X  %02X %02X %02X.",
 	     ret, SYNC_BYTE_OUT, id, addr << 1, snd_len, rcv_len,
 	     buf[0], buf[1], buf[4], buf[5], buf[6]);
 
diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index d9f3262bf071..fbfcabc52f76 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -50,8 +50,7 @@ MODULE_PARM_DESC(debug,
 static int disable_led_control;
 module_param(disable_led_control, int, 0444);
 MODULE_PARM_DESC(disable_led_control,
-		"disable LED control of the device "
-		"(default: 0 - LED control is active).");
+		"disable LED control of the device (default: 0 - LED control is active).");
 
 /* device private data */
 struct technisat_usb2_state {
-- 
2.7.4


