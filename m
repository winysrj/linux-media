Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:49211 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755964AbbA1UfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 15:35:00 -0500
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/3] dvb_net: Use vsprintf %pM extension to print Ethernet addresses
Date: Wed, 28 Jan 2015 10:05:50 -0800
Message-Id: <5e0ccf5c0cf308317c79f5497d7eb63adca72e44.1422468185.git.joe@perches.com>
In-Reply-To: <cover.1422468185.git.joe@perches.com>
References: <cover.1422468185.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No need for more macros, so remove them and use the kernel extension.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb-core/dvb_net.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index e4041f0..ff79b0b 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -90,9 +90,6 @@ static inline __u32 iov_crc32( __u32 c, struct kvec *iov, unsigned int cnt )
 
 #ifdef ULE_DEBUG
 
-#define MAC_ADDR_PRINTFMT "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x"
-#define MAX_ADDR_PRINTFMT_ARGS(macap) (macap)[0],(macap)[1],(macap)[2],(macap)[3],(macap)[4],(macap)[5]
-
 #define isprint(c)	((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9'))
 
 static void hexdump( const unsigned char *buf, unsigned short len )
@@ -700,8 +697,8 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 
 					if (drop) {
 #ifdef ULE_DEBUG
-						dprintk("Dropping SNDU: MAC destination address does not match: dest addr: "MAC_ADDR_PRINTFMT", dev addr: "MAC_ADDR_PRINTFMT"\n",
-							MAX_ADDR_PRINTFMT_ARGS(priv->ule_skb->data), MAX_ADDR_PRINTFMT_ARGS(dev->dev_addr));
+						dprintk("Dropping SNDU: MAC destination address does not match: dest addr: %pM, dev addr: %pM\n",
+							priv->ule_skb->data, dev->dev_addr);
 #endif
 						dev_kfree_skb(priv->ule_skb);
 						goto sndu_done;
-- 
2.1.2

