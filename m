Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:60667 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbdIXKXm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 06:23:42 -0400
Subject: [PATCH 1/6] [media] omap_vout: Delete an error message for a failed
 memory allocation in omap_vout_create_video_devices()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Jan Kara <jack@suse.cz>, Lorenzo Stoakes <lstoakes@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Muralidharan Karicheri <mkaricheri@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f9dc652b-4fca-37aa-0b72-8c9e6a828da9@users.sourceforge.net>
Message-ID: <c949fbd6-0a01-d6e7-d6f9-d55dbf5dce5e@users.sourceforge.net>
Date: Sun, 24 Sep 2017 12:22:55 +0200
MIME-Version: 1.0
In-Reply-To: <f9dc652b-4fca-37aa-0b72-8c9e6a828da9@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 24 Sep 2017 10:08:22 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/omap/omap_vout.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 4d29860d27b4..aebc1e628ac5 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1948,7 +1948,5 @@ static int __init omap_vout_create_video_devices(struct platform_device *pdev)
-		if (!vout) {
-			dev_err(&pdev->dev, ": could not allocate memory\n");
+		if (!vout)
 			return -ENOMEM;
-		}
 
 		vout->vid = k;
 		vid_dev->vouts[k] = vout;
-- 
2.14.1
