Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39546 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3AaLD3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 06:03:29 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHH00I1DL63GP40@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 11:03:27 +0000 (GMT)
Received: from AMDC1061.digital.local ([106.116.147.88])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MHH00L2SLDL5Z50@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 11:03:27 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH] MAINTAINERS: add s5c73m3 driver entry
Date: Thu, 31 Jan 2013 12:03:05 +0100
Message-id: <1359630186-14216-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a58a25..e3c2f09 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6545,6 +6545,13 @@ S:	Maintained
 F:	drivers/media/platform/s3c-camif/
 F:	include/media/s3c_camif.h
 
+SAMSUNG S5C73M3 CAMERA DRIVER
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+M:	Andrzej Hajda <a.hajda@samsung.com>
+L:	linux-media@vger.kernel.org
+S:	Supported
+F:	drivers/media/i2c/s5c73m3/*
+
 SERIAL DRIVERS
 M:	Alan Cox <alan@linux.intel.com>
 L:	linux-serial@vger.kernel.org
-- 
1.7.10.4

