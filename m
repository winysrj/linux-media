Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34917 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932312AbcLMLuv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 06:50:51 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: kyungmin.park@samsung.com, riverful.kim@samsung.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] media: i2c: m5mols: m5mols_core: constify v4l2_subdev_pad_ops structures
Date: Tue, 13 Dec 2016 17:19:45 +0530
Message-Id: <1481629785-7547-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_subdev_pad_ops structures are stored in the pad field
of the v4l2_subdev_ops structure and this field is of type const.
As the v4l2_subdev_pad_ops structures are never modified, they can be
declared as const.
Done using Coccinelle:

@r1 disable optional_qualifier @
identifier i;
position p;
@@
static struct v4l2_subdev_pad_ops i@p = {...};

@ok1@
identifier r1.i;
position p;
struct v4l2_subdev_ops obj;
@@
obj.pad=&i@p;

@bad@
position p!={r1.p,ok1.p};
identifier r1.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
+const
struct v4l2_subdev_pad_ops i;

File size before:
 text	   data	    bss	    dec	    hex	filename
   7633	    512	     20	   8165	   1fe5	media/i2c/m5mols/m5mols_core.o

File size after:
  text	   data	    bss	    dec	    hex	filename
   7761	    384	     20	   8165	   1fe5	media/i2c/m5mols/m5mols_core.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/i2c/m5mols/m5mols_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index acb804b..91451c4c 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -651,7 +651,7 @@ static int m5mols_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static struct v4l2_subdev_pad_ops m5mols_pad_ops = {
+static const struct v4l2_subdev_pad_ops m5mols_pad_ops = {
 	.enum_mbus_code	= m5mols_enum_mbus_code,
 	.get_fmt	= m5mols_get_fmt,
 	.set_fmt	= m5mols_set_fmt,
-- 
1.9.1

