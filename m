Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35826 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752174AbdGDUq6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 16:46:58 -0400
Received: by mail-qt0-f195.google.com with SMTP id w12so28346966qta.2
        for <linux-media@vger.kernel.org>; Tue, 04 Jul 2017 13:46:58 -0700 (PDT)
From: "Guillermo O. Freschi" <kedrot@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "Guillermo O. Freschi" <kedrot@gmail.com>
Subject: [PATCH] drivers/staging/media/atomisp/i2c/gc2235: fix sparse warning: missing static
Date: Tue,  4 Jul 2017 17:46:43 -0300
Message-Id: <20170704204643.348-1-kedrot@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several local use structs were missing declarations. Added static
qualifier to clean up Sparse warning.

Signed-off-by: Guillermo O. Freschi <kedrot@gmail.com>
---
 drivers/staging/media/atomisp/i2c/gc2235.c | 2 +-
 drivers/staging/media/atomisp/i2c/gc2235.h | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 50f431729b6c..04e69dd5fdb1 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -480,7 +480,7 @@ static const struct v4l2_ctrl_ops ctrl_ops = {
 	.g_volatile_ctrl = gc2235_g_volatile_ctrl
 };
 
-struct v4l2_ctrl_config gc2235_controls[] = {
+static struct v4l2_ctrl_config gc2235_controls[] = {
 	{
 	 .ops = &ctrl_ops,
 	 .id = V4L2_CID_EXPOSURE_ABSOLUTE,
diff --git a/drivers/staging/media/atomisp/i2c/gc2235.h b/drivers/staging/media/atomisp/i2c/gc2235.h
index ccbc757045a5..ae8f09dbe5c7 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.h
+++ b/drivers/staging/media/atomisp/i2c/gc2235.h
@@ -530,7 +530,7 @@ static struct gc2235_reg const gc2235_1616_1216_30fps[] = {
 	{ GC2235_TOK_TERM, 0, 0 }
 };
 
-struct gc2235_resolution gc2235_res_preview[] = {
+static struct gc2235_resolution gc2235_res_preview[] = {
 
 	{
 		.desc = "gc2235_1600_900_30fps",
@@ -582,7 +582,7 @@ struct gc2235_resolution gc2235_res_preview[] = {
 };
 #define N_RES_PREVIEW (ARRAY_SIZE(gc2235_res_preview))
 
-struct gc2235_resolution gc2235_res_still[] = {
+static struct gc2235_resolution gc2235_res_still[] = {
 	{
 		.desc = "gc2235_1600_900_30fps",
 		.width = 1600,
@@ -632,7 +632,7 @@ struct gc2235_resolution gc2235_res_still[] = {
 };
 #define N_RES_STILL (ARRAY_SIZE(gc2235_res_still))
 
-struct gc2235_resolution gc2235_res_video[] = {
+static struct gc2235_resolution gc2235_res_video[] = {
 	{
 		.desc = "gc2235_1296_736_30fps",
 		.width = 1296,
-- 
2.11.0
