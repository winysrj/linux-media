Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:35505 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbZHSTk7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 15:40:59 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [patch]remove unnecessary power management primitive in stk-webcam
Date: Wed, 19 Aug 2009 21:41:59 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908192141.59722.oliver@neukum.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes an unneeded power management primitive.
Power management is automatically enabled as probe ends.

Signed-off-by: Oliver Neukum <oliver@neukum.org>

Hi,

please accept this patch for the next merge window, as this
patch changes no functionality and removes a primitive that
won't be supported in the new generic framework.

	Regards
		Oliver

--

commit eeada72856087eb90e8649692b75e5b875ba051d
Author: Oliver Neukum <oliver@neukum.org>
Date:   Wed Aug 19 20:31:56 2009 +0200

    usb: remove unneeded power management primitive

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index b154bd9..0b996ea 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -1400,7 +1400,6 @@ static int stk_camera_probe(struct usb_interface *interface,
 	}
 
 	stk_create_sysfs_files(&dev->vdev);
-	usb_autopm_enable(dev->interface);
 
 	return 0;
 

