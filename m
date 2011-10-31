Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58562 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab1JaQZl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:25:41 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so5444327eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:25:40 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>
Subject: =?UTF-8?q?=5BPATCH=2005/17=5D=20staging=3A=20as102=3A=20Fix=20CodingStyle=20errors=20in=20file=20as10x=5Fcmd=5Fstream=2Ec?=
Date: Mon, 31 Oct 2011 17:24:43 +0100
Message-Id: <1320078295-3379-6-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
References: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Fix Linux kernel coding style (whitespace and indentation) errors
in file as10x_cmd_stream.c. No functional changes.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as10x_cmd_stream.c |  280 ++++++++++++------------
 1 files changed, 136 insertions(+), 144 deletions(-)

diff --git a/drivers/staging/media/as102/as10x_cmd_stream.c b/drivers/staging/media/as102/as10x_cmd_stream.c
index 4dfacf4..8705894 100644
--- a/drivers/staging/media/as102/as10x_cmd_stream.c
+++ b/drivers/staging/media/as102/as10x_cmd_stream.c
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
-
-   ENTER();
-
-   pcmd = phandle->cmd;
-   prsp = phandle->rsp;
-
-   /* prepare command */
-   as10x_cmd_build(pcmd, (++phandle->cmd_xid),
-		    sizeof(pcmd->body.add_pid_filter.req));
-
-   /* fill command */
-   pcmd->body.add_pid_filter.req.proc_id = cpu_to_le16(CONTROL_PROC_SETFILTER);
-   pcmd->body.add_pid_filter.req.pid = cpu_to_le16(filter->pid);
-   pcmd->body.add_pid_filter.req.stream_type = filter->type;
-
-   if(filter->idx < 16)
-	pcmd->body.add_pid_filter.req.idx = filter->idx;
-   else
-	pcmd->body.add_pid_filter.req.idx = 0xFF;
-
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
-
-   if(error < 0) {
-      goto out;
-   }
-
-   /* parse response */
-   error = as10x_rsp_parse(prsp, CONTROL_PROC_SETFILTER_RSP);
-
-   if(error == 0) {
-     /* Response OK -> get response data */
-     filter->idx = prsp->body.add_pid_filter.rsp.filter_id;
-   }
+int as10x_cmd_add_PID_filter(as10x_handle_t *phandle,
+			     struct as10x_ts_filter *filter)
+{
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
+			sizeof(pcmd->body.add_pid_filter.req));
+
+	/* fill command */
+	pcmd->body.add_pid_filter.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_SETFILTER);
+	pcmd->body.add_pid_filter.req.pid = cpu_to_le16(filter->pid);
+	pcmd->body.add_pid_filter.req.stream_type = filter->type;
+
+	if (filter->idx < 16)
+		pcmd->body.add_pid_filter.req.idx = filter->idx;
+	else
+		pcmd->body.add_pid_filter.req.idx = 0xFF;
+
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
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_SETFILTER_RSP);
+
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
@@ -113,144 +111,138 @@ out:
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
-
-   ENTER();
+	ENTER();
 
-   pcmd = phandle->cmd;
-   prsp = phandle->rsp;
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
 
-   /* prepare command */
-   as10x_cmd_build(pcmd, (++phandle->cmd_xid),
-		    sizeof(pcmd->body.del_pid_filter.req));
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.del_pid_filter.req));
 
-   /* fill command */
-   pcmd->body.del_pid_filter.req.proc_id = cpu_to_le16(CONTROL_PROC_REMOVEFILTER);
-   pcmd->body.del_pid_filter.req.pid = cpu_to_le16(pid_value);
+	/* fill command */
+	pcmd->body.del_pid_filter.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_REMOVEFILTER);
+	pcmd->body.del_pid_filter.req.pid = cpu_to_le16(pid_value);
 
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
 
-   if(error < 0) {
-      goto out;
-   }
+	if (error < 0)
+		goto out;
 
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
-   \return 0 when no error, < 0 in case of error. 
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
-   \return 0 when no error, < 0 in case of error. 
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
 
 
-- 
1.7.4.1

