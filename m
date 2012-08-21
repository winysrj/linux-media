Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48223 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab2HUX4y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 19:56:54 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/5] rtl28xxu: stream did not start after stop on USB3.0
Date: Wed, 22 Aug 2012 02:56:18 +0300
Message-Id: <1345593382-11367-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stream did not start anymore after stream was stopped once.

Following error can be seen, xhci_hcd
WARN Set TR Deq Ptr cmd failed due to incorrect slot or ep state.

usb_clear_halt for streaming endpoint helps.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index d2b1505..1ccb99b 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -834,6 +834,7 @@ static int rtl28xxu_streaming_ctrl(struct dvb_frontend *fe , int onoff)
 	if (onoff) {
 		buf[0] = 0x00;
 		buf[1] = 0x00;
+		usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x81));
 	} else {
 		buf[0] = 0x10; /* stall EPA */
 		buf[1] = 0x02; /* reset EPA */
-- 
1.7.11.4

