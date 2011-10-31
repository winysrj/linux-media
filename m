Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48795 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab1JaQZj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:25:39 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so5444413eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:25:38 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>
Subject: [PATCH 04/17] staging: as102: Fix CodingStyle errors in file as10x_cmd.c
Date: Mon, 31 Oct 2011 17:24:42 +0100
Message-Id: <1320078295-3379-5-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
References: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Fix Linux kernel coding style (whitespace and indentation) errors
in file as10x_cmd.c. No functional changes.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as10x_cmd.c |  573 ++++++++++++++++---------------
 1 files changed, 288 insertions(+), 285 deletions(-)

diff --git a/drivers/staging/media/as102/as10x_cmd.c b/drivers/staging/media/as102/as10x_cmd.c
index cecb809..222e703 100644
--- a/drivers/staging/media/as102/as10x_cmd.c
+++ b/drivers/staging/media/as102/as10x_cmd.c
@@ -1,6 +1,7 @@
 /*
  * Abilis Systems Single DVB-T Receiver
  * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -21,7 +22,8 @@
 #include <linux/kernel.h>
 #include "as102_drv.h"
 #elif defined(WIN32)
-   #if defined(__BUILDMACHINE__) && (__BUILDMACHINE__ == WinDDK)  /* win32 ddk implementation */
+   #if defined(__BUILDMACHINE__) && (__BUILDMACHINE__ == WinDDK)
+      /* win32 ddk implementation */
       #include "wdm.h"
       #include "Device.h"
       #include "endian_mgmt.h" /* FIXME */
@@ -51,43 +53,42 @@
 */
 int as10x_cmd_turn_on(as10x_handle_t *phandle)
 {
-   int error;
-   struct as10x_cmd_t *pcmd, *prsp;
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
 
-   ENTER();
+	ENTER();
 
-   pcmd = phandle->cmd;
-   prsp = phandle->rsp;
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
 
-   /* prepare command */
-   as10x_cmd_build(pcmd,(++phandle->cmd_xid), sizeof(pcmd->body.turn_on.req));
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.turn_on.req));
 
-   /* fill command */
-   pcmd->body.turn_on.req.proc_id = cpu_to_le16(CONTROL_PROC_TURNON);
+	/* fill command */
+	pcmd->body.turn_on.req.proc_id = cpu_to_le16(CONTROL_PROC_TURNON);
 
-   /* send command */
-   if(phandle->ops->xfer_cmd) {
-      error = phandle->ops->xfer_cmd(
-			phandle,
-			(uint8_t *) pcmd,
-			sizeof(pcmd->body.turn_on.req) + HEADER_SIZE,
-			(uint8_t *) prsp,
-			sizeof(prsp->body.turn_on.rsp) + HEADER_SIZE);
-   }
-   else{
-      error = AS10X_CMD_ERROR;
-   }
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+					       sizeof(pcmd->body.turn_on.req) +
+					       HEADER_SIZE,
+					       (uint8_t *) prsp,
+					       sizeof(prsp->body.turn_on.rsp) +
+					       HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
 
-   if(error < 0) {
-      goto out;
-   }
+	if (error < 0)
+		goto out;
 
-   /* parse response */
-   error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNON_RSP);
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNON_RSP);
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
 /**
@@ -98,42 +99,41 @@ out:
 */
 int as10x_cmd_turn_off(as10x_handle_t *phandle)
 {
-   int error;
-   struct as10x_cmd_t *pcmd, *prsp;
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
 
-   ENTER();
+	ENTER();
 
-   pcmd = phandle->cmd;
-   prsp = phandle->rsp;
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
 
-   /* prepare command */
-   as10x_cmd_build(pcmd,(++phandle->cmd_xid),sizeof(pcmd->body.turn_off.req));
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.turn_off.req));
 
-   /* fill command */
-   pcmd->body.turn_off.req.proc_id = cpu_to_le16(CONTROL_PROC_TURNOFF);
+	/* fill command */
+	pcmd->body.turn_off.req.proc_id = cpu_to_le16(CONTROL_PROC_TURNOFF);
 
-   /* send command */
-   if(phandle->ops->xfer_cmd) {
-      error = phandle->ops->xfer_cmd(
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(
 			phandle, (uint8_t *) pcmd,
 			sizeof(pcmd->body.turn_off.req) + HEADER_SIZE,
-			 (uint8_t *) prsp,
+			(uint8_t *) prsp,
 			sizeof(prsp->body.turn_off.rsp) + HEADER_SIZE);
-   }
-   else{
-      error = AS10X_CMD_ERROR;
-   }
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
 
-   if(error < 0) {
-      goto out;
-   }
+	if (error < 0)
+		goto out;
 
-   /* parse response */
-   error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNOFF_RSP);
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNOFF_RSP);
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
 /**
@@ -145,50 +145,54 @@ out:
  */
 int as10x_cmd_set_tune(as10x_handle_t *phandle, struct as10x_tune_args *ptune)
 {
-   int error;
-   struct as10x_cmd_t *preq, *prsp;
-
-   ENTER();
-
-   preq = phandle->cmd;
-   prsp = phandle->rsp;
-
-   /* prepare command */
-   as10x_cmd_build(preq,(++phandle->cmd_xid),sizeof(preq->body.set_tune.req));
-
-   /* fill command */
-   preq->body.set_tune.req.proc_id                 = cpu_to_le16(CONTROL_PROC_SETTUNE);
-   preq->body.set_tune.req.args.freq               = cpu_to_le32(ptune->freq);
-   preq->body.set_tune.req.args.bandwidth          = ptune->bandwidth;
-   preq->body.set_tune.req.args.hier_select        = ptune->hier_select;
-   preq->body.set_tune.req.args.constellation      = ptune->constellation;
-   preq->body.set_tune.req.args.hierarchy          = ptune->hierarchy;
-   preq->body.set_tune.req.args.interleaving_mode  = ptune->interleaving_mode;
-   preq->body.set_tune.req.args.code_rate          = ptune->code_rate;
-   preq->body.set_tune.req.args.guard_interval     = ptune->guard_interval;
-   preq->body.set_tune.req.args.transmission_mode  = ptune->transmission_mode;
-
-   /* send command */
-   if(phandle->ops->xfer_cmd) {
-      error = phandle->ops->xfer_cmd(phandle,
-			(uint8_t *) preq,
-			sizeof(preq->body.set_tune.req) + HEADER_SIZE,
-			(uint8_t *) prsp,
-			sizeof(prsp->body.set_tune.rsp) + HEADER_SIZE);
-   } else{
-      error = AS10X_CMD_ERROR;
-   }
-
-   if(error < 0) {
-      goto out;
-   }
-
-   /* parse response */
-   error = as10x_rsp_parse(prsp, CONTROL_PROC_SETTUNE_RSP);
+	int error;
+	struct as10x_cmd_t *preq, *prsp;
+
+	ENTER();
+
+	preq = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(preq, (++phandle->cmd_xid),
+			sizeof(preq->body.set_tune.req));
+
+	/* fill command */
+	preq->body.set_tune.req.proc_id = cpu_to_le16(CONTROL_PROC_SETTUNE);
+	preq->body.set_tune.req.args.freq = cpu_to_le32(ptune->freq);
+	preq->body.set_tune.req.args.bandwidth = ptune->bandwidth;
+	preq->body.set_tune.req.args.hier_select = ptune->hier_select;
+	preq->body.set_tune.req.args.constellation = ptune->constellation;
+	preq->body.set_tune.req.args.hierarchy = ptune->hierarchy;
+	preq->body.set_tune.req.args.interleaving_mode  =
+		ptune->interleaving_mode;
+	preq->body.set_tune.req.args.code_rate  = ptune->code_rate;
+	preq->body.set_tune.req.args.guard_interval = ptune->guard_interval;
+	preq->body.set_tune.req.args.transmission_mode  =
+		ptune->transmission_mode;
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle,
+					       (uint8_t *) preq,
+					       sizeof(preq->body.set_tune.req)
+					       + HEADER_SIZE,
+					       (uint8_t *) prsp,
+					       sizeof(prsp->body.set_tune.rsp)
+					       + HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_SETTUNE_RSP);
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
 /**
@@ -198,57 +202,55 @@ out:
    \return 0 when no error, < 0 in case of error.
    \callgraph
  */
-int as10x_cmd_get_tune_status(as10x_handle_t *phandle, struct as10x_tune_status *pstatus)
+int as10x_cmd_get_tune_status(as10x_handle_t *phandle,
+			      struct as10x_tune_status *pstatus)
 {
-   int error;
-   struct as10x_cmd_t  *preq, *prsp;
+	int error;
+	struct as10x_cmd_t  *preq, *prsp;
 
-   ENTER();
+	ENTER();
 
-   preq = phandle->cmd;
-   prsp = phandle->rsp;
+	preq = phandle->cmd;
+	prsp = phandle->rsp;
 
-   /* prepare command */
-   as10x_cmd_build(preq,(++phandle->cmd_xid),
-		   sizeof(preq->body.get_tune_status.req));
+	/* prepare command */
+	as10x_cmd_build(preq, (++phandle->cmd_xid),
+			sizeof(preq->body.get_tune_status.req));
 
-   /* fill command */
-   preq->body.get_tune_status.req.proc_id =
-			cpu_to_le16(CONTROL_PROC_GETTUNESTAT);
+	/* fill command */
+	preq->body.get_tune_status.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_GETTUNESTAT);
 
-   /* send command */
-   if (phandle->ops->xfer_cmd) {
-      error = phandle->ops->xfer_cmd(
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(
 			phandle,
 			(uint8_t *) preq,
 			sizeof(preq->body.get_tune_status.req) + HEADER_SIZE,
 			(uint8_t *) prsp,
 			sizeof(prsp->body.get_tune_status.rsp) + HEADER_SIZE);
-   }
-   else{
-      error = AS10X_CMD_ERROR;
-   }
-
-   if (error < 0) {
-      goto out;
-   }
-
-   /* parse response */
-   error = as10x_rsp_parse(prsp, CONTROL_PROC_GETTUNESTAT_RSP);
-   if (error < 0) {
-      goto out;
-   }
-
-   /* Response OK -> get response data */
-   pstatus->tune_state       = prsp->body.get_tune_status.rsp.sts.tune_state;
-   pstatus->signal_strength  =
-		   le16_to_cpu(prsp->body.get_tune_status.rsp.sts.signal_strength);
-   pstatus->PER              = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.PER);
-   pstatus->BER              = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.BER);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_GETTUNESTAT_RSP);
+	if (error < 0)
+		goto out;
+
+	/* Response OK -> get response data */
+	pstatus->tune_state = prsp->body.get_tune_status.rsp.sts.tune_state;
+	pstatus->signal_strength  =
+		le16_to_cpu(prsp->body.get_tune_status.rsp.sts.signal_strength);
+	pstatus->PER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.PER);
+	pstatus->BER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.BER);
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
 /**
@@ -260,56 +262,58 @@ out:
  */
 int as10x_cmd_get_tps(as10x_handle_t *phandle, struct as10x_tps *ptps)
 {
-
-   int error;
-   struct as10x_cmd_t *pcmd, *prsp;
-
-   ENTER();
-
-   pcmd = phandle->cmd;
-   prsp = phandle->rsp;
-
-   /* prepare command */
-   as10x_cmd_build(pcmd, (++phandle->cmd_xid),sizeof(pcmd->body.get_tps.req));
-
-   /* fill command */
-   pcmd->body.get_tune_status.req.proc_id = cpu_to_le16(CONTROL_PROC_GETTPS);
-
-   /* send command */
-   if(phandle->ops->xfer_cmd) {
-      error = phandle->ops->xfer_cmd(phandle,
-	       (uint8_t *) pcmd, sizeof(pcmd->body.get_tps.req) + HEADER_SIZE,
-	       (uint8_t *) prsp, sizeof(prsp->body.get_tps.rsp) + HEADER_SIZE);
-   }
-   else{
-      error = AS10X_CMD_ERROR;
-   }
-
-   if(error < 0) {
-      goto out;
-   }
-
-   /* parse response */
-   error = as10x_rsp_parse(prsp, CONTROL_PROC_GETTPS_RSP);
-   if (error < 0) {
-      goto out;
-   }
-
-   /* Response OK -> get response data */
-   ptps->constellation      = prsp->body.get_tps.rsp.tps.constellation;
-   ptps->hierarchy          = prsp->body.get_tps.rsp.tps.hierarchy;
-   ptps->interleaving_mode  = prsp->body.get_tps.rsp.tps.interleaving_mode;
-   ptps->code_rate_HP       = prsp->body.get_tps.rsp.tps.code_rate_HP;
-   ptps->code_rate_LP       = prsp->body.get_tps.rsp.tps.code_rate_LP;
-   ptps->guard_interval     = prsp->body.get_tps.rsp.tps.guard_interval;
-   ptps->transmission_mode  = prsp->body.get_tps.rsp.tps.transmission_mode;
-   ptps->DVBH_mask_HP       = prsp->body.get_tps.rsp.tps.DVBH_mask_HP;
-   ptps->DVBH_mask_LP       = prsp->body.get_tps.rsp.tps.DVBH_mask_LP;
-   ptps->cell_ID            = le16_to_cpu(prsp->body.get_tps.rsp.tps.cell_ID);
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.get_tps.req));
+
+	/* fill command */
+	pcmd->body.get_tune_status.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_GETTPS);
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle,
+					       (uint8_t *) pcmd,
+					       sizeof(pcmd->body.get_tps.req) +
+					       HEADER_SIZE,
+					       (uint8_t *) prsp,
+					       sizeof(prsp->body.get_tps.rsp) +
+					       HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_GETTPS_RSP);
+	if (error < 0)
+		goto out;
+
+	/* Response OK -> get response data */
+	ptps->constellation = prsp->body.get_tps.rsp.tps.constellation;
+	ptps->hierarchy = prsp->body.get_tps.rsp.tps.hierarchy;
+	ptps->interleaving_mode = prsp->body.get_tps.rsp.tps.interleaving_mode;
+	ptps->code_rate_HP = prsp->body.get_tps.rsp.tps.code_rate_HP;
+	ptps->code_rate_LP = prsp->body.get_tps.rsp.tps.code_rate_LP;
+	ptps->guard_interval = prsp->body.get_tps.rsp.tps.guard_interval;
+	ptps->transmission_mode  = prsp->body.get_tps.rsp.tps.transmission_mode;
+	ptps->DVBH_mask_HP = prsp->body.get_tps.rsp.tps.DVBH_mask_HP;
+	ptps->DVBH_mask_LP = prsp->body.get_tps.rsp.tps.DVBH_mask_LP;
+	ptps->cell_ID = le16_to_cpu(prsp->body.get_tps.rsp.tps.cell_ID);
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
 /**
@@ -322,59 +326,58 @@ out:
 int as10x_cmd_get_demod_stats(as10x_handle_t  *phandle,
 			      struct as10x_demod_stats *pdemod_stats)
 {
-   int error;
-   struct as10x_cmd_t *pcmd, *prsp;
-
-   ENTER();
-
-   pcmd = phandle->cmd;
-   prsp = phandle->rsp;
-
-   /* prepare command */
-   as10x_cmd_build(pcmd, (++phandle->cmd_xid),
-		   sizeof(pcmd->body.get_demod_stats.req));
-
-   /* fill command */
-   pcmd->body.get_demod_stats.req.proc_id =
-      cpu_to_le16(CONTROL_PROC_GET_DEMOD_STATS);
-
-   /* send command */
-   if(phandle->ops->xfer_cmd) {
-      error = phandle->ops->xfer_cmd(phandle,
-			 (uint8_t *) pcmd,
-			 sizeof(pcmd->body.get_demod_stats.req) + HEADER_SIZE,
-			 (uint8_t *) prsp,
-			 sizeof(prsp->body.get_demod_stats.rsp) + HEADER_SIZE);
-   }
-   else{
-      error = AS10X_CMD_ERROR;
-   }
-
-   if(error < 0) {
-      goto out;
-   }
-
-   /* parse response */
-   error = as10x_rsp_parse(prsp,CONTROL_PROC_GET_DEMOD_STATS_RSP);
-   if (error < 0) {
-      goto out;
-   }
-
-   /* Response OK -> get response data */
-   pdemod_stats->frame_count =
-	   le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.frame_count);
-   pdemod_stats->bad_frame_count =
-	   le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bad_frame_count);
-   pdemod_stats->bytes_fixed_by_rs =
-	   le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bytes_fixed_by_rs);
-   pdemod_stats->mer =
-	   le16_to_cpu(prsp->body.get_demod_stats.rsp.stats.mer);
-   pdemod_stats->has_started =
-	   prsp->body.get_demod_stats.rsp.stats.has_started;
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.get_demod_stats.req));
+
+	/* fill command */
+	pcmd->body.get_demod_stats.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_GET_DEMOD_STATS);
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle,
+				(uint8_t *) pcmd,
+				sizeof(pcmd->body.get_demod_stats.req)
+				+ HEADER_SIZE,
+				(uint8_t *) prsp,
+				sizeof(prsp->body.get_demod_stats.rsp)
+				+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_GET_DEMOD_STATS_RSP);
+	if (error < 0)
+		goto out;
+
+	/* Response OK -> get response data */
+	pdemod_stats->frame_count =
+		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.frame_count);
+	pdemod_stats->bad_frame_count =
+		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bad_frame_count);
+	pdemod_stats->bytes_fixed_by_rs =
+		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bytes_fixed_by_rs);
+	pdemod_stats->mer =
+		le16_to_cpu(prsp->body.get_demod_stats.rsp.stats.mer);
+	pdemod_stats->has_started =
+		prsp->body.get_demod_stats.rsp.stats.has_started;
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
 /**
@@ -388,50 +391,49 @@ out:
 int as10x_cmd_get_impulse_resp(as10x_handle_t     *phandle,
 			       uint8_t *is_ready)
 {
-   int error;
-   struct as10x_cmd_t *pcmd, *prsp;
-
-   ENTER();
-
-   pcmd = phandle->cmd;
-   prsp = phandle->rsp;
-
-   /* prepare command */
-   as10x_cmd_build(pcmd, (++phandle->cmd_xid),
-		   sizeof(pcmd->body.get_impulse_rsp.req));
-
-   /* fill command */
-   pcmd->body.get_impulse_rsp.req.proc_id =
-      cpu_to_le16(CONTROL_PROC_GET_IMPULSE_RESP);
-
-   /* send command */
-   if(phandle->ops->xfer_cmd) {
-      error = phandle->ops->xfer_cmd(phandle,
-			 (uint8_t *) pcmd,
-			 sizeof(pcmd->body.get_impulse_rsp.req) + HEADER_SIZE,
-			 (uint8_t *) prsp,
-			 sizeof(prsp->body.get_impulse_rsp.rsp) + HEADER_SIZE);
-   }
-   else{
-      error = AS10X_CMD_ERROR;
-   }
-
-   if(error < 0) {
-      goto out;
-   }
-
-   /* parse response */
-   error = as10x_rsp_parse(prsp,CONTROL_PROC_GET_IMPULSE_RESP_RSP);
-   if (error < 0) {
-      goto out;
-   }
-
-   /* Response OK -> get response data */
-   *is_ready = prsp->body.get_impulse_rsp.rsp.is_ready;
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.get_impulse_rsp.req));
+
+	/* fill command */
+	pcmd->body.get_impulse_rsp.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_GET_IMPULSE_RESP);
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle,
+					(uint8_t *) pcmd,
+					sizeof(pcmd->body.get_impulse_rsp.req)
+					+ HEADER_SIZE,
+					(uint8_t *) prsp,
+					sizeof(prsp->body.get_impulse_rsp.rsp)
+					+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_GET_IMPULSE_RESP_RSP);
+	if (error < 0)
+		goto out;
+
+	/* Response OK -> get response data */
+	*is_ready = prsp->body.get_impulse_rsp.rsp.is_ready;
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
 
@@ -447,10 +449,10 @@ out:
 void as10x_cmd_build(struct as10x_cmd_t *pcmd,
 		     uint16_t xid, uint16_t cmd_len)
 {
-   pcmd->header.req_id = cpu_to_le16(xid);
-   pcmd->header.prog = cpu_to_le16(SERVICE_PROG_ID);
-   pcmd->header.version = cpu_to_le16(SERVICE_PROG_VERSION);
-   pcmd->header.data_len = cpu_to_le16(cmd_len);
+	pcmd->header.req_id = cpu_to_le16(xid);
+	pcmd->header.prog = cpu_to_le16(SERVICE_PROG_ID);
+	pcmd->header.version = cpu_to_le16(SERVICE_PROG_VERSION);
+	pcmd->header.data_len = cpu_to_le16(cmd_len);
 }
 
 /**
@@ -463,16 +465,17 @@ void as10x_cmd_build(struct as10x_cmd_t *pcmd,
 */
 int as10x_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id)
 {
-   int error;
+	int error;
 
-   /* extract command error code */
-   error = prsp->body.common.rsp.error;
+	/* extract command error code */
+	error = prsp->body.common.rsp.error;
 
-   if((error == 0) && (le16_to_cpu(prsp->body.common.rsp.proc_id) == proc_id)) {
-      return 0;
-   }
+	if ((error == 0) &&
+	    (le16_to_cpu(prsp->body.common.rsp.proc_id) == proc_id)) {
+		return 0;
+	}
 
-   return AS10X_CMD_ERROR;
+	return AS10X_CMD_ERROR;
 }
 
 
-- 
1.7.4.1

