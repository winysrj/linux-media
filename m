Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaEUUzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 16:55:49 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: "Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] dib0700: fix RC support on Hauppauge Nova-TD
Date: Wed, 21 May 2014 17:55:36 -0300
Message-Id: <1400705736-1816-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RC support o Nova-TD is broken, as the RC endpoint there
is an interrupt endpoint.

That produces an ugly calltrace at the Kernel logs:

	WARNING: CPU: 2 PID: 56 at drivers/usb/core/urb.c:450 usb_submit_urb+0x1fd/0x5c0()
	usb 1-1.2: BOGUS urb xfer, pipe 3 != type 1
	Modules linked in: rc_dib0700_rc5(OF) dvb_usb_dib0700(OF) dib9000(OF) dib8000(OF) dib7000m(OF) dib0090(OF) dib0070(OF) dib7000p(OF) dib3000mc(OF) dibx000_common(OF) dvb_usb(OF) rc_core(OF) snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi snd_seq snd_seq_device snd_pcm snd_timer snd soundcore bnep bluetooth 6lowpan_iphc rfkill au0828(OF) xc5000(OF) au8522_dig(OF) au8522_common(OF) tveeprom(OF) dvb_core(OF) nouveau i915 mxm_wmi ttm i2c_algo_bit drm_kms_helper drm r8169 mii i2c_core video wmi [last unloaded: au0828]
	CPU: 2 PID: 56 Comm: khubd Tainted: GF          O 3.14.2-200.fc20.x86_64 #1
	Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
	 0000000000000000 00000000610866bc ffff880223703860 ffffffff816eec92
	 ffff8802237038a8 ffff880223703898 ffffffff8108a1bd ffff8800916a2180
	 ffff8801d5b16000 0000000000000003 0000000000000003 0000000000000020
	Call Trace:
	 [<ffffffff816eec92>] dump_stack+0x45/0x56
	 [<ffffffff8108a1bd>] warn_slowpath_common+0x7d/0xa0
	 [<ffffffff8108a23c>] warn_slowpath_fmt+0x5c/0x80
	 [<ffffffff814e3ebd>] usb_submit_urb+0x1fd/0x5c0
	 [<ffffffffa0445925>] dib0700_rc_setup+0xb5/0x120 [dvb_usb_dib0700]
	 [<ffffffffa0445a58>] dib0700_probe+0xc8/0x130 [dvb_usb_dib0700]
	...

Fix it by detecting if the endpoint is bulk or interrupt.

Tested with both Hauppauge Nova-TD model 52009 (interrupt) and with a
		 Prolink Pixelview SBTVD model PV-D231U (bulk).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/dvb-usb/dib0700.h         |  2 +-
 drivers/media/usb/dvb-usb/dib0700_core.c    | 41 ++++++++++++++++++++++++-----
 drivers/media/usb/dvb-usb/dib0700_devices.c |  2 +-
 3 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700.h b/drivers/media/usb/dvb-usb/dib0700.h
index 637b6123f391..927617d95616 100644
--- a/drivers/media/usb/dvb-usb/dib0700.h
+++ b/drivers/media/usb/dvb-usb/dib0700.h
@@ -59,7 +59,7 @@ extern int dib0700_set_gpio(struct dvb_usb_device *, enum dib07x0_gpios gpio, u8
 extern int dib0700_ctrl_clock(struct dvb_usb_device *d, u32 clk_MHz, u8 clock_out_gp3);
 extern int dib0700_ctrl_rd(struct dvb_usb_device *d, u8 *tx, u8 txlen, u8 *rx, u8 rxlen);
 extern int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw);
-extern int dib0700_rc_setup(struct dvb_usb_device *d);
+extern int dib0700_rc_setup(struct dvb_usb_device *d, struct usb_interface *intf);
 extern int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff);
 extern struct i2c_algorithm dib0700_i2c_algo;
 extern int dib0700_identify_state(struct usb_device *udev, struct dvb_usb_device_properties *props,
diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index bf2a908d74cf..2797a7fb2d22 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -754,17 +754,20 @@ resubmit:
 	usb_submit_urb(purb, GFP_ATOMIC);
 }
 
-int dib0700_rc_setup(struct dvb_usb_device *d)
+int dib0700_rc_setup(struct dvb_usb_device *d, struct usb_interface *intf)
 {
 	struct dib0700_state *st = d->priv;
 	struct urb *purb;
-	int ret;
+	const struct usb_endpoint_descriptor *e;
+	int ret, rc_ep = 1;
+	unsigned int pipe = 0;
 
 	/* Poll-based. Don't initialize bulk mode */
-	if (st->fw_version < 0x10200)
+	if (st->fw_version < 0x10200 || !intf)
 		return 0;
 
 	/* Starting in firmware 1.20, the RC info is provided on a bulk pipe */
+
 	purb = usb_alloc_urb(0, GFP_KERNEL);
 	if (purb == NULL) {
 		err("rc usb alloc urb failed");
@@ -779,9 +782,33 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
 	}
 
 	purb->status = -EINPROGRESS;
-	usb_fill_bulk_urb(purb, d->udev, usb_rcvbulkpipe(d->udev, 1),
-			  purb->transfer_buffer, RC_MSG_SIZE_V1_20,
-			  dib0700_rc_urb_completion, d);
+
+	/*
+	 * Some devices like the Hauppauge NovaTD model 52009 use an interrupt
+	 * endpoint, while others use a bulk one.
+	 */
+	e = &intf->altsetting[0].endpoint[rc_ep].desc;
+	if (usb_endpoint_dir_in(e)) {
+		if (usb_endpoint_xfer_bulk(e)) {
+			pipe = usb_rcvbulkpipe(d->udev, rc_ep);
+			usb_fill_bulk_urb(purb, d->udev, pipe,
+					  purb->transfer_buffer, RC_MSG_SIZE_V1_20,
+					  dib0700_rc_urb_completion, d);
+
+		} else if (usb_endpoint_xfer_int(e)) {
+			pipe = usb_rcvintpipe(d->udev, rc_ep);
+			usb_fill_int_urb(purb, d->udev, pipe,
+					  purb->transfer_buffer, RC_MSG_SIZE_V1_20,
+					  dib0700_rc_urb_completion, d, 1);
+		}
+	}
+
+	if (!pipe) {
+		err("There's no endpoint for remote controller");
+		kfree(purb->transfer_buffer);
+		usb_free_urb(purb);
+		return 0;
+	}
 
 	ret = usb_submit_urb(purb, GFP_ATOMIC);
 	if (ret) {
@@ -820,7 +847,7 @@ static int dib0700_probe(struct usb_interface *intf,
 			else
 				dev->props.rc.core.bulk_mode = false;
 
-			dib0700_rc_setup(dev);
+			dib0700_rc_setup(dev, intf);
 
 			return 0;
 		}
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 829323e42ca0..10e0db8d1850 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -514,7 +514,7 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 
 	/* info("%d: %2X %2X %2X %2X",dvb_usb_dib0700_ir_proto,(int)key[3-2],(int)key[3-3],(int)key[3-1],(int)key[3]);  */
 
-	dib0700_rc_setup(d); /* reset ir sensor data to prevent false events */
+	dib0700_rc_setup(d, NULL); /* reset ir sensor data to prevent false events */
 
 	d->last_event = 0;
 	switch (d->props.rc.core.protocol) {
-- 
1.9.0

