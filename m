Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450AbcB0Kv3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 05:51:29 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/7] [media] airspy: fix bit set/clean mess on s->flags
Date: Sat, 27 Feb 2016 07:51:07 -0300
Message-Id: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/usb/airspy/airspy.c:541 airspy_start_streaming() warn: test_bit() takes a bit number
	drivers/media/usb/airspy/airspy.c:569 airspy_start_streaming() warn: test_bit() takes a bit number
	drivers/media/usb/airspy/airspy.c:605 airspy_stop_streaming() warn: test_bit() takes a bit number

set_bit/clear_bit argument is the bit number, and not 1 << bit.

Thankfully, one of the bits was not used (URB_BUF), with would
otherwise cause a driver misfunctioning.

Clean this mess by always using set_bit/clear_bit/test_bit and
removing the unused bit.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/airspy/airspy.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 0d4ac5947f3a..87c12930416f 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -104,9 +104,8 @@ struct airspy_frame_buf {
 };
 
 struct airspy {
-#define POWER_ON           (1 << 1)
-#define URB_BUF            (1 << 2)
-#define USB_STATE_URB_BUF  (1 << 3)
+#define POWER_ON	   1
+#define USB_STATE_URB_BUF  2
 	unsigned long flags;
 
 	struct device *dev;
@@ -359,7 +358,7 @@ static int airspy_submit_urbs(struct airspy *s)
 
 static int airspy_free_stream_bufs(struct airspy *s)
 {
-	if (s->flags & USB_STATE_URB_BUF) {
+	if (test_bit(USB_STATE_URB_BUF, &s->flags)) {
 		while (s->buf_num) {
 			s->buf_num--;
 			dev_dbg(s->dev, "free buf=%d\n", s->buf_num);
@@ -368,7 +367,7 @@ static int airspy_free_stream_bufs(struct airspy *s)
 					  s->dma_addr[s->buf_num]);
 		}
 	}
-	s->flags &= ~USB_STATE_URB_BUF;
+	clear_bit(USB_STATE_URB_BUF, &s->flags);
 
 	return 0;
 }
@@ -394,7 +393,7 @@ static int airspy_alloc_stream_bufs(struct airspy *s)
 		dev_dbg(s->dev, "alloc buf=%d %p (dma %llu)\n", s->buf_num,
 				s->buf_list[s->buf_num],
 				(long long)s->dma_addr[s->buf_num]);
-		s->flags |= USB_STATE_URB_BUF;
+		set_bit(USB_STATE_URB_BUF, &s->flags);
 	}
 
 	return 0;
-- 
2.5.0

