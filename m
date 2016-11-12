Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:47906 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S937770AbcKLAYF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 19:24:05 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: fix HDMI VSDB block in the EDID
Message-ID: <59e6b947-f03c-c8ab-18b9-57306de06ea4@xs4all.nl>
Date: Sat, 12 Nov 2016 01:23:56 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The maximum 'Max TMDS Rate' in the HDMI VSDB block is 340 MHz, not 600.
Higher rates are advertised in the HDMI Forum VSDB block.

So lower the Max TMDS rate in the HDMI VSDB block that the vivid driver
uses to 300 MHz, which is typical of most HDMI 1.4b devices.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 5464fef..b8ef836 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -183,7 +183,7 @@ static const u8 vivid_hdmi_edid[256] = {
 	0x5e, 0x5d, 0x10, 0x1f, 0x04, 0x13, 0x22, 0x21,
 	0x20, 0x05, 0x14, 0x02, 0x11, 0x01, 0x23, 0x09,
 	0x07, 0x07, 0x83, 0x01, 0x00, 0x00, 0x6d, 0x03,
-	0x0c, 0x00, 0x10, 0x00, 0x00, 0x78, 0x21, 0x00,
+	0x0c, 0x00, 0x10, 0x00, 0x00, 0x3c, 0x21, 0x00,
 	0x60, 0x01, 0x02, 0x03, 0x67, 0xd8, 0x5d, 0xc4,
 	0x01, 0x78, 0x00, 0x00, 0xe2, 0x00, 0xea, 0xe3,
 	0x05, 0x00, 0x00, 0xe3, 0x06, 0x01, 0x00, 0x4d,
@@ -194,7 +194,7 @@ static const u8 vivid_hdmi_edid[256] = {
 	0x00, 0x00, 0x1a, 0x1a, 0x1d, 0x00, 0x80, 0x51,
 	0xd0, 0x1c, 0x20, 0x40, 0x80, 0x35, 0x00, 0xc0,
 	0x1c, 0x32, 0x00, 0x00, 0x1c, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x27,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x63,
 };

 static int vidioc_querycap(struct file *file, void  *priv,
