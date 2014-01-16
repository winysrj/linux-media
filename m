Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.hs-offenburg.de ([141.79.128.11]:42364 "EHLO
	mx.hs-offenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaAPSF4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jan 2014 13:05:56 -0500
Received: from [141.79.65.136] (asa2.rz.hs-offenburg.de [141.79.10.2])
	by mx.hs-offenburg.de (8.13.6/8.13.6/SuSE Linux 0.8) with ESMTP id s0GHYw3m014993
	for <linux-media@vger.kernel.org>; Thu, 16 Jan 2014 18:34:58 +0100
Message-ID: <52D81841.7080703@hs-offenburg.de>
Date: Thu, 16 Jan 2014 18:34:57 +0100
From: Andreas Weber <andreas.weber@hs-offenburg.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: patch for display of readbuffers in v4l2-ctl-misc.cpp
Content-Type: multipart/mixed;
 boundary="------------070009090901090800020709"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070009090901090800020709
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dear maintainers,
I think there is a bug in utils/v4l2-ctl/v4l2-ctl-misc.cpp:394
  printf("\tRead buffers     : %d\n", parm.parm.output.writebuffers);
Please consider the attached patch.

-- Andy

--------------070009090901090800020709
Content-Type: text/x-diff;
 name="fix_display_number_of_readbuffers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix_display_number_of_readbuffers.patch"

>From c3b6188d385dce46bed3e8803f661cf0e501522e Mon Sep 17 00:00:00 2001
From: Andreas Weber <andreas.weber@hs-offenburg.de>
Date: Thu, 16 Jan 2014 18:27:14 +0100
Subject: [PATCH] v4l2-ctl-misc.cpp: bugfix display #of readbuffers

---
 utils/v4l2-ctl/v4l2-ctl-misc.cpp |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-misc.cpp b/utils/v4l2-ctl/v4l2-ctl-misc.cpp
index 6857fff..4d11ec8 100644
--- a/utils/v4l2-ctl/v4l2-ctl-misc.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-misc.cpp
@@ -391,7 +391,7 @@ void misc_get(int fd)
 				printf("\tFrames per second: %.3f (%d/%d)\n",
 						(1.0 * tf.denominator) / tf.numerator,
 						tf.denominator, tf.numerator);
-			printf("\tRead buffers     : %d\n", parm.parm.output.writebuffers);
+			printf("\tRead buffers     : %d\n", parm.parm.capture.readbuffers);
 		}
 	}
 
-- 
1.7.10.4


--------------070009090901090800020709--
