Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo13.poczta.onet.pl ([213.180.142.144]:41194 "EHLO
	smtpo13.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab1JRTyQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 15:54:16 -0400
Date: Tue, 18 Oct 2011 21:54:13 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [RESEND PATCH 5/14] staging/media/as102: checkpatch fixes
Message-ID: <20111018215413.119601a2@darkstar>
In-Reply-To: <20111018111156.1fc2f267.chmooreck@poczta.onet.pl>
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
	<20111018111156.1fc2f267.chmooreck@poczta.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/

Original source and comment:
# HG changeset patch
# User Devin Heitmueller <dheitmueller@kernellabs.com>
# Date 1267318751 18000
# Node ID 1ccb2e0adbf02a111decf8a4c78e93f4354e2bd2
# Parent  69c8f5172790784738bcc18f8301919ef3d5373f
as102: checkpatch fixes

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Fix make checkpatch issues reported against as10x_cmd_stream.c.

Priority: normal

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>

diff --git linux/drivers/staging/media/as102/as10x_cmd_stream.c linuxb/drivers/staging/media/as102/as10x_cmd_stream.c
--- linux/drivers/staging/media/as102/as10x_cmd_stream.c
+++ linuxb/drivers/staging/media/as102/as10x_cmd_stream.c
@@ -2,8 +2,6 @@
 
  \file   as10x_cmd_stream.c
 
- \version $Id$
-
  \author: S. Martinelli
 
  ----------------------------------------------------------------------------\n
@@ -53,57 +51,57 @@
    \return 0 when no error, < 0 in case of error.
    \callgraph
 */
-int as10x_cmd_add_PID_filter(as10x_handle_t* phandle,
-			     struct as10x_ts_filter *filter) {
-   int    error;
-   struct as10x_cmd_t *pcmd, *prsp;
+int as10x_cmd_add_PID_filter(as10x_handle_t *phandle,
+			     struct as10x_ts_filter *filter)
+{
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
-		    sizeof(pcmd->body.add_pid_filter.req));
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.add_pid_filter.req));
 
-   /* fill command */
-   pcmd->body.add_pid_filter.req.proc_id = cpu_to_le16(CONTROL_PROC_SETFILTER);
-   pcmd->body.add_pid_filter.req.pid = cpu_to_le16(filter->pid);
-   pcmd->body.add_pid_filter.req.stream_type = filter->type;
+	/* fill command */
+	pcmd->body.add_pid_filter.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_SETFILTER);
+	pcmd->body.add_pid_filter.req.pid = cpu_to_le16(filter->pid);
+	pcmd->body.add_pid_filter.req.stream_type = filter->type;
 
-   if(filter->idx < 16)
-	pcmd->body.add_pid_filter.req.idx = filter->idx;
-   else
-	pcmd->body.add_pid_filter.req.idx = 0xFF;
+	if (filter->idx < 16)
+		pcmd->body.add_pid_filter.req.idx = filter->idx;
+	else
+		pcmd->body.add_pid_filter.req.idx = 0xFF;
 
-   /* send command */
-   if(phandle->ops->xfer_cmd) {
-      error = phandle->ops->xfer_cmd(phandle,
-		       (uint8_t *) pcmd,
-		       sizeof(pcmd->body.add_pid_filter.req) + HEADER_SIZE,
-		       (uint8_t *) prsp,
-		       sizeof(prsp->body.add_pid_filter.rsp) + HEADER_SIZE);
-   }
-   else{
-      error = AS10X_CMD_ERROR;
-   }
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+				sizeof(pcmd->body.add_pid_filter.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.add_pid_filter.rsp)
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
-   error = as10x_rsp_parse(prsp, CONTROL_PROC_SETFILTER_RSP);
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_SETFILTER_RSP);
 
-   if(error == 0) {
-     /* Response OK -> get response data */
-     filter->idx = prsp->body.add_pid_filter.rsp.filter_id;
-   }
+	if (error == 0) {
+		/* Response OK -> get response data */
+		filter->idx = prsp->body.add_pid_filter.rsp.filter_id;
+	}
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
 /**
@@ -113,144 +111,138 @@
    \return 0 when no error, < 0 in case of error.
    \callgraph
 */
-int as10x_cmd_del_PID_filter(as10x_handle_t* phandle,
+int as10x_cmd_del_PID_filter(as10x_handle_t *phandle,
 			     uint16_t pid_value)
 {
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
 
-   int    error;
-   struct as10x_cmd_t *pcmd, *prsp;
+	ENTER();
 
-   ENTER();
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
 
-   pcmd = phandle->cmd;
-   prsp = phandle->rsp;
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.del_pid_filter.req));
 
-   /* prepare command */
-   as10x_cmd_build(pcmd, (++phandle->cmd_xid),
-		    sizeof(pcmd->body.del_pid_filter.req));
+	/* fill command */
+	pcmd->body.del_pid_filter.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_REMOVEFILTER);
+	pcmd->body.del_pid_filter.req.pid = cpu_to_le16(pid_value);
 
-   /* fill command */
-   pcmd->body.del_pid_filter.req.proc_id = cpu_to_le16(CONTROL_PROC_REMOVEFILTER);
-   pcmd->body.del_pid_filter.req.pid = cpu_to_le16(pid_value);
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+				sizeof(pcmd->body.del_pid_filter.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.del_pid_filter.rsp)
+				+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
 
-   /* send command */
-   if(phandle->ops->xfer_cmd){
-      error = phandle->ops->xfer_cmd(phandle,
-		       (uint8_t *) pcmd,
-		       sizeof(pcmd->body.del_pid_filter.req) + HEADER_SIZE,
-		       (uint8_t *) prsp,
-		       sizeof(prsp->body.del_pid_filter.rsp) + HEADER_SIZE);
-   }
-   else{
-      error = AS10X_CMD_ERROR;
-   }
+	if (error < 0)
+		goto out;
 
-   if(error < 0) {
-      goto out;
-   }
-
-   /* parse response */
-   error = as10x_rsp_parse(prsp, CONTROL_PROC_REMOVEFILTER_RSP);
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_REMOVEFILTER_RSP);
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
 /**
    \brief Send start streaming command to AS10x
    \param  phandle:   pointer to AS10x handle
-   \return 0 when no error, < 0 in case of error._
+   \return 0 when no error, < 0 in case of error.
    \callgraph
 */
-int as10x_cmd_start_streaming(as10x_handle_t* phandle)
+int as10x_cmd_start_streaming(as10x_handle_t *phandle)
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
-		    sizeof(pcmd->body.start_streaming.req));
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.start_streaming.req));
 
-   /* fill command */
-   pcmd->body.start_streaming.req.proc_id =
-				   cpu_to_le16(CONTROL_PROC_START_STREAMING);
+	/* fill command */
+	pcmd->body.start_streaming.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_START_STREAMING);
 
-   /* send command */
-   if(phandle->ops->xfer_cmd){
-      error = phandle->ops->xfer_cmd(phandle,
-		       (uint8_t *) pcmd,
-		       sizeof(pcmd->body.start_streaming.req) + HEADER_SIZE,
-		       (uint8_t *) prsp,
-		       sizeof(prsp->body.start_streaming.rsp) + HEADER_SIZE);
-   }
-   else{
-      error = AS10X_CMD_ERROR;
-   }
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+				sizeof(pcmd->body.start_streaming.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.start_streaming.rsp)
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
-   error = as10x_rsp_parse(prsp, CONTROL_PROC_START_STREAMING_RSP);
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_START_STREAMING_RSP);
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
 /**
    \brief Send stop streaming command to AS10x
    \param  phandle:   pointer to AS10x handle
-   \return 0 when no error, < 0 in case of error._
+   \return 0 when no error, < 0 in case of error.
    \callgraph
 */
-int as10x_cmd_stop_streaming(as10x_handle_t* phandle)
+int as10x_cmd_stop_streaming(as10x_handle_t *phandle)
 {
-   int8_t error;
-   struct as10x_cmd_t *pcmd, *prsp;
+	int8_t error;
+	struct as10x_cmd_t *pcmd, *prsp;
 
-   ENTER();
+	ENTER();
 
-   pcmd = phandle->cmd;
-   prsp = phandle->rsp;
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
 
-   /* prepare command */
-   as10x_cmd_build(pcmd, (++phandle->cmd_xid),
-		    sizeof(pcmd->body.stop_streaming.req));
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.stop_streaming.req));
 
-   /* fill command */
-   pcmd->body.stop_streaming.req.proc_id =
-				   cpu_to_le16(CONTROL_PROC_STOP_STREAMING);
+	/* fill command */
+	pcmd->body.stop_streaming.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_STOP_STREAMING);
 
-   /* send command */
-   if(phandle->ops->xfer_cmd){
-      error = phandle->ops->xfer_cmd(phandle,
-		       (uint8_t *) pcmd,
-		       sizeof(pcmd->body.stop_streaming.req) + HEADER_SIZE,
-		       (uint8_t *) prsp,
-		       sizeof(prsp->body.stop_streaming.rsp) + HEADER_SIZE);
-   }
-   else{
-      error = AS10X_CMD_ERROR;
-   }
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+				sizeof(pcmd->body.stop_streaming.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.stop_streaming.rsp)
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
-   error = as10x_rsp_parse(prsp, CONTROL_PROC_STOP_STREAMING_RSP);
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_STOP_STREAMING_RSP);
 
 out:
-   LEAVE();
-   return(error);
+	LEAVE();
+	return error;
 }
 
