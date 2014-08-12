Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49244 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbaHLVuf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 17:50:35 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 03/10] [media] as102: CodingStyle fixes
Date: Tue, 12 Aug 2014 18:50:17 -0300
Message-Id: <1407880224-374-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
References: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this warning:

WARNING: quoted string split across lines
566: FILE: drivers/media/usb/as102/as102_fe.c:141:
+				"demod status: fc: 0x%08x, bad fc: 0x%08x, "
+				"bytes corrected: 0x%08x , MER: 0x%04x\n",

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/as102/as102_fe.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/as102/as102_fe.c b/drivers/media/usb/as102/as102_fe.c
index 29a6d38f91a9..9596756b3869 100644
--- a/drivers/media/usb/as102/as102_fe.c
+++ b/drivers/media/usb/as102/as102_fe.c
@@ -137,8 +137,7 @@ static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
 				"as10x_cmd_get_demod_stats failed (probably not tuned)\n");
 		} else {
 			dev_dbg(&dev->bus_adap.usb_dev->dev,
-				"demod status: fc: 0x%08x, bad fc: 0x%08x, "
-				"bytes corrected: 0x%08x , MER: 0x%04x\n",
+				"demod status: fc: 0x%08x, bad fc: 0x%08x, bytes corrected: 0x%08x , MER: 0x%04x\n",
 				dev->demod_stats.frame_count,
 				dev->demod_stats.bad_frame_count,
 				dev->demod_stats.bytes_fixed_by_rs,
-- 
1.9.3

