Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28837 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933587AbaJ2PsJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Oct 2014 11:48:09 -0400
Date: Wed, 29 Oct 2014 18:47:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	dingtianhong <dingtianhong@huawei.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Tom Gundersen <teg@jklm.no>,
	David Herrmann <dh.herrmann@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] media: dvb_core: fix an error message
Message-ID: <20141029154741.GB5290@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The right shift has higher precedence than the mask so the warning
doesn't match what the test was checking.  Also it's better to use TS_SC
instead of magic number 0xC0.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index 059e611..360ef2b 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -379,7 +379,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 			/* Check TS error conditions: sync_byte, transport_error_indicator, scrambling_control . */
 			if ((ts[0] != TS_SYNC) || (ts[1] & TS_TEI) || ((ts[3] & TS_SC) != 0)) {
 				printk(KERN_WARNING "%lu: Invalid TS cell: SYNC %#x, TEI %u, SC %#x.\n",
-				       priv->ts_count, ts[0], ts[1] & TS_TEI >> 7, ts[3] & 0xC0 >> 6);
+				       priv->ts_count, ts[0], (ts[1] & TS_TEI) >> 7, (ts[3] & TS_SC) >> 6);
 
 				/* Drop partly decoded SNDU, reset state, resync on PUSI. */
 				if (priv->ule_skb) {
