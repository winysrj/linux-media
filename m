Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34738 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751858AbdHSTU7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 15:20:59 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: hans.verkuil@cisco.com, mchehab@kernel.org, matrandg@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 1/6] [media] ad9389b: constify i2c_device_id
Date: Sun, 20 Aug 2017 00:50:42 +0530
Message-Id: <1503170447-18533-2-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1503170447-18533-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503170447-18533-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c_device_id are not supposed to change at runtime. All functions
working with i2c_device_id provided by <linux/i2c.h> work with
const i2c_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/i2c/ad9389b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 50f3541..a056d6c 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -1208,7 +1208,7 @@ static int ad9389b_remove(struct i2c_client *client)
 
 /* ----------------------------------------------------------------------- */
 
-static struct i2c_device_id ad9389b_id[] = {
+static const struct i2c_device_id ad9389b_id[] = {
 	{ "ad9389b", 0 },
 	{ "ad9889b", 0 },
 	{ }
-- 
2.7.4
