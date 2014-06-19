Return-path: <linux-media-owner@vger.kernel.org>
Received: from serv03.imset.org ([176.31.106.97]:43515 "EHLO serv03.imset.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757619AbaFSIZx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 04:25:53 -0400
Message-ID: <53A29E8F.7050608@dest-unreach.be>
Date: Thu, 19 Jun 2014 10:25:51 +0200
From: Niels Laukens <niels@dest-unreach.be>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
CC: James Hogan <james.hogan@imgtec.com>,
	=?ISO-8859-1?Q?David_H=E4rdem?= =?ISO-8859-1?Q?an?=
	<david@hardeman.nu>,
	=?ISO-8859-1?Q?Antti_Sepp=E4l?= =?ISO-8859-1?Q?=E4?=
	<a.seppala@gmail.com>
Subject: [PATCH 2/2] drivers/media/rc/ir-nec-decode : add toggle feature (2/2)
References: <53A29E5A.9030304@dest-unreach.be>
In-Reply-To: <53A29E5A.9030304@dest-unreach.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From a8fca4a8c37cb35ea4527a708a6894745f81c661 Mon Sep 17 00:00:00 2001
From: Niels Laukens <niels.laukens@vrt.be>
Date: Thu, 19 Jun 2014 10:06:00 +0200
Subject: [PATCH 2/2] drivers/media/rc/ir-nec-decode : add toggle feature (2/2)

Fixes indentation. Kept as separate patch to keep patch 1/2 more to the point.

Signed-off-by: Niels Laukens <niels@dest-unreach.be>
---
 drivers/media/rc/ir-nec-decoder.c | 61 ++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 1f2482a..ff8b5d7 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -161,38 +161,41 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			break;
 
 		if (!data->nec_repeat) {
-		address     = bitrev8((data->bits >> 24) & 0xff);
-		not_address = bitrev8((data->bits >> 16) & 0xff);
-		command	    = bitrev8((data->bits >>  8) & 0xff);
-		not_command = bitrev8((data->bits >>  0) & 0xff);
-
-		if ((command ^ not_command) != 0xff) {
-			IR_dprintk(1, "NEC checksum error: received 0x%08x\n",
-				   data->bits);
-			send_32bits = true;
-		}
+			address     = bitrev8((data->bits >> 24) & 0xff);
+			not_address = bitrev8((data->bits >> 16) & 0xff);
+			command	    = bitrev8((data->bits >>  8) & 0xff);
+			not_command = bitrev8((data->bits >>  0) & 0xff);
+
+			if ((command ^ not_command) != 0xff) {
+				IR_dprintk(1, "NEC checksum error: received 0x%08x\n",
+					   data->bits);
+				send_32bits = true;
+			}
 
-		if (send_32bits) {
-			/* NEC transport, but modified protocol, used by at
-			 * least Apple and TiVo remotes */
-			scancode = data->bits;
-			IR_dprintk(1, "NEC (modified) scancode 0x%08x\n", scancode);
-		} else if ((address ^ not_address) != 0xff) {
-			/* Extended NEC */
-			scancode = address     << 16 |
-				   not_address <<  8 |
-				   command;
-			IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
-		} else {
-			/* Normal NEC */
-			scancode = address << 8 | command;
-			IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
-		}
+			if (send_32bits) {
+				/* NEC transport, but modified protocol, used
+				 * by at least Apple and TiVo remotes */
+				scancode = data->bits;
+				IR_dprintk(1, "NEC (modified) scancode 0x%08x\n",
+					   scancode);
+			} else if ((address ^ not_address) != 0xff) {
+				/* Extended NEC */
+				scancode = address     << 16 |
+					   not_address <<  8 |
+					   command;
+				IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n",
+					   scancode);
+			} else {
+				/* Normal NEC */
+				scancode = address << 8 | command;
+				IR_dprintk(1, "NEC scancode 0x%04x\n",
+					   scancode);
+			}
 
-		if (data->is_nec_x)
-			data->necx_repeat = true;
+			if (data->is_nec_x)
+				data->necx_repeat = true;
 
-		rc_keydown(dev, scancode, !dev->last_toggle);
+			rc_keydown(dev, scancode, !dev->last_toggle);
 		}
 
 		data->state = STATE_INACTIVE;
-- 1.8.5.2 (Apple Git-48) 

