Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:34684 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbJSQl4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2015 12:41:56 -0400
From: Insu Yun <wuninsu@gmail.com>
To: hdegoede@redhat.com, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] gspca: correctly checked failed allocation
Date: Mon, 19 Oct 2015 16:43:14 +0000
Message-Id: <1445272994-25312-1-git-send-email-wuninsu@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

create_singlethread_workqueue can be failed in memory pressue.
So, check return value and return -ENOMEM

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/media/usb/gspca/sq905.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/gspca/sq905.c b/drivers/media/usb/gspca/sq905.c
index a7ae0ec..b1c25d9a 100644
--- a/drivers/media/usb/gspca/sq905.c
+++ b/drivers/media/usb/gspca/sq905.c
@@ -392,6 +392,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	}
 	/* Start the workqueue function to do the streaming */
 	dev->work_thread = create_singlethread_workqueue(MODULE_NAME);
+	if (!dev->work_thread)
+		return -ENOMEM;
 	queue_work(dev->work_thread, &dev->work_struct);
 
 	return 0;
-- 
1.9.1

