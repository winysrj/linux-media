Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33184 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933175AbdKAVGN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 13/26] media: rcar: fix a debug printk
Date: Wed,  1 Nov 2017 17:05:50 -0400
Message-Id: <ef0a1dc7f902c8ed9cc8aa454bd07a8fcda66dfa.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two orthogonal changesets caused a breakage at a printk
inside rcar. Changeset 859969b38e2e
("[media] v4l: Switch from V4L2 OF not V4L2 fwnode API")
made davinci to use struct fwnode_handle instead of
struct device_node. Changeset 68d9c47b1679
("media: Convert to using %pOF instead of full_name")
changed the printk to not use ->full_name, but, instead,
to rely on %pOF.

With both patches applied, the Kernel will do the wrong
thing, as warned by smatch:
	drivers/media/platform/rcar-vin/rcar-core.c:189 rvin_digital_graph_init() error: '%pOF' expects argument of type 'struct device_node*', argument 4 has type 'void*'

So, change the logic to actually print the device name
that was obtained before the print logic.

Fixes: 68d9c47b1679 ("media: Convert to using %pOF instead of full_name")
Fixes: 859969b38e2e ("[media] v4l: Switch from V4L2 OF not V4L2 fwnode API")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 108d776f3265..ce5914f7a056 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -186,8 +186,8 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 	if (!vin->digital)
 		return -ENODEV;
 
-	vin_dbg(vin, "Found digital subdevice %pOF\n",
-		to_of_node(vin->digital->asd.match.fwnode.fwnode));
+	vin_dbg(vin, "Found digital subdevice %s\n",
+		to_of_node(vin->digital->asd.match.fwnode.fwnode)->full_name);
 
 	vin->notifier.ops = &rvin_digital_notify_ops;
 	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
-- 
2.13.6
