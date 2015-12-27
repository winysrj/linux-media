Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout05.plus.net ([84.93.230.250]:35017 "EHLO
	avasout05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbbL0TOY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2015 14:14:24 -0500
From: Chris Mayo <aklhfex@gmail.com>
To: linux-media@vger.kernel.org
Subject: [v4l-utils PATCH] man: Fix typos in dvbv5-scan dvbv5-zap pages
Date: Sun, 27 Dec 2015 19:06:45 +0000
Message-Id: <1451243205-22517-1-git-send-email-aklhfex@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Chris Mayo <aklhfex@gmail.com>
---
 utils/dvb/dvbv5-scan.1.in | 2 +-
 utils/dvb/dvbv5-zap.1.in  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/dvb/dvbv5-scan.1.in b/utils/dvb/dvbv5-scan.1.in
index 8958ceb..e6fe3ee 100644
--- a/utils/dvb/dvbv5-scan.1.in
+++ b/utils/dvb/dvbv5-scan.1.in
@@ -172,7 +172,7 @@ New transponder/channel found: #39: 507000000
 .fi
 .PP
 The scan process will then scan the other 38 discovered new transponders,
-and generate a dvb_channel.com with several entries with will have not only
+and generate a dvb_channel.conf with several entries with will have not only
 the physical channel/transponder info, but also the Service ID, and the
 corresponding audio/video/other program IDs (PID), like:
 .PP
diff --git a/utils/dvb/dvbv5-zap.1.in b/utils/dvb/dvbv5-zap.1.in
index 9bf2687..2445593 100644
--- a/utils/dvb/dvbv5-zap.1.in
+++ b/utils/dvb/dvbv5-zap.1.in
@@ -167,7 +167,7 @@ DVR interface '/dev/dvb/adapter0/dvr0' can now be opened
 The channel can be watched by playing the contents of the DVR interface,
 with some player that recognizes the MPEG\-TS format.
 .PP
-For example, this audio-only channel can be playew with mplayer:
+For example, this audio-only channel can be played with mplayer:
 .PP
 .nf
 $ \fBmplayer \-cache 800 /dev/dvb/adapter0/dvr0\fR
-- 
2.4.10

