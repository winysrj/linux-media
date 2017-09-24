Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:65459 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbdIXK0u (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 06:26:50 -0400
Subject: [PATCH 3/6] [media] omap_vout: Adjust a null pointer check in two
 functions
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
Message-ID: <28d2db5e-0cc3-04eb-16d6-0b6f0ecfe19c@users.sourceforge.net>
Date: Sun, 24 Sep 2017 12:26:35 +0200
MIME-Version: 1.0
In-Reply-To: <f9dc652b-4fca-37aa-0b72-8c9e6a828da9@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 24 Sep 2017 10:30:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/omap/omap_vout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 4a4d171ca573..2b55a8ebd1ad 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1006,7 +1006,7 @@ static int omap_vout_open(struct file *file)
 	vout = video_drvdata(file);
 	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "Entering %s\n", __func__);
 
-	if (vout == NULL)
+	if (!vout)
 		return -ENODEV;
 
 	/* for now, we only support single open */
@@ -2095,7 +2095,7 @@ static int __init omap_vout_probe(struct platform_device *pdev)
 	}
 
 	vid_dev = kzalloc(sizeof(*vid_dev), GFP_KERNEL);
-	if (vid_dev == NULL) {
+	if (!vid_dev) {
 		ret = -ENOMEM;
 		goto err_dss_init;
 	}
-- 
2.14.1
