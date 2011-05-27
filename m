Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab1E0P5S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 11:57:18 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
	Hans Petter Selasky <hselasky@c2i.net>
Subject: [PATCH] [media] mceusb: plug memory leak on data transmit
Date: Fri, 27 May 2011 11:57:09 -0400
Message-Id: <1306511829-493-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans Petter Selasky pointed out to me that we're leaking urbs when
mce_async_out is called. Its used both for configuring the hardware and
for transmitting IR data. In the tx case, mce_request_packet actually
allocates both a urb and the transfer buffer, neither of which was being
torn down. Do that in the tx callback.

CC: Hans Petter Selasky <hselasky@c2i.net>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index ad927fc..124f5af 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -612,6 +612,9 @@ static void mce_async_callback(struct urb *urb, struct pt_regs *regs)
 		mceusb_dev_printdata(ir, urb->transfer_buffer, 0, len, true);
 	}
 
+	/* the transfer buffer and urb were allocated in mce_request_packet */
+	kfree(urb->transfer_buffer);
+	usb_free_urb(urb);
 }
 
 /* request incoming or send outgoing usb packet - used to initialize remote */
-- 
1.7.1

