Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36480 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751859AbdHSTVB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 15:21:01 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: hans.verkuil@cisco.com, mchehab@kernel.org, matrandg@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 2/6] [media] adv7511: constify i2c_device_id
Date: Sun, 20 Aug 2017 00:50:43 +0530
Message-Id: <1503170447-18533-3-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1503170447-18533-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503170447-18533-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c_device_id are not supposed to change at runtime. All functions
working with i2c_device_id provided by <linux/i2c.h> work with
const i2c_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/i2c/adv7511.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index ccc4786..8fc97a8 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1986,7 +1986,7 @@ static int adv7511_remove(struct i2c_client *client)
 
 /* ----------------------------------------------------------------------- */
 
-static struct i2c_device_id adv7511_id[] = {
+static const struct i2c_device_id adv7511_id[] = {
 	{ "adv7511", 0 },
 	{ }
 };
-- 
2.7.4
