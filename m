Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48619 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754319AbcJNRrF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 07/25] [media] dvb-core: don't break long lines
Date: Fri, 14 Oct 2016 14:45:45 -0300
Message-Id: <d2c088d970c8c2fbe3c3ae6ccec3217adf7a05b3.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_demux.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index a0cf7b0d03e8..280716f1cc46 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -426,8 +426,7 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 	}
 
 	if (buf[1] & 0x80) {
-		dprintk_tscheck("TEI detected. "
-				"PID=0x%x data1=0x%x\n",
+		dprintk_tscheck("TEI detected. PID=0x%x data1=0x%x\n",
 				pid, buf[1]);
 		/* data in this packet can't be trusted - drop it unless
 		 * module option dvb_demux_feed_err_pkts is set */
-- 
2.7.4


