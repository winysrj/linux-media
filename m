Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:1578 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933156AbcCIQDd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 11:03:33 -0500
From: Antonio Ospite <ao2@ao2.it>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Antonio Ospite <ao2@ao2.it>
Subject: [PATCH 2/7] [media] gspca: fix setting frame interval type in vidioc_enum_frameintervals()
Date: Wed,  9 Mar 2016 17:03:16 +0100
Message-Id: <1457539401-11515-3-git-send-email-ao2@ao2.it>
In-Reply-To: <1457539401-11515-1-git-send-email-ao2@ao2.it>
References: <1457539401-11515-1-git-send-email-ao2@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the frame _interval_ type to V4L2_FRMIVAL_TYPE_DISCRETE instead of
using V4L2_FRMSIZE_TYPE_DISCRETE which is meant for frame _size_.

The old and new values happen to be the same so there is no functional
change.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
---
 drivers/media/usb/gspca/gspca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index af5cd82..9c8990f 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1246,7 +1246,7 @@ static int vidioc_enum_frameintervals(struct file *filp, void *priv,
 
 	for (i = 0; i < gspca_dev->cam.mode_framerates[mode].nrates; i++) {
 		if (fival->index == i) {
-			fival->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+			fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
 			fival->discrete.numerator = 1;
 			fival->discrete.denominator =
 				gspca_dev->cam.mode_framerates[mode].rates[i];
-- 
2.7.0

