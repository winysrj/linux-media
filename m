Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:22189 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099Ab3L3Ql6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 11:41:58 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: hdegoede@redhat.com, m.chehab@samsung.com,
	Julia Lawall <julia.lawall@lip6.fr>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 2/2] gspca_kinect: fix messages about kinect_read() return value
Date: Mon, 30 Dec 2013 17:41:46 +0100
Message-Id: <1388421706-8366-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <20131230165625.814796d9e041d2261e1d078a@studenti.unina.it>
References: <20131230165625.814796d9e041d2261e1d078a@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Messages relative to kinect_read() are printing "res" which contains the
return value of a previous kinect_write().

Print the correct value in the messages.

Cc: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/usb/gspca/kinect.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/kinect.c b/drivers/media/usb/gspca/kinect.c
index 48084736..081f051 100644
--- a/drivers/media/usb/gspca/kinect.c
+++ b/drivers/media/usb/gspca/kinect.c
@@ -155,9 +155,10 @@ static int send_cmd(struct gspca_dev *gspca_dev, uint16_t cmd, void *cmdbuf,
 	do {
 		actual_len = kinect_read(udev, ibuf, 0x200);
 	} while (actual_len == 0);
-	PDEBUG(D_USBO, "Control reply: %d", res);
+	PDEBUG(D_USBO, "Control reply: %d", actual_len);
 	if (actual_len < sizeof(*rhdr)) {
-		pr_err("send_cmd: Input control transfer failed (%d)\n", res);
+		pr_err("send_cmd: Input control transfer failed (%d)\n",
+		       actual_len);
 		return actual_len < 0 ? actual_len : -EREMOTEIO;
 	}
 	actual_len -= sizeof(*rhdr);
-- 
1.8.5.2

