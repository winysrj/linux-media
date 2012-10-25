Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53802 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759901Ab2JYOgo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 10:36:44 -0400
Received: from localhost.localdomain (earthlight.etchedpixels.co.uk [81.2.110.250])
	by lxorguk.ukuu.org.uk (8.14.5/8.14.1) with ESMTP id q9PF8hDH006894
	for <linux-media@vger.kernel.org>; Thu, 25 Oct 2012 16:08:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] pvr2: fix minor storage
To: linux-media@vger.kernel.org
Date: Thu, 25 Oct 2012 15:38:21 +0100
Message-ID: <20121025143816.17307.17929.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

This should have break statements in it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/media/usb/pvrusb2/pvrusb2-hdw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index fb828ba..299751a 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -3563,9 +3563,9 @@ void pvr2_hdw_v4l_store_minor_number(struct pvr2_hdw *hdw,
 				     enum pvr2_v4l_type index,int v)
 {
 	switch (index) {
-	case pvr2_v4l_type_video: hdw->v4l_minor_number_video = v;
-	case pvr2_v4l_type_vbi: hdw->v4l_minor_number_vbi = v;
-	case pvr2_v4l_type_radio: hdw->v4l_minor_number_radio = v;
+	case pvr2_v4l_type_video: hdw->v4l_minor_number_video = v;break;
+	case pvr2_v4l_type_vbi: hdw->v4l_minor_number_vbi = v;break;
+	case pvr2_v4l_type_radio: hdw->v4l_minor_number_radio = v;break;
 	default: break;
 	}
 }

