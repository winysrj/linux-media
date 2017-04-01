Return-path: <linux-media-owner@vger.kernel.org>
Received: from twinsen.zall.org ([109.74.194.249]:57560 "EHLO twinsen.zall.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751661AbdDARjN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Apr 2017 13:39:13 -0400
Date: Sat, 1 Apr 2017 17:33:42 +0000
From: Alyssa Milburn <amilburn@zall.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 1/4] digitv: limit messages to buffer size
Message-ID: <c4e1d89600126ce7ea244b132ec50dddf5ad41d9.1491066251.git.amilburn@zall.org>
References: <cover.1491066251.git.amilburn@zall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <cover.1491066251.git.amilburn@zall.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return an error rather than memcpy()ing beyond the end of the buffer.
Internal callers use appropriate sizes, but digitv_i2c_xfer may not.

Signed-off-by: Alyssa Milburn <amilburn@zall.org>
---
 drivers/media/usb/dvb-usb/digitv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/digitv.c b/drivers/media/usb/dvb-usb/digitv.c
index 4284f6984dc1..475a3c0cdee7 100644
--- a/drivers/media/usb/dvb-usb/digitv.c
+++ b/drivers/media/usb/dvb-usb/digitv.c
@@ -33,6 +33,9 @@ static int digitv_ctrl_msg(struct dvb_usb_device *d,
 
 	wo = (rbuf == NULL || rlen == 0); /* write-only */
 
+	if (wlen > 4 || rlen > 4)
+		return -EIO;
+
 	memset(st->sndbuf, 0, 7);
 	memset(st->rcvbuf, 0, 7);
 
-- 
2.11.0
