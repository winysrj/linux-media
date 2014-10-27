Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0252.hostedemail.com ([216.40.44.252]:44391 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752778AbaJ0FZ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 01:25:27 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 04/11] dvb-net: Fix probable mask then right shift defects
Date: Sun, 26 Oct 2014 22:25:00 -0700
Message-Id: <dd93cdd7254bc6405709e1e53b07e8555647a372.1414387334.git.joe@perches.com>
In-Reply-To: <cover.1414387334.git.joe@perches.com>
References: <cover.1414387334.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Precedence of & and >> is not the same and is not left to right.
shift has higher precedence and should be done after the mask.

Add parentheses around the mask.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb-core/dvb_net.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index 059e611..441814b 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -379,7 +379,9 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 			/* Check TS error conditions: sync_byte, transport_error_indicator, scrambling_control . */
 			if ((ts[0] != TS_SYNC) || (ts[1] & TS_TEI) || ((ts[3] & TS_SC) != 0)) {
 				printk(KERN_WARNING "%lu: Invalid TS cell: SYNC %#x, TEI %u, SC %#x.\n",
-				       priv->ts_count, ts[0], ts[1] & TS_TEI >> 7, ts[3] & 0xC0 >> 6);
+				       priv->ts_count, ts[0],
+				       (ts[1] & TS_TEI) >> 7,
+				       (ts[3] & 0xC0) >> 6);
 
 				/* Drop partly decoded SNDU, reset state, resync on PUSI. */
 				if (priv->ule_skb) {
-- 
2.1.2

