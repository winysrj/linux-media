Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail11a.verio-web.com ([204.202.242.23]:2860 "HELO
	mail11a.verio-web.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751868AbZD3P3o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 11:29:44 -0400
Received: from mx39.stngva01.us.mxservers.net (204.202.242.107)
	by mail11a.verio-web.com (RS ver 1.0.95vs) with SMTP id 2-0198075382
	for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 11:29:42 -0400 (EDT)
Date: Thu, 30 Apr 2009 08:29:38 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
Subject: patch: s2255drv: urb completion routine fixes
To: linux-media@vger.kernel.org, video4linux-list@redhat.com,
	mchehab@infradead.org
Message-ID: <tkrat.5b56fa3a69c1e6ea@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dean Anderson <dean@sensoray.com>

Error count in read pipe completion corrected.
URB not resubmitted if shutting down.
URB not freed in completion routine if new urb_submit_fails.
(URB is freed on shutdown).

Signed-off-by: Dean Anderson <dean@sensoray.com>

--- v4l-dvb-83712d149893/linux/drivers/media/video/s2255drv.c.orig	2009-04-30 07:34:34.000000000 -0700
+++ v4l-dvb-83712d149893/linux/drivers/media/video/s2255drv.c	2009-04-30 07:27:10.000000000 -0700
@@ -2240,8 +2240,10 @@ static void read_pipe_completion(struct 
 		return;
 	}
 	status = purb->status;
-	if (status != 0) {
-		dprintk(2, "read_pipe_completion: err\n");
+	/* if shutting down, do not resubmit, exit immediately */
+	if (status == -ESHUTDOWN) {
+		dprintk(2, "read_pipe_completion: err shutdown\n");
+		pipe_info->err_count++;
 		return;
 	}
 
@@ -2250,9 +2252,13 @@ static void read_pipe_completion(struct 
 		return;
 	}
 
-	s2255_read_video_callback(dev, pipe_info);
+	if (status == 0)
+		s2255_read_video_callback(dev, pipe_info);
+	else {
+		pipe_info->err_count++;
+		dprintk(1, "s2255drv: failed URB %d\n", status);
+	}
 
-	pipe_info->err_count = 0;
 	pipe = usb_rcvbulkpipe(dev->udev, dev->read_endpoint);
 	/* reuse urb */
 	usb_fill_bulk_urb(pipe_info->stream_urb, dev->udev,
@@ -2264,7 +2270,6 @@ static void read_pipe_completion(struct 
 	if (pipe_info->state != 0) {
 		if (usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL)) {
 			dev_err(&dev->udev->dev, "error submitting urb\n");
-			usb_free_urb(pipe_info->stream_urb);
 		}
 	} else {
 		dprintk(2, "read pipe complete state 0\n");

