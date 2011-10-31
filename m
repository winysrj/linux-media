Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48795 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab1JaQZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:25:46 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so5444413eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:25:46 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>
Subject: [PATCH 08/17] staging: as102: Fix CodingStyle errors in file as10x_cmd_cfg.c
Date: Mon, 31 Oct 2011 17:24:46 +0100
Message-Id: <1320078295-3379-9-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
References: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Fix Linux kernel coding style (whitespace and indentation) errors
in file as10x_cmd_cfg.c. No functional changes.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as10x_cmd_cfg.c |  262 +++++++++++++--------------
 1 files changed, 130 insertions(+), 132 deletions(-)

diff --git a/drivers/staging/media/as102/as10x_cmd_cfg.c b/drivers/staging/media/as102/as10x_cmd_cfg.c
index e3a0f90..7b22e19 100644
--- a/drivers/staging/media/as102/as10x_cmd_cfg.c
+++ b/drivers/staging/media/as102/as10x_cmd_cfg.c
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
-
-   ENTER();
-
-   pcmd = phandle->cmd;
-   prsp = phandle->rsp;
-
-   /* prepare command */
-   as10x_cmd_build(pcmd, (++phandle->cmd_xid),
-		    sizeof(pcmd->body.context.req));
-
-   /* fill command */
-   pcmd->body.context.req.proc_id      = cpu_to_le16(CONTROL_PROC_CONTEXT);
-   pcmd->body.context.req.tag          = cpu_to_le16(tag);
-   pcmd->body.context.req.type         = cpu_to_le16(GET_CONTEXT_DATA);
-
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
-
-   if(error < 0) {
-      goto out;
-   }
-
-   /* parse response: context command do not follow the common response */
-   /* structure -> specific handling response parse required            */
-   error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);
-
-   if(error == 0) {
-     /* Response OK -> get response data */
-      *pvalue = le32_to_cpu(prsp->body.context.rsp.reg_val.u.value32);
-     /* value returned is always a 32-bit value */
-   }
+	int  error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.context.req));
+
+	/* fill command */
+	pcmd->body.context.req.proc_id = cpu_to_le16(CONTROL_PROC_CONTEXT);
+	pcmd->body.context.req.tag = cpu_to_le16(tag);
+	pcmd->body.context.req.type = cpu_to_le16(GET_CONTEXT_DATA);
+
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
+
+	if (error < 0)
+		goto out;
+
+	/* parse response: context command do not follow the common response */
+	/* structure -> specific handling response parse required            */
+	error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);
+
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
@@ -118,47 +117,48 @@ out:
 int as10x_cmd_set_context(as10x_handle_t *phandle, uint16_t tag,
 			  uint32_t value)
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
-   as10x_cmd_build(pcmd,(++phandle->cmd_xid),sizeof(pcmd->body.context.req));
-
-   /* fill command */
-   pcmd->body.context.req.proc_id      = cpu_to_le16(CONTROL_PROC_CONTEXT);
-      /* pcmd->body.context.req.reg_val.mode initialization is not required */
-   pcmd->body.context.req.reg_val.u.value32 = cpu_to_le32(value);
-   pcmd->body.context.req.tag          = cpu_to_le16(tag);
-   pcmd->body.context.req.type         = cpu_to_le16(SET_CONTEXT_DATA);
-
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
-
-   if(error < 0) {
-      goto out;
-   }
-
-   /* parse response: context command do not follow the common response */
-   /* structure -> specific handling response parse required            */
-   error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);
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
+			sizeof(pcmd->body.context.req));
+
+	/* fill command */
+	pcmd->body.context.req.proc_id = cpu_to_le16(CONTROL_PROC_CONTEXT);
+	/* pcmd->body.context.req.reg_val.mode initialization is not required */
+	pcmd->body.context.req.reg_val.u.value32 = cpu_to_le32(value);
+	pcmd->body.context.req.tag = cpu_to_le16(tag);
+	pcmd->body.context.req.type = cpu_to_le16(SET_CONTEXT_DATA);
+
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
+
+	if (error < 0)
+		goto out;
+
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
@@ -175,45 +175,43 @@ out:
 */
 int as10x_cmd_eLNA_change_mode(as10x_handle_t *phandle, uint8_t mode)
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
-		   sizeof(pcmd->body.cfg_change_mode.req));
-
-   /* fill command */
-   pcmd->body.cfg_change_mode.req.proc_id =
-				    cpu_to_le16(CONTROL_PROC_ELNA_CHANGE_MODE);
-   pcmd->body.cfg_change_mode.req.mode    = mode;
-
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
-
-   if(error < 0) {
-      goto out;
-   }
-
-   /* parse response */
-   error = as10x_rsp_parse(prsp, CONTROL_PROC_ELNA_CHANGE_MODE_RSP);
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
+			sizeof(pcmd->body.cfg_change_mode.req));
+
+	/* fill command */
+	pcmd->body.cfg_change_mode.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_ELNA_CHANGE_MODE);
+	pcmd->body.cfg_change_mode.req.mode = mode;
+
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
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_ELNA_CHANGE_MODE_RSP);
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
 /**
@@ -225,15 +223,15 @@ out:
 	   ABILIS_RC_NOK
    \callgraph
 */
-int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id) {
-
-   int err;
+int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id)
+{
+	int err;
 
-   err = prsp->body.context.rsp.error;
+	err = prsp->body.context.rsp.error;
 
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
-- 
1.7.4.1

