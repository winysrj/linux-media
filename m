Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9516DC43444
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C89721906
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545355120;
	bh=i/uv1TBPmT8SACtM1FnPqbclbE2t/B1l31U+TfW/G6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=17wwqbkCxcZ9Mt/adjoyCo1ZbSTQyKHnYYaWhb6/3YUkjxsZwGtlPvD7M5OyE/Yha
	 fZW8BruJdM5jx1PGSPTvJatbg2QbdyjVFLUqhfWaeEB46QaMBKUWI0ohEJMEzlSAxr
	 q5EjWzYxZzPQXfeUVz6RGqU6uuruh8YqSeqHEb3Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390653AbeLUBSj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 20:18:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390644AbeLUBSi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 20:18:38 -0500
Received: from mail.kernel.org (unknown [185.216.33.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20F7321903;
        Fri, 21 Dec 2018 01:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545355117;
        bh=i/uv1TBPmT8SACtM1FnPqbclbE2t/B1l31U+TfW/G6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXz7Ob2Y2K7jhAfW1WCnfoyBPdiBJrdocNcMR0lYUv1xyCj5uPA/Q4zLlpPDk0a2T
         zypcinnMG9rlNOvD2rU3gJkLW41+mPG+NlY8vwD46ze+Xqqp4WuiD7vztHDkU8XWun
         owyPr3K2zDTuaNu5i0OVPCJXXM3sauyGK+GgyEZU=
From:   Sebastian Reichel <sre@kernel.org>
To:     Sebastian Reichel <sre@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>
Cc:     Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-bluetooth@vger.kernel.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 12/14] media: wl128x-radio: move from TI_ST to hci_ll driver
Date:   Fri, 21 Dec 2018 02:17:50 +0100
Message-Id: <20181221011752.25627-13-sre@kernel.org>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181221011752.25627-1-sre@kernel.org>
References: <20181221011752.25627-1-sre@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Sebastian Reichel <sebastian.reichel@collabora.com>

This updates the wl128x-radio driver to be used with hci_ll
instead of the deprecated TI_ST driver.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 drivers/bluetooth/hci_ll.c                | 115 ++++++++++++++++++++--
 drivers/media/radio/wl128x/Kconfig        |   2 +-
 drivers/media/radio/wl128x/fmdrv.h        |   1 +
 drivers/media/radio/wl128x/fmdrv_common.c | 101 ++-----------------
 include/linux/ti_wilink_st.h              |   2 +
 5 files changed, 117 insertions(+), 104 deletions(-)

diff --git a/drivers/bluetooth/hci_ll.c b/drivers/bluetooth/hci_ll.c
index 3e767f245ed5..6bcba57e9c9c 100644
--- a/drivers/bluetooth/hci_ll.c
+++ b/drivers/bluetooth/hci_ll.c
@@ -49,6 +49,7 @@
 #include <linux/skbuff.h>
 #include <linux/ti_wilink_st.h>
 #include <linux/clk.h>
+#include <linux/platform_device.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -62,6 +63,7 @@
 #define HCI_VS_UPDATE_UART_HCI_BAUDRATE		0xff36
 
 /* HCILL commands */
+#define HCILL_FM_RADIO		0x08
 #define HCILL_GO_TO_SLEEP_IND	0x30
 #define HCILL_GO_TO_SLEEP_ACK	0x31
 #define HCILL_WAKE_UP_IND	0x32
@@ -81,6 +83,10 @@ struct ll_device {
 	struct gpio_desc *enable_gpio;
 	struct clk *ext_clk;
 	bdaddr_t bdaddr;
+
+	struct platform_device *fmdev;
+	void (*fm_handler) (void *, struct sk_buff *);
+	void *fm_drvdata;
 };
 
 struct ll_struct {
@@ -161,6 +167,35 @@ static int ll_flush(struct hci_uart *hu)
 	return 0;
 }
 
+static int ll_register_fm(struct ll_device *lldev)
+{
+	struct device *dev = &lldev->serdev->dev;
+	int err;
+
+	if (!of_device_is_compatible(dev->of_node, "ti,wl1281-st") &&
+	    !of_device_is_compatible(dev->of_node, "ti,wl1283-st") &&
+	    !of_device_is_compatible(dev->of_node, "ti,wl1285-st"))
+		return -ENODEV;
+
+	lldev->fmdev = platform_device_register_data(dev, "wl128x-fm",
+		PLATFORM_DEVID_AUTO, NULL, 0);
+	err = PTR_ERR_OR_ZERO(lldev->fmdev);
+	if (err) {
+		dev_warn(dev, "cannot register FM radio subdevice: %d\n", err);
+		lldev->fmdev = NULL;
+	}
+
+	return err;
+}
+
+static void ll_unregister_fm(struct ll_device *lldev)
+{
+	if (!lldev->fmdev)
+		return;
+	platform_device_unregister(lldev->fmdev);
+	lldev->fmdev = NULL;
+}
+
 /* Close protocol */
 static int ll_close(struct hci_uart *hu)
 {
@@ -178,6 +213,8 @@ static int ll_close(struct hci_uart *hu)
 		gpiod_set_value_cansleep(lldev->enable_gpio, 0);
 
 		clk_disable_unprepare(lldev->ext_clk);
+
+		ll_unregister_fm(lldev);
 	}
 
 	hu->priv = NULL;
@@ -313,18 +350,11 @@ static void ll_device_woke_up(struct hci_uart *hu)
 	hci_uart_tx_wakeup(hu);
 }
 
-/* Enqueue frame for transmittion (padding, crc, etc) */
-/* may be called from two simultaneous tasklets */
-static int ll_enqueue(struct hci_uart *hu, struct sk_buff *skb)
+static int ll_enqueue_prefixed(struct hci_uart *hu, struct sk_buff *skb)
 {
 	unsigned long flags = 0;
 	struct ll_struct *ll = hu->priv;
 
-	BT_DBG("hu %p skb %p", hu, skb);
-
-	/* Prepend skb with frame type */
-	memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
-
 	/* lock hcill state */
 	spin_lock_irqsave(&ll->hcill_lock, flags);
 
@@ -361,6 +391,18 @@ static int ll_enqueue(struct hci_uart *hu, struct sk_buff *skb)
 	return 0;
 }
 
+/* Enqueue frame for transmittion (padding, crc, etc) */
+/* may be called from two simultaneous tasklets */
+static int ll_enqueue(struct hci_uart *hu, struct sk_buff *skb)
+{
+	BT_DBG("hu %p skb %p", hu, skb);
+
+	/* Prepend skb with frame type */
+	memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
+
+	return ll_enqueue_prefixed(hu, skb);
+}
+
 static int ll_recv_frame(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct hci_uart *hu = hci_get_drvdata(hdev);
@@ -390,6 +432,32 @@ static int ll_recv_frame(struct hci_dev *hdev, struct sk_buff *skb)
 	return 0;
 }
 
+static int ll_recv_radio(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct hci_uart *hu = hci_get_drvdata(hdev);
+	struct serdev_device *serdev = hu->serdev;
+	struct ll_device *lldev = serdev_device_get_drvdata(serdev);
+
+	if (!lldev->fm_handler) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	/* Prepend skb with frame type */
+	memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
+
+	lldev->fm_handler(lldev->fm_drvdata, skb);
+
+	return 0;
+}
+
+#define LL_RECV_FM_RADIO \
+	.type = HCILL_FM_RADIO, \
+	.hlen = 1, \
+	.loff = 0, \
+	.lsize = 1, \
+	.maxlen = 0xff
+
 #define LL_RECV_SLEEP_IND \
 	.type = HCILL_GO_TO_SLEEP_IND, \
 	.hlen = 0, \
@@ -422,6 +490,7 @@ static const struct h4_recv_pkt ll_recv_pkts[] = {
 	{ H4_RECV_ACL,       .recv = hci_recv_frame },
 	{ H4_RECV_SCO,       .recv = hci_recv_frame },
 	{ H4_RECV_EVENT,     .recv = hci_recv_frame },
+	{ LL_RECV_FM_RADIO,  .recv = ll_recv_radio },
 	{ LL_RECV_SLEEP_IND, .recv = ll_recv_frame  },
 	{ LL_RECV_SLEEP_ACK, .recv = ll_recv_frame  },
 	{ LL_RECV_WAKE_IND,  .recv = ll_recv_frame  },
@@ -669,11 +738,41 @@ static int ll_setup(struct hci_uart *hu)
 		}
 	}
 
+	/* We intentionally ignore failures and proceed without FM device */
+	ll_register_fm(lldev);
+
 	return 0;
 }
 
 static const struct hci_uart_proto llp;
 
+void hci_ti_set_fm_handler(struct device *dev, void (*recv_handler) (void *, struct sk_buff *), void *drvdata)
+{
+	struct serdev_device *serdev = to_serdev_device(dev);
+	struct ll_device *lldev = serdev_device_get_drvdata(serdev);
+
+	lldev->fm_drvdata = drvdata;
+	lldev->fm_handler = recv_handler;
+}
+EXPORT_SYMBOL_GPL(hci_ti_set_fm_handler);
+
+int hci_ti_fm_send(struct device *dev, struct sk_buff *skb)
+{
+	struct serdev_device *serdev = to_serdev_device(dev);
+	struct ll_device *lldev = serdev_device_get_drvdata(serdev);
+	struct hci_uart *hu = &lldev->hu;
+	int ret;
+
+	hci_skb_pkt_type(skb) = HCILL_FM_RADIO;
+	ret = ll_enqueue_prefixed(hu, skb);
+
+	if (!ret)
+		hci_uart_tx_wakeup(hu);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hci_ti_fm_send);
+
 static int hci_ti_probe(struct serdev_device *serdev)
 {
 	struct hci_uart *hu;
diff --git a/drivers/media/radio/wl128x/Kconfig b/drivers/media/radio/wl128x/Kconfig
index 64b66bbdae72..847b3ed92639 100644
--- a/drivers/media/radio/wl128x/Kconfig
+++ b/drivers/media/radio/wl128x/Kconfig
@@ -4,7 +4,7 @@
 menu "Texas Instruments WL128x FM driver (ST based)"
 config RADIO_WL128X
 	tristate "Texas Instruments WL128x FM Radio"
-	depends on VIDEO_V4L2 && RFKILL && TTY && TI_ST
+	depends on VIDEO_V4L2 && RFKILL && TTY && BT_HCIUART_LL
 	depends on GPIOLIB || COMPILE_TEST
 	help
 	  Choose Y here if you have this FM radio chip.
diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
index 4a337f38cfc9..717a8a3f533f 100644
--- a/drivers/media/radio/wl128x/fmdrv.h
+++ b/drivers/media/radio/wl128x/fmdrv.h
@@ -197,6 +197,7 @@ struct fmtx_data {
 
 /* FM driver operation structure */
 struct fmdev {
+	struct device *dev;
 	struct video_device radio_dev;	/* V4L2 video device pointer */
 	struct v4l2_device v4l2_dev;	/* V4L2 top level struct */
 	struct snd_card *card;	/* Card which holds FM mixer controls */
diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index c20d518af4f3..88a2197c4815 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -172,9 +172,6 @@ static int_handler_prototype int_handler_table[] = {
 	fm_irq_handle_intmsk_cmd_resp
 };
 
-static long (*g_st_write) (struct sk_buff *skb);
-static struct completion wait_for_fmdrv_reg_comp;
-
 static inline void fm_irq_call(struct fmdev *fmdev)
 {
 	fmdev->irq_info.handlers[fmdev->irq_info.stage](fmdev);
@@ -373,7 +370,7 @@ static void send_tasklet(unsigned long arg)
 
 	/* Write FM packet to ST driver */
 	dump_tx_skb_data(skb);
-	len = g_st_write(skb);
+	len = hci_ti_fm_send(fmdev->dev->parent, skb);
 	if (len < 0) {
 		kfree_skb(skb);
 		fmdev->resp_comp = NULL;
@@ -1441,42 +1438,13 @@ int fmc_get_mode(struct fmdev *fmdev, u8 *fmmode)
 }
 
 /* Called by ST layer when FM packet is available */
-static long fm_st_receive(void *arg, struct sk_buff *skb)
+static void fm_st_receive(void *arg, struct sk_buff *skb)
 {
-	struct fmdev *fmdev;
-
-	fmdev = (struct fmdev *)arg;
-
-	if (skb == NULL) {
-		fmerr("Invalid SKB received from ST\n");
-		return -EFAULT;
-	}
-
-	if (skb->cb[0] != FM_PKT_LOGICAL_CHAN_NUMBER) {
-		fmerr("Received SKB (%p) is not FM Channel 8 pkt\n", skb);
-		return -EINVAL;
-	}
+	struct fmdev *fmdev = (struct fmdev *) arg;
 
-	memcpy(skb_push(skb, 1), &skb->cb[0], 1);
 	dump_rx_skb_data(skb);
-
 	skb_queue_tail(&fmdev->rx_q, skb);
 	tasklet_schedule(&fmdev->rx_task);
-
-	return 0;
-}
-
-/*
- * Called by ST layer to indicate protocol registration completion
- * status.
- */
-static void fm_st_reg_comp_cb(void *arg, int data)
-{
-	struct fmdev *fmdev;
-
-	fmdev = (struct fmdev *)arg;
-	fmdev->streg_cbdata = data;
-	complete(&wait_for_fmdrv_reg_comp);
 }
 
 /*
@@ -1485,59 +1453,12 @@ static void fm_st_reg_comp_cb(void *arg, int data)
  */
 void fmc_prepare(struct fmdev *fmdev)
 {
-	static struct st_proto_s fm_st_proto;
-
 	if (test_bit(FM_CORE_READY, &fmdev->flag)) {
 		fmdbg("FM Core is already up\n");
 		return;
 	}
 
-	memset(&fm_st_proto, 0, sizeof(fm_st_proto));
-	fm_st_proto.recv = fm_st_receive;
-	fm_st_proto.match_packet = NULL;
-	fm_st_proto.reg_complete_cb = fm_st_reg_comp_cb;
-	fm_st_proto.write = NULL; /* TI ST driver will fill write pointer */
-	fm_st_proto.priv_data = fmdev;
-	fm_st_proto.chnl_id = 0x08;
-	fm_st_proto.max_frame_size = 0xff;
-	fm_st_proto.hdr_len = 1;
-	fm_st_proto.offset_len_in_hdr = 0;
-	fm_st_proto.len_size = 1;
-	fm_st_proto.reserve = 1;
-
-	ret = st_register(&fm_st_proto);
-	if (ret == -EINPROGRESS) {
-		init_completion(&wait_for_fmdrv_reg_comp);
-		fmdev->streg_cbdata = -EINPROGRESS;
-		fmdbg("%s waiting for ST reg completion signal\n", __func__);
-
-		if (!wait_for_completion_timeout(&wait_for_fmdrv_reg_comp,
-						 FM_ST_REG_TIMEOUT)) {
-			fmerr("Timeout(%d sec), didn't get reg completion signal from ST\n",
-					jiffies_to_msecs(FM_ST_REG_TIMEOUT) / 1000);
-			return -ETIMEDOUT;
-		}
-		if (fmdev->streg_cbdata != 0) {
-			fmerr("ST reg comp CB called with error status %d\n",
-			      fmdev->streg_cbdata);
-			return -EAGAIN;
-		}
-
-		ret = 0;
-	} else if (ret == -1) {
-		fmerr("st_register failed %d\n", ret);
-		return -EAGAIN;
-	}
-
-	if (fm_st_proto.write != NULL) {
-		g_st_write = fm_st_proto.write;
-	} else {
-		fmerr("Failed to get ST write func pointer\n");
-		ret = st_unregister(&fm_st_proto);
-		if (ret < 0)
-			fmerr("st_unregister failed %d\n", ret);
-		return -EAGAIN;
-	}
+	hci_ti_set_fm_handler(fmdev->dev->parent, fm_st_receive, fmdev);
 
 	spin_lock_init(&fmdev->rds_buff_lock);
 	spin_lock_init(&fmdev->resp_skb_lock);
@@ -1582,9 +1503,6 @@ void fmc_prepare(struct fmdev *fmdev)
  */
 void fmc_release(struct fmdev *fmdev)
 {
-	static struct st_proto_s fm_st_proto;
-	int ret;
-
 	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
 		fmdbg("FM Core is already down\n");
 		return;
@@ -1601,15 +1519,7 @@ void fmc_release(struct fmdev *fmdev)
 	fmdev->resp_comp = NULL;
 	fmdev->rx.freq = 0;
 
-	memset(&fm_st_proto, 0, sizeof(fm_st_proto));
-	fm_st_proto.chnl_id = 0x08;
-
-	ret = st_unregister(&fm_st_proto);
-
-	if (ret < 0)
-		fmerr("Failed to de-register FM from ST %d\n", ret);
-	else
-		fmdbg("Successfully unregistered from ST\n");
+	hci_ti_set_fm_handler(fmdev->dev->parent, NULL, NULL);
 
 	clear_bit(FM_CORE_READY, &fmdev->flag);
 }
@@ -1624,6 +1534,7 @@ static int wl128x_fm_probe(struct platform_device *pdev)
 	if (!fmdev)
 		return -ENOMEM;
 	platform_set_drvdata(pdev, fmdev);
+	fmdev->dev = &pdev->dev;
 
 	fmdev->rx.rds.buf_size = default_rds_buf * FM_RDS_BLK_SIZE;
 	fmdev->rx.rds.buff = devm_kzalloc(&pdev->dev, fmdev->rx.rds.buf_size, GFP_KERNEL);
diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
index f2293028ab9d..a9de5654b0cd 100644
--- a/include/linux/ti_wilink_st.h
+++ b/include/linux/ti_wilink_st.h
@@ -86,6 +86,8 @@ struct st_proto_s {
 extern long st_register(struct st_proto_s *);
 extern long st_unregister(struct st_proto_s *);
 
+void hci_ti_set_fm_handler(struct device *dev, void (*recv_handler) (void *, struct sk_buff *), void *drvdata);
+int hci_ti_fm_send(struct device *dev, struct sk_buff *skb);
 
 /*
  * header information used by st_core.c
-- 
2.19.2

