Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36923 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752420AbdHTKlS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 06:41:18 -0400
Received: by mail-wr0-f196.google.com with SMTP id z91so13149675wrc.4
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 03:41:17 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 1/6] [media] ddbridge: fix gap handling
Date: Sun, 20 Aug 2017 12:41:09 +0200
Message-Id: <20170820104114.6515-2-d.scheller.oss@gmail.com>
In-Reply-To: <20170820104114.6515-1-d.scheller.oss@gmail.com>
References: <20170820104114.6515-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Force gap setting if given by attribute and enable gap for older regmaps.
Also, setting a gap value of 128 via sysfs will now disable gap.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index c290d3fecc8d..98a12c644e44 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -336,6 +336,7 @@ static void calc_con(struct ddb_output *output, u32 *con, u32 *con2, u32 flags)
 	if (output->port->gap != 0xffffffff) {
 		flags |= 1;
 		gap = output->port->gap;
+		max_bitrate = 0;
 	}
 	if (dev->link[0].info->type == DDB_OCTOPUS_CI && output->port->nr > 1) {
 		*con = 0x10c;
@@ -372,6 +373,7 @@ static void calc_con(struct ddb_output *output, u32 *con, u32 *con2, u32 flags)
 				*con |= 0x810; /* 96 MBit/s and gap */
 				max_bitrate = 96000;
 			}
+			*con |= 0x10; /* enable gap */
 		}
 	}
 	if (max_bitrate > 0) {
@@ -3203,8 +3205,10 @@ static ssize_t gap_store(struct device *device, struct device_attribute *attr,
 
 	if (sscanf(buf, "%u\n", &val) != 1)
 		return -EINVAL;
-	if (val > 20)
+	if (val > 128)
 		return -EINVAL;
+	if (val == 128)
+		val = 0xffffffff;
 	dev->port[num].gap = val;
 	return count;
 }
-- 
2.13.0
