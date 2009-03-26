Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate05.web.de ([217.72.192.243])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <no_bs@web.de>) id 1LmzVg-0007cR-Lt
	for linux-dvb@linuxtv.org; Fri, 27 Mar 2009 01:01:21 +0100
Received: from web.de
	by fmmailgate05.web.de (Postfix) with SMTP id 876FC5B2AB44
	for <linux-dvb@linuxtv.org>; Thu, 26 Mar 2009 20:02:40 +0100 (CET)
Date: Thu, 26 Mar 2009 20:02:40 +0100
Message-Id: <1619240981@web.de>
MIME-Version: 1.0
From: =?iso-8859-15?Q?Bernd_Strau=DF?= <no_bs@web.de>
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed;
 boundary="=-------------1238094160564059109"
Subject: [linux-dvb] Patch: IR-support for Tevii s460
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--=-------------1238094160564059109
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

The remote control which comes with this card doesn't work out of the box.=

This patch changes that. Works with LIRC and /dev/input/eventX.

=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F
DSL zum Nulltarif + 20 Euro Extrapr=E4mie bei Online-Bestellung =FCber die
DSL Freundschaftswerbung! http://dsl.web.de/=3Fac=3DOM.AD.AD008K15279B7069a


--=-------------1238094160564059109
Content-Type: text/x-patch;
 name="ir-remote-tevii-s460.patch"
Content-Disposition: attachment;
 filename="ir-remote-tevii-s460.patch"
Content-Transfer-Encoding: 7bit

diff -r -U 6 v4l-dvb/linux/drivers/media/common/ir-keymaps.c patched-v4l-dvb/linux/drivers/media/common/ir-keymaps.c
--- v4l-dvb/linux/drivers/media/common/ir-keymaps.c	2009-03-25 18:27:24.929354799 +0100
+++ patched-v4l-dvb/linux/drivers/media/common/ir-keymaps.c	2009-03-26 19:23:12.953686930 +0100
@@ -2797,6 +2797,60 @@
 	[0x06] = KEY_S,		/*stop*/
 	[0x40] = KEY_F,		/*full*/
 	[0x1e] = KEY_W,		/*tvmode*/
 	[0x1b] = KEY_B,		/*recall*/
 };
 EXPORT_SYMBOL_GPL(ir_codes_dm1105_nec);
+
+/* TeVii S460 DVB-S/S2 */
+IR_KEYTAB_TYPE ir_codes_tevii_s460[IR_KEYTAB_SIZE] = {
+	[0x0a] = KEY_POWER,
+	[0x0c] = KEY_MUTE,
+	[0x11] = KEY_1,
+	[0x12] = KEY_2,
+	[0x13] = KEY_3,
+	[0x14] = KEY_4,
+	[0x15] = KEY_5,
+	[0x16] = KEY_6,
+	[0x17] = KEY_7,
+	[0x18] = KEY_8,
+	[0x19] = KEY_9,
+	[0x1a] = KEY_LAST,		/* 'recall' / 'event info' */
+	[0x10] = KEY_0,
+	[0x1b] = KEY_FAVORITES,
+
+	[0x09] = KEY_VOLUMEUP,
+	[0x0f] = KEY_VOLUMEDOWN,
+	[0x05] = KEY_TUNER,		/* 'live mode' */
+	[0x07] = KEY_PVR,		/* 'play mode' */
+	[0x08] = KEY_CHANNELUP,
+	[0x06] = KEY_CHANNELDOWN,
+	[0x00] = KEY_UP,
+	[0x03] = KEY_LEFT,
+	[0x1f] = KEY_OK,	
+	[0x02] = KEY_RIGHT,
+	[0x01] = KEY_DOWN,
+	[0x1c] = KEY_MENU,
+	[0x1d] = KEY_BACK,
+
+	[0x40] = KEY_PLAYPAUSE,
+	[0x1e] = KEY_REWIND,		/* '<<' */
+	[0x4d] = KEY_FASTFORWARD,	/* '>>' */
+	[0x44] = KEY_EPG,
+	[0x04] = KEY_RECORD,
+	[0x0b] = KEY_TIME,		/* 'timer' */
+	[0x0e] = KEY_OPEN,
+	[0x4c] = KEY_INFO,
+	[0x41] = KEY_AB,		/* 'A/B' */
+	[0x43] = KEY_AUDIO,
+	[0x45] = KEY_SUBTITLE,
+	[0x4a] = KEY_LIST,
+	[0x46] = KEY_F1,		/* 'F1' / 'satellite' */
+	[0x47] = KEY_F2,		/* 'F2' / 'provider' */
+	[0x5e] = KEY_F3,		/* 'F3' / 'transp' */
+	[0x5c] = KEY_F4,		/* 'F4' / 'favorites' */
+	[0x52] = KEY_F5,		/* 'F5' / 'all' */
+	[0x5a] = KEY_F6,
+	[0x56] = KEY_SWITCHVIDEOMODE,	/* 'mon' */
+	[0x58] = KEY_ZOOM,		/* 'FS' */
+};
+EXPORT_SYMBOL_GPL(ir_codes_tevii_s460);
diff -r -U 6 v4l-dvb/linux/drivers/media/video/cx88/cx88-input.c patched-v4l-dvb/linux/drivers/media/video/cx88/cx88-input.c
--- v4l-dvb/linux/drivers/media/video/cx88/cx88-input.c	2009-03-25 18:27:33.595354385 +0100
+++ patched-v4l-dvb/linux/drivers/media/video/cx88/cx88-input.c	2009-03-25 18:28:27.585354216 +0100
@@ -327,12 +327,17 @@
 	case CX88_BOARD_POWERCOLOR_REAL_ANGEL:
 		ir_codes = ir_codes_powercolor_real_angel;
 		ir->gpio_addr = MO_GP2_IO;
 		ir->mask_keycode = 0x7e;
 		ir->polling = 100; /* ms */
 		break;
+	case CX88_BOARD_TEVII_S460:
+		ir_codes = ir_codes_tevii_s460;
+		ir_type = IR_TYPE_PD;
+		ir->sampling = 0xff00; /* address */
+		break;
 	}
 
 	if (NULL == ir_codes) {
 		err = -ENODEV;
 		goto err_out_free;
 	}
@@ -433,12 +438,13 @@
 		ir_dump_samples(ir->samples, ir->scount);
 
 	/* decode it */
 	switch (core->boardnr) {
 	case CX88_BOARD_TERRATEC_CINERGY_1400_DVB_T1:
 	case CX88_BOARD_DNTV_LIVE_DVB_T_PRO:
+	case CX88_BOARD_TEVII_S460:
 		ircode = ir_decode_pulsedistance(ir->samples, ir->scount, 1, 4);
 
 		if (ircode == 0xffffffff) { /* decoding error */
 			ir_dprintk("pulse distance decoding error\n");
 			break;
 		}
diff -r -U 6 v4l-dvb/linux/include/media/ir-common.h patched-v4l-dvb/linux/include/media/ir-common.h
--- v4l-dvb/linux/include/media/ir-common.h	2009-03-25 18:27:39.310350866 +0100
+++ patched-v4l-dvb/linux/include/media/ir-common.h	2009-03-25 18:28:27.585354216 +0100
@@ -159,12 +159,13 @@
 extern IR_KEYTAB_TYPE ir_codes_real_audio_220_32_keys[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_msi_tvanywhere_plus[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_ati_tv_wonder_hd_600[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_kworld_plus_tv_analog[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_kaiomy[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_dm1105_nec[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_tevii_s460[IR_KEYTAB_SIZE];
 #endif
 
 /*
  * Local variables:
  * c-basic-offset: 8
  * End:

--=-------------1238094160564059109
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-------------1238094160564059109--
