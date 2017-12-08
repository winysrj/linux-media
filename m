Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:47387 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751213AbdLHR4Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 12:56:25 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Fixed pr_fmt.patch
Date: Fri,  8 Dec 2017 18:56:16 +0100
Message-Id: <1512755776-6561-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/pr_fmt.patch | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/backports/pr_fmt.patch b/backports/pr_fmt.patch
index 53f0273..d36e071 100644
--- a/backports/pr_fmt.patch
+++ b/backports/pr_fmt.patch
@@ -34,9 +34,9 @@ index 75897f95e4b4..6d5c3ea28e1c 100644
 +++ b/drivers/media/common/saa7146/saa7146_i2c.c
 @@ -1,3 +1,4 @@
 +#undef pr_fmt
+ // SPDX-License-Identifier: GPL-2.0
  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
  
- #include <media/drv-intf/saa7146_vv.h>
 diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
 index b3b29d4f36ed..9f679334437e 100644
 --- a/drivers/media/common/saa7146/saa7146_video.c
-- 
2.7.4
