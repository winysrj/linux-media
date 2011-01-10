Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35102 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab1AJMlQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 07:41:16 -0500
From: manjunatha_halli@ti.com
To: mchehab@infradead.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [RFC V9 3/7] drivers:media:radio: wl128x: FM Driver Common  sources
Date: Mon, 10 Jan 2011 08:04:56 -0500
Message-Id: <1294664700-26949-4-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1294664700-26949-3-git-send-email-manjunatha_halli@ti.com>
References: <1294664700-26949-1-git-send-email-manjunatha_halli@ti.com>
 <1294664700-26949-2-git-send-email-manjunatha_halli@ti.com>
 <1294664700-26949-3-git-send-email-manjunatha_halli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Manjunatha Halli <manjunatha_halli@ti.com>

These are the sources for the common interfaces required by the
FM V4L2 driver for TI WL127x and WL128x chips.

These implement the FM channel-8 protocol communication with the
chip. This makes use of the Shared Transport as its transport.

Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 1693 +++++++++++++++++++++++++++++
 drivers/media/radio/wl128x/fmdrv_common.h |  402 +++++++
 2 files changed, 2095 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/wl128x/fmdrv_common.c
 create mode 100644 drivers/media/radio/wl128x/fmdrv_common.h

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
new file mode 100644
index 0000000..46f5fe4
--- /dev/null
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -0,0 +1,1693 @@
+/*
+ *  FM Driver for Connectivity chip of Texas Instruments.
+ *
+ *  This sub-module of FM driver is common for FM RX and TX
+ *  functionality. This module is responsible for:
+ *  1) Forming group of Channel-8 commands to perform particular
+ *     functionality (eg., frequency set require more than
+ *     one Channel-8 command to be sent to the chip).
+ *  2) Sending each Channel-8 command to the chip and reading
+ *     response back over Shared Transport.
+ *  3) Managing TX and RX Queues and Tasklets.
+ *  4) Handling FM Interrupt packet and taking appropriate action.
+ *  5) Loading FM firmware to the chip (common, FM TX, and FM RX
+ *     firmware files based on mode selection)
+ *
+ *  Copyright (C) 2011 Texas Instruments
+ *  Author: Raja Mani <raja_mani@ti.com>
+ *  Author: Manjunatha Halli <manjunatha_halli@ti.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/firmware.h>
+#include <linux/delay.h>
+#include "fmdrv.h"
+#include "fmdrv_v4l2.h"
+#include "fmdrv_common.h"
+#include <linux/ti_wilink_st.h>
+#include "fmdrv_rx.h"
+#include "fmdrv_tx.h"
+
+/* Region info */
+static struct region_info region_configs[] = {
+	/* Europe/US */
+	{
+	 .chanl_space = FM_CHANNEL_SPACING_200KHZ * FM_FREQ_MUL,
+	 .bot_freq = 87500,	/* 87.5 MHz */
+	 .top_freq = 108000,	/* 108 MHz */
+	 .fm_band = 0,
+	 },
+	/* Japan */
+	{
+	 .chanl_space = FM_CHANNEL_SPACING_200KHZ * FM_FREQ_MUL,
+	 .bot_freq = 76000,	/* 76 MHz */
+	 .top_freq = 90000,	/* 90 MHz */
+	 .fm_band = 1,
+	 },
+};
+
+/* Band selection */
+static u8 default_radio_region;	/* Europe/US */
+module_param(default_radio_region, byte, 0);
+MODULE_PARM_DESC(default_radio_region, "Region: 0=Europe/US, 1=Japan");
+
+/* RDS buffer blocks */
+static u32 default_rds_buf = 300;
+module_param(default_rds_buf, uint, 0444);
+MODULE_PARM_DESC(rds_buf, "RDS buffer entries");
+
+/* Radio Nr */
+static u32 radio_nr = -1;
+module_param(radio_nr, int, 0444);
+MODULE_PARM_DESC(radio_nr, "Radio Nr");
+
+/* FM irq handlers forward declaration */
+static void fm_irq_send_flag_getcmd(struct fmdev *);
+static void fm_irq_handle_flag_getcmd_resp(struct fmdev *);
+static void fm_irq_handle_hw_malfunction(struct fmdev *);
+static void fm_irq_handle_rds_start(struct fmdev *);
+static void fm_irq_send_rdsdata_getcmd(struct fmdev *);
+static void fm_irq_handle_rdsdata_getcmd_resp(struct fmdev *);
+static void fm_irq_handle_rds_finish(struct fmdev *);
+static void fm_irq_handle_tune_op_ended(struct fmdev *);
+static void fm_irq_handle_power_enb(struct fmdev *);
+static void fm_irq_handle_low_rssi_start(struct fmdev *);
+static void fm_irq_afjump_set_pi(struct fmdev *);
+static void fm_irq_handle_set_pi_resp(struct fmdev *);
+static void fm_irq_afjump_set_pimask(struct fmdev *);
+static void fm_irq_handle_set_pimask_resp(struct fmdev *);
+static void fm_irq_afjump_setfreq(struct fmdev *);
+static void fm_irq_handle_setfreq_resp(struct fmdev *);
+static void fm_irq_afjump_enableint(struct fmdev *);
+static void fm_irq_afjump_enableint_resp(struct fmdev *);
+static void fm_irq_start_afjump(struct fmdev *);
+static void fm_irq_handle_start_afjump_resp(struct fmdev *);
+static void fm_irq_afjump_rd_freq(struct fmdev *);
+static void fm_irq_afjump_rd_freq_resp(struct fmdev *);
+static void fm_irq_handle_low_rssi_finish(struct fmdev *);
+static void fm_irq_send_intmsk_cmd(struct fmdev *);
+static void fm_irq_handle_intmsk_cmd_resp(struct fmdev *);
+
+/*
+ * When FM common module receives interrupt packet, following handlers
+ * will be executed one after another to service the interrupt(s)
+ */
+enum fmc_irq_handler_index {
+	FM_SEND_FLAG_GETCMD_IDX,
+	FM_HANDLE_FLAG_GETCMD_RESP_IDX,
+
+	/* HW malfunction irq handler */
+	FM_HW_MAL_FUNC_IDX,
+
+	/* RDS threshold reached irq handler */
+	FM_RDS_START_IDX,
+	FM_RDS_SEND_RDS_GETCMD_IDX,
+	FM_RDS_HANDLE_RDS_GETCMD_RESP_IDX,
+	FM_RDS_FINISH_IDX,
+
+	/* Tune operation ended irq handler */
+	FM_HW_TUNE_OP_ENDED_IDX,
+
+	/* TX power enable irq handler */
+	FM_HW_POWER_ENB_IDX,
+
+	/* Low RSSI irq handler */
+	FM_LOW_RSSI_START_IDX,
+	FM_AF_JUMP_SETPI_IDX,
+	FM_AF_JUMP_HANDLE_SETPI_RESP_IDX,
+	FM_AF_JUMP_SETPI_MASK_IDX,
+	FM_AF_JUMP_HANDLE_SETPI_MASK_RESP_IDX,
+	FM_AF_JUMP_SET_AF_FREQ_IDX,
+	FM_AF_JUMP_HANDLE_SET_AFFREQ_RESP_IDX,
+	FM_AF_JUMP_ENABLE_INT_IDX,
+	FM_AF_JUMP_ENABLE_INT_RESP_IDX,
+	FM_AF_JUMP_START_AFJUMP_IDX,
+	FM_AF_JUMP_HANDLE_START_AFJUMP_RESP_IDX,
+	FM_AF_JUMP_RD_FREQ_IDX,
+	FM_AF_JUMP_RD_FREQ_RESP_IDX,
+	FM_LOW_RSSI_FINISH_IDX,
+
+	/* Interrupt process post action */
+	FM_SEND_INTMSK_CMD_IDX,
+	FM_HANDLE_INTMSK_CMD_RESP_IDX,
+};
+
+/* FM interrupt handler table */
+static int_handler_prototype int_handler_table[] = {
+	fm_irq_send_flag_getcmd,
+	fm_irq_handle_flag_getcmd_resp,
+	fm_irq_handle_hw_malfunction,
+	fm_irq_handle_rds_start, /* RDS threshold reached irq handler */
+	fm_irq_send_rdsdata_getcmd,
+	fm_irq_handle_rdsdata_getcmd_resp,
+	fm_irq_handle_rds_finish,
+	fm_irq_handle_tune_op_ended,
+	fm_irq_handle_power_enb, /* TX power enable irq handler */
+	fm_irq_handle_low_rssi_start,
+	fm_irq_afjump_set_pi,
+	fm_irq_handle_set_pi_resp,
+	fm_irq_afjump_set_pimask,
+	fm_irq_handle_set_pimask_resp,
+	fm_irq_afjump_setfreq,
+	fm_irq_handle_setfreq_resp,
+	fm_irq_afjump_enableint,
+	fm_irq_afjump_enableint_resp,
+	fm_irq_start_afjump,
+	fm_irq_handle_start_afjump_resp,
+	fm_irq_afjump_rd_freq,
+	fm_irq_afjump_rd_freq_resp,
+	fm_irq_handle_low_rssi_finish,
+	fm_irq_send_intmsk_cmd, /* Interrupt process post action */
+	fm_irq_handle_intmsk_cmd_resp
+};
+
+long (*g_st_write) (struct sk_buff *skb);
+static struct completion wait_for_fmdrv_reg_comp;
+
+static inline void fm_irq_call(struct fmdev *fmdev)
+{
+	fmdev->irq_info.handlers[fmdev->irq_info.stage](fmdev);
+}
+
+/* Continue next function in interrupt handler table */
+static inline void fm_irq_call_stage(struct fmdev *fmdev, u8 stage)
+{
+	fmdev->irq_info.stage = stage;
+	fm_irq_call(fmdev);
+}
+
+static inline void fm_irq_timeout_stage(struct fmdev *fmdev, u8 stage)
+{
+	fmdev->irq_info.stage = stage;
+	mod_timer(&fmdev->irq_info.timer, jiffies + FM_DRV_TX_TIMEOUT);
+}
+
+#ifdef FM_DUMP_TXRX_PKT
+ /* To dump outgoing FM Channel-8 packets */
+inline void dump_tx_skb_data(struct sk_buff *skb)
+{
+	int len, len_org;
+	u8 index;
+	struct fm_cmd_msg_hdr *cmd_hdr;
+
+	cmd_hdr = (struct fm_cmd_msg_hdr *)skb->data;
+	printk(KERN_INFO "<<%shdr:%02x len:%02x opcode:%02x type:%s dlen:%02x",
+	       fm_cb(skb)->completion ? " " : "*", cmd_hdr->hdr,
+	       cmd_hdr->len, cmd_hdr->op,
+	       cmd_hdr->rd_wr ? "RD" : "WR", cmd_hdr->dlen);
+
+	len_org = skb->len - FM_CMD_MSG_HDR_SIZE;
+	if (len_org > 0) {
+		printk("\n   data(%d): ", cmd_hdr->dlen);
+		len = min(len_org, 14);
+		for (index = 0; index < len; index++)
+			printk("%x ",
+			       skb->data[FM_CMD_MSG_HDR_SIZE + index]);
+		printk("%s", (len_org > 14) ? ".." : "");
+	}
+	printk("\n");
+}
+
+ /* To dump incoming FM Channel-8 packets */
+inline void dump_rx_skb_data(struct sk_buff *skb)
+{
+	int len, len_org;
+	u8 index;
+	struct fm_event_msg_hdr *evt_hdr;
+
+	evt_hdr = (struct fm_event_msg_hdr *)skb->data;
+	printk(KERN_INFO ">> hdr:%02x len:%02x sts:%02x numhci:%02x "
+	    "opcode:%02x type:%s dlen:%02x", evt_hdr->hdr, evt_hdr->len,
+	    evt_hdr->status, evt_hdr->num_fm_hci_cmds, evt_hdr->op,
+	    (evt_hdr->rd_wr) ? "RD" : "WR", evt_hdr->dlen);
+
+	len_org = skb->len - FM_EVT_MSG_HDR_SIZE;
+	if (len_org > 0) {
+		printk("\n   data(%d): ", evt_hdr->dlen);
+		len = min(len_org, 14);
+		for (index = 0; index < len; index++)
+			printk("%x ",
+			       skb->data[FM_EVT_MSG_HDR_SIZE + index]);
+		printk("%s", (len_org > 14) ? ".." : "");
+	}
+	printk("\n");
+}
+#endif
+
+void fmc_update_region_info(struct fmdev *fmdev, u8 region_to_set)
+{
+	fmdev->rx.region = region_configs[region_to_set];
+}
+
+/*
+ * FM common sub-module will schedule this tasklet whenever it receives
+ * FM packet from ST driver.
+ */
+static void recv_tasklet(unsigned long arg)
+{
+	struct fmdev *fmdev;
+	struct fm_irq *irq_info;
+	struct fm_event_msg_hdr *evt_hdr;
+	struct sk_buff *skb;
+	u8 num_fm_hci_cmds;
+	unsigned long flags;
+
+	fmdev = (struct fmdev *)arg;
+	irq_info = &fmdev->irq_info;
+	/* Process all packets in the RX queue */
+	while ((skb = skb_dequeue(&fmdev->rx_q))) {
+		if (skb->len < sizeof(struct fm_event_msg_hdr)) {
+			fmerr("skb(%p) has only %d bytes"
+				"atleast need %d bytes to decode\n",skb,
+				skb->len, sizeof(struct fm_event_msg_hdr));
+			kfree_skb(skb);
+			continue;
+		}
+
+		evt_hdr = (void *)skb->data;
+		num_fm_hci_cmds = evt_hdr->num_fm_hci_cmds;
+
+		/* FM interrupt packet? */
+		if (evt_hdr->op == FM_INTERRUPT) {
+			/* FM interrupt handler started already? */
+			if (!test_bit(FM_INTTASK_RUNNING, &fmdev->flag)) {
+				set_bit(FM_INTTASK_RUNNING, &fmdev->flag);
+				if (irq_info->stage != 0) {
+					fmerr("Inval stage resetting to zero\n");
+					irq_info->stage = 0;
+				}
+
+				/*
+				 * Execute first function in interrupt handler
+				 * table.
+				 */
+				irq_info->handlers[irq_info->stage](fmdev);
+			} else {
+				set_bit(FM_INTTASK_SCHEDULE_PENDING,&fmdev->flag);
+			}
+			kfree_skb(skb);
+		}
+		/* Anyone waiting for this with completion handler? */
+		else if (evt_hdr->op == fmdev->pre_op && fmdev->resp_comp != NULL) {
+
+			spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
+			fmdev->resp_skb = skb;
+			spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);
+			complete(fmdev->resp_comp);
+
+			fmdev->resp_comp = NULL;
+			atomic_set(&fmdev->tx_cnt, 1);
+		}
+		/* Is this for interrupt handler? */
+		else if (evt_hdr->op == fmdev->pre_op && fmdev->resp_comp == NULL) {
+			if (fmdev->resp_skb != NULL)
+				fmerr("Response SKB ptr not NULL\n");
+
+			spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
+			fmdev->resp_skb = skb;
+			spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);
+
+			/* Execute interrupt handler where state index points */
+			irq_info->handlers[irq_info->stage](fmdev);
+
+			kfree_skb(skb);
+			atomic_set(&fmdev->tx_cnt, 1);
+		} else {
+			fmerr("Nobody claimed SKB(%p),purging\n",skb);
+		}
+
+		/*
+		 * Check flow control field. If Num_FM_HCI_Commands field is
+		 * not zero, schedule FM TX tasklet.
+		 */
+		if (num_fm_hci_cmds && atomic_read(&fmdev->tx_cnt))
+			if (!skb_queue_empty(&fmdev->tx_q))
+				tasklet_schedule(&fmdev->tx_task);
+	}
+}
+
+/* FM send tasklet: is scheduled when FM packet has to be sent to chip */
+static void send_tasklet(unsigned long arg)
+{
+	struct fmdev *fmdev;
+	struct sk_buff *skb;
+	int len;
+
+	fmdev = (struct fmdev *)arg;
+
+	if (!atomic_read(&fmdev->tx_cnt))
+		return;
+
+	/* Check, is there any timeout happenned to last transmitted packet */
+	if ((jiffies - fmdev->last_tx_jiffies) > FM_DRV_TX_TIMEOUT) {
+		fmerr("TX timeout occurred\n");
+		atomic_set(&fmdev->tx_cnt, 1);
+	}
+
+	/* Send queued FM TX packets */
+	skb = skb_dequeue(&fmdev->tx_q);
+	if (!skb)
+		return;
+
+	atomic_dec(&fmdev->tx_cnt);
+	fmdev->pre_op = fm_cb(skb)->fm_op;
+
+	if (fmdev->resp_comp != NULL)
+		fmerr("Response completion handler is not NULL\n");
+
+	fmdev->resp_comp = fm_cb(skb)->completion;
+
+	/* Write FM packet to ST driver */
+	len = g_st_write(skb);
+	if (len < 0) {
+		kfree_skb(skb);
+		fmdev->resp_comp = NULL;
+		fmerr("TX tasklet failed to send skb(%p)\n", skb);
+		atomic_set(&fmdev->tx_cnt, 1);
+	} else {
+		fmdev->last_tx_jiffies = jiffies;
+	}
+}
+
+/*
+ * Queues FM Channel-8 packet to FM TX queue and schedules FM TX tasklet for
+ * transmission
+ */
+static u32 fm_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type,	void *payload,
+		int payload_len, struct completion *wait_completion)
+{
+	struct sk_buff *skb;
+	struct fm_cmd_msg_hdr *hdr;
+	int size;
+
+	if (fm_op >= FM_INTERRUPT) {
+		fmerr("Invalid fm opcode - %d\n",fm_op);
+		return -EINVAL;
+	}
+	if (test_bit(FM_FW_DW_INPROGRESS, &fmdev->flag) && payload == NULL) {
+		fmerr("Payload data is NULL during fw download\n");
+		return -EINVAL;
+	}
+	if (!test_bit(FM_FW_DW_INPROGRESS, &fmdev->flag))
+		size =
+		    FM_CMD_MSG_HDR_SIZE + ((payload == NULL) ? 0 : payload_len);
+	else
+		size = payload_len;
+
+	skb = alloc_skb(size, GFP_ATOMIC);
+	if (!skb) {
+		fmerr("No memory to create new SKB\n");
+		return -ENOMEM;
+	}
+	/*
+	 * Don't fill FM header info for the commands which come from
+	 * FM firmware file.
+	 */
+	if (!test_bit(FM_FW_DW_INPROGRESS, &fmdev->flag) ||
+			test_bit(FM_INTTASK_RUNNING, &fmdev->flag)) {
+		/* Fill command header info */
+		hdr = (struct fm_cmd_msg_hdr *)skb_put(skb, FM_CMD_MSG_HDR_SIZE);
+		hdr->hdr = FM_PKT_LOGICAL_CHAN_NUMBER;	/* 0x08 */
+
+		/* 3 (fm_opcode,rd_wr,dlen) + payload len) */
+		hdr->len = ((payload == NULL) ? 0 : payload_len) + 3;
+
+		/* FM opcode */
+		hdr->op = fm_op;
+
+		/* read/write type */
+		hdr->rd_wr = type;
+		hdr->dlen = payload_len;
+		fm_cb(skb)->fm_op = fm_op;
+
+		/*
+		 * If firmware download has finished and the command is
+		 * not a read command then payload is != NULL - a write
+		 * command with u16 payload - convert to be16
+		 */
+		if (payload != NULL)
+			*(u16 *)payload = cpu_to_be16(*(u16 *)payload);
+
+	} else if (payload != NULL) {
+		fm_cb(skb)->fm_op = *((u8 *)payload + 2);
+	}
+	if (payload != NULL)
+		memcpy(skb_put(skb, payload_len), payload, payload_len);
+
+	fm_cb(skb)->completion = wait_completion;
+	skb_queue_tail(&fmdev->tx_q, skb);
+	tasklet_schedule(&fmdev->tx_task);
+
+	return 0;
+}
+
+/* Sends FM Channel-8 command to the chip and waits for the response */
+u32 fmc_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type, void *payload,
+		unsigned int payload_len, void *response, int *response_len)
+{
+	struct sk_buff *skb;
+	struct fm_event_msg_hdr *evt_hdr;
+	unsigned long flags;
+	u32 ret;
+
+	init_completion(&fmdev->maintask_comp);
+	ret = fm_send_cmd(fmdev, fm_op, type, payload, payload_len,
+			    &fmdev->maintask_comp);
+	if (ret)
+		return ret;
+
+	ret = wait_for_completion_timeout(&fmdev->maintask_comp, FM_DRV_TX_TIMEOUT);
+	if (!ret) {
+		fmerr("Timeout(%d sec),didn't get reg"
+			   "completion signal from RX tasklet\n",
+			   jiffies_to_msecs(FM_DRV_TX_TIMEOUT) / 1000);
+		return -ETIMEDOUT;
+	}
+	if (!fmdev->resp_skb) {
+		fmerr("Reponse SKB is missing\n");
+		return -EFAULT;
+	}
+	spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
+	skb = fmdev->resp_skb;
+	fmdev->resp_skb = NULL;
+	spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);
+
+	evt_hdr = (void *)skb->data;
+	if (evt_hdr->status != 0) {
+		fmerr("Received event pkt status(%d) is not zero\n",
+			   evt_hdr->status);
+		kfree_skb(skb);
+		return -EIO;
+	}
+	/* Send response data to caller */
+	if (response != NULL && response_len != NULL && evt_hdr->dlen) {
+		/* Skip header info and copy only response data */
+		skb_pull(skb, sizeof(struct fm_event_msg_hdr));
+		memcpy(response, skb->data, evt_hdr->dlen);
+		*response_len = evt_hdr->dlen;
+	} else if (response_len != NULL && evt_hdr->dlen == 0) {
+		*response_len = 0;
+	}
+	kfree_skb(skb);
+
+	return 0;
+}
+
+/* --- Helper functions used in FM interrupt handlers ---*/
+static inline u32 check_cmdresp_status(struct fmdev *fmdev,
+		struct sk_buff **skb)
+{
+	struct fm_event_msg_hdr *fm_evt_hdr;
+	unsigned long flags;
+
+	del_timer(&fmdev->irq_info.timer);
+
+	spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
+	*skb = fmdev->resp_skb;
+	fmdev->resp_skb = NULL;
+	spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);
+
+	fm_evt_hdr = (void *)(*skb)->data;
+	if (fm_evt_hdr->status != 0) {
+		fmerr("irq: opcode %x response status is not zero "
+				"Initiating irq recovery process\n",
+				fm_evt_hdr->op);
+
+		mod_timer(&fmdev->irq_info.timer, jiffies + FM_DRV_TX_TIMEOUT);
+		return -1;
+	}
+
+	return 0;
+}
+
+static inline void fm_irq_common_cmd_resp_helper(struct fmdev *fmdev, u8 stage)
+{
+	struct sk_buff *skb;
+
+	if (!check_cmdresp_status(fmdev, &skb))
+		fm_irq_call_stage(fmdev, stage);
+}
+
+/*
+ * Interrupt process timeout handler.
+ * One of the irq handler did not get proper response from the chip. So take
+ * recovery action here. FM interrupts are disabled in the beginning of
+ * interrupt process. Therefore reset stage index to re-enable default
+ * interrupts. So that next interrupt will be processed as usual.
+ */
+static void int_timeout_handler(unsigned long data)
+{
+	struct fmdev *fmdev;
+	struct fm_irq *fmirq;
+
+	fmdbg("irq: timeout,trying to re-enable fm interrupts\n");
+	fmdev = (struct fmdev *)data;
+	fmirq = &fmdev->irq_info;
+	fmirq->retry++;
+
+	if (fmirq->retry > FM_IRQ_TIMEOUT_RETRY_MAX) {
+		/* Stop recovery action (interrupt reenable process) and
+		 * reset stage index & retry count values */
+		fmirq->stage = 0;
+		fmirq->retry = 0;
+		fmerr("Recovery action failed during"
+				"irq processing, max retry reached\n");
+		return;
+	}
+	fm_irq_call_stage(fmdev, FM_SEND_INTMSK_CMD_IDX);
+}
+
+/* --------- FM interrupt handlers ------------*/
+static void fm_irq_send_flag_getcmd(struct fmdev *fmdev)
+{
+	u16 flag;
+
+	/* Send FLAG_GET command , to know the source of interrupt */
+	if (!fm_send_cmd(fmdev, FLAG_GET, REG_RD, NULL, sizeof(flag), NULL))
+		fm_irq_timeout_stage(fmdev, FM_HANDLE_FLAG_GETCMD_RESP_IDX);
+}
+
+static void fm_irq_handle_flag_getcmd_resp(struct fmdev *fmdev)
+{
+	struct sk_buff *skb;
+	struct fm_event_msg_hdr *fm_evt_hdr;
+
+	if (check_cmdresp_status(fmdev, &skb))
+		return;
+
+	fm_evt_hdr = (void *)skb->data;
+
+	/* Skip header info and copy only response data */
+	skb_pull(skb, sizeof(struct fm_event_msg_hdr));
+	memcpy(&fmdev->irq_info.flag, skb->data, fm_evt_hdr->dlen);
+
+	fmdev->irq_info.flag = be16_to_cpu(fmdev->irq_info.flag);
+	fmdbg("irq: flag register(0x%x)\n", fmdev->irq_info.flag);
+
+	/* Continue next function in interrupt handler table */
+	fm_irq_call_stage(fmdev, FM_HW_MAL_FUNC_IDX);
+}
+
+static void fm_irq_handle_hw_malfunction(struct fmdev *fmdev)
+{
+	if (fmdev->irq_info.flag & FM_MAL_EVENT & fmdev->irq_info.mask)
+		fmerr("irq: HW MAL int received - do nothing\n");
+
+	/* Continue next function in interrupt handler table */
+	fm_irq_call_stage(fmdev, FM_RDS_START_IDX);
+}
+
+static void fm_irq_handle_rds_start(struct fmdev *fmdev)
+{
+	if (fmdev->irq_info.flag & FM_RDS_EVENT & fmdev->irq_info.mask) {
+		fmdbg("irq: rds threshold reached\n");
+		fmdev->irq_info.stage = FM_RDS_SEND_RDS_GETCMD_IDX;
+	} else {
+		/* Continue next function in interrupt handler table */
+		fmdev->irq_info.stage = FM_HW_TUNE_OP_ENDED_IDX;
+	}
+
+	fm_irq_call(fmdev);
+}
+
+static void fm_irq_send_rdsdata_getcmd(struct fmdev *fmdev)
+{
+	/* Send the command to read RDS data from the chip */
+	if (!fm_send_cmd(fmdev, RDS_DATA_GET, REG_RD, NULL,
+			    (FM_RX_RDS_FIFO_THRESHOLD * 3), NULL))
+		fm_irq_timeout_stage(fmdev, FM_RDS_HANDLE_RDS_GETCMD_RESP_IDX);
+}
+
+/* Keeps track of current RX channel AF (Alternate Frequency) */
+static void fm_rx_update_af_cache(struct fmdev *fmdev, u8 af)
+{
+	struct tuned_station_info *stat_info = &fmdev->rx.stat_info;
+	u8 reg_idx = fmdev->rx.region.fm_band;
+	u8 index;
+	u32 freq;
+
+	/* First AF indicates the number of AF follows. Reset the list */
+	if ((af >= FM_RDS_1_AF_FOLLOWS) && (af <= FM_RDS_25_AF_FOLLOWS)) {
+		fmdev->rx.stat_info.af_list_max = (af - FM_RDS_1_AF_FOLLOWS + 1);
+		fmdev->rx.stat_info.afcache_size = 0;
+		fmdbg("No of expected AF : %d\n",fmdev->rx.stat_info.af_list_max);
+		return;
+	}
+
+	if (af < FM_RDS_MIN_AF)
+		return;
+	if (reg_idx == FM_BAND_EUROPE_US && af > FM_RDS_MAX_AF)
+		return;
+	if (reg_idx == FM_BAND_JAPAN && af > FM_RDS_MAX_AF_JAPAN)
+		return;
+
+	freq = fmdev->rx.region.bot_freq + (af * 100);
+	if (freq == fmdev->rx.freq) {
+		fmdbg("Current freq(%d) is matching with received AF(%d)\n",
+				fmdev->rx.freq, freq);
+		return;
+	}
+	/* Do check in AF cache */
+	for (index = 0; index < stat_info->afcache_size; index++) {
+		if (stat_info->af_cache[index] == freq)
+			break;
+	}
+	/* Reached the limit of the list - ignore the next AF */
+	if (index == stat_info->af_list_max) {
+		fmdbg("AF cache is full\n");
+		return;
+	}
+	/*
+	 * If we reached the end of the list then this AF is not
+	 * in the list - add it.
+	 */
+	if (index == stat_info->afcache_size) {
+		fmdbg("Storing AF %d to cache index %d\n",freq, index);
+		stat_info->af_cache[index] = freq;
+		stat_info->afcache_size++;
+	}
+}
+
+/*
+ * Converts RDS buffer data from big endian format
+ * to little endian format.
+ */
+static void fm_rdsparse_swapbytes(struct fmdev *fmdev,
+		struct fm_rdsdata_format *rds_format)
+{
+	u8 byte1;
+	u8 index = 0;
+	u8 *rds_buff;
+
+	/*
+	 * Since in Orca the 2 RDS Data bytes are in little endian and
+	 * in Dolphin they are in big endian, the parsing of the RDS data
+	 * is chip dependent
+	 */
+	if (fmdev->asci_id != 0x6350) {
+		rds_buff = &rds_format->data.groupdatabuff.buff[0];
+		while (index + 1 < FM_RX_RDS_INFO_FIELD_MAX) {
+			byte1 = rds_buff[index];
+			rds_buff[index] = rds_buff[index + 1];
+			rds_buff[index + 1] = byte1;
+			index += 2;
+		}
+	}
+}
+
+static void fm_irq_handle_rdsdata_getcmd_resp(struct fmdev *fmdev)
+{
+	struct sk_buff *skb;
+	struct fm_rdsdata_format rds_fmt;
+	struct fm_rds *rds = &fmdev->rx.rds;
+	unsigned long group_idx, flags;
+	u8 *rds_data, meta_data, tmpbuf[3];
+	u8 type, blk_idx;
+	u16 cur_picode;
+	u32 rds_len;
+
+	if (check_cmdresp_status(fmdev, &skb))
+		return;
+
+	/* Skip header info */
+	skb_pull(skb, sizeof(struct fm_event_msg_hdr));
+	rds_data = skb->data;
+	rds_len = skb->len;
+
+	/* Parse the RDS data */
+	while (rds_len >= FM_RDS_BLK_SIZE) {
+		meta_data = rds_data[2];
+		/* Get the type: 0=A, 1=B, 2=C, 3=C', 4=D, 5=E */
+		type = (meta_data & 0x07);
+
+		/* Transform the blk type into index sequence (0, 1, 2, 3, 4) */
+		blk_idx = (type <= FM_RDS_BLOCK_C ? type : (type - 1));
+		fmdbg("Block index:%d(%s)\n", blk_idx,
+			   (meta_data & FM_RDS_STATUS_ERR_MASK) ? "Bad" : "Ok");
+
+		if ((meta_data & FM_RDS_STATUS_ERR_MASK) != 0)
+			break;
+
+		if (blk_idx < FM_RDS_BLK_IDX_A || blk_idx > FM_RDS_BLK_IDX_D) {
+			fmdbg("Block sequence mismatch\n");
+			rds->last_blk_idx = -1;
+			break;
+		}
+
+		/* Skip checkword (control) byte and copy only data byte */
+		memcpy(&rds_fmt.data.groupdatabuff.
+				buff[blk_idx * (FM_RDS_BLK_SIZE - 1)],
+				rds_data, (FM_RDS_BLK_SIZE - 1));
+
+		rds->last_blk_idx = blk_idx;
+
+		/* If completed a whole group then handle it */
+		if (blk_idx == FM_RDS_BLK_IDX_D) {
+			fmdbg("Good block received\n");
+			fm_rdsparse_swapbytes(fmdev, &rds_fmt);
+
+			/*
+			 * Extract PI code and store in local cache.
+			 * We need this during AF switch processing.
+			 */
+			cur_picode = be16_to_cpu(rds_fmt.data.groupgeneral.pidata);
+			if (fmdev->rx.stat_info.picode != cur_picode)
+				fmdev->rx.stat_info.picode = cur_picode;
+
+			fmdbg("picode:%d\n", cur_picode);
+
+			group_idx = (rds_fmt.data.groupgeneral.blk_b[0] >> 3);
+			fmdbg("(fmdrv):Group:%ld%s\n", group_idx/2,
+					(group_idx % 2) ? "B" : "A");
+
+			group_idx = 1 << (rds_fmt.data.groupgeneral.blk_b[0] >> 3);
+			if (group_idx == FM_RDS_GROUP_TYPE_MASK_0A) {
+				fm_rx_update_af_cache(fmdev, rds_fmt.data.group0A.af[0]);
+				fm_rx_update_af_cache(fmdev, rds_fmt.data.group0A.af[1]);
+			}
+		}
+		rds_len -= FM_RDS_BLK_SIZE;
+		rds_data += FM_RDS_BLK_SIZE;
+	}
+
+	/* Copy raw rds data to internal rds buffer */
+	rds_data = skb->data;
+	rds_len = skb->len;
+
+	spin_lock_irqsave(&fmdev->rds_buff_lock, flags);
+	while (rds_len > 0) {
+		/*
+		 * Fill RDS buffer as per V4L2 specification.
+		 * Store control byte
+		 */
+		type = (rds_data[2] & 0x07);
+		blk_idx = (type <= FM_RDS_BLOCK_C ? type : (type - 1));
+		tmpbuf[2] = blk_idx;	/* Offset name */
+		tmpbuf[2] |= blk_idx << 3;	/* Received offset */
+
+		/* Store data byte */
+		tmpbuf[0] = rds_data[0];
+		tmpbuf[1] = rds_data[1];
+
+		memcpy(&rds->buff[rds->wr_idx], &tmpbuf, FM_RDS_BLK_SIZE);
+		rds->wr_idx = (rds->wr_idx + FM_RDS_BLK_SIZE) % rds->buf_size;
+
+		/* Check for overflow & start over */
+		if (rds->wr_idx == rds->rd_idx) {
+			fmdbg("RDS buffer overflow\n");
+			rds->wr_idx = 0;
+			rds->rd_idx = 0;
+			break;
+		}
+		rds_len -= FM_RDS_BLK_SIZE;
+		rds_data += FM_RDS_BLK_SIZE;
+	}
+	spin_unlock_irqrestore(&fmdev->rds_buff_lock, flags);
+
+	/* Wakeup read queue */
+	if (rds->wr_idx != rds->rd_idx)
+		wake_up_interruptible(&rds->read_queue);
+
+	fm_irq_call_stage(fmdev, FM_RDS_FINISH_IDX);
+}
+
+static void fm_irq_handle_rds_finish(struct fmdev *fmdev)
+{
+	fm_irq_call_stage(fmdev, FM_HW_TUNE_OP_ENDED_IDX);
+}
+
+static void fm_irq_handle_tune_op_ended(struct fmdev *fmdev)
+{
+	if (fmdev->irq_info.flag & (FM_FR_EVENT | FM_BL_EVENT) & fmdev->
+	    irq_info.mask) {
+		fmdbg("irq: tune ended/bandlimit reached\n");
+		if (test_and_clear_bit(FM_AF_SWITCH_INPROGRESS, &fmdev->flag)) {
+			fmdev->irq_info.stage = FM_AF_JUMP_RD_FREQ_IDX;
+		} else {
+			complete(&fmdev->maintask_comp);
+			fmdev->irq_info.stage = FM_HW_POWER_ENB_IDX;
+		}
+	} else
+		fmdev->irq_info.stage = FM_HW_POWER_ENB_IDX;
+
+	fm_irq_call(fmdev);
+}
+
+static void fm_irq_handle_power_enb(struct fmdev *fmdev)
+{
+	if (fmdev->irq_info.flag & FM_POW_ENB_EVENT) {
+		fmdbg("irq: Power Enabled/Disabled\n");
+		complete(&fmdev->maintask_comp);
+	}
+
+	fm_irq_call_stage(fmdev, FM_LOW_RSSI_START_IDX);
+}
+
+static void fm_irq_handle_low_rssi_start(struct fmdev *fmdev)
+{
+	if ((fmdev->rx.af_mode == FM_RX_RDS_AF_SWITCH_MODE_ON) &&
+	    (fmdev->irq_info.flag & FM_LEV_EVENT & fmdev->irq_info.mask) &&
+	    (fmdev->rx.freq != FM_UNDEFINED_FREQ) &&
+	    (fmdev->rx.stat_info.afcache_size != 0)) {
+		fmdbg("irq: rssi level has fallen below threshold level\n");
+
+		/* Disable further low RSSI interrupts */
+		fmdev->irq_info.mask &= ~FM_LEV_EVENT;
+
+		fmdev->rx.afjump_idx = 0;
+		fmdev->rx.freq_before_jump = fmdev->rx.freq;
+		fmdev->irq_info.stage = FM_AF_JUMP_SETPI_IDX;
+	} else {
+		/* Continue next function in interrupt handler table */
+		fmdev->irq_info.stage = FM_SEND_INTMSK_CMD_IDX;
+	}
+
+	fm_irq_call(fmdev);
+}
+
+static void fm_irq_afjump_set_pi(struct fmdev *fmdev)
+{
+	u16 payload;
+
+	/* Set PI code - must be updated if the AF list is not empty */
+	payload = fmdev->rx.stat_info.picode;
+	if (!fm_send_cmd(fmdev, RDS_PI_SET, REG_WR, &payload, sizeof(payload), NULL))
+		fm_irq_timeout_stage(fmdev, FM_AF_JUMP_HANDLE_SETPI_RESP_IDX);
+}
+
+static void fm_irq_handle_set_pi_resp(struct fmdev *fmdev)
+{
+	fm_irq_common_cmd_resp_helper(fmdev, FM_AF_JUMP_SETPI_MASK_IDX);
+}
+
+/*
+ * Set PI mask.
+ * 0xFFFF = Enable PI code matching
+ * 0x0000 = Disable PI code matching
+ */
+static void fm_irq_afjump_set_pimask(struct fmdev *fmdev)
+{
+	u16 payload;
+
+	payload = 0x0000;
+	if (!fm_send_cmd(fmdev, RDS_PI_MASK_SET, REG_WR, &payload, sizeof(payload), NULL))
+		fm_irq_timeout_stage(fmdev, FM_AF_JUMP_HANDLE_SETPI_MASK_RESP_IDX);
+}
+
+static void fm_irq_handle_set_pimask_resp(struct fmdev *fmdev)
+{
+	fm_irq_common_cmd_resp_helper(fmdev, FM_AF_JUMP_SET_AF_FREQ_IDX);
+}
+
+static void fm_irq_afjump_setfreq(struct fmdev *fmdev)
+{
+	u16 frq_index;
+	u16 payload;
+
+	fmdbg("Swtich to %d KHz\n", fmdev->rx.stat_info.af_cache[fmdev->rx.afjump_idx]);
+	frq_index = (fmdev->rx.stat_info.af_cache[fmdev->rx.afjump_idx] -
+	     fmdev->rx.region.bot_freq) / FM_FREQ_MUL;
+
+	payload = frq_index;
+	if (!fm_send_cmd(fmdev, AF_FREQ_SET, REG_WR, &payload, sizeof(payload), NULL))
+		fm_irq_timeout_stage(fmdev, FM_AF_JUMP_HANDLE_SET_AFFREQ_RESP_IDX);
+}
+
+static void fm_irq_handle_setfreq_resp(struct fmdev *fmdev)
+{
+	fm_irq_common_cmd_resp_helper(fmdev, FM_AF_JUMP_ENABLE_INT_IDX);
+}
+
+static void fm_irq_afjump_enableint(struct fmdev *fmdev)
+{
+	u16 payload;
+
+	/* Enable FR (tuning operation ended) interrupt */
+	payload = FM_FR_EVENT;
+	if (!fm_send_cmd(fmdev, INT_MASK_SET, REG_WR, &payload, sizeof(payload), NULL))
+		fm_irq_timeout_stage(fmdev, FM_AF_JUMP_ENABLE_INT_RESP_IDX);
+}
+
+static void fm_irq_afjump_enableint_resp(struct fmdev *fmdev)
+{
+	fm_irq_common_cmd_resp_helper(fmdev, FM_AF_JUMP_START_AFJUMP_IDX);
+}
+
+static void fm_irq_start_afjump(struct fmdev *fmdev)
+{
+	u16 payload;
+
+	payload = FM_TUNER_AF_JUMP_MODE;
+	if (!fm_send_cmd(fmdev, TUNER_MODE_SET, REG_WR, &payload,
+			sizeof(payload), NULL))
+		fm_irq_timeout_stage(fmdev, FM_AF_JUMP_HANDLE_START_AFJUMP_RESP_IDX);
+}
+
+static void fm_irq_handle_start_afjump_resp(struct fmdev *fmdev)
+{
+	struct sk_buff *skb;
+
+	if (check_cmdresp_status(fmdev, &skb))
+		return;
+
+	fmdev->irq_info.stage = FM_SEND_FLAG_GETCMD_IDX;
+	set_bit(FM_AF_SWITCH_INPROGRESS, &fmdev->flag);
+	clear_bit(FM_INTTASK_RUNNING, &fmdev->flag);
+}
+
+static void fm_irq_afjump_rd_freq(struct fmdev *fmdev)
+{
+	u16 payload;
+
+	if (!fm_send_cmd(fmdev, FREQ_SET, REG_RD, NULL, sizeof(payload), NULL));
+		fm_irq_timeout_stage(fmdev, FM_AF_JUMP_RD_FREQ_RESP_IDX);
+}
+
+static void fm_irq_afjump_rd_freq_resp(struct fmdev *fmdev)
+{
+	struct sk_buff *skb;
+	u16 read_freq;
+	u32 curr_freq, jumped_freq;
+
+	if (check_cmdresp_status(fmdev, &skb))
+		return;
+
+	/* Skip header info and copy only response data */
+	skb_pull(skb, sizeof(struct fm_event_msg_hdr));
+	memcpy(&read_freq, skb->data, sizeof(read_freq));
+	read_freq = be16_to_cpu(read_freq);
+	curr_freq = fmdev->rx.region.bot_freq + ((u32)read_freq * FM_FREQ_MUL);
+
+	jumped_freq = fmdev->rx.stat_info.af_cache[fmdev->rx.afjump_idx];
+
+	/* If the frequency was changed the jump succeeded */
+	if ((curr_freq != fmdev->rx.freq_before_jump) && (curr_freq == jumped_freq)) {
+		fmdbg("Successfully switched to alternate freq %d\n", curr_freq);
+		fmdev->rx.freq = curr_freq;
+		fm_rx_reset_rds_cache(fmdev);
+
+		/* AF feature is on, enable low level RSSI interrupt */
+		if (fmdev->rx.af_mode == FM_RX_RDS_AF_SWITCH_MODE_ON)
+			fmdev->irq_info.mask |= FM_LEV_EVENT;
+
+		fmdev->irq_info.stage = FM_LOW_RSSI_FINISH_IDX;
+	} else {		/* jump to the next freq in the AF list */
+		fmdev->rx.afjump_idx++;
+
+		/* If we reached the end of the list - stop searching */
+		if (fmdev->rx.afjump_idx >= fmdev->rx.stat_info.afcache_size) {
+			fmdbg("AF switch processing failed\n");
+			fmdev->irq_info.stage = FM_LOW_RSSI_FINISH_IDX;
+		} else {	/* AF List is not over - try next one */
+
+			fmdbg("Trying next freq in AF cache\n");
+			fmdev->irq_info.stage = FM_AF_JUMP_SETPI_IDX;
+		}
+	}
+	fm_irq_call(fmdev);
+}
+
+static void fm_irq_handle_low_rssi_finish(struct fmdev *fmdev)
+{
+	fm_irq_call_stage(fmdev, FM_SEND_INTMSK_CMD_IDX);
+}
+
+static void fm_irq_send_intmsk_cmd(struct fmdev *fmdev)
+{
+	u16 payload;
+
+	/* Re-enable FM interrupts */
+	payload = fmdev->irq_info.mask;
+
+	if (!fm_send_cmd(fmdev, INT_MASK_SET, REG_WR, &payload,
+			sizeof(payload), NULL))
+		fm_irq_timeout_stage(fmdev, FM_HANDLE_INTMSK_CMD_RESP_IDX);
+}
+
+static void fm_irq_handle_intmsk_cmd_resp(struct fmdev *fmdev)
+{
+	struct sk_buff *skb;
+
+	if (check_cmdresp_status(fmdev, &skb))
+		return;
+	/*
+	 * This is last function in interrupt table to be executed.
+	 * So, reset stage index to 0.
+	 */
+	fmdev->irq_info.stage = FM_SEND_FLAG_GETCMD_IDX;
+
+	/* Start processing any pending interrupt */
+	if (test_and_clear_bit(FM_INTTASK_SCHEDULE_PENDING, &fmdev->flag)) {
+		fmdev->irq_info.handlers[fmdev->irq_info.stage](fmdev);
+	} else
+		clear_bit(FM_INTTASK_RUNNING, &fmdev->flag);
+}
+
+/* Returns availability of RDS data in internel buffer */
+u32 fmc_is_rds_data_available(struct fmdev *fmdev, struct file *file,
+				struct poll_table_struct *pts)
+{
+	poll_wait(file, &fmdev->rx.rds.read_queue, pts);
+	if (fmdev->rx.rds.rd_idx != fmdev->rx.rds.wr_idx)
+		return 0;
+
+	return -EAGAIN;
+}
+
+/* Copies RDS data from internal buffer to user buffer */
+u32 fmc_transfer_rds_from_internal_buff(struct fmdev *fmdev, struct file *file,
+		u8 __user *buf, size_t count)
+{
+	u32 block_count;
+	unsigned long flags;
+	int ret;
+
+	if (fmdev->rx.rds.wr_idx == fmdev->rx.rds.rd_idx) {
+		if (file->f_flags & O_NONBLOCK)
+			return -EWOULDBLOCK;
+
+		ret = wait_event_interruptible(fmdev->rx.rds.read_queue,
+				(fmdev->rx.rds.wr_idx != fmdev->rx.rds.rd_idx));
+		if (ret)
+			return -EINTR;
+	}
+
+	/* Calculate block count from byte count */
+	count /= 3;
+	block_count = 0;
+	ret = 0;
+
+	spin_lock_irqsave(&fmdev->rds_buff_lock, flags);
+
+	while (block_count < count) {
+		if (fmdev->rx.rds.wr_idx == fmdev->rx.rds.rd_idx)
+			break;
+
+		if (copy_to_user(buf, &fmdev->rx.rds.buff[fmdev->rx.rds.rd_idx],
+					FM_RDS_BLK_SIZE))
+			break;
+
+		fmdev->rx.rds.rd_idx += FM_RDS_BLK_SIZE;
+		if (fmdev->rx.rds.rd_idx >= fmdev->rx.rds.buf_size)
+			fmdev->rx.rds.rd_idx = 0;
+
+		block_count++;
+		buf += FM_RDS_BLK_SIZE;
+		ret += FM_RDS_BLK_SIZE;
+	}
+	spin_unlock_irqrestore(&fmdev->rds_buff_lock, flags);
+	return ret;
+}
+
+u32 fmc_set_freq(struct fmdev *fmdev, u32 freq_to_set)
+{
+	switch (fmdev->curr_fmmode) {
+	case FM_MODE_RX:
+		return fm_rx_set_freq(fmdev, freq_to_set);
+		break;
+
+	case FM_MODE_TX:
+		return fm_tx_set_freq(fmdev, freq_to_set);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+u32 fmc_get_freq(struct fmdev *fmdev, u32 *cur_tuned_frq)
+{
+	if (fmdev->rx.freq == FM_UNDEFINED_FREQ) {
+		fmerr("RX frequency is not set\n");
+		return -EPERM;
+	}
+	if (cur_tuned_frq == NULL) {
+		fmerr("Invalid memory\n");
+		return -ENOMEM;
+	}
+
+	switch (fmdev->curr_fmmode) {
+	case FM_MODE_RX:
+		*cur_tuned_frq = fmdev->rx.freq;
+		break;
+
+	case FM_MODE_TX:
+		*cur_tuned_frq = 0;	/* TODO : Change this later */
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+u32 fmc_set_region(struct fmdev *fmdev, u8 region_to_set)
+{
+	switch (fmdev->curr_fmmode) {
+	case FM_MODE_RX:
+		return fm_rx_set_region(fmdev, region_to_set);
+		break;
+
+	case FM_MODE_TX:
+		return fm_tx_set_region(fmdev, region_to_set);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+u32 fmc_set_mute_mode(struct fmdev *fmdev, u8 mute_mode_toset)
+{
+	switch (fmdev->curr_fmmode) {
+	case FM_MODE_RX:
+		return fm_rx_set_mute_mode(fmdev, mute_mode_toset);
+		break;
+
+	case FM_MODE_TX:
+		return fm_tx_set_mute_mode(fmdev, mute_mode_toset);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+u32 fmc_set_stereo_mono(struct fmdev *fmdev, u16 mode)
+{
+	switch (fmdev->curr_fmmode) {
+	case FM_MODE_RX:
+		return fm_rx_set_stereo_mono(fmdev, mode);
+		break;
+
+	case FM_MODE_TX:
+		return fm_tx_set_stereo_mono(fmdev, mode);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+u32 fmc_set_rds_mode(struct fmdev *fmdev, u8 rds_en_dis)
+{
+	switch (fmdev->curr_fmmode) {
+	case FM_MODE_RX:
+		return fm_rx_set_rds_mode(fmdev, rds_en_dis);
+		break;
+
+	case FM_MODE_TX:
+		return fm_tx_set_rds_mode(fmdev, rds_en_dis);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+/* Sends power off command to the chip */
+static u32 fm_power_down(struct fmdev *fmdev)
+{
+	u16 payload;
+	u32 ret = 0;
+
+	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
+		fmerr("FM core is not ready\n");
+		return -EPERM;
+	}
+	if (fmdev->curr_fmmode == FM_MODE_OFF) {
+		fmdbg("FM chip is already in OFF state\n");
+		return ret;
+	}
+
+	payload = 0x0;
+	ret = fmc_send_cmd(fmdev, FM_POWER_MODE, REG_WR, &payload,
+		sizeof(payload), NULL, NULL);
+	if (ret < 0)
+		return ret;
+
+	ret = fmc_release(fmdev);
+
+	return ret;
+}
+
+/* Reads init command from FM firmware file and loads to the chip */
+static u32 fm_download_firmware(struct fmdev *fmdev, const u8 *fw_name)
+{
+	const struct firmware *fw_entry;
+	struct bts_header *fw_header;
+	struct bts_action *action;
+	struct bts_action_delay *delay;
+	u8 *fw_data;
+	int ret, fw_len, cmd_cnt;
+
+	cmd_cnt = 0;
+	set_bit(FM_FW_DW_INPROGRESS, &fmdev->flag);
+
+	ret = request_firmware(&fw_entry, fw_name,
+				&fmdev->radio_dev->dev);
+	if (ret < 0) {
+		fmerr("Unable to read firmware(%s) content\n", fw_name);
+		return ret;
+	}
+	fmdbg("Firmware(%s) length : %d bytes\n", fw_name, fw_entry->size);
+
+	fw_data = (void *)fw_entry->data;
+	fw_len = fw_entry->size;
+
+	fw_header = (struct bts_header *)fw_data;
+	if (fw_header->magic != FM_FW_FILE_HEADER_MAGIC) {
+		fmerr("%s not a legal TI firmware file\n", fw_name);
+		ret = -EINVAL;
+		goto rel_fw;
+	}
+	fmdbg("FW(%s) magic number : 0x%x\n", fw_name, fw_header->magic);
+
+	/* Skip file header info , we already verified it */
+	fw_data += sizeof(struct bts_header);
+	fw_len -= sizeof(struct bts_header);
+
+	while (fw_data && fw_len > 0) {
+		action = (struct bts_action *)fw_data;
+
+		switch (action->type) {
+		case ACTION_SEND_COMMAND:	/* Send */
+			if (fmc_send_cmd(fmdev, 0, 0, action->data,
+						action->size, NULL, NULL))
+				goto rel_fw;
+
+			cmd_cnt++;
+			break;
+
+		case ACTION_DELAY:	/* Delay */
+			delay = (struct bts_action_delay *)action->data;
+			mdelay(delay->msec);
+			break;
+		}
+
+		fw_data += (sizeof(struct bts_action) + (action->size));
+		fw_len -= (sizeof(struct bts_action) + (action->size));
+	}
+	fmdbg("Firmare commands(%d) loaded to chip\n", cmd_cnt);
+rel_fw:
+	release_firmware(fw_entry);
+	clear_bit(FM_FW_DW_INPROGRESS, &fmdev->flag);
+
+	return ret;
+}
+
+/* Loads default RX configuration to the chip */
+static u32 load_default_rx_configuration(struct fmdev *fmdev)
+{
+	int ret;
+
+	ret = fm_rx_set_volume(fmdev, FM_DEFAULT_RX_VOLUME);
+	if (ret < 0)
+		return ret;
+
+	ret = fm_rx_set_rssi_threshold(fmdev, FM_DEFAULT_RSSI_THRESHOLD);
+	return ret;
+}
+
+/* Does FM power on sequence */
+static u32 fm_power_up(struct fmdev *fmdev, u8 mode)
+{
+	u16 payload, asic_id, asic_ver;
+	int resp_len, ret;
+	u8 fw_name[50];
+
+	if (mode >= FM_MODE_ENTRY_MAX) {
+		fmerr("Invalid firmware download option\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Initialize FM common module. FM GPIO toggling is
+	 * taken care in Shared Transport driver.
+	 */
+	ret = fmc_prepare(fmdev);
+	if (ret < 0) {
+		fmerr("Unable to prepare FM Common\n");
+		return ret;
+	}
+
+	payload = FM_ENABLE;
+	if (fmc_send_cmd(fmdev, FM_POWER_MODE, REG_WR, &payload,
+			sizeof(payload), NULL, NULL))
+		goto rel;
+
+	/* Allow the chip to settle down in Channel-8 mode */
+	msleep(20);
+
+	if (fmc_send_cmd(fmdev, ASIC_ID_GET, REG_RD, NULL,
+			sizeof(asic_id), &asic_id, &resp_len))
+		goto rel;
+
+	if (fmc_send_cmd(fmdev, ASIC_VER_GET, REG_RD, NULL,
+			sizeof(asic_ver), &asic_ver, &resp_len))
+		goto rel;
+
+	fmdbg("ASIC ID: 0x%x , ASIC Version: %d\n",
+		be16_to_cpu(asic_id), be16_to_cpu(asic_ver));
+
+	sprintf(fw_name, "%s_%x.%d.bts", FM_FMC_FW_FILE_START,
+		be16_to_cpu(asic_id), be16_to_cpu(asic_ver));
+
+	ret = fm_download_firmware(fmdev, fw_name);
+	if (ret < 0) {
+		fmdbg("Failed to download firmware file %s\n", fw_name);
+		goto rel;
+	}
+	sprintf(fw_name, "%s_%x.%d.bts", (mode == FM_MODE_RX) ?
+			FM_RX_FW_FILE_START : FM_TX_FW_FILE_START,
+			be16_to_cpu(asic_id), be16_to_cpu(asic_ver));
+
+	ret = fm_download_firmware(fmdev, fw_name);
+	if (ret < 0) {
+		fmdbg("Failed to download firmware file %s\n", fw_name);
+		goto rel;
+	} else
+		return ret;
+rel:
+	fmc_release(fmdev);
+
+	return ret;
+}
+
+/* Set FM Modes(TX, RX, OFF) */
+u32 fmc_set_mode(struct fmdev *fmdev, u8 fm_mode)
+{
+	int ret = 0;
+
+	if (fm_mode >= FM_MODE_ENTRY_MAX) {
+		fmerr("Invalid FM mode\n");
+		return -EINVAL;
+	}
+	if (fmdev->curr_fmmode == fm_mode) {
+		fmdbg("Already fm is in mode(%d)\n", fm_mode);
+		return ret;
+	}
+
+	switch (fm_mode) {
+	case FM_MODE_OFF:	/* OFF Mode */
+		ret = fm_power_down(fmdev);
+		if (ret < 0) {
+			fmerr("Failed to set OFF mode\n");
+			return ret;
+		}
+		break;
+
+	case FM_MODE_TX:	/* TX Mode */
+	case FM_MODE_RX:	/* RX Mode */
+		/* Power down before switching to TX or RX mode */
+		if (fmdev->curr_fmmode != FM_MODE_OFF) {
+			ret = fm_power_down(fmdev);
+			if (ret < 0) {
+				fmerr("Failed to set OFF mode\n");
+				return ret;
+			}
+			msleep(30);
+		}
+		ret = fm_power_up(fmdev, fm_mode);
+		if (ret < 0) {
+			fmerr("Failed to load firmware\n");
+			return ret;
+		}
+	}
+	fmdev->curr_fmmode = fm_mode;
+
+	/* Set default configuration */
+	if (fmdev->curr_fmmode == FM_MODE_RX) {
+		fmdbg("Loading default rx configuration..\n");
+		ret = load_default_rx_configuration(fmdev);
+		if (ret < 0)
+			fmerr("Failed to load default values\n");
+	}
+
+	return ret;
+}
+
+/* Returns current FM mode (TX, RX, OFF) */
+u32 fmc_get_mode(struct fmdev *fmdev, u8 *fmmode)
+{
+	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
+		fmerr("FM core is not ready\n");
+		return -EPERM;
+	}
+	if (fmmode == NULL) {
+		fmerr("Invalid memory\n");
+		return -ENOMEM;
+	}
+
+	*fmmode = fmdev->curr_fmmode;
+	return 0;
+}
+
+/* Called by ST layer when FM packet is available */
+static long fm_st_receive(void *arg, struct sk_buff *skb)
+{
+	struct fmdev *fmdev;
+
+	fmdev = (struct fmdev *)arg;
+
+	if (skb == NULL) {
+		fmerr("Invalid SKB received from ST\n");
+		return -EFAULT;
+	}
+
+	if (skb->cb[0] != FM_PKT_LOGICAL_CHAN_NUMBER) {
+		fmerr("Received SKB (%p) is not FM Channel 8 pkt\n", skb);
+		return -EINVAL;
+	}
+
+	memcpy(skb_push(skb, 1), &skb->cb[0], 1);
+	skb_queue_tail(&fmdev->rx_q, skb);
+	tasklet_schedule(&fmdev->rx_task);
+
+	return 0;
+}
+
+/*
+ * Called by ST layer to indicate protocol registration completion
+ * status.
+ */
+static void fm_st_reg_comp_cb(void *arg, char data)
+{
+	struct fmdev *fmdev;
+
+	fmdev = (struct fmdev *)arg;
+	fmdev->streg_cbdata = data;
+	complete(&wait_for_fmdrv_reg_comp);
+}
+
+/*
+ * This function will be called from FM V4L2 open function.
+ * Register with ST driver and initialize driver data.
+ */
+u32 fmc_prepare(struct fmdev *fmdev)
+{
+	static struct st_proto_s fm_st_proto;
+	u32 ret = 0;
+
+	if (test_bit(FM_CORE_READY, &fmdev->flag)) {
+		fmdbg("FM Core is already up\n");
+		return ret;
+	}
+
+	memset(&fm_st_proto, 0, sizeof(fm_st_proto));
+	fm_st_proto.type = ST_FM;
+	fm_st_proto.recv = fm_st_receive;
+	fm_st_proto.match_packet = NULL;
+	fm_st_proto.reg_complete_cb = fm_st_reg_comp_cb;
+	fm_st_proto.write = NULL; /* TI ST driver will fill write pointer */
+	fm_st_proto.priv_data = fmdev;
+
+	ret = st_register(&fm_st_proto);
+	if (ret == -EINPROGRESS) {
+		init_completion(&wait_for_fmdrv_reg_comp);
+		fmdev->streg_cbdata = -EINPROGRESS;
+		fmdbg("%s waiting for ST reg completion signal\n",__func__);
+
+		ret = wait_for_completion_timeout(&wait_for_fmdrv_reg_comp,
+				FM_ST_REG_TIMEOUT);
+
+		if (!ret) {
+			fmerr("Timeout(%d sec), didn't get reg "
+					"completion signal from ST\n",
+					jiffies_to_msecs(FM_ST_REG_TIMEOUT) / 1000);
+			return -ETIMEDOUT;
+		}
+		if (fmdev->streg_cbdata != 0) {
+			fmerr("ST reg comp CB called with error "
+					"status %d\n", fmdev->streg_cbdata);
+			return -EAGAIN;
+		}
+
+		ret = 0;
+	} else if (ret == -1) {
+		fmerr("st_register failed %d\n", ret);
+		return -EAGAIN;
+	}
+
+	if (fm_st_proto.write != NULL) {
+		g_st_write = fm_st_proto.write;
+	} else {
+		fmerr("Failed to get ST write func pointer\n");
+		ret = st_unregister(ST_FM);
+		if (ret < 0)
+			fmerr("st_unregister failed %d\n", ret);
+		return -EAGAIN;
+	}
+
+	spin_lock_init(&fmdev->rds_buff_lock);
+	spin_lock_init(&fmdev->resp_skb_lock);
+
+	/* Initialize TX queue and TX tasklet */
+	skb_queue_head_init(&fmdev->tx_q);
+	tasklet_init(&fmdev->tx_task, send_tasklet, (unsigned long)fmdev);
+
+	/* Initialize RX Queue and RX tasklet */
+	skb_queue_head_init(&fmdev->rx_q);
+	tasklet_init(&fmdev->rx_task, recv_tasklet, (unsigned long)fmdev);
+
+	fmdev->irq_info.stage = 0;
+	atomic_set(&fmdev->tx_cnt, 1);
+	fmdev->resp_comp = NULL;
+
+	init_timer(&fmdev->irq_info.timer);
+	fmdev->irq_info.timer.function = &int_timeout_handler;
+	fmdev->irq_info.timer.data = (unsigned long)fmdev;
+	/*TODO: add FM_STIC_EVENT later */
+	fmdev->irq_info.mask = FM_MAL_EVENT;
+
+	/* Region info */
+	memcpy(&fmdev->rx.region, &region_configs[default_radio_region],
+			sizeof(struct region_info));
+
+	fmdev->rx.mute_mode = FM_MUTE_OFF;
+	fmdev->rx.rf_depend_mute = FM_RX_RF_DEPENDENT_MUTE_OFF;
+	fmdev->rx.rds.flag = FM_RDS_DISABLE;
+	fmdev->rx.freq = FM_UNDEFINED_FREQ;
+	fmdev->rx.rds_mode = FM_RDS_SYSTEM_RDS;
+	fmdev->rx.af_mode = FM_RX_RDS_AF_SWITCH_MODE_OFF;
+	fmdev->irq_info.retry = 0;
+
+	fm_rx_reset_rds_cache(fmdev);
+	init_waitqueue_head(&fmdev->rx.rds.read_queue);
+
+	fm_rx_reset_station_info(fmdev);
+	set_bit(FM_CORE_READY, &fmdev->flag);
+
+	return ret;
+}
+
+/*
+ * This function will be called from FM V4L2 release function.
+ * Unregister from ST driver.
+ */
+u32 fmc_release(struct fmdev *fmdev)
+{
+	u32 ret;
+
+	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
+		fmdbg("FM Core is already down\n");
+		return 0;
+	}
+	/* Sevice pending read */
+	wake_up_interruptible(&fmdev->rx.rds.read_queue);
+
+	tasklet_kill(&fmdev->tx_task);
+	tasklet_kill(&fmdev->rx_task);
+
+	skb_queue_purge(&fmdev->tx_q);
+	skb_queue_purge(&fmdev->rx_q);
+
+	fmdev->resp_comp = NULL;
+	fmdev->rx.freq = 0;
+
+	ret = st_unregister(ST_FM);
+	if (ret < 0)
+		fmerr("Failed to de-register FM from ST %d\n", ret);
+	else
+		fmdbg("Successfully unregistered from ST\n");
+
+	clear_bit(FM_CORE_READY, &fmdev->flag);
+	return ret;
+}
+
+/*
+ * Module init function. Ask FM V4L module to register video device.
+ * Allocate memory for FM driver context and RX RDS buffer.
+ */
+static int __init fm_drv_init(void)
+{
+	struct fmdev *fmdev = NULL;
+	u32 ret = -ENOMEM;
+
+	fmdbg("FM driver version %s\n", FM_DRV_VERSION);
+
+	fmdev = kzalloc(sizeof(struct fmdev), GFP_KERNEL);
+	if (NULL == fmdev) {
+		fmerr("Can't allocate operation structure memory\n");
+		return ret;
+	}
+	fmdev->rx.rds.buf_size = default_rds_buf * FM_RDS_BLK_SIZE;
+	fmdev->rx.rds.buff = kzalloc(fmdev->rx.rds.buf_size, GFP_KERNEL);
+	if (NULL == fmdev->rx.rds.buff) {
+		fmerr("Can't allocate rds ring buffer\n");
+		goto rel_dev;
+	}
+
+	ret = fm_v4l2_init_video_device(fmdev, radio_nr);
+	if (ret < 0)
+		goto rel_rdsbuf;
+
+	fmdev->irq_info.handlers = int_handler_table;
+	fmdev->curr_fmmode = FM_MODE_OFF;
+	fmdev->tx_data.pwr_lvl = FM_PWR_LVL_DEF;
+	fmdev->tx_data.preemph = FM_TX_PREEMPH_50US;
+	return ret;
+
+rel_rdsbuf:
+	kfree(fmdev->rx.rds.buff);
+rel_dev:
+	kfree(fmdev);
+
+	return ret;
+}
+
+/* Module exit function. Ask FM V4L module to unregister video device */
+static void __exit fm_drv_exit(void)
+{
+	struct fmdev *fmdev = NULL;
+
+	fmdev = fm_v4l2_deinit_video_device();
+	if (fmdev != NULL) {
+		kfree(fmdev->rx.rds.buff);
+		kfree(fmdev);
+	}
+}
+
+module_init(fm_drv_init);
+module_exit(fm_drv_exit);
+
+/* ------------- Module Info ------------- */
+MODULE_AUTHOR("Manjunatha Halli <manjunatha_halli@ti.com>");
+MODULE_DESCRIPTION("FM Driver for TI's Connectivity chip. " FM_DRV_VERSION);
+MODULE_VERSION(FM_DRV_VERSION);
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/radio/wl128x/fmdrv_common.h b/drivers/media/radio/wl128x/fmdrv_common.h
new file mode 100644
index 0000000..e5091f4
--- /dev/null
+++ b/drivers/media/radio/wl128x/fmdrv_common.h
@@ -0,0 +1,402 @@
+/*
+ *  FM Driver for Connectivity chip of Texas Instruments.
+ *  FM Common module header file
+ *
+ *  Copyright (C) 2011 Texas Instruments
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#ifndef _FMDRV_COMMON_H
+#define _FMDRV_COMMON_H
+
+#define FM_ST_REG_TIMEOUT   msecs_to_jiffies(6000)	/* 6 sec */
+#define FM_PKT_LOGICAL_CHAN_NUMBER  0x08   /* Logical channel 8 */
+
+#define REG_RD       0x1
+#define REG_WR      0x0
+
+struct fm_reg_table {
+	u8 opcode;
+	u8 type;
+	u8 *name;
+};
+
+#define STEREO_GET               0
+#define RSSI_LVL_GET             1
+#define IF_COUNT_GET             2
+#define FLAG_GET                 3
+#define RDS_SYNC_GET             4
+#define RDS_DATA_GET             5
+#define FREQ_SET                 10
+#define AF_FREQ_SET              11
+#define MOST_MODE_SET            12
+#define MOST_BLEND_SET           13
+#define DEMPH_MODE_SET           14
+#define SEARCH_LVL_SET           15
+#define BAND_SET                 16
+#define MUTE_STATUS_SET          17
+#define RDS_PAUSE_LVL_SET        18
+#define RDS_PAUSE_DUR_SET        19
+#define RDS_MEM_SET              20
+#define RDS_BLK_B_SET            21
+#define RDS_MSK_B_SET            22
+#define RDS_PI_MASK_SET          23
+#define RDS_PI_SET               24
+#define RDS_SYSTEM_SET           25
+#define INT_MASK_SET             26
+#define SEARCH_DIR_SET           27
+#define VOLUME_SET               28
+#define AUDIO_ENABLE_SET         29
+#define PCM_MODE_SET             30
+#define I2S_MODE_CONFIG_SET      31
+#define POWER_SET                32
+#define INTX_CONFIG_SET          33
+#define PULL_EN_SET              34
+#define HILO_SET                 35
+#define SWITCH2FREF              36
+#define FREQ_DRIFT_REPORT        37
+
+#define PCE_GET                  40
+#define FIRM_VER_GET             41
+#define ASIC_VER_GET             42
+#define ASIC_ID_GET              43
+#define MAN_ID_GET               44
+#define TUNER_MODE_SET           45
+#define STOP_SEARCH              46
+#define RDS_CNTRL_SET            47
+
+#define WRITE_HARDWARE_REG       100
+#define CODE_DOWNLOAD            101
+#define RESET                    102
+
+#define FM_POWER_MODE            254
+#define FM_INTERRUPT             255
+
+/* Transmitter API */
+
+#define CHANL_SET                55
+#define CHANL_BW_SET		56
+#define REF_SET                  57
+#define POWER_ENB_SET            90
+#define POWER_ATT_SET            58
+#define POWER_LEV_SET            59
+#define AUDIO_DEV_SET            60
+#define PILOT_DEV_SET            61
+#define RDS_DEV_SET              62
+#define TX_BAND_SET              65
+#define PUPD_SET                 91
+#define AUDIO_IO_SET             63
+#define PREMPH_SET               64
+#define MONO_SET                 66
+#define MUTE                     92
+#define MPX_LMT_ENABLE           67
+#define PI_SET                   93
+#define ECC_SET                  69
+#define PTY                      70
+#define AF                       71
+#define DISPLAY_MODE             74
+#define RDS_REP_SET              77
+#define RDS_CONFIG_DATA_SET      98
+#define RDS_DATA_SET             99
+#define RDS_DATA_ENB             94
+#define TA_SET                   78
+#define TP_SET                   79
+#define DI_SET                   80
+#define MS_SET                   81
+#define PS_SCROLL_SPEED          82
+#define TX_AUDIO_LEVEL_TEST      96
+#define TX_AUDIO_LEVEL_TEST_THRESHOLD    73
+#define TX_AUDIO_INPUT_LEVEL_RANGE_SET   54
+#define RX_ANTENNA_SELECT        87
+#define I2C_DEV_ADDR_SET         86
+#define REF_ERR_CALIB_PARAM_SET          88
+#define REF_ERR_CALIB_PERIODICITY_SET    89
+#define SOC_INT_TRIGGER                  52
+#define SOC_AUDIO_PATH_SET               83
+#define SOC_PCMI_OVERRIDE                84
+#define SOC_I2S_OVERRIDE         85
+#define RSSI_BLOCK_SCAN_FREQ_SET 95
+#define RSSI_BLOCK_SCAN_START    97
+#define RSSI_BLOCK_SCAN_DATA_GET  5
+#define READ_FMANT_TUNE_VALUE            104
+
+/* SKB helpers */
+struct fm_skb_cb {
+	__u8 fm_op;
+	struct completion *completion;
+};
+
+#define fm_cb(skb) ((struct fm_skb_cb *)(skb->cb))
+
+/* FM Channel-8 command message format */
+struct fm_cmd_msg_hdr {
+	__u8 hdr;		/* Logical Channel-8 */
+	__u8 len;		/* Number of bytes follows */
+	__u8 op;		/* FM Opcode */
+	__u8 rd_wr;		/* Read/Write command */
+	__u8 dlen;		/* Length of payload */
+} __attribute__ ((packed));
+
+#define FM_CMD_MSG_HDR_SIZE    5	/* sizeof(struct fm_cmd_msg_hdr) */
+
+/* FM Channel-8 event messgage format */
+struct fm_event_msg_hdr {
+	__u8 header;		/* Logical Channel-8 */
+	__u8 len;		/* Number of bytes follows */
+	__u8 status;		/* Event status */
+	__u8 num_fm_hci_cmds;	/* Number of pkts the host allowed to send */
+	__u8 op;		/* FM Opcode */
+	__u8 rd_wr;		/* Read/Write command */
+	__u8 dlen;		/* Length of payload */
+} __attribute__ ((packed));
+
+#define FM_EVT_MSG_HDR_SIZE     7	/* sizeof(struct fm_event_msg_hdr) */
+
+/* TI's magic number in firmware file */
+#define FM_FW_FILE_HEADER_MAGIC	     0x42535442
+
+#define FM_ENABLE   1
+#define FM_DISABLE  0
+
+/* FLAG_GET register bits */
+#define FM_FR_EVENT		(1 << 0)
+#define FM_BL_EVENT		(1 << 1)
+#define FM_RDS_EVENT		(1 << 2)
+#define FM_BBLK_EVENT		(1 << 3)
+#define FM_LSYNC_EVENT		(1 << 4)
+#define FM_LEV_EVENT		(1 << 5)
+#define FM_IFFR_EVENT		(1 << 6)
+#define FM_PI_EVENT		(1 << 7)
+#define FM_PD_EVENT		(1 << 8)
+#define FM_STIC_EVENT		(1 << 9)
+#define FM_MAL_EVENT		(1 << 10)
+#define FM_POW_ENB_EVENT	(1 << 11)
+
+/*
+ * Firmware files of FM. ASIC ID and ASIC version will be appened to this,
+ * later.
+ */
+#define FM_FMC_FW_FILE_START      ("fmc_ch8")
+#define FM_RX_FW_FILE_START       ("fm_rx_ch8")
+#define FM_TX_FW_FILE_START       ("fm_tx_ch8")
+
+#define FM_UNDEFINED_FREQ		   0xFFFFFFFF
+
+/* Band types */
+#define FM_BAND_EUROPE_US	0
+#define FM_BAND_JAPAN		1
+
+/* Seek directions */
+#define FM_SEARCH_DIRECTION_DOWN	0
+#define FM_SEARCH_DIRECTION_UP		1
+
+/* Tunner modes */
+#define FM_TUNER_STOP_SEARCH_MODE	0
+#define FM_TUNER_PRESET_MODE		1
+#define FM_TUNER_AUTONOMOUS_SEARCH_MODE	2
+#define FM_TUNER_AF_JUMP_MODE		3
+
+/* Min and Max volume */
+#define FM_RX_VOLUME_MIN	0
+#define FM_RX_VOLUME_MAX	70
+
+/* Volume gain step */
+#define FM_RX_VOLUME_GAIN_STEP	0x370
+
+/* Mute modes */
+#define FM_MUTE_OFF		0
+#define	FM_MUTE_ON		1
+#define	FM_MUTE_ATTENUATE	2
+
+#define FM_RX_UNMUTE_MODE		0x00
+#define FM_RX_RF_DEP_MODE		0x01
+#define FM_RX_AC_MUTE_MODE		0x02
+#define FM_RX_HARD_MUTE_LEFT_MODE	0x04
+#define FM_RX_HARD_MUTE_RIGHT_MODE	0x08
+#define FM_RX_SOFT_MUTE_FORCE_MODE	0x10
+
+/* RF dependent mute mode */
+#define FM_RX_RF_DEPENDENT_MUTE_ON	1
+#define FM_RX_RF_DEPENDENT_MUTE_OFF	0
+
+/* RSSI threshold min and max */
+#define FM_RX_RSSI_THRESHOLD_MIN	-128
+#define FM_RX_RSSI_THRESHOLD_MAX	127
+
+/* Stereo/Mono mode */
+#define FM_STEREO_MODE		0
+#define FM_MONO_MODE		1
+#define FM_STEREO_SOFT_BLEND	1
+
+/* FM RX De-emphasis filter modes */
+#define FM_RX_EMPHASIS_FILTER_50_USEC	0
+#define FM_RX_EMPHASIS_FILTER_75_USEC	1
+
+/* FM RDS modes */
+#define FM_RDS_DISABLE	0
+#define FM_RDS_ENABLE	1
+
+#define FM_NO_PI_CODE	0
+
+/* FM and RX RDS block enable/disable  */
+#define FM_RX_PWR_SET_FM_ON_RDS_OFF		0x1
+#define FM_RX_PWR_SET_FM_AND_RDS_BLK_ON		0x3
+#define FM_RX_PWR_SET_FM_AND_RDS_BLK_OFF	0x0
+
+/* RX RDS */
+#define FM_RX_RDS_FLUSH_FIFO		0x1
+#define FM_RX_RDS_FIFO_THRESHOLD	64	/* tuples */
+#define FM_RDS_BLK_SIZE		3	/* 3 bytes */
+
+/* RDS block types */
+#define FM_RDS_BLOCK_A		0
+#define FM_RDS_BLOCK_B		1
+#define FM_RDS_BLOCK_C		2
+#define FM_RDS_BLOCK_Ctag	3
+#define FM_RDS_BLOCK_D		4
+#define FM_RDS_BLOCK_E		5
+
+#define FM_RDS_BLK_IDX_A		0
+#define FM_RDS_BLK_IDX_B		1
+#define FM_RDS_BLK_IDX_C		2
+#define FM_RDS_BLK_IDX_D		3
+#define FM_RDS_BLK_IDX_UNKNOWN	0xF0
+
+#define FM_RDS_STATUS_ERR_MASK	0x18
+
+/*
+ * Represents an RDS group type & version.
+ * There are 15 groups, each group has 2 versions: A and B.
+ */
+#define FM_RDS_GROUP_TYPE_MASK_0A	    ((unsigned long)1<<0)
+#define FM_RDS_GROUP_TYPE_MASK_0B	    ((unsigned long)1<<1)
+#define FM_RDS_GROUP_TYPE_MASK_1A	    ((unsigned long)1<<2)
+#define FM_RDS_GROUP_TYPE_MASK_1B	    ((unsigned long)1<<3)
+#define FM_RDS_GROUP_TYPE_MASK_2A	    ((unsigned long)1<<4)
+#define FM_RDS_GROUP_TYPE_MASK_2B	    ((unsigned long)1<<5)
+#define FM_RDS_GROUP_TYPE_MASK_3A	    ((unsigned long)1<<6)
+#define FM_RDS_GROUP_TYPE_MASK_3B           ((unsigned long)1<<7)
+#define FM_RDS_GROUP_TYPE_MASK_4A	    ((unsigned long)1<<8)
+#define FM_RDS_GROUP_TYPE_MASK_4B	    ((unsigned long)1<<9)
+#define FM_RDS_GROUP_TYPE_MASK_5A	    ((unsigned long)1<<10)
+#define FM_RDS_GROUP_TYPE_MASK_5B	    ((unsigned long)1<<11)
+#define FM_RDS_GROUP_TYPE_MASK_6A	    ((unsigned long)1<<12)
+#define FM_RDS_GROUP_TYPE_MASK_6B	    ((unsigned long)1<<13)
+#define FM_RDS_GROUP_TYPE_MASK_7A	    ((unsigned long)1<<14)
+#define FM_RDS_GROUP_TYPE_MASK_7B	    ((unsigned long)1<<15)
+#define FM_RDS_GROUP_TYPE_MASK_8A           ((unsigned long)1<<16)
+#define FM_RDS_GROUP_TYPE_MASK_8B	    ((unsigned long)1<<17)
+#define FM_RDS_GROUP_TYPE_MASK_9A	    ((unsigned long)1<<18)
+#define FM_RDS_GROUP_TYPE_MASK_9B	    ((unsigned long)1<<19)
+#define FM_RDS_GROUP_TYPE_MASK_10A	    ((unsigned long)1<<20)
+#define FM_RDS_GROUP_TYPE_MASK_10B	    ((unsigned long)1<<21)
+#define FM_RDS_GROUP_TYPE_MASK_11A	    ((unsigned long)1<<22)
+#define FM_RDS_GROUP_TYPE_MASK_11B	    ((unsigned long)1<<23)
+#define FM_RDS_GROUP_TYPE_MASK_12A	    ((unsigned long)1<<24)
+#define FM_RDS_GROUP_TYPE_MASK_12B	    ((unsigned long)1<<25)
+#define FM_RDS_GROUP_TYPE_MASK_13A	    ((unsigned long)1<<26)
+#define FM_RDS_GROUP_TYPE_MASK_13B	    ((unsigned long)1<<27)
+#define FM_RDS_GROUP_TYPE_MASK_14A	    ((unsigned long)1<<28)
+#define FM_RDS_GROUP_TYPE_MASK_14B	    ((unsigned long)1<<29)
+#define FM_RDS_GROUP_TYPE_MASK_15A	    ((unsigned long)1<<30)
+#define FM_RDS_GROUP_TYPE_MASK_15B	    ((unsigned long)1<<31)
+
+/* RX Alternate Frequency info */
+#define FM_RDS_MIN_AF		          1
+#define FM_RDS_MAX_AF		        204
+#define FM_RDS_MAX_AF_JAPAN	        140
+#define FM_RDS_1_AF_FOLLOWS	        225
+#define FM_RDS_25_AF_FOLLOWS	        249
+
+/* RDS system type (RDS/RBDS) */
+#define FM_RDS_SYSTEM_RDS		0
+#define FM_RDS_SYSTEM_RBDS		1
+
+/* AF on/off */
+#define FM_RX_RDS_AF_SWITCH_MODE_ON	1
+#define FM_RX_RDS_AF_SWITCH_MODE_OFF	0
+
+/* Retry count when interrupt process goes wrong */
+#define FM_IRQ_TIMEOUT_RETRY_MAX	5	/* 5 times */
+
+/* Audio IO set values */
+#define FM_RX_AUDIO_ENABLE_I2S	0x01
+#define FM_RX_AUDIO_ENABLE_ANALOG	0x02
+#define FM_RX_AUDIO_ENABLE_I2S_AND_ANALOG	0x03
+#define FM_RX_AUDIO_ENABLE_DISABLE	0x00
+
+/* HI/LO set values */
+#define FM_RX_IFFREQ_TO_HI_SIDE		0x0
+#define FM_RX_IFFREQ_TO_LO_SIDE		0x1
+#define FM_RX_IFFREQ_HILO_AUTOMATIC	0x2
+
+/*
+ * Default RX mode configuration. Chip will be configured
+ * with this default values after loading RX firmware.
+ */
+#define FM_DEFAULT_RX_VOLUME		10
+#define FM_DEFAULT_RSSI_THRESHOLD	3
+
+/* Range for TX power level in units for dB/uV */
+#define FM_PWR_LVL_LOW			91
+#define FM_PWR_LVL_HIGH			122
+
+/* Chip specific default TX power level value */
+#define FM_PWR_LVL_DEF			4
+
+/* FM TX Pre-emphasis filter values */
+#define FM_TX_PREEMPH_OFF		1
+#define FM_TX_PREEMPH_50US		0
+#define FM_TX_PREEMPH_75US		2
+
+/* FM TX antenna impedence values */
+#define FM_TX_ANT_IMP_50		0
+#define FM_TX_ANT_IMP_200		1
+#define FM_TX_ANT_IMP_500		2
+
+/* Functions exported by FM common sub-module */
+u32 fmc_prepare(struct fmdev *);
+u32 fmc_release(struct fmdev *);
+
+void fmc_update_region_info(struct fmdev *, u8);
+u32 fmc_send_cmd(struct fmdev *, u8, u16,
+				void *, unsigned int, void *, int *);
+u32 fmc_is_rds_data_available(struct fmdev *, struct file *,
+				struct poll_table_struct *);
+u32 fmc_transfer_rds_from_internal_buff(struct fmdev *, struct file *,
+					u8 __user *, size_t);
+
+u32 fmc_set_freq(struct fmdev *, u32);
+u32 fmc_set_mode(struct fmdev *, u8);
+u32 fmc_set_region(struct fmdev *, u8);
+u32 fmc_set_mute_mode(struct fmdev *, u8);
+u32 fmc_set_stereo_mono(struct fmdev *, u16);
+u32 fmc_set_rds_mode(struct fmdev *, u8);
+
+u32 fmc_get_freq(struct fmdev *, u32 *);
+u32 fmc_get_region(struct fmdev *, u8 *);
+u32 fmc_get_mode(struct fmdev *, u8 *);
+
+/*
+ * channel spacing
+ */
+#define FM_CHANNEL_SPACING_50KHZ 1
+#define FM_CHANNEL_SPACING_100KHZ 2
+#define FM_CHANNEL_SPACING_200KHZ 4
+#define FM_FREQ_MUL 50
+
+#endif
+
-- 
1.5.6.3

