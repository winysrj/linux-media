Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1666 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab3JDOCE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:02:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/14] hdpvr: fix sparse warnings
Date: Fri,  4 Oct 2013 16:01:39 +0200
Message-Id: <1380895312-30863-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/hdpvr/hdpvr-core.c:110:54: warning: incorrect type in argument 1 (different base types)
drivers/media/usb/hdpvr/hdpvr-core.c:112:39: warning: invalid assignment: +=
drivers/media/usb/hdpvr/hdpvr-core.c:304:26: warning: Using plain integer as NULL pointer

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 6e50707..2f0c89c 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -78,7 +78,8 @@ void hdpvr_delete(struct hdpvr_device *dev)
 
 static void challenge(u8 *bytes)
 {
-	u64 *i64P, tmp64;
+	__le64 *i64P;
+	u64 tmp64;
 	uint i, idx;
 
 	for (idx = 0; idx < 32; ++idx) {
@@ -106,10 +107,10 @@ static void challenge(u8 *bytes)
 			for (i = 0; i < 3; i++)
 				bytes[1] *= bytes[6] + 1;
 			for (i = 0; i < 3; i++) {
-				i64P = (u64 *)bytes;
+				i64P = (__le64 *)bytes;
 				tmp64 = le64_to_cpup(i64P);
-				tmp64 <<= bytes[7] & 0x0f;
-				*i64P += cpu_to_le64(tmp64);
+				tmp64 = tmp64 + (tmp64 << (bytes[7] & 0x0f));
+				*i64P = cpu_to_le64(tmp64);
 			}
 			break;
 		}
@@ -301,8 +302,6 @@ static int hdpvr_probe(struct usb_interface *interface,
 		goto error;
 	}
 
-	dev->workqueue = 0;
-
 	/* init video transfer queues first of all */
 	/* to prevent oops in hdpvr_delete() on error paths */
 	INIT_LIST_HEAD(&dev->free_buff_list);
-- 
1.8.3.2

