Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:56069 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab1JRJQE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 05:16:04 -0400
Date: Tue, 18 Oct 2011 11:12:26 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH 8/14] staging/media/as102: checkpatch fixes
Message-Id: <20111018111226.adab687e.chmooreck@poczta.onet.pl>
In-Reply-To: <20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E999733.2010802@poczta.onet.pl>
	<4E99F2FC.5030200@poczta.onet.pl>
	<20111016105731.09d66f03@stein>
	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
	<4E9ADFAE.8050208@redhat.com>
	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/

Original source and comment:
# HG changeset patch
# User Devin Heitmueller <dheitmueller@kernellabs.com>
# Date 1267318909 18000
# Node ID 89de57601df871f6d951ca13bf52b136f9eadddf
# Parent  152825226bec049f947a844bea2c530fc9269ae5
as102: checkpatch fixes

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Fix make checkpatch issues reported against as10x_cmd_cfg.c.

Priority: normal

Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>

diff --git linux/drivers/staging/media/as102/as10x_cmd_cfg.c linuxb/drivers/media/dvb/as102/as10x_cmd_cfg.c
--- linux/drivers/staging/media/as102/as10x_cmd_cfg.c
+++ linuxb/drivers/staging/media/as102/as10x_cmd_cfg.c
@@ -2,8 +2,6 @@
 
  \file   as10x_cmd_cfg.c
 
- \version $Id$
-
  \author: S. Martinelli
 
  ----------------------------------------------------------------------------\n
@@ -22,7 +20,8 @@
 #include <linux/kernel.h>
 #include "as102_drv.h"
 #elif defined(WIN32)
-   #if defined(__BUILDMACHINE__) && (__BUILDMACHINE__ == WinDDK)  /* win32 ddk implementation */
+   #if defined(__BUILDMACHINE__) && (__BUILDMACHINE__ == WinDDK)
+      /* win32 ddk implementation */
       #include "wdm.h"
       #include "Device.h"
       #include "endian_mgmt.h" /* FIXME */
@@ -59,52 +58,52 @@
 int as10x_cmd_get_context(as10x_handle_t *phandle, uint16_t tag,
 			  uint32_t *pvalue)
 {
-   int  error;
-   struct as10x_cmd_t *pcmd, *prsp;
+	int  error;
+	struct as10x_cmd_t *pcmd, *prsp;
 
-   ENTER();
+	ENTER();
 
-   pcmd = phandle->cmd;
-   prsp = phandle->rsp;
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
 
-   /* prepare command */
-   as10x_cmd_build(pcmd, (++phandle->cmd_xid),
-		    sizeof(pcmd->body.context.req));
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.context.req));
 
-   /* fill command */
-   pcmd->body.context.req.proc_id      = cpu_to_le16(CONTROL_PROC_CONTEXT);
-   pcmd->body.context.req.tag          = cpu_to_le16(tag);
-   pcmd->body.context.req.type         = cpu_to_le16(GET_CONTEXT_DATA);
+	/* fill command */
+	pcmd->body.context.req.proc_id = cpu_to_le16(CONTROL_PROC_CONTEXT);
+	pcmd->body.context.req.tag = cpu_to_le16(tag);
+	pcmd->body.context.req.type = cpu_to_le16(GET_CONTEXT_DATA);
 
-   /* send command */
-   if(phandle->ops->xfer_cmd) {
-      error  = phandle->ops->xfer_cmd(phandle,
-			   (uint8_t *) pcmd,
-			   sizeof(pcmd->body.context.req) + HEADER_SIZE,
-			   (uint8_t *) prsp,
-			   sizeof(prsp->body.context.rsp) + HEADER_SIZE);
-   }
-   else{
-      error = AS10X_CMD_ERROR;
-   }
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error  = phandle->ops->xfer_cmd(phandle,
+						(uint8_t *) pcmd,
+						sizeof(pcmd->body.context.req)
+						+ HEADER_SIZE,
+						(uint8_t *) prsp,
+						sizeof(prsp->body.context.rsp)
+						+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
 
-   if(error < 0) {
-      goto out;
-   }
+	if (error < 0)
+		goto out;
 
-   /* parse response: context command do not follow the common response */
-   /* structure -> specific handling response parse required            */
-   error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);
+	/* parse response: context command do not follow the common response */
+	/* structure -> specific handling response parse required            */
+	error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);
 
-   if(error == 0) {
-     /* Response OK -> get response data */
-      *pvalue = le32_to_cpu(prsp->body.context.rsp.reg_val.u.value32);
-     /* value returned is always a 32-bit value */
-   }
+	if (error == 0) {
+		/* Response OK -> get response data */
+		*pvalue = le32_to_cpu(prsp->body.context.rsp.reg_val.u.value32);
+		/* value returned is always a 32-bit value */
+	}
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
 /**
@@ -118,47 +117,48 @@
 int as10x_cmd_set_context(as10x_handle_t *phandle, uint16_t tag,
 			  uint32_t value)
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
-   as10x_cmd_build(pcmd,(++phandle->cmd_xid),sizeof(pcmd->body.context.req));
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.context.req));
 
-   /* fill command */
-   pcmd->body.context.req.proc_id      = cpu_to_le16(CONTROL_PROC_CONTEXT);
-      /* pcmd->body.context.req.reg_val.mode initialization is not required */
-   pcmd->body.context.req.reg_val.u.value32 = cpu_to_le32(value);
-   pcmd->body.context.req.tag          = cpu_to_le16(tag);
-   pcmd->body.context.req.type         = cpu_to_le16(SET_CONTEXT_DATA);
+	/* fill command */
+	pcmd->body.context.req.proc_id = cpu_to_le16(CONTROL_PROC_CONTEXT);
+	/* pcmd->body.context.req.reg_val.mode initialization is not required */
+	pcmd->body.context.req.reg_val.u.value32 = cpu_to_le32(value);
+	pcmd->body.context.req.tag = cpu_to_le16(tag);
+	pcmd->body.context.req.type = cpu_to_le16(SET_CONTEXT_DATA);
 
-   /* send command */
-   if(phandle->ops->xfer_cmd){
-      error  = phandle->ops->xfer_cmd(phandle,
-				(uint8_t *) pcmd,
-				sizeof(pcmd->body.context.req) + HEADER_SIZE,
-				(uint8_t *) prsp,
-				sizeof(prsp->body.context.rsp) + HEADER_SIZE);
-   }
-   else{
-      error = AS10X_CMD_ERROR;
-   }
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error  = phandle->ops->xfer_cmd(phandle,
+						(uint8_t *) pcmd,
+						sizeof(pcmd->body.context.req)
+						+ HEADER_SIZE,
+						(uint8_t *) prsp,
+						sizeof(prsp->body.context.rsp)
+						+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
 
-   if(error < 0) {
-      goto out;
-   }
+	if (error < 0)
+		goto out;
 
-   /* parse response: context command do not follow the common response */
-   /* structure -> specific handling response parse required            */
-   error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);
+	/* parse response: context command do not follow the common response */
+	/* structure -> specific handling response parse required            */
+	error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
 /**
@@ -175,45 +175,43 @@
 */
 int as10x_cmd_eLNA_change_mode(as10x_handle_t *phandle, uint8_t mode)
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
-   as10x_cmd_build(pcmd, (++phandle->cmd_xid),
-		   sizeof(pcmd->body.cfg_change_mode.req));
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.cfg_change_mode.req));
 
-   /* fill command */
-   pcmd->body.cfg_change_mode.req.proc_id =
-				    cpu_to_le16(CONTROL_PROC_ELNA_CHANGE_MODE);
-   pcmd->body.cfg_change_mode.req.mode    = mode;
+	/* fill command */
+	pcmd->body.cfg_change_mode.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_ELNA_CHANGE_MODE);
+	pcmd->body.cfg_change_mode.req.mode = mode;
 
-   /* send command */
-   if(phandle->ops->xfer_cmd){
-      error  = phandle->ops->xfer_cmd(phandle,
-			 (uint8_t *) pcmd,
-			 sizeof(pcmd->body.cfg_change_mode.req) + HEADER_SIZE,
-			 (uint8_t *) prsp,
-			 sizeof(prsp->body.cfg_change_mode.rsp) + HEADER_SIZE);
-   }
-   else{
-      error = AS10X_CMD_ERROR;
-   }
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error  = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+				sizeof(pcmd->body.cfg_change_mode.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.cfg_change_mode.rsp)
+				+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
 
-   if(error < 0) {
-      goto out;
-   }
+	if (error < 0)
+		goto out;
 
-   /* parse response */
-   error = as10x_rsp_parse(prsp, CONTROL_PROC_ELNA_CHANGE_MODE_RSP);
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_ELNA_CHANGE_MODE_RSP);
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
 /**
@@ -225,15 +223,15 @@
 	   ABILIS_RC_NOK
    \callgraph
 */
-int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id) {
+int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id)
+{
+	int err;
 
-   int err;
+	err = prsp->body.context.rsp.error;
 
-   err = prsp->body.context.rsp.error;
-
-   if((err == 0) &&
-      (le16_to_cpu(prsp->body.context.rsp.proc_id) == proc_id)) {
-      return 0;
-   }
-   return AS10X_CMD_ERROR;
+	if ((err == 0) &&
+	    (le16_to_cpu(prsp->body.context.rsp.proc_id) == proc_id)) {
+		return 0;
+	}
+	return AS10X_CMD_ERROR;
 }
