Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34689 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752361AbdHSTVL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 15:21:11 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: hans.verkuil@cisco.com, mchehab@kernel.org, matrandg@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 6/6] [media] ths8200: constify i2c_device_id
Date: Sun, 20 Aug 2017 00:50:47 +0530
Message-Id: <1503170447-18533-7-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1503170447-18533-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503170447-18533-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c_device_id are not supposed to change at runtime. All functions
working with i2c_device_id provided by <linux/i2c.h> work with
const i2c_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/i2c/ths8200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 42340e3..498ad23 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -483,7 +483,7 @@ static int ths8200_remove(struct i2c_client *client)
 	return 0;
 }
 
-static struct i2c_device_id ths8200_id[] = {
+static const struct i2c_device_id ths8200_id[] = {
 	{ "ths8200", 0 },
 	{},
 };
-- 
2.7.4
