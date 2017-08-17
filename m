Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33704 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753136AbdHQL4g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 07:56:36 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] [media] usb: rainshadow-cec: constify serio_device_id
Date: Thu, 17 Aug 2017 17:26:24 +0530
Message-Id: <d5f108ac6d73151cf75ab37deb537c4f244748b7.1502970772.git.arvind.yadav.cs@gmail.com>
In-Reply-To: <e7621768ad407ec297b173e3a768a29f9136a780.1502970772.git.arvind.yadav.cs@gmail.com>
References: <e7621768ad407ec297b173e3a768a29f9136a780.1502970772.git.arvind.yadav.cs@gmail.com>
In-Reply-To: <e7621768ad407ec297b173e3a768a29f9136a780.1502970772.git.arvind.yadav.cs@gmail.com>
References: <e7621768ad407ec297b173e3a768a29f9136a780.1502970772.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

serio_device_id are not supposed to change at runtime. All functions
working with serio_device_id provided by <linux/serio.h> work with
const serio_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
index f203699..b82e37c 100644
--- a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
+++ b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
@@ -361,7 +361,7 @@ static int rain_connect(struct serio *serio, struct serio_driver *drv)
 	return err;
 }
 
-static struct serio_device_id rain_serio_ids[] = {
+static const struct serio_device_id rain_serio_ids[] = {
 	{
 		.type	= SERIO_RS232,
 		.proto	= SERIO_RAINSHADOW_CEC,
-- 
2.7.4
