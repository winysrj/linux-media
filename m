Return-path: <mchehab@pedra>
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:60823 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722Ab1EDLjR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 07:39:17 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Steven Toth <stoth@kernellabs.com>,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Subject: [PATCH] cx18: Bump driver version to 1.5.0
Date: Wed,  4 May 2011 12:39:07 +0100
Message-Id: <1304509147-28058-1-git-send-email-simon.farnsworth@onelan.co.uk>
In-Reply-To: <4DC138F7.5050400@infradead.org>
References: <4DC138F7.5050400@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

To simplify maintainer support of this driver, bump the version to
1.5.0 - this will be the first version that is expected to support
mmap() for raw video frames.

Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
---
Mauro,

This is an incremental patch to apply on top of my cleanup patch - if
you would prefer a complete new patch with this squashed into the
cleanup patch, just ask and it will be done.

 drivers/media/video/cx18/cx18-version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-version.h b/drivers/media/video/cx18/cx18-version.h
index 62c6ca2..cd189b6 100644
--- a/drivers/media/video/cx18/cx18-version.h
+++ b/drivers/media/video/cx18/cx18-version.h
@@ -24,8 +24,8 @@
 
 #define CX18_DRIVER_NAME "cx18"
 #define CX18_DRIVER_VERSION_MAJOR 1
-#define CX18_DRIVER_VERSION_MINOR 4
-#define CX18_DRIVER_VERSION_PATCHLEVEL 1
+#define CX18_DRIVER_VERSION_MINOR 5
+#define CX18_DRIVER_VERSION_PATCHLEVEL 0
 
 #define CX18_VERSION __stringify(CX18_DRIVER_VERSION_MAJOR) "." __stringify(CX18_DRIVER_VERSION_MINOR) "." __stringify(CX18_DRIVER_VERSION_PATCHLEVEL)
 #define CX18_DRIVER_VERSION KERNEL_VERSION(CX18_DRIVER_VERSION_MAJOR, \
-- 
1.7.4

