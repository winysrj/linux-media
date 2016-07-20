Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:52972 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510AbcGTKrp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 06:47:45 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C5E6D180496
	for <linux-media@vger.kernel.org>; Wed, 20 Jul 2016 12:47:35 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] airspy: fix compiler warning
Message-ID: <27ca2b5b-a93e-b17f-ea64-000b41b78be2@xs4all.nl>
Date: Wed, 20 Jul 2016 12:47:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/airspy/airspy.c: In function 'airspy_probe':
drivers/media/usb/airspy/airspy.c:1084:1: warning: label 'err_unregister_v4l2_dev' defined but not used [-Wunused-label]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/airspy/airspy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 19cd64c..fe031b0 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -1081,7 +1081,6 @@ static int airspy_probe(struct usb_interface *intf,

 err_free_controls:
 	v4l2_ctrl_handler_free(&s->hdl);
-err_unregister_v4l2_dev:
 	v4l2_device_unregister(&s->v4l2_dev);
 err_free_mem:
 	kfree(s);
-- 
2.8.1

