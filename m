Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:11226 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140AbcCIQDb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 11:03:31 -0500
From: Antonio Ospite <ao2@ao2.it>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Antonio Ospite <ao2@ao2.it>
Subject: [PATCH 5/7] [media] gspca: fix a v4l2-compliance failure about buffer timestamp
Date: Wed,  9 Mar 2016 17:03:19 +0100
Message-Id: <1457539401-11515-6-git-send-email-ao2@ao2.it>
In-Reply-To: <1457539401-11515-1-git-send-email-ao2@ao2.it>
References: <1457539401-11515-1-git-send-email-ao2@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-compliance fails with this message:

  fail: v4l2-test-buffers.cpp(250): \
      timestamp != V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC && \
      timestamp != V4L2_BUF_FLAG_TIMESTAMP_COPY
  ...
  test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL

When setting the frame time, gspca uses v4l2_get_timestamp() which uses
ktime_get_ts() which uses ktime_get_ts64() which returns a monotonic
timestamp, so it's safe to initialize the buffer flags to
V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC to fix the failure.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
---
 drivers/media/usb/gspca/gspca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 61cb16d..84b0d6a 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -522,7 +522,7 @@ static int frame_alloc(struct gspca_dev *gspca_dev, struct file *file,
 		frame = &gspca_dev->frame[i];
 		frame->v4l2_buf.index = i;
 		frame->v4l2_buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		frame->v4l2_buf.flags = 0;
+		frame->v4l2_buf.flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		frame->v4l2_buf.field = V4L2_FIELD_NONE;
 		frame->v4l2_buf.length = frsz;
 		frame->v4l2_buf.memory = memory;
-- 
2.7.0

