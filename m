Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:7421 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbaF1K67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Jun 2014 06:58:59 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/1] drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c: remove unnecessary null test before usb_free_urb
Date: Sat, 28 Jun 2014 12:57:39 +0200
Message-Id: <1403953059-32444-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix checkpatch warning:
WARNING: usb_free_urb(NULL) is safe this check is probably not required

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index f8a60c1..f166ffc 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -791,8 +791,7 @@ static void ttusb_free_iso_urbs(struct ttusb *ttusb)
 	int i;
 
 	for (i = 0; i < ISO_BUF_COUNT; i++)
-		if (ttusb->iso_urb[i])
-			usb_free_urb(ttusb->iso_urb[i]);
+		usb_free_urb(ttusb->iso_urb[i]);
 
 	pci_free_consistent(NULL,
 			    ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF *
-- 
1.8.4.5

