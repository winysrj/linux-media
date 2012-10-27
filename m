Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab2J0UmC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:02 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKg2kl006285
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:02 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 35/68] [media] pwc-if: must check vb2_queue_init() success
Date: Sat, 27 Oct 2012 18:40:53 -0200
Message-Id: <1351370486-29040-36-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/pwc/pwc-if.c: In function 'usb_pwc_probe':
drivers/media/usb/pwc/pwc-if.c:1003:16: warning: ignoring return value of 'vb2_queue_init', declared with attribute warn_unused_result [-Wunused-result]
In the past, it used to have a logic there at queue init that would
BUG() on errors. This logic got removed. Drivers are now required
to explicitly handle the queue initialization errors, or very bad
things may happen.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/pwc/pwc-if.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index e191572..5210239 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -1000,7 +1000,11 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	pdev->vb_queue.buf_struct_size = sizeof(struct pwc_frame_buf);
 	pdev->vb_queue.ops = &pwc_vb_queue_ops;
 	pdev->vb_queue.mem_ops = &vb2_vmalloc_memops;
-	vb2_queue_init(&pdev->vb_queue);
+	rc = vb2_queue_init(&pdev->vb_queue);
+	if (rc < 0) {
+		PWC_ERROR("Oops, could not initialize vb2 queue.\n");
+		goto err_free_mem;
+	}
 
 	/* Init video_device structure */
 	memcpy(&pdev->vdev, &pwc_template, sizeof(pwc_template));
-- 
1.7.11.7

