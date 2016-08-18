Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51369 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753135AbcHRHOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2016 03:14:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.8] cec-edid: check for IEEE identifier
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mailing list - DRI developers <dri-devel@lists.freedesktop.org>
Message-ID: <09104964-b93a-cbdb-8065-13558aa85f74@xs4all.nl>
Date: Thu, 18 Aug 2016 09:13:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cec_get_edid_spa_location() function did not verify that the IEEE
identifier in the Vendor Specific Data Block matched the HDMI-LLC
identifier. This could result in the wrong VSDB block being returned.

For example, for HDMI 2.0 EDIDs there is also a HDMI Forum VSDB.

So check the IEEE identifier as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/cec-edid.c b/drivers/media/cec-edid.c
index 7001824..5719b99 100644
--- a/drivers/media/cec-edid.c
+++ b/drivers/media/cec-edid.c
@@ -70,7 +70,10 @@ static unsigned int cec_get_edid_spa_location(const u8 *edid, unsigned int size)
 				u8 tag = edid[i] >> 5;
 				u8 len = edid[i] & 0x1f;

-				if (tag == 3 && len >= 5 && i + len <= end)
+				if (tag == 3 && len >= 5 && i + len <= end &&
+				    edid[i + 1] == 0x03 &&
+				    edid[i + 2] == 0x0c &&
+				    edid[i + 3] == 0x00)
 					return i + 4;
 				i += len + 1;
 			} while (i < end);


