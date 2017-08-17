Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38099 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752583AbdHQL4f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 07:56:35 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] [media] usb: pulse8-cec: constify serio_device_id
Date: Thu, 17 Aug 2017 17:26:23 +0530
Message-Id: <e7621768ad407ec297b173e3a768a29f9136a780.1502970772.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

serio_device_id are not supposed to change at runtime. All functions
working with serio_device_id provided by <linux/serio.h> work with
const serio_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/usb/pulse8-cec/pulse8-cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
index c843070..d10d803 100644
--- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
+++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
@@ -732,7 +732,7 @@ static void pulse8_ping_eeprom_work_handler(struct work_struct *work)
 	mutex_unlock(&pulse8->config_lock);
 }
 
-static struct serio_device_id pulse8_serio_ids[] = {
+static const struct serio_device_id pulse8_serio_ids[] = {
 	{
 		.type	= SERIO_RS232,
 		.proto	= SERIO_PULSE8_CEC,
-- 
2.7.4
