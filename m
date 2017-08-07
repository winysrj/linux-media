Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:46365 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751930AbdHGUVF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 16:21:05 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/6] [media] rc: rename RC_TYPE_* to RC_PROTO_* and RC_BIT_* to RC_PROTO_BIT_*
Date: Mon,  7 Aug 2017 21:20:58 +0100
Message-Id: <98d93968b26e9fcdbc3afba4e8354f44f9188c9f.1502137028.git.sean@mess.org>
In-Reply-To: <cover.1502137028.git.sean@mess.org>
References: <cover.1502137028.git.sean@mess.org>
In-Reply-To: <cover.1502137028.git.sean@mess.org>
References: <cover.1502137028.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RC_TYPE is confusing and it's just the protocol. So rename it.

Suggested-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/hid/hid-picolcd_cir.c                      |   2 +-
 drivers/media/cec/cec-adap.c                       |   6 +-
 drivers/media/cec/cec-core.c                       |   2 +-
 drivers/media/common/siano/smsir.c                 |   2 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |  57 +++---
 drivers/media/pci/bt8xx/bttv-input.c               |  16 +-
 drivers/media/pci/cx18/cx18-i2c.c                  |   4 +-
 drivers/media/pci/cx23885/cx23885-input.c          |  14 +-
 drivers/media/pci/cx88/cx88-input.c                |  28 +--
 drivers/media/pci/dm1105/dm1105.c                  |   2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                  |  14 +-
 drivers/media/pci/mantis/mantis_input.c            |   2 +-
 drivers/media/pci/saa7134/saa7134-input.c          |  44 +++--
 drivers/media/pci/smipcie/smipcie-ir.c             |   2 +-
 drivers/media/pci/ttpci/budget-ci.c                |   5 +-
 drivers/media/rc/ati_remote.c                      |   5 +-
 drivers/media/rc/ene_ir.c                          |   2 +-
 drivers/media/rc/fintek-cir.c                      |   2 +-
 drivers/media/rc/gpio-ir-recv.c                    |   2 +-
 drivers/media/rc/igorplugusb.c                     |   9 +-
 drivers/media/rc/iguanair.c                        |   2 +-
 drivers/media/rc/img-ir/img-ir-hw.c                |   4 +-
 drivers/media/rc/img-ir/img-ir-hw.h                |   4 +-
 drivers/media/rc/img-ir/img-ir-jvc.c               |   4 +-
 drivers/media/rc/img-ir/img-ir-nec.c               |  20 +-
 drivers/media/rc/img-ir/img-ir-rc5.c               |   4 +-
 drivers/media/rc/img-ir/img-ir-rc6.c               |   4 +-
 drivers/media/rc/img-ir/img-ir-sanyo.c             |   4 +-
 drivers/media/rc/img-ir/img-ir-sharp.c             |   4 +-
 drivers/media/rc/img-ir/img-ir-sony.c              |  27 +--
 drivers/media/rc/imon.c                            |  49 ++---
 drivers/media/rc/ir-hix5hd2.c                      |   2 +-
 drivers/media/rc/ir-jvc-decoder.c                  |   6 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |   6 +-
 drivers/media/rc/ir-nec-decoder.c                  |  17 +-
 drivers/media/rc/ir-rc5-decoder.c                  |  25 +--
 drivers/media/rc/ir-rc6-decoder.c                  |  30 +--
 drivers/media/rc/ir-sanyo-decoder.c                |   6 +-
 drivers/media/rc/ir-sharp-decoder.c                |   6 +-
 drivers/media/rc/ir-sony-decoder.c                 |  23 +--
 drivers/media/rc/ir-xmp-decoder.c                  |   4 +-
 drivers/media/rc/ite-cir.c                         |   2 +-
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c    |   8 +-
 drivers/media/rc/keymaps/rc-alink-dtu-m.c          |   8 +-
 drivers/media/rc/keymaps/rc-anysee.c               |   8 +-
 drivers/media/rc/keymaps/rc-apac-viewcomp.c        |   8 +-
 drivers/media/rc/keymaps/rc-asus-pc39.c            |   8 +-
 drivers/media/rc/keymaps/rc-asus-ps3-100.c         |   8 +-
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c |   8 +-
 drivers/media/rc/keymaps/rc-ati-x10.c              |   8 +-
 drivers/media/rc/keymaps/rc-avermedia-a16d.c       |   8 +-
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c    |   8 +-
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c       |   8 +-
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      |   8 +-
 .../media/rc/keymaps/rc-avermedia-m733a-rm-k6.c    |   8 +-
 drivers/media/rc/keymaps/rc-avermedia-rm-ks.c      |   8 +-
 drivers/media/rc/keymaps/rc-avermedia.c            |   8 +-
 drivers/media/rc/keymaps/rc-avertv-303.c           |   8 +-
 drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c   |   8 +-
 drivers/media/rc/keymaps/rc-behold-columbus.c      |   8 +-
 drivers/media/rc/keymaps/rc-behold.c               |   8 +-
 drivers/media/rc/keymaps/rc-budget-ci-old.c        |   8 +-
 drivers/media/rc/keymaps/rc-cec.c                  |   2 +-
 drivers/media/rc/keymaps/rc-cinergy-1400.c         |   8 +-
 drivers/media/rc/keymaps/rc-cinergy.c              |   8 +-
 drivers/media/rc/keymaps/rc-d680-dmb.c             |   8 +-
 drivers/media/rc/keymaps/rc-delock-61959.c         |   8 +-
 drivers/media/rc/keymaps/rc-dib0700-nec.c          |   8 +-
 drivers/media/rc/keymaps/rc-dib0700-rc5.c          |   8 +-
 drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c  |   8 +-
 drivers/media/rc/keymaps/rc-digittrade.c           |   8 +-
 drivers/media/rc/keymaps/rc-dm1105-nec.c           |   8 +-
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c      |   8 +-
 drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c   |   8 +-
 drivers/media/rc/keymaps/rc-dtt200u.c              |   8 +-
 drivers/media/rc/keymaps/rc-dvbsky.c               |   8 +-
 drivers/media/rc/keymaps/rc-dvico-mce.c            |   8 +-
 drivers/media/rc/keymaps/rc-dvico-portable.c       |   8 +-
 drivers/media/rc/keymaps/rc-em-terratec.c          |   8 +-
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c    |   8 +-
 drivers/media/rc/keymaps/rc-encore-enltv.c         |   8 +-
 drivers/media/rc/keymaps/rc-encore-enltv2.c        |   8 +-
 drivers/media/rc/keymaps/rc-evga-indtube.c         |   8 +-
 drivers/media/rc/keymaps/rc-eztv.c                 |   8 +-
 drivers/media/rc/keymaps/rc-flydvb.c               |   8 +-
 drivers/media/rc/keymaps/rc-flyvideo.c             |   8 +-
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c       |   8 +-
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c        |   8 +-
 drivers/media/rc/keymaps/rc-geekbox.c              |   8 +-
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c   |   8 +-
 drivers/media/rc/keymaps/rc-gotview7135.c          |   8 +-
 drivers/media/rc/keymaps/rc-hauppauge.c            |   8 +-
 drivers/media/rc/keymaps/rc-imon-mce.c             |   8 +-
 drivers/media/rc/keymaps/rc-imon-pad.c             |   8 +-
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c        |   8 +-
 drivers/media/rc/keymaps/rc-it913x-v1.c            |   8 +-
 drivers/media/rc/keymaps/rc-it913x-v2.c            |   8 +-
 drivers/media/rc/keymaps/rc-kaiomy.c               |   8 +-
 drivers/media/rc/keymaps/rc-kworld-315u.c          |   8 +-
 drivers/media/rc/keymaps/rc-kworld-pc150u.c        |   8 +-
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |   8 +-
 drivers/media/rc/keymaps/rc-leadtek-y04g0051.c     |   8 +-
 drivers/media/rc/keymaps/rc-lme2510.c              |   8 +-
 drivers/media/rc/keymaps/rc-manli.c                |   8 +-
 .../media/rc/keymaps/rc-medion-x10-digitainer.c    |   8 +-
 drivers/media/rc/keymaps/rc-medion-x10-or2x.c      |   8 +-
 drivers/media/rc/keymaps/rc-medion-x10.c           |   8 +-
 drivers/media/rc/keymaps/rc-msi-digivox-ii.c       |   8 +-
 drivers/media/rc/keymaps/rc-msi-digivox-iii.c      |   8 +-
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c  |   8 +-
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c       |   8 +-
 drivers/media/rc/keymaps/rc-nebula.c               |   8 +-
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  |   8 +-
 drivers/media/rc/keymaps/rc-norwood.c              |   8 +-
 drivers/media/rc/keymaps/rc-npgtech.c              |   8 +-
 drivers/media/rc/keymaps/rc-pctv-sedna.c           |   8 +-
 drivers/media/rc/keymaps/rc-pinnacle-color.c       |   8 +-
 drivers/media/rc/keymaps/rc-pinnacle-grey.c        |   8 +-
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c     |   8 +-
 drivers/media/rc/keymaps/rc-pixelview-002t.c       |   8 +-
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       |   8 +-
 drivers/media/rc/keymaps/rc-pixelview-new.c        |   8 +-
 drivers/media/rc/keymaps/rc-pixelview.c            |   8 +-
 .../media/rc/keymaps/rc-powercolor-real-angel.c    |   8 +-
 drivers/media/rc/keymaps/rc-proteus-2309.c         |   8 +-
 drivers/media/rc/keymaps/rc-purpletv.c             |   8 +-
 drivers/media/rc/keymaps/rc-pv951.c                |   8 +-
 drivers/media/rc/keymaps/rc-rc6-mce.c              |   8 +-
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   |   8 +-
 drivers/media/rc/keymaps/rc-reddo.c                |   8 +-
 drivers/media/rc/keymaps/rc-snapstream-firefly.c   |   8 +-
 drivers/media/rc/keymaps/rc-streamzap.c            |   8 +-
 drivers/media/rc/keymaps/rc-su3000.c               |   8 +-
 drivers/media/rc/keymaps/rc-tbs-nec.c              |   8 +-
 drivers/media/rc/keymaps/rc-technisat-ts35.c       |   8 +-
 drivers/media/rc/keymaps/rc-technisat-usb2.c       |   8 +-
 .../media/rc/keymaps/rc-terratec-cinergy-c-pci.c   |   8 +-
 .../media/rc/keymaps/rc-terratec-cinergy-s2-hd.c   |   8 +-
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c  |   8 +-
 drivers/media/rc/keymaps/rc-terratec-slim-2.c      |   8 +-
 drivers/media/rc/keymaps/rc-terratec-slim.c        |   8 +-
 drivers/media/rc/keymaps/rc-tevii-nec.c            |   8 +-
 drivers/media/rc/keymaps/rc-tivo.c                 |   8 +-
 .../media/rc/keymaps/rc-total-media-in-hand-02.c   |   8 +-
 drivers/media/rc/keymaps/rc-total-media-in-hand.c  |   8 +-
 drivers/media/rc/keymaps/rc-trekstor.c             |   8 +-
 drivers/media/rc/keymaps/rc-tt-1500.c              |   8 +-
 drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c   |   8 +-
 drivers/media/rc/keymaps/rc-twinhan1027.c          |   8 +-
 drivers/media/rc/keymaps/rc-videomate-m1f.c        |   8 +-
 drivers/media/rc/keymaps/rc-videomate-s350.c       |   8 +-
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c     |   8 +-
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c |   8 +-
 drivers/media/rc/keymaps/rc-winfast.c              |   8 +-
 drivers/media/rc/keymaps/rc-zx-irdec.c             |   2 +-
 drivers/media/rc/mceusb.c                          |   2 +-
 drivers/media/rc/meson-ir.c                        |   2 +-
 drivers/media/rc/mtk-cir.c                         |   2 +-
 drivers/media/rc/nuvoton-cir.c                     |   4 +-
 drivers/media/rc/rc-core-priv.h                    |   2 +-
 drivers/media/rc/rc-ir-raw.c                       |   4 +-
 drivers/media/rc/rc-loopback.c                     |   4 +-
 drivers/media/rc/rc-main.c                         | 190 +++++++++---------
 drivers/media/rc/redrat3.c                         |   2 +-
 drivers/media/rc/serial_ir.c                       |   2 +-
 drivers/media/rc/sir_ir.c                          |   2 +-
 drivers/media/rc/st_rc.c                           |   2 +-
 drivers/media/rc/streamzap.c                       |   2 +-
 drivers/media/rc/sunxi-cir.c                       |   2 +-
 drivers/media/rc/ttusbir.c                         |   2 +-
 drivers/media/rc/winbond-cir.c                     |  33 ++--
 drivers/media/rc/zx-irdec.c                        |   9 +-
 drivers/media/usb/au0828/au0828-input.c            |   4 +-
 drivers/media/usb/cx231xx/cx231xx-input.c          |   6 +-
 drivers/media/usb/dvb-usb-v2/af9015.c              |  11 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |  14 +-
 drivers/media/usb/dvb-usb-v2/anysee.c              |   4 +-
 drivers/media/usb/dvb-usb-v2/az6007.c              |  11 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |   2 +-
 drivers/media/usb/dvb-usb-v2/dvbsky.c              |   4 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |   6 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |  13 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |  30 +--
 drivers/media/usb/dvb-usb/dib0700.h                |   2 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |  28 +--
 drivers/media/usb/dvb-usb/dib0700_devices.c        | 152 +++++++--------
 drivers/media/usb/dvb-usb/dtt200u.c                |  12 +-
 drivers/media/usb/dvb-usb/dvb-usb.h                |   2 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |  21 +-
 drivers/media/usb/dvb-usb/m920x.c                  |   4 +-
 drivers/media/usb/dvb-usb/pctv452e.c               |   6 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         |   2 +-
 drivers/media/usb/dvb-usb/ttusb2.c                 |   4 +-
 drivers/media/usb/em28xx/em28xx-input.c            | 124 ++++++------
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |   3 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |  10 +-
 drivers/media/usb/tm6000/tm6000-input.c            |  38 ++--
 include/media/i2c/ir-kbd-i2c.h                     |   8 +-
 include/media/rc-core.h                            |  33 ++--
 include/media/rc-map.h                             | 215 +++++++++++----------
 200 files changed, 1223 insertions(+), 1177 deletions(-)

diff --git a/drivers/hid/hid-picolcd_cir.c b/drivers/hid/hid-picolcd_cir.c
index b3b2233f3c65..32747b7f917e 100644
--- a/drivers/hid/hid-picolcd_cir.c
+++ b/drivers/hid/hid-picolcd_cir.c
@@ -113,7 +113,7 @@ int picolcd_init_cir(struct picolcd_data *data, struct hid_report *report)
 		return -ENOMEM;
 
 	rdev->priv             = data;
-	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	rdev->open             = picolcd_cir_open;
 	rdev->close            = picolcd_cir_close;
 	rdev->device_name      = data->hdev->name;
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 1a021828c8d4..9ab7fd37f6ec 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1854,10 +1854,10 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		 */
 		case 0x60:
 			if (msg->len == 2)
-				rc_keydown(adap->rc, RC_TYPE_CEC,
+				rc_keydown(adap->rc, RC_PROTO_CEC,
 					   msg->msg[2], 0);
 			else
-				rc_keydown(adap->rc, RC_TYPE_CEC,
+				rc_keydown(adap->rc, RC_PROTO_CEC,
 					   msg->msg[2] << 8 | msg->msg[3], 0);
 			break;
 		/*
@@ -1873,7 +1873,7 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		case 0x67: case 0x68: case 0x69: case 0x6a:
 			break;
 		default:
-			rc_keydown(adap->rc, RC_TYPE_CEC, msg->msg[2], 0);
+			rc_keydown(adap->rc, RC_PROTO_CEC, msg->msg[2], 0);
 			break;
 		}
 #endif
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index efb7bbbc941f..3b69c64c948c 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -275,7 +275,7 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	adap->rc->input_id.product = 0;
 	adap->rc->input_id.version = 1;
 	adap->rc->driver_name = CEC_NAME;
-	adap->rc->allowed_protocols = RC_BIT_CEC;
+	adap->rc->allowed_protocols = RC_PROTO_BIT_CEC;
 	adap->rc->priv = adap;
 	adap->rc->map_name = RC_MAP_CEC;
 	adap->rc->timeout = MS_TO_NS(100);
diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
index 941c342896cc..e77bb0c95e69 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -86,7 +86,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 #endif
 
 	dev->priv = coredev;
-	dev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	dev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	dev->map_name = sms_get_board(board_id)->rc_codes;
 	dev->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index af909bf5dd5b..a374e2a0ac3d 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -59,8 +59,8 @@ module_param(debug, int, 0644);    /* debug level (0,1,2) */
 
 /* ----------------------------------------------------------------------- */
 
-static int get_key_haup_common(struct IR_i2c *ir, enum rc_type *protocol,
-					u32 *scancode, u8 *ptoggle, int size)
+static int get_key_haup_common(struct IR_i2c *ir, enum rc_proto *protocol,
+			       u32 *scancode, u8 *ptoggle, int size)
 {
 	unsigned char buf[6];
 	int start, range, toggle, dev, code, ircode, vendor;
@@ -99,7 +99,7 @@ static int get_key_haup_common(struct IR_i2c *ir, enum rc_type *protocol,
 		dprintk(1, "ir hauppauge (rc5): s%d r%d t%d dev=%d code=%d\n",
 			start, range, toggle, dev, code);
 
-		*protocol = RC_TYPE_RC5;
+		*protocol = RC_PROTO_RC5;
 		*scancode = RC_SCANCODE_RC5(dev, code);
 		*ptoggle = toggle;
 
@@ -111,13 +111,13 @@ static int get_key_haup_common(struct IR_i2c *ir, enum rc_type *protocol,
 
 		if (vendor == 0x800f) {
 			*ptoggle = (dev & 0x80) != 0;
-			*protocol = RC_TYPE_RC6_MCE;
+			*protocol = RC_PROTO_RC6_MCE;
 			dev &= 0x7f;
 			dprintk(1, "ir hauppauge (rc6-mce): t%d vendor=%d dev=%d code=%d\n",
 						*ptoggle, vendor, dev, code);
 		} else {
 			*ptoggle = 0;
-			*protocol = RC_TYPE_RC6_6A_32;
+			*protocol = RC_PROTO_RC6_6A_32;
 			dprintk(1, "ir hauppauge (rc6-6a-32): vendor=%d dev=%d code=%d\n",
 							vendor, dev, code);
 		}
@@ -130,13 +130,13 @@ static int get_key_haup_common(struct IR_i2c *ir, enum rc_type *protocol,
 	return 0;
 }
 
-static int get_key_haup(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_haup(struct IR_i2c *ir, enum rc_proto *protocol,
 			u32 *scancode, u8 *toggle)
 {
 	return get_key_haup_common(ir, protocol, scancode, toggle, 3);
 }
 
-static int get_key_haup_xvr(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_haup_xvr(struct IR_i2c *ir, enum rc_proto *protocol,
 			    u32 *scancode, u8 *toggle)
 {
 	int ret;
@@ -155,7 +155,7 @@ static int get_key_haup_xvr(struct IR_i2c *ir, enum rc_type *protocol,
 	return get_key_haup_common(ir, protocol, scancode, toggle, 6);
 }
 
-static int get_key_pixelview(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_pixelview(struct IR_i2c *ir, enum rc_proto *protocol,
 			     u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
@@ -166,13 +166,13 @@ static int get_key_pixelview(struct IR_i2c *ir, enum rc_type *protocol,
 		return -EIO;
 	}
 
-	*protocol = RC_TYPE_OTHER;
+	*protocol = RC_PROTO_OTHER;
 	*scancode = b;
 	*toggle = 0;
 	return 1;
 }
 
-static int get_key_fusionhdtv(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_fusionhdtv(struct IR_i2c *ir, enum rc_proto *protocol,
 			      u32 *scancode, u8 *toggle)
 {
 	unsigned char buf[4];
@@ -191,13 +191,13 @@ static int get_key_fusionhdtv(struct IR_i2c *ir, enum rc_type *protocol,
 	if(buf[0] != 0x1 ||  buf[1] != 0xfe)
 		return 0;
 
-	*protocol = RC_TYPE_UNKNOWN;
+	*protocol = RC_PROTO_UNKNOWN;
 	*scancode = buf[2];
 	*toggle = 0;
 	return 1;
 }
 
-static int get_key_knc1(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_knc1(struct IR_i2c *ir, enum rc_proto *protocol,
 			u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
@@ -221,13 +221,13 @@ static int get_key_knc1(struct IR_i2c *ir, enum rc_type *protocol,
 		/* keep old data */
 		return 1;
 
-	*protocol = RC_TYPE_UNKNOWN;
+	*protocol = RC_PROTO_UNKNOWN;
 	*scancode = b;
 	*toggle = 0;
 	return 1;
 }
 
-static int get_key_avermedia_cardbus(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_avermedia_cardbus(struct IR_i2c *ir, enum rc_proto *protocol,
 				     u32 *scancode, u8 *toggle)
 {
 	unsigned char subaddr, key, keygroup;
@@ -262,7 +262,7 @@ static int get_key_avermedia_cardbus(struct IR_i2c *ir, enum rc_type *protocol,
 	}
 	key |= (keygroup & 1) << 6;
 
-	*protocol = RC_TYPE_UNKNOWN;
+	*protocol = RC_PROTO_UNKNOWN;
 	*scancode = key;
 	if (ir->c->addr == 0x41) /* AVerMedia EM78P153 */
 		*scancode |= keygroup << 8;
@@ -274,7 +274,7 @@ static int get_key_avermedia_cardbus(struct IR_i2c *ir, enum rc_type *protocol,
 
 static int ir_key_poll(struct IR_i2c *ir)
 {
-	enum rc_type protocol;
+	enum rc_proto protocol;
 	u32 scancode;
 	u8 toggle;
 	int rc;
@@ -315,7 +315,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	char *ir_codes = NULL;
 	const char *name = NULL;
-	u64 rc_type = RC_BIT_UNKNOWN;
+	u64 rc_proto = RC_PROTO_BIT_UNKNOWN;
 	struct IR_i2c *ir;
 	struct rc_dev *rc = NULL;
 	struct i2c_adapter *adap = client->adapter;
@@ -334,7 +334,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	case 0x64:
 		name        = "Pixelview";
 		ir->get_key = get_key_pixelview;
-		rc_type     = RC_BIT_OTHER;
+		rc_proto    = RC_PROTO_BIT_OTHER;
 		ir_codes    = RC_MAP_EMPTY;
 		break;
 	case 0x18:
@@ -342,38 +342,39 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	case 0x1a:
 		name        = "Hauppauge";
 		ir->get_key = get_key_haup;
-		rc_type     = RC_BIT_RC5;
+		rc_proto    = RC_PROTO_BIT_RC5;
 		ir_codes    = RC_MAP_HAUPPAUGE;
 		break;
 	case 0x30:
 		name        = "KNC One";
 		ir->get_key = get_key_knc1;
-		rc_type     = RC_BIT_OTHER;
+		rc_proto    = RC_PROTO_BIT_OTHER;
 		ir_codes    = RC_MAP_EMPTY;
 		break;
 	case 0x6b:
 		name        = "FusionHDTV";
 		ir->get_key = get_key_fusionhdtv;
-		rc_type     = RC_BIT_UNKNOWN;
+		rc_proto    = RC_PROTO_BIT_UNKNOWN;
 		ir_codes    = RC_MAP_FUSIONHDTV_MCE;
 		break;
 	case 0x40:
 		name        = "AVerMedia Cardbus remote";
 		ir->get_key = get_key_avermedia_cardbus;
-		rc_type     = RC_BIT_OTHER;
+		rc_proto    = RC_PROTO_BIT_OTHER;
 		ir_codes    = RC_MAP_AVERMEDIA_CARDBUS;
 		break;
 	case 0x41:
 		name        = "AVerMedia EM78P153";
 		ir->get_key = get_key_avermedia_cardbus;
-		rc_type     = RC_BIT_OTHER;
+		rc_proto    = RC_PROTO_BIT_OTHER;
 		/* RM-KV remote, seems to be same as RM-K6 */
 		ir_codes    = RC_MAP_AVERMEDIA_M733A_RM_K6;
 		break;
 	case 0x71:
 		name        = "Hauppauge/Zilog Z8";
 		ir->get_key = get_key_haup_xvr;
-		rc_type     = RC_BIT_RC5 | RC_BIT_RC6_MCE | RC_BIT_RC6_6A_32;
+		rc_proto    = RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC6_MCE |
+							RC_PROTO_BIT_RC6_6A_32;
 		ir_codes    = RC_MAP_HAUPPAUGE;
 		break;
 	}
@@ -388,7 +389,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 		name = init_data->name;
 		if (init_data->type)
-			rc_type = init_data->type;
+			rc_proto = init_data->type;
 
 		if (init_data->polling_interval)
 			ir->polling_interval = init_data->polling_interval;
@@ -431,7 +432,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	ir->rc = rc;
 
 	/* Make sure we are all setup before going on */
-	if (!name || !ir->get_key || !rc_type || !ir_codes) {
+	if (!name || !ir->get_key || !rc_proto || !ir_codes) {
 		dprintk(1, ": Unsupported device at address 0x%02x\n",
 			addr);
 		err = -ENODEV;
@@ -458,8 +459,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 * Initialize the other fields of rc_dev
 	 */
 	rc->map_name       = ir->ir_codes;
-	rc->allowed_protocols = rc_type;
-	rc->enabled_protocols = rc_type;
+	rc->allowed_protocols = rc_proto;
+	rc->enabled_protocols = rc_proto;
 	if (!rc->driver_name)
 		rc->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index bb8eda51ee27..73d655d073d6 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -69,12 +69,13 @@ static void ir_handle_key(struct bttv *btv)
 
 	if ((ir->mask_keydown && (gpio & ir->mask_keydown)) ||
 	    (ir->mask_keyup   && !(gpio & ir->mask_keyup))) {
-		rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
+		rc_keydown_notimeout(ir->dev, RC_PROTO_UNKNOWN, data, 0);
 	} else {
 		/* HACK: Probably, ir->mask_keydown is missing
 		   for this board */
 		if (btv->c.type == BTTV_BOARD_WINFAST2000)
-			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_PROTO_UNKNOWN, data,
+					     0);
 
 		rc_keyup(ir->dev);
 	}
@@ -99,7 +100,7 @@ static void ir_enltv_handle_key(struct bttv *btv)
 			gpio, data,
 			(gpio & ir->mask_keyup) ? " up" : "up/down");
 
-		rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
+		rc_keydown_notimeout(ir->dev, RC_PROTO_UNKNOWN, data, 0);
 		if (keyup)
 			rc_keyup(ir->dev);
 	} else {
@@ -113,7 +114,8 @@ static void ir_enltv_handle_key(struct bttv *btv)
 		if (keyup)
 			rc_keyup(ir->dev);
 		else
-			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_PROTO_UNKNOWN, data,
+					     0);
 	}
 
 	ir->last_gpio = data | keyup;
@@ -235,7 +237,7 @@ static void bttv_rc5_timer_end(unsigned long data)
 	}
 
 	scancode = RC_SCANCODE_RC5(system, command);
-	rc_keydown(ir->dev, RC_TYPE_RC5, scancode, toggle);
+	rc_keydown(ir->dev, RC_PROTO_RC5, scancode, toggle);
 	dprintk("scancode %x, toggle %x\n", scancode, toggle);
 }
 
@@ -327,7 +329,7 @@ static void bttv_ir_stop(struct bttv *btv)
  * Get_key functions used by I2C remotes
  */
 
-static int get_key_pv951(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_pv951(struct IR_i2c *ir, enum rc_proto *protocol,
 			 u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
@@ -355,7 +357,7 @@ static int get_key_pv951(struct IR_i2c *ir, enum rc_type *protocol,
 	 * 	   the device is bound to the vendor-provided RC.
 	 */
 
-	*protocol = RC_TYPE_UNKNOWN;
+	*protocol = RC_PROTO_UNKNOWN;
 	*scancode = b;
 	*toggle = 0;
 	return 1;
diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
index eabdd4c5520a..b89fbcbfb491 100644
--- a/drivers/media/pci/cx18/cx18-i2c.c
+++ b/drivers/media/pci/cx18/cx18-i2c.c
@@ -93,8 +93,8 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
 	case CX18_HW_Z8F0811_IR_RX_HAUP:
 		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type = RC_BIT_RC5 | RC_BIT_RC6_MCE |
-							RC_BIT_RC6_6A_32;
+		init_data->type = RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC6_MCE |
+							RC_PROTO_BIT_RC6_6A_32;
 		init_data->name = cx->card_name;
 		info.platform_data = init_data;
 		break;
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index c9b8e3f4d9fb..944b70831f12 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -284,32 +284,32 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		/* Integrated CX2388[58] IR controller */
-		allowed_protos = RC_BIT_ALL_IR_DECODER;
+		allowed_protos = RC_PROTO_BIT_ALL_IR_DECODER;
 		/* The grey Hauppauge RC-5 remote */
 		rc_map = RC_MAP_HAUPPAUGE;
 		break;
 	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
 		/* Integrated CX23885 IR controller */
-		allowed_protos = RC_BIT_ALL_IR_DECODER;
+		allowed_protos = RC_PROTO_BIT_ALL_IR_DECODER;
 		/* The grey Terratec remote with orange buttons */
 		rc_map = RC_MAP_NEC_TERRATEC_CINERGY_XS;
 		break;
 	case CX23885_BOARD_TEVII_S470:
 		/* Integrated CX23885 IR controller */
-		allowed_protos = RC_BIT_ALL_IR_DECODER;
+		allowed_protos = RC_PROTO_BIT_ALL_IR_DECODER;
 		/* A guess at the remote */
 		rc_map = RC_MAP_TEVII_NEC;
 		break;
 	case CX23885_BOARD_MYGICA_X8507:
 		/* Integrated CX23885 IR controller */
-		allowed_protos = RC_BIT_ALL_IR_DECODER;
+		allowed_protos = RC_PROTO_BIT_ALL_IR_DECODER;
 		/* A guess at the remote */
 		rc_map = RC_MAP_TOTAL_MEDIA_IN_HAND_02;
 		break;
 	case CX23885_BOARD_TBS_6980:
 	case CX23885_BOARD_TBS_6981:
 		/* Integrated CX23885 IR controller */
-		allowed_protos = RC_BIT_ALL_IR_DECODER;
+		allowed_protos = RC_PROTO_BIT_ALL_IR_DECODER;
 		/* A guess at the remote */
 		rc_map = RC_MAP_TBS_NEC;
 		break;
@@ -320,12 +320,12 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_DVBSKY_S952:
 	case CX23885_BOARD_DVBSKY_T982:
 		/* Integrated CX23885 IR controller */
-		allowed_protos = RC_BIT_ALL_IR_DECODER;
+		allowed_protos = RC_PROTO_BIT_ALL_IR_DECODER;
 		rc_map = RC_MAP_DVBSKY;
 		break;
 	case CX23885_BOARD_TT_CT2_4500_CI:
 		/* Integrated CX23885 IR controller */
-		allowed_protos = RC_BIT_ALL_IR_DECODER;
+		allowed_protos = RC_PROTO_BIT_ALL_IR_DECODER;
 		rc_map = RC_MAP_TT_1500;
 		break;
 	default:
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index a5dbee776455..e02449bf2041 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -132,7 +132,7 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 
 		data = (data << 4) | ((gpio_key & 0xf0) >> 4);
 
-		rc_keydown(ir->dev, RC_TYPE_UNKNOWN, data, 0);
+		rc_keydown(ir->dev, RC_PROTO_UNKNOWN, data, 0);
 
 	} else if (ir->core->boardnr == CX88_BOARD_PROLINK_PLAYTVPVR ||
 		   ir->core->boardnr == CX88_BOARD_PIXELVIEW_PLAYTV_ULTRA_PRO) {
@@ -146,7 +146,7 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 		scancode = RC_SCANCODE_NECX(addr, cmd);
 
 		if (0 == (gpio & ir->mask_keyup))
-			rc_keydown_notimeout(ir->dev, RC_TYPE_NECX, scancode,
+			rc_keydown_notimeout(ir->dev, RC_PROTO_NECX, scancode,
 					     0);
 		else
 			rc_keyup(ir->dev);
@@ -154,20 +154,22 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 	} else if (ir->mask_keydown) {
 		/* bit set on keydown */
 		if (gpio & ir->mask_keydown)
-			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_PROTO_UNKNOWN, data,
+					     0);
 		else
 			rc_keyup(ir->dev);
 
 	} else if (ir->mask_keyup) {
 		/* bit cleared on keydown */
 		if (0 == (gpio & ir->mask_keyup))
-			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_PROTO_UNKNOWN, data,
+					     0);
 		else
 			rc_keyup(ir->dev);
 
 	} else {
 		/* can't distinguish keydown/up :-/ */
-		rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
+		rc_keydown_notimeout(ir->dev, RC_PROTO_UNKNOWN, data, 0);
 		rc_keyup(ir->dev);
 	}
 }
@@ -267,7 +269,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	struct cx88_IR *ir;
 	struct rc_dev *dev;
 	char *ir_codes = NULL;
-	u64 rc_type = RC_BIT_OTHER;
+	u64 rc_proto = RC_PROTO_BIT_OTHER;
 	int err = -ENOMEM;
 	u32 hardware_mask = 0;	/* For devices with a hardware mask, when
 				 * used with a full-code IR table
@@ -348,7 +350,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		 * 002-T mini RC, provided with newer PV hardware
 		 */
 		ir_codes = RC_MAP_PIXELVIEW_MK12;
-		rc_type = RC_BIT_NECX;
+		rc_proto = RC_PROTO_BIT_NECX;
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keyup = 0x80;
 		ir->polling = 10; /* ms */
@@ -487,7 +489,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		dev->timeout = 10 * 1000 * 1000; /* 10 ms */
 	} else {
 		dev->driver_type = RC_DRIVER_SCANCODE;
-		dev->allowed_protocols = rc_type;
+		dev->allowed_protocols = rc_proto;
 	}
 
 	ir->core = core;
@@ -557,7 +559,7 @@ void cx88_ir_irq(struct cx88_core *core)
 	ir_raw_event_handle(ir->dev);
 }
 
-static int get_key_pvr2000(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_pvr2000(struct IR_i2c *ir, enum rc_proto *protocol,
 			   u32 *scancode, u8 *toggle)
 {
 	int flags, code;
@@ -582,7 +584,7 @@ static int get_key_pvr2000(struct IR_i2c *ir, enum rc_type *protocol,
 	dprintk("IR Key/Flags: (0x%02x/0x%02x)\n",
 		code & 0xff, flags & 0xff);
 
-	*protocol = RC_TYPE_UNKNOWN;
+	*protocol = RC_PROTO_UNKNOWN;
 	*scancode = code & 0xff;
 	*toggle = 0;
 	return 1;
@@ -612,7 +614,7 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 	case CX88_BOARD_LEADTEK_PVR2000:
 		addr_list = pvr2000_addr_list;
 		core->init_data.name = "cx88 Leadtek PVR 2000 remote";
-		core->init_data.type = RC_BIT_UNKNOWN;
+		core->init_data.type = RC_PROTO_BIT_UNKNOWN;
 		core->init_data.get_key = get_key_pvr2000;
 		core->init_data.ir_codes = RC_MAP_EMPTY;
 		break;
@@ -633,8 +635,8 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 			/* Hauppauge XVR */
 			core->init_data.name = "cx88 Hauppauge XVR remote";
 			core->init_data.ir_codes = RC_MAP_HAUPPAUGE;
-			core->init_data.type = RC_BIT_RC5 | RC_BIT_RC6_MCE |
-							RC_BIT_RC6_6A_32;
+			core->init_data.type = RC_PROTO_BIT_RC5 |
+				RC_PROTO_BIT_RC6_MCE | RC_PROTO_BIT_RC6_6A_32;
 			core->init_data.internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 
 			info.platform_data = &core->init_data;
diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index 996d0a1a770c..5604aed6cad5 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -675,7 +675,7 @@ static void dm1105_emit_key(struct work_struct *work)
 	data = (ircom >> 8) & 0x7f;
 
 	/* FIXME: UNKNOWN because we don't generate a full NEC scancode (yet?) */
-	rc_keydown(ir->dev, RC_TYPE_UNKNOWN, data, 0);
+	rc_keydown(ir->dev, RC_PROTO_UNKNOWN, data, 0);
 }
 
 /* work handler */
diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index dea80efd5836..69b4fa6f0362 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -148,7 +148,7 @@ static const char * const hw_devicenames[] = {
 	"ir_video",		/* IVTV_HW_I2C_IR_RX_ADAPTEC */
 };
 
-static int get_key_adaptec(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_adaptec(struct IR_i2c *ir, enum rc_proto *protocol,
 			   u32 *scancode, u8 *toggle)
 {
 	unsigned char keybuf[4];
@@ -168,7 +168,7 @@ static int get_key_adaptec(struct IR_i2c *ir, enum rc_type *protocol,
 	keybuf[2] &= 0x7f;
 	keybuf[3] |= 0x80;
 
-	*protocol = RC_TYPE_UNKNOWN;
+	*protocol = RC_PROTO_UNKNOWN;
 	*scancode = keybuf[3] | keybuf[2] << 8 | keybuf[1] << 16 |keybuf[0] << 24;
 	*toggle = 0;
 	return 1;
@@ -201,22 +201,22 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		init_data->ir_codes = RC_MAP_AVERMEDIA_CARDBUS;
 		init_data->internal_get_key_func =
 					IR_KBD_GET_KEY_AVERMEDIA_CARDBUS;
-		init_data->type = RC_BIT_OTHER;
+		init_data->type = RC_PROTO_BIT_OTHER;
 		init_data->name = "AVerMedia AVerTV card";
 		break;
 	case IVTV_HW_I2C_IR_RX_HAUP_EXT:
 	case IVTV_HW_I2C_IR_RX_HAUP_INT:
 		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
-		init_data->type = RC_BIT_RC5;
+		init_data->type = RC_PROTO_BIT_RC5;
 		init_data->name = itv->card_name;
 		break;
 	case IVTV_HW_Z8F0811_IR_RX_HAUP:
 		/* Default to grey remote */
 		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type = RC_BIT_RC5 | RC_BIT_RC6_MCE |
-							RC_BIT_RC6_6A_32;
+		init_data->type = RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC6_MCE |
+							RC_PROTO_BIT_RC6_6A_32;
 		init_data->name = itv->card_name;
 		break;
 	case IVTV_HW_I2C_IR_RX_ADAPTEC:
@@ -224,7 +224,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		init_data->name = itv->card_name;
 		/* FIXME: The protocol and RC_MAP needs to be corrected */
 		init_data->ir_codes = RC_MAP_EMPTY;
-		init_data->type = RC_BIT_UNKNOWN;
+		init_data->type = RC_PROTO_BIT_UNKNOWN;
 		break;
 	}
 
diff --git a/drivers/media/pci/mantis/mantis_input.c b/drivers/media/pci/mantis/mantis_input.c
index 001b7f827699..7519dcc934dd 100644
--- a/drivers/media/pci/mantis/mantis_input.c
+++ b/drivers/media/pci/mantis/mantis_input.c
@@ -31,7 +31,7 @@
 void mantis_input_process(struct mantis_pci *mantis, int scancode)
 {
 	if (mantis->rc)
-		rc_keydown(mantis->rc, RC_TYPE_UNKNOWN, scancode, 0);
+		rc_keydown(mantis->rc, RC_PROTO_UNKNOWN, scancode, 0);
 }
 
 int mantis_input_init(struct mantis_pci *mantis)
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index e7b386ee3ff9..b1f3769eac45 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -83,14 +83,16 @@ static int build_key(struct saa7134_dev *dev)
 		if (data == ir->mask_keycode)
 			rc_keyup(ir->dev);
 		else
-			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_PROTO_UNKNOWN, data,
+					     0);
 		return 0;
 	}
 
 	if (ir->polling) {
 		if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
 		    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_PROTO_UNKNOWN, data,
+					     0);
 		} else {
 			rc_keyup(ir->dev);
 		}
@@ -98,7 +100,8 @@ static int build_key(struct saa7134_dev *dev)
 	else {	/* IRQ driven mode - handle key press and release in one go */
 		if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
 		    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_PROTO_UNKNOWN, data,
+					     0);
 			rc_keyup(ir->dev);
 		}
 	}
@@ -108,7 +111,7 @@ static int build_key(struct saa7134_dev *dev)
 
 /* --------------------- Chip specific I2C key builders ----------------- */
 
-static int get_key_flydvb_trio(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_flydvb_trio(struct IR_i2c *ir, enum rc_proto *protocol,
 			       u32 *scancode, u8 *toggle)
 {
 	int gpio;
@@ -154,13 +157,14 @@ static int get_key_flydvb_trio(struct IR_i2c *ir, enum rc_type *protocol,
 		return -EIO;
 	}
 
-	*protocol = RC_TYPE_UNKNOWN;
+	*protocol = RC_PROTO_UNKNOWN;
 	*scancode = b;
 	*toggle = 0;
 	return 1;
 }
 
-static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir,
+				       enum rc_proto *protocol,
 				       u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
@@ -201,14 +205,14 @@ static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, enum rc_type *protocol
 	/* Button pressed */
 
 	input_dbg("get_key_msi_tvanywhere_plus: Key = 0x%02X\n", b);
-	*protocol = RC_TYPE_UNKNOWN;
+	*protocol = RC_PROTO_UNKNOWN;
 	*scancode = b;
 	*toggle = 0;
 	return 1;
 }
 
 /* copied and modified from get_key_msi_tvanywhere_plus() */
-static int get_key_kworld_pc150u(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_kworld_pc150u(struct IR_i2c *ir, enum rc_proto *protocol,
 				 u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
@@ -249,13 +253,13 @@ static int get_key_kworld_pc150u(struct IR_i2c *ir, enum rc_type *protocol,
 	/* Button pressed */
 
 	input_dbg("get_key_kworld_pc150u: Key = 0x%02X\n", b);
-	*protocol = RC_TYPE_UNKNOWN;
+	*protocol = RC_PROTO_UNKNOWN;
 	*scancode = b;
 	*toggle = 0;
 	return 1;
 }
 
-static int get_key_purpletv(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_purpletv(struct IR_i2c *ir, enum rc_proto *protocol,
 			    u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
@@ -274,13 +278,13 @@ static int get_key_purpletv(struct IR_i2c *ir, enum rc_type *protocol,
 	if (b & 0x80)
 		return 1;
 
-	*protocol = RC_TYPE_UNKNOWN;
+	*protocol = RC_PROTO_UNKNOWN;
 	*scancode = b;
 	*toggle = 0;
 	return 1;
 }
 
-static int get_key_hvr1110(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_hvr1110(struct IR_i2c *ir, enum rc_proto *protocol,
 			   u32 *scancode, u8 *toggle)
 {
 	unsigned char buf[5];
@@ -304,14 +308,14 @@ static int get_key_hvr1110(struct IR_i2c *ir, enum rc_type *protocol,
 	 *
 	 * FIXME: start bits could maybe be used...?
 	 */
-	*protocol = RC_TYPE_RC5;
+	*protocol = RC_PROTO_RC5;
 	*scancode = RC_SCANCODE_RC5(buf[3] & 0x1f, buf[4] >> 2);
 	*toggle = !!(buf[3] & 0x40);
 	return 1;
 }
 
 
-static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_proto *protocol,
 			      u32 *scancode, u8 *toggle)
 {
 	unsigned char data[12];
@@ -338,7 +342,7 @@ static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_type *protocol,
 	if (data[9] != (unsigned char)(~data[8]))
 		return 0;
 
-	*protocol = RC_TYPE_NECX;
+	*protocol = RC_PROTO_NECX;
 	*scancode = RC_SCANCODE_NECX(data[11] << 8 | data[10], data[9]);
 	*toggle = 0;
 	return 1;
@@ -347,7 +351,7 @@ static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_type *protocol,
 /* Common (grey or coloured) pinnacle PCTV remote handling
  *
  */
-static int get_key_pinnacle(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_pinnacle(struct IR_i2c *ir, enum rc_proto *protocol,
 			    u32 *scancode, u8 *toggle, int parity_offset,
 			    int marker, int code_modulo)
 {
@@ -384,7 +388,7 @@ static int get_key_pinnacle(struct IR_i2c *ir, enum rc_type *protocol,
 
 	code %= code_modulo;
 
-	*protocol = RC_TYPE_UNKNOWN;
+	*protocol = RC_PROTO_UNKNOWN;
 	*scancode = code;
 	*toggle = 0;
 
@@ -401,7 +405,7 @@ static int get_key_pinnacle(struct IR_i2c *ir, enum rc_type *protocol,
  *
  * Sylvain Pasche <sylvain.pasche@gmail.com>
  */
-static int get_key_pinnacle_grey(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_pinnacle_grey(struct IR_i2c *ir, enum rc_proto *protocol,
 				 u32 *scancode, u8 *toggle)
 {
 
@@ -413,7 +417,7 @@ static int get_key_pinnacle_grey(struct IR_i2c *ir, enum rc_type *protocol,
  *
  * Ricardo Cerqueira <v4l@cerqueira.org>
  */
-static int get_key_pinnacle_color(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_pinnacle_color(struct IR_i2c *ir, enum rc_proto *protocol,
 				  u32 *scancode, u8 *toggle)
 {
 	/* code_modulo parameter (0x88) is used to reduce code value to fit inside IR_KEYTAB_SIZE
@@ -1020,7 +1024,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		dev->init_data.name = "BeholdTV";
 		dev->init_data.get_key = get_key_beholdm6xx;
 		dev->init_data.ir_codes = RC_MAP_BEHOLD;
-		dev->init_data.type = RC_BIT_NECX;
+		dev->init_data.type = RC_PROTO_BIT_NECX;
 		info.addr = 0x2d;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
diff --git a/drivers/media/pci/smipcie/smipcie-ir.c b/drivers/media/pci/smipcie/smipcie-ir.c
index fc3375720a35..c5595af6b976 100644
--- a/drivers/media/pci/smipcie/smipcie-ir.c
+++ b/drivers/media/pci/smipcie/smipcie-ir.c
@@ -144,7 +144,7 @@ static void smi_ir_decode(struct work_struct *work)
 			rc5_system = (dwIRCode & 0x7C0) >> 6;
 			toggle = (dwIRCode & 0x800) ? 1 : 0;
 			scancode = rc5_system << 8 | rc5_command;
-			rc_keydown(rc_dev, RC_TYPE_RC5, scancode, toggle);
+			rc_keydown(rc_dev, RC_PROTO_RC5, scancode, toggle);
 		}
 	}
 end_ir_decode:
diff --git a/drivers/media/pci/ttpci/budget-ci.c b/drivers/media/pci/ttpci/budget-ci.c
index cd4e63b99e0b..87e8924d4691 100644
--- a/drivers/media/pci/ttpci/budget-ci.c
+++ b/drivers/media/pci/ttpci/budget-ci.c
@@ -158,14 +158,15 @@ static void msp430_ir_interrupt(unsigned long data)
 		return;
 
 	if (budget_ci->ir.full_rc5) {
-		rc_keydown(dev, RC_TYPE_RC5,
+		rc_keydown(dev, RC_PROTO_RC5,
 			   RC_SCANCODE_RC5(budget_ci->ir.rc5_device, budget_ci->ir.ir_key),
 			   !!(command & 0x20));
 		return;
 	}
 
 	/* FIXME: We should generate complete scancodes for all devices */
-	rc_keydown(dev, RC_TYPE_UNKNOWN, budget_ci->ir.ir_key, !!(command & 0x20));
+	rc_keydown(dev, RC_PROTO_UNKNOWN, budget_ci->ir.ir_key,
+		   !!(command & 0x20));
 }
 
 static int msp430_ir_init(struct budget_ci *budget_ci)
diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index a7f76002b30a..d0871d60a723 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -622,7 +622,8 @@ static void ati_remote_input_report(struct urb *urb)
 				* it would cause ghost repeats which would be a
 				* regression for this driver.
 				*/
-				rc_keydown_notimeout(ati_remote->rdev, RC_TYPE_OTHER,
+				rc_keydown_notimeout(ati_remote->rdev,
+						     RC_PROTO_OTHER,
 						     scancode, data[2]);
 				rc_keyup(ati_remote->rdev);
 			}
@@ -760,7 +761,7 @@ static void ati_remote_rc_init(struct ati_remote *ati_remote)
 	struct rc_dev *rdev = ati_remote->rdev;
 
 	rdev->priv = ati_remote;
-	rdev->allowed_protocols = RC_BIT_OTHER;
+	rdev->allowed_protocols = RC_PROTO_BIT_OTHER;
 	rdev->driver_name = "ati_remote";
 
 	rdev->open = ati_remote_rc_open;
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 41f6b1c52407..af7ba23e16e1 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1053,7 +1053,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	if (!dev->hw_learning_and_tx_capable)
 		learning_mode_force = false;
 
-	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	rdev->priv = dev;
 	rdev->open = ene_open;
 	rdev->close = ene_close;
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 57155e4c9f38..f2639d0c2fca 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -529,7 +529,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 
 	/* Set up the rc device */
 	rdev->priv = fintek;
-	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	rdev->open = fintek_open;
 	rdev->close = fintek_close;
 	rdev->device_name = FINTEK_DESCRIPTION;
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 24c7ac8f1b82..7248b3662285 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -143,7 +143,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	if (pdata->allowed_protos)
 		rcdev->allowed_protocols = pdata->allowed_protos;
 	else
-		rcdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+		rcdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	rcdev->map_name = pdata->map_name ?: RC_MAP_EMPTY;
 
 	gpio_dev->rcdev = rcdev;
diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
index 5babc6371df4..a5ea86be8f44 100644
--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -202,10 +202,11 @@ static int igorplugusb_probe(struct usb_interface *intf,
 	 * This device can only store 36 pulses + spaces, which is not enough
 	 * for the NEC protocol and many others.
 	 */
-	rc->allowed_protocols = RC_BIT_ALL_IR_DECODER & ~(RC_BIT_NEC |
-			RC_BIT_NECX | RC_BIT_NEC32 | RC_BIT_RC6_6A_20 |
-			RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE |
-			RC_BIT_SONY20 | RC_BIT_SANYO);
+	rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER &
+		~(RC_PROTO_BIT_NEC | RC_PROTO_BIT_NECX | RC_PROTO_BIT_NEC32 |
+		  RC_PROTO_BIT_RC6_6A_20 | RC_PROTO_BIT_RC6_6A_24 |
+		  RC_PROTO_BIT_RC6_6A_32 | RC_PROTO_BIT_RC6_MCE |
+		  RC_PROTO_BIT_SONY20 | RC_PROTO_BIT_SANYO);
 
 	rc->priv = ir;
 	rc->driver_name = DRIVER_NAME;
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 4357dd36d7b9..30e24da67226 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -491,7 +491,7 @@ static int iguanair_probe(struct usb_interface *intf,
 	rc->input_phys = ir->phys;
 	usb_to_input_id(ir->udev, &rc->input_id);
 	rc->dev.parent = &intf->dev;
-	rc->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	rc->priv = ir;
 	rc->open = iguanair_open;
 	rc->close = iguanair_close;
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index dd46973e0cbf..82fdf4cc0824 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -589,7 +589,7 @@ static void img_ir_set_decoder(struct img_ir_priv *priv,
 	/* clear the wakeup scancode filter */
 	rdev->scancode_wakeup_filter.data = 0;
 	rdev->scancode_wakeup_filter.mask = 0;
-	rdev->wakeup_protocol = RC_TYPE_UNKNOWN;
+	rdev->wakeup_protocol = RC_PROTO_UNKNOWN;
 
 	/* clear raw filters */
 	_img_ir_set_filter(priv, NULL);
@@ -823,7 +823,7 @@ static void img_ir_handle_data(struct img_ir_priv *priv, u32 len, u64 raw)
 	int ret = IMG_IR_SCANCODE;
 	struct img_ir_scancode_req request;
 
-	request.protocol = RC_TYPE_UNKNOWN;
+	request.protocol = RC_PROTO_UNKNOWN;
 	request.toggle   = 0;
 
 	if (dec->scancode)
diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
index 91a297731661..58b68dd6c67d 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.h
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -135,13 +135,13 @@ struct img_ir_timing_regvals {
 /**
  * struct img_ir_scancode_req - Scancode request data.
  * @protocol:	Protocol code of received message (defaults to
- *		RC_TYPE_UNKNOWN).
+ *		RC_PROTO_UNKNOWN).
  * @scancode:	Scan code of received message (must be written by
  *		handler if IMG_IR_SCANCODE is returned).
  * @toggle:	Toggle bit (defaults to 0).
  */
 struct img_ir_scancode_req {
-	enum rc_type protocol;
+	enum rc_proto protocol;
 	u32 scancode;
 	u8 toggle;
 };
diff --git a/drivers/media/rc/img-ir/img-ir-jvc.c b/drivers/media/rc/img-ir/img-ir-jvc.c
index d3e2fc0bcfe1..4b07c76fbe1b 100644
--- a/drivers/media/rc/img-ir/img-ir-jvc.c
+++ b/drivers/media/rc/img-ir/img-ir-jvc.c
@@ -23,7 +23,7 @@ static int img_ir_jvc_scancode(int len, u64 raw, u64 enabled_protocols,
 	cust = (raw >> 0) & 0xff;
 	data = (raw >> 8) & 0xff;
 
-	request->protocol = RC_TYPE_JVC;
+	request->protocol = RC_PROTO_JVC;
 	request->scancode = cust << 8 | data;
 	return IMG_IR_SCANCODE;
 }
@@ -52,7 +52,7 @@ static int img_ir_jvc_filter(const struct rc_scancode_filter *in,
  *          http://support.jvc.com/consumer/support/documents/RemoteCodes.pdf
  */
 struct img_ir_decoder img_ir_jvc = {
-	.type = RC_BIT_JVC,
+	.type = RC_PROTO_BIT_JVC,
 	.control = {
 		.decoden = 1,
 		.code_type = IMG_IR_CODETYPE_PULSEDIST,
diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/img-ir/img-ir-nec.c
index 044fd42b22a0..2fc0678ad2d7 100644
--- a/drivers/media/rc/img-ir/img-ir-nec.c
+++ b/drivers/media/rc/img-ir/img-ir-nec.c
@@ -35,20 +35,20 @@ static int img_ir_nec_scancode(int len, u64 raw, u64 enabled_protocols,
 				bitrev8(addr_inv) << 16 |
 				bitrev8(data)     <<  8 |
 				bitrev8(data_inv);
-		request->protocol = RC_TYPE_NEC32;
+		request->protocol = RC_PROTO_NEC32;
 	} else if ((addr_inv ^ addr) != 0xff) {
 		/* Extended NEC */
 		/* scan encoding: AAaaDD */
 		request->scancode = addr     << 16 |
 				addr_inv <<  8 |
 				data;
-		request->protocol = RC_TYPE_NECX;
+		request->protocol = RC_PROTO_NECX;
 	} else {
 		/* Normal NEC */
 		/* scan encoding: AADD */
 		request->scancode = addr << 8 |
 				data;
-		request->protocol = RC_TYPE_NEC;
+		request->protocol = RC_PROTO_NEC;
 	}
 	return IMG_IR_SCANCODE;
 }
@@ -63,7 +63,7 @@ static int img_ir_nec_filter(const struct rc_scancode_filter *in,
 	data       = in->data & 0xff;
 	data_m     = in->mask & 0xff;
 
-	protocols &= RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32;
+	protocols &= RC_PROTO_BIT_NEC | RC_PROTO_BIT_NECX | RC_PROTO_BIT_NEC32;
 
 	/*
 	 * If only one bit is set, we were requested to do an exact
@@ -72,14 +72,14 @@ static int img_ir_nec_filter(const struct rc_scancode_filter *in,
 	 */
 	if (!is_power_of_2(protocols)) {
 		if ((in->data | in->mask) & 0xff000000)
-			protocols = RC_BIT_NEC32;
+			protocols = RC_PROTO_BIT_NEC32;
 		else if ((in->data | in->mask) & 0x00ff0000)
-			protocols = RC_BIT_NECX;
+			protocols = RC_PROTO_BIT_NECX;
 		else
-			protocols = RC_BIT_NEC;
+			protocols = RC_PROTO_BIT_NEC;
 	}
 
-	if (protocols == RC_BIT_NEC32) {
+	if (protocols == RC_PROTO_BIT_NEC32) {
 		/* 32-bit NEC (used by Apple and TiVo remotes) */
 		/* scan encoding: as transmitted, MSBit = first received bit */
 		addr       = bitrev8(in->data >> 24);
@@ -90,7 +90,7 @@ static int img_ir_nec_filter(const struct rc_scancode_filter *in,
 		data_m     = bitrev8(in->mask >>  8);
 		data_inv   = bitrev8(in->data >>  0);
 		data_inv_m = bitrev8(in->mask >>  0);
-	} else if (protocols == RC_BIT_NECX) {
+	} else if (protocols == RC_PROTO_BIT_NECX) {
 		/* Extended NEC */
 		/* scan encoding AAaaDD */
 		addr       = (in->data >> 16) & 0xff;
@@ -128,7 +128,7 @@ static int img_ir_nec_filter(const struct rc_scancode_filter *in,
  *        http://wiki.altium.com/display/ADOH/NEC+Infrared+Transmission+Protocol
  */
 struct img_ir_decoder img_ir_nec = {
-	.type = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32,
+	.type = RC_PROTO_BIT_NEC | RC_PROTO_BIT_NECX | RC_PROTO_BIT_NEC32,
 	.control = {
 		.decoden = 1,
 		.code_type = IMG_IR_CODETYPE_PULSEDIST,
diff --git a/drivers/media/rc/img-ir/img-ir-rc5.c b/drivers/media/rc/img-ir/img-ir-rc5.c
index a8a28a377eee..a1bc8705472b 100644
--- a/drivers/media/rc/img-ir/img-ir-rc5.c
+++ b/drivers/media/rc/img-ir/img-ir-rc5.c
@@ -33,7 +33,7 @@ static int img_ir_rc5_scancode(int len, u64 raw, u64 enabled_protocols,
 	if (!start)
 		return -EINVAL;
 
-	request->protocol = RC_TYPE_RC5;
+	request->protocol = RC_PROTO_RC5;
 	request->scancode = addr << 8 | cmd;
 	request->toggle   = tgl;
 	return IMG_IR_SCANCODE;
@@ -52,7 +52,7 @@ static int img_ir_rc5_filter(const struct rc_scancode_filter *in,
  * see http://www.sbprojects.com/knowledge/ir/rc5.php
  */
 struct img_ir_decoder img_ir_rc5 = {
-	.type      = RC_BIT_RC5,
+	.type      = RC_PROTO_BIT_RC5,
 	.control   = {
 		.bitoriend2	= 1,
 		.code_type	= IMG_IR_CODETYPE_BIPHASE,
diff --git a/drivers/media/rc/img-ir/img-ir-rc6.c b/drivers/media/rc/img-ir/img-ir-rc6.c
index de1e27534968..5f34f59ca257 100644
--- a/drivers/media/rc/img-ir/img-ir-rc6.c
+++ b/drivers/media/rc/img-ir/img-ir-rc6.c
@@ -54,7 +54,7 @@ static int img_ir_rc6_scancode(int len, u64 raw, u64 enabled_protocols,
 	if (mode)
 		return -EINVAL;
 
-	request->protocol = RC_TYPE_RC6_0;
+	request->protocol = RC_PROTO_RC6_0;
 	request->scancode = addr << 8 | cmd;
 	request->toggle	  = trl2;
 	return IMG_IR_SCANCODE;
@@ -73,7 +73,7 @@ static int img_ir_rc6_filter(const struct rc_scancode_filter *in,
  * see http://www.sbprojects.com/knowledge/ir/rc6.php
  */
 struct img_ir_decoder img_ir_rc6 = {
-	.type		= RC_BIT_RC6_0,
+	.type		= RC_PROTO_BIT_RC6_0,
 	.control	= {
 		.bitorien	= 1,
 		.code_type	= IMG_IR_CODETYPE_BIPHASE,
diff --git a/drivers/media/rc/img-ir/img-ir-sanyo.c b/drivers/media/rc/img-ir/img-ir-sanyo.c
index f394994ffc22..55a755bb437c 100644
--- a/drivers/media/rc/img-ir/img-ir-sanyo.c
+++ b/drivers/media/rc/img-ir/img-ir-sanyo.c
@@ -44,7 +44,7 @@ static int img_ir_sanyo_scancode(int len, u64 raw, u64 enabled_protocols,
 		return -EINVAL;
 
 	/* Normal Sanyo */
-	request->protocol = RC_TYPE_SANYO;
+	request->protocol = RC_PROTO_SANYO;
 	request->scancode = addr << 8 | data;
 	return IMG_IR_SCANCODE;
 }
@@ -80,7 +80,7 @@ static int img_ir_sanyo_filter(const struct rc_scancode_filter *in,
 
 /* Sanyo decoder */
 struct img_ir_decoder img_ir_sanyo = {
-	.type = RC_BIT_SANYO,
+	.type = RC_PROTO_BIT_SANYO,
 	.control = {
 		.decoden = 1,
 		.code_type = IMG_IR_CODETYPE_PULSEDIST,
diff --git a/drivers/media/rc/img-ir/img-ir-sharp.c b/drivers/media/rc/img-ir/img-ir-sharp.c
index fe5acc4f030e..2d2530902cfa 100644
--- a/drivers/media/rc/img-ir/img-ir-sharp.c
+++ b/drivers/media/rc/img-ir/img-ir-sharp.c
@@ -32,7 +32,7 @@ static int img_ir_sharp_scancode(int len, u64 raw, u64 enabled_protocols,
 		/* probably the second half of the message */
 		return -EINVAL;
 
-	request->protocol = RC_TYPE_SHARP;
+	request->protocol = RC_PROTO_SHARP;
 	request->scancode = addr << 8 | cmd;
 	return IMG_IR_SCANCODE;
 }
@@ -73,7 +73,7 @@ static int img_ir_sharp_filter(const struct rc_scancode_filter *in,
  * See also http://www.sbprojects.com/knowledge/ir/sharp.php
  */
 struct img_ir_decoder img_ir_sharp = {
-	.type = RC_BIT_SHARP,
+	.type = RC_PROTO_BIT_SHARP,
 	.control = {
 		.decoden = 0,
 		.decodend2 = 1,
diff --git a/drivers/media/rc/img-ir/img-ir-sony.c b/drivers/media/rc/img-ir/img-ir-sony.c
index 3fcba271a419..a942d0be908c 100644
--- a/drivers/media/rc/img-ir/img-ir-sony.c
+++ b/drivers/media/rc/img-ir/img-ir-sony.c
@@ -19,32 +19,32 @@ static int img_ir_sony_scancode(int len, u64 raw, u64 enabled_protocols,
 
 	switch (len) {
 	case 12:
-		if (!(enabled_protocols & RC_BIT_SONY12))
+		if (!(enabled_protocols & RC_PROTO_BIT_SONY12))
 			return -EINVAL;
 		func   = raw & 0x7f;	/* first 7 bits */
 		raw    >>= 7;
 		dev    = raw & 0x1f;	/* next 5 bits */
 		subdev = 0;
-		request->protocol = RC_TYPE_SONY12;
+		request->protocol = RC_PROTO_SONY12;
 		break;
 	case 15:
-		if (!(enabled_protocols & RC_BIT_SONY15))
+		if (!(enabled_protocols & RC_PROTO_BIT_SONY15))
 			return -EINVAL;
 		func   = raw & 0x7f;	/* first 7 bits */
 		raw    >>= 7;
 		dev    = raw & 0xff;	/* next 8 bits */
 		subdev = 0;
-		request->protocol = RC_TYPE_SONY15;
+		request->protocol = RC_PROTO_SONY15;
 		break;
 	case 20:
-		if (!(enabled_protocols & RC_BIT_SONY20))
+		if (!(enabled_protocols & RC_PROTO_BIT_SONY20))
 			return -EINVAL;
 		func   = raw & 0x7f;	/* first 7 bits */
 		raw    >>= 7;
 		dev    = raw & 0x1f;	/* next 5 bits */
 		raw    >>= 5;
 		subdev = raw & 0xff;	/* next 8 bits */
-		request->protocol = RC_TYPE_SONY20;
+		request->protocol = RC_PROTO_SONY20;
 		break;
 	default:
 		return -EINVAL;
@@ -68,7 +68,8 @@ static int img_ir_sony_filter(const struct rc_scancode_filter *in,
 	func     = (in->data >> 0)  & 0x7f;
 	func_m   = (in->mask >> 0)  & 0x7f;
 
-	protocols &= RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20;
+	protocols &= RC_PROTO_BIT_SONY12 | RC_PROTO_BIT_SONY15 |
+							RC_PROTO_BIT_SONY20;
 
 	/*
 	 * If only one bit is set, we were requested to do an exact
@@ -77,20 +78,20 @@ static int img_ir_sony_filter(const struct rc_scancode_filter *in,
 	 */
 	if (!is_power_of_2(protocols)) {
 		if (subdev & subdev_m)
-			protocols = RC_BIT_SONY20;
+			protocols = RC_PROTO_BIT_SONY20;
 		else if (dev & dev_m & 0xe0)
-			protocols = RC_BIT_SONY15;
+			protocols = RC_PROTO_BIT_SONY15;
 		else
-			protocols = RC_BIT_SONY12;
+			protocols = RC_PROTO_BIT_SONY12;
 	}
 
-	if (protocols == RC_BIT_SONY20) {
+	if (protocols == RC_PROTO_BIT_SONY20) {
 		/* can't encode subdev and higher device bits */
 		if (dev & dev_m & 0xe0)
 			return -EINVAL;
 		len = 20;
 		dev_m &= 0x1f;
-	} else if (protocols == RC_BIT_SONY15) {
+	} else if (protocols == RC_PROTO_BIT_SONY15) {
 		len = 15;
 		subdev_m = 0;
 	} else {
@@ -128,7 +129,7 @@ static int img_ir_sony_filter(const struct rc_scancode_filter *in,
  *          http://picprojects.org.uk/projects/sirc/sonysirc.pdf
  */
 struct img_ir_decoder img_ir_sony = {
-	.type = RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20,
+	.type = RC_PROTO_BIT_SONY12 | RC_PROTO_BIT_SONY15 | RC_PROTO_BIT_SONY20,
 	.control = {
 		.decoden = 1,
 		.code_type = IMG_IR_CODETYPE_PULSELEN,
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index ab560fdaae7c..7b3f31cc63d2 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -148,7 +148,7 @@ struct imon_context {
 	u32 last_keycode;		/* last reported input keycode */
 	u32 rc_scancode;		/* the computed remote scancode */
 	u8 rc_toggle;			/* the computed remote toggle bit */
-	u64 rc_type;			/* iMON or MCE (RC6) IR protocol? */
+	u64 rc_proto;			/* iMON or MCE (RC6) IR protocol? */
 	bool release_code;		/* some keys send a release code */
 
 	u8 display_type;		/* store the display type */
@@ -1118,7 +1118,7 @@ static void imon_touch_display_timeout(unsigned long data)
  * it is not, so we must acquire it prior to calling send_packet, which
  * requires that the lock is held.
  */
-static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_type)
+static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_proto)
 {
 	int retval;
 	struct imon_context *ictx = rc->priv;
@@ -1127,25 +1127,25 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_type)
 	unsigned char ir_proto_packet[] = {
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86 };
 
-	if (*rc_type && !(*rc_type & rc->allowed_protocols))
+	if (*rc_proto && !(*rc_proto & rc->allowed_protocols))
 		dev_warn(dev, "Looks like you're trying to use an IR protocol this device does not support\n");
 
-	if (*rc_type & RC_BIT_RC6_MCE) {
+	if (*rc_proto & RC_PROTO_BIT_RC6_MCE) {
 		dev_dbg(dev, "Configuring IR receiver for MCE protocol\n");
 		ir_proto_packet[0] = 0x01;
-		*rc_type = RC_BIT_RC6_MCE;
-	} else if (*rc_type & RC_BIT_OTHER) {
+		*rc_proto = RC_PROTO_BIT_RC6_MCE;
+	} else if (*rc_proto & RC_PROTO_BIT_OTHER) {
 		dev_dbg(dev, "Configuring IR receiver for iMON protocol\n");
 		if (!pad_stabilize)
 			dev_dbg(dev, "PAD stabilize functionality disabled\n");
 		/* ir_proto_packet[0] = 0x00; // already the default */
-		*rc_type = RC_BIT_OTHER;
+		*rc_proto = RC_PROTO_BIT_OTHER;
 	} else {
 		dev_warn(dev, "Unsupported IR protocol specified, overriding to iMON IR protocol\n");
 		if (!pad_stabilize)
 			dev_dbg(dev, "PAD stabilize functionality disabled\n");
 		/* ir_proto_packet[0] = 0x00; // already the default */
-		*rc_type = RC_BIT_OTHER;
+		*rc_proto = RC_PROTO_BIT_OTHER;
 	}
 
 	memcpy(ictx->usb_tx_buf, &ir_proto_packet, sizeof(ir_proto_packet));
@@ -1159,7 +1159,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_type)
 	if (retval)
 		goto out;
 
-	ictx->rc_type = *rc_type;
+	ictx->rc_proto = *rc_proto;
 	ictx->pad_mouse = false;
 
 out:
@@ -1435,7 +1435,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 		rel_x = buf[2];
 		rel_y = buf[3];
 
-		if (ictx->rc_type == RC_BIT_OTHER && pad_stabilize) {
+		if (ictx->rc_proto == RC_PROTO_BIT_OTHER && pad_stabilize) {
 			if ((buf[1] == 0) && ((rel_x != 0) || (rel_y != 0))) {
 				dir = stabilize((int)rel_x, (int)rel_y,
 						timeout, threshold);
@@ -1502,7 +1502,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 		buf[0] = 0x01;
 		buf[1] = buf[4] = buf[5] = buf[6] = buf[7] = 0;
 
-		if (ictx->rc_type == RC_BIT_OTHER && pad_stabilize) {
+		if (ictx->rc_proto == RC_PROTO_BIT_OTHER && pad_stabilize) {
 			dir = stabilize((int)rel_x, (int)rel_y,
 					timeout, threshold);
 			if (!dir) {
@@ -1706,7 +1706,7 @@ static void imon_incoming_scancode(struct imon_context *ictx,
 		ictx->release_code = false;
 	} else {
 		scancode = be32_to_cpu(*((__be32 *)buf));
-		if (ictx->rc_type == RC_BIT_RC6_MCE) {
+		if (ictx->rc_proto == RC_PROTO_BIT_RC6_MCE) {
 			ktype = IMON_KEY_IMON;
 			if (buf[0] == 0x80)
 				ktype = IMON_KEY_MCE;
@@ -1769,10 +1769,10 @@ static void imon_incoming_scancode(struct imon_context *ictx,
 		if (press_type == 0)
 			rc_keyup(ictx->rdev);
 		else {
-			if (ictx->rc_type == RC_BIT_RC6_MCE ||
-			    ictx->rc_type == RC_BIT_OTHER)
+			if (ictx->rc_proto == RC_PROTO_BIT_RC6_MCE ||
+			    ictx->rc_proto == RC_PROTO_BIT_OTHER)
 				rc_keydown(ictx->rdev,
-					   ictx->rc_type == RC_BIT_RC6_MCE ? RC_TYPE_RC6_MCE : RC_TYPE_OTHER,
+					   ictx->rc_proto == RC_PROTO_BIT_RC6_MCE ? RC_PROTO_RC6_MCE : RC_PROTO_OTHER,
 					   ictx->rc_scancode, ictx->rc_toggle);
 			spin_lock_irqsave(&ictx->kc_lock, flags);
 			ictx->last_keycode = ictx->kc;
@@ -1936,7 +1936,7 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 {
 	u8 ffdc_cfg_byte = ictx->usb_rx_buf[6];
 	u8 detected_display_type = IMON_DISPLAY_TYPE_NONE;
-	u64 allowed_protos = RC_BIT_OTHER;
+	u64 allowed_protos = RC_PROTO_BIT_OTHER;
 
 	switch (ffdc_cfg_byte) {
 	/* iMON Knob, no display, iMON IR + vol knob */
@@ -1967,27 +1967,27 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 	case 0x9e:
 		dev_info(ictx->dev, "0xffdc iMON VFD, MCE IR");
 		detected_display_type = IMON_DISPLAY_TYPE_VFD;
-		allowed_protos = RC_BIT_RC6_MCE;
+		allowed_protos = RC_PROTO_BIT_RC6_MCE;
 		break;
 	/* iMON LCD, MCE IR */
 	case 0x9f:
 		dev_info(ictx->dev, "0xffdc iMON LCD, MCE IR");
 		detected_display_type = IMON_DISPLAY_TYPE_LCD;
-		allowed_protos = RC_BIT_RC6_MCE;
+		allowed_protos = RC_PROTO_BIT_RC6_MCE;
 		break;
 	default:
 		dev_info(ictx->dev, "Unknown 0xffdc device, defaulting to VFD and iMON IR");
 		detected_display_type = IMON_DISPLAY_TYPE_VFD;
 		/* We don't know which one it is, allow user to set the
 		 * RC6 one from userspace if OTHER wasn't correct. */
-		allowed_protos |= RC_BIT_RC6_MCE;
+		allowed_protos |= RC_PROTO_BIT_RC6_MCE;
 		break;
 	}
 
 	printk(KERN_CONT " (id 0x%02x)\n", ffdc_cfg_byte);
 
 	ictx->display_type = detected_display_type;
-	ictx->rc_type = allowed_protos;
+	ictx->rc_proto = allowed_protos;
 }
 
 static void imon_set_display_type(struct imon_context *ictx)
@@ -2070,10 +2070,11 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 
 	rdev->priv = ictx;
 	if (ictx->dev_descr->flags & IMON_IR_RAW)
-		rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+		rdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	else
 		/* iMON PAD or MCE */
-		rdev->allowed_protocols = RC_BIT_OTHER | RC_BIT_RC6_MCE;
+		rdev->allowed_protocols = RC_PROTO_BIT_OTHER |
+					  RC_PROTO_BIT_RC6_MCE;
 	rdev->change_protocol = imon_ir_change_protocol;
 	rdev->driver_name = MOD_NAME;
 
@@ -2086,12 +2087,12 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 
 	if (ictx->product == 0xffdc) {
 		imon_get_ffdc_type(ictx);
-		rdev->allowed_protocols = ictx->rc_type;
+		rdev->allowed_protocols = ictx->rc_proto;
 	}
 
 	imon_set_display_type(ictx);
 
-	if (ictx->rc_type == RC_BIT_RC6_MCE ||
+	if (ictx->rc_proto == RC_PROTO_BIT_RC6_MCE ||
 	    ictx->dev_descr->flags & IMON_IR_RAW)
 		rdev->map_name = RC_MAP_IMON_MCE;
 	else
diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index 0e639fb6f7b9..0ce11c41dfae 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -242,7 +242,7 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 	clk_prepare_enable(priv->clock);
 	priv->rate = clk_get_rate(priv->clock);
 
-	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	rdev->priv = priv;
 	rdev->open = hix5hd2_ir_open;
 	rdev->close = hix5hd2_ir_close;
diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 674bf156edcb..e2bd68c42edf 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -137,7 +137,7 @@ static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			scancode = (bitrev8((data->bits >> 8) & 0xff) << 8) |
 				   (bitrev8((data->bits >> 0) & 0xff) << 0);
 			IR_dprintk(1, "JVC scancode 0x%04x\n", scancode);
-			rc_keydown(dev, RC_TYPE_JVC, scancode, data->toggle);
+			rc_keydown(dev, RC_PROTO_JVC, scancode, data->toggle);
 			data->first = false;
 			data->old_bits = data->bits;
 		} else if (data->bits == data->old_bits) {
@@ -193,7 +193,7 @@ static const struct ir_raw_timings_pd ir_jvc_timings = {
  *		-ENOBUFS if there isn't enough space in the array to fit the
  *		encoding. In this case all @max events will have been written.
  */
-static int ir_jvc_encode(enum rc_type protocol, u32 scancode,
+static int ir_jvc_encode(enum rc_proto protocol, u32 scancode,
 			 struct ir_raw_event *events, unsigned int max)
 {
 	struct ir_raw_event *e = events;
@@ -209,7 +209,7 @@ static int ir_jvc_encode(enum rc_type protocol, u32 scancode,
 }
 
 static struct ir_raw_handler jvc_handler = {
-	.protocols	= RC_BIT_JVC,
+	.protocols	= RC_PROTO_BIT_JVC,
 	.decode		= ir_jvc_decode,
 	.encode		= ir_jvc_encode,
 };
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 5de14ae77421..7c572a643656 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -444,14 +444,14 @@ static const struct ir_raw_timings_manchester ir_mce_kbd_timings = {
  *              -ENOBUFS if there isn't enough space in the array to fit the
  *              encoding. In this case all @max events will have been written.
  */
-static int ir_mce_kbd_encode(enum rc_type protocol, u32 scancode,
+static int ir_mce_kbd_encode(enum rc_proto protocol, u32 scancode,
 			     struct ir_raw_event *events, unsigned int max)
 {
 	struct ir_raw_event *e = events;
 	int len, ret;
 	u64 raw;
 
-	if (protocol == RC_TYPE_MCIR2_KBD) {
+	if (protocol == RC_PROTO_MCIR2_KBD) {
 		raw = scancode |
 		      ((u64)MCIR2_KEYBOARD_HEADER << MCIR2_KEYBOARD_NBITS);
 		len = MCIR2_KEYBOARD_NBITS + MCIR2_HEADER_NBITS + 1;
@@ -469,7 +469,7 @@ static int ir_mce_kbd_encode(enum rc_type protocol, u32 scancode,
 }
 
 static struct ir_raw_handler mce_kbd_handler = {
-	.protocols	= RC_BIT_MCIR2_KBD | RC_BIT_MCIR2_MSE,
+	.protocols	= RC_PROTO_BIT_MCIR2_KBD | RC_PROTO_BIT_MCIR2_MSE,
 	.decode		= ir_mce_kbd_decode,
 	.encode		= ir_mce_kbd_encode,
 	.raw_register	= ir_mce_kbd_register,
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 23d2bc8c190d..817c18f2ddd1 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -49,7 +49,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct nec_dec *data = &dev->raw->nec;
 	u32 scancode;
-	enum rc_type rc_type;
+	enum rc_proto rc_proto;
 	u8 address, not_address, command, not_command;
 
 	if (!is_timing_event(ev)) {
@@ -158,12 +158,12 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		scancode = ir_nec_bytes_to_scancode(address, not_address,
 						    command, not_command,
-						    &rc_type);
+						    &rc_proto);
 
 		if (data->is_nec_x)
 			data->necx_repeat = true;
 
-		rc_keydown(dev, rc_type, scancode, 0);
+		rc_keydown(dev, rc_proto, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
@@ -180,19 +180,19 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
  * @scancode:	a single NEC scancode.
  * @raw:	raw data to be modulated.
  */
-static u32 ir_nec_scancode_to_raw(enum rc_type protocol, u32 scancode)
+static u32 ir_nec_scancode_to_raw(enum rc_proto protocol, u32 scancode)
 {
 	unsigned int addr, addr_inv, data, data_inv;
 
 	data = scancode & 0xff;
 
-	if (protocol == RC_TYPE_NEC32) {
+	if (protocol == RC_PROTO_NEC32) {
 		/* 32-bit NEC (used by Apple and TiVo remotes) */
 		/* scan encoding: aaAAddDD */
 		addr_inv   = (scancode >> 24) & 0xff;
 		addr       = (scancode >> 16) & 0xff;
 		data_inv   = (scancode >>  8) & 0xff;
-	} else if (protocol == RC_TYPE_NECX) {
+	} else if (protocol == RC_PROTO_NECX) {
 		/* Extended NEC */
 		/* scan encoding AAaaDD */
 		addr       = (scancode >> 16) & 0xff;
@@ -236,7 +236,7 @@ static const struct ir_raw_timings_pd ir_nec_timings = {
  *		-ENOBUFS if there isn't enough space in the array to fit the
  *		encoding. In this case all @max events will have been written.
  */
-static int ir_nec_encode(enum rc_type protocol, u32 scancode,
+static int ir_nec_encode(enum rc_proto protocol, u32 scancode,
 			 struct ir_raw_event *events, unsigned int max)
 {
 	struct ir_raw_event *e = events;
@@ -255,7 +255,8 @@ static int ir_nec_encode(enum rc_type protocol, u32 scancode,
 }
 
 static struct ir_raw_handler nec_handler = {
-	.protocols	= RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32,
+	.protocols	= RC_PROTO_BIT_NEC | RC_PROTO_BIT_NECX |
+							RC_PROTO_BIT_NEC32,
 	.decode		= ir_nec_decode,
 	.encode		= ir_nec_encode,
 };
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index fcfedf95def7..1292f534de43 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -51,7 +51,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct rc5_dec *data = &dev->raw->rc5;
 	u8 toggle;
 	u32 scancode;
-	enum rc_type protocol;
+	enum rc_proto protocol;
 
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
@@ -124,7 +124,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (data->is_rc5x && data->count == RC5X_NBITS) {
 			/* RC5X */
 			u8 xdata, command, system;
-			if (!(dev->enabled_protocols & RC_BIT_RC5X_20)) {
+			if (!(dev->enabled_protocols & RC_PROTO_BIT_RC5X_20)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
@@ -134,12 +134,12 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			toggle   = (data->bits & 0x20000) ? 1 : 0;
 			command += (data->bits & 0x40000) ? 0 : 0x40;
 			scancode = system << 16 | command << 8 | xdata;
-			protocol = RC_TYPE_RC5X_20;
+			protocol = RC_PROTO_RC5X_20;
 
 		} else if (!data->is_rc5x && data->count == RC5_NBITS) {
 			/* RC5 */
 			u8 command, system;
-			if (!(dev->enabled_protocols & RC_BIT_RC5)) {
+			if (!(dev->enabled_protocols & RC_PROTO_BIT_RC5)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
@@ -148,12 +148,12 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			toggle   = (data->bits & 0x00800) ? 1 : 0;
 			command += (data->bits & 0x01000) ? 0 : 0x40;
 			scancode = system << 8 | command;
-			protocol = RC_TYPE_RC5;
+			protocol = RC_PROTO_RC5;
 
 		} else if (!data->is_rc5x && data->count == RC5_SZ_NBITS) {
 			/* RC5 StreamZap */
 			u8 command, system;
-			if (!(dev->enabled_protocols & RC_BIT_RC5_SZ)) {
+			if (!(dev->enabled_protocols & RC_PROTO_BIT_RC5_SZ)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
@@ -161,7 +161,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			system   = (data->bits & 0x02FC0) >> 6;
 			toggle   = (data->bits & 0x01000) ? 1 : 0;
 			scancode = system << 6 | command;
-			protocol = RC_TYPE_RC5_SZ;
+			protocol = RC_PROTO_RC5_SZ;
 
 		} else
 			break;
@@ -221,7 +221,7 @@ static const struct ir_raw_timings_manchester ir_rc5_sz_timings = {
  *		encoding. In this case all @max events will have been written.
  *		-EINVAL if the scancode is ambiguous or invalid.
  */
-static int ir_rc5_encode(enum rc_type protocol, u32 scancode,
+static int ir_rc5_encode(enum rc_proto protocol, u32 scancode,
 			 struct ir_raw_event *events, unsigned int max)
 {
 	int ret;
@@ -229,7 +229,7 @@ static int ir_rc5_encode(enum rc_type protocol, u32 scancode,
 	unsigned int data, xdata, command, commandx, system, pre_space_data;
 
 	/* Detect protocol and convert scancode to raw data */
-	if (protocol == RC_TYPE_RC5) {
+	if (protocol == RC_PROTO_RC5) {
 		/* decode scancode */
 		command  = (scancode & 0x003f) >> 0;
 		commandx = (scancode & 0x0040) >> 6;
@@ -242,7 +242,7 @@ static int ir_rc5_encode(enum rc_type protocol, u32 scancode,
 					    RC5_NBITS, data);
 		if (ret < 0)
 			return ret;
-	} else if (protocol == RC_TYPE_RC5X_20) {
+	} else if (protocol == RC_PROTO_RC5X_20) {
 		/* decode scancode */
 		xdata    = (scancode & 0x00003f) >> 0;
 		command  = (scancode & 0x003f00) >> 8;
@@ -264,7 +264,7 @@ static int ir_rc5_encode(enum rc_type protocol, u32 scancode,
 					    data);
 		if (ret < 0)
 			return ret;
-	} else if (protocol == RC_TYPE_RC5_SZ) {
+	} else if (protocol == RC_PROTO_RC5_SZ) {
 		/* RC5-SZ scancode is raw enough for Manchester as it is */
 		ret = ir_raw_gen_manchester(&e, max, &ir_rc5_sz_timings,
 					    RC5_SZ_NBITS, scancode & 0x2fff);
@@ -278,7 +278,8 @@ static int ir_rc5_encode(enum rc_type protocol, u32 scancode,
 }
 
 static struct ir_raw_handler rc5_handler = {
-	.protocols	= RC_BIT_RC5 | RC_BIT_RC5X_20 | RC_BIT_RC5_SZ,
+	.protocols	= RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC5X_20 |
+							RC_PROTO_BIT_RC5_SZ,
 	.decode		= ir_rc5_decode,
 	.encode		= ir_rc5_encode,
 };
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 6fe2268dada0..5d0d2fe3b7a7 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -88,7 +88,7 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct rc6_dec *data = &dev->raw->rc6;
 	u32 scancode;
 	u8 toggle;
-	enum rc_type protocol;
+	enum rc_proto protocol;
 
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
@@ -229,7 +229,7 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		case RC6_MODE_0:
 			scancode = data->body;
 			toggle = data->toggle;
-			protocol = RC_TYPE_RC6_0;
+			protocol = RC_PROTO_RC6_0;
 			IR_dprintk(1, "RC6(0) scancode 0x%04x (toggle: %u)\n",
 				   scancode, toggle);
 			break;
@@ -244,20 +244,20 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			scancode = data->body;
 			switch (data->count) {
 			case 20:
-				protocol = RC_TYPE_RC6_6A_20;
+				protocol = RC_PROTO_RC6_6A_20;
 				toggle = 0;
 				break;
 			case 24:
-				protocol = RC_TYPE_RC6_6A_24;
+				protocol = RC_PROTO_RC6_6A_24;
 				toggle = 0;
 				break;
 			case 32:
 				if ((scancode & RC6_6A_LCC_MASK) == RC6_6A_MCE_CC) {
-					protocol = RC_TYPE_RC6_MCE;
+					protocol = RC_PROTO_RC6_MCE;
 					toggle = !!(scancode & RC6_6A_MCE_TOGGLE_MASK);
 					scancode &= ~RC6_6A_MCE_TOGGLE_MASK;
 				} else {
-					protocol = RC_TYPE_RC6_6A_32;
+					protocol = RC_PROTO_RC6_6A_32;
 					toggle = 0;
 				}
 				break;
@@ -322,13 +322,13 @@ static const struct ir_raw_timings_manchester ir_rc6_timings[4] = {
  *		encoding. In this case all @max events will have been written.
  *		-EINVAL if the scancode is ambiguous or invalid.
  */
-static int ir_rc6_encode(enum rc_type protocol, u32 scancode,
+static int ir_rc6_encode(enum rc_proto protocol, u32 scancode,
 			 struct ir_raw_event *events, unsigned int max)
 {
 	int ret;
 	struct ir_raw_event *e = events;
 
-	if (protocol == RC_TYPE_RC6_0) {
+	if (protocol == RC_PROTO_RC6_0) {
 		/* Modulate the preamble */
 		ret = ir_raw_gen_manchester(&e, max, &ir_rc6_timings[0], 0, 0);
 		if (ret < 0)
@@ -358,14 +358,14 @@ static int ir_rc6_encode(enum rc_type protocol, u32 scancode,
 		int bits;
 
 		switch (protocol) {
-		case RC_TYPE_RC6_MCE:
-		case RC_TYPE_RC6_6A_32:
+		case RC_PROTO_RC6_MCE:
+		case RC_PROTO_RC6_6A_32:
 			bits = 32;
 			break;
-		case RC_TYPE_RC6_6A_24:
+		case RC_PROTO_RC6_6A_24:
 			bits = 24;
 			break;
-		case RC_TYPE_RC6_6A_20:
+		case RC_PROTO_RC6_6A_20:
 			bits = 20;
 			break;
 		default:
@@ -403,9 +403,9 @@ static int ir_rc6_encode(enum rc_type protocol, u32 scancode,
 }
 
 static struct ir_raw_handler rc6_handler = {
-	.protocols	= RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 |
-			  RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32 |
-			  RC_BIT_RC6_MCE,
+	.protocols	= RC_PROTO_BIT_RC6_0 | RC_PROTO_BIT_RC6_6A_20 |
+			  RC_PROTO_BIT_RC6_6A_24 | RC_PROTO_BIT_RC6_6A_32 |
+			  RC_PROTO_BIT_RC6_MCE,
 	.decode		= ir_rc6_decode,
 	.encode		= ir_rc6_encode,
 };
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index e6a906a34f90..758c60956850 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -161,7 +161,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		scancode = address << 8 | command;
 		IR_dprintk(1, "SANYO scancode: 0x%06x\n", scancode);
-		rc_keydown(dev, RC_TYPE_SANYO, scancode, 0);
+		rc_keydown(dev, RC_PROTO_SANYO, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
@@ -195,7 +195,7 @@ static const struct ir_raw_timings_pd ir_sanyo_timings = {
  *		-ENOBUFS if there isn't enough space in the array to fit the
  *		encoding. In this case all @max events will have been written.
  */
-static int ir_sanyo_encode(enum rc_type protocol, u32 scancode,
+static int ir_sanyo_encode(enum rc_proto protocol, u32 scancode,
 			   struct ir_raw_event *events, unsigned int max)
 {
 	struct ir_raw_event *e = events;
@@ -215,7 +215,7 @@ static int ir_sanyo_encode(enum rc_type protocol, u32 scancode,
 }
 
 static struct ir_raw_handler sanyo_handler = {
-	.protocols	= RC_BIT_SANYO,
+	.protocols	= RC_PROTO_BIT_SANYO,
 	.decode		= ir_sanyo_decode,
 	.encode		= ir_sanyo_encode,
 };
diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
index b47e89e2c1bd..ed43a4212479 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -161,7 +161,7 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		scancode = address << 8 | command;
 		IR_dprintk(1, "Sharp scancode 0x%04x\n", scancode);
 
-		rc_keydown(dev, RC_TYPE_SHARP, scancode, 0);
+		rc_keydown(dev, RC_PROTO_SHARP, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
@@ -196,7 +196,7 @@ static const struct ir_raw_timings_pd ir_sharp_timings = {
  *		-ENOBUFS if there isn't enough space in the array to fit the
  *		encoding. In this case all @max events will have been written.
  */
-static int ir_sharp_encode(enum rc_type protocol, u32 scancode,
+static int ir_sharp_encode(enum rc_proto protocol, u32 scancode,
 			   struct ir_raw_event *events, unsigned int max)
 {
 	struct ir_raw_event *e = events;
@@ -223,7 +223,7 @@ static int ir_sharp_encode(enum rc_type protocol, u32 scancode,
 }
 
 static struct ir_raw_handler sharp_handler = {
-	.protocols	= RC_BIT_SHARP,
+	.protocols	= RC_PROTO_BIT_SHARP,
 	.decode		= ir_sharp_decode,
 	.encode		= ir_sharp_encode,
 };
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index 355fa8198f5a..a47ced763031 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -42,7 +42,7 @@ enum sony_state {
 static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct sony_dec *data = &dev->raw->sony;
-	enum rc_type protocol;
+	enum rc_proto protocol;
 	u32 scancode;
 	u8 device, subdevice, function;
 
@@ -121,31 +121,31 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		switch (data->count) {
 		case 12:
-			if (!(dev->enabled_protocols & RC_BIT_SONY12))
+			if (!(dev->enabled_protocols & RC_PROTO_BIT_SONY12))
 				goto finish_state_machine;
 
 			device    = bitrev8((data->bits <<  3) & 0xF8);
 			subdevice = 0;
 			function  = bitrev8((data->bits >>  4) & 0xFE);
-			protocol = RC_TYPE_SONY12;
+			protocol = RC_PROTO_SONY12;
 			break;
 		case 15:
-			if (!(dev->enabled_protocols & RC_BIT_SONY15))
+			if (!(dev->enabled_protocols & RC_PROTO_BIT_SONY15))
 				goto finish_state_machine;
 
 			device    = bitrev8((data->bits >>  0) & 0xFF);
 			subdevice = 0;
 			function  = bitrev8((data->bits >>  7) & 0xFE);
-			protocol = RC_TYPE_SONY15;
+			protocol = RC_PROTO_SONY15;
 			break;
 		case 20:
-			if (!(dev->enabled_protocols & RC_BIT_SONY20))
+			if (!(dev->enabled_protocols & RC_PROTO_BIT_SONY20))
 				goto finish_state_machine;
 
 			device    = bitrev8((data->bits >>  5) & 0xF8);
 			subdevice = bitrev8((data->bits >>  0) & 0xFF);
 			function  = bitrev8((data->bits >> 12) & 0xFE);
-			protocol = RC_TYPE_SONY20;
+			protocol = RC_PROTO_SONY20;
 			break;
 		default:
 			IR_dprintk(1, "Sony invalid bitcount %u\n", data->count);
@@ -190,17 +190,17 @@ static const struct ir_raw_timings_pl ir_sony_timings = {
  *		-ENOBUFS if there isn't enough space in the array to fit the
  *		encoding. In this case all @max events will have been written.
  */
-static int ir_sony_encode(enum rc_type protocol, u32 scancode,
+static int ir_sony_encode(enum rc_proto protocol, u32 scancode,
 			  struct ir_raw_event *events, unsigned int max)
 {
 	struct ir_raw_event *e = events;
 	u32 raw, len;
 	int ret;
 
-	if (protocol == RC_TYPE_SONY12) {
+	if (protocol == RC_PROTO_SONY12) {
 		raw = (scancode & 0x7f) | ((scancode & 0x1f0000) >> 9);
 		len = 12;
-	} else if (protocol == RC_TYPE_SONY15) {
+	} else if (protocol == RC_PROTO_SONY15) {
 		raw = (scancode & 0x7f) | ((scancode & 0xff0000) >> 9);
 		len = 15;
 	} else {
@@ -217,7 +217,8 @@ static int ir_sony_encode(enum rc_type protocol, u32 scancode,
 }
 
 static struct ir_raw_handler sony_handler = {
-	.protocols	= RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20,
+	.protocols	= RC_PROTO_BIT_SONY12 | RC_PROTO_BIT_SONY15 |
+							RC_PROTO_BIT_SONY20,
 	.decode		= ir_sony_decode,
 	.encode		= ir_sony_encode,
 };
diff --git a/drivers/media/rc/ir-xmp-decoder.c b/drivers/media/rc/ir-xmp-decoder.c
index 18596190bbb8..6f464be1c8d7 100644
--- a/drivers/media/rc/ir-xmp-decoder.c
+++ b/drivers/media/rc/ir-xmp-decoder.c
@@ -141,7 +141,7 @@ static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			IR_dprintk(1, "XMP scancode 0x%06x\n", scancode);
 
 			if (toggle == 0) {
-				rc_keydown(dev, RC_TYPE_XMP, scancode, 0);
+				rc_keydown(dev, RC_PROTO_XMP, scancode, 0);
 			} else {
 				rc_repeat(dev);
 				IR_dprintk(1, "Repeat last key\n");
@@ -196,7 +196,7 @@ static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 }
 
 static struct ir_raw_handler xmp_handler = {
-	.protocols	= RC_BIT_XMP,
+	.protocols	= RC_PROTO_BIT_XMP,
 	.decode		= ir_xmp_decode,
 };
 
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index c8eea30b4e50..65e104c7ddfc 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1556,7 +1556,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 
 	/* set up ir-core props */
 	rdev->priv = itdev;
-	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	rdev->open = ite_open;
 	rdev->close = ite_close;
 	rdev->s_idle = ite_s_idle;
diff --git a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
index 01d901fbfc8b..2d303c2cee3b 100644
--- a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
+++ b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
@@ -66,10 +66,10 @@ static struct rc_map_table adstech_dvb_t_pci[] = {
 
 static struct rc_map_list adstech_dvb_t_pci_map = {
 	.map = {
-		.scan    = adstech_dvb_t_pci,
-		.size    = ARRAY_SIZE(adstech_dvb_t_pci),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_ADSTECH_DVB_T_PCI,
+		.scan     = adstech_dvb_t_pci,
+		.size     = ARRAY_SIZE(adstech_dvb_t_pci),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_ADSTECH_DVB_T_PCI,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-alink-dtu-m.c b/drivers/media/rc/keymaps/rc-alink-dtu-m.c
index 4e6ade8e616f..3818c33734a1 100644
--- a/drivers/media/rc/keymaps/rc-alink-dtu-m.c
+++ b/drivers/media/rc/keymaps/rc-alink-dtu-m.c
@@ -45,10 +45,10 @@ static struct rc_map_table alink_dtu_m[] = {
 
 static struct rc_map_list alink_dtu_m_map = {
 	.map = {
-		.scan    = alink_dtu_m,
-		.size    = ARRAY_SIZE(alink_dtu_m),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_ALINK_DTU_M,
+		.scan     = alink_dtu_m,
+		.size     = ARRAY_SIZE(alink_dtu_m),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_ALINK_DTU_M,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-anysee.c b/drivers/media/rc/keymaps/rc-anysee.c
index c735fe10a390..e75e51b34d29 100644
--- a/drivers/media/rc/keymaps/rc-anysee.c
+++ b/drivers/media/rc/keymaps/rc-anysee.c
@@ -70,10 +70,10 @@ static struct rc_map_table anysee[] = {
 
 static struct rc_map_list anysee_map = {
 	.map = {
-		.scan    = anysee,
-		.size    = ARRAY_SIZE(anysee),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_ANYSEE,
+		.scan     = anysee,
+		.size     = ARRAY_SIZE(anysee),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_ANYSEE,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-apac-viewcomp.c b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
index bf9efa007e1c..65bc8957d9c3 100644
--- a/drivers/media/rc/keymaps/rc-apac-viewcomp.c
+++ b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
@@ -57,10 +57,10 @@ static struct rc_map_table apac_viewcomp[] = {
 
 static struct rc_map_list apac_viewcomp_map = {
 	.map = {
-		.scan    = apac_viewcomp,
-		.size    = ARRAY_SIZE(apac_viewcomp),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_APAC_VIEWCOMP,
+		.scan     = apac_viewcomp,
+		.size     = ARRAY_SIZE(apac_viewcomp),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_APAC_VIEWCOMP,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-asus-pc39.c b/drivers/media/rc/keymaps/rc-asus-pc39.c
index 9e674ba5dd4f..530e1d1158d1 100644
--- a/drivers/media/rc/keymaps/rc-asus-pc39.c
+++ b/drivers/media/rc/keymaps/rc-asus-pc39.c
@@ -68,10 +68,10 @@ static struct rc_map_table asus_pc39[] = {
 
 static struct rc_map_list asus_pc39_map = {
 	.map = {
-		.scan    = asus_pc39,
-		.size    = ARRAY_SIZE(asus_pc39),
-		.rc_type = RC_TYPE_RC5,
-		.name    = RC_MAP_ASUS_PC39,
+		.scan     = asus_pc39,
+		.size     = ARRAY_SIZE(asus_pc39),
+		.rc_proto = RC_PROTO_RC5,
+		.name     = RC_MAP_ASUS_PC39,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-asus-ps3-100.c b/drivers/media/rc/keymaps/rc-asus-ps3-100.c
index e45de35f528f..c91ba332984c 100644
--- a/drivers/media/rc/keymaps/rc-asus-ps3-100.c
+++ b/drivers/media/rc/keymaps/rc-asus-ps3-100.c
@@ -67,10 +67,10 @@ static struct rc_map_table asus_ps3_100[] = {
 
 static struct rc_map_list asus_ps3_100_map = {
 .map = {
-	.scan    = asus_ps3_100,
-	.size    = ARRAY_SIZE(asus_ps3_100),
-	.rc_type = RC_TYPE_RC5,
-	.name    = RC_MAP_ASUS_PS3_100,
+	.scan     = asus_ps3_100,
+	.size     = ARRAY_SIZE(asus_ps3_100),
+	.rc_proto = RC_PROTO_RC5,
+	.name     = RC_MAP_ASUS_PS3_100,
 }
 };
 
diff --git a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
index 91392d4cfd6d..11b4bdd2392b 100644
--- a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
+++ b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
@@ -46,10 +46,10 @@ static struct rc_map_table ati_tv_wonder_hd_600[] = {
 
 static struct rc_map_list ati_tv_wonder_hd_600_map = {
 	.map = {
-		.scan    = ati_tv_wonder_hd_600,
-		.size    = ARRAY_SIZE(ati_tv_wonder_hd_600),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_ATI_TV_WONDER_HD_600,
+		.scan     = ati_tv_wonder_hd_600,
+		.size     = ARRAY_SIZE(ati_tv_wonder_hd_600),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_ATI_TV_WONDER_HD_600,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-ati-x10.c b/drivers/media/rc/keymaps/rc-ati-x10.c
index 4bdc709ec54d..11f1eb6ad712 100644
--- a/drivers/media/rc/keymaps/rc-ati-x10.c
+++ b/drivers/media/rc/keymaps/rc-ati-x10.c
@@ -114,10 +114,10 @@ static struct rc_map_table ati_x10[] = {
 
 static struct rc_map_list ati_x10_map = {
 	.map = {
-		.scan    = ati_x10,
-		.size    = ARRAY_SIZE(ati_x10),
-		.rc_type = RC_TYPE_OTHER,
-		.name    = RC_MAP_ATI_X10,
+		.scan     = ati_x10,
+		.size     = ARRAY_SIZE(ati_x10),
+		.rc_proto = RC_PROTO_OTHER,
+		.name     = RC_MAP_ATI_X10,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-avermedia-a16d.c b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
index ff30a71d623e..510dc90ebf49 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-a16d.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
@@ -52,10 +52,10 @@ static struct rc_map_table avermedia_a16d[] = {
 
 static struct rc_map_list avermedia_a16d_map = {
 	.map = {
-		.scan    = avermedia_a16d,
-		.size    = ARRAY_SIZE(avermedia_a16d),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_AVERMEDIA_A16D,
+		.scan     = avermedia_a16d,
+		.size     = ARRAY_SIZE(avermedia_a16d),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_AVERMEDIA_A16D,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
index d7471a6de9b4..4bbc1e68d1b8 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
@@ -74,10 +74,10 @@ static struct rc_map_table avermedia_cardbus[] = {
 
 static struct rc_map_list avermedia_cardbus_map = {
 	.map = {
-		.scan    = avermedia_cardbus,
-		.size    = ARRAY_SIZE(avermedia_cardbus),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_AVERMEDIA_CARDBUS,
+		.scan     = avermedia_cardbus,
+		.size     = ARRAY_SIZE(avermedia_cardbus),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_AVERMEDIA_CARDBUS,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
index e2417d6331fe..f6b8547dbad3 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
@@ -55,10 +55,10 @@ static struct rc_map_table avermedia_dvbt[] = {
 
 static struct rc_map_list avermedia_dvbt_map = {
 	.map = {
-		.scan    = avermedia_dvbt,
-		.size    = ARRAY_SIZE(avermedia_dvbt),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_AVERMEDIA_DVBT,
+		.scan     = avermedia_dvbt,
+		.size     = ARRAY_SIZE(avermedia_dvbt),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_AVERMEDIA_DVBT,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m135a.c b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
index 843598a5f1b5..9882e2cde975 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m135a.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
@@ -124,10 +124,10 @@ static struct rc_map_table avermedia_m135a[] = {
 
 static struct rc_map_list avermedia_m135a_map = {
 	.map = {
-		.scan    = avermedia_m135a,
-		.size    = ARRAY_SIZE(avermedia_m135a),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_AVERMEDIA_M135A,
+		.scan     = avermedia_m135a,
+		.size     = ARRAY_SIZE(avermedia_m135a),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_AVERMEDIA_M135A,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
index b24e7481ac21..d86126e10375 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
@@ -72,10 +72,10 @@ static struct rc_map_table avermedia_m733a_rm_k6[] = {
 
 static struct rc_map_list avermedia_m733a_rm_k6_map = {
 	.map = {
-		.scan    = avermedia_m733a_rm_k6,
-		.size    = ARRAY_SIZE(avermedia_m733a_rm_k6),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_AVERMEDIA_M733A_RM_K6,
+		.scan     = avermedia_m733a_rm_k6,
+		.size     = ARRAY_SIZE(avermedia_m733a_rm_k6),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_AVERMEDIA_M733A_RM_K6,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
index 2583400ca1b4..5d92d36d9174 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
@@ -56,10 +56,10 @@ static struct rc_map_table avermedia_rm_ks[] = {
 
 static struct rc_map_list avermedia_rm_ks_map = {
 	.map = {
-		.scan    = avermedia_rm_ks,
-		.size    = ARRAY_SIZE(avermedia_rm_ks),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_AVERMEDIA_RM_KS,
+		.scan     = avermedia_rm_ks,
+		.size     = ARRAY_SIZE(avermedia_rm_ks),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_AVERMEDIA_RM_KS,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-avermedia.c b/drivers/media/rc/keymaps/rc-avermedia.c
index 3f68fbecc188..6503f11c7df5 100644
--- a/drivers/media/rc/keymaps/rc-avermedia.c
+++ b/drivers/media/rc/keymaps/rc-avermedia.c
@@ -63,10 +63,10 @@ static struct rc_map_table avermedia[] = {
 
 static struct rc_map_list avermedia_map = {
 	.map = {
-		.scan    = avermedia,
-		.size    = ARRAY_SIZE(avermedia),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_AVERMEDIA,
+		.scan     = avermedia,
+		.size     = ARRAY_SIZE(avermedia),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_AVERMEDIA,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-avertv-303.c b/drivers/media/rc/keymaps/rc-avertv-303.c
index c35bc5b835c4..fbdd7ada57ce 100644
--- a/drivers/media/rc/keymaps/rc-avertv-303.c
+++ b/drivers/media/rc/keymaps/rc-avertv-303.c
@@ -62,10 +62,10 @@ static struct rc_map_table avertv_303[] = {
 
 static struct rc_map_list avertv_303_map = {
 	.map = {
-		.scan    = avertv_303,
-		.size    = ARRAY_SIZE(avertv_303),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_AVERTV_303,
+		.scan     = avertv_303,
+		.size     = ARRAY_SIZE(avertv_303),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_AVERTV_303,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c b/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
index ea7f2d0f31eb..18d7dcb869b0 100644
--- a/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
+++ b/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
@@ -79,10 +79,10 @@ static struct rc_map_table azurewave_ad_tu700[] = {
 
 static struct rc_map_list azurewave_ad_tu700_map = {
 	.map = {
-		.scan    = azurewave_ad_tu700,
-		.size    = ARRAY_SIZE(azurewave_ad_tu700),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_AZUREWAVE_AD_TU700,
+		.scan     = azurewave_ad_tu700,
+		.size     = ARRAY_SIZE(azurewave_ad_tu700),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_AZUREWAVE_AD_TU700,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-behold-columbus.c b/drivers/media/rc/keymaps/rc-behold-columbus.c
index 1fc344e9daa7..d256743be998 100644
--- a/drivers/media/rc/keymaps/rc-behold-columbus.c
+++ b/drivers/media/rc/keymaps/rc-behold-columbus.c
@@ -85,10 +85,10 @@ static struct rc_map_table behold_columbus[] = {
 
 static struct rc_map_list behold_columbus_map = {
 	.map = {
-		.scan    = behold_columbus,
-		.size    = ARRAY_SIZE(behold_columbus),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_BEHOLD_COLUMBUS,
+		.scan     = behold_columbus,
+		.size     = ARRAY_SIZE(behold_columbus),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_BEHOLD_COLUMBUS,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
index 520a96f2ff86..93dc795adc67 100644
--- a/drivers/media/rc/keymaps/rc-behold.c
+++ b/drivers/media/rc/keymaps/rc-behold.c
@@ -118,10 +118,10 @@ static struct rc_map_table behold[] = {
 
 static struct rc_map_list behold_map = {
 	.map = {
-		.scan    = behold,
-		.size    = ARRAY_SIZE(behold),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_BEHOLD,
+		.scan     = behold,
+		.size     = ARRAY_SIZE(behold),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_BEHOLD,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-budget-ci-old.c b/drivers/media/rc/keymaps/rc-budget-ci-old.c
index b196a5f436a3..81ea1424d9e5 100644
--- a/drivers/media/rc/keymaps/rc-budget-ci-old.c
+++ b/drivers/media/rc/keymaps/rc-budget-ci-old.c
@@ -70,10 +70,10 @@ static struct rc_map_table budget_ci_old[] = {
 
 static struct rc_map_list budget_ci_old_map = {
 	.map = {
-		.scan    = budget_ci_old,
-		.size    = ARRAY_SIZE(budget_ci_old),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_BUDGET_CI_OLD,
+		.scan     = budget_ci_old,
+		.size     = ARRAY_SIZE(budget_ci_old),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_BUDGET_CI_OLD,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-cec.c b/drivers/media/rc/keymaps/rc-cec.c
index 354c8e724b8e..76d34abb7c85 100644
--- a/drivers/media/rc/keymaps/rc-cec.c
+++ b/drivers/media/rc/keymaps/rc-cec.c
@@ -160,7 +160,7 @@ static struct rc_map_list cec_map = {
 	.map = {
 		.scan		= cec,
 		.size		= ARRAY_SIZE(cec),
-		.rc_type	= RC_TYPE_CEC,
+		.rc_proto	= RC_PROTO_CEC,
 		.name		= RC_MAP_CEC,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-cinergy-1400.c b/drivers/media/rc/keymaps/rc-cinergy-1400.c
index a099c080bf8c..bcb96b3dda85 100644
--- a/drivers/media/rc/keymaps/rc-cinergy-1400.c
+++ b/drivers/media/rc/keymaps/rc-cinergy-1400.c
@@ -61,10 +61,10 @@ static struct rc_map_table cinergy_1400[] = {
 
 static struct rc_map_list cinergy_1400_map = {
 	.map = {
-		.scan    = cinergy_1400,
-		.size    = ARRAY_SIZE(cinergy_1400),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_CINERGY_1400,
+		.scan     = cinergy_1400,
+		.size     = ARRAY_SIZE(cinergy_1400),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_CINERGY_1400,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-cinergy.c b/drivers/media/rc/keymaps/rc-cinergy.c
index b0f4328bdd6f..fd56c402aae5 100644
--- a/drivers/media/rc/keymaps/rc-cinergy.c
+++ b/drivers/media/rc/keymaps/rc-cinergy.c
@@ -55,10 +55,10 @@ static struct rc_map_table cinergy[] = {
 
 static struct rc_map_list cinergy_map = {
 	.map = {
-		.scan    = cinergy,
-		.size    = ARRAY_SIZE(cinergy),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_CINERGY,
+		.scan     = cinergy,
+		.size     = ARRAY_SIZE(cinergy),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_CINERGY,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-d680-dmb.c b/drivers/media/rc/keymaps/rc-d680-dmb.c
index bb5745d29d8a..2c94b9d88b67 100644
--- a/drivers/media/rc/keymaps/rc-d680-dmb.c
+++ b/drivers/media/rc/keymaps/rc-d680-dmb.c
@@ -51,10 +51,10 @@ static struct rc_map_table rc_map_d680_dmb_table[] = {
 
 static struct rc_map_list d680_dmb_map = {
 	.map = {
-		.scan    = rc_map_d680_dmb_table,
-		.size    = ARRAY_SIZE(rc_map_d680_dmb_table),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_D680_DMB,
+		.scan     = rc_map_d680_dmb_table,
+		.size     = ARRAY_SIZE(rc_map_d680_dmb_table),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_D680_DMB,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-delock-61959.c b/drivers/media/rc/keymaps/rc-delock-61959.c
index 01bed864f09d..62de69d78d92 100644
--- a/drivers/media/rc/keymaps/rc-delock-61959.c
+++ b/drivers/media/rc/keymaps/rc-delock-61959.c
@@ -58,10 +58,10 @@ static struct rc_map_table delock_61959[] = {
 
 static struct rc_map_list delock_61959_map = {
 	.map = {
-		.scan    = delock_61959,
-		.size    = ARRAY_SIZE(delock_61959),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_DELOCK_61959,
+		.scan     = delock_61959,
+		.size     = ARRAY_SIZE(delock_61959),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_DELOCK_61959,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-dib0700-nec.c b/drivers/media/rc/keymaps/rc-dib0700-nec.c
index a0fa543c9f9e..1b4df106b7b5 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-nec.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-nec.c
@@ -101,10 +101,10 @@ static struct rc_map_table dib0700_nec_table[] = {
 
 static struct rc_map_list dib0700_nec_map = {
 	.map = {
-		.scan    = dib0700_nec_table,
-		.size    = ARRAY_SIZE(dib0700_nec_table),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_DIB0700_NEC_TABLE,
+		.scan     = dib0700_nec_table,
+		.size     = ARRAY_SIZE(dib0700_nec_table),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_DIB0700_NEC_TABLE,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-dib0700-rc5.c b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
index 907941145eb7..b0f8151bb824 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-rc5.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
@@ -212,10 +212,10 @@ static struct rc_map_table dib0700_rc5_table[] = {
 
 static struct rc_map_list dib0700_rc5_map = {
 	.map = {
-		.scan    = dib0700_rc5_table,
-		.size    = ARRAY_SIZE(dib0700_rc5_table),
-		.rc_type = RC_TYPE_RC5,
-		.name    = RC_MAP_DIB0700_RC5_TABLE,
+		.scan     = dib0700_rc5_table,
+		.size     = ARRAY_SIZE(dib0700_rc5_table),
+		.rc_proto = RC_PROTO_RC5,
+		.name     = RC_MAP_DIB0700_RC5_TABLE,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c b/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
index bed78acb9198..01ca8b39359f 100644
--- a/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
+++ b/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
@@ -75,10 +75,10 @@ static struct rc_map_table digitalnow_tinytwin[] = {
 
 static struct rc_map_list digitalnow_tinytwin_map = {
 	.map = {
-		.scan    = digitalnow_tinytwin,
-		.size    = ARRAY_SIZE(digitalnow_tinytwin),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_DIGITALNOW_TINYTWIN,
+		.scan     = digitalnow_tinytwin,
+		.size     = ARRAY_SIZE(digitalnow_tinytwin),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_DIGITALNOW_TINYTWIN,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-digittrade.c b/drivers/media/rc/keymaps/rc-digittrade.c
index a3b97a1fe223..a54b1d632ca6 100644
--- a/drivers/media/rc/keymaps/rc-digittrade.c
+++ b/drivers/media/rc/keymaps/rc-digittrade.c
@@ -59,10 +59,10 @@ static struct rc_map_table digittrade[] = {
 
 static struct rc_map_list digittrade_map = {
 	.map = {
-		.scan    = digittrade,
-		.size    = ARRAY_SIZE(digittrade),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_DIGITTRADE,
+		.scan     = digittrade,
+		.size     = ARRAY_SIZE(digittrade),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_DIGITTRADE,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-dm1105-nec.c b/drivers/media/rc/keymaps/rc-dm1105-nec.c
index 46e7ae414cc8..c353445d10ed 100644
--- a/drivers/media/rc/keymaps/rc-dm1105-nec.c
+++ b/drivers/media/rc/keymaps/rc-dm1105-nec.c
@@ -53,10 +53,10 @@ static struct rc_map_table dm1105_nec[] = {
 
 static struct rc_map_list dm1105_nec_map = {
 	.map = {
-		.scan    = dm1105_nec,
-		.size    = ARRAY_SIZE(dm1105_nec),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_DM1105_NEC,
+		.scan     = dm1105_nec,
+		.size     = ARRAY_SIZE(dm1105_nec),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_DM1105_NEC,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
index d2826b46fea2..5bafd5b70f5e 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
@@ -55,10 +55,10 @@ static struct rc_map_table dntv_live_dvb_t[] = {
 
 static struct rc_map_list dntv_live_dvb_t_map = {
 	.map = {
-		.scan    = dntv_live_dvb_t,
-		.size    = ARRAY_SIZE(dntv_live_dvb_t),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_DNTV_LIVE_DVB_T,
+		.scan     = dntv_live_dvb_t,
+		.size     = ARRAY_SIZE(dntv_live_dvb_t),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_DNTV_LIVE_DVB_T,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
index 0d74769467b5..360167c8829b 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
@@ -74,10 +74,10 @@ static struct rc_map_table dntv_live_dvbt_pro[] = {
 
 static struct rc_map_list dntv_live_dvbt_pro_map = {
 	.map = {
-		.scan    = dntv_live_dvbt_pro,
-		.size    = ARRAY_SIZE(dntv_live_dvbt_pro),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_DNTV_LIVE_DVBT_PRO,
+		.scan     = dntv_live_dvbt_pro,
+		.size     = ARRAY_SIZE(dntv_live_dvbt_pro),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_DNTV_LIVE_DVBT_PRO,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-dtt200u.c b/drivers/media/rc/keymaps/rc-dtt200u.c
index 25650e9e4664..c932d8b6c509 100644
--- a/drivers/media/rc/keymaps/rc-dtt200u.c
+++ b/drivers/media/rc/keymaps/rc-dtt200u.c
@@ -35,10 +35,10 @@ static struct rc_map_table dtt200u_table[] = {
 
 static struct rc_map_list dtt200u_map = {
 	.map = {
-		.scan    = dtt200u_table,
-		.size    = ARRAY_SIZE(dtt200u_table),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_DTT200U,
+		.scan     = dtt200u_table,
+		.size     = ARRAY_SIZE(dtt200u_table),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_DTT200U,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-dvbsky.c b/drivers/media/rc/keymaps/rc-dvbsky.c
index c5115a1165d1..d6c0b4c1e20e 100644
--- a/drivers/media/rc/keymaps/rc-dvbsky.c
+++ b/drivers/media/rc/keymaps/rc-dvbsky.c
@@ -54,10 +54,10 @@ static struct rc_map_table rc5_dvbsky[] = {
 
 static struct rc_map_list rc5_dvbsky_map = {
 	.map = {
-		.scan    = rc5_dvbsky,
-		.size    = ARRAY_SIZE(rc5_dvbsky),
-		.rc_type = RC_TYPE_RC5,
-		.name    = RC_MAP_DVBSKY,
+		.scan     = rc5_dvbsky,
+		.size     = ARRAY_SIZE(rc5_dvbsky),
+		.rc_proto = RC_PROTO_RC5,
+		.name     = RC_MAP_DVBSKY,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-dvico-mce.c b/drivers/media/rc/keymaps/rc-dvico-mce.c
index d1e861f4d095..e4cee190b923 100644
--- a/drivers/media/rc/keymaps/rc-dvico-mce.c
+++ b/drivers/media/rc/keymaps/rc-dvico-mce.c
@@ -61,10 +61,10 @@ static struct rc_map_table rc_map_dvico_mce_table[] = {
 
 static struct rc_map_list dvico_mce_map = {
 	.map = {
-		.scan    = rc_map_dvico_mce_table,
-		.size    = ARRAY_SIZE(rc_map_dvico_mce_table),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_DVICO_MCE,
+		.scan     = rc_map_dvico_mce_table,
+		.size     = ARRAY_SIZE(rc_map_dvico_mce_table),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_DVICO_MCE,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-dvico-portable.c b/drivers/media/rc/keymaps/rc-dvico-portable.c
index ac4cb515cbf1..cdd21f54aa61 100644
--- a/drivers/media/rc/keymaps/rc-dvico-portable.c
+++ b/drivers/media/rc/keymaps/rc-dvico-portable.c
@@ -52,10 +52,10 @@ static struct rc_map_table rc_map_dvico_portable_table[] = {
 
 static struct rc_map_list dvico_portable_map = {
 	.map = {
-		.scan    = rc_map_dvico_portable_table,
-		.size    = ARRAY_SIZE(rc_map_dvico_portable_table),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_DVICO_PORTABLE,
+		.scan     = rc_map_dvico_portable_table,
+		.size     = ARRAY_SIZE(rc_map_dvico_portable_table),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_DVICO_PORTABLE,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-em-terratec.c b/drivers/media/rc/keymaps/rc-em-terratec.c
index 7f1e06be175b..18e1a2679c20 100644
--- a/drivers/media/rc/keymaps/rc-em-terratec.c
+++ b/drivers/media/rc/keymaps/rc-em-terratec.c
@@ -46,10 +46,10 @@ static struct rc_map_table em_terratec[] = {
 
 static struct rc_map_list em_terratec_map = {
 	.map = {
-		.scan    = em_terratec,
-		.size    = ARRAY_SIZE(em_terratec),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_EM_TERRATEC,
+		.scan     = em_terratec,
+		.size     = ARRAY_SIZE(em_terratec),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_EM_TERRATEC,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
index 4fc3904daf06..72ffd5cb0108 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
@@ -58,10 +58,10 @@ static struct rc_map_table encore_enltv_fm53[] = {
 
 static struct rc_map_list encore_enltv_fm53_map = {
 	.map = {
-		.scan    = encore_enltv_fm53,
-		.size    = ARRAY_SIZE(encore_enltv_fm53),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_ENCORE_ENLTV_FM53,
+		.scan     = encore_enltv_fm53,
+		.size     = ARRAY_SIZE(encore_enltv_fm53),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_ENCORE_ENLTV_FM53,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv.c b/drivers/media/rc/keymaps/rc-encore-enltv.c
index f1914e23d203..e0381e7aa964 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv.c
@@ -89,10 +89,10 @@ static struct rc_map_table encore_enltv[] = {
 
 static struct rc_map_list encore_enltv_map = {
 	.map = {
-		.scan    = encore_enltv,
-		.size    = ARRAY_SIZE(encore_enltv),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_ENCORE_ENLTV,
+		.scan     = encore_enltv,
+		.size     = ARRAY_SIZE(encore_enltv),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_ENCORE_ENLTV,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv2.c b/drivers/media/rc/keymaps/rc-encore-enltv2.c
index 9c6c55240d18..e9b0bfba319c 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv2.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv2.c
@@ -67,10 +67,10 @@ static struct rc_map_table encore_enltv2[] = {
 
 static struct rc_map_list encore_enltv2_map = {
 	.map = {
-		.scan    = encore_enltv2,
-		.size    = ARRAY_SIZE(encore_enltv2),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_ENCORE_ENLTV2,
+		.scan     = encore_enltv2,
+		.size     = ARRAY_SIZE(encore_enltv2),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_ENCORE_ENLTV2,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-evga-indtube.c b/drivers/media/rc/keymaps/rc-evga-indtube.c
index 2370d2a3deb6..b77c5e908668 100644
--- a/drivers/media/rc/keymaps/rc-evga-indtube.c
+++ b/drivers/media/rc/keymaps/rc-evga-indtube.c
@@ -38,10 +38,10 @@ static struct rc_map_table evga_indtube[] = {
 
 static struct rc_map_list evga_indtube_map = {
 	.map = {
-		.scan    = evga_indtube,
-		.size    = ARRAY_SIZE(evga_indtube),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_EVGA_INDTUBE,
+		.scan     = evga_indtube,
+		.size     = ARRAY_SIZE(evga_indtube),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_EVGA_INDTUBE,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-eztv.c b/drivers/media/rc/keymaps/rc-eztv.c
index b5c96ed84376..5013b3b2aa93 100644
--- a/drivers/media/rc/keymaps/rc-eztv.c
+++ b/drivers/media/rc/keymaps/rc-eztv.c
@@ -73,10 +73,10 @@ static struct rc_map_table eztv[] = {
 
 static struct rc_map_list eztv_map = {
 	.map = {
-		.scan    = eztv,
-		.size    = ARRAY_SIZE(eztv),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_EZTV,
+		.scan     = eztv,
+		.size     = ARRAY_SIZE(eztv),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_EZTV,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-flydvb.c b/drivers/media/rc/keymaps/rc-flydvb.c
index 25cb89fac03c..418b32521273 100644
--- a/drivers/media/rc/keymaps/rc-flydvb.c
+++ b/drivers/media/rc/keymaps/rc-flydvb.c
@@ -54,10 +54,10 @@ static struct rc_map_table flydvb[] = {
 
 static struct rc_map_list flydvb_map = {
 	.map = {
-		.scan    = flydvb,
-		.size    = ARRAY_SIZE(flydvb),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_FLYDVB,
+		.scan     = flydvb,
+		.size     = ARRAY_SIZE(flydvb),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_FLYDVB,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-flyvideo.c b/drivers/media/rc/keymaps/rc-flyvideo.c
index e71377dd0534..93fb87ecf061 100644
--- a/drivers/media/rc/keymaps/rc-flyvideo.c
+++ b/drivers/media/rc/keymaps/rc-flyvideo.c
@@ -47,10 +47,10 @@ static struct rc_map_table flyvideo[] = {
 
 static struct rc_map_list flyvideo_map = {
 	.map = {
-		.scan    = flyvideo,
-		.size    = ARRAY_SIZE(flyvideo),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_FLYVIDEO,
+		.scan     = flyvideo,
+		.size     = ARRAY_SIZE(flyvideo),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_FLYVIDEO,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
index cf0608dc83d5..9ed3f749262b 100644
--- a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
+++ b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
@@ -75,10 +75,10 @@ static struct rc_map_table fusionhdtv_mce[] = {
 
 static struct rc_map_list fusionhdtv_mce_map = {
 	.map = {
-		.scan    = fusionhdtv_mce,
-		.size    = ARRAY_SIZE(fusionhdtv_mce),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_FUSIONHDTV_MCE,
+		.scan     = fusionhdtv_mce,
+		.size     = ARRAY_SIZE(fusionhdtv_mce),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_FUSIONHDTV_MCE,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
index 03575bdb2eca..3443b721d092 100644
--- a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
+++ b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
@@ -58,10 +58,10 @@ static struct rc_map_table gadmei_rm008z[] = {
 
 static struct rc_map_list gadmei_rm008z_map = {
 	.map = {
-		.scan    = gadmei_rm008z,
-		.size    = ARRAY_SIZE(gadmei_rm008z),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_GADMEI_RM008Z,
+		.scan     = gadmei_rm008z,
+		.size     = ARRAY_SIZE(gadmei_rm008z),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_GADMEI_RM008Z,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-geekbox.c b/drivers/media/rc/keymaps/rc-geekbox.c
index affc4c481888..4aa1b54bb52e 100644
--- a/drivers/media/rc/keymaps/rc-geekbox.c
+++ b/drivers/media/rc/keymaps/rc-geekbox.c
@@ -31,10 +31,10 @@ static struct rc_map_table geekbox[] = {
 
 static struct rc_map_list geekbox_map = {
 	.map = {
-		.scan    = geekbox,
-		.size    = ARRAY_SIZE(geekbox),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_GEEKBOX,
+		.scan     = geekbox,
+		.size     = ARRAY_SIZE(geekbox),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_GEEKBOX,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
index b2ab13b0dcb1..d140e8d45bcc 100644
--- a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
+++ b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
@@ -61,10 +61,10 @@ static struct rc_map_table genius_tvgo_a11mce[] = {
 
 static struct rc_map_list genius_tvgo_a11mce_map = {
 	.map = {
-		.scan    = genius_tvgo_a11mce,
-		.size    = ARRAY_SIZE(genius_tvgo_a11mce),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_GENIUS_TVGO_A11MCE,
+		.scan     = genius_tvgo_a11mce,
+		.size     = ARRAY_SIZE(genius_tvgo_a11mce),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_GENIUS_TVGO_A11MCE,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-gotview7135.c b/drivers/media/rc/keymaps/rc-gotview7135.c
index 229a36ac7f0a..51230fbb52ba 100644
--- a/drivers/media/rc/keymaps/rc-gotview7135.c
+++ b/drivers/media/rc/keymaps/rc-gotview7135.c
@@ -56,10 +56,10 @@ static struct rc_map_table gotview7135[] = {
 
 static struct rc_map_list gotview7135_map = {
 	.map = {
-		.scan    = gotview7135,
-		.size    = ARRAY_SIZE(gotview7135),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_GOTVIEW7135,
+		.scan     = gotview7135,
+		.size     = ARRAY_SIZE(gotview7135),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_GOTVIEW7135,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-hauppauge.c b/drivers/media/rc/keymaps/rc-hauppauge.c
index 36d57f7c532b..890164b68d64 100644
--- a/drivers/media/rc/keymaps/rc-hauppauge.c
+++ b/drivers/media/rc/keymaps/rc-hauppauge.c
@@ -269,10 +269,10 @@ static struct rc_map_table rc5_hauppauge_new[] = {
 
 static struct rc_map_list rc5_hauppauge_new_map = {
 	.map = {
-		.scan    = rc5_hauppauge_new,
-		.size    = ARRAY_SIZE(rc5_hauppauge_new),
-		.rc_type = RC_TYPE_RC5,
-		.name    = RC_MAP_HAUPPAUGE,
+		.scan     = rc5_hauppauge_new,
+		.size     = ARRAY_SIZE(rc5_hauppauge_new),
+		.rc_proto = RC_PROTO_RC5,
+		.name     = RC_MAP_HAUPPAUGE,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-imon-mce.c b/drivers/media/rc/keymaps/rc-imon-mce.c
index f0da960560b0..6a69ce1451f1 100644
--- a/drivers/media/rc/keymaps/rc-imon-mce.c
+++ b/drivers/media/rc/keymaps/rc-imon-mce.c
@@ -118,11 +118,11 @@ static struct rc_map_table imon_mce[] = {
 
 static struct rc_map_list imon_mce_map = {
 	.map = {
-		.scan    = imon_mce,
-		.size    = ARRAY_SIZE(imon_mce),
+		.scan     = imon_mce,
+		.size     = ARRAY_SIZE(imon_mce),
 		/* its RC6, but w/a hardware decoder */
-		.rc_type = RC_TYPE_RC6_MCE,
-		.name    = RC_MAP_IMON_MCE,
+		.rc_proto = RC_PROTO_RC6_MCE,
+		.name     = RC_MAP_IMON_MCE,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-imon-pad.c b/drivers/media/rc/keymaps/rc-imon-pad.c
index 999c6295c70e..a7296ffbf218 100644
--- a/drivers/media/rc/keymaps/rc-imon-pad.c
+++ b/drivers/media/rc/keymaps/rc-imon-pad.c
@@ -132,11 +132,11 @@ static struct rc_map_table imon_pad[] = {
 
 static struct rc_map_list imon_pad_map = {
 	.map = {
-		.scan    = imon_pad,
-		.size    = ARRAY_SIZE(imon_pad),
+		.scan     = imon_pad,
+		.size     = ARRAY_SIZE(imon_pad),
 		/* actual protocol details unknown, hardware decoder */
-		.rc_type = RC_TYPE_OTHER,
-		.name    = RC_MAP_IMON_PAD,
+		.rc_proto = RC_PROTO_OTHER,
+		.name     = RC_MAP_IMON_PAD,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
index 9ee154cb0c6b..8cf87a15c4f2 100644
--- a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
+++ b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
@@ -65,10 +65,10 @@ static struct rc_map_table iodata_bctv7e[] = {
 
 static struct rc_map_list iodata_bctv7e_map = {
 	.map = {
-		.scan    = iodata_bctv7e,
-		.size    = ARRAY_SIZE(iodata_bctv7e),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_IODATA_BCTV7E,
+		.scan     = iodata_bctv7e,
+		.size     = ARRAY_SIZE(iodata_bctv7e),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_IODATA_BCTV7E,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-it913x-v1.c b/drivers/media/rc/keymaps/rc-it913x-v1.c
index 0ac775fd109d..908d14848ae8 100644
--- a/drivers/media/rc/keymaps/rc-it913x-v1.c
+++ b/drivers/media/rc/keymaps/rc-it913x-v1.c
@@ -71,10 +71,10 @@ static struct rc_map_table it913x_v1_rc[] = {
 
 static struct rc_map_list it913x_v1_map = {
 	.map = {
-		.scan    = it913x_v1_rc,
-		.size    = ARRAY_SIZE(it913x_v1_rc),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_IT913X_V1,
+		.scan     = it913x_v1_rc,
+		.size     = ARRAY_SIZE(it913x_v1_rc),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_IT913X_V1,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-it913x-v2.c b/drivers/media/rc/keymaps/rc-it913x-v2.c
index bd42a30ec06f..05ab7fa4f90b 100644
--- a/drivers/media/rc/keymaps/rc-it913x-v2.c
+++ b/drivers/media/rc/keymaps/rc-it913x-v2.c
@@ -70,10 +70,10 @@ static struct rc_map_table it913x_v2_rc[] = {
 
 static struct rc_map_list it913x_v2_map = {
 	.map = {
-		.scan    = it913x_v2_rc,
-		.size    = ARRAY_SIZE(it913x_v2_rc),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_IT913X_V2,
+		.scan     = it913x_v2_rc,
+		.size     = ARRAY_SIZE(it913x_v2_rc),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_IT913X_V2,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-kaiomy.c b/drivers/media/rc/keymaps/rc-kaiomy.c
index 60803a732c08..e791f1e1b43b 100644
--- a/drivers/media/rc/keymaps/rc-kaiomy.c
+++ b/drivers/media/rc/keymaps/rc-kaiomy.c
@@ -64,10 +64,10 @@ static struct rc_map_table kaiomy[] = {
 
 static struct rc_map_list kaiomy_map = {
 	.map = {
-		.scan    = kaiomy,
-		.size    = ARRAY_SIZE(kaiomy),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_KAIOMY,
+		.scan     = kaiomy,
+		.size     = ARRAY_SIZE(kaiomy),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_KAIOMY,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-kworld-315u.c b/drivers/media/rc/keymaps/rc-kworld-315u.c
index ba087eed1ed9..71dce0138f0e 100644
--- a/drivers/media/rc/keymaps/rc-kworld-315u.c
+++ b/drivers/media/rc/keymaps/rc-kworld-315u.c
@@ -60,10 +60,10 @@ static struct rc_map_table kworld_315u[] = {
 
 static struct rc_map_list kworld_315u_map = {
 	.map = {
-		.scan    = kworld_315u,
-		.size    = ARRAY_SIZE(kworld_315u),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_KWORLD_315U,
+		.scan     = kworld_315u,
+		.size     = ARRAY_SIZE(kworld_315u),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_KWORLD_315U,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-kworld-pc150u.c b/drivers/media/rc/keymaps/rc-kworld-pc150u.c
index b92e571f4def..3846059060aa 100644
--- a/drivers/media/rc/keymaps/rc-kworld-pc150u.c
+++ b/drivers/media/rc/keymaps/rc-kworld-pc150u.c
@@ -78,10 +78,10 @@ static struct rc_map_table kworld_pc150u[] = {
 
 static struct rc_map_list kworld_pc150u_map = {
 	.map = {
-		.scan    = kworld_pc150u,
-		.size    = ARRAY_SIZE(kworld_pc150u),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_KWORLD_PC150U,
+		.scan     = kworld_pc150u,
+		.size     = ARRAY_SIZE(kworld_pc150u),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_KWORLD_PC150U,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
index edc868564f99..e0322ed16c94 100644
--- a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
+++ b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
@@ -76,10 +76,10 @@ static struct rc_map_table kworld_plus_tv_analog[] = {
 
 static struct rc_map_list kworld_plus_tv_analog_map = {
 	.map = {
-		.scan    = kworld_plus_tv_analog,
-		.size    = ARRAY_SIZE(kworld_plus_tv_analog),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_KWORLD_PLUS_TV_ANALOG,
+		.scan     = kworld_plus_tv_analog,
+		.size     = ARRAY_SIZE(kworld_plus_tv_analog),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_KWORLD_PLUS_TV_ANALOG,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c b/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
index 03d762d986ee..e534a5601b6d 100644
--- a/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
+++ b/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
@@ -76,10 +76,10 @@ static struct rc_map_table leadtek_y04g0051[] = {
 
 static struct rc_map_list leadtek_y04g0051_map = {
 	.map = {
-		.scan    = leadtek_y04g0051,
-		.size    = ARRAY_SIZE(leadtek_y04g0051),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_LEADTEK_Y04G0051,
+		.scan     = leadtek_y04g0051,
+		.size     = ARRAY_SIZE(leadtek_y04g0051),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_LEADTEK_Y04G0051,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-lme2510.c b/drivers/media/rc/keymaps/rc-lme2510.c
index 2b0027c41332..9c93f90f5c2b 100644
--- a/drivers/media/rc/keymaps/rc-lme2510.c
+++ b/drivers/media/rc/keymaps/rc-lme2510.c
@@ -87,10 +87,10 @@ static struct rc_map_table lme2510_rc[] = {
 
 static struct rc_map_list lme2510_map = {
 	.map = {
-		.scan    = lme2510_rc,
-		.size    = ARRAY_SIZE(lme2510_rc),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_LME2510,
+		.scan     = lme2510_rc,
+		.size     = ARRAY_SIZE(lme2510_rc),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_LME2510,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-manli.c b/drivers/media/rc/keymaps/rc-manli.c
index 92424ef2aaa6..da566902a4dd 100644
--- a/drivers/media/rc/keymaps/rc-manli.c
+++ b/drivers/media/rc/keymaps/rc-manli.c
@@ -111,10 +111,10 @@ static struct rc_map_table manli[] = {
 
 static struct rc_map_list manli_map = {
 	.map = {
-		.scan    = manli,
-		.size    = ARRAY_SIZE(manli),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_MANLI,
+		.scan     = manli,
+		.size     = ARRAY_SIZE(manli),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_MANLI,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-medion-x10-digitainer.c b/drivers/media/rc/keymaps/rc-medion-x10-digitainer.c
index 966f9b3c71da..c9973340e546 100644
--- a/drivers/media/rc/keymaps/rc-medion-x10-digitainer.c
+++ b/drivers/media/rc/keymaps/rc-medion-x10-digitainer.c
@@ -98,10 +98,10 @@ static struct rc_map_table medion_x10_digitainer[] = {
 
 static struct rc_map_list medion_x10_digitainer_map = {
 	.map = {
-		.scan    = medion_x10_digitainer,
-		.size    = ARRAY_SIZE(medion_x10_digitainer),
-		.rc_type = RC_TYPE_OTHER,
-		.name    = RC_MAP_MEDION_X10_DIGITAINER,
+		.scan     = medion_x10_digitainer,
+		.size     = ARRAY_SIZE(medion_x10_digitainer),
+		.rc_proto = RC_PROTO_OTHER,
+		.name     = RC_MAP_MEDION_X10_DIGITAINER,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-medion-x10-or2x.c b/drivers/media/rc/keymaps/rc-medion-x10-or2x.c
index b077300ecb5c..103ad88d242c 100644
--- a/drivers/media/rc/keymaps/rc-medion-x10-or2x.c
+++ b/drivers/media/rc/keymaps/rc-medion-x10-or2x.c
@@ -83,10 +83,10 @@ static struct rc_map_table medion_x10_or2x[] = {
 
 static struct rc_map_list medion_x10_or2x_map = {
 	.map = {
-		.scan    = medion_x10_or2x,
-		.size    = ARRAY_SIZE(medion_x10_or2x),
-		.rc_type = RC_TYPE_OTHER,
-		.name    = RC_MAP_MEDION_X10_OR2X,
+		.scan     = medion_x10_or2x,
+		.size     = ARRAY_SIZE(medion_x10_or2x),
+		.rc_proto = RC_PROTO_OTHER,
+		.name     = RC_MAP_MEDION_X10_OR2X,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-medion-x10.c b/drivers/media/rc/keymaps/rc-medion-x10.c
index 479cdb897810..bbffa5dfe420 100644
--- a/drivers/media/rc/keymaps/rc-medion-x10.c
+++ b/drivers/media/rc/keymaps/rc-medion-x10.c
@@ -93,10 +93,10 @@ static struct rc_map_table medion_x10[] = {
 
 static struct rc_map_list medion_x10_map = {
 	.map = {
-		.scan    = medion_x10,
-		.size    = ARRAY_SIZE(medion_x10),
-		.rc_type = RC_TYPE_OTHER,
-		.name    = RC_MAP_MEDION_X10,
+		.scan     = medion_x10,
+		.size     = ARRAY_SIZE(medion_x10),
+		.rc_proto = RC_PROTO_OTHER,
+		.name     = RC_MAP_MEDION_X10,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-msi-digivox-ii.c b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
index 2fa71d0d72d7..94aa12d4b73c 100644
--- a/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
+++ b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
@@ -44,10 +44,10 @@ static struct rc_map_table msi_digivox_ii[] = {
 
 static struct rc_map_list msi_digivox_ii_map = {
 	.map = {
-		.scan    = msi_digivox_ii,
-		.size    = ARRAY_SIZE(msi_digivox_ii),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_MSI_DIGIVOX_II,
+		.scan     = msi_digivox_ii,
+		.size     = ARRAY_SIZE(msi_digivox_ii),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_MSI_DIGIVOX_II,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-msi-digivox-iii.c b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
index 303a0b73175b..8fec0c1dcb12 100644
--- a/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
+++ b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
@@ -62,10 +62,10 @@ static struct rc_map_table msi_digivox_iii[] = {
 
 static struct rc_map_list msi_digivox_iii_map = {
 	.map = {
-		.scan    = msi_digivox_iii,
-		.size    = ARRAY_SIZE(msi_digivox_iii),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_MSI_DIGIVOX_III,
+		.scan     = msi_digivox_iii,
+		.size     = ARRAY_SIZE(msi_digivox_iii),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_MSI_DIGIVOX_III,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
index fd7a55c56167..dfa0ed1d7667 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
@@ -100,10 +100,10 @@ static struct rc_map_table msi_tvanywhere_plus[] = {
 
 static struct rc_map_list msi_tvanywhere_plus_map = {
 	.map = {
-		.scan    = msi_tvanywhere_plus,
-		.size    = ARRAY_SIZE(msi_tvanywhere_plus),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_MSI_TVANYWHERE_PLUS,
+		.scan     = msi_tvanywhere_plus,
+		.size     = ARRAY_SIZE(msi_tvanywhere_plus),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_MSI_TVANYWHERE_PLUS,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
index 4233a8d4d63e..2111816a3f59 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
@@ -46,10 +46,10 @@ static struct rc_map_table msi_tvanywhere[] = {
 
 static struct rc_map_list msi_tvanywhere_map = {
 	.map = {
-		.scan    = msi_tvanywhere,
-		.size    = ARRAY_SIZE(msi_tvanywhere),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_MSI_TVANYWHERE,
+		.scan     = msi_tvanywhere,
+		.size     = ARRAY_SIZE(msi_tvanywhere),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_MSI_TVANYWHERE,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-nebula.c b/drivers/media/rc/keymaps/rc-nebula.c
index 4c50f33c7c41..109b6e1a8b1a 100644
--- a/drivers/media/rc/keymaps/rc-nebula.c
+++ b/drivers/media/rc/keymaps/rc-nebula.c
@@ -73,10 +73,10 @@ static struct rc_map_table nebula[] = {
 
 static struct rc_map_list nebula_map = {
 	.map = {
-		.scan    = nebula,
-		.size    = ARRAY_SIZE(nebula),
-		.rc_type = RC_TYPE_RC5,
-		.name    = RC_MAP_NEBULA,
+		.scan     = nebula,
+		.size     = ARRAY_SIZE(nebula),
+		.rc_proto = RC_PROTO_RC5,
+		.name     = RC_MAP_NEBULA,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
index 292bbad35d21..bb2d3a2962c0 100644
--- a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
@@ -134,10 +134,10 @@ static struct rc_map_table nec_terratec_cinergy_xs[] = {
 
 static struct rc_map_list nec_terratec_cinergy_xs_map = {
 	.map = {
-		.scan    = nec_terratec_cinergy_xs,
-		.size    = ARRAY_SIZE(nec_terratec_cinergy_xs),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_NEC_TERRATEC_CINERGY_XS,
+		.scan     = nec_terratec_cinergy_xs,
+		.size     = ARRAY_SIZE(nec_terratec_cinergy_xs),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_NEC_TERRATEC_CINERGY_XS,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-norwood.c b/drivers/media/rc/keymaps/rc-norwood.c
index ca1b82a2c54f..cd25df336749 100644
--- a/drivers/media/rc/keymaps/rc-norwood.c
+++ b/drivers/media/rc/keymaps/rc-norwood.c
@@ -62,10 +62,10 @@ static struct rc_map_table norwood[] = {
 
 static struct rc_map_list norwood_map = {
 	.map = {
-		.scan    = norwood,
-		.size    = ARRAY_SIZE(norwood),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_NORWOOD,
+		.scan     = norwood,
+		.size     = ARRAY_SIZE(norwood),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_NORWOOD,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-npgtech.c b/drivers/media/rc/keymaps/rc-npgtech.c
index 1fb946024512..140bbc20a764 100644
--- a/drivers/media/rc/keymaps/rc-npgtech.c
+++ b/drivers/media/rc/keymaps/rc-npgtech.c
@@ -57,10 +57,10 @@ static struct rc_map_table npgtech[] = {
 
 static struct rc_map_list npgtech_map = {
 	.map = {
-		.scan    = npgtech,
-		.size    = ARRAY_SIZE(npgtech),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_NPGTECH,
+		.scan     = npgtech,
+		.size     = ARRAY_SIZE(npgtech),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_NPGTECH,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-pctv-sedna.c b/drivers/media/rc/keymaps/rc-pctv-sedna.c
index 5ef01ab3fd50..52b4558b7bd0 100644
--- a/drivers/media/rc/keymaps/rc-pctv-sedna.c
+++ b/drivers/media/rc/keymaps/rc-pctv-sedna.c
@@ -57,10 +57,10 @@ static struct rc_map_table pctv_sedna[] = {
 
 static struct rc_map_list pctv_sedna_map = {
 	.map = {
-		.scan    = pctv_sedna,
-		.size    = ARRAY_SIZE(pctv_sedna),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_PCTV_SEDNA,
+		.scan     = pctv_sedna,
+		.size     = ARRAY_SIZE(pctv_sedna),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_PCTV_SEDNA,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-color.c b/drivers/media/rc/keymaps/rc-pinnacle-color.c
index a218b471a4ca..973c9c34e304 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-color.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-color.c
@@ -71,10 +71,10 @@ static struct rc_map_table pinnacle_color[] = {
 
 static struct rc_map_list pinnacle_color_map = {
 	.map = {
-		.scan    = pinnacle_color,
-		.size    = ARRAY_SIZE(pinnacle_color),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_PINNACLE_COLOR,
+		.scan     = pinnacle_color,
+		.size     = ARRAY_SIZE(pinnacle_color),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_PINNACLE_COLOR,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-grey.c b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
index 4a3f467a47a2..22e44b0d2a93 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-grey.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
@@ -66,10 +66,10 @@ static struct rc_map_table pinnacle_grey[] = {
 
 static struct rc_map_list pinnacle_grey_map = {
 	.map = {
-		.scan    = pinnacle_grey,
-		.size    = ARRAY_SIZE(pinnacle_grey),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_PINNACLE_GREY,
+		.scan     = pinnacle_grey,
+		.size     = ARRAY_SIZE(pinnacle_grey),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_PINNACLE_GREY,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
index e89cc10b68bf..186dcf8e0491 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
@@ -47,10 +47,10 @@ static struct rc_map_table pinnacle_pctv_hd[] = {
 
 static struct rc_map_list pinnacle_pctv_hd_map = {
 	.map = {
-		.scan    = pinnacle_pctv_hd,
-		.size    = ARRAY_SIZE(pinnacle_pctv_hd),
-		.rc_type = RC_TYPE_RC5,
-		.name    = RC_MAP_PINNACLE_PCTV_HD,
+		.scan     = pinnacle_pctv_hd,
+		.size     = ARRAY_SIZE(pinnacle_pctv_hd),
+		.rc_proto = RC_PROTO_RC5,
+		.name     = RC_MAP_PINNACLE_PCTV_HD,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-pixelview-002t.c b/drivers/media/rc/keymaps/rc-pixelview-002t.c
index d967c3816fdc..b235ada2e28f 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-002t.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-002t.c
@@ -54,10 +54,10 @@ static struct rc_map_table pixelview_002t[] = {
 
 static struct rc_map_list pixelview_map = {
 	.map = {
-		.scan    = pixelview_002t,
-		.size    = ARRAY_SIZE(pixelview_002t),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_PIXELVIEW_002T,
+		.scan     = pixelview_002t,
+		.size     = ARRAY_SIZE(pixelview_002t),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_PIXELVIEW_002T,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-pixelview-mk12.c b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
index 224d0efaa6e5..453d52d663fe 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-mk12.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
@@ -60,10 +60,10 @@ static struct rc_map_table pixelview_mk12[] = {
 
 static struct rc_map_list pixelview_map = {
 	.map = {
-		.scan    = pixelview_mk12,
-		.size    = ARRAY_SIZE(pixelview_mk12),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_PIXELVIEW_MK12,
+		.scan     = pixelview_mk12,
+		.size     = ARRAY_SIZE(pixelview_mk12),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_PIXELVIEW_MK12,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-pixelview-new.c b/drivers/media/rc/keymaps/rc-pixelview-new.c
index 781d788d6b6d..ef97095ec8f1 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-new.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-new.c
@@ -60,10 +60,10 @@ static struct rc_map_table pixelview_new[] = {
 
 static struct rc_map_list pixelview_new_map = {
 	.map = {
-		.scan    = pixelview_new,
-		.size    = ARRAY_SIZE(pixelview_new),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_PIXELVIEW_NEW,
+		.scan     = pixelview_new,
+		.size     = ARRAY_SIZE(pixelview_new),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_PIXELVIEW_NEW,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-pixelview.c b/drivers/media/rc/keymaps/rc-pixelview.c
index 39e6feaa35a3..cfd8f80d3617 100644
--- a/drivers/media/rc/keymaps/rc-pixelview.c
+++ b/drivers/media/rc/keymaps/rc-pixelview.c
@@ -59,10 +59,10 @@ static struct rc_map_table pixelview[] = {
 
 static struct rc_map_list pixelview_map = {
 	.map = {
-		.scan    = pixelview,
-		.size    = ARRAY_SIZE(pixelview),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_PIXELVIEW,
+		.scan     = pixelview,
+		.size     = ARRAY_SIZE(pixelview),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_PIXELVIEW,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
index e96fa3ab9f4b..b63f82bcf29a 100644
--- a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
+++ b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
@@ -58,10 +58,10 @@ static struct rc_map_table powercolor_real_angel[] = {
 
 static struct rc_map_list powercolor_real_angel_map = {
 	.map = {
-		.scan    = powercolor_real_angel,
-		.size    = ARRAY_SIZE(powercolor_real_angel),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_POWERCOLOR_REAL_ANGEL,
+		.scan     = powercolor_real_angel,
+		.size     = ARRAY_SIZE(powercolor_real_angel),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_POWERCOLOR_REAL_ANGEL,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-proteus-2309.c b/drivers/media/rc/keymaps/rc-proteus-2309.c
index eef626ee02df..be34c517e4e1 100644
--- a/drivers/media/rc/keymaps/rc-proteus-2309.c
+++ b/drivers/media/rc/keymaps/rc-proteus-2309.c
@@ -46,10 +46,10 @@ static struct rc_map_table proteus_2309[] = {
 
 static struct rc_map_list proteus_2309_map = {
 	.map = {
-		.scan    = proteus_2309,
-		.size    = ARRAY_SIZE(proteus_2309),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_PROTEUS_2309,
+		.scan     = proteus_2309,
+		.size     = ARRAY_SIZE(proteus_2309),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_PROTEUS_2309,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-purpletv.c b/drivers/media/rc/keymaps/rc-purpletv.c
index cec6fe466829..84c40b97ee00 100644
--- a/drivers/media/rc/keymaps/rc-purpletv.c
+++ b/drivers/media/rc/keymaps/rc-purpletv.c
@@ -58,10 +58,10 @@ static struct rc_map_table purpletv[] = {
 
 static struct rc_map_list purpletv_map = {
 	.map = {
-		.scan    = purpletv,
-		.size    = ARRAY_SIZE(purpletv),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_PURPLETV,
+		.scan     = purpletv,
+		.size     = ARRAY_SIZE(purpletv),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_PURPLETV,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-pv951.c b/drivers/media/rc/keymaps/rc-pv951.c
index 5ac89ce8c053..be190ddebfc4 100644
--- a/drivers/media/rc/keymaps/rc-pv951.c
+++ b/drivers/media/rc/keymaps/rc-pv951.c
@@ -55,10 +55,10 @@ static struct rc_map_table pv951[] = {
 
 static struct rc_map_list pv951_map = {
 	.map = {
-		.scan    = pv951,
-		.size    = ARRAY_SIZE(pv951),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_PV951,
+		.scan     = pv951,
+		.size     = ARRAY_SIZE(pv951),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_PV951,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-rc6-mce.c b/drivers/media/rc/keymaps/rc-rc6-mce.c
index 5be567506bcd..0d87b20a0c43 100644
--- a/drivers/media/rc/keymaps/rc-rc6-mce.c
+++ b/drivers/media/rc/keymaps/rc-rc6-mce.c
@@ -96,10 +96,10 @@ static struct rc_map_table rc6_mce[] = {
 
 static struct rc_map_list rc6_mce_map = {
 	.map = {
-		.scan    = rc6_mce,
-		.size    = ARRAY_SIZE(rc6_mce),
-		.rc_type = RC_TYPE_RC6_MCE,
-		.name    = RC_MAP_RC6_MCE,
+		.scan     = rc6_mce,
+		.size     = ARRAY_SIZE(rc6_mce),
+		.rc_proto = RC_PROTO_RC6_MCE,
+		.name     = RC_MAP_RC6_MCE,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
index 9f778bd091db..957fa21747ea 100644
--- a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
+++ b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
@@ -55,10 +55,10 @@ static struct rc_map_table real_audio_220_32_keys[] = {
 
 static struct rc_map_list real_audio_220_32_keys_map = {
 	.map = {
-		.scan    = real_audio_220_32_keys,
-		.size    = ARRAY_SIZE(real_audio_220_32_keys),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_REAL_AUDIO_220_32_KEYS,
+		.scan     = real_audio_220_32_keys,
+		.size     = ARRAY_SIZE(real_audio_220_32_keys),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_REAL_AUDIO_220_32_KEYS,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-reddo.c b/drivers/media/rc/keymaps/rc-reddo.c
index b80b336e9284..3b37acc7b144 100644
--- a/drivers/media/rc/keymaps/rc-reddo.c
+++ b/drivers/media/rc/keymaps/rc-reddo.c
@@ -62,10 +62,10 @@ static struct rc_map_table reddo[] = {
 
 static struct rc_map_list reddo_map = {
 	.map = {
-		.scan    = reddo,
-		.size    = ARRAY_SIZE(reddo),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_REDDO,
+		.scan     = reddo,
+		.size     = ARRAY_SIZE(reddo),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_REDDO,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-snapstream-firefly.c b/drivers/media/rc/keymaps/rc-snapstream-firefly.c
index c7f33ec719b4..30630a6f76ac 100644
--- a/drivers/media/rc/keymaps/rc-snapstream-firefly.c
+++ b/drivers/media/rc/keymaps/rc-snapstream-firefly.c
@@ -83,10 +83,10 @@ static struct rc_map_table snapstream_firefly[] = {
 
 static struct rc_map_list snapstream_firefly_map = {
 	.map = {
-		.scan    = snapstream_firefly,
-		.size    = ARRAY_SIZE(snapstream_firefly),
-		.rc_type = RC_TYPE_OTHER,
-		.name    = RC_MAP_SNAPSTREAM_FIREFLY,
+		.scan     = snapstream_firefly,
+		.size     = ARRAY_SIZE(snapstream_firefly),
+		.rc_proto = RC_PROTO_OTHER,
+		.name     = RC_MAP_SNAPSTREAM_FIREFLY,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-streamzap.c b/drivers/media/rc/keymaps/rc-streamzap.c
index 23c061174ed7..b53bca9e4576 100644
--- a/drivers/media/rc/keymaps/rc-streamzap.c
+++ b/drivers/media/rc/keymaps/rc-streamzap.c
@@ -57,10 +57,10 @@ static struct rc_map_table streamzap[] = {
 
 static struct rc_map_list streamzap_map = {
 	.map = {
-		.scan    = streamzap,
-		.size    = ARRAY_SIZE(streamzap),
-		.rc_type = RC_TYPE_RC5_SZ,
-		.name    = RC_MAP_STREAMZAP,
+		.scan     = streamzap,
+		.size     = ARRAY_SIZE(streamzap),
+		.rc_proto = RC_PROTO_RC5_SZ,
+		.name     = RC_MAP_STREAMZAP,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-su3000.c b/drivers/media/rc/keymaps/rc-su3000.c
index 8dbd3e9bc951..d9af7e3c55d9 100644
--- a/drivers/media/rc/keymaps/rc-su3000.c
+++ b/drivers/media/rc/keymaps/rc-su3000.c
@@ -51,10 +51,10 @@ static struct rc_map_table su3000[] = {
 
 static struct rc_map_list su3000_map = {
 	.map = {
-		.scan    = su3000,
-		.size    = ARRAY_SIZE(su3000),
-		.rc_type = RC_TYPE_RC5,
-		.name    = RC_MAP_SU3000,
+		.scan     = su3000,
+		.size     = ARRAY_SIZE(su3000),
+		.rc_proto = RC_PROTO_RC5,
+		.name     = RC_MAP_SU3000,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-tbs-nec.c b/drivers/media/rc/keymaps/rc-tbs-nec.c
index 24ce2a252502..05facc043272 100644
--- a/drivers/media/rc/keymaps/rc-tbs-nec.c
+++ b/drivers/media/rc/keymaps/rc-tbs-nec.c
@@ -52,10 +52,10 @@ static struct rc_map_table tbs_nec[] = {
 
 static struct rc_map_list tbs_nec_map = {
 	.map = {
-		.scan    = tbs_nec,
-		.size    = ARRAY_SIZE(tbs_nec),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_TBS_NEC,
+		.scan     = tbs_nec,
+		.size     = ARRAY_SIZE(tbs_nec),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_TBS_NEC,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-technisat-ts35.c b/drivers/media/rc/keymaps/rc-technisat-ts35.c
index 3328cbefabad..dff7021734ba 100644
--- a/drivers/media/rc/keymaps/rc-technisat-ts35.c
+++ b/drivers/media/rc/keymaps/rc-technisat-ts35.c
@@ -53,10 +53,10 @@ static struct rc_map_table technisat_ts35[] = {
 
 static struct rc_map_list technisat_ts35_map = {
 	.map = {
-		.scan    = technisat_ts35,
-		.size    = ARRAY_SIZE(technisat_ts35),
-		.rc_type = RC_TYPE_UNKNOWN,
-		.name    = RC_MAP_TECHNISAT_TS35,
+		.scan     = technisat_ts35,
+		.size     = ARRAY_SIZE(technisat_ts35),
+		.rc_proto = RC_PROTO_UNKNOWN,
+		.name     = RC_MAP_TECHNISAT_TS35,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-technisat-usb2.c b/drivers/media/rc/keymaps/rc-technisat-usb2.c
index 02c9c243c060..58b3baf5ee96 100644
--- a/drivers/media/rc/keymaps/rc-technisat-usb2.c
+++ b/drivers/media/rc/keymaps/rc-technisat-usb2.c
@@ -66,10 +66,10 @@ static struct rc_map_table technisat_usb2[] = {
 
 static struct rc_map_list technisat_usb2_map = {
 	.map = {
-		.scan    = technisat_usb2,
-		.size    = ARRAY_SIZE(technisat_usb2),
-		.rc_type = RC_TYPE_RC5,
-		.name    = RC_MAP_TECHNISAT_USB2,
+		.scan     = technisat_usb2,
+		.size     = ARRAY_SIZE(technisat_usb2),
+		.rc_proto = RC_PROTO_RC5,
+		.name     = RC_MAP_TECHNISAT_USB2,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-c-pci.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-c-pci.c
index 7958f458527a..7ae88ccf1def 100644
--- a/drivers/media/rc/keymaps/rc-terratec-cinergy-c-pci.c
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-c-pci.c
@@ -65,10 +65,10 @@ static struct rc_map_table terratec_cinergy_c_pci[] = {
 
 static struct rc_map_list terratec_cinergy_c_pci_map = {
 	.map = {
-		.scan    = terratec_cinergy_c_pci,
-		.size    = ARRAY_SIZE(terratec_cinergy_c_pci),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_TERRATEC_CINERGY_C_PCI,
+		.scan     = terratec_cinergy_c_pci,
+		.size     = ARRAY_SIZE(terratec_cinergy_c_pci),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_TERRATEC_CINERGY_C_PCI,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-s2-hd.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-s2-hd.c
index 1e096bbda4a0..bf0171b05ac2 100644
--- a/drivers/media/rc/keymaps/rc-terratec-cinergy-s2-hd.c
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-s2-hd.c
@@ -63,10 +63,10 @@ static struct rc_map_table terratec_cinergy_s2_hd[] = {
 
 static struct rc_map_list terratec_cinergy_s2_hd_map = {
 	.map = {
-		.scan    = terratec_cinergy_s2_hd,
-		.size    = ARRAY_SIZE(terratec_cinergy_s2_hd),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_TERRATEC_CINERGY_S2_HD,
+		.scan     = terratec_cinergy_s2_hd,
+		.size     = ARRAY_SIZE(terratec_cinergy_s2_hd),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_TERRATEC_CINERGY_S2_HD,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
index 97eb83ab5a35..3d0f6f7e5bea 100644
--- a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
@@ -69,10 +69,10 @@ static struct rc_map_table terratec_cinergy_xs[] = {
 
 static struct rc_map_list terratec_cinergy_xs_map = {
 	.map = {
-		.scan    = terratec_cinergy_xs,
-		.size    = ARRAY_SIZE(terratec_cinergy_xs),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_TERRATEC_CINERGY_XS,
+		.scan     = terratec_cinergy_xs,
+		.size     = ARRAY_SIZE(terratec_cinergy_xs),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_TERRATEC_CINERGY_XS,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-terratec-slim-2.c b/drivers/media/rc/keymaps/rc-terratec-slim-2.c
index 4c149ef712dc..df57e0a45820 100644
--- a/drivers/media/rc/keymaps/rc-terratec-slim-2.c
+++ b/drivers/media/rc/keymaps/rc-terratec-slim-2.c
@@ -49,10 +49,10 @@ static struct rc_map_table terratec_slim_2[] = {
 
 static struct rc_map_list terratec_slim_2_map = {
 	.map = {
-		.scan    = terratec_slim_2,
-		.size    = ARRAY_SIZE(terratec_slim_2),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_TERRATEC_SLIM_2,
+		.scan     = terratec_slim_2,
+		.size     = ARRAY_SIZE(terratec_slim_2),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_TERRATEC_SLIM_2,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-terratec-slim.c b/drivers/media/rc/keymaps/rc-terratec-slim.c
index 3d8a19cdb5a2..628272c58d65 100644
--- a/drivers/media/rc/keymaps/rc-terratec-slim.c
+++ b/drivers/media/rc/keymaps/rc-terratec-slim.c
@@ -56,10 +56,10 @@ static struct rc_map_table terratec_slim[] = {
 
 static struct rc_map_list terratec_slim_map = {
 	.map = {
-		.scan    = terratec_slim,
-		.size    = ARRAY_SIZE(terratec_slim),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_TERRATEC_SLIM,
+		.scan     = terratec_slim,
+		.size     = ARRAY_SIZE(terratec_slim),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_TERRATEC_SLIM,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-tevii-nec.c b/drivers/media/rc/keymaps/rc-tevii-nec.c
index 38e0c0875596..31f8a0fd1f2c 100644
--- a/drivers/media/rc/keymaps/rc-tevii-nec.c
+++ b/drivers/media/rc/keymaps/rc-tevii-nec.c
@@ -65,10 +65,10 @@ static struct rc_map_table tevii_nec[] = {
 
 static struct rc_map_list tevii_nec_map = {
 	.map = {
-		.scan    = tevii_nec,
-		.size    = ARRAY_SIZE(tevii_nec),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_TEVII_NEC,
+		.scan     = tevii_nec,
+		.size     = ARRAY_SIZE(tevii_nec),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_TEVII_NEC,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-tivo.c b/drivers/media/rc/keymaps/rc-tivo.c
index 5cc1b456e329..1962e33c8f4e 100644
--- a/drivers/media/rc/keymaps/rc-tivo.c
+++ b/drivers/media/rc/keymaps/rc-tivo.c
@@ -75,10 +75,10 @@ static struct rc_map_table tivo[] = {
 
 static struct rc_map_list tivo_map = {
 	.map = {
-		.scan    = tivo,
-		.size    = ARRAY_SIZE(tivo),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_TIVO,
+		.scan     = tivo,
+		.size     = ARRAY_SIZE(tivo),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_TIVO,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-total-media-in-hand-02.c b/drivers/media/rc/keymaps/rc-total-media-in-hand-02.c
index 47270f72ebf0..eeeca142f7b1 100644
--- a/drivers/media/rc/keymaps/rc-total-media-in-hand-02.c
+++ b/drivers/media/rc/keymaps/rc-total-media-in-hand-02.c
@@ -62,10 +62,10 @@ static struct rc_map_table total_media_in_hand_02[] = {
 
 static struct rc_map_list total_media_in_hand_02_map = {
 	.map = {
-		.scan    = total_media_in_hand_02,
-		.size    = ARRAY_SIZE(total_media_in_hand_02),
-		.rc_type = RC_TYPE_RC5,
-		.name    = RC_MAP_TOTAL_MEDIA_IN_HAND_02,
+		.scan     = total_media_in_hand_02,
+		.size     = ARRAY_SIZE(total_media_in_hand_02),
+		.rc_proto = RC_PROTO_RC5,
+		.name     = RC_MAP_TOTAL_MEDIA_IN_HAND_02,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-total-media-in-hand.c b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
index 5b9f9ec13680..bc73bee309d8 100644
--- a/drivers/media/rc/keymaps/rc-total-media-in-hand.c
+++ b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
@@ -62,10 +62,10 @@ static struct rc_map_table total_media_in_hand[] = {
 
 static struct rc_map_list total_media_in_hand_map = {
 	.map = {
-		.scan    = total_media_in_hand,
-		.size    = ARRAY_SIZE(total_media_in_hand),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_TOTAL_MEDIA_IN_HAND,
+		.scan     = total_media_in_hand,
+		.size     = ARRAY_SIZE(total_media_in_hand),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_TOTAL_MEDIA_IN_HAND,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-trekstor.c b/drivers/media/rc/keymaps/rc-trekstor.c
index f9a2e0fabb9f..63f966219342 100644
--- a/drivers/media/rc/keymaps/rc-trekstor.c
+++ b/drivers/media/rc/keymaps/rc-trekstor.c
@@ -57,10 +57,10 @@ static struct rc_map_table trekstor[] = {
 
 static struct rc_map_list trekstor_map = {
 	.map = {
-		.scan    = trekstor,
-		.size    = ARRAY_SIZE(trekstor),
-		.rc_type = RC_TYPE_NEC,
-		.name    = RC_MAP_TREKSTOR,
+		.scan     = trekstor,
+		.size     = ARRAY_SIZE(trekstor),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_TREKSTOR,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-tt-1500.c b/drivers/media/rc/keymaps/rc-tt-1500.c
index c766d3b2b6b0..374c230705d2 100644
--- a/drivers/media/rc/keymaps/rc-tt-1500.c
+++ b/drivers/media/rc/keymaps/rc-tt-1500.c
@@ -59,10 +59,10 @@ static struct rc_map_table tt_1500[] = {
 
 static struct rc_map_list tt_1500_map = {
 	.map = {
-		.scan    = tt_1500,
-		.size    = ARRAY_SIZE(tt_1500),
-		.rc_type = RC_TYPE_RC5,
-		.name    = RC_MAP_TT_1500,
+		.scan     = tt_1500,
+		.size     = ARRAY_SIZE(tt_1500),
+		.rc_proto = RC_PROTO_RC5,
+		.name     = RC_MAP_TT_1500,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c b/drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c
index 202500cb3061..240d720d440c 100644
--- a/drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c
+++ b/drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c
@@ -75,10 +75,10 @@ static struct rc_map_table twinhan_dtv_cab_ci[] = {
 
 static struct rc_map_list twinhan_dtv_cab_ci_map = {
 	.map = {
-		.scan    = twinhan_dtv_cab_ci,
-		.size    = ARRAY_SIZE(twinhan_dtv_cab_ci),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_TWINHAN_DTV_CAB_CI,
+		.scan     = twinhan_dtv_cab_ci,
+		.size     = ARRAY_SIZE(twinhan_dtv_cab_ci),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_TWINHAN_DTV_CAB_CI,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-twinhan1027.c b/drivers/media/rc/keymaps/rc-twinhan1027.c
index 509299b90c90..2275b37c61d2 100644
--- a/drivers/media/rc/keymaps/rc-twinhan1027.c
+++ b/drivers/media/rc/keymaps/rc-twinhan1027.c
@@ -64,10 +64,10 @@ static struct rc_map_table twinhan_vp1027[] = {
 
 static struct rc_map_list twinhan_vp1027_map = {
 	.map = {
-		.scan    = twinhan_vp1027,
-		.size    = ARRAY_SIZE(twinhan_vp1027),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_TWINHAN_VP1027_DVBS,
+		.scan     = twinhan_vp1027,
+		.size     = ARRAY_SIZE(twinhan_vp1027),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_TWINHAN_VP1027_DVBS,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-videomate-m1f.c b/drivers/media/rc/keymaps/rc-videomate-m1f.c
index 23ee05e53949..fe02e047bd01 100644
--- a/drivers/media/rc/keymaps/rc-videomate-m1f.c
+++ b/drivers/media/rc/keymaps/rc-videomate-m1f.c
@@ -69,10 +69,10 @@ static struct rc_map_table videomate_k100[] = {
 
 static struct rc_map_list videomate_k100_map = {
 	.map = {
-		.scan    = videomate_k100,
-		.size    = ARRAY_SIZE(videomate_k100),
-		.rc_type = RC_TYPE_UNKNOWN,     /* Legacy IR type */
-		.name    = RC_MAP_VIDEOMATE_K100,
+		.scan     = videomate_k100,
+		.size     = ARRAY_SIZE(videomate_k100),
+		.rc_proto = RC_PROTO_UNKNOWN,     /* Legacy IR type */
+		.name     = RC_MAP_VIDEOMATE_K100,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-videomate-s350.c b/drivers/media/rc/keymaps/rc-videomate-s350.c
index 8a354775a2d8..b4f103269872 100644
--- a/drivers/media/rc/keymaps/rc-videomate-s350.c
+++ b/drivers/media/rc/keymaps/rc-videomate-s350.c
@@ -62,10 +62,10 @@ static struct rc_map_table videomate_s350[] = {
 
 static struct rc_map_list videomate_s350_map = {
 	.map = {
-		.scan    = videomate_s350,
-		.size    = ARRAY_SIZE(videomate_s350),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_VIDEOMATE_S350,
+		.scan     = videomate_s350,
+		.size     = ARRAY_SIZE(videomate_s350),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_VIDEOMATE_S350,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
index eb0cda7766c4..c431fdf44057 100644
--- a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
+++ b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
@@ -64,10 +64,10 @@ static struct rc_map_table videomate_tv_pvr[] = {
 
 static struct rc_map_list videomate_tv_pvr_map = {
 	.map = {
-		.scan    = videomate_tv_pvr,
-		.size    = ARRAY_SIZE(videomate_tv_pvr),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_VIDEOMATE_TV_PVR,
+		.scan     = videomate_tv_pvr,
+		.size     = ARRAY_SIZE(videomate_tv_pvr),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_VIDEOMATE_TV_PVR,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
index c1dd598e828e..5a437e61bd5d 100644
--- a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
+++ b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
@@ -59,10 +59,10 @@ static struct rc_map_table winfast_usbii_deluxe[] = {
 
 static struct rc_map_list winfast_usbii_deluxe_map = {
 	.map = {
-		.scan    = winfast_usbii_deluxe,
-		.size    = ARRAY_SIZE(winfast_usbii_deluxe),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_WINFAST_USBII_DELUXE,
+		.scan     = winfast_usbii_deluxe,
+		.size     = ARRAY_SIZE(winfast_usbii_deluxe),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_WINFAST_USBII_DELUXE,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-winfast.c b/drivers/media/rc/keymaps/rc-winfast.c
index 8a779da1e973..53685d1f9a47 100644
--- a/drivers/media/rc/keymaps/rc-winfast.c
+++ b/drivers/media/rc/keymaps/rc-winfast.c
@@ -79,10 +79,10 @@ static struct rc_map_table winfast[] = {
 
 static struct rc_map_list winfast_map = {
 	.map = {
-		.scan    = winfast,
-		.size    = ARRAY_SIZE(winfast),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_WINFAST,
+		.scan     = winfast,
+		.size     = ARRAY_SIZE(winfast),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_WINFAST,
 	}
 };
 
diff --git a/drivers/media/rc/keymaps/rc-zx-irdec.c b/drivers/media/rc/keymaps/rc-zx-irdec.c
index cc889df47eb8..5bf3ab002afc 100644
--- a/drivers/media/rc/keymaps/rc-zx-irdec.c
+++ b/drivers/media/rc/keymaps/rc-zx-irdec.c
@@ -57,7 +57,7 @@ static struct rc_map_list zx_irdec_map = {
 	.map = {
 		.scan = zx_irdec_table,
 		.size = ARRAY_SIZE(zx_irdec_table),
-		.rc_type = RC_TYPE_NEC,
+		.rc_proto = RC_PROTO_NEC,
 		.name = RC_MAP_ZX_IRDEC,
 	}
 };
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 60258889b162..bf7aaff3aa37 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1267,7 +1267,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	usb_to_input_id(ir->usbdev, &rc->input_id);
 	rc->dev.parent = dev;
 	rc->priv = ir;
-	rc->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	rc->timeout = MS_TO_NS(100);
 	if (!ir->flags.no_tx) {
 		rc->s_tx_mask = mceusb_set_tx_mask;
diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index dfe3da487be0..f2204eb77e2a 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -143,7 +143,7 @@ static int meson_ir_probe(struct platform_device *pdev)
 	ir->rc->input_id.bustype = BUS_HOST;
 	map_name = of_get_property(node, "linux,rc-map-name", NULL);
 	ir->rc->map_name = map_name ? map_name : RC_MAP_EMPTY;
-	ir->rc->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	ir->rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	ir->rc->rx_resolution = US_TO_NS(MESON_TRATE);
 	ir->rc->timeout = MS_TO_NS(200);
 	ir->rc->driver_name = DRIVER_NAME;
diff --git a/drivers/media/rc/mtk-cir.c b/drivers/media/rc/mtk-cir.c
index da4461fabce6..e88eb64e8e69 100644
--- a/drivers/media/rc/mtk-cir.c
+++ b/drivers/media/rc/mtk-cir.c
@@ -353,7 +353,7 @@ static int mtk_ir_probe(struct platform_device *pdev)
 	ir->rc->map_name = map_name ?: RC_MAP_EMPTY;
 	ir->rc->dev.parent = dev;
 	ir->rc->driver_name = MTK_IR_DEV;
-	ir->rc->allowed_protocols = RC_BIT_ALL;
+	ir->rc->allowed_protocols = RC_PROTO_BIT_ALL;
 	ir->rc->rx_resolution = MTK_IR_SAMPLE;
 	ir->rc->timeout = MTK_MAX_SAMPLES * (MTK_IR_SAMPLE + 1);
 
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 5249cb58ea73..5e1d866a61a5 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1023,8 +1023,8 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	/* Set up the rc device */
 	rdev->priv = nvt;
-	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
-	rdev->allowed_wakeup_protocols = RC_BIT_ALL_IR_ENCODER;
+	rdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
+	rdev->allowed_wakeup_protocols = RC_PROTO_BIT_ALL_IR_ENCODER;
 	rdev->encode_wakeup = true;
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 5e5b10fbc47e..7da9c96cb058 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -27,7 +27,7 @@ struct ir_raw_handler {
 
 	u64 protocols; /* which are handled by this handler */
 	int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
-	int (*encode)(enum rc_type protocol, u32 scancode,
+	int (*encode)(enum rc_proto protocol, u32 scancode,
 		      struct ir_raw_event *events, unsigned int max);
 
 	/* These two should only be used by the lirc decoder */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 1761be8c7028..f495709e28fb 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -213,7 +213,7 @@ ir_raw_get_allowed_protocols(void)
 	return atomic64_read(&available_protocols);
 }
 
-static int change_protocol(struct rc_dev *dev, u64 *rc_type)
+static int change_protocol(struct rc_dev *dev, u64 *rc_proto)
 {
 	/* the caller will update dev->enabled_protocols */
 	return 0;
@@ -450,7 +450,7 @@ EXPORT_SYMBOL(ir_raw_gen_pl);
  *		-EINVAL if the scancode is ambiguous or invalid, or if no
  *		compatible encoder was found.
  */
-int ir_raw_encode_scancode(enum rc_type protocol, u32 scancode,
+int ir_raw_encode_scancode(enum rc_proto protocol, u32 scancode,
 			   struct ir_raw_event *events, unsigned int max)
 {
 	struct ir_raw_handler *handler;
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 46cc9c29d68a..3822d9ebcb46 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -226,8 +226,8 @@ static int __init loop_init(void)
 	rc->driver_name		= DRIVER_NAME;
 	rc->map_name		= RC_MAP_EMPTY;
 	rc->priv		= &loopdev;
-	rc->allowed_protocols	= RC_BIT_ALL_IR_DECODER;
-	rc->allowed_wakeup_protocols = RC_BIT_ALL_IR_ENCODER;
+	rc->allowed_protocols	= RC_PROTO_BIT_ALL_IR_DECODER;
+	rc->allowed_wakeup_protocols = RC_PROTO_BIT_ALL_IR_ENCODER;
 	rc->encode_wakeup	= true;
 	rc->timeout		= 100 * 1000 * 1000; /* 100 ms */
 	rc->min_timeout		= 1;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 7aaf28bcb01e..c494a4ddc138 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -110,10 +110,10 @@ static struct rc_map_table empty[] = {
 
 static struct rc_map_list empty_map = {
 	.map = {
-		.scan    = empty,
-		.size    = ARRAY_SIZE(empty),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_EMPTY,
+		.scan     = empty,
+		.size     = ARRAY_SIZE(empty),
+		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.name     = RC_MAP_EMPTY,
 	}
 };
 
@@ -121,7 +121,7 @@ static struct rc_map_list empty_map = {
  * ir_create_table() - initializes a scancode table
  * @rc_map:	the rc_map to initialize
  * @name:	name to assign to the table
- * @rc_type:	ir type to assign to the new table
+ * @rc_proto:	ir type to assign to the new table
  * @size:	initial size of the table
  * @return:	zero on success or a negative error code
  *
@@ -129,12 +129,12 @@ static struct rc_map_list empty_map = {
  * memory to hold at least the specified number of elements.
  */
 static int ir_create_table(struct rc_map *rc_map,
-			   const char *name, u64 rc_type, size_t size)
+			   const char *name, u64 rc_proto, size_t size)
 {
 	rc_map->name = kstrdup(name, GFP_KERNEL);
 	if (!rc_map->name)
 		return -ENOMEM;
-	rc_map->rc_type = rc_type;
+	rc_map->rc_proto = rc_proto;
 	rc_map->alloc = roundup_pow_of_two(size * sizeof(struct rc_map_table));
 	rc_map->size = rc_map->alloc / sizeof(struct rc_map_table);
 	rc_map->scan = kmalloc(rc_map->alloc, GFP_KERNEL);
@@ -389,7 +389,7 @@ static int ir_setkeytable(struct rc_dev *dev,
 	int rc;
 
 	rc = ir_create_table(rc_map, from->name,
-			     from->rc_type, from->size);
+			     from->rc_proto, from->size);
 	if (rc)
 		return rc;
 
@@ -641,7 +641,7 @@ EXPORT_SYMBOL_GPL(rc_repeat);
  * This function is used internally to register a keypress, it must be
  * called with keylock held.
  */
-static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
+static void ir_do_keydown(struct rc_dev *dev, enum rc_proto protocol,
 			  u32 scancode, u32 keycode, u8 toggle)
 {
 	bool new_event = (!dev->keypressed		 ||
@@ -683,7 +683,8 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
  * This routine is used to signal that a key has been pressed on the
  * remote control.
  */
-void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle)
+void rc_keydown(struct rc_dev *dev, enum rc_proto protocol, u32 scancode,
+		u8 toggle)
 {
 	unsigned long flags;
 	u32 keycode = rc_g_keycode_from_table(dev, scancode);
@@ -711,7 +712,7 @@ EXPORT_SYMBOL_GPL(rc_keydown);
  * This routine is used to signal that a key has been pressed on the
  * remote control. The driver must manually call rc_keyup() at a later stage.
  */
-void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol,
+void rc_keydown_notimeout(struct rc_dev *dev, enum rc_proto protocol,
 			  u32 scancode, u8 toggle)
 {
 	unsigned long flags;
@@ -734,46 +735,46 @@ static int rc_validate_filter(struct rc_dev *dev,
 			      struct rc_scancode_filter *filter)
 {
 	static const u32 masks[] = {
-		[RC_TYPE_RC5] = 0x1f7f,
-		[RC_TYPE_RC5X_20] = 0x1f7f3f,
-		[RC_TYPE_RC5_SZ] = 0x2fff,
-		[RC_TYPE_SONY12] = 0x1f007f,
-		[RC_TYPE_SONY15] = 0xff007f,
-		[RC_TYPE_SONY20] = 0x1fff7f,
-		[RC_TYPE_JVC] = 0xffff,
-		[RC_TYPE_NEC] = 0xffff,
-		[RC_TYPE_NECX] = 0xffffff,
-		[RC_TYPE_NEC32] = 0xffffffff,
-		[RC_TYPE_SANYO] = 0x1fffff,
-		[RC_TYPE_MCIR2_KBD] = 0xffff,
-		[RC_TYPE_MCIR2_MSE] = 0x1fffff,
-		[RC_TYPE_RC6_0] = 0xffff,
-		[RC_TYPE_RC6_6A_20] = 0xfffff,
-		[RC_TYPE_RC6_6A_24] = 0xffffff,
-		[RC_TYPE_RC6_6A_32] = 0xffffffff,
-		[RC_TYPE_RC6_MCE] = 0xffff7fff,
-		[RC_TYPE_SHARP] = 0x1fff,
+		[RC_PROTO_RC5] = 0x1f7f,
+		[RC_PROTO_RC5X_20] = 0x1f7f3f,
+		[RC_PROTO_RC5_SZ] = 0x2fff,
+		[RC_PROTO_SONY12] = 0x1f007f,
+		[RC_PROTO_SONY15] = 0xff007f,
+		[RC_PROTO_SONY20] = 0x1fff7f,
+		[RC_PROTO_JVC] = 0xffff,
+		[RC_PROTO_NEC] = 0xffff,
+		[RC_PROTO_NECX] = 0xffffff,
+		[RC_PROTO_NEC32] = 0xffffffff,
+		[RC_PROTO_SANYO] = 0x1fffff,
+		[RC_PROTO_MCIR2_KBD] = 0xffff,
+		[RC_PROTO_MCIR2_MSE] = 0x1fffff,
+		[RC_PROTO_RC6_0] = 0xffff,
+		[RC_PROTO_RC6_6A_20] = 0xfffff,
+		[RC_PROTO_RC6_6A_24] = 0xffffff,
+		[RC_PROTO_RC6_6A_32] = 0xffffffff,
+		[RC_PROTO_RC6_MCE] = 0xffff7fff,
+		[RC_PROTO_SHARP] = 0x1fff,
 	};
 	u32 s = filter->data;
-	enum rc_type protocol = dev->wakeup_protocol;
+	enum rc_proto protocol = dev->wakeup_protocol;
 
 	if (protocol >= ARRAY_SIZE(masks))
 		return -EINVAL;
 
 	switch (protocol) {
-	case RC_TYPE_NECX:
+	case RC_PROTO_NECX:
 		if ((((s >> 16) ^ ~(s >> 8)) & 0xff) == 0)
 			return -EINVAL;
 		break;
-	case RC_TYPE_NEC32:
+	case RC_PROTO_NEC32:
 		if ((((s >> 24) ^ ~(s >> 16)) & 0xff) == 0)
 			return -EINVAL;
 		break;
-	case RC_TYPE_RC6_MCE:
+	case RC_PROTO_RC6_MCE:
 		if ((s & 0xffff0000) != 0x800f0000)
 			return -EINVAL;
 		break;
-	case RC_TYPE_RC6_6A_32:
+	case RC_PROTO_RC6_6A_32:
 		if ((s & 0xffff0000) == 0x800f0000)
 			return -EINVAL;
 		break;
@@ -862,30 +863,30 @@ static const struct {
 	const char	*name;
 	const char	*module_name;
 } proto_names[] = {
-	{ RC_BIT_NONE,		"none",		NULL			},
-	{ RC_BIT_OTHER,		"other",	NULL			},
-	{ RC_BIT_UNKNOWN,	"unknown",	NULL			},
-	{ RC_BIT_RC5 |
-	  RC_BIT_RC5X_20,	"rc-5",		"ir-rc5-decoder"	},
-	{ RC_BIT_NEC |
-	  RC_BIT_NECX |
-	  RC_BIT_NEC32,		"nec",		"ir-nec-decoder"	},
-	{ RC_BIT_RC6_0 |
-	  RC_BIT_RC6_6A_20 |
-	  RC_BIT_RC6_6A_24 |
-	  RC_BIT_RC6_6A_32 |
-	  RC_BIT_RC6_MCE,	"rc-6",		"ir-rc6-decoder"	},
-	{ RC_BIT_JVC,		"jvc",		"ir-jvc-decoder"	},
-	{ RC_BIT_SONY12 |
-	  RC_BIT_SONY15 |
-	  RC_BIT_SONY20,	"sony",		"ir-sony-decoder"	},
-	{ RC_BIT_RC5_SZ,	"rc-5-sz",	"ir-rc5-decoder"	},
-	{ RC_BIT_SANYO,		"sanyo",	"ir-sanyo-decoder"	},
-	{ RC_BIT_SHARP,		"sharp",	"ir-sharp-decoder"	},
-	{ RC_BIT_MCIR2_KBD |
-	  RC_BIT_MCIR2_MSE,	"mce_kbd",	"ir-mce_kbd-decoder"	},
-	{ RC_BIT_XMP,		"xmp",		"ir-xmp-decoder"	},
-	{ RC_BIT_CEC,		"cec",		NULL			},
+	{ RC_PROTO_BIT_NONE,	"none",		NULL			},
+	{ RC_PROTO_BIT_OTHER,	"other",	NULL			},
+	{ RC_PROTO_BIT_UNKNOWN,	"unknown",	NULL			},
+	{ RC_PROTO_BIT_RC5 |
+	  RC_PROTO_BIT_RC5X_20,	"rc-5",		"ir-rc5-decoder"	},
+	{ RC_PROTO_BIT_NEC |
+	  RC_PROTO_BIT_NECX |
+	  RC_PROTO_BIT_NEC32,	"nec",		"ir-nec-decoder"	},
+	{ RC_PROTO_BIT_RC6_0 |
+	  RC_PROTO_BIT_RC6_6A_20 |
+	  RC_PROTO_BIT_RC6_6A_24 |
+	  RC_PROTO_BIT_RC6_6A_32 |
+	  RC_PROTO_BIT_RC6_MCE,	"rc-6",		"ir-rc6-decoder"	},
+	{ RC_PROTO_BIT_JVC,	"jvc",		"ir-jvc-decoder"	},
+	{ RC_PROTO_BIT_SONY12 |
+	  RC_PROTO_BIT_SONY15 |
+	  RC_PROTO_BIT_SONY20,	"sony",		"ir-sony-decoder"	},
+	{ RC_PROTO_BIT_RC5_SZ,	"rc-5-sz",	"ir-rc5-decoder"	},
+	{ RC_PROTO_BIT_SANYO,	"sanyo",	"ir-sanyo-decoder"	},
+	{ RC_PROTO_BIT_SHARP,	"sharp",	"ir-sharp-decoder"	},
+	{ RC_PROTO_BIT_MCIR2_KBD |
+	  RC_PROTO_BIT_MCIR2_MSE, "mce_kbd",	"ir-mce_kbd-decoder"	},
+	{ RC_PROTO_BIT_XMP,	"xmp",		"ir-xmp-decoder"	},
+	{ RC_PROTO_BIT_CEC,	"cec",		NULL			},
 };
 
 /**
@@ -1055,8 +1056,9 @@ static void ir_raw_load_modules(u64 *protocols)
 	int i, ret;
 
 	for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
-		if (proto_names[i].type == RC_BIT_NONE ||
-		    proto_names[i].type & (RC_BIT_OTHER | RC_BIT_UNKNOWN))
+		if (proto_names[i].type == RC_PROTO_BIT_NONE ||
+		    proto_names[i].type & (RC_PROTO_BIT_OTHER |
+					   RC_PROTO_BIT_UNKNOWN))
 			continue;
 
 		available = ir_raw_get_allowed_protocols();
@@ -1274,7 +1276,7 @@ static ssize_t store_filter(struct device *device,
 		 * Refuse to set a filter unless a protocol is enabled
 		 * and the filter is valid for that protocol
 		 */
-		if (dev->wakeup_protocol != RC_TYPE_UNKNOWN)
+		if (dev->wakeup_protocol != RC_PROTO_UNKNOWN)
 			ret = rc_validate_filter(dev, &new_filter);
 		else
 			ret = -EINVAL;
@@ -1310,29 +1312,29 @@ static ssize_t store_filter(struct device *device,
  * can be programmed exactly what to expect.
  */
 static const char * const proto_variant_names[] = {
-	[RC_TYPE_UNKNOWN] = "unknown",
-	[RC_TYPE_OTHER] = "other",
-	[RC_TYPE_RC5] = "rc-5",
-	[RC_TYPE_RC5X_20] = "rc-5x-20",
-	[RC_TYPE_RC5_SZ] = "rc-5-sz",
-	[RC_TYPE_JVC] = "jvc",
-	[RC_TYPE_SONY12] = "sony-12",
-	[RC_TYPE_SONY15] = "sony-15",
-	[RC_TYPE_SONY20] = "sony-20",
-	[RC_TYPE_NEC] = "nec",
-	[RC_TYPE_NECX] = "nec-x",
-	[RC_TYPE_NEC32] = "nec-32",
-	[RC_TYPE_SANYO] = "sanyo",
-	[RC_TYPE_MCIR2_KBD] = "mcir2-kbd",
-	[RC_TYPE_MCIR2_MSE] = "mcir2-mse",
-	[RC_TYPE_RC6_0] = "rc-6-0",
-	[RC_TYPE_RC6_6A_20] = "rc-6-6a-20",
-	[RC_TYPE_RC6_6A_24] = "rc-6-6a-24",
-	[RC_TYPE_RC6_6A_32] = "rc-6-6a-32",
-	[RC_TYPE_RC6_MCE] = "rc-6-mce",
-	[RC_TYPE_SHARP] = "sharp",
-	[RC_TYPE_XMP] = "xmp",
-	[RC_TYPE_CEC] = "cec",
+	[RC_PROTO_UNKNOWN] = "unknown",
+	[RC_PROTO_OTHER] = "other",
+	[RC_PROTO_RC5] = "rc-5",
+	[RC_PROTO_RC5X_20] = "rc-5x-20",
+	[RC_PROTO_RC5_SZ] = "rc-5-sz",
+	[RC_PROTO_JVC] = "jvc",
+	[RC_PROTO_SONY12] = "sony-12",
+	[RC_PROTO_SONY15] = "sony-15",
+	[RC_PROTO_SONY20] = "sony-20",
+	[RC_PROTO_NEC] = "nec",
+	[RC_PROTO_NECX] = "nec-x",
+	[RC_PROTO_NEC32] = "nec-32",
+	[RC_PROTO_SANYO] = "sanyo",
+	[RC_PROTO_MCIR2_KBD] = "mcir2-kbd",
+	[RC_PROTO_MCIR2_MSE] = "mcir2-mse",
+	[RC_PROTO_RC6_0] = "rc-6-0",
+	[RC_PROTO_RC6_6A_20] = "rc-6-6a-20",
+	[RC_PROTO_RC6_6A_24] = "rc-6-6a-24",
+	[RC_PROTO_RC6_6A_32] = "rc-6-6a-32",
+	[RC_PROTO_RC6_MCE] = "rc-6-mce",
+	[RC_PROTO_SHARP] = "sharp",
+	[RC_PROTO_XMP] = "xmp",
+	[RC_PROTO_CEC] = "cec",
 };
 
 /**
@@ -1355,7 +1357,7 @@ static ssize_t show_wakeup_protocols(struct device *device,
 {
 	struct rc_dev *dev = to_rc_dev(device);
 	u64 allowed;
-	enum rc_type enabled;
+	enum rc_proto enabled;
 	char *tmp = buf;
 	int i;
 
@@ -1406,7 +1408,7 @@ static ssize_t store_wakeup_protocols(struct device *device,
 				      const char *buf, size_t len)
 {
 	struct rc_dev *dev = to_rc_dev(device);
-	enum rc_type protocol;
+	enum rc_proto protocol;
 	ssize_t rc;
 	u64 allowed;
 	int i;
@@ -1416,7 +1418,7 @@ static ssize_t store_wakeup_protocols(struct device *device,
 	allowed = dev->allowed_wakeup_protocols;
 
 	if (sysfs_streq(buf, "none")) {
-		protocol = RC_TYPE_UNKNOWN;
+		protocol = RC_PROTO_UNKNOWN;
 	} else {
 		for (i = 0; i < ARRAY_SIZE(proto_variant_names); i++) {
 			if ((allowed & (1ULL << i)) &&
@@ -1446,7 +1448,7 @@ static ssize_t store_wakeup_protocols(struct device *device,
 		dev->wakeup_protocol = protocol;
 		IR_dprintk(1, "Wakeup protocol changed to %d\n", protocol);
 
-		if (protocol == RC_TYPE_RC6_MCE)
+		if (protocol == RC_PROTO_RC6_MCE)
 			dev->scancode_wakeup_filter.data = 0x800f0000;
 		else
 			dev->scancode_wakeup_filter.data = 0;
@@ -1627,7 +1629,7 @@ static int rc_prepare_rx_device(struct rc_dev *dev)
 {
 	int rc;
 	struct rc_map *rc_map;
-	u64 rc_type;
+	u64 rc_proto;
 
 	if (!dev->map_name)
 		return -EINVAL;
@@ -1642,17 +1644,17 @@ static int rc_prepare_rx_device(struct rc_dev *dev)
 	if (rc)
 		return rc;
 
-	rc_type = BIT_ULL(rc_map->rc_type);
+	rc_proto = BIT_ULL(rc_map->rc_proto);
 
 	if (dev->change_protocol) {
-		rc = dev->change_protocol(dev, &rc_type);
+		rc = dev->change_protocol(dev, &rc_proto);
 		if (rc < 0)
 			goto out_table;
-		dev->enabled_protocols = rc_type;
+		dev->enabled_protocols = rc_proto;
 	}
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
-		ir_raw_load_modules(&rc_type);
+		ir_raw_load_modules(&rc_proto);
 
 	set_bit(EV_KEY, dev->input_dev->evbit);
 	set_bit(EV_REP, dev->input_dev->evbit);
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 29fa37b99553..6784cb9fc4e7 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -956,7 +956,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	usb_to_input_id(rr3->udev, &rc->input_id);
 	rc->dev.parent = dev;
 	rc->priv = rr3;
-	rc->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	rc->min_timeout = MS_TO_NS(RR3_RX_MIN_TIMEOUT);
 	rc->max_timeout = MS_TO_NS(RR3_RX_MAX_TIMEOUT);
 	rc->timeout = US_TO_NS(redrat3_get_timeout(rr3));
diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 9a5e9fa01196..4b8d5f38baf6 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -537,7 +537,7 @@ static int serial_ir_probe(struct platform_device *dev)
 	rcdev->open = serial_ir_open;
 	rcdev->close = serial_ir_close;
 	rcdev->dev.parent = &serial_ir.pdev->dev;
-	rcdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rcdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	rcdev->driver_name = KBUILD_MODNAME;
 	rcdev->map_name = RC_MAP_RC6_MCE;
 	rcdev->min_timeout = 1;
diff --git a/drivers/media/rc/sir_ir.c b/drivers/media/rc/sir_ir.c
index 83b4410664af..bc906fb128d5 100644
--- a/drivers/media/rc/sir_ir.c
+++ b/drivers/media/rc/sir_ir.c
@@ -315,7 +315,7 @@ static int sir_ir_probe(struct platform_device *dev)
 	rcdev->input_id.product = 0x0001;
 	rcdev->input_id.version = 0x0100;
 	rcdev->tx_ir = sir_tx_ir;
-	rcdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rcdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	rcdev->driver_name = KBUILD_MODNAME;
 	rcdev->map_name = RC_MAP_RC6_MCE;
 	rcdev->timeout = IR_DEFAULT_TIMEOUT;
diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index dc15dc8a7d21..a8e39c635f34 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -290,7 +290,7 @@ static int st_rc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, rc_dev);
 	st_rc_hardware_init(rc_dev);
 
-	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	/* rx sampling rate is 10Mhz */
 	rdev->rx_resolution = 100;
 	rdev->timeout = US_TO_NS(MAX_SYMB_TIME);
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 829f2b348a46..f03a174ddf9d 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -304,7 +304,7 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	usb_to_input_id(sz->usbdev, &rdev->input_id);
 	rdev->dev.parent = dev;
 	rdev->priv = sz;
-	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	rdev->driver_name = DRIVER_NAME;
 	rdev->map_name = RC_MAP_STREAMZAP;
 
diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
index f619b76273be..97f367b446c4 100644
--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -224,7 +224,7 @@ static int sunxi_ir_probe(struct platform_device *pdev)
 	ir->map_name = of_get_property(dn, "linux,rc-map-name", NULL);
 	ir->rc->map_name = ir->map_name ?: RC_MAP_EMPTY;
 	ir->rc->dev.parent = dev;
-	ir->rc->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	ir->rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	ir->rc->rx_resolution = SUNXI_IR_SAMPLE;
 	ir->rc->timeout = MS_TO_NS(SUNXI_IR_TIMEOUT);
 	ir->rc->driver_name = SUNXI_IR_DEV;
diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index 5002a91e830e..aafea3c5170b 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -313,7 +313,7 @@ static int ttusbir_probe(struct usb_interface *intf,
 	rc->input_phys = tt->phys;
 	usb_to_input_id(tt->udev, &rc->input_id);
 	rc->dev.parent = &intf->dev;
-	rc->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	rc->priv = tt;
 	rc->driver_name = DRIVER_NAME;
 	rc->map_name = RC_MAP_TT_1500;
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index a18eb232ed81..3ca7ab48293d 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -697,7 +697,7 @@ wbcir_shutdown(struct pnp_dev *device)
 	}
 
 	switch (rc->wakeup_protocol) {
-	case RC_TYPE_RC5:
+	case RC_PROTO_RC5:
 		/* Mask = 13 bits, ex toggle */
 		mask[0]  = (mask_sc & 0x003f);
 		mask[0] |= (mask_sc & 0x0300) >> 2;
@@ -714,7 +714,7 @@ wbcir_shutdown(struct pnp_dev *device)
 		proto = IR_PROTOCOL_RC5;
 		break;
 
-	case RC_TYPE_NEC:
+	case RC_PROTO_NEC:
 		mask[1] = bitrev8(mask_sc);
 		mask[0] = mask[1];
 		mask[3] = bitrev8(mask_sc >> 8);
@@ -728,7 +728,7 @@ wbcir_shutdown(struct pnp_dev *device)
 		proto = IR_PROTOCOL_NEC;
 		break;
 
-	case RC_TYPE_NECX:
+	case RC_PROTO_NECX:
 		mask[1] = bitrev8(mask_sc);
 		mask[0] = mask[1];
 		mask[2] = bitrev8(mask_sc >> 8);
@@ -742,7 +742,7 @@ wbcir_shutdown(struct pnp_dev *device)
 		proto = IR_PROTOCOL_NEC;
 		break;
 
-	case RC_TYPE_NEC32:
+	case RC_PROTO_NEC32:
 		mask[0] = bitrev8(mask_sc);
 		mask[1] = bitrev8(mask_sc >> 8);
 		mask[2] = bitrev8(mask_sc >> 16);
@@ -756,7 +756,7 @@ wbcir_shutdown(struct pnp_dev *device)
 		proto = IR_PROTOCOL_NEC;
 		break;
 
-	case RC_TYPE_RC6_0:
+	case RC_PROTO_RC6_0:
 		/* Command */
 		match[0] = wbcir_to_rc6cells(wake_sc >> 0);
 		mask[0]  = wbcir_to_rc6cells(mask_sc >> 0);
@@ -779,9 +779,9 @@ wbcir_shutdown(struct pnp_dev *device)
 		proto = IR_PROTOCOL_RC6;
 		break;
 
-	case RC_TYPE_RC6_6A_24:
-	case RC_TYPE_RC6_6A_32:
-	case RC_TYPE_RC6_MCE:
+	case RC_PROTO_RC6_6A_24:
+	case RC_PROTO_RC6_6A_32:
+	case RC_PROTO_RC6_MCE:
 		i = 0;
 
 		/* Command */
@@ -800,13 +800,13 @@ wbcir_shutdown(struct pnp_dev *device)
 		match[i]  = wbcir_to_rc6cells(wake_sc >> 16);
 		mask[i++] = wbcir_to_rc6cells(mask_sc >> 16);
 
-		if (rc->wakeup_protocol == RC_TYPE_RC6_6A_20) {
+		if (rc->wakeup_protocol == RC_PROTO_RC6_6A_20) {
 			rc6_csl = 52;
 		} else {
 			match[i]  = wbcir_to_rc6cells(wake_sc >> 20);
 			mask[i++] = wbcir_to_rc6cells(mask_sc >> 20);
 
-			if (rc->wakeup_protocol == RC_TYPE_RC6_6A_24) {
+			if (rc->wakeup_protocol == RC_PROTO_RC6_6A_24) {
 				rc6_csl = 60;
 			} else {
 				/* Customer range bit and bits 15 - 8 */
@@ -1086,12 +1086,13 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->timeout = IR_DEFAULT_TIMEOUT;
 	data->dev->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
 	data->dev->rx_resolution = US_TO_NS(2);
-	data->dev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
-	data->dev->allowed_wakeup_protocols = RC_BIT_NEC | RC_BIT_NECX |
-			RC_BIT_NEC32 | RC_BIT_RC5 | RC_BIT_RC6_0 |
-			RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
-			RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE;
-	data->dev->wakeup_protocol = RC_TYPE_RC6_MCE;
+	data->dev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
+	data->dev->allowed_wakeup_protocols = RC_PROTO_BIT_NEC |
+		RC_PROTO_BIT_NECX | RC_PROTO_BIT_NEC32 | RC_PROTO_BIT_RC5 |
+		RC_PROTO_BIT_RC6_0 | RC_PROTO_BIT_RC6_6A_20 |
+		RC_PROTO_BIT_RC6_6A_24 | RC_PROTO_BIT_RC6_6A_32 |
+		RC_PROTO_BIT_RC6_MCE;
+	data->dev->wakeup_protocol = RC_PROTO_RC6_MCE;
 	data->dev->scancode_wakeup_filter.data = 0x800f040c;
 	data->dev->scancode_wakeup_filter.mask = 0xffff7fff;
 	data->dev->s_wakeup_filter = wbcir_set_wakeup_filter;
diff --git a/drivers/media/rc/zx-irdec.c b/drivers/media/rc/zx-irdec.c
index 9452bac9262c..12d322ec8a29 100644
--- a/drivers/media/rc/zx-irdec.c
+++ b/drivers/media/rc/zx-irdec.c
@@ -54,7 +54,7 @@ static irqreturn_t zx_irdec_irq(int irq, void *dev_id)
 	u8 address, not_address;
 	u8 command, not_command;
 	u32 rawcode, scancode;
-	enum rc_type rc_type;
+	enum rc_proto rc_proto;
 
 	/* Clear interrupt */
 	writel(1, irdec->base + ZX_IR_INTSTCLR);
@@ -73,8 +73,8 @@ static irqreturn_t zx_irdec_irq(int irq, void *dev_id)
 
 	scancode = ir_nec_bytes_to_scancode(address, not_address,
 					    command, not_command,
-					    &rc_type);
-	rc_keydown(irdec->rcd, rc_type, scancode, 0);
+					    &rc_proto);
+	rc_keydown(irdec->rcd, rc_proto, scancode, 0);
 
 done:
 	return IRQ_HANDLED;
@@ -114,7 +114,8 @@ static int zx_irdec_probe(struct platform_device *pdev)
 	rcd->input_phys = DRIVER_NAME "/input0";
 	rcd->input_id.bustype = BUS_HOST;
 	rcd->map_name = RC_MAP_ZX_IRDEC;
-	rcd->allowed_protocols = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32;
+	rcd->allowed_protocols = RC_PROTO_BIT_NEC | RC_PROTO_BIT_NECX |
+							RC_PROTO_BIT_NEC32;
 	rcd->driver_name = DRIVER_NAME;
 	rcd->device_name = DRIVER_NAME;
 
diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 9ae42ebefa8a..7996eb83a54e 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -343,8 +343,8 @@ int au0828_rc_register(struct au0828_dev *dev)
 	rc->input_id.product = le16_to_cpu(dev->usbdev->descriptor.idProduct);
 	rc->dev.parent = &dev->usbdev->dev;
 	rc->driver_name = "au0828-input";
-	rc->allowed_protocols = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 |
-								RC_BIT_RC5;
+	rc->allowed_protocols = RC_PROTO_BIT_NEC | RC_PROTO_BIT_NECX |
+				RC_PROTO_BIT_NEC32 | RC_PROTO_BIT_RC5;
 
 	/* all done */
 	err = rc_register_device(rc);
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index eecf074b0a48..02ebeb16055f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -24,7 +24,7 @@
 
 #define MODULE_NAME "cx231xx-input"
 
-static int get_key_isdbt(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_isdbt(struct IR_i2c *ir, enum rc_proto *protocol,
 			 u32 *pscancode, u8 *toggle)
 {
 	int	rc;
@@ -50,7 +50,7 @@ static int get_key_isdbt(struct IR_i2c *ir, enum rc_type *protocol,
 
 	dev_dbg(&ir->rc->dev, "cmd %02x, scan = %02x\n", cmd, scancode);
 
-	*protocol = RC_TYPE_OTHER;
+	*protocol = RC_PROTO_OTHER;
 	*pscancode = scancode;
 	*toggle = 0;
 	return 1;
@@ -91,7 +91,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	/* The i2c micro-controller only outputs the cmd part of NEC protocol */
 	dev->init_data.rc_dev->scancode_mask = 0xff;
 	dev->init_data.rc_dev->driver_name = "cx231xx";
-	dev->init_data.type = RC_BIT_NEC;
+	dev->init_data.type = RC_PROTO_BIT_NEC;
 	info.addr = 0x30;
 
 	/* Load and bind ir-kbd-i2c */
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 23bbbf367b51..8013659c41b1 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -1237,7 +1237,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 	/* Only process key if canary killed */
 	if (buf[16] != 0xff && buf[0] != 0x01) {
-		enum rc_type proto;
+		enum rc_proto proto;
 		dev_dbg(&d->udev->dev, "%s: key pressed %*ph\n",
 				__func__, 4, buf + 12);
 
@@ -1253,13 +1253,13 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 				/* NEC */
 				state->rc_keycode = RC_SCANCODE_NEC(buf[12],
 								    buf[14]);
-				proto = RC_TYPE_NEC;
+				proto = RC_PROTO_NEC;
 			} else {
 				/* NEC extended*/
 				state->rc_keycode = RC_SCANCODE_NECX(buf[12] << 8 |
 								     buf[13],
 								     buf[14]);
-				proto = RC_TYPE_NECX;
+				proto = RC_PROTO_NECX;
 			}
 		} else {
 			/* 32 bit NEC */
@@ -1267,7 +1267,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 							      buf[13] << 16 |
 							      buf[14] << 8  |
 							      buf[15]);
-			proto = RC_TYPE_NEC32;
+			proto = RC_PROTO_NEC32;
 		}
 		rc_keydown(d->rc_dev, proto, state->rc_keycode, 0);
 	} else {
@@ -1336,7 +1336,8 @@ static int af9015_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 	if (!rc->map_name)
 		rc->map_name = RC_MAP_EMPTY;
 
-	rc->allowed_protos = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32;
+	rc->allowed_protos = RC_PROTO_BIT_NEC | RC_PROTO_BIT_NECX |
+						RC_PROTO_BIT_NEC32;
 	rc->query = af9015_rc_query;
 	rc->interval = 500;
 
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index ccf4a5c68877..666d319d3d1a 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1828,7 +1828,7 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 {
 	struct usb_interface *intf = d->intf;
 	int ret;
-	enum rc_type proto;
+	enum rc_proto proto;
 	u32 key;
 	u8 buf[4];
 	struct usb_req req = { CMD_IR_GET, 0, 0, NULL, 4, buf };
@@ -1843,17 +1843,17 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 		if ((buf[0] + buf[1]) == 0xff) {
 			/* NEC standard 16bit */
 			key = RC_SCANCODE_NEC(buf[0], buf[2]);
-			proto = RC_TYPE_NEC;
+			proto = RC_PROTO_NEC;
 		} else {
 			/* NEC extended 24bit */
 			key = RC_SCANCODE_NECX(buf[0] << 8 | buf[1], buf[2]);
-			proto = RC_TYPE_NECX;
+			proto = RC_PROTO_NECX;
 		}
 	} else {
 		/* NEC full code 32bit */
 		key = RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
 					buf[2] << 8  | buf[3]);
-		proto = RC_TYPE_NEC32;
+		proto = RC_PROTO_NEC32;
 	}
 
 	dev_dbg(&intf->dev, "%*ph\n", 4, buf);
@@ -1881,11 +1881,11 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 		switch (state->ir_type) {
 		case 0: /* NEC */
 		default:
-			rc->allowed_protos = RC_BIT_NEC | RC_BIT_NECX |
-								RC_BIT_NEC32;
+			rc->allowed_protos = RC_PROTO_BIT_NEC |
+					RC_PROTO_BIT_NECX | RC_PROTO_BIT_NEC32;
 			break;
 		case 1: /* RC6 */
-			rc->allowed_protos = RC_BIT_RC6_MCE;
+			rc->allowed_protos = RC_PROTO_BIT_RC6_MCE;
 			break;
 		}
 
diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index 6795c0c609b1..20ee7eea2a91 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -1142,7 +1142,7 @@ static int anysee_rc_query(struct dvb_usb_device *d)
 	if (ircode[0]) {
 		dev_dbg(&d->udev->dev, "%s: key pressed %02x\n", __func__,
 				ircode[1]);
-		rc_keydown(d->rc_dev, RC_TYPE_NEC,
+		rc_keydown(d->rc_dev, RC_PROTO_NEC,
 			   RC_SCANCODE_NEC(0x08, ircode[1]), 0);
 	}
 
@@ -1151,7 +1151,7 @@ static int anysee_rc_query(struct dvb_usb_device *d)
 
 static int anysee_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 {
-	rc->allowed_protos = RC_BIT_NEC;
+	rc->allowed_protos = RC_PROTO_BIT_NEC;
 	rc->query          = anysee_rc_query;
 	rc->interval       = 250;  /* windows driver uses 500ms */
 
diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index 50c07fe7dacb..5c59505cd2e6 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -208,7 +208,7 @@ static int az6007_rc_query(struct dvb_usb_device *d)
 {
 	struct az6007_device_state *st = d_to_priv(d);
 	unsigned code;
-	enum rc_type proto;
+	enum rc_proto proto;
 
 	az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10);
 
@@ -218,18 +218,18 @@ static int az6007_rc_query(struct dvb_usb_device *d)
 	if ((st->data[3] ^ st->data[4]) == 0xff) {
 		if ((st->data[1] ^ st->data[2]) == 0xff) {
 			code = RC_SCANCODE_NEC(st->data[1], st->data[3]);
-			proto = RC_TYPE_NEC;
+			proto = RC_PROTO_NEC;
 		} else {
 			code = RC_SCANCODE_NECX(st->data[1] << 8 | st->data[2],
 						st->data[3]);
-			proto = RC_TYPE_NECX;
+			proto = RC_PROTO_NECX;
 		}
 	} else {
 		code = RC_SCANCODE_NEC32(st->data[1] << 24 |
 					 st->data[2] << 16 |
 					 st->data[3] << 8  |
 					 st->data[4]);
-		proto = RC_TYPE_NEC32;
+		proto = RC_PROTO_NEC32;
 	}
 
 	rc_keydown(d->rc_dev, proto, code, st->data[5]);
@@ -241,7 +241,8 @@ static int az6007_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 {
 	pr_debug("Getting az6007 Remote Control properties\n");
 
-	rc->allowed_protos = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32;
+	rc->allowed_protos = RC_PROTO_BIT_NEC | RC_PROTO_BIT_NECX |
+						RC_PROTO_BIT_NEC32;
 	rc->query          = az6007_rc_query;
 	rc->interval       = 400;
 
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 35f27e2e4e28..0005bdb2207d 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -138,7 +138,7 @@ struct dvb_usb_driver_info {
 struct dvb_usb_rc {
 	const char *map_name;
 	u64 allowed_protos;
-	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
+	int (*change_protocol)(struct rc_dev *dev, u64 *rc_proto);
 	int (*query) (struct dvb_usb_device *d);
 	unsigned int interval;
 	enum rc_driver_type driver_type;
diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 5730760e4e93..131b6c08e199 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -211,7 +211,7 @@ static int dvbsky_rc_query(struct dvb_usb_device *d)
 		rc5_system = (code & 0x7C0) >> 6;
 		toggle = (code & 0x800) ? 1 : 0;
 		scancode = rc5_system << 8 | rc5_command;
-		rc_keydown(d->rc_dev, RC_TYPE_RC5, scancode, toggle);
+		rc_keydown(d->rc_dev, RC_PROTO_RC5, scancode, toggle);
 	}
 	return 0;
 }
@@ -223,7 +223,7 @@ static int dvbsky_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 		return 0;
 	}
 
-	rc->allowed_protos = RC_BIT_RC5;
+	rc->allowed_protos = RC_PROTO_BIT_RC5;
 	rc->query          = dvbsky_rc_query;
 	rc->interval       = 300;
 	return 0;
diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index a91fdad8f8d4..5e320fa4a795 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -347,8 +347,8 @@ static void lme2510_int_response(struct urb *lme_urb)
 						ibuf[5]);
 
 			deb_info(1, "INT Key = 0x%08x", key);
-			rc_keydown(adap_to_d(adap)->rc_dev, RC_TYPE_NEC32, key,
-									0);
+			rc_keydown(adap_to_d(adap)->rc_dev, RC_PROTO_NEC32, key,
+				   0);
 			break;
 		case 0xbb:
 			switch (st->tuner_config) {
@@ -1232,7 +1232,7 @@ static int lme2510_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
 static int lme2510_get_rc_config(struct dvb_usb_device *d,
 	struct dvb_usb_rc *rc)
 {
-	rc->allowed_protos = RC_BIT_NEC32;
+	rc->allowed_protos = RC_PROTO_BIT_NEC32;
 	return 0;
 }
 
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index e16ca07acf1d..95a7b9123f8e 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1631,24 +1631,24 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 		goto err;
 
 	if (buf[4] & 0x01) {
-		enum rc_type proto;
+		enum rc_proto proto;
 
 		if (buf[2] == (u8) ~buf[3]) {
 			if (buf[0] == (u8) ~buf[1]) {
 				/* NEC standard (16 bit) */
 				rc_code = RC_SCANCODE_NEC(buf[0], buf[2]);
-				proto = RC_TYPE_NEC;
+				proto = RC_PROTO_NEC;
 			} else {
 				/* NEC extended (24 bit) */
 				rc_code = RC_SCANCODE_NECX(buf[0] << 8 | buf[1],
 							   buf[2]);
-				proto = RC_TYPE_NECX;
+				proto = RC_PROTO_NECX;
 			}
 		} else {
 			/* NEC full (32 bit) */
 			rc_code = RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
 						    buf[2] << 8  | buf[3]);
-			proto = RC_TYPE_NEC32;
+			proto = RC_PROTO_NEC32;
 		}
 
 		rc_keydown(d->rc_dev, proto, rc_code, 0);
@@ -1673,7 +1673,8 @@ static int rtl2831u_get_rc_config(struct dvb_usb_device *d,
 		struct dvb_usb_rc *rc)
 {
 	rc->map_name = RC_MAP_EMPTY;
-	rc->allowed_protos = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32;
+	rc->allowed_protos = RC_PROTO_BIT_NEC | RC_PROTO_BIT_NECX |
+							RC_PROTO_BIT_NEC32;
 	rc->query = rtl2831u_rc_query;
 	rc->interval = 400;
 
@@ -1778,7 +1779,7 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
 	/* load empty to enable rc */
 	if (!rc->map_name)
 		rc->map_name = RC_MAP_EMPTY;
-	rc->allowed_protos = RC_BIT_ALL_IR_DECODER;
+	rc->allowed_protos = RC_PROTO_BIT_ALL_IR_DECODER;
 	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->query = rtl2832u_rc_query;
 	rc->interval = 200;
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 99a3f3625944..37dea0adc695 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -458,7 +458,7 @@ static int cxusb_rc_query(struct dvb_usb_device *d)
 	cxusb_ctrl_msg(d, CMD_GET_IR_CODE, NULL, 0, ircode, 4);
 
 	if (ircode[2] || ircode[3])
-		rc_keydown(d->rc_dev, RC_TYPE_NEC,
+		rc_keydown(d->rc_dev, RC_PROTO_NEC,
 			   RC_SCANCODE_NEC(~ircode[2] & 0xff, ircode[3]), 0);
 	return 0;
 }
@@ -473,7 +473,7 @@ static int cxusb_bluebird2_rc_query(struct dvb_usb_device *d)
 		return 0;
 
 	if (ircode[1] || ircode[2])
-		rc_keydown(d->rc_dev, RC_TYPE_NEC,
+		rc_keydown(d->rc_dev, RC_PROTO_NEC,
 			   RC_SCANCODE_NEC(~ircode[1] & 0xff, ircode[2]), 0);
 	return 0;
 }
@@ -486,7 +486,7 @@ static int cxusb_d680_dmb_rc_query(struct dvb_usb_device *d)
 		return 0;
 
 	if (ircode[0] || ircode[1])
-		rc_keydown(d->rc_dev, RC_TYPE_UNKNOWN,
+		rc_keydown(d->rc_dev, RC_PROTO_UNKNOWN,
 			   RC_SCANCODE_RC5(ircode[0], ircode[1]), 0);
 	return 0;
 }
@@ -1646,7 +1646,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgh064f_properties = {
 		.rc_codes	= RC_MAP_DVICO_PORTABLE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query	= cxusb_rc_query,
-		.allowed_protos = RC_BIT_NEC,
+		.allowed_protos = RC_PROTO_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1703,7 +1703,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_dee1601_properties = {
 		.rc_codes	= RC_MAP_DVICO_MCE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query	= cxusb_rc_query,
-		.allowed_protos = RC_BIT_NEC,
+		.allowed_protos = RC_PROTO_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1768,7 +1768,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgz201_properties = {
 		.rc_codes	= RC_MAP_DVICO_PORTABLE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query	= cxusb_rc_query,
-		.allowed_protos = RC_BIT_NEC,
+		.allowed_protos = RC_PROTO_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1824,7 +1824,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_dtt7579_properties = {
 		.rc_codes	= RC_MAP_DVICO_PORTABLE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query	= cxusb_rc_query,
-		.allowed_protos = RC_BIT_NEC,
+		.allowed_protos = RC_PROTO_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1879,7 +1879,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_dualdig4_properties = {
 		.rc_codes	= RC_MAP_DVICO_MCE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query	= cxusb_bluebird2_rc_query,
-		.allowed_protos = RC_BIT_NEC,
+		.allowed_protos = RC_PROTO_BIT_NEC,
 	},
 
 	.num_device_descs = 1,
@@ -1933,7 +1933,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_properties = {
 		.rc_codes	= RC_MAP_DVICO_PORTABLE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query       = cxusb_bluebird2_rc_query,
-		.allowed_protos = RC_BIT_NEC,
+		.allowed_protos = RC_PROTO_BIT_NEC,
 	},
 
 	.num_device_descs = 1,
@@ -1989,7 +1989,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_needsfirmware_prope
 		.rc_codes	= RC_MAP_DVICO_PORTABLE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query	= cxusb_rc_query,
-		.allowed_protos = RC_BIT_NEC,
+		.allowed_protos = RC_PROTO_BIT_NEC,
 	},
 
 	.num_device_descs = 1,
@@ -2088,7 +2088,7 @@ struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties = {
 		.rc_codes	= RC_MAP_DVICO_MCE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query	= cxusb_rc_query,
-		.allowed_protos = RC_BIT_NEC,
+		.allowed_protos = RC_PROTO_BIT_NEC,
 	},
 
 	.num_device_descs = 1,
@@ -2142,7 +2142,7 @@ static struct dvb_usb_device_properties cxusb_d680_dmb_properties = {
 		.rc_codes	= RC_MAP_D680_DMB,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query       = cxusb_d680_dmb_rc_query,
-		.allowed_protos = RC_BIT_UNKNOWN,
+		.allowed_protos = RC_PROTO_BIT_UNKNOWN,
 	},
 
 	.num_device_descs = 1,
@@ -2197,7 +2197,7 @@ static struct dvb_usb_device_properties cxusb_mygica_d689_properties = {
 		.rc_codes	= RC_MAP_D680_DMB,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query       = cxusb_d680_dmb_rc_query,
-		.allowed_protos = RC_BIT_UNKNOWN,
+		.allowed_protos = RC_PROTO_BIT_UNKNOWN,
 	},
 
 	.num_device_descs = 1,
@@ -2251,7 +2251,7 @@ static struct dvb_usb_device_properties cxusb_mygica_t230_properties = {
 		.rc_codes	= RC_MAP_TOTAL_MEDIA_IN_HAND_02,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query       = cxusb_d680_dmb_rc_query,
-		.allowed_protos = RC_BIT_UNKNOWN,
+		.allowed_protos = RC_PROTO_BIT_UNKNOWN,
 	},
 
 	.num_device_descs = 1,
@@ -2305,7 +2305,7 @@ static struct dvb_usb_device_properties cxusb_mygica_t230c_properties = {
 		.rc_codes	= RC_MAP_TOTAL_MEDIA_IN_HAND_02,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query       = cxusb_d680_dmb_rc_query,
-		.allowed_protos = RC_BIT_UNKNOWN,
+		.allowed_protos = RC_PROTO_BIT_UNKNOWN,
 	},
 
 	.num_device_descs = 1,
diff --git a/drivers/media/usb/dvb-usb/dib0700.h b/drivers/media/usb/dvb-usb/dib0700.h
index 8fd8f5b489d2..f89ab3b5a6c4 100644
--- a/drivers/media/usb/dvb-usb/dib0700.h
+++ b/drivers/media/usb/dvb-usb/dib0700.h
@@ -64,7 +64,7 @@ extern int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff);
 extern struct i2c_algorithm dib0700_i2c_algo;
 extern int dib0700_identify_state(struct usb_device *udev, struct dvb_usb_device_properties *props,
 			struct dvb_usb_device_description **desc, int *cold);
-extern int dib0700_change_protocol(struct rc_dev *dev, u64 *rc_type);
+extern int dib0700_change_protocol(struct rc_dev *dev, u64 *rc_proto);
 extern int dib0700_set_i2c_speed(struct dvb_usb_device *d, u16 scl_kHz);
 
 extern int dib0700_device_count;
diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index bea1b4764a66..1ee7ec558293 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -638,7 +638,7 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	return ret;
 }
 
-int dib0700_change_protocol(struct rc_dev *rc, u64 *rc_type)
+int dib0700_change_protocol(struct rc_dev *rc, u64 *rc_proto)
 {
 	struct dvb_usb_device *d = rc->priv;
 	struct dib0700_state *st = d->priv;
@@ -654,19 +654,19 @@ int dib0700_change_protocol(struct rc_dev *rc, u64 *rc_type)
 	st->buf[2] = 0;
 
 	/* Set the IR mode */
-	if (*rc_type & RC_BIT_RC5) {
+	if (*rc_proto & RC_PROTO_BIT_RC5) {
 		new_proto = 1;
-		*rc_type = RC_BIT_RC5;
-	} else if (*rc_type & RC_BIT_NEC) {
+		*rc_proto = RC_PROTO_BIT_RC5;
+	} else if (*rc_proto & RC_PROTO_BIT_NEC) {
 		new_proto = 0;
-		*rc_type = RC_BIT_NEC;
-	} else if (*rc_type & RC_BIT_RC6_MCE) {
+		*rc_proto = RC_PROTO_BIT_NEC;
+	} else if (*rc_proto & RC_PROTO_BIT_RC6_MCE) {
 		if (st->fw_version < 0x10200) {
 			ret = -EINVAL;
 			goto out;
 		}
 		new_proto = 2;
-		*rc_type = RC_BIT_RC6_MCE;
+		*rc_proto = RC_PROTO_BIT_RC6_MCE;
 	} else {
 		ret = -EINVAL;
 		goto out;
@@ -680,7 +680,7 @@ int dib0700_change_protocol(struct rc_dev *rc, u64 *rc_type)
 		goto out;
 	}
 
-	d->props.rc.core.protocol = *rc_type;
+	d->props.rc.core.protocol = *rc_proto;
 
 out:
 	mutex_unlock(&d->usb_mutex);
@@ -712,7 +712,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 {
 	struct dvb_usb_device *d = purb->context;
 	struct dib0700_rc_response *poll_reply;
-	enum rc_type protocol;
+	enum rc_proto protocol;
 	u32 keycode;
 	u8 toggle;
 
@@ -745,7 +745,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		 purb->actual_length);
 
 	switch (d->props.rc.core.protocol) {
-	case RC_BIT_NEC:
+	case RC_PROTO_BIT_NEC:
 		toggle = 0;
 
 		/* NEC protocol sends repeat code as 0 0 0 FF */
@@ -764,25 +764,25 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 						     poll_reply->nec.not_system << 16 |
 						     poll_reply->nec.data       << 8  |
 						     poll_reply->nec.not_data);
-			protocol = RC_TYPE_NEC32;
+			protocol = RC_PROTO_NEC32;
 		} else if ((poll_reply->nec.system ^ poll_reply->nec.not_system) != 0xff) {
 			deb_data("NEC extended protocol\n");
 			keycode = RC_SCANCODE_NECX(poll_reply->nec.system << 8 |
 						    poll_reply->nec.not_system,
 						    poll_reply->nec.data);
 
-			protocol = RC_TYPE_NECX;
+			protocol = RC_PROTO_NECX;
 		} else {
 			deb_data("NEC normal protocol\n");
 			keycode = RC_SCANCODE_NEC(poll_reply->nec.system,
 						   poll_reply->nec.data);
-			protocol = RC_TYPE_NEC;
+			protocol = RC_PROTO_NEC;
 		}
 
 		break;
 	default:
 		deb_data("RC5 protocol\n");
-		protocol = RC_TYPE_RC5;
+		protocol = RC_PROTO_RC5;
 		toggle = poll_reply->report_id;
 		keycode = RC_SCANCODE_RC5(poll_reply->rc5.system, poll_reply->rc5.data);
 
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 6a57fc6d3472..6020170fe99a 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -514,7 +514,7 @@ static int stk7700ph_tuner_attach(struct dvb_usb_adapter *adap)
  */
 static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 {
-	enum rc_type protocol;
+	enum rc_proto protocol;
 	u32 scancode;
 	u8 toggle;
 	int i;
@@ -547,7 +547,7 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 	dib0700_rc_setup(d, NULL); /* reset ir sensor data to prevent false events */
 
 	switch (d->props.rc.core.protocol) {
-	case RC_BIT_NEC:
+	case RC_PROTO_BIT_NEC:
 		/* NEC protocol sends repeat code as 0 0 0 FF */
 		if ((st->buf[3 - 2] == 0x00) && (st->buf[3 - 3] == 0x00) &&
 		    (st->buf[3] == 0xff)) {
@@ -555,14 +555,14 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 			return 0;
 		}
 
-		protocol = RC_TYPE_NEC;
+		protocol = RC_PROTO_NEC;
 		scancode = RC_SCANCODE_NEC(st->buf[3 - 2], st->buf[3 - 3]);
 		toggle = 0;
 		break;
 
 	default:
 		/* RC-5 protocol changes toggle bit on new keypress */
-		protocol = RC_TYPE_RC5;
+		protocol = RC_PROTO_RC5;
 		scancode = RC_SCANCODE_RC5(st->buf[3 - 2], st->buf[3 - 3]);
 		toggle = st->buf[3 - 1];
 		break;
@@ -3909,9 +3909,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3949,9 +3949,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4014,9 +4014,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4059,9 +4059,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4140,9 +4140,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4185,9 +4185,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4242,9 +4242,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4308,9 +4308,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4357,9 +4357,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4430,9 +4430,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4466,9 +4466,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4542,9 +4542,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4586,9 +4586,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4635,9 +4635,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4672,9 +4672,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4709,9 +4709,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4746,9 +4746,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4783,9 +4783,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4820,9 +4820,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4871,9 +4871,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4906,9 +4906,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4943,9 +4943,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4981,9 +4981,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-					    RC_BIT_RC6_MCE |
-					    RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+					    RC_PROTO_BIT_RC6_MCE |
+					    RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -5035,9 +5035,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_BIT_RC5 |
-				RC_BIT_RC6_MCE |
-				RC_BIT_NEC,
+			.allowed_protos   = RC_PROTO_BIT_RC5 |
+				RC_PROTO_BIT_RC6_MCE |
+				RC_PROTO_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	},
diff --git a/drivers/media/usb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-usb/dtt200u.c
index fcbff7fb0c4e..512370786696 100644
--- a/drivers/media/usb/dvb-usb/dtt200u.c
+++ b/drivers/media/usb/dvb-usb/dtt200u.c
@@ -100,14 +100,14 @@ static int dtt200u_rc_query(struct dvb_usb_device *d)
 		goto ret;
 
 	if (st->data[0] == 1) {
-		enum rc_type proto = RC_TYPE_NEC;
+		enum rc_proto proto = RC_PROTO_NEC;
 
 		scancode = st->data[1];
 		if ((u8) ~st->data[1] != st->data[2]) {
 			/* Extended NEC */
 			scancode = scancode << 8;
 			scancode |= st->data[2];
-			proto = RC_TYPE_NECX;
+			proto = RC_PROTO_NECX;
 		}
 		scancode = scancode << 8;
 		scancode |= st->data[3];
@@ -213,7 +213,7 @@ static struct dvb_usb_device_properties dtt200u_properties = {
 		.rc_interval     = 300,
 		.rc_codes        = RC_MAP_DTT200U,
 		.rc_query        = dtt200u_rc_query,
-		.allowed_protos  = RC_BIT_NEC,
+		.allowed_protos  = RC_PROTO_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -265,7 +265,7 @@ static struct dvb_usb_device_properties wt220u_properties = {
 		.rc_interval     = 300,
 		.rc_codes        = RC_MAP_DTT200U,
 		.rc_query        = dtt200u_rc_query,
-		.allowed_protos  = RC_BIT_NEC,
+		.allowed_protos  = RC_PROTO_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -317,7 +317,7 @@ static struct dvb_usb_device_properties wt220u_fc_properties = {
 		.rc_interval     = 300,
 		.rc_codes        = RC_MAP_DTT200U,
 		.rc_query        = dtt200u_rc_query,
-		.allowed_protos  = RC_BIT_NEC,
+		.allowed_protos  = RC_PROTO_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -369,7 +369,7 @@ static struct dvb_usb_device_properties wt220u_zl0353_properties = {
 		.rc_interval     = 300,
 		.rc_codes        = RC_MAP_DTT200U,
 		.rc_query        = dtt200u_rc_query,
-		.allowed_protos  = RC_BIT_NEC,
+		.allowed_protos  = RC_PROTO_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
index 67f898b6f6d0..72468fdffa18 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb.h
+++ b/drivers/media/usb/dvb-usb/dvb-usb.h
@@ -202,7 +202,7 @@ struct dvb_rc {
 	u64 protocol;
 	u64 allowed_protos;
 	enum rc_driver_type driver_type;
-	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
+	int (*change_protocol)(struct rc_dev *dev, u64 *rc_proto);
 	char *module_name;
 	int (*rc_query) (struct dvb_usb_device *d);
 	int rc_interval;
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 57b187240110..11109b1e641f 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -1671,7 +1671,7 @@ static int dw2102_rc_query(struct dvb_usb_device *d)
 		if (msg.buf[0] != 0xff) {
 			deb_rc("%s: rc code: %x, %x\n",
 					__func__, key[0], key[1]);
-			rc_keydown(d->rc_dev, RC_TYPE_UNKNOWN, key[0], 0);
+			rc_keydown(d->rc_dev, RC_PROTO_UNKNOWN, key[0], 0);
 		}
 	}
 
@@ -1692,7 +1692,8 @@ static int prof_rc_query(struct dvb_usb_device *d)
 		if (msg.buf[0] != 0xff) {
 			deb_rc("%s: rc code: %x, %x\n",
 					__func__, key[0], key[1]);
-			rc_keydown(d->rc_dev, RC_TYPE_UNKNOWN, key[0]^0xff, 0);
+			rc_keydown(d->rc_dev, RC_PROTO_UNKNOWN, key[0] ^ 0xff,
+				   0);
 		}
 	}
 
@@ -1713,7 +1714,7 @@ static int su3000_rc_query(struct dvb_usb_device *d)
 		if (msg.buf[0] != 0xff) {
 			deb_rc("%s: rc code: %x, %x\n",
 					__func__, key[0], key[1]);
-			rc_keydown(d->rc_dev, RC_TYPE_RC5,
+			rc_keydown(d->rc_dev, RC_PROTO_RC5,
 				   RC_SCANCODE_RC5(key[1], key[0]), 0);
 		}
 	}
@@ -1912,7 +1913,7 @@ static struct dvb_usb_device_properties dw2102_properties = {
 		.rc_interval = 150,
 		.rc_codes = RC_MAP_DM1105_NEC,
 		.module_name = "dw2102",
-		.allowed_protos   = RC_BIT_NEC,
+		.allowed_protos   = RC_PROTO_BIT_NEC,
 		.rc_query = dw2102_rc_query,
 	},
 
@@ -1967,7 +1968,7 @@ static struct dvb_usb_device_properties dw2104_properties = {
 		.rc_interval = 150,
 		.rc_codes = RC_MAP_DM1105_NEC,
 		.module_name = "dw2102",
-		.allowed_protos   = RC_BIT_NEC,
+		.allowed_protos   = RC_PROTO_BIT_NEC,
 		.rc_query = dw2102_rc_query,
 	},
 
@@ -2018,7 +2019,7 @@ static struct dvb_usb_device_properties dw3101_properties = {
 		.rc_interval = 150,
 		.rc_codes = RC_MAP_DM1105_NEC,
 		.module_name = "dw2102",
-		.allowed_protos   = RC_BIT_NEC,
+		.allowed_protos   = RC_PROTO_BIT_NEC,
 		.rc_query = dw2102_rc_query,
 	},
 
@@ -2067,7 +2068,7 @@ static struct dvb_usb_device_properties s6x0_properties = {
 		.rc_interval = 150,
 		.rc_codes = RC_MAP_TEVII_NEC,
 		.module_name = "dw2102",
-		.allowed_protos   = RC_BIT_NEC,
+		.allowed_protos   = RC_PROTO_BIT_NEC,
 		.rc_query = dw2102_rc_query,
 	},
 
@@ -2161,7 +2162,7 @@ static struct dvb_usb_device_properties su3000_properties = {
 		.rc_interval = 150,
 		.rc_codes = RC_MAP_SU3000,
 		.module_name = "dw2102",
-		.allowed_protos   = RC_BIT_RC5,
+		.allowed_protos   = RC_PROTO_BIT_RC5,
 		.rc_query = su3000_rc_query,
 	},
 
@@ -2230,7 +2231,7 @@ static struct dvb_usb_device_properties t220_properties = {
 		.rc_interval = 150,
 		.rc_codes = RC_MAP_SU3000,
 		.module_name = "dw2102",
-		.allowed_protos   = RC_BIT_RC5,
+		.allowed_protos   = RC_PROTO_BIT_RC5,
 		.rc_query = su3000_rc_query,
 	},
 
@@ -2279,7 +2280,7 @@ static struct dvb_usb_device_properties tt_s2_4600_properties = {
 		.rc_interval = 250,
 		.rc_codes = RC_MAP_TT_1500,
 		.module_name = "dw2102",
-		.allowed_protos   = RC_BIT_RC5,
+		.allowed_protos   = RC_PROTO_BIT_RC5,
 		.rc_query = su3000_rc_query,
 	},
 
diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index 70672e1e5ec7..32081c2ce0da 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -241,7 +241,7 @@ static int m920x_rc_core_query(struct dvb_usb_device *d)
 	else if (state == REMOTE_KEY_REPEAT)
 		rc_repeat(d->rc_dev);
 	else
-		rc_keydown(d->rc_dev, RC_TYPE_UNKNOWN, rc_state[1], 0);
+		rc_keydown(d->rc_dev, RC_PROTO_UNKNOWN, rc_state[1], 0);
 
 out:
 	kfree(rc_state);
@@ -1208,7 +1208,7 @@ static struct dvb_usb_device_properties vp7049_properties = {
 		.rc_interval    = 150,
 		.rc_codes       = RC_MAP_TWINHAN_VP1027_DVBS,
 		.rc_query       = m920x_rc_core_query,
-		.allowed_protos = RC_BIT_UNKNOWN,
+		.allowed_protos = RC_PROTO_BIT_UNKNOWN,
 	},
 
 	.size_of_priv     = sizeof(struct m920x_state),
diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index d54ebe7e0215..601ade7ca48d 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -600,7 +600,7 @@ static int pctv452e_rc_query(struct dvb_usb_device *d)
 			info("%s: cmd=0x%02x sys=0x%02x\n",
 				__func__, rx[6], rx[7]);
 
-		rc_keydown(d->rc_dev, RC_TYPE_RC5, state->last_rc_key, 0);
+		rc_keydown(d->rc_dev, RC_PROTO_RC5, state->last_rc_key, 0);
 	} else if (state->last_rc_key) {
 		rc_keyup(d->rc_dev);
 		state->last_rc_key = 0;
@@ -958,7 +958,7 @@ static struct dvb_usb_device_properties pctv452e_properties = {
 
 	.rc.core = {
 		.rc_codes	= RC_MAP_DIB0700_RC5_TABLE,
-		.allowed_protos	= RC_BIT_RC5,
+		.allowed_protos	= RC_PROTO_BIT_RC5,
 		.rc_query	= pctv452e_rc_query,
 		.rc_interval	= 100,
 	},
@@ -1011,7 +1011,7 @@ static struct dvb_usb_device_properties tt_connect_s2_3600_properties = {
 
 	.rc.core = {
 		.rc_codes	= RC_MAP_TT_1500,
-		.allowed_protos	= RC_BIT_RC5,
+		.allowed_protos	= RC_PROTO_BIT_RC5,
 		.rc_query	= pctv452e_rc_query,
 		.rc_interval	= 100,
 	},
diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index 9f7dd1afcb15..18d0f8f5283f 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -749,7 +749,7 @@ static struct dvb_usb_device_properties technisat_usb2_devices = {
 		.rc_codes    = RC_MAP_TECHNISAT_USB2,
 		.module_name = "technisat-usb2",
 		.rc_query    = technisat_usb2_rc_query,
-		.allowed_protos = RC_BIT_ALL_IR_DECODER,
+		.allowed_protos = RC_PROTO_BIT_ALL_IR_DECODER,
 		.driver_type    = RC_DRIVER_IR_RAW,
 	}
 };
diff --git a/drivers/media/usb/dvb-usb/ttusb2.c b/drivers/media/usb/dvb-usb/ttusb2.c
index 9e0d6a4166d2..e7020f245f53 100644
--- a/drivers/media/usb/dvb-usb/ttusb2.c
+++ b/drivers/media/usb/dvb-usb/ttusb2.c
@@ -459,7 +459,7 @@ static int tt3650_rc_query(struct dvb_usb_device *d)
 		/* got a "press" event */
 		st->last_rc_key = RC_SCANCODE_RC5(rx[3], rx[2]);
 		deb_info("%s: cmd=0x%02x sys=0x%02x\n", __func__, rx[2], rx[3]);
-		rc_keydown(d->rc_dev, RC_TYPE_RC5, st->last_rc_key, rx[1]);
+		rc_keydown(d->rc_dev, RC_PROTO_RC5, st->last_rc_key, rx[1]);
 	} else if (st->last_rc_key) {
 		rc_keyup(d->rc_dev);
 		st->last_rc_key = 0;
@@ -766,7 +766,7 @@ static struct dvb_usb_device_properties ttusb2_properties_ct3650 = {
 		.rc_interval      = 150, /* Less than IR_KEYPRESS_TIMEOUT */
 		.rc_codes         = RC_MAP_TT_1500,
 		.rc_query         = tt3650_rc_query,
-		.allowed_protos   = RC_BIT_RC5,
+		.allowed_protos   = RC_PROTO_BIT_RC5,
 	},
 
 	.num_adapters = 1,
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index d8746b96a0f8..046223de1e91 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -55,7 +55,7 @@ struct em28xx_ir_poll_result {
 	unsigned int toggle_bit:1;
 	unsigned int read_count:7;
 
-	enum rc_type protocol;
+	enum rc_proto protocol;
 	u32 scancode;
 };
 
@@ -70,11 +70,12 @@ struct em28xx_IR {
 	struct delayed_work work;
 	unsigned int full_code:1;
 	unsigned int last_readcount;
-	u64 rc_type;
+	u64 rc_proto;
 
 	struct i2c_client *i2c_client;
 
-	int  (*get_key_i2c)(struct i2c_client *ir, enum rc_type *protocol, u32 *scancode);
+	int  (*get_key_i2c)(struct i2c_client *ir, enum rc_proto *protocol,
+			    u32 *scancode);
 	int  (*get_key)(struct em28xx_IR *, struct em28xx_ir_poll_result *);
 };
 
@@ -83,7 +84,7 @@ struct em28xx_IR {
  **********************************************************/
 
 static int em28xx_get_key_terratec(struct i2c_client *i2c_dev,
-				   enum rc_type *protocol, u32 *scancode)
+				   enum rc_proto *protocol, u32 *scancode)
 {
 	unsigned char b;
 
@@ -101,13 +102,13 @@ static int em28xx_get_key_terratec(struct i2c_client *i2c_dev,
 		/* keep old data */
 		return 1;
 
-	*protocol = RC_TYPE_UNKNOWN;
+	*protocol = RC_PROTO_UNKNOWN;
 	*scancode = b;
 	return 1;
 }
 
 static int em28xx_get_key_em_haup(struct i2c_client *i2c_dev,
-				  enum rc_type *protocol, u32 *scancode)
+				  enum rc_proto *protocol, u32 *scancode)
 {
 	unsigned char buf[2];
 	int size;
@@ -131,13 +132,14 @@ static int em28xx_get_key_em_haup(struct i2c_client *i2c_dev,
 	 * So, the code translation is not complete. Yet, it is enough to
 	 * work with the provided RC5 IR.
 	 */
-	*protocol = RC_TYPE_RC5;
+	*protocol = RC_PROTO_RC5;
 	*scancode = (bitrev8(buf[1]) & 0x1f) << 8 | bitrev8(buf[0]) >> 2;
 	return 1;
 }
 
 static int em28xx_get_key_pinnacle_usb_grey(struct i2c_client *i2c_dev,
-					    enum rc_type *protocol, u32 *scancode)
+					    enum rc_proto *protocol,
+					    u32 *scancode)
 {
 	unsigned char buf[3];
 
@@ -149,13 +151,14 @@ static int em28xx_get_key_pinnacle_usb_grey(struct i2c_client *i2c_dev,
 	if (buf[0] != 0x00)
 		return 0;
 
-	*protocol = RC_TYPE_UNKNOWN;
+	*protocol = RC_PROTO_UNKNOWN;
 	*scancode = buf[2] & 0x3f;
 	return 1;
 }
 
 static int em28xx_get_key_winfast_usbii_deluxe(struct i2c_client *i2c_dev,
-					       enum rc_type *protocol, u32 *scancode)
+					       enum rc_proto *protocol,
+					       u32 *scancode)
 {
 	unsigned char subaddr, keydetect, key;
 
@@ -175,7 +178,7 @@ static int em28xx_get_key_winfast_usbii_deluxe(struct i2c_client *i2c_dev,
 	if (key == 0x00)
 		return 0;
 
-	*protocol = RC_TYPE_UNKNOWN;
+	*protocol = RC_PROTO_UNKNOWN;
 	*scancode = key;
 	return 1;
 }
@@ -207,19 +210,19 @@ static int default_polling_getkey(struct em28xx_IR *ir,
 	poll_result->read_count = (msg[0] & 0x7f);
 
 	/* Remote Control Address/Data (Regs 0x46/0x47) */
-	switch (ir->rc_type) {
-	case RC_BIT_RC5:
-		poll_result->protocol = RC_TYPE_RC5;
+	switch (ir->rc_proto) {
+	case RC_PROTO_BIT_RC5:
+		poll_result->protocol = RC_PROTO_RC5;
 		poll_result->scancode = RC_SCANCODE_RC5(msg[1], msg[2]);
 		break;
 
-	case RC_BIT_NEC:
-		poll_result->protocol = RC_TYPE_NEC;
+	case RC_PROTO_BIT_NEC:
+		poll_result->protocol = RC_PROTO_NEC;
 		poll_result->scancode = RC_SCANCODE_NEC(msg[1], msg[2]);
 		break;
 
 	default:
-		poll_result->protocol = RC_TYPE_UNKNOWN;
+		poll_result->protocol = RC_PROTO_UNKNOWN;
 		poll_result->scancode = msg[1] << 8 | msg[2];
 		break;
 	}
@@ -252,37 +255,37 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 	 * Remote Control Address (Reg 0x52)
 	 * Remote Control Data (Reg 0x53-0x55)
 	 */
-	switch (ir->rc_type) {
-	case RC_BIT_RC5:
-		poll_result->protocol = RC_TYPE_RC5;
+	switch (ir->rc_proto) {
+	case RC_PROTO_BIT_RC5:
+		poll_result->protocol = RC_PROTO_RC5;
 		poll_result->scancode = RC_SCANCODE_RC5(msg[1], msg[2]);
 		break;
 
-	case RC_BIT_NEC:
+	case RC_PROTO_BIT_NEC:
 		poll_result->scancode = msg[1] << 8 | msg[2];
 		if ((msg[3] ^ msg[4]) != 0xff) {	/* 32 bits NEC */
-			poll_result->protocol = RC_TYPE_NEC32;
+			poll_result->protocol = RC_PROTO_NEC32;
 			poll_result->scancode = RC_SCANCODE_NEC32((msg[1] << 24) |
 								  (msg[2] << 16) |
 								  (msg[3] << 8)  |
 								  (msg[4]));
 		} else if ((msg[1] ^ msg[2]) != 0xff) {	/* 24 bits NEC */
-			poll_result->protocol = RC_TYPE_NECX;
+			poll_result->protocol = RC_PROTO_NECX;
 			poll_result->scancode = RC_SCANCODE_NECX(msg[1] << 8 |
 								 msg[2], msg[3]);
 		} else {				/* Normal NEC */
-			poll_result->protocol = RC_TYPE_NEC;
+			poll_result->protocol = RC_PROTO_NEC;
 			poll_result->scancode = RC_SCANCODE_NEC(msg[1], msg[3]);
 		}
 		break;
 
-	case RC_BIT_RC6_0:
-		poll_result->protocol = RC_TYPE_RC6_0;
+	case RC_PROTO_BIT_RC6_0:
+		poll_result->protocol = RC_PROTO_RC6_0;
 		poll_result->scancode = RC_SCANCODE_RC6_0(msg[1], msg[2]);
 		break;
 
 	default:
-		poll_result->protocol = RC_TYPE_UNKNOWN;
+		poll_result->protocol = RC_PROTO_UNKNOWN;
 		poll_result->scancode = (msg[1] << 24) | (msg[2] << 16) |
 					(msg[3] << 8)  | msg[4];
 		break;
@@ -298,7 +301,7 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 static int em28xx_i2c_ir_handle_key(struct em28xx_IR *ir)
 {
 	static u32 scancode;
-	enum rc_type protocol;
+	enum rc_proto protocol;
 	int rc;
 
 	rc = ir->get_key_i2c(ir->i2c_client, &protocol, &scancode);
@@ -338,7 +341,7 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 				   poll_result.toggle_bit);
 		else
 			rc_keydown(ir->rc,
-				   RC_TYPE_UNKNOWN,
+				   RC_PROTO_UNKNOWN,
 				   poll_result.scancode & 0xff,
 				   poll_result.toggle_bit);
 
@@ -383,70 +386,71 @@ static void em28xx_ir_stop(struct rc_dev *rc)
 	cancel_delayed_work_sync(&ir->work);
 }
 
-static int em2860_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
+static int em2860_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_proto)
 {
 	struct em28xx_IR *ir = rc_dev->priv;
 	struct em28xx *dev = ir->dev;
 
 	/* Adjust xclk based on IR table for RC5/NEC tables */
-	if (*rc_type & RC_BIT_RC5) {
+	if (*rc_proto & RC_PROTO_BIT_RC5) {
 		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
 		ir->full_code = 1;
-		*rc_type = RC_BIT_RC5;
-	} else if (*rc_type & RC_BIT_NEC) {
+		*rc_proto = RC_PROTO_BIT_RC5;
+	} else if (*rc_proto & RC_PROTO_BIT_NEC) {
 		dev->board.xclk &= ~EM28XX_XCLK_IR_RC5_MODE;
 		ir->full_code = 1;
-		*rc_type = RC_BIT_NEC;
-	} else if (*rc_type & RC_BIT_UNKNOWN) {
-		*rc_type = RC_BIT_UNKNOWN;
+		*rc_proto = RC_PROTO_BIT_NEC;
+	} else if (*rc_proto & RC_PROTO_BIT_UNKNOWN) {
+		*rc_proto = RC_PROTO_BIT_UNKNOWN;
 	} else {
-		*rc_type = ir->rc_type;
+		*rc_proto = ir->rc_proto;
 		return -EINVAL;
 	}
 	em28xx_write_reg_bits(dev, EM28XX_R0F_XCLK, dev->board.xclk,
 			      EM28XX_XCLK_IR_RC5_MODE);
 
-	ir->rc_type = *rc_type;
+	ir->rc_proto = *rc_proto;
 
 	return 0;
 }
 
-static int em2874_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
+static int em2874_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_proto)
 {
 	struct em28xx_IR *ir = rc_dev->priv;
 	struct em28xx *dev = ir->dev;
 	u8 ir_config = EM2874_IR_RC5;
 
 	/* Adjust xclk and set type based on IR table for RC5/NEC/RC6 tables */
-	if (*rc_type & RC_BIT_RC5) {
+	if (*rc_proto & RC_PROTO_BIT_RC5) {
 		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
 		ir->full_code = 1;
-		*rc_type = RC_BIT_RC5;
-	} else if (*rc_type & RC_BIT_NEC) {
+		*rc_proto = RC_PROTO_BIT_RC5;
+	} else if (*rc_proto & RC_PROTO_BIT_NEC) {
 		dev->board.xclk &= ~EM28XX_XCLK_IR_RC5_MODE;
 		ir_config = EM2874_IR_NEC | EM2874_IR_NEC_NO_PARITY;
 		ir->full_code = 1;
-		*rc_type = RC_BIT_NEC;
-	} else if (*rc_type & RC_BIT_RC6_0) {
+		*rc_proto = RC_PROTO_BIT_NEC;
+	} else if (*rc_proto & RC_PROTO_BIT_RC6_0) {
 		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
 		ir_config = EM2874_IR_RC6_MODE_0;
 		ir->full_code = 1;
-		*rc_type = RC_BIT_RC6_0;
-	} else if (*rc_type & RC_BIT_UNKNOWN) {
-		*rc_type = RC_BIT_UNKNOWN;
+		*rc_proto = RC_PROTO_BIT_RC6_0;
+	} else if (*rc_proto & RC_PROTO_BIT_UNKNOWN) {
+		*rc_proto = RC_PROTO_BIT_UNKNOWN;
 	} else {
-		*rc_type = ir->rc_type;
+		*rc_proto = ir->rc_proto;
 		return -EINVAL;
 	}
 	em28xx_write_regs(dev, EM2874_R50_IR_CONFIG, &ir_config, 1);
 	em28xx_write_reg_bits(dev, EM28XX_R0F_XCLK, dev->board.xclk,
 			      EM28XX_XCLK_IR_RC5_MODE);
 
-	ir->rc_type = *rc_type;
+	ir->rc_proto = *rc_proto;
 
 	return 0;
 }
-static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
+
+static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_proto)
 {
 	struct em28xx_IR *ir = rc_dev->priv;
 	struct em28xx *dev = ir->dev;
@@ -455,12 +459,12 @@ static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
 	switch (dev->chip_id) {
 	case CHIP_ID_EM2860:
 	case CHIP_ID_EM2883:
-		return em2860_ir_change_protocol(rc_dev, rc_type);
+		return em2860_ir_change_protocol(rc_dev, rc_proto);
 	case CHIP_ID_EM2884:
 	case CHIP_ID_EM2874:
 	case CHIP_ID_EM28174:
 	case CHIP_ID_EM28178:
-		return em2874_ir_change_protocol(rc_dev, rc_type);
+		return em2874_ir_change_protocol(rc_dev, rc_proto);
 	default:
 		dev_err(&ir->dev->intf->dev,
 			"Unrecognized em28xx chip id 0x%02x: IR not supported\n",
@@ -686,7 +690,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 	struct em28xx_IR *ir;
 	struct rc_dev *rc;
 	int err = -ENOMEM;
-	u64 rc_type;
+	u64 rc_proto;
 	u16 i2c_rc_dev_addr = 0;
 
 	if (dev->is_audio_only) {
@@ -749,7 +753,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 		case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:
 			rc->map_name = RC_MAP_HAUPPAUGE;
 			ir->get_key_i2c = em28xx_get_key_em_haup;
-			rc->allowed_protocols = RC_BIT_RC5;
+			rc->allowed_protocols = RC_PROTO_BIT_RC5;
 			break;
 		case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
 			rc->map_name = RC_MAP_WINFAST_USBII_DELUXE;
@@ -771,7 +775,8 @@ static int em28xx_ir_init(struct em28xx *dev)
 		switch (dev->chip_id) {
 		case CHIP_ID_EM2860:
 		case CHIP_ID_EM2883:
-			rc->allowed_protocols = RC_BIT_RC5 | RC_BIT_NEC;
+			rc->allowed_protocols = RC_PROTO_BIT_RC5 |
+						RC_PROTO_BIT_NEC;
 			ir->get_key = default_polling_getkey;
 			break;
 		case CHIP_ID_EM2884:
@@ -779,8 +784,9 @@ static int em28xx_ir_init(struct em28xx *dev)
 		case CHIP_ID_EM28174:
 		case CHIP_ID_EM28178:
 			ir->get_key = em2874_polling_getkey;
-			rc->allowed_protocols = RC_BIT_RC5 | RC_BIT_NEC |
-				RC_BIT_NECX | RC_BIT_NEC32 | RC_BIT_RC6_0;
+			rc->allowed_protocols = RC_PROTO_BIT_RC5 |
+				RC_PROTO_BIT_NEC | RC_PROTO_BIT_NECX |
+				RC_PROTO_BIT_NEC32 | RC_PROTO_BIT_RC6_0;
 			break;
 		default:
 			err = -ENODEV;
@@ -791,8 +797,8 @@ static int em28xx_ir_init(struct em28xx *dev)
 		rc->map_name = dev->board.ir_codes;
 
 		/* By default, keep protocol field untouched */
-		rc_type = RC_BIT_UNKNOWN;
-		err = em28xx_ir_change_protocol(rc, &rc_type);
+		rc_proto = RC_PROTO_BIT_UNKNOWN;
+		err = em28xx_ir_change_protocol(rc, &rc_proto);
 		if (err)
 			goto error;
 	}
diff --git a/drivers/media/usb/hdpvr/hdpvr-i2c.c b/drivers/media/usb/hdpvr/hdpvr-i2c.c
index fcab55038d99..b9074b978ae3 100644
--- a/drivers/media/usb/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/usb/hdpvr/hdpvr-i2c.c
@@ -55,7 +55,8 @@ struct i2c_client *hdpvr_register_ir_rx_i2c(struct hdpvr_device *dev)
 	/* Our default information for ir-kbd-i2c.c to use */
 	init_data->ir_codes = RC_MAP_HAUPPAUGE;
 	init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-	init_data->type = RC_BIT_RC5 | RC_BIT_RC6_MCE | RC_BIT_RC6_6A_32;
+	init_data->type = RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC6_MCE |
+			  RC_PROTO_BIT_RC6_6A_32;
 	init_data->name = "HD-PVR";
 	init_data->polling_interval = 405; /* ms, duplicated from Windows */
 	hdpvr_ir_rx_i2c_board_info.platform_data = init_data;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
index 20a52b785fff..e3c8f9414e45 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
@@ -567,7 +567,7 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
 	case PVR2_IR_SCHEME_29XXX: /* Original 29xxx device */
 		init_data->ir_codes              = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
-		init_data->type                  = RC_BIT_RC5;
+		init_data->type                  = RC_PROTO_BIT_RC5;
 		init_data->name                  = hdw->hdw_desc->description;
 		init_data->polling_interval      = 100; /* ms From ir-kbd-i2c */
 		/* IR Receiver */
@@ -580,11 +580,11 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
 		break;
 	case PVR2_IR_SCHEME_ZILOG:     /* HVR-1950 style */
 	case PVR2_IR_SCHEME_24XXX_MCE: /* 24xxx MCE device */
-		init_data->ir_codes              = RC_MAP_HAUPPAUGE;
+		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type                  = RC_BIT_RC5 | RC_BIT_RC6_MCE |
-							RC_BIT_RC6_6A_32;
-		init_data->name                  = hdw->hdw_desc->description;
+		init_data->type = RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC6_MCE |
+							RC_PROTO_BIT_RC6_6A_32;
+		init_data->name = hdw->hdw_desc->description;
 		/* IR Receiver */
 		info.addr          = 0x71;
 		info.platform_data = init_data;
diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
index 83e33aef0105..91889ad9cdd7 100644
--- a/drivers/media/usb/tm6000/tm6000-input.c
+++ b/drivers/media/usb/tm6000/tm6000-input.c
@@ -66,7 +66,7 @@ struct tm6000_IR {
 	struct urb		*int_urb;
 
 	/* IR device properties */
-	u64			rc_type;
+	u64			rc_proto;
 };
 
 void tm6000_ir_wait(struct tm6000_core *dev, u8 state)
@@ -103,13 +103,13 @@ static int tm6000_ir_config(struct tm6000_IR *ir)
 	 * IR, in order to discard such decoding
 	 */
 
-	switch (ir->rc_type) {
-	case RC_BIT_NEC:
+	switch (ir->rc_proto) {
+	case RC_PROTO_BIT_NEC:
 		leader = 900;	/* ms */
 		pulse  = 700;	/* ms - the actual value would be 562 */
 		break;
 	default:
-	case RC_BIT_RC5:
+	case RC_PROTO_BIT_RC5:
 		leader = 900;	/* ms - from the NEC decoding */
 		pulse  = 1780;	/* ms - The actual value would be 1776 */
 		break;
@@ -117,12 +117,12 @@ static int tm6000_ir_config(struct tm6000_IR *ir)
 
 	pulse = ir_clock_mhz * pulse;
 	leader = ir_clock_mhz * leader;
-	if (ir->rc_type == RC_BIT_NEC)
+	if (ir->rc_proto == RC_PROTO_BIT_NEC)
 		leader = leader | 0x8000;
 
 	dprintk(2, "%s: %s, %d MHz, leader = 0x%04x, pulse = 0x%06x \n",
 		__func__,
-		(ir->rc_type == RC_BIT_NEC) ? "NEC" : "RC-5",
+		(ir->rc_proto == RC_PROTO_BIT_NEC) ? "NEC" : "RC-5",
 		ir_clock_mhz, leader, pulse);
 
 	/* Remote WAKEUP = enable, normal mode, from IR decoder output */
@@ -162,24 +162,24 @@ static void tm6000_ir_keydown(struct tm6000_IR *ir,
 {
 	u8 device, command;
 	u32 scancode;
-	enum rc_type protocol;
+	enum rc_proto protocol;
 
 	if (len < 1)
 		return;
 
 	command = buf[0];
 	device = (len > 1 ? buf[1] : 0x0);
-	switch (ir->rc_type) {
-	case RC_BIT_RC5:
-		protocol = RC_TYPE_RC5;
+	switch (ir->rc_proto) {
+	case RC_PROTO_BIT_RC5:
+		protocol = RC_PROTO_RC5;
 		scancode = RC_SCANCODE_RC5(device, command);
 		break;
-	case RC_BIT_NEC:
-		protocol = RC_TYPE_NEC;
+	case RC_PROTO_BIT_NEC:
+		protocol = RC_PROTO_NEC;
 		scancode = RC_SCANCODE_NEC(device, command);
 		break;
 	default:
-		protocol = RC_TYPE_OTHER;
+		protocol = RC_PROTO_OTHER;
 		scancode = RC_SCANCODE_OTHER(device << 8 | command);
 		break;
 	}
@@ -311,7 +311,7 @@ static void tm6000_ir_stop(struct rc_dev *rc)
 	cancel_delayed_work_sync(&ir->work);
 }
 
-static int tm6000_ir_change_protocol(struct rc_dev *rc, u64 *rc_type)
+static int tm6000_ir_change_protocol(struct rc_dev *rc, u64 *rc_proto)
 {
 	struct tm6000_IR *ir = rc->priv;
 
@@ -320,7 +320,7 @@ static int tm6000_ir_change_protocol(struct rc_dev *rc, u64 *rc_type)
 
 	dprintk(2, "%s\n",__func__);
 
-	ir->rc_type = *rc_type;
+	ir->rc_proto = *rc_proto;
 
 	tm6000_ir_config(ir);
 	/* TODO */
@@ -409,7 +409,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	struct tm6000_IR *ir;
 	struct rc_dev *rc;
 	int err = -ENOMEM;
-	u64 rc_type;
+	u64 rc_proto;
 
 	if (!enable_ir)
 		return -ENODEV;
@@ -433,7 +433,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	ir->rc = rc;
 
 	/* input setup */
-	rc->allowed_protocols = RC_BIT_RC5 | RC_BIT_NEC;
+	rc->allowed_protocols = RC_PROTO_BIT_RC5 | RC_PROTO_BIT_NEC;
 	/* Needed, in order to support NEC remotes with 24 or 32 bits */
 	rc->scancode_mask = 0xffff;
 	rc->priv = ir;
@@ -455,8 +455,8 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 
-	rc_type = RC_BIT_UNKNOWN;
-	tm6000_ir_change_protocol(rc, &rc_type);
+	rc_proto = RC_PROTO_BIT_UNKNOWN;
+	tm6000_ir_change_protocol(rc, &rc_proto);
 
 	rc->device_name = ir->name;
 	rc->input_phys = ir->phys;
diff --git a/include/media/i2c/ir-kbd-i2c.h b/include/media/i2c/ir-kbd-i2c.h
index d8564354debb..ac8c55617a79 100644
--- a/include/media/i2c/ir-kbd-i2c.h
+++ b/include/media/i2c/ir-kbd-i2c.h
@@ -20,7 +20,8 @@ struct IR_i2c {
 	struct delayed_work    work;
 	char                   name[32];
 	char                   phys[32];
-	int                    (*get_key)(struct IR_i2c *ir, enum rc_type *protocol,
+	int                    (*get_key)(struct IR_i2c *ir,
+					  enum rc_proto *protocol,
 					  u32 *scancode, u8 *toggle);
 };
 
@@ -38,14 +39,15 @@ enum ir_kbd_get_key_fn {
 struct IR_i2c_init_data {
 	char			*ir_codes;
 	const char		*name;
-	u64			type; /* RC_BIT_RC5, etc */
+	u64			type; /* RC_PROTO_BIT_RC5, etc */
 	u32			polling_interval; /* 0 means DEFAULT_POLLING_INTERVAL */
 
 	/*
 	 * Specify either a function pointer or a value indicating one of
 	 * ir_kbd_i2c's internal get_key functions
 	 */
-	int                    (*get_key)(struct IR_i2c *ir, enum rc_type *protocol,
+	int                    (*get_key)(struct IR_i2c *ir,
+					  enum rc_proto *protocol,
 					  u32 *scancode, u8 *toggle);
 	enum ir_kbd_get_key_fn internal_get_key_func;
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 5be527ff851d..314a1edb6189 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -87,11 +87,12 @@ enum rc_filter_type {
  * @idle: used to keep track of RX state
  * @encode_wakeup: wakeup filtering uses IR encode API, therefore the allowed
  *	wakeup protocols is the set of all raw encoders
- * @allowed_protocols: bitmask with the supported RC_BIT_* protocols
- * @enabled_protocols: bitmask with the enabled RC_BIT_* protocols
- * @allowed_wakeup_protocols: bitmask with the supported RC_BIT_* wakeup protocols
- * @wakeup_protocol: the enabled RC_TYPE_* wakeup protocol or
- *	RC_TYPE_UNKNOWN if disabled.
+ * @allowed_protocols: bitmask with the supported RC_PROTO_BIT_* protocols
+ * @enabled_protocols: bitmask with the enabled RC_PROTO_BIT_* protocols
+ * @allowed_wakeup_protocols: bitmask with the supported RC_PROTO_BIT_* wakeup
+ *	protocols
+ * @wakeup_protocol: the enabled RC_PROTO_* wakeup protocol or
+ *	RC_PROTO_UNKNOWN if disabled.
  * @scancode_filter: scancode filter
  * @scancode_wakeup_filter: scancode wakeup filters
  * @scancode_mask: some hardware decoders are not capable of providing the full
@@ -154,7 +155,7 @@ struct rc_dev {
 	u64				allowed_protocols;
 	u64				enabled_protocols;
 	u64				allowed_wakeup_protocols;
-	enum rc_type			wakeup_protocol;
+	enum rc_proto			wakeup_protocol;
 	struct rc_scancode_filter	scancode_filter;
 	struct rc_scancode_filter	scancode_wakeup_filter;
 	u32				scancode_mask;
@@ -165,7 +166,7 @@ struct rc_dev {
 	unsigned long			keyup_jiffies;
 	struct timer_list		timer_keyup;
 	u32				last_keycode;
-	enum rc_type			last_protocol;
+	enum rc_proto			last_protocol;
 	u32				last_scancode;
 	u8				last_toggle;
 	u32				timeout;
@@ -173,7 +174,7 @@ struct rc_dev {
 	u32				max_timeout;
 	u32				rx_resolution;
 	u32				tx_resolution;
-	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_type);
+	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_proto);
 	int				(*open)(struct rc_dev *dev);
 	void				(*close)(struct rc_dev *dev);
 	int				(*s_tx_mask)(struct rc_dev *dev, u32 mask);
@@ -262,8 +263,10 @@ int rc_open(struct rc_dev *rdev);
 void rc_close(struct rc_dev *rdev);
 
 void rc_repeat(struct rc_dev *dev);
-void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle);
-void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle);
+void rc_keydown(struct rc_dev *dev, enum rc_proto protocol, u32 scancode,
+		u8 toggle);
+void rc_keydown_notimeout(struct rc_dev *dev, enum rc_proto protocol,
+			  u32 scancode, u8 toggle);
 void rc_keyup(struct rc_dev *dev);
 u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode);
 
@@ -304,7 +307,7 @@ int ir_raw_event_store_edge(struct rc_dev *dev, bool pulse);
 int ir_raw_event_store_with_filter(struct rc_dev *dev,
 				struct ir_raw_event *ev);
 void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
-int ir_raw_encode_scancode(enum rc_type protocol, u32 scancode,
+int ir_raw_encode_scancode(enum rc_proto protocol, u32 scancode,
 			   struct ir_raw_event *events, unsigned int max);
 
 static inline void ir_raw_event_reset(struct rc_dev *dev)
@@ -335,7 +338,7 @@ static inline u32 ir_extract_bits(u32 data, u32 mask)
 /* Get NEC scancode and protocol type from address and command bytes */
 static inline u32 ir_nec_bytes_to_scancode(u8 address, u8 not_address,
 					   u8 command, u8 not_command,
-					   enum rc_type *protocol)
+					   enum rc_proto *protocol)
 {
 	u32 scancode;
 
@@ -347,17 +350,17 @@ static inline u32 ir_nec_bytes_to_scancode(u8 address, u8 not_address,
 			address     << 16 |
 			not_command <<  8 |
 			command;
-		*protocol = RC_TYPE_NEC32;
+		*protocol = RC_PROTO_NEC32;
 	} else if ((address ^ not_address) != 0xff) {
 		/* Extended NEC */
 		scancode = address     << 16 |
 			   not_address <<  8 |
 			   command;
-		*protocol = RC_TYPE_NECX;
+		*protocol = RC_PROTO_NECX;
 	} else {
 		/* Normal NEC */
 		scancode = address << 8 | command;
-		*protocol = RC_TYPE_NEC;
+		*protocol = RC_PROTO_NEC;
 	}
 
 	return scancode;
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index c69482852f29..2a160e6e823c 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -12,113 +12,122 @@
 #include <linux/input.h>
 
 /**
- * enum rc_type - type of the Remote Controller protocol
+ * enum rc_proto - the Remote Controller protocol
  *
- * @RC_TYPE_UNKNOWN: Protocol not known
- * @RC_TYPE_OTHER: Protocol known but proprietary
- * @RC_TYPE_RC5: Philips RC5 protocol
- * @RC_TYPE_RC5X_20: Philips RC5x 20 bit protocol
- * @RC_TYPE_RC5_SZ: StreamZap variant of RC5
- * @RC_TYPE_JVC: JVC protocol
- * @RC_TYPE_SONY12: Sony 12 bit protocol
- * @RC_TYPE_SONY15: Sony 15 bit protocol
- * @RC_TYPE_SONY20: Sony 20 bit protocol
- * @RC_TYPE_NEC: NEC protocol
- * @RC_TYPE_NECX: Extended NEC protocol
- * @RC_TYPE_NEC32: NEC 32 bit protocol
- * @RC_TYPE_SANYO: Sanyo protocol
- * @RC_TYPE_MCIR2_KBD: RC6-ish MCE keyboard
- * @RC_TYPE_MCIR2_MSE: RC6-ish MCE mouse
- * @RC_TYPE_RC6_0: Philips RC6-0-16 protocol
- * @RC_TYPE_RC6_6A_20: Philips RC6-6A-20 protocol
- * @RC_TYPE_RC6_6A_24: Philips RC6-6A-24 protocol
- * @RC_TYPE_RC6_6A_32: Philips RC6-6A-32 protocol
- * @RC_TYPE_RC6_MCE: MCE (Philips RC6-6A-32 subtype) protocol
- * @RC_TYPE_SHARP: Sharp protocol
- * @RC_TYPE_XMP: XMP protocol
- * @RC_TYPE_CEC: CEC protocol
+ * @RC_PROTO_UNKNOWN: Protocol not known
+ * @RC_PROTO_OTHER: Protocol known but proprietary
+ * @RC_PROTO_RC5: Philips RC5 protocol
+ * @RC_PROTO_RC5X_20: Philips RC5x 20 bit protocol
+ * @RC_PROTO_RC5_SZ: StreamZap variant of RC5
+ * @RC_PROTO_JVC: JVC protocol
+ * @RC_PROTO_SONY12: Sony 12 bit protocol
+ * @RC_PROTO_SONY15: Sony 15 bit protocol
+ * @RC_PROTO_SONY20: Sony 20 bit protocol
+ * @RC_PROTO_NEC: NEC protocol
+ * @RC_PROTO_NECX: Extended NEC protocol
+ * @RC_PROTO_NEC32: NEC 32 bit protocol
+ * @RC_PROTO_SANYO: Sanyo protocol
+ * @RC_PROTO_MCIR2_KBD: RC6-ish MCE keyboard
+ * @RC_PROTO_MCIR2_MSE: RC6-ish MCE mouse
+ * @RC_PROTO_RC6_0: Philips RC6-0-16 protocol
+ * @RC_PROTO_RC6_6A_20: Philips RC6-6A-20 protocol
+ * @RC_PROTO_RC6_6A_24: Philips RC6-6A-24 protocol
+ * @RC_PROTO_RC6_6A_32: Philips RC6-6A-32 protocol
+ * @RC_PROTO_RC6_MCE: MCE (Philips RC6-6A-32 subtype) protocol
+ * @RC_PROTO_SHARP: Sharp protocol
+ * @RC_PROTO_XMP: XMP protocol
+ * @RC_PROTO_CEC: CEC protocol
  */
-enum rc_type {
-	RC_TYPE_UNKNOWN		= 0,
-	RC_TYPE_OTHER		= 1,
-	RC_TYPE_RC5		= 2,
-	RC_TYPE_RC5X_20		= 3,
-	RC_TYPE_RC5_SZ		= 4,
-	RC_TYPE_JVC		= 5,
-	RC_TYPE_SONY12		= 6,
-	RC_TYPE_SONY15		= 7,
-	RC_TYPE_SONY20		= 8,
-	RC_TYPE_NEC		= 9,
-	RC_TYPE_NECX		= 10,
-	RC_TYPE_NEC32		= 11,
-	RC_TYPE_SANYO		= 12,
-	RC_TYPE_MCIR2_KBD	= 13,
-	RC_TYPE_MCIR2_MSE	= 14,
-	RC_TYPE_RC6_0		= 15,
-	RC_TYPE_RC6_6A_20	= 16,
-	RC_TYPE_RC6_6A_24	= 17,
-	RC_TYPE_RC6_6A_32	= 18,
-	RC_TYPE_RC6_MCE		= 19,
-	RC_TYPE_SHARP		= 20,
-	RC_TYPE_XMP		= 21,
-	RC_TYPE_CEC		= 22,
+enum rc_proto {
+	RC_PROTO_UNKNOWN	= 0,
+	RC_PROTO_OTHER		= 1,
+	RC_PROTO_RC5		= 2,
+	RC_PROTO_RC5X_20	= 3,
+	RC_PROTO_RC5_SZ		= 4,
+	RC_PROTO_JVC		= 5,
+	RC_PROTO_SONY12		= 6,
+	RC_PROTO_SONY15		= 7,
+	RC_PROTO_SONY20		= 8,
+	RC_PROTO_NEC		= 9,
+	RC_PROTO_NECX		= 10,
+	RC_PROTO_NEC32		= 11,
+	RC_PROTO_SANYO		= 12,
+	RC_PROTO_MCIR2_KBD	= 13,
+	RC_PROTO_MCIR2_MSE	= 14,
+	RC_PROTO_RC6_0		= 15,
+	RC_PROTO_RC6_6A_20	= 16,
+	RC_PROTO_RC6_6A_24	= 17,
+	RC_PROTO_RC6_6A_32	= 18,
+	RC_PROTO_RC6_MCE	= 19,
+	RC_PROTO_SHARP		= 20,
+	RC_PROTO_XMP		= 21,
+	RC_PROTO_CEC		= 22,
 };
 
-#define RC_BIT_NONE		0ULL
-#define RC_BIT_UNKNOWN		BIT_ULL(RC_TYPE_UNKNOWN)
-#define RC_BIT_OTHER		BIT_ULL(RC_TYPE_OTHER)
-#define RC_BIT_RC5		BIT_ULL(RC_TYPE_RC5)
-#define RC_BIT_RC5X_20		BIT_ULL(RC_TYPE_RC5X_20)
-#define RC_BIT_RC5_SZ		BIT_ULL(RC_TYPE_RC5_SZ)
-#define RC_BIT_JVC		BIT_ULL(RC_TYPE_JVC)
-#define RC_BIT_SONY12		BIT_ULL(RC_TYPE_SONY12)
-#define RC_BIT_SONY15		BIT_ULL(RC_TYPE_SONY15)
-#define RC_BIT_SONY20		BIT_ULL(RC_TYPE_SONY20)
-#define RC_BIT_NEC		BIT_ULL(RC_TYPE_NEC)
-#define RC_BIT_NECX		BIT_ULL(RC_TYPE_NECX)
-#define RC_BIT_NEC32		BIT_ULL(RC_TYPE_NEC32)
-#define RC_BIT_SANYO		BIT_ULL(RC_TYPE_SANYO)
-#define RC_BIT_MCIR2_KBD	BIT_ULL(RC_TYPE_MCIR2_KBD)
-#define RC_BIT_MCIR2_MSE	BIT_ULL(RC_TYPE_MCIR2_MSE)
-#define RC_BIT_RC6_0		BIT_ULL(RC_TYPE_RC6_0)
-#define RC_BIT_RC6_6A_20	BIT_ULL(RC_TYPE_RC6_6A_20)
-#define RC_BIT_RC6_6A_24	BIT_ULL(RC_TYPE_RC6_6A_24)
-#define RC_BIT_RC6_6A_32	BIT_ULL(RC_TYPE_RC6_6A_32)
-#define RC_BIT_RC6_MCE		BIT_ULL(RC_TYPE_RC6_MCE)
-#define RC_BIT_SHARP		BIT_ULL(RC_TYPE_SHARP)
-#define RC_BIT_XMP		BIT_ULL(RC_TYPE_XMP)
-#define RC_BIT_CEC		BIT_ULL(RC_TYPE_CEC)
+#define RC_PROTO_BIT_NONE		0ULL
+#define RC_PROTO_BIT_UNKNOWN		BIT_ULL(RC_PROTO_UNKNOWN)
+#define RC_PROTO_BIT_OTHER		BIT_ULL(RC_PROTO_OTHER)
+#define RC_PROTO_BIT_RC5		BIT_ULL(RC_PROTO_RC5)
+#define RC_PROTO_BIT_RC5X_20		BIT_ULL(RC_PROTO_RC5X_20)
+#define RC_PROTO_BIT_RC5_SZ		BIT_ULL(RC_PROTO_RC5_SZ)
+#define RC_PROTO_BIT_JVC		BIT_ULL(RC_PROTO_JVC)
+#define RC_PROTO_BIT_SONY12		BIT_ULL(RC_PROTO_SONY12)
+#define RC_PROTO_BIT_SONY15		BIT_ULL(RC_PROTO_SONY15)
+#define RC_PROTO_BIT_SONY20		BIT_ULL(RC_PROTO_SONY20)
+#define RC_PROTO_BIT_NEC		BIT_ULL(RC_PROTO_NEC)
+#define RC_PROTO_BIT_NECX		BIT_ULL(RC_PROTO_NECX)
+#define RC_PROTO_BIT_NEC32		BIT_ULL(RC_PROTO_NEC32)
+#define RC_PROTO_BIT_SANYO		BIT_ULL(RC_PROTO_SANYO)
+#define RC_PROTO_BIT_MCIR2_KBD		BIT_ULL(RC_PROTO_MCIR2_KBD)
+#define RC_PROTO_BIT_MCIR2_MSE		BIT_ULL(RC_PROTO_MCIR2_MSE)
+#define RC_PROTO_BIT_RC6_0		BIT_ULL(RC_PROTO_RC6_0)
+#define RC_PROTO_BIT_RC6_6A_20		BIT_ULL(RC_PROTO_RC6_6A_20)
+#define RC_PROTO_BIT_RC6_6A_24		BIT_ULL(RC_PROTO_RC6_6A_24)
+#define RC_PROTO_BIT_RC6_6A_32		BIT_ULL(RC_PROTO_RC6_6A_32)
+#define RC_PROTO_BIT_RC6_MCE		BIT_ULL(RC_PROTO_RC6_MCE)
+#define RC_PROTO_BIT_SHARP		BIT_ULL(RC_PROTO_SHARP)
+#define RC_PROTO_BIT_XMP		BIT_ULL(RC_PROTO_XMP)
+#define RC_PROTO_BIT_CEC		BIT_ULL(RC_PROTO_CEC)
 
-#define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | \
-			 RC_BIT_RC5 | RC_BIT_RC5X_20 | RC_BIT_RC5_SZ | \
-			 RC_BIT_JVC | \
-			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
-			 RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 | \
-			 RC_BIT_SANYO | \
-			 RC_BIT_MCIR2_KBD | RC_BIT_MCIR2_MSE | \
-			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
-			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP | \
-			 RC_BIT_XMP | RC_BIT_CEC)
+#define RC_PROTO_BIT_ALL \
+			(RC_PROTO_BIT_UNKNOWN | RC_PROTO_BIT_OTHER | \
+			 RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC5X_20 | \
+			 RC_PROTO_BIT_RC5_SZ | RC_PROTO_BIT_JVC | \
+			 RC_PROTO_BIT_SONY12 | RC_PROTO_BIT_SONY15 | \
+			 RC_PROTO_BIT_SONY20 | RC_PROTO_BIT_NEC | \
+			 RC_PROTO_BIT_NECX | RC_PROTO_BIT_NEC32 | \
+			 RC_PROTO_BIT_SANYO | \
+			 RC_PROTO_BIT_MCIR2_KBD | RC_PROTO_BIT_MCIR2_MSE | \
+			 RC_PROTO_BIT_RC6_0 | RC_PROTO_BIT_RC6_6A_20 | \
+			 RC_PROTO_BIT_RC6_6A_24 | RC_PROTO_BIT_RC6_6A_32 | \
+			 RC_PROTO_BIT_RC6_MCE | RC_PROTO_BIT_SHARP | \
+			 RC_PROTO_BIT_XMP | RC_PROTO_BIT_CEC)
 /* All rc protocols for which we have decoders */
-#define RC_BIT_ALL_IR_DECODER \
-			(RC_BIT_RC5 | RC_BIT_RC5X_20 | RC_BIT_RC5_SZ | \
-			 RC_BIT_JVC | \
-			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
-			 RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 | \
-			 RC_BIT_SANYO | RC_BIT_MCIR2_KBD | RC_BIT_MCIR2_MSE | \
-			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
-			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP | \
-			 RC_BIT_XMP)
+#define RC_PROTO_BIT_ALL_IR_DECODER \
+			(RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC5X_20 | \
+			 RC_PROTO_BIT_RC5_SZ | RC_PROTO_BIT_JVC | \
+			 RC_PROTO_BIT_SONY12 | RC_PROTO_BIT_SONY15 | \
+			 RC_PROTO_BIT_SONY20 | RC_PROTO_BIT_NEC | \
+			 RC_PROTO_BIT_NECX | RC_PROTO_BIT_NEC32 | \
+			 RC_PROTO_BIT_SANYO | RC_PROTO_BIT_MCIR2_KBD | \
+			 RC_PROTO_BIT_MCIR2_MSE | \
+			 RC_PROTO_BIT_RC6_0 | RC_PROTO_BIT_RC6_6A_20 | \
+			 RC_PROTO_BIT_RC6_6A_24 |  RC_PROTO_BIT_RC6_6A_32 | \
+			 RC_PROTO_BIT_RC6_MCE | RC_PROTO_BIT_SHARP | \
+			 RC_PROTO_BIT_XMP)
 
-#define RC_BIT_ALL_IR_ENCODER \
-			(RC_BIT_RC5 | RC_BIT_RC5X_20 | RC_BIT_RC5_SZ | \
-			 RC_BIT_JVC | \
-			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
-			 RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 | \
-			 RC_BIT_SANYO | RC_BIT_MCIR2_KBD | RC_BIT_MCIR2_MSE | \
-			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
-			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | \
-			 RC_BIT_SHARP)
+#define RC_PROTO_BIT_ALL_IR_ENCODER \
+			(RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC5X_20 | \
+			 RC_PROTO_BIT_RC5_SZ | RC_PROTO_BIT_JVC | \
+			 RC_PROTO_BIT_SONY12 | RC_PROTO_BIT_SONY15 | \
+			 RC_PROTO_BIT_SONY20 |  RC_PROTO_BIT_NEC | \
+			 RC_PROTO_BIT_NECX | RC_PROTO_BIT_NEC32 | \
+			 RC_PROTO_BIT_SANYO | RC_PROTO_BIT_MCIR2_KBD | \
+			 RC_PROTO_BIT_MCIR2_MSE | \
+			 RC_PROTO_BIT_RC6_0 | RC_PROTO_BIT_RC6_6A_20 | \
+			 RC_PROTO_BIT_RC6_6A_24 | \
+			 RC_PROTO_BIT_RC6_6A_32 | RC_PROTO_BIT_RC6_MCE | \
+			 RC_PROTO_BIT_SHARP)
 
 #define RC_SCANCODE_UNKNOWN(x)			(x)
 #define RC_SCANCODE_OTHER(x)			(x)
@@ -148,8 +157,8 @@ struct rc_map_table {
  * @size: Max number of entries
  * @len: Number of entries that are in use
  * @alloc: size of \*scan, in bytes
- * @rc_type: type of the remote controller protocol, as defined at
- *	     enum &rc_type
+ * @rc_proto: type of the remote controller protocol, as defined at
+ *	     enum &rc_proto
  * @name: name of the key map table
  * @lock: lock to protect access to this structure
  */
@@ -158,7 +167,7 @@ struct rc_map {
 	unsigned int		size;
 	unsigned int		len;
 	unsigned int		alloc;
-	enum rc_type		rc_type;
+	enum rc_proto		rc_proto;
 	const char		*name;
 	spinlock_t		lock;
 };
-- 
2.13.4
