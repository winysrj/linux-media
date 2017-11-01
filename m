Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33655 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933417AbdKAVGL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 12/26] media: davinci: fix a debug printk
Date: Wed,  1 Nov 2017 17:05:49 -0400
Message-Id: <c0f1eacb1871395845a89668f18a6663c9dabbfd.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two orthogonal changesets caused a breakage at a printk
inside davinci. Changeset a2d17962c9ca
("[media] davinci: Switch from V4L2 OF to V4L2 fwnode")
made davinci to use struct fwnode_handle instead of
struct device_node. Changeset 68d9c47b1679
("media: Convert to using %pOF instead of full_name")
changed the printk to not use ->full_name, but, instead,
to rely on %pOF.

With both patches applied, the Kernel will do the wrong
thing, as warned by smatch:
	drivers/media/platform/davinci/vpif_capture.c:1399 vpif_async_bound() error: '%pOF' expects argument of type 'struct device_node*', argument 5 has type 'void*'

So, change the logic to actually print the device name
that was obtained before the print logic.

Fixes: 68d9c47b1679 ("media: Convert to using %pOF instead of full_name")
Fixes: a2d17962c9ca ("[media] davinci: Switch from V4L2 OF to V4L2 fwnode")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index a89367ab1e06..1a443181a320 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1397,9 +1397,9 @@ static int vpif_async_bound(struct v4l2_async_notifier *notifier,
 			vpif_obj.config->chan_config->inputs[i].subdev_name =
 				(char *)to_of_node(subdev->fwnode)->full_name;
 			vpif_dbg(2, debug,
-				 "%s: setting input %d subdev_name = %pOF\n",
+				 "%s: setting input %d subdev_name = %s\n",
 				 __func__, i,
-				 to_of_node(subdev->fwnode));
+				vpif_obj.config->chan_config->inputs[i].subdev_name);
 			return 0;
 		}
 	}
-- 
2.13.6
