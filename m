Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:36318 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066AbaLPXR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 18:17:26 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: au0828 VBI support comment cleanup
Date: Tue, 16 Dec 2014 16:17:20 -0700
Message-Id: <1418771840-8825-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver supports VBI and the comment "VBI support
is not yet working" is inaccurate. Remove it.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 5f337b1..8a7a547 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -22,7 +22,6 @@
 
 /* Developer Notes:
  *
- * VBI support is not yet working
  * The hardware scaler supported is unimplemented
  * AC97 audio support is unimplemented (only i2s audio mode)
  *
-- 
2.1.0

