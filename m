Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49986 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3ILXFO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 19:05:14 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/3] [media] siano: Use the default firmware for Stellar
Date: Thu, 12 Sep 2013 17:04:07 -0300
Message-Id: <1379016247-19744-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1379016000-19577-1-git-send-email-m.chehab@samsung.com>
References: <1379016000-19577-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Stellar firmware load routine is different. Improve it to use
the default firmware, if no modprobe parameter tells otherwise.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/siano/smsusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 33f3575..05bd91a 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -245,6 +245,9 @@ static int smsusb1_load_firmware(struct usb_device *udev, int id, int board_id)
 	int rc, dummy;
 	char *fw_filename;
 
+	if (id < 0)
+		id = sms_get_board(board_id)->default_mode;
+
 	if (id < DEVICE_MODE_DVBT || id > DEVICE_MODE_DVBT_BDA) {
 		sms_err("invalid firmware id specified %d", id);
 		return -EINVAL;
-- 
1.8.3.1

