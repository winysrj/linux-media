Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:32863 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161491Ab3FUOVw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 10:21:52 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mike Isely <isely@pobox.com>
Subject: [PATCH] [media] pvrusb2: Remove unused variable
Date: Fri, 21 Jun 2013 11:21:41 -0300
Message-Id: <1371824501-20742-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/pvrusb2/pvrusb2-v4l2.c: In function 'pvr2_v4l2_dev_init':
drivers/media/usb/pvrusb2/pvrusb2-v4l2.c:1268:21: warning: variable 'usbdev' set but not used [-Wunused-but-set-variable]

This warning is due to changeset a28fbd04facb, with removed the
usage of usbdev inside pvr2_v4l2_dev_init().

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mike Isely <isely@pobox.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index d77069e..7c280f3 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -1265,7 +1265,6 @@ static void pvr2_v4l2_dev_init(struct pvr2_v4l2_dev *dip,
 			       struct pvr2_v4l2 *vp,
 			       int v4l_type)
 {
-	struct usb_device *usbdev;
 	int mindevnum;
 	int unit_number;
 	struct pvr2_hdw *hdw;
@@ -1273,7 +1272,6 @@ static void pvr2_v4l2_dev_init(struct pvr2_v4l2_dev *dip,
 	dip->v4lp = vp;
 
 	hdw = vp->channel.mc_head->hdw;
-	usbdev = pvr2_hdw_get_dev(hdw);
 	dip->v4l_type = v4l_type;
 	switch (v4l_type) {
 	case VFL_TYPE_GRABBER:
-- 
1.8.1.4

