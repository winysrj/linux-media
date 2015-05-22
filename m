Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:34812 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371AbbEVU3C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 16:29:02 -0400
Received: by wghq2 with SMTP id q2so27646942wgh.1
        for <linux-media@vger.kernel.org>; Fri, 22 May 2015 13:29:01 -0700 (PDT)
From: Jemma Denson <jdenson@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, patrick.boettcher@posteo.de,
	Jemma Denson <jdenson@gmail.com>
Subject: [PATCH 2/4] b2c2: Allow external stream control
Date: Fri, 22 May 2015 21:28:26 +0100
Message-Id: <1432326508-6825-3-git-send-email-jdenson@gmail.com>
In-Reply-To: <1432326508-6825-1-git-send-email-jdenson@gmail.com>
References: <1432326508-6825-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch brings in a feature present in the gpl patch portion of
the SkystarS2 driver available for download from Technisat. The
patch is identical save for renaming the configuration variable,
and also directly exposing the flexcop_rcv_data_ctrl() instead of
wrapping it around a separate function.

The feature added is to allow passing control of the flexcop
receive stream to another device, such as the demod chip.

Signed-off-by: Jemma Denson <jdenson@gmail.com>
---
 drivers/media/common/b2c2/flexcop-common.h    | 2 ++
 drivers/media/common/b2c2/flexcop-hw-filter.c | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/b2c2/flexcop-common.h b/drivers/media/common/b2c2/flexcop-common.h
index 2b2460e..7075043 100644
--- a/drivers/media/common/b2c2/flexcop-common.h
+++ b/drivers/media/common/b2c2/flexcop-common.h
@@ -91,6 +91,7 @@ struct flexcop_device {
 	int feedcount;
 	int pid_filtering;
 	int fullts_streaming_state;
+	int external_stream_control;
 	int skip_6_hw_pid_filter;
 
 	/* bus specific callbacks */
@@ -174,6 +175,7 @@ void flexcop_dump_reg(struct flexcop_device *fc,
 		flexcop_ibi_register reg, int num);
 
 /* from flexcop-hw-filter.c */
+void flexcop_rcv_data_ctrl(struct flexcop_device *fc, int onoff);
 int flexcop_pid_feed_control(struct flexcop_device *fc,
 		struct dvb_demux_feed *dvbdmxfeed, int onoff);
 void flexcop_hw_filter_init(struct flexcop_device *fc);
diff --git a/drivers/media/common/b2c2/flexcop-hw-filter.c b/drivers/media/common/b2c2/flexcop-hw-filter.c
index 8220257..eceb9c5 100644
--- a/drivers/media/common/b2c2/flexcop-hw-filter.c
+++ b/drivers/media/common/b2c2/flexcop-hw-filter.c
@@ -5,7 +5,7 @@
  */
 #include "flexcop.h"
 
-static void flexcop_rcv_data_ctrl(struct flexcop_device *fc, int onoff)
+void flexcop_rcv_data_ctrl(struct flexcop_device *fc, int onoff)
 {
 	flexcop_set_ibi_value(ctrl_208, Rcv_Data_sig, onoff);
 	deb_ts("rcv_data is now: '%s'\n", onoff ? "on" : "off");
@@ -206,7 +206,9 @@ int flexcop_pid_feed_control(struct flexcop_device *fc,
 
 	/* if it was the first or last feed request change the stream-status */
 	if (fc->feedcount == onoff) {
-		flexcop_rcv_data_ctrl(fc, onoff);
+		if (!fc->external_stream_control)
+			flexcop_rcv_data_ctrl(fc, onoff);
+
 		if (fc->stream_control) /* device specific stream control */
 			fc->stream_control(fc, onoff);
 
-- 
2.1.0

