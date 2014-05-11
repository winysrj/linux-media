Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:51492 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757829AbaEKLMK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 07:12:10 -0400
Date: 11 May 2014 07:12:09 -0400
Message-ID: <20140511111209.14512.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: james.hogan@imgtec.com, linux-media@vger.kernel.org,
	linux@horizon.com, m.chehab@samsung.com
Subject: [PATCH 01/10] ati_remote: Check the checksum
In-Reply-To: <20140511111113.14427.qmail@ns.horizon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An input report is 4 bytes long, but there are only 12 bits
of actual payload.  The 4 bytes are:
data[0] = 0x14
data[1] = data[2] + data[3] + 0xd5 (a checksum byte)
data[2] = the raw scancode (plus toggle bit in msbit)
data[3] = channel << 4 (the low 4 bits must be zero)

Ignore reports with a bad checksum.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 drivers/media/rc/ati_remote.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 2df7c55160..3ddd66a23d 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -507,8 +507,9 @@ static void ati_remote_input_report(struct urb *urb)
 	 */
 
 	/* Deal with strange looking inputs */
-	if ( (urb->actual_length != 4) || (data[0] != 0x14) ||
-		((data[3] & 0x0f) != 0x00) ) {
+	if ( urb->actual_length != 4 || data[0] != 0x14 ||
+	     data[1] != (unsigned char)(data[2] + data[3] + 0xD5) ||
+	     (data[3] & 0x0f) != 0x00) {
 		ati_remote_dump(&urb->dev->dev, data, urb->actual_length);
 		return;
 	}
@@ -524,9 +525,9 @@ static void ati_remote_input_report(struct urb *urb)
 	remote_num = (data[3] >> 4) & 0x0f;
 	if (channel_mask & (1 << (remote_num + 1))) {
 		dbginfo(&ati_remote->interface->dev,
-			"Masked input from channel 0x%02x: data %02x,%02x, "
+			"Masked input from channel 0x%02x: data %02x, "
 			"mask= 0x%02lx\n",
-			remote_num, data[1], data[2], channel_mask);
+			remote_num, data[2], channel_mask);
 		return;
 	}
 
-- 
1.9.2

