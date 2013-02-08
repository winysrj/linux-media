Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:34438 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab3BHN7M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2013 08:59:12 -0500
Received: by mail-ea0-f176.google.com with SMTP id a13so1736160eaa.21
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2013 05:59:10 -0800 (PST)
Message-ID: <511504AB.1040005@gmail.com>
Date: Fri, 08 Feb 2013 14:59:07 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: j@jannau.net, jarod@redhat.com, 699470@bugs.debian.org
Subject: [PATCH] crystalhd git.linuxtv.org kernel driver: Fix PM suspend broken
 by emergency patches
References: <50E3E643.7070701@gmail.com> <50E5A116.9070307@schinagl.nl> <50E8203C.20603@gmail.com> <50EB5B44.6020603@gmail.com> <50EF6042.7010908@gmail.com>
In-Reply-To: <50EF6042.7010908@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040304050203060608040601"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040304050203060608040601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Fix PM suspend() broken by emergency patches, thanks to Philip Langdale for pointing out.

...But PM resume() didn't work anyway with the original code, always err invalid args.

Recommended workaround user space PM handling for ACPI S3:

/etc/pm/config.d/00suspend_modules:2:SUSPEND_MODULES="dvb_ttpci crystalhd"

/etc/pm/sleep.d/92_crystalhd
#!/bin/sh

#SERVICES="crystalhd"

#for service in $SERVICES; do
#    services_reverse="$service $services_reverse"
#done

case "$1" in
     hibernate|suspend)
         ;;
     thaw|resume)
     echo 1 > /sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/reset
#    echo 1 > /sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/rescan
esac

and after malfunction with "FW Command T/O", etc, crystalhd PCI-E device needs the reset up to 3x and module reload.

--------------------------

Patch attached.

crystalhd git.linuxtv.org kernel driver: Fix PM suspend broken by emergency patches

Signed-off-by: Thomas Schorpp <thomas.schorpp@gmail.com>

y
tom



--------------040304050203060608040601
Content-Type: text/x-diff;
 name="crystalhd-fix-PM-suspend.schorpp.01.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="crystalhd-fix-PM-suspend.schorpp.01.patch"

diff --git a/driver/linux/crystalhd_cmds.c b/driver/linux/crystalhd_cmds.c
index cecd710..cb6e65d 100644
--- a/driver/linux/crystalhd_cmds.c
+++ b/driver/linux/crystalhd_cmds.c
@@ -32,6 +32,11 @@ static struct crystalhd_user *bc_cproc_get_uid(struct crystalhd_cmd *ctx)
 	struct crystalhd_user *user = NULL;
 	int i;
 
+	if (!ctx) {
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
+		return user;
+	}
+
 	for (i = 0; i < BC_LINK_MAX_OPENS; i++) {
 		if (!ctx->user[i].in_use) {
 			user = &ctx->user[i];
@@ -46,6 +51,11 @@ int bc_get_userhandle_count(struct crystalhd_cmd *ctx)
 {
 	int i, count = 0;
 
+	if (!ctx) {
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
 	for (i = 0; i < BC_LINK_MAX_OPENS; i++) {
 		if (ctx->user[i].in_use)
 			count++;
@@ -154,7 +164,7 @@ static BC_STATUS bc_cproc_get_hwtype(struct crystalhd_cmd *ctx, crystalhd_ioctl_
 static BC_STATUS bc_cproc_reg_rd(struct crystalhd_cmd *ctx,
 				 crystalhd_ioctl_data *idata)
 {
-	if (!ctx || !idata)
+	if (!ctx || !ctx->hw_ctx || !idata)
 		return BC_STS_INV_ARG;
 	idata->udata.u.regAcc.Value = ctx->hw_ctx->pfnReadDevRegister(ctx->adp,
 					idata->udata.u.regAcc.Offset);
@@ -164,7 +174,7 @@ static BC_STATUS bc_cproc_reg_rd(struct crystalhd_cmd *ctx,
 static BC_STATUS bc_cproc_reg_wr(struct crystalhd_cmd *ctx,
 				 crystalhd_ioctl_data *idata)
 {
-	if (!ctx || !idata)
+	if (!ctx || !ctx->hw_ctx || !idata)
 		return BC_STS_INV_ARG;
 
 	ctx->hw_ctx->pfnWriteDevRegister(ctx->adp, idata->udata.u.regAcc.Offset,
@@ -176,7 +186,7 @@ static BC_STATUS bc_cproc_reg_wr(struct crystalhd_cmd *ctx,
 static BC_STATUS bc_cproc_link_reg_rd(struct crystalhd_cmd *ctx,
 				      crystalhd_ioctl_data *idata)
 {
-	if (!ctx || !idata)
+	if (!ctx || !ctx->hw_ctx || !idata)
 		return BC_STS_INV_ARG;
 
 	idata->udata.u.regAcc.Value = ctx->hw_ctx->pfnReadFPGARegister(ctx->adp,
@@ -187,7 +197,7 @@ static BC_STATUS bc_cproc_link_reg_rd(struct crystalhd_cmd *ctx,
 static BC_STATUS bc_cproc_link_reg_wr(struct crystalhd_cmd *ctx,
 				      crystalhd_ioctl_data *idata)
 {
-	if (!ctx || !idata)
+	if (!ctx || !ctx->hw_ctx || !idata)
 		return BC_STS_INV_ARG;
 
 	ctx->hw_ctx->pfnWriteFPGARegister(ctx->adp, idata->udata.u.regAcc.Offset,
@@ -201,7 +211,7 @@ static BC_STATUS bc_cproc_mem_rd(struct crystalhd_cmd *ctx,
 {
 	BC_STATUS sts = BC_STS_SUCCESS;
 
-	if (!ctx || !idata || !idata->add_cdata)
+	if (!ctx || !ctx->hw_ctx || !idata || !idata->add_cdata)
 		return BC_STS_INV_ARG;
 
 	if (idata->udata.u.devMem.NumDwords > (idata->add_cdata_sz / 4)) {
@@ -220,7 +230,7 @@ static BC_STATUS bc_cproc_mem_wr(struct crystalhd_cmd *ctx,
 {
 	BC_STATUS sts = BC_STS_SUCCESS;
 
-	if (!ctx || !idata || !idata->add_cdata)
+	if (!ctx || !ctx->hw_ctx || !idata || !idata->add_cdata)
 		return BC_STS_INV_ARG;
 
 	if (idata->udata.u.devMem.NumDwords > (idata->add_cdata_sz / 4)) {
@@ -307,7 +317,7 @@ static BC_STATUS bc_cproc_download_fw(struct crystalhd_cmd *ctx,
 
 	dev_dbg(chddev(), "Downloading FW\n");
 
-	if (!ctx || !idata || !idata->add_cdata || !idata->add_cdata_sz) {
+	if (!ctx || !ctx->hw_ctx || !idata || !idata->add_cdata || !idata->add_cdata_sz) {
 		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -350,7 +360,7 @@ static BC_STATUS bc_cproc_do_fw_cmd(struct crystalhd_cmd *ctx, crystalhd_ioctl_d
 	BC_STATUS sts;
 	uint32_t *cmd;
 
-	if (!(ctx->state & BC_LINK_INIT)) {
+	if ( !ctx || !idata || !(ctx->state & BC_LINK_INIT) || !ctx->hw_ctx) {
 		dev_dbg(dev, "Link invalid state do fw cmd %x \n", ctx->state);
 		return BC_STS_ERR_USAGE;
 	}
@@ -395,7 +405,7 @@ static void bc_proc_in_completion(struct crystalhd_dio_req *dio_hnd,
 		return;
 	}
 	if (sts == BC_STS_IO_USER_ABORT || sts == BC_STS_PWR_MGMT)
-		 return;
+		return;
 
 	dio_hnd->uinfo.comp_sts = sts;
 	dio_hnd->uinfo.ev_sts = 1;
@@ -407,6 +417,9 @@ static BC_STATUS bc_cproc_codein_sleep(struct crystalhd_cmd *ctx)
 	wait_queue_head_t sleep_ev;
 	int rc = 0;
 
+	if (!ctx)
+		return BC_STS_INV_ARG;
+
 	if (ctx->state & BC_LINK_SUSPEND)
 		return BC_STS_PWR_MGMT;
 
@@ -432,7 +445,7 @@ static BC_STATUS bc_cproc_hw_txdma(struct crystalhd_cmd *ctx,
 	wait_queue_head_t event;
 	int rc = 0;
 
-	if (!ctx || !idata || !dio) {
+	if (!ctx || !ctx->hw_ctx || !idata || !dio) {
 		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -573,7 +586,7 @@ static BC_STATUS bc_cproc_add_cap_buff(struct crystalhd_cmd *ctx,
 	struct crystalhd_dio_req *dio_hnd = NULL;
 	BC_STATUS sts = BC_STS_SUCCESS;
 
-	if (!ctx || !idata) {
+	if (!ctx || !ctx->hw_ctx || !idata) {
 		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -612,6 +625,11 @@ static BC_STATUS bc_cproc_fmt_change(struct crystalhd_cmd *ctx,
 {
 	BC_STATUS sts = BC_STS_SUCCESS;
 
+	if (!ctx || !dio) {
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
 	sts = crystalhd_hw_add_cap_buffer(ctx->hw_ctx, dio, 0);
 	if (sts != BC_STS_SUCCESS)
 		return sts;
@@ -673,6 +691,10 @@ static BC_STATUS bc_cproc_fetch_frame(struct crystalhd_cmd *ctx,
 static BC_STATUS bc_cproc_start_capture(struct crystalhd_cmd *ctx,
 					crystalhd_ioctl_data *idata)
 {
+	if (!ctx || !ctx->hw_ctx || !idata) {
+		return BC_STS_INV_ARG;
+	}
+
 	ctx->state |= BC_LINK_CAP_EN;
 
 	if( idata->udata.u.RxCap.PauseThsh )
@@ -705,7 +727,7 @@ static BC_STATUS bc_cproc_flush_cap_buffs(struct crystalhd_cmd *ctx,
 	struct device *dev = chddev();
 	struct crystalhd_rx_dma_pkt *rpkt;
 
-	if (!ctx || !idata) {
+	if (!ctx || !ctx->hw_ctx || !idata) {
 		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -745,8 +767,8 @@ static BC_STATUS bc_cproc_get_stats(struct crystalhd_cmd *ctx,
 	bool readTxOnly = false;
 	unsigned long irqflags;
 
-	if (!ctx || !idata) {
-		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
+	if (!ctx || !ctx->hw_ctx || !idata) {
+		dev_err(chddev(), "%s: Invalid Arg ctx,hw,data: 0x%lx 0x%lx 0x%lx\n", __func__, (uintptr_t)(ctx->hw_ctx), (uintptr_t)ctx, (uintptr_t)idata);
 		return BC_STS_INV_ARG;
 	}
 
@@ -828,6 +850,10 @@ get_out:
 static BC_STATUS bc_cproc_reset_stats(struct crystalhd_cmd *ctx,
 				      crystalhd_ioctl_data *idata)
 {
+	if (!ctx || !ctx->hw_ctx || !idata) {
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
+		return BC_STS_INV_ARG;
+	}
 	crystalhd_hw_stats(ctx->hw_ctx, NULL);
 
 	return BC_STS_SUCCESS;
@@ -949,8 +975,8 @@ BC_STATUS crystalhd_suspend(struct crystalhd_cmd *ctx, crystalhd_ioctl_data *ida
 	struct crystalhd_rx_dma_pkt *rpkt = NULL;
 
 	if (!ctx || !idata) {
-		dev_err(dev, "Invalid Parameters\n");
-		return BC_STS_ERROR;
+		dev_err(dev, "%s: Invalid Arg\n", __func__);
+		return BC_STS_INV_ARG;
 	}
 
 	if (ctx->state & BC_LINK_SUSPEND)
@@ -965,7 +991,7 @@ BC_STATUS crystalhd_suspend(struct crystalhd_cmd *ctx, crystalhd_ioctl_data *ida
 
 	bc_cproc_mark_pwr_state(ctx, BC_HW_SUSPEND); /* going to suspend */
 
-	if (ctx->state & BC_LINK_CAP_EN) {
+	if (ctx->hw_ctx && ctx->state & BC_LINK_CAP_EN) {
 		// Clean any pending RX
 		crystalhd_hw_stop_capture(ctx->hw_ctx, false);
 		while((rpkt = crystalhd_dioq_fetch(ctx->hw_ctx->rx_actq)) != NULL)
@@ -980,8 +1006,7 @@ BC_STATUS crystalhd_suspend(struct crystalhd_cmd *ctx, crystalhd_ioctl_data *ida
 		if (sts != BC_STS_SUCCESS)
 			return sts;
 	}
-	else
-	{
+	else if (ctx->hw_ctx) {
 		// Even if there is no active TX DMA need to stop and reset TX DMA pointers
 		ctx->hw_ctx->pfnStopTxDMA(ctx->hw_ctx);
 	}
@@ -1017,6 +1042,11 @@ BC_STATUS crystalhd_resume(struct crystalhd_cmd *ctx)
 {
 	BC_STATUS sts = BC_STS_SUCCESS;
 
+	if (!ctx) {
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
 	sts = crystalhd_hw_resume(ctx->hw_ctx);
 	if (sts != BC_STS_SUCCESS)
 		return sts;
@@ -1049,13 +1079,13 @@ BC_STATUS crystalhd_user_open(struct crystalhd_cmd *ctx,
 	struct crystalhd_user *uc;
 
 	if (!ctx || !user_ctx) {
-		dev_err(dev, "Invalid arg..\n");
+		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	uc = bc_cproc_get_uid(ctx);
 	if (!uc) {
-		dev_info(dev, "No free user context...\n");
+		dev_info(dev, "%s No free user context.\n", __func__);
 		return BC_STS_BUSY;
 	}
 
@@ -1093,19 +1123,21 @@ BC_STATUS crystalhd_user_open(struct crystalhd_cmd *ctx,
  *
  * Called at the time of driver load.
  */
-BC_STATUS __devinit crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
+BC_STATUS crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
 				    struct crystalhd_adp *adp)
 {
-	struct device *dev = &adp->pdev->dev;
+	struct device *dev;
 	int i = 0;
 
-	if (!ctx || !adp) {
-		dev_err(dev, "%s: Invalid arg\n", __func__);
+	if (!ctx || !adp || !adp->pdev) {
+		printk(KERN_ERR "%s: Invalid arg.\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
+	dev = &adp->pdev->dev;
+
 	if (ctx->adp)
-		dev_dbg(dev, "Resetting Cmd context delete missing..\n");
+		dev_dbg(dev, "Resetting Cmd context delete missing.\n");
 
 	ctx->adp = adp;
 	for (i = 0; i < BC_LINK_MAX_OPENS; i++) {
@@ -1114,15 +1146,19 @@ BC_STATUS __devinit crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
 		ctx->user[i].mode = DTS_MODE_INV;
 	}
 
-	ctx->hw_ctx = (struct crystalhd_hw*)kmalloc(sizeof(struct crystalhd_hw), GFP_KERNEL);
-
-	memset(ctx->hw_ctx, 0, sizeof(struct crystalhd_hw));
+	if(ctx->hw_ctx == NULL) {
+		ctx->hw_ctx = (struct crystalhd_hw*)kmalloc(sizeof(struct crystalhd_hw), GFP_KERNEL);
+		if(ctx->hw_ctx != NULL)
+			memset(ctx->hw_ctx, 0, sizeof(struct crystalhd_hw));
+		else
+			return BC_STS_ERROR;
 
-	/*Open and Close the Hardware to put it in to sleep state*/
-	crystalhd_hw_open(ctx->hw_ctx, ctx->adp);
-	crystalhd_hw_close(ctx->hw_ctx, ctx->adp);
-	kfree(ctx->hw_ctx);
-	ctx->hw_ctx = NULL;
+		/*Open and Close the Hardware to put it in to sleep state*/
+		crystalhd_hw_open(ctx->hw_ctx, ctx->adp);
+		crystalhd_hw_close(ctx->hw_ctx, ctx->adp);
+		kfree(ctx->hw_ctx);
+		ctx->hw_ctx = NULL;
+	}
 
 	return BC_STS_SUCCESS;
 }
@@ -1136,10 +1172,15 @@ BC_STATUS __devinit crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
  *
  * Called at the time of driver un-load.
  */
-BC_STATUS __devexit crystalhd_delete_cmd_context(struct crystalhd_cmd *ctx)
+BC_STATUS crystalhd_delete_cmd_context(struct crystalhd_cmd *ctx)
 {
 	dev_dbg(chddev(), "Deleting Command context..\n");
 
+	if (!ctx) {
+		dev_err(chddev(), "%s: Invalid arg\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
 	ctx->adp = NULL;
 
 	return BC_STS_SUCCESS;
@@ -1165,8 +1206,8 @@ crystalhd_cmd_proc crystalhd_get_cmd_proc(struct crystalhd_cmd *ctx, uint32_t cm
 	crystalhd_cmd_proc cproc = NULL;
 	unsigned int i, tbl_sz;
 
-	if (!ctx) {
-		dev_err(dev, "Invalid arg.. Cmd[%d]\n", cmd);
+	if (!ctx || !uc) {
+		dev_err(dev, "Invalid arg. Cmd[%d]\n", cmd);
 		return NULL;
 	}
 
diff --git a/driver/linux/crystalhd_fleafuncs.c b/driver/linux/crystalhd_fleafuncs.c
index 1aa7115..f76d122 100644
--- a/driver/linux/crystalhd_fleafuncs.c
+++ b/driver/linux/crystalhd_fleafuncs.c
@@ -1344,7 +1344,9 @@ BCHP_SCRUB_CTRL_BI_CMAC_127_96		0x000f6018			CMAC Bits[127:96]
 bool crystalhd_flea_start_device(struct crystalhd_hw *hw)
 {
 	uint32_t	regVal	= 0;
-	bool		bRetVal = false;
+
+	if (!hw)
+		return false;
 
 	/*
 	-- Issue Core reset to bring in the default values in place
@@ -1430,7 +1432,7 @@ bool crystalhd_flea_start_device(struct crystalhd_hw *hw)
 
 	msleep_interruptible(1);
 
-	return bRetVal;
+	return true;
 }
 
 
diff --git a/driver/linux/crystalhd_hw.c b/driver/linux/crystalhd_hw.c
index cf8fefb..bffb468 100644
--- a/driver/linux/crystalhd_hw.c
+++ b/driver/linux/crystalhd_hw.c
@@ -38,7 +38,7 @@
 BC_STATUS crystalhd_hw_open(struct crystalhd_hw *hw, struct crystalhd_adp *adp)
 {
 	struct device *dev;
-	if (!hw || !adp) {
+	if (!hw || !adp || !adp->pdev) {
 		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -110,7 +110,10 @@ BC_STATUS crystalhd_hw_open(struct crystalhd_hw *hw, struct crystalhd_adp *adp)
 	hw->rx_pkt_tag_seed = 0x70029070;
 
 	hw->stop_pending = 0;
-	hw->pfnStartDevice(hw);
+	if (!hw->pfnStartDevice(hw)) {
+		printk(KERN_ERR "%s: Failed to Start Device! \n", __func__);
+		return BC_STS_ERROR;
+	}
 	hw->dev_started = true;
 
 	dev_dbg(dev, "Opening HW. hw:0x%lx, hw->adp:0x%lx\n",
@@ -121,9 +124,9 @@ BC_STATUS crystalhd_hw_open(struct crystalhd_hw *hw, struct crystalhd_adp *adp)
 
 BC_STATUS crystalhd_hw_close(struct crystalhd_hw *hw, struct crystalhd_adp *adp)
 {
-	if (!hw) {
+	if (!hw || !adp) {
 		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
-		return BC_STS_SUCCESS;
+		return BC_STS_INV_ARG;
 	}
 
 	if (!hw->dev_started)
@@ -390,12 +393,12 @@ BC_STATUS crystalhd_hw_tx_req_complete(struct crystalhd_hw *hw,
 	struct tx_dma_pkt *tx_req;
 
 	if (!hw || !list_id) {
-		printk(KERN_ERR "%s: Invalid Arg!!\n", __func__);
+		printk(KERN_ERR "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	tx_req = (struct tx_dma_pkt *)crystalhd_dioq_find_and_fetch(hw->tx_actq, list_id);
-	if (!tx_req) {
+	if (!tx_req || !tx_req->dio_req || !tx_req->cb_event) {
 		if (cs != BC_STS_IO_USER_ABORT)
 			dev_err(&hw->adp->pdev->dev, "Find/Fetch: no req!\n");
 		return BC_STS_NO_DATA;
@@ -1047,8 +1050,8 @@ BC_STATUS crystalhd_hw_resume(struct crystalhd_hw *hw)
 	hw->rx_list_post_index = 0;
 	hw->tx_list_post_index = 0;
 
-	if (hw->pfnStartDevice(hw)) {
-		dev_info(&hw->adp->pdev->dev, "Failed to Start Device!!\n");
+	if (!hw->pfnStartDevice(hw)) {
+		dev_info(&hw->adp->pdev->dev, "Failed to resume start device!\n");
 		return BC_STS_ERROR;
 	}
 
diff --git a/driver/linux/crystalhd_linkfuncs.c b/driver/linux/crystalhd_linkfuncs.c
index 8366cc3..c8be3ab 100644
--- a/driver/linux/crystalhd_linkfuncs.c
+++ b/driver/linux/crystalhd_linkfuncs.c
@@ -469,8 +469,8 @@ bool crystalhd_link_start_device(struct crystalhd_hw *hw)
 	uint32_t dbg_options, glb_cntrl = 0, reg_pwrmgmt = 0;
 	struct device *dev;
 
-	if (!hw)
-		return -EINVAL;
+	if (!hw || !hw->adp || !hw->adp->pdev)
+		return false;
 
 	dev = &hw->adp->pdev->dev;
 
@@ -957,6 +957,9 @@ void crystalhd_link_tx_isr(struct crystalhd_hw *hw, uint32_t int_sts)
 {
 	uint32_t err_sts;
 
+	if (!hw)
+		return;
+
 	if (int_sts & INTR_INTR_STATUS_L0_TX_DMA_DONE_INTR_MASK)
 		crystalhd_hw_tx_req_complete(hw, hw->tx_ioq_tag_seed + 0,
 					   BC_STS_SUCCESS);
@@ -1995,22 +1998,15 @@ bool crystalhd_link_hw_interrupt_handle(struct crystalhd_adp *adp, struct crysta
 {
 	uint32_t intr_sts = 0;
 	uint32_t deco_intr = 0;
-	bool rc = false;
 
-	if (!adp || !hw->dev_started)
-		return rc;
+	if (!adp || !hw || !hw->dev_started)
+		return false;
 
 	hw->stats.num_interrupts++;
 
 	deco_intr = hw->pfnReadDevRegister(hw->adp, Stream2Host_Intr_Sts);
 	intr_sts  = hw->pfnReadFPGARegister(hw->adp, INTR_INTR_STATUS);
 
-	if (intr_sts) {
-		/* let system know we processed interrupt..*/
-		rc = true;
-		hw->stats.dev_interrupts++;
-	}
-
 	if (deco_intr && (deco_intr != 0xdeaddead)) {
 
 		if (deco_intr & 0x80000000) {
@@ -2026,7 +2022,6 @@ bool crystalhd_link_hw_interrupt_handle(struct crystalhd_adp *adp, struct crysta
 
 		hw->pfnWriteDevRegister(hw->adp, Stream2Host_Intr_Sts, deco_intr);
 		hw->pfnWriteDevRegister(hw->adp, Stream2Host_Intr_Sts, 0);
-		rc = 1;
 	}
 
 	/* Rx interrupts */
@@ -2036,14 +2031,17 @@ bool crystalhd_link_hw_interrupt_handle(struct crystalhd_adp *adp, struct crysta
 	crystalhd_link_tx_isr(hw, intr_sts);
 
 	/* Clear interrupts */
-	if (rc) {
-		if (intr_sts)
-			hw->pfnWriteFPGARegister(hw->adp, INTR_INTR_CLR_REG, intr_sts);
+	if (intr_sts)
+		hw->pfnWriteFPGARegister(hw->adp, INTR_INTR_CLR_REG, intr_sts);
 
-		hw->pfnWriteFPGARegister(hw->adp, INTR_EOI_CTRL, 1);
+	hw->pfnWriteFPGARegister(hw->adp, INTR_EOI_CTRL, 1);
+
+	if (intr_sts) {
+		/* Let system know we have processed interrupts, and rc ret is always true unless invalid args. */
+		hw->stats.dev_interrupts++;
 	}
 
-	return rc;
+	return true;
 }
 
 /* Dummy private function */
diff --git a/driver/linux/crystalhd_lnx.c b/driver/linux/crystalhd_lnx.c
index 64e66ad..8608aea 100644
--- a/driver/linux/crystalhd_lnx.c
+++ b/driver/linux/crystalhd_lnx.c
@@ -431,7 +431,7 @@ static const struct file_operations chd_dec_fops = {
 	.llseek		= noop_llseek,
 };
 
-static int __devinit chd_dec_init_chdev(struct crystalhd_adp *adp)
+static int chd_dec_init_chdev(struct crystalhd_adp *adp)
 {
 	struct device *xdev = &adp->pdev->dev;
 	struct device *dev;
@@ -498,7 +498,7 @@ fail:
 	return rc;
 }
 
-static void __devexit chd_dec_release_chdev(struct crystalhd_adp *adp)
+static void chd_dec_release_chdev(struct crystalhd_adp *adp)
 {
 	crystalhd_ioctl_data *temp = NULL;
 	if (!adp)
@@ -523,7 +523,7 @@ static void __devexit chd_dec_release_chdev(struct crystalhd_adp *adp)
 	/*crystalhd_delete_elem_pool(adp); */
 }
 
-static int __devinit chd_pci_reserve_mem(struct crystalhd_adp *pinfo)
+static int chd_pci_reserve_mem(struct crystalhd_adp *pinfo)
 {
 	struct device *dev = &pinfo->pdev->dev;
 	int rc;
@@ -582,7 +582,7 @@ static int __devinit chd_pci_reserve_mem(struct crystalhd_adp *pinfo)
 	return 0;
 }
 
-static void __devexit chd_pci_release_mem(struct crystalhd_adp *pinfo)
+static void chd_pci_release_mem(struct crystalhd_adp *pinfo)
 {
 	if (!pinfo)
 		return;
@@ -597,7 +597,7 @@ static void __devexit chd_pci_release_mem(struct crystalhd_adp *pinfo)
 }
 
 
-static void __devexit chd_dec_pci_remove(struct pci_dev *pdev)
+static void chd_dec_pci_remove(struct pci_dev *pdev)
 {
 	struct crystalhd_adp *pinfo;
 	BC_STATUS sts = BC_STS_SUCCESS;
@@ -625,7 +625,7 @@ static void __devexit chd_dec_pci_remove(struct pci_dev *pdev)
 	g_adp_info = NULL;
 }
 
-static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
+static int chd_dec_pci_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *entry)
 {
 	struct device *dev = &pdev->dev;
@@ -815,7 +815,7 @@ MODULE_DEVICE_TABLE(pci, chd_dec_pci_id_table);
 static struct pci_driver bc_chd_driver = {
 	.name     = "crystalhd",
 	.probe    = chd_dec_pci_probe,
-	.remove   = __devexit_p(chd_dec_pci_remove),
+	.remove   = chd_dec_pci_remove,
 	.id_table = chd_dec_pci_id_table,
 	.suspend  = chd_dec_pci_suspend,
 	.resume   = chd_dec_pci_resume
diff --git a/driver/linux/crystalhd_misc.c b/driver/linux/crystalhd_misc.c
index 410ab9d..56fbb51 100644
--- a/driver/linux/crystalhd_misc.c
+++ b/driver/linux/crystalhd_misc.c
@@ -512,8 +512,8 @@ void *crystalhd_dioq_fetch_wait(struct crystalhd_hw *hw, uint32_t to_secs, uint3
 			if(down_interruptible(&hw->fetch_sem))
 				goto sem_error;
 			r_pkt = crystalhd_dioq_fetch(ioq);
-			/* If format change packet, then return with out checking anything */
-			if (r_pkt->flags & (COMP_FLAG_PIB_VALID | COMP_FLAG_FMT_CHANGE))
+			/* If format change packet then return without checking anything */
+			if (!r_pkt || r_pkt->flags & (COMP_FLAG_PIB_VALID | COMP_FLAG_FMT_CHANGE))
 				goto sem_rel_return;
 			if (hw->adp->pdev->device == BC_PCI_DEVID_LINK) {
 				picYcomp = link_GetRptDropParam(hw, hw->PICHeight, hw->PICWidth, (void *)r_pkt);

--------------040304050203060608040601--
