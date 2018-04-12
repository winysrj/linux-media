Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41632 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753729AbeDLPYX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:24:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        stable@vger.kernel.org
Subject: [PATCH 10/17] media: v4l2-compat-ioctl32: prevent go past max size
Date: Thu, 12 Apr 2018 11:24:02 -0400
Message-Id: <14713aeb03c27ea39967d47594e2ad36ff9184b9.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/v4l2-core/v4l2-compat-ioctl32.c:879 put_v4l2_ext_controls32() warn: check for integer overflow 'count'

The access_ok() logic should check for too big arrays too.

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 4312935f1dfc..d03a44d89649 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -871,7 +871,7 @@ static int put_v4l2_ext_controls32(struct file *file,
 	    get_user(kcontrols, &kp->controls))
 		return -EFAULT;
 
-	if (!count)
+	if (!count || count > (U32_MAX/sizeof(*ucontrols)))
 		return 0;
 	if (get_user(p, &up->controls))
 		return -EFAULT;
-- 
2.14.3
