Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35996 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863AbbE3SKh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 May 2015 14:10:37 -0400
Received: by wivl4 with SMTP id l4so42944385wiv.1
        for <linux-media@vger.kernel.org>; Sat, 30 May 2015 11:10:36 -0700 (PDT)
From: Jemma Denson <jdenson@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, patrick.boettcher@posteo.de,
	Jemma Denson <jdenson@gmail.com>
Subject: [PATCH v2 1/4] b2c2: Add option to skip the first 6 pid filters
Date: Sat, 30 May 2015 19:10:06 +0100
Message-Id: <1433009409-5622-2-git-send-email-jdenson@gmail.com>
In-Reply-To: <1433009409-5622-1-git-send-email-jdenson@gmail.com>
References: <1433009409-5622-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The flexcop bridge chip has two banks of hardware pid filters -
an initial 6, and on some chip revisions an additional bank of 32.

A bug is present on the initial 6 - when changing transponders
one of two PAT packets from the old transponder would be included
in the initial packets from the new transponder. This usually
transpired with userspace programs complaining about services
missing, because they are seeing a PAT that they would not be
expecting. Running in full TS mode does not exhibit this problem,
neither does using just the additional 32.

This patch adds in an option to not use the inital 6 and solely use
just the additional 32, and enables this option for the SkystarS2
card. Other cards can be added as required if they also have
this bug.

Signed-off-by: Jemma Denson <jdenson@gmail.com>
---
 drivers/media/common/b2c2/flexcop-common.h    |  1 +
 drivers/media/common/b2c2/flexcop-fe-tuner.c  |  3 +++
 drivers/media/common/b2c2/flexcop-hw-filter.c | 16 ++++++++++++++--
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/b2c2/flexcop-common.h b/drivers/media/common/b2c2/flexcop-common.h
index 437912e..2b2460e 100644
--- a/drivers/media/common/b2c2/flexcop-common.h
+++ b/drivers/media/common/b2c2/flexcop-common.h
@@ -91,6 +91,7 @@ struct flexcop_device {
 	int feedcount;
 	int pid_filtering;
 	int fullts_streaming_state;
+	int skip_6_hw_pid_filter;
 
 	/* bus specific callbacks */
 	flexcop_ibi_value(*read_ibi_reg) (struct flexcop_device *,
diff --git a/drivers/media/common/b2c2/flexcop-fe-tuner.c b/drivers/media/common/b2c2/flexcop-fe-tuner.c
index 2426062..31ebf1e 100644
--- a/drivers/media/common/b2c2/flexcop-fe-tuner.c
+++ b/drivers/media/common/b2c2/flexcop-fe-tuner.c
@@ -651,6 +651,9 @@ static int skystarS2_rev33_attach(struct flexcop_device *fc,
 	}
 	info("ISL6421 successfully attached.");
 
+	if (fc->has_32_hw_pid_filter)
+		fc->skip_6_hw_pid_filter = 1;
+
 	return 1;
 }
 #else
diff --git a/drivers/media/common/b2c2/flexcop-hw-filter.c b/drivers/media/common/b2c2/flexcop-hw-filter.c
index 77e4547..8220257 100644
--- a/drivers/media/common/b2c2/flexcop-hw-filter.c
+++ b/drivers/media/common/b2c2/flexcop-hw-filter.c
@@ -117,6 +117,10 @@ static void flexcop_pid_control(struct flexcop_device *fc,
 	deb_ts("setting pid: %5d %04x at index %d '%s'\n",
 			pid, pid, index, onoff ? "on" : "off");
 
+	/* First 6 can be buggy - skip over them if option set */
+	if (fc->skip_6_hw_pid_filter)
+		index += 6;
+
 	/* We could use bit magic here to reduce source code size.
 	 * I decided against it, but to use the real register names */
 	switch (index) {
@@ -170,7 +174,10 @@ static int flexcop_toggle_fullts_streaming(struct flexcop_device *fc, int onoff)
 int flexcop_pid_feed_control(struct flexcop_device *fc,
 		struct dvb_demux_feed *dvbdmxfeed, int onoff)
 {
-	int max_pid_filter = 6 + fc->has_32_hw_pid_filter*32;
+	int max_pid_filter = 6;
+
+	max_pid_filter -= 6 * fc->skip_6_hw_pid_filter;
+	max_pid_filter += 32 * fc->has_32_hw_pid_filter;
 
 	fc->feedcount += onoff ? 1 : -1; /* the number of PIDs/Feed currently requested */
 	if (dvbdmxfeed->index >= max_pid_filter)
@@ -217,7 +224,12 @@ void flexcop_hw_filter_init(struct flexcop_device *fc)
 {
 	int i;
 	flexcop_ibi_value v;
-	for (i = 0; i < 6 + 32*fc->has_32_hw_pid_filter; i++)
+	int max_pid_filter = 6;
+
+	max_pid_filter -= 6 * fc->skip_6_hw_pid_filter;
+	max_pid_filter += 32 * fc->has_32_hw_pid_filter;
+
+	for (i = 0; i < max_pid_filter; i++)
 		flexcop_pid_control(fc, i, 0x1fff, 0);
 
 	flexcop_pid_group_filter(fc, 0, 0x1fe0);
-- 
2.1.0

