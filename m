Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:61905 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbdIXK3V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 06:29:21 -0400
Subject: [PATCH 4/6] [media] omap_vout: Fix a possible null pointer
 dereference in omap_vout_open()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Jan Kara <jack@suse.cz>, Lorenzo Stoakes <lstoakes@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Muralidharan Karicheri <mkaricheri@gmail.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f9dc652b-4fca-37aa-0b72-8c9e6a828da9@users.sourceforge.net>
Message-ID: <15332564-0c8d-a197-b987-f54e29768e56@users.sourceforge.net>
Date: Sun, 24 Sep 2017 12:28:54 +0200
MIME-Version: 1.0
In-Reply-To: <f9dc652b-4fca-37aa-0b72-8c9e6a828da9@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 24 Sep 2017 11:00:57 +0200

Move a debug message so that a null pointer access can not happen
for the variable "vout" in this function.

Fixes: 5c7ab6348e7b3fcca2b8ee548306c774472971e2 ("V4L/DVB: V4L2: Add support for OMAP2/3 V4L2 display driver on top of DSS2")

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/omap/omap_vout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 2b55a8ebd1ad..71b77426271e 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1004,11 +1004,11 @@ static int omap_vout_open(struct file *file)
 	struct omap_vout_device *vout = NULL;
 
 	vout = video_drvdata(file);
-	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "Entering %s\n", __func__);
-
 	if (!vout)
 		return -ENODEV;
 
+	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "Entering %s\n", __func__);
+
 	/* for now, we only support single open */
 	if (vout->opened)
 		return -EBUSY;
-- 
2.14.1
