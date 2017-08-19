Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35707 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751858AbdHSTVI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 15:21:08 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: hans.verkuil@cisco.com, mchehab@kernel.org, matrandg@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 5/6] [media] tc358743: constify i2c_device_id
Date: Sun, 20 Aug 2017 00:50:46 +0530
Message-Id: <1503170447-18533-6-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1503170447-18533-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503170447-18533-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c_device_id are not supposed to change at runtime. All functions
working with i2c_device_id provided by <linux/i2c.h> work with
const i2c_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/i2c/tc358743.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 5788af2..e6f5c36 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -2013,7 +2013,7 @@ static int tc358743_remove(struct i2c_client *client)
 	return 0;
 }
 
-static struct i2c_device_id tc358743_id[] = {
+static const struct i2c_device_id tc358743_id[] = {
 	{"tc358743", 0},
 	{}
 };
-- 
2.7.4
