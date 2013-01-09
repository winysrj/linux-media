Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47691 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3AIHgh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 02:36:37 -0500
Date: Wed, 9 Jan 2013 10:36:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Hunold <michael@mihu.de>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [media] dvb-usb: reading before start of array
Message-ID: <20130109073632.GD2454@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a static checker fix.  In the ttusb_process_muxpack() we do:

	cc = (muxpack[len - 4] << 8) | muxpack[len - 3];

That means if we pass a number less than 4 then we will either trigger a
checksum error message or read before the start of the array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I can't test this.

This patch doesn't introduce any bugs, but I'm not positive this is the
right thing to do.  Perhaps it's better to print an error message?

diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index 5b682cc..99a2fd1 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -709,7 +709,7 @@ static void ttusb_process_frame(struct ttusb *ttusb, u8 * data, int len)
 			 * if length is valid and we reached the end:
 			 * goto next muxpack
 			 */
-				if ((ttusb->muxpack_ptr >= 2) &&
+				if ((ttusb->muxpack_ptr >= 4) &&
 				    (ttusb->muxpack_ptr ==
 				     ttusb->muxpack_len)) {
 					ttusb_process_muxpack(ttusb,
