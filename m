Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720FEC43612
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 414D4218E0
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545355167;
	bh=Qn0CqU4S1/+2lB935WPJiZabi36T/4R+/jIXSshUPGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Lfjtn99H5hcZTk393r+wjbXtLObkVgkq/Pp/J8m5DS53EvmDcApt9y5ECIVF8drkO
	 5sTfhZDOHAupNBw4pAFbMdAsc4ZKcOzj32OZb0C6am5ocSn4iqDRjZ+/0tYgaC2hx6
	 w13GtQV8aKMw2FccQ+xHBXDfUTokihkicYryR1j4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388208AbeLUBTU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 20:19:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390632AbeLUBSf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 20:18:35 -0500
Received: from mail.kernel.org (unknown [185.216.33.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DCA521907;
        Fri, 21 Dec 2018 01:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545355115;
        bh=Qn0CqU4S1/+2lB935WPJiZabi36T/4R+/jIXSshUPGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWszkehHP5TR+CWeTiKmaidA+m5kNAlaZtBAWwn5kMgZElP31k6ymEfPBFs1qoE+p
         9yBpJ0CELeaZirPxiSL7soqI6qkngC1XBmd7L7k9lsMfmqD3KvIN/KxcUBhOKmV98n
         by6MXhb5Y+OjpNwKNRe24wUdjvg9BPn+PJ0/Eq3E=
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
Subject: [PATCH 11/14] media: wl128x-radio: fix skb debug printing
Date:   Fri, 21 Dec 2018 02:17:49 +0100
Message-Id: <20181221011752.25627-12-sre@kernel.org>
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

This fixes incorrect code in the TX/RX skb debug print
function and add stubs in receive/transmit packet path.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 473ec5738a11..c20d518af4f3 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -195,7 +195,7 @@ static inline void fm_irq_timeout_stage(struct fmdev *fmdev, u8 stage)
 
 #ifdef FM_DUMP_TXRX_PKT
  /* To dump outgoing FM Channel-8 packets */
-inline void dump_tx_skb_data(struct sk_buff *skb)
+static void dump_tx_skb_data(struct sk_buff *skb)
 {
 	int len, len_org;
 	u8 index;
@@ -220,7 +220,7 @@ inline void dump_tx_skb_data(struct sk_buff *skb)
 }
 
  /* To dump incoming FM Channel-8 packets */
-inline void dump_rx_skb_data(struct sk_buff *skb)
+static void dump_rx_skb_data(struct sk_buff *skb)
 {
 	int len, len_org;
 	u8 index;
@@ -228,7 +228,7 @@ inline void dump_rx_skb_data(struct sk_buff *skb)
 
 	evt_hdr = (struct fm_event_msg_hdr *)skb->data;
 	printk(KERN_INFO ">> hdr:%02x len:%02x sts:%02x numhci:%02x opcode:%02x type:%s dlen:%02x",
-	       evt_hdr->hdr, evt_hdr->len,
+	       evt_hdr->header, evt_hdr->len,
 	       evt_hdr->status, evt_hdr->num_fm_hci_cmds, evt_hdr->op,
 	       (evt_hdr->rd_wr) ? "RD" : "WR", evt_hdr->dlen);
 
@@ -243,6 +243,9 @@ inline void dump_rx_skb_data(struct sk_buff *skb)
 	}
 	printk(KERN_CONT "\n");
 }
+#else
+static void dump_tx_skb_data(struct sk_buff *skb) {}
+static void dump_rx_skb_data(struct sk_buff *skb) {}
 #endif
 
 void fmc_update_region_info(struct fmdev *fmdev, u8 region_to_set)
@@ -369,6 +372,7 @@ static void send_tasklet(unsigned long arg)
 	fmdev->resp_comp = fm_cb(skb)->completion;
 
 	/* Write FM packet to ST driver */
+	dump_tx_skb_data(skb);
 	len = g_st_write(skb);
 	if (len < 0) {
 		kfree_skb(skb);
@@ -1454,6 +1458,8 @@ static long fm_st_receive(void *arg, struct sk_buff *skb)
 	}
 
 	memcpy(skb_push(skb, 1), &skb->cb[0], 1);
+	dump_rx_skb_data(skb);
+
 	skb_queue_tail(&fmdev->rx_q, skb);
 	tasklet_schedule(&fmdev->rx_task);
 
-- 
2.19.2

