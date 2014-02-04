Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2283 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaBDJBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 04:01:13 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s149191N007348
	for <linux-media@vger.kernel.org>; Tue, 4 Feb 2014 10:01:12 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 2F2632A00A6
	for <linux-media@vger.kernel.org>; Tue,  4 Feb 2014 10:00:52 +0100 (CET)
Message-ID: <52F0AC44.4020402@xs4all.nl>
Date: Tue, 04 Feb 2014 10:00:52 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] usbtv: fix compiler error due to missing module.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usbtv-video.c needs module.h. So move the module.h include from usbtv-core.c to usbtv.h,
that way both core.c and video.c have it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index e89e48b..d543928 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -28,8 +28,6 @@
  * GNU General Public License ("GPL").
  */
 
-#include <linux/module.h>
-
 #include "usbtv.h"
 
 int usbtv_set_regs(struct usbtv *usbtv, const u16 regs[][2], int size)
diff --git a/drivers/media/usb/usbtv/usbtv.h b/drivers/media/usb/usbtv/usbtv.h
index 536343d..cb1d388 100644
--- a/drivers/media/usb/usbtv/usbtv.h
+++ b/drivers/media/usb/usbtv/usbtv.h
@@ -19,6 +19,7 @@
  * GNU General Public License ("GPL").
  */
 
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
 
