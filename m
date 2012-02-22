Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56315 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2BVWqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 17:46:43 -0500
Received: by ghrr11 with SMTP id r11so351099ghr.19
        for <linux-media@vger.kernel.org>; Wed, 22 Feb 2012 14:46:43 -0800 (PST)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org, gregkh@linuxfoundation.org
Cc: tomas.winkler@intel.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, dan.carpenter@oracle.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH V2 2/2] staging: easycap: Fix incorrect comment
Date: Wed, 22 Feb 2012 19:46:15 -0300
Message-Id: <1329950775-2059-2-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1329950775-2059-1-git-send-email-elezegarcia@gmail.com>
References: <1329950775-2059-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
V2: resend to proper maintainers

 drivers/staging/media/easycap/easycap_main.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/easycap/easycap_main.c b/drivers/staging/media/easycap/easycap_main.c
index 95f3cc1..d0fe34a 100644
--- a/drivers/staging/media/easycap/easycap_main.c
+++ b/drivers/staging/media/easycap/easycap_main.c
@@ -3542,9 +3542,8 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		/*
 		 * It is essential to initialize the hardware before,
 		 * rather than after, the device is registered,
-		 * because some versions of the videodev module
-		 * call easycap_open() immediately after registration,
-		 * causing a clash.
+		 * because some udev rules triggers easycap_open()
+		 * immediately after registration, causing a clash.
 		 */
 		peasycap->ntsc = easycap_ntsc;
 		JOM(8, "defaulting initially to %s\n",
-- 
1.7.3.4

