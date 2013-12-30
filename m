Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:48686 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010Ab3L3Ql6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 11:41:58 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: hdegoede@redhat.com, m.chehab@samsung.com,
	Julia Lawall <julia.lawall@lip6.fr>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 1/2] gspca_kinect: fix kinect_read() error path
Date: Mon, 30 Dec 2013 17:41:45 +0100
Message-Id: <1388421706-8366-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <20131230165625.814796d9e041d2261e1d078a@studenti.unina.it>
References: <20131230165625.814796d9e041d2261e1d078a@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The error checking code relative to the invocations of kinect_read()
does not return the actual return code of the function just called, it
returns "res" which still contains the value of the last invocation of
a previous kinect_write().

Return the proper value, and while at it also report with -EREMOTEIO the
case of a partial transfer.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/usb/gspca/kinect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/kinect.c b/drivers/media/usb/gspca/kinect.c
index 3773a8a..48084736 100644
--- a/drivers/media/usb/gspca/kinect.c
+++ b/drivers/media/usb/gspca/kinect.c
@@ -158,7 +158,7 @@ static int send_cmd(struct gspca_dev *gspca_dev, uint16_t cmd, void *cmdbuf,
 	PDEBUG(D_USBO, "Control reply: %d", res);
 	if (actual_len < sizeof(*rhdr)) {
 		pr_err("send_cmd: Input control transfer failed (%d)\n", res);
-		return res;
+		return actual_len < 0 ? actual_len : -EREMOTEIO;
 	}
 	actual_len -= sizeof(*rhdr);
 
-- 
1.8.5.2

