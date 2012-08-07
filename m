Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49633 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab2HGQm6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 12:42:58 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Anssi Hannula <anssi.hannula@iki.fi>
Subject: [PATCH 09/11] ati_remote: use %*ph to dump small buffers
Date: Tue,  7 Aug 2012 19:43:09 +0300
Message-Id: <1344357792-18202-9-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Anssi Hannula <anssi.hannula@iki.fi>
---
 drivers/media/rc/ati_remote.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 8fa72e2..08aede5 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -331,13 +331,9 @@ static void ati_remote_dump(struct device *dev, unsigned char *data,
 		if (data[0] != (unsigned char)0xff && data[0] != 0x00)
 			dev_warn(dev, "Weird byte 0x%02x\n", data[0]);
 	} else if (len == 4)
-		dev_warn(dev, "Weird key %02x %02x %02x %02x\n",
-		     data[0], data[1], data[2], data[3]);
+		dev_warn(dev, "Weird key %*ph\n", 4, data);
 	else
-		dev_warn(dev,
-			"Weird data, len=%d %02x %02x %02x %02x %02x %02x ...\n",
-			len, data[0], data[1], data[2], data[3], data[4],
-			data[5]);
+		dev_warn(dev, "Weird data, len=%d %*ph ...\n", len, 6, data);
 }
 
 /*
@@ -519,8 +515,7 @@ static void ati_remote_input_report(struct urb *urb)
 
 	if (data[1] != ((data[2] + data[3] + 0xd5) & 0xff)) {
 		dbginfo(&ati_remote->interface->dev,
-			"wrong checksum in input: %02x %02x %02x %02x\n",
-			data[0], data[1], data[2], data[3]);
+			"wrong checksum in input: %*ph\n", 4, data);
 		return;
 	}
 
-- 
1.7.10.4

