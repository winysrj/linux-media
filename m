Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:40438 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751788AbeD1XMB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 19:12:01 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 093FB9A2
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2018 23:03:05 +0000 (UTC)
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xiPL8b-3ag44 for <linux-media@vger.kernel.org>;
        Sat, 28 Apr 2018 18:03:04 -0500 (CDT)
Received: from mail-it0-f72.google.com (mail-it0-f72.google.com [209.85.214.72])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id D0DD895D
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2018 18:03:04 -0500 (CDT)
Received: by mail-it0-f72.google.com with SMTP id r188-v6so4597188ith.2
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2018 16:03:04 -0700 (PDT)
From: Wenwen Wang <wang6495@umn.edu>
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org (open list:STAGING - ATOMISP DRIVER),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: staging: atomisp: fix a potential missing-check bug
Date: Sat, 28 Apr 2018 18:02:31 -0500
Message-Id: <1524956553-20678-1-git-send-email-wang6495@umn.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At the end of atomisp_subdev_set_selection(), the function
atomisp_subdev_get_rect() is invoked to get the pointer to v4l2_rect. Since
this function may return a NULL pointer, it is firstly invoked to check
the returned pointer. If the returned pointer is not NULL, then the
function is invoked again to obtain the pointer and the memory content
at the location of the returned pointer is copied to the memory location of
r. In most cases, the pointers returned by the two invocations are same.
However, given that the pointer returned by the function
atomisp_subdev_get_rect() is not a constant, it is possible that the two
invocations return two different pointers. For example, another thread may
race to modify the related pointers during the two invocations. In that
case, even if the first returned pointer is not null, the second returned
pointer might be null, which will cause issues such as null pointer
dereference.

This patch saves the pointer returned by the first invocation and removes
the second invocation. If the returned pointer is not NULL, the memory
content is copied according to the original code.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
index 49a9973..d5fa513 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
@@ -366,6 +366,7 @@ int atomisp_subdev_set_selection(struct v4l2_subdev *sd,
 	unsigned int i;
 	unsigned int padding_w = pad_w;
 	unsigned int padding_h = pad_h;
+	struct v4l2_rect *p;
 
 	stream_id = atomisp_source_pad_to_stream_id(isp_sd, vdev_pad);
 
@@ -536,9 +537,10 @@ int atomisp_subdev_set_selection(struct v4l2_subdev *sd,
 		ffmt[pad]->height = comp[pad]->height;
 	}
 
-	if (!atomisp_subdev_get_rect(sd, cfg, which, pad, target))
+	p = atomisp_subdev_get_rect(sd, cfg, which, pad, target);
+	if (!p)
 		return -EINVAL;
-	*r = *atomisp_subdev_get_rect(sd, cfg, which, pad, target);
+	*r = *p;
 
 	dev_dbg(isp->dev, "sel actual: l %d t %d w %d h %d\n",
 		r->left, r->top, r->width, r->height);
-- 
2.7.4
