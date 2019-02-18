Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8237C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54DBB217F5
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550518158;
	bh=L8jL7I6Gcu06IwMK3qEYUawhuM9myOJIEENL1+YXiKY=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=Iu2BO/ibxnplJZBFJI2DntL4DZa7tPPYBuQgiFAIJ/OeNwKayr/4XmyJY4liBchtL
	 GexnwEBfDId3b6wEo64xqVUcJO3dIhg+kNe5hMDIhbuS618gNb7XUtPEY0snukTskl
	 ldbFrU6umtckKGFoW69IQ8+h0gS4VJvYMDYLJrVo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfBRT3R (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:29:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34276 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfBRT3Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 14:29:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=T5Nv6+Wp9qJjFLemyNt6p0KKAck6nff7VivMinGT978=; b=hvVPTxvB7aHlV7RiRsNReWvKda
        DYHzeHeg62ISdHyFcFaYveGVHvrg9JrogetXhYPPsS6kHbyhIIV1MNWCS4Pk+ONI1ZBqy874dwHWv
        QvZjuhJCyzHQyt3zgeubIAb8oSRoFS6khg8OPi4swxTdK+msnx4oEbrMeJi5asWyGYopv0DxkDX8H
        +yQmStOqWwG+j/xCm+SJqmGHhNefdRzQWXqM9Hko+axPX5J/TWS3bwj1/1vV1pGOJU4GeWa9csChO
        heIm7P8bfBxkqvu6sVLI2Ezo9dr6BcOnZ6bTJAffhPH9gkM9aWQwrt4Ua+hOTiWzmAxVH2fOlISsw
        OsvcsA+Q==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvobJ-0002Ur-9i; Mon, 18 Feb 2019 19:29:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvobG-0006g6-DT; Mon, 18 Feb 2019 14:29:10 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Brian Johnson <brijohn@gmail.com>,
        Leandro Costantino <lcostantino@gmail.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine Jacquet <royale@zerezo.com>, linux-usb@vger.kernel.org
Subject: [PATCH 09/14] media: usb: fix several typos
Date:   Mon, 18 Feb 2019 14:29:03 -0500
Message-Id: <5fd53931784e7db034dde7f731931fb1ae484706.1550518128.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
References: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use codespell to fix lots of typos over frontends.

Manually verified to avoid false-positives.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/usb/au0828/au0828-core.c            |  2 +-
 drivers/media/usb/au0828/au0828.h                 |  2 +-
 drivers/media/usb/cx231xx/cx231xx-avcore.c        |  2 +-
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h       |  2 +-
 drivers/media/usb/cx231xx/cx231xx.h               |  2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h            |  2 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c            |  8 ++++----
 drivers/media/usb/dvb-usb-v2/mxl111sf.c           |  4 ++--
 drivers/media/usb/dvb-usb/af9005.c                |  2 +-
 drivers/media/usb/dvb-usb/cinergyT2-fe.c          |  2 +-
 drivers/media/usb/dvb-usb/cxusb.c                 |  2 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c          |  2 +-
 drivers/media/usb/dvb-usb/dvb-usb.h               |  2 +-
 drivers/media/usb/dvb-usb/pctv452e.c              |  4 ++--
 drivers/media/usb/em28xx/em28xx-i2c.c             |  4 ++--
 drivers/media/usb/em28xx/em28xx-reg.h             |  2 +-
 drivers/media/usb/gspca/Kconfig                   |  2 +-
 drivers/media/usb/gspca/autogain_functions.c      |  2 +-
 drivers/media/usb/gspca/benq.c                    |  4 ++--
 drivers/media/usb/gspca/mr97310a.c                | 10 +++++-----
 drivers/media/usb/gspca/ov519.c                   |  4 ++--
 drivers/media/usb/gspca/pac_common.h              |  2 +-
 drivers/media/usb/gspca/sn9c20x.c                 |  2 +-
 drivers/media/usb/gspca/sonixb.c                  |  4 ++--
 drivers/media/usb/gspca/sonixj.c                  |  2 +-
 drivers/media/usb/gspca/spca501.c                 |  2 +-
 drivers/media/usb/gspca/sq905.c                   |  2 +-
 drivers/media/usb/gspca/sunplus.c                 |  4 ++--
 drivers/media/usb/gspca/t613.c                    |  2 +-
 drivers/media/usb/gspca/touptek.c                 |  4 ++--
 drivers/media/usb/gspca/w996Xcf.c                 |  2 +-
 drivers/media/usb/gspca/zc3xx-reg.h               |  2 +-
 drivers/media/usb/gspca/zc3xx.c                   |  8 ++++----
 drivers/media/usb/hdpvr/hdpvr.h                   |  2 +-
 drivers/media/usb/pwc/pwc-dec23.c                 |  4 ++--
 drivers/media/usb/pwc/pwc-if.c                    |  2 +-
 drivers/media/usb/pwc/pwc-misc.c                  |  2 +-
 drivers/media/usb/siano/smsusb.c                  |  2 +-
 drivers/media/usb/stk1160/stk1160-core.c          |  4 ++--
 drivers/media/usb/stk1160/stk1160-reg.h           |  4 ++--
 drivers/media/usb/stkwebcam/stk-webcam.c          |  2 +-
 drivers/media/usb/tm6000/tm6000-alsa.c            |  2 +-
 drivers/media/usb/tm6000/tm6000-core.c            |  4 ++--
 drivers/media/usb/tm6000/tm6000-dvb.c             |  2 +-
 drivers/media/usb/tm6000/tm6000-i2c.c             |  2 +-
 drivers/media/usb/tm6000/tm6000-stds.c            |  2 +-
 drivers/media/usb/tm6000/tm6000-video.c           |  2 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c |  2 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c           |  2 +-
 drivers/media/usb/usbvision/usbvision-core.c      |  8 ++++----
 drivers/media/usb/usbvision/usbvision.h           |  8 ++++----
 drivers/media/usb/uvc/uvc_video.c                 |  2 +-
 drivers/media/usb/zr364xx/zr364xx.c               |  2 +-
 53 files changed, 81 insertions(+), 81 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 1fdb1601dc65..3f8c92a70116 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -234,7 +234,7 @@ static void au0828_media_graph_notify(struct media_entity *new,
 	if (!new) {
 		/*
 		 * Called during au0828 probe time to connect
-		 * entites that were created prior to registering
+		 * entities that were created prior to registering
 		 * the notify handler. Find mixer and decoder.
 		*/
 		media_device_for_each_entity(entity, dev->media_dev) {
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 004eadef55c7..425c35d16057 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -52,7 +52,7 @@
 
 #define AU0828_INTERLACED_DEFAULT       1
 
-/* Defination for AU0828 USB transfer */
+/* Definition for AU0828 USB transfer */
 #define AU0828_MAX_ISO_BUFS    12  /* maybe resize this value in the future */
 #define AU0828_ISO_PACKETS_PER_URB      128
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index fdd3c221fa0d..3374888b3021 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -2987,7 +2987,7 @@ int cx231xx_gpio_i2c_write_ack(struct cx231xx *dev)
 {
 	int status = 0;
 
-	/* set SDA to ouput */
+	/* set SDA to output */
 	dev->gpio_dir |= 1 << dev->board.tuner_sda_gpio;
 	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h
index 8f00b1d38277..bb4f817be0c5 100644
--- a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h
+++ b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h
@@ -86,7 +86,7 @@ enum TS_PORT{
 #define EAVP_MASK       0x8
 enum EAV_PRESENT{
 	NO_EXTERNAL_AV = 0x0,	/* 0: No External A/V inputs
-						(no need for i2s blcok),
+						(no need for i2s block),
 						Analog Tuner must be present */
 	EXTERNAL_AV = 0x8	/* 1: External A/V inputs
 						present (requires i2s blk) */
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index fa640bf20111..86b7f57492b1 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -646,7 +646,7 @@ struct cx231xx {
 	/* frame properties */
 	int width;		/* current frame width */
 	int height;		/* current frame height */
-	int interlaced;		/* 1=interlace fileds, 0=just top fileds */
+	int interlaced;		/* 1=interlace fields, 0=just top fields */
 
 	struct cx231xx_audio adev;
 
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 3fd6cc0d6340..728ef5f3ada2 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -146,7 +146,7 @@ struct dvb_usb_rc {
 };
 
 /**
- * usb streaming configration for adapter
+ * usb streaming configuration for adapter
  * @type: urb type
  * @count: count of used urbs
  * @endpoint: stream usb endpoint number
diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 602013cf3e69..15944b95970f 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -308,7 +308,7 @@ static void lme2510_int_response(struct urb *lme_urb)
 
 		switch (ibuf[0]) {
 		case 0xaa:
-			debug_data_snipet(1, "INT Remote data snipet", ibuf);
+			debug_data_snipet(1, "INT Remote data snippet", ibuf);
 			if (!adap_to_d(adap)->rc_dev)
 				break;
 
@@ -358,13 +358,13 @@ static void lme2510_int_response(struct urb *lme_urb)
 
 			lme2510_update_stats(adap);
 
-			debug_data_snipet(5, "INT Remote data snipet in", ibuf);
+			debug_data_snipet(5, "INT Remote data snippet in", ibuf);
 		break;
 		case 0xcc:
-			debug_data_snipet(1, "INT Control data snipet", ibuf);
+			debug_data_snipet(1, "INT Control data snippet", ibuf);
 			break;
 		default:
-			debug_data_snipet(1, "INT Unknown data snipet", ibuf);
+			debug_data_snipet(1, "INT Unknown data snippet", ibuf);
 		break;
 		}
 	}
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index 85cdf593a9ad..5e2d53af68c7 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -140,7 +140,7 @@ int mxl111sf_write_reg_mask(struct mxl111sf_state *state,
 	if (mask != 0xff) {
 		ret = mxl111sf_read_reg(state, addr, &val);
 #if 1
-		/* dont know why this usually errors out on the first try */
+		/* don't know why this usually errors out on the first try */
 		if (mxl_fail(ret))
 			pr_err("error writing addr: 0x%02x, mask: 0x%02x, data: 0x%02x, retrying...",
 			       addr, mask, data);
@@ -783,7 +783,7 @@ static int mxl111sf_attach_demod(struct dvb_usb_adapter *adap, u8 fe_id)
 	if (mxl_fail(ret))
 		goto fail;
 
-	/* dont care if this fails */
+	/* don't care if this fails */
 	mxl111sf_init_port_expander(state);
 
 	adap->fe[fe_id] = dvb_attach(mxl111sf_demod_attach, state,
diff --git a/drivers/media/usb/dvb-usb/af9005.c b/drivers/media/usb/dvb-usb/af9005.c
index 16e946e01d2c..0638d907c73e 100644
--- a/drivers/media/usb/dvb-usb/af9005.c
+++ b/drivers/media/usb/dvb-usb/af9005.c
@@ -845,7 +845,7 @@ static int af9005_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 
 	/* deb_info("rc_query\n"); */
 	st->data[0] = 3;		/* rest of packet length low */
-	st->data[1] = 0;		/* rest of packet lentgh high */
+	st->data[1] = 0;		/* rest of packet length high */
 	st->data[2] = 0x40;		/* read remote */
 	st->data[3] = 1;		/* rest of packet length */
 	st->data[4] = seq = st->sequence++;	/* sequence number */
diff --git a/drivers/media/usb/dvb-usb/cinergyT2-fe.c b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
index df71df7ed524..4c9f83ba260d 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
@@ -33,7 +33,7 @@
  *  This function is probably reusable and may better get placed in a support
  *  library.
  *
- *  We replace errornous fields by default TPS fields (the ones with value 0).
+ *  We replace erroneous fields by default TPS fields (the ones with value 0).
  */
 
 static uint16_t compute_tps(struct dtv_frontend_properties *op)
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index a51a45c60233..9ddb2000249e 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1016,7 +1016,7 @@ static int cxusb_dualdig4_rev2_tuner_attach(struct dvb_usb_adapter *adap)
 	/*
 	 * No need to call dvb7000p_attach here, as it was called
 	 * already, as frontend_attach method is called first, and
-	 * tuner_attach is only called on sucess.
+	 * tuner_attach is only called on success.
 	 */
 	tun_i2c = st->dib7000p_ops.get_i2c_master(adap->fe_adap[0].fe,
 					DIBX000_I2C_INTERFACE_TUNER, 1);
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
index 40ca4eafb137..99951e02a880 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -98,7 +98,7 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 
 	/*
 	 * when reloading the driver w/o replugging the device
-	 * sometimes a timeout occures, this helps
+	 * sometimes a timeout occurs, this helps
 	 */
 	if (d->props.generic_bulk_ctrl_endpoint != 0) {
 		usb_clear_halt(d->udev, usb_sndbulkpipe(d->udev, d->props.generic_bulk_ctrl_endpoint));
diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
index 317ed6a82d19..32829bdd5f22 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb.h
+++ b/drivers/media/usb/dvb-usb/dvb-usb.h
@@ -336,7 +336,7 @@ struct usb_data_stream {
  * struct dvb_usb_adapter - a DVB adapter on a USB device
  * @id: index of this adapter (starting with 0).
  *
- * @feedcount: number of reqested feeds (used for streaming-activation)
+ * @feedcount: number of requested feeds (used for streaming-activation)
  * @pid_filtering: is hardware pid_filtering used or not.
  *
  * @pll_addr: I2C address of the tuner for programming
diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index 0af74383083d..150081128196 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -528,13 +528,13 @@ static int pctv452e_power_ctrl(struct dvb_usb_device *d, int i)
 
 	rx = b0 + 5;
 
-	/* hmm where shoud this should go? */
+	/* hmm where should this should go? */
 	ret = usb_set_interface(d->udev, 0, ISOC_INTERFACE_ALTERNATIVE);
 	if (ret != 0)
 		info("%s: Warning set interface returned: %d\n",
 			__func__, ret);
 
-	/* this is a one-time initialization, dont know where to put */
+	/* this is a one-time initialization, don't know where to put */
 	b0[0] = 0xaa;
 	b0[1] = state->c++;
 	b0[2] = PCTV_CMD_RESET;
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 02c13d71e6c1..a3155ec196cc 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -296,7 +296,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 		return ret;
 	}
 	/*
-	 * NOTE: some devices with two i2c busses have the bad habit to return 0
+	 * NOTE: some devices with two i2c buses have the bad habit to return 0
 	 * bytes if we are on bus B AND there was no write attempt to the
 	 * specified slave address before AND no device is present at the
 	 * requested slave address.
@@ -427,7 +427,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		return ret;
 	}
 	/*
-	 * NOTE: some devices with two i2c busses have the bad habit to return 0
+	 * NOTE: some devices with two i2c buses have the bad habit to return 0
 	 * bytes if we are on bus B AND there was no write attempt to the
 	 * specified slave address before AND no device is present at the
 	 * requested slave address.
diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index f53afe18e92d..d7c60862874a 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -67,7 +67,7 @@
 #define EM28XX_I2C_CLK_WAIT_ENABLE	0x40
 #define EM28XX_I2C_EEPROM_ON_BOARD	0x08
 #define EM28XX_I2C_EEPROM_KEY_VALID	0x04
-#define EM2874_I2C_SECONDARY_BUS_SELECT	0x04 /* em2874 has two i2c busses */
+#define EM2874_I2C_SECONDARY_BUS_SELECT	0x04 /* em2874 has two i2c buses */
 #define EM28XX_I2C_FREQ_1_5_MHZ		0x03 /* bus frequency (bits [1-0]) */
 #define EM28XX_I2C_FREQ_25_KHZ		0x02
 #define EM28XX_I2C_FREQ_400_KHZ		0x01
diff --git a/drivers/media/usb/gspca/Kconfig b/drivers/media/usb/gspca/Kconfig
index d3b6665c342d..088566e88467 100644
--- a/drivers/media/usb/gspca/Kconfig
+++ b/drivers/media/usb/gspca/Kconfig
@@ -46,7 +46,7 @@ config USB_GSPCA_CPIA1
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
 	  Say Y here if you want support for USB cameras based on the cpia
-	  CPiA chip. Note that you need atleast version 0.6.4 of libv4l for
+	  CPiA chip. Note that you need at least version 0.6.4 of libv4l for
 	  applications to understand the videoformat generated by this driver.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/media/usb/gspca/autogain_functions.c b/drivers/media/usb/gspca/autogain_functions.c
index 6dfab2b077f7..f915cc7c0c63 100644
--- a/drivers/media/usb/gspca/autogain_functions.c
+++ b/drivers/media/usb/gspca/autogain_functions.c
@@ -98,7 +98,7 @@ EXPORT_SYMBOL(gspca_expo_autogain);
    80 %) and if that does not help, only then changes exposure. This leads
    to a much more stable image then using the knee algorithm which at
    certain points of the knee graph will only try to adjust exposure,
-   which leads to oscilating as one exposure step is huge.
+   which leads to oscillating as one exposure step is huge.
 
    Returns 0 if no changes were made, 1 if the gain and or exposure settings
    where changed. */
diff --git a/drivers/media/usb/gspca/benq.c b/drivers/media/usb/gspca/benq.c
index 8a8db5eb6d5f..1744591b8ba0 100644
--- a/drivers/media/usb/gspca/benq.c
+++ b/drivers/media/usb/gspca/benq.c
@@ -205,12 +205,12 @@ static void sd_isoc_irq(struct urb *urb)
 		 *	- 80 ba/bb 00 00 = start of image followed by 'ff d8'
 		 *	- 04 ba/bb oo oo = image piece
 		 *		where 'oo oo' is the image offset
-						(not cheked)
+						(not checked)
 		 *	- (other -> bad frame)
 		 * The images are JPEG encoded with full header and
 		 * normal ff escape.
 		 * The end of image ('ff d9') may occur in any URB.
-		 * (not cheked)
+		 * (not checked)
 		 */
 		data = (u8 *) urb0->transfer_buffer
 					+ urb0->iso_frame_desc[i].offset;
diff --git a/drivers/media/usb/gspca/mr97310a.c b/drivers/media/usb/gspca/mr97310a.c
index bea196361215..af454663e295 100644
--- a/drivers/media/usb/gspca/mr97310a.c
+++ b/drivers/media/usb/gspca/mr97310a.c
@@ -520,7 +520,7 @@ static int start_cif_cam(struct gspca_dev *gspca_dev)
 	switch (gspca_dev->pixfmt.width) {
 	case 160:
 		data[9] |= 0x04;  /* reg 8, 2:1 scale down from 320 */
-		/* fall thru */
+		/* fall through */
 	case 320:
 	default:
 		data[3] = 0x28;			   /* reg 2, H size/8 */
@@ -530,7 +530,7 @@ static int start_cif_cam(struct gspca_dev *gspca_dev)
 		break;
 	case 176:
 		data[9] |= 0x04;  /* reg 8, 2:1 scale down from 352 */
-		/* fall thru */
+		/* fall through */
 	case 352:
 		data[3] = 0x2c;			   /* reg 2, H size/8 */
 		data[4] = 0x48;			   /* reg 3, V size/4 */
@@ -617,10 +617,10 @@ static int start_vga_cam(struct gspca_dev *gspca_dev)
 	switch (gspca_dev->pixfmt.width) {
 	case 160:
 		data[9] |= 0x0c;  /* reg 8, 4:1 scale down */
-		/* fall thru */
+		/* fall through */
 	case 320:
 		data[9] |= 0x04;  /* reg 8, 2:1 scale down */
-		/* fall thru */
+		/* fall through */
 	case 640:
 	default:
 		data[3] = 0x50;  /* reg 2, H size/8 */
@@ -637,7 +637,7 @@ static int start_vga_cam(struct gspca_dev *gspca_dev)
 
 	case 176:
 		data[9] |= 0x04;  /* reg 8, 2:1 scale down */
-		/* fall thru */
+		/* fall through */
 	case 352:
 		data[3] = 0x2c;  /* reg 2, H size */
 		data[4] = 0x48;  /* reg 3, V size */
diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
index 10fcbe9e8614..f2799e8cb8e7 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -1945,7 +1945,7 @@ static const struct ov_i2c_regvals norm_8610[] = {
 	{ 0x62, 0x5f }, /* was 0xd7, new from windrv 090403 */
 	{ 0x63, 0xff },
 	{ 0x64, 0x53 }, /* new windrv 090403 says 0x57,
-			 * maybe thats wrong */
+			 * maybe that's wrong */
 	{ 0x65, 0x00 },
 	{ 0x66, 0x55 },
 	{ 0x67, 0xb0 },
@@ -3658,7 +3658,7 @@ static void ov518_mode_init_regs(struct sd *sd)
 		case SEN_OV7620AE:
 			/*
 			 * HdG: 640x480 needs special handling on device
-			 * revision 2, we check for device revison > 0 to
+			 * revision 2, we check for device revision > 0 to
 			 * avoid regressions, as we don't know the correct
 			 * thing todo for revision 1.
 			 *
diff --git a/drivers/media/usb/gspca/pac_common.h b/drivers/media/usb/gspca/pac_common.h
index 31f2a42af4dd..aae97a5534e3 100644
--- a/drivers/media/usb/gspca/pac_common.h
+++ b/drivers/media/usb/gspca/pac_common.h
@@ -21,7 +21,7 @@
 
 /* We calculate the autogain at the end of the transfer of a frame, at this
    moment a frame with the old settings is being captured and transmitted. So
-   if we adjust the gain or exposure we must ignore atleast the next frame for
+   if we adjust the gain or exposure we must ignore at least the next frame for
    the new settings to come into effect before doing any other adjustments. */
 #define PAC_AUTOGAIN_IGNORE_FRAMES	2
 
diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index 5984bb12bcff..ab912903f8d7 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -1634,7 +1634,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 		break;
 	case SENSOR_HV7131R:
 		sd->i2c_intf = 0x81;			/* i2c 400 Kb/s */
-		/* fall thru */
+		/* fall through */
 	default:
 		cam->cam_mode = vga_mode;
 		cam->nmodes = ARRAY_SIZE(vga_mode);
diff --git a/drivers/media/usb/gspca/sonixb.c b/drivers/media/usb/gspca/sonixb.c
index 5f3f2979540a..583c9f10198c 100644
--- a/drivers/media/usb/gspca/sonixb.c
+++ b/drivers/media/usb/gspca/sonixb.c
@@ -121,7 +121,7 @@ struct sensor_data {
 
 /* We calculate the autogain at the end of the transfer of a frame, at this
    moment a frame with the old settings is being captured and transmitted. So
-   if we adjust the gain or exposure we must ignore atleast the next frame for
+   if we adjust the gain or exposure we must ignore at least the next frame for
    the new settings to come into effect before doing any other adjustments. */
 #define AUTOGAIN_IGNORE_FRAMES 1
 
@@ -757,7 +757,7 @@ static void setexposure(struct gspca_dev *gspca_dev)
 
 		/* Don't allow this to get below 10 when using autogain, the
 		   steps become very large (relatively) when below 10 causing
-		   the image to oscilate from much too dark, to much too bright
+		   the image to oscillate from much too dark, to much too bright
 		   and back again. */
 		if (gspca_dev->autogain->val && reg10 < 10)
 			reg10 = 10;
diff --git a/drivers/media/usb/gspca/sonixj.c b/drivers/media/usb/gspca/sonixj.c
index df8d8482b795..a63f155f1515 100644
--- a/drivers/media/usb/gspca/sonixj.c
+++ b/drivers/media/usb/gspca/sonixj.c
@@ -2677,7 +2677,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	 * which is 62 bytes long and is followed by various information
 	 * including statuses and luminosity.
 	 *
-	 * A marker may be splitted on two packets.
+	 * A marker may be split on two packets.
 	 *
 	 * The 6th byte of a marker contains the bits:
 	 *	0x08: USB full
diff --git a/drivers/media/usb/gspca/spca501.c b/drivers/media/usb/gspca/spca501.c
index 2cce74b166d8..3d215952af18 100644
--- a/drivers/media/usb/gspca/spca501.c
+++ b/drivers/media/usb/gspca/spca501.c
@@ -574,7 +574,7 @@ static const __u16 spca501_3com_open_data[][3] = {
 	{0x0, 0x0001, 0x0010},	/* TG Start Clock */
 
 /*	{0x2, 0x006a, 0x0001},	 * C/S Enable ISOSYNCH Packet Engine */
-	{0x2, 0x0068, 0x0001},	/* C/S Diable ISOSYNCH Packet Engine */
+	{0x2, 0x0068, 0x0001},	/* C/S Disable ISOSYNCH Packet Engine */
 	{0x2, 0x0000, 0x0005},
 	{0x2, 0x0043, 0x0000},	/* C/S Set Timing Mode, Disable TG soft reset */
 	{0x2, 0x0043, 0x0000},	/* C/S Set Timing Mode, Disable TG soft reset */
diff --git a/drivers/media/usb/gspca/sq905.c b/drivers/media/usb/gspca/sq905.c
index ffea9c35b0a0..d5c48216deb7 100644
--- a/drivers/media/usb/gspca/sq905.c
+++ b/drivers/media/usb/gspca/sq905.c
@@ -18,7 +18,7 @@
  * History and Acknowledgments
  *
  * The original Linux driver for SQ905 based cameras was written by
- * Marcell Lengyel and furter developed by many other contributors
+ * Marcell Lengyel and further developed by many other contributors
  * and is available from http://sourceforge.net/projects/sqcam/
  *
  * This driver takes advantage of the reverse engineering work done for
diff --git a/drivers/media/usb/gspca/sunplus.c b/drivers/media/usb/gspca/sunplus.c
index 437a3367ab97..e1e2a605a46c 100644
--- a/drivers/media/usb/gspca/sunplus.c
+++ b/drivers/media/usb/gspca/sunplus.c
@@ -555,7 +555,7 @@ static void init_ctl_reg(struct gspca_dev *gspca_dev)
 	case BRIDGE_SPCA504:
 	case BRIDGE_SPCA504C:
 		pollreg = 0;
-		/* fall thru */
+		/* fall through */
 	default:
 /*	case BRIDGE_SPCA533: */
 /*	case BRIDGE_SPCA504B: */
@@ -638,7 +638,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		reg_w_riv(gspca_dev, 0x00, 0x2000, 0x00);
 		reg_w_riv(gspca_dev, 0x00, 0x2301, 0x13);
 		reg_w_riv(gspca_dev, 0x00, 0x2306, 0x00);
-		/* fall thru */
+		/* fall through */
 	case BRIDGE_SPCA533:
 		spca504B_PollingDataReady(gspca_dev);
 		spca50x_GetFirmware(gspca_dev);
diff --git a/drivers/media/usb/gspca/t613.c b/drivers/media/usb/gspca/t613.c
index 445782919446..ed9b925b723e 100644
--- a/drivers/media/usb/gspca/t613.c
+++ b/drivers/media/usb/gspca/t613.c
@@ -966,7 +966,7 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
 			V4L2_CID_SATURATION, 0, 0xf, 1, 5);
 	v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
 			V4L2_CID_GAMMA, 0, GAMMA_MAX, 1, 10);
-	/* Activate lowlight, some apps dont bring up the
+	/* Activate lowlight, some apps don't bring up the
 	   backlight_compensation control) */
 	v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
 			V4L2_CID_BACKLIGHT_COMPENSATION, 0, 1, 1, 1);
diff --git a/drivers/media/usb/gspca/touptek.c b/drivers/media/usb/gspca/touptek.c
index d1b9032d7863..6c056a448231 100644
--- a/drivers/media/usb/gspca/touptek.c
+++ b/drivers/media/usb/gspca/touptek.c
@@ -185,7 +185,7 @@ static const struct v4l2_pix_format vga_mode[] = {
 };
 
 /*
- * As theres no known frame sync, the only way to keep synced is to try hard
+ * As there's no known frame sync, the only way to keep synced is to try hard
  * to never miss any packets
  */
 #if MAX_NURBS < 4
@@ -259,7 +259,7 @@ static void setexposure(struct gspca_dev *gspca_dev, s32 val)
 		return;
 	}
 	gspca_dbg(gspca_dev, D_STREAM, "exposure: 0x%04X ms\n\n", value);
-	/* Wonder if theres a good reason for sending it twice */
+	/* Wonder if there's a good reason for sending it twice */
 	/* probably not but leave it in because...why not */
 	reg_w(gspca_dev, value, REG_COARSE_INTEGRATION_TIME_);
 	reg_w(gspca_dev, value, REG_COARSE_INTEGRATION_TIME_);
diff --git a/drivers/media/usb/gspca/w996Xcf.c b/drivers/media/usb/gspca/w996Xcf.c
index abfab3de1866..36cc5a5ce77a 100644
--- a/drivers/media/usb/gspca/w996Xcf.c
+++ b/drivers/media/usb/gspca/w996Xcf.c
@@ -431,7 +431,7 @@ static void w9968cf_set_crop_window(struct sd *sd)
 		start_cropy = 35;
 	}
 
-	/* Work around to avoid FP arithmetics */
+	/* Work around to avoid FP arithmetic */
 	#define SC(x) ((x) << 10)
 
 	/* Scaling factors */
diff --git a/drivers/media/usb/gspca/zc3xx-reg.h b/drivers/media/usb/gspca/zc3xx-reg.h
index 71fda38e85e0..26f6153b687f 100644
--- a/drivers/media/usb/gspca/zc3xx-reg.h
+++ b/drivers/media/usb/gspca/zc3xx-reg.h
@@ -26,7 +26,7 @@
 /* Test mode */
 #define ZC3XX_R00B_TESTMODECONTROL     0x000b
 
-/* Frame retreiving */
+/* Frame retrieving */
 #define ZC3XX_R00C_LASTACQTIME         0x000c
 #define ZC3XX_R00D_MONITORRES          0x000d
 #define ZC3XX_R00E_TIMESTAMPHIGH       0x000e
diff --git a/drivers/media/usb/gspca/zc3xx.c b/drivers/media/usb/gspca/zc3xx.c
index cf21991e3d99..ad7194029031 100644
--- a/drivers/media/usb/gspca/zc3xx.c
+++ b/drivers/media/usb/gspca/zc3xx.c
@@ -3602,7 +3602,7 @@ static const struct usb_action pas106b_InitialScale[] = {	/* 176x144 */
 	{0xaa, 0x14, 0x0081},
 /* Other registers */
 	{0xa0, 0x37, ZC3XX_R101_SENSORCORRECTION},
-/* Frame retreiving */
+/* Frame retrieving */
 	{0xa0, 0x00, ZC3XX_R019_AUTOADJUSTFPS},
 /* Gains */
 	{0xa0, 0xa0, ZC3XX_R1A8_DIGITALGAIN},
@@ -3718,7 +3718,7 @@ static const struct usb_action pas106b_Initial[] = {	/* 352x288 */
 	{0xaa, 0x14, 0x0081},
 /* Other registers */
 	{0xa0, 0x37, ZC3XX_R101_SENSORCORRECTION},
-/* Frame retreiving */
+/* Frame retrieving */
 	{0xa0, 0x00, ZC3XX_R019_AUTOADJUSTFPS},
 /* Gains */
 	{0xa0, 0xa0, ZC3XX_R1A8_DIGITALGAIN},
@@ -6775,7 +6775,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	case SENSOR_HV7131R:
 	case SENSOR_TAS5130C:
 		reg_r(gspca_dev, 0x0008);
-		/* fall thru */
+		/* fall through */
 	case SENSOR_PO2030:
 		reg_w(gspca_dev, 0x03, 0x0008);
 		break;
@@ -6824,7 +6824,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	case SENSOR_TAS5130C:
 		reg_w(gspca_dev, 0x09, 0x01ad);	/* (from win traces) */
 		reg_w(gspca_dev, 0x15, 0x01ae);
-		/* fall thru */
+		/* fall through */
 	case SENSOR_PAS202B:
 	case SENSOR_PO2030:
 /*		reg_w(gspca_dev, 0x40, ZC3XX_R117_GGAIN); in win traces */
diff --git a/drivers/media/usb/hdpvr/hdpvr.h b/drivers/media/usb/hdpvr/hdpvr.h
index 1d65b4185f57..fa43e1d45ea9 100644
--- a/drivers/media/usb/hdpvr/hdpvr.h
+++ b/drivers/media/usb/hdpvr/hdpvr.h
@@ -215,7 +215,7 @@ enum {
 	 */
 
 	/* :0 s 38 01 1700 0003 0001 1 = 00
-	 * VIDEO STANDARD or FREQUNCY 0 = 60hz, 1 = 50hz
+	 * VIDEO STANDARD or FREQUENCY 0 = 60hz, 1 = 50hz
 	 */
 
 	/* :0 s 38 01 3100 0003 0004 4 = 03030000
diff --git a/drivers/media/usb/pwc/pwc-dec23.c b/drivers/media/usb/pwc/pwc-dec23.c
index 1283b3bd9800..854c36a5dec9 100644
--- a/drivers/media/usb/pwc/pwc-dec23.c
+++ b/drivers/media/usb/pwc/pwc-dec23.c
@@ -41,7 +41,7 @@
  * UNROLL_LOOP_FOR_COPYING_BLOCK
  *   0: use a loop for a smaller code (but little slower)
  *   1: when unrolling the loop, gcc produces some faster code (perhaps only
- *   valid for intel processor class). Activating this option, automaticaly
+ *   valid for intel processor class). Activating this option, automatically
  *   activate USE_LOOKUP_TABLE_TO_CLAMP
  */
 #define UNROLL_LOOP_FOR_COPY		1
@@ -332,7 +332,7 @@ void pwc_dec23_init(struct pwc_device *pdev, const unsigned char *cmd)
 		build_table_color(TimonRomTable[version][1], pdec->table_0004_pass2, pdec->table_8004_pass2);
 	}
 
-	/* Informations can be coded on a variable number of bits but never less than 8 */
+	/* Information can be coded on a variable number of bits but never less than 8 */
 	shift = 8 - pdec->nbits;
 	pdec->scalebits = SCALEBITS - shift;
 	pdec->nbitsmask = 0xFF >> shift;
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index a81fb319b339..4e94197094ad 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -653,7 +653,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2_queue);
 
-	/* Don't allow queing new buffers after device disconnection */
+	/* Don't allow queueing new buffers after device disconnection */
 	if (!pdev->udev)
 		return -ENODEV;
 
diff --git a/drivers/media/usb/pwc/pwc-misc.c b/drivers/media/usb/pwc/pwc-misc.c
index 9be5adffa874..03888fc3804d 100644
--- a/drivers/media/usb/pwc/pwc-misc.c
+++ b/drivers/media/usb/pwc/pwc-misc.c
@@ -59,7 +59,7 @@ int pwc_get_size(struct pwc_device *pdev, int width, int height)
 			return i;
 	}
 
-	/* Never reached there always is atleast one supported mode */
+	/* Never reached there always is at least one supported mode */
 	return 0;
 }
 
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 2ffded08407b..4fc03ec8a4f1 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -75,7 +75,7 @@ static int smsusb_submit_urb(struct smsusb_device_t *dev,
 			     struct smsusb_urb_t *surb);
 
 /*
- * Completing URB's callback handler - bottom half (proccess context)
+ * Completing URB's callback handler - bottom half (process context)
  * submits the URB prepared on smsusb_onresponse()
  */
 static void do_submit_urb(struct work_struct *work)
diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index 468f5ccf4ae6..a44a44ff3bb1 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -297,7 +297,7 @@ static int stk1160_probe(struct usb_interface *interface,
 		return -ENOMEM;
 
 	/*
-	 * Scan usb posibilities and populate alt_max_pkt_size array.
+	 * Scan usb possibilities and populate alt_max_pkt_size array.
 	 * Also, check if device speed is fast enough.
 	 */
 	rc = stk1160_scan_usb(interface, udev, alt_max_pkt_size);
@@ -426,7 +426,7 @@ static void stk1160_disconnect(struct usb_interface *interface)
 
 	/*
 	 * This calls stk1160_release if it's the last reference.
-	 * Otherwise, release is posponed until there are no users left.
+	 * Otherwise, release is postponed until there are no users left.
 	 */
 	v4l2_device_put(&dev->v4l2_dev);
 }
diff --git a/drivers/media/usb/stk1160/stk1160-reg.h b/drivers/media/usb/stk1160/stk1160-reg.h
index 7b08a3cc4504..2e400db0ad0e 100644
--- a/drivers/media/usb/stk1160/stk1160-reg.h
+++ b/drivers/media/usb/stk1160/stk1160-reg.h
@@ -23,7 +23,7 @@
 /* GPIO Control */
 #define STK1160_GCTRL			0x000
 
-/* Remote Wakup Control */
+/* Remote Wakeup Control */
 #define STK1160_RMCTL			0x00c
 
 /* Power-on Strapping Data */
@@ -104,7 +104,7 @@
 #define STK1160_SBUSR_RA		0x208
 #define STK1160_SBUSR_RD		0x209
 
-/* Alternate Serial Inteface Control */
+/* Alternate Serial Interface Control */
 #define STK1160_ASIC			0x2fc
 
 /* PLL Select Options */
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 03f5e12b13a5..8f545861471e 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1006,7 +1006,7 @@ static int stk_setup_format(struct stk_camera *dev)
 		stk_camera_write_reg(dev, 0x001c, 0x46);
 	/*
 	 * Registers 0x0115 0x0114 are the size of each line (bytes),
-	 * regs 0x0117 0x0116 are the heigth of the image.
+	 * regs 0x0117 0x0116 are the height of the image.
 	 */
 	stk_camera_write_reg(dev, 0x0115,
 		((stk_sizes[i].w * depth) >> 8) & 0xff);
diff --git a/drivers/media/usb/tm6000/tm6000-alsa.c b/drivers/media/usb/tm6000/tm6000-alsa.c
index b965931793b5..d6c79c13b332 100644
--- a/drivers/media/usb/tm6000/tm6000-alsa.c
+++ b/drivers/media/usb/tm6000/tm6000-alsa.c
@@ -58,7 +58,7 @@ module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
 
 /****************************************************************************
-			Module specific funtions
+			Module specific functions
  ****************************************************************************/
 
 /*
diff --git a/drivers/media/usb/tm6000/tm6000-core.c b/drivers/media/usb/tm6000/tm6000-core.c
index d3229aa45fcb..2c723706f8c8 100644
--- a/drivers/media/usb/tm6000/tm6000-core.c
+++ b/drivers/media/usb/tm6000/tm6000-core.c
@@ -668,7 +668,7 @@ int tm6000_set_audio_rinput(struct tm6000_core *dev)
 			areg_f0 = 0x04;
 			break;
 		default:
-			printk(KERN_INFO "%s: audio input dosn't support\n",
+			printk(KERN_INFO "%s: audio input doesn't support\n",
 				dev->name);
 			return 0;
 			break;
@@ -690,7 +690,7 @@ int tm6000_set_audio_rinput(struct tm6000_core *dev)
 			areg_eb = 0x04;
 			break;
 		default:
-			printk(KERN_INFO "%s: audio input dosn't support\n",
+			printk(KERN_INFO "%s: audio input doesn't support\n",
 				dev->name);
 			return 0;
 			break;
diff --git a/drivers/media/usb/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
index 3a4e545c6037..36eea1950e77 100644
--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -149,7 +149,7 @@ static int tm6000_start_stream(struct tm6000_core *dev)
 							ret, __func__);
 		return ret;
 	} else
-		printk(KERN_ERR "tm6000: pipe resetted\n");
+		printk(KERN_ERR "tm6000: pipe reset\n");
 
 /*	mutex_lock(&tm6000_driver.open_close_mutex); */
 	ret = usb_submit_urb(dvb->bulk_urb, GFP_ATOMIC);
diff --git a/drivers/media/usb/tm6000/tm6000-i2c.c b/drivers/media/usb/tm6000/tm6000-i2c.c
index 8c0476dfe54f..b37782d6f79c 100644
--- a/drivers/media/usb/tm6000/tm6000-i2c.c
+++ b/drivers/media/usb/tm6000/tm6000-i2c.c
@@ -155,7 +155,7 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 			/*
 			 * The TM6000 only supports a read transaction
 			 * immediately after a 1 or 2 byte write to select
-			 * a register.  We cannot fulfil this request.
+			 * a register.  We cannot fulfill this request.
 			 */
 			i2c_dprintk(2, " read without preceding write not supported");
 			rc = -EOPNOTSUPP;
diff --git a/drivers/media/usb/tm6000/tm6000-stds.c b/drivers/media/usb/tm6000/tm6000-stds.c
index c0c75951246b..858cb4f3a9ca 100644
--- a/drivers/media/usb/tm6000/tm6000-stds.c
+++ b/drivers/media/usb/tm6000/tm6000-stds.c
@@ -323,7 +323,7 @@ static int tm6000_set_audio_std(struct tm6000_core *dev)
 {
 	uint8_t areg_02 = 0x04; /* GC1 Fixed gain 0dB */
 	uint8_t areg_05 = 0x01; /* Auto 4.5 = M Japan, Auto 6.5 = DK */
-	uint8_t areg_06 = 0x02; /* Auto de-emphasis, mannual channel mode */
+	uint8_t areg_06 = 0x02; /* Auto de-emphasis, manual channel mode */
 
 	if (dev->radio) {
 		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 5127be71dd03..072210f5f92f 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -180,7 +180,7 @@ static int copy_streams(u8 *data, unsigned long len,
 			field = (header >> 11) & 0x1;
 			line  = (header >> 12) & 0x1ff;
 			cmd   = (header >> 21) & 0x7;
-			/* Validates haeder fields */
+			/* Validates header fields */
 			if (size > TM6000_URB_MSG_LEN)
 				size = TM6000_URB_MSG_LEN;
 			pktsize = TM6000_URB_MSG_LEN;
diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index 6eb84cf007b4..4db7a013e049 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -306,7 +306,7 @@ static int ttusb_boot_dsp(struct ttusb *ttusb)
 	b[3] = 28;
 
 	/* upload dsp code in 32 byte steps (36 didn't work for me ...) */
-	/* 32 is max packet size, no messages should be splitted. */
+	/* 32 is max packet size, no messages should be split. */
 	for (i = 0; i < fw->size; i += 28) {
 		memcpy(&b[4], &fw->data[i], 28);
 
diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 44ca66cb9b8f..897ef5e1da71 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -284,7 +284,7 @@ static void ttusb_dec_handle_irq( struct urb *urb)
 		 *
 		 * this is an fact a bit too simple implementation;
 		 * the box also reports a keyrepeat signal
-		 * (with buffer[3] == 0x40) in an intervall of ~100ms.
+		 * (with buffer[3] == 0x40) in an interval of ~100ms.
 		 * But to handle this correctly we had to imlemenent some
 		 * kind of timer which signals a 'key up' event if no
 		 * keyrepeat signal is received for lets say 200ms.
diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index 2b843a7b27a4..92d166bf8c12 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -900,7 +900,7 @@ static enum parse_state usbvision_parse_lines_420(struct usb_usbvision *usbvisio
 	if ((frame->curline + 1) >= frame->frmheight)
 		return parse_state_next_frame;
 
-	block_split = (pixel_per_line%y_block_size) ? 1 : 0;	/* are some blocks splitted into different lines? */
+	block_split = (pixel_per_line%y_block_size) ? 1 : 0;	/* are some blocks split into different lines? */
 
 	y_odd_offset = (pixel_per_line / y_block_size) * (y_block_size + uv_block_size)
 			+ block_split * uv_block_size;
@@ -1865,7 +1865,7 @@ static int usbvision_set_compress_params(struct usb_usbvision *usbvision)
 	value[4] = 0xA2;    /* Reg.48 BUF_THR I'm not sure if this does something in not compressed mode. */
 	value[5] = 0x00;    /* Reg.49 DVI_YUV This has nothing to do with compression */
 
-	/* catched values for NT1004 */
+	/* caught values for NT1004 */
 	/* value[0] = 0xFF; Never apply intra mode automatically */
 	/* value[1] = 0xF1; Use full frame height for virtual strip width; One line per strip */
 	/* value[2] = 0x01; Force intra mode on all new frames */
@@ -1943,7 +1943,7 @@ int usbvision_set_input(struct usb_usbvision *usbvision)
 		/* SAA7113 uses 8 bit output */
 		value[0] = USBVISION_8_422_SYNC;
 	} else {
-		/* I'm sure only about d2-d0 [010] 16 bit 4:2:2 usin sync pulses
+		/* I'm sure only about d2-d0 [010] 16 bit 4:2:2 using sync pulses
 		 * as that is how saa7111 is configured */
 		value[0] = USBVISION_16_422_SYNC;
 		/* | USBVISION_VSNC_POL | USBVISION_VCLK_POL);*/
@@ -2146,7 +2146,7 @@ int usbvision_power_on(struct usb_usbvision *usbvision)
 
 /*
  * usbvision_begin_streaming()
- * Sure you have to put bit 7 to 0, if not incoming frames are droped, but no
+ * Sure you have to put bit 7 to 0, if not incoming frames are dropped, but no
  * idea about the rest
  */
 int usbvision_begin_streaming(struct usb_usbvision *usbvision)
diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/usbvision/usbvision.h
index d55088b4fd63..668167f8951d 100644
--- a/drivers/media/usb/usbvision/usbvision.h
+++ b/drivers/media/usb/usbvision/usbvision.h
@@ -135,11 +135,11 @@
 
 #define MIN_FRAME_WIDTH			64
 #define MAX_USB_WIDTH			320  /* 384 */
-#define MAX_FRAME_WIDTH			320  /* 384 */			/* streching sometimes causes crashes*/
+#define MAX_FRAME_WIDTH			320  /* 384 */			/* stretching sometimes causes crashes*/
 
 #define MIN_FRAME_HEIGHT		48
 #define MAX_USB_HEIGHT			240  /* 288 */
-#define MAX_FRAME_HEIGHT		240  /* 288 */			/* Streching sometimes causes crashes*/
+#define MAX_FRAME_HEIGHT		240  /* 288 */			/* Stretching sometimes causes crashes*/
 
 #define MAX_FRAME_SIZE			(MAX_FRAME_WIDTH * MAX_FRAME_HEIGHT * MAX_BYTES_PER_PIXEL)
 #define USBVISION_CLIPMASK_SIZE		(MAX_FRAME_WIDTH * MAX_FRAME_HEIGHT / 8) /* bytesize of clipmask */
@@ -177,7 +177,7 @@ enum {
  * G = 1.164*(Y-16) - 0.813*(U-128) - 0.391*(V-128)
  * R = 1.164*(Y-16) + 1.596*(U-128)
  *
- * If you fancy integer arithmetics (as you should), hear this:
+ * If you fancy integer arithmetic (as you should), hear this:
  *
  * 65536*B = 76284*(Y-16)		  + 132252*(V-128)
  * 65536*G = 76284*(Y-16) -  53281*(U-128) -  25625*(V-128)
@@ -438,7 +438,7 @@ struct usb_usbvision {
 	int last_compr_level;						/* How strong (100) or weak (0) was compression */
 	int usb_bandwidth;						/* Mbit/s */
 
-	/* Statistics that can be overlayed on the screen */
+	/* Statistics that can be overlaid on the screen */
 	unsigned long isoc_urb_count;			/* How many URBs we received so far */
 	unsigned long urb_length;			/* Length of last URB */
 	unsigned long isoc_data_count;			/* How many bytes we received */
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index e314657a1843..182dcac49aa3 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -2008,7 +2008,7 @@ int uvc_video_init(struct uvc_streaming *stream)
 	usb_set_interface(stream->dev->udev, stream->intfnum, 0);
 
 	/* Set the streaming probe control with default streaming parameters
-	 * retrieved from the device. Webcams that don't suport GET_DEF
+	 * retrieved from the device. Webcams that don't support GET_DEF
 	 * requests on the probe control will just keep their current streaming
 	 * parameters.
 	 */
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 51aad2cf742f..96fee8d5b865 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -2,7 +2,7 @@
  * Zoran 364xx based USB webcam module version 0.73
  *
  * Allows you to use your USB webcam with V4L2 applications
- * This is still in heavy developpement !
+ * This is still in heavy development !
  *
  * Copyright (C) 2004  Antoine Jacquet <royale@zerezo.com>
  * http://royale.zerezo.com/zr364xx/
-- 
2.20.1

