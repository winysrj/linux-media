Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:51506 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941144AbcJXU7i (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 16:59:38 -0400
Subject: [PATCH 1/3] [media] au0828-video: Use kcalloc() in au0828_init_isoc()
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
        <chehabrafael@gmail.com>, Shuah Khan <shuah@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
References: <c6a37822-c0f9-1f1e-6ebe-a1c88c6d9d0a@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <68ad1aaa-c029-04b9-805a-e859f6c2d2d5@users.sourceforge.net>
Date: Mon, 24 Oct 2016 22:59:24 +0200
MIME-Version: 1.0
In-Reply-To: <c6a37822-c0f9-1f1e-6ebe-a1c88c6d9d0a@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Oct 2016 22:08:47 +0200

* Multiplications for the size determination of memory allocations
  indicated that array data structures should be processed.
  Thus use the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of data types by pointer dereferences
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/au0828/au0828-video.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 85dd9a8..85b13c1 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -221,15 +221,18 @@ static int au0828_init_isoc(struct au0828_dev *dev, int max_packets,
 
 	dev->isoc_ctl.isoc_copy = isoc_copy;
 	dev->isoc_ctl.num_bufs = num_bufs;
-
-	dev->isoc_ctl.urb = kzalloc(sizeof(void *)*num_bufs,  GFP_KERNEL);
+	dev->isoc_ctl.urb = kcalloc(num_bufs,
+				    sizeof(*dev->isoc_ctl.urb),
+				    GFP_KERNEL);
 	if (!dev->isoc_ctl.urb) {
 		au0828_isocdbg("cannot alloc memory for usb buffers\n");
 		return -ENOMEM;
 	}
 
-	dev->isoc_ctl.transfer_buffer = kzalloc(sizeof(void *)*num_bufs,
-					      GFP_KERNEL);
+	dev->isoc_ctl.transfer_buffer = kcalloc(num_bufs,
+						sizeof(*dev->isoc_ctl
+						       .transfer_buffer),
+						GFP_KERNEL);
 	if (!dev->isoc_ctl.transfer_buffer) {
 		au0828_isocdbg("cannot allocate memory for usb transfer\n");
 		kfree(dev->isoc_ctl.urb);
-- 
2.10.1

