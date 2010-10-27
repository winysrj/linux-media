Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:34814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846Ab0J0Mbg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 08:31:36 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Lee Jones <lee.jones@canonical.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/7] gspca: only set gspca->int_urb if submitting it succeeds
Date: Wed, 27 Oct 2010 14:35:21 +0200
Message-Id: <1288182926-25400-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
References: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Currently alloc_and_submit_int_urb() is setting gspca->int_urb
as soon as the allocation has succeeded, but if the subsequent
submit fails, the urb gets destroyed. And then later will
get destroyed again in gspca_input_destroy_urb() because
gspca->int_urb is set, leading to a double free.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/gspca.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index dbd63c5..a089fca 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -224,12 +224,12 @@ static int alloc_and_submit_int_urb(struct gspca_dev *gspca_dev,
 		buffer, buffer_len,
 		int_irq, (void *)gspca_dev, interval);
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-	gspca_dev->int_urb = urb;
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret < 0) {
 		PDEBUG(D_ERR, "submit int URB failed with error %i", ret);
 		goto error_submit;
 	}
+	gspca_dev->int_urb = urb;
 	return ret;
 
 error_submit:
-- 
1.7.3.1

