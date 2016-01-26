Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:55898 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965442AbcAZQSV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 11:18:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [SUBMITTED] [media] pwc: hide unused label
Date: Tue, 26 Jan 2016 17:17:24 +0100
Message-Id: <1453825059-3339577-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pwc driver causes a warning when CONFIG_USB_PWC_INPUT_EVDEV is unset:

drivers/media/usb/pwc/pwc-if.c: In function 'usb_pwc_probe':
drivers/media/usb/pwc/pwc-if.c:1115:1: warning: label 'err_video_unreg' defined but not used [-Wunused-label]

This moves the unused label and code inside another #ifdef to
get rid of the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/pwc/pwc-if.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 086cf1c7bd7d..432554d07e6e 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -1112,8 +1112,10 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 
 	return 0;
 
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
 err_video_unreg:
 	video_unregister_device(&pdev->vdev);
+#endif
 err_unregister_v4l2_dev:
 	v4l2_device_unregister(&pdev->v4l2_dev);
 err_free_controls:
-- 
2.7.0

