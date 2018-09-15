Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52521 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbeIOLYY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 07:24:24 -0400
From: Nathan Chancellor <natechancellor@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] [media] bt8xx: Remove unnecessary self-assignment
Date: Fri, 14 Sep 2018 23:06:13 -0700
Message-Id: <20180915060612.21812-1-natechancellor@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clang warns when a variable is assigned to itself.

drivers/media/pci/bt8xx/bttv-driver.c:2043:13: warning: explicitly
assigning value of variable of type '__s32' (aka 'int') to itself
[-Wself-assign]
        min_height = min_height;
        ~~~~~~~~~~ ^ ~~~~~~~~~~
1 warning generated.

There doesn't appear to be any good reason for this and this statement
was added in commit e5bd0260e7d3 ("V4L/DVB (5077): Bttv cropping
support") back in 2007. Just remove it.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

I'm not sure if the comment should have been removed as well. If it
does, I can easily send a v2.

Thanks!

 drivers/media/pci/bt8xx/bttv-driver.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 413bf287547c..b2cfcbb0008e 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2040,7 +2040,6 @@ limit_scaled_size_lock       (struct bttv_fh *               fh,
 	max_width = max_width & width_mask;
 
 	/* Max. scale factor is 16:1 for frames, 8:1 for fields. */
-	min_height = min_height;
 	/* Min. scale factor is 1:1. */
 	max_height >>= !V4L2_FIELD_HAS_BOTH(field);
 
-- 
2.18.0
