Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34986 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbcAZSjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 13:39:18 -0500
Date: Wed, 27 Jan 2016 00:09:14 +0530
From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
To: hverkuil@xs4all.nl, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] media: platform: vivid: vivid-osd: Remove unnecessary cast
 to kfree
Message-ID: <20160126183914.GA29658@amitoj-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove an unnecassary cast in the argument to kfree.

Found using Coccinelle. The semantic patch used to find this is as follows:

//<smpl>
@@
type T;
expression *f;
@@

- kfree((T *)(f));
+ kfree(f);
//</smpl>

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/media/platform/vivid/vivid-osd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-osd.c b/drivers/media/platform/vivid/vivid-osd.c
index 084d346..0869eb5 100644
--- a/drivers/media/platform/vivid/vivid-osd.c
+++ b/drivers/media/platform/vivid/vivid-osd.c
@@ -359,7 +359,7 @@ void vivid_fb_release_buffers(struct vivid_dev *dev)
 
 	/* Release pseudo palette */
 	kfree(dev->fb_info.pseudo_palette);
-	kfree((void *)dev->video_vbase);
+	kfree(dev->video_vbase);
 }
 
 /* Initialize the specified card */
-- 
1.9.1

