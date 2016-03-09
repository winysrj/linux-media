Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:1602 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140AbcCIQDe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 11:03:34 -0500
From: Antonio Ospite <ao2@ao2.it>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Antonio Ospite <ao2@ao2.it>
Subject: [PATCH 7/7] [media] gspca: fix a v4l2-compliance failure during read()
Date: Wed,  9 Mar 2016 17:03:21 +0100
Message-Id: <1457539401-11515-8-git-send-email-ao2@ao2.it>
In-Reply-To: <1457539401-11515-1-git-send-email-ao2@ao2.it>
References: <1457539401-11515-1-git-send-email-ao2@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-compliance fails with this message:

  fail: v4l2-test-buffers.cpp(512): Expected EBUSY, got 22
  test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL

Looking at the v4l2-compliance code reveals that this failure is about
the read() callback.

In gspca, dev_read() is calling vidioc_dqbuf() which calls
frame_ready_nolock() but the latter returns -EINVAL in a case when
v4l2-compliance expects -EBUSY.

Fix the failure by changing the return value in frame_ready_nolock().

Signed-off-by: Antonio Ospite <ao2@ao2.it>
---
 drivers/media/usb/gspca/gspca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 915b6c7..de7e300 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1664,7 +1664,7 @@ static int frame_ready_nolock(struct gspca_dev *gspca_dev, struct file *file,
 		return -ENODEV;
 	if (gspca_dev->capt_file != file || gspca_dev->memory != memory ||
 			!gspca_dev->streaming)
-		return -EINVAL;
+		return -EBUSY;
 
 	/* check if a frame is ready */
 	return gspca_dev->fr_o != atomic_read(&gspca_dev->fr_i);
-- 
2.7.0

