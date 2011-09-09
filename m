Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab1IIROM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 13:14:12 -0400
Date: Fri, 9 Sep 2011 19:14:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: linux-sh@vger.kernel.org
Subject: [PATCH] V4L: sh_mobile_csi2: fix unbalanced pm_runtime_put()
Message-ID: <Pine.LNX.4.64.1109091910230.915@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the sh_mobile_csi2 driver didn't attach to a client, normally, because
the respective device connects to the SoC over the parallel CEU interface
and doesn't use the CSI-2 controller, it also shouldn't call
pm_runtime_put() on attempted disconnect.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

If it also applies to the current Linus' tree, it could be a good idea to 
push it to 3.1. But in practice it's not a very serious bug, it would only 
affect systems with a serial / CSI-2 _and_ a parallel cameras connected 
simultaneously to one CEU interface, where the user switches between them 
at runtime. In any case it should be trivial to backport it to 3.1.

 drivers/media/video/sh_mobile_csi2.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/sh_mobile_csi2.c b/drivers/media/video/sh_mobile_csi2.c
index 91c680a..37706eb 100644
--- a/drivers/media/video/sh_mobile_csi2.c
+++ b/drivers/media/video/sh_mobile_csi2.c
@@ -208,6 +208,9 @@ static int sh_csi2_client_connect(struct sh_csi2 *priv)
 	unsigned long common_flags, csi2_flags;
 	int i, ret;
 
+	if (priv->client)
+		return -EBUSY;
+
 	for (i = 0; i < pdata->num_clients; i++)
 		if (&pdata->clients[i].pdev->dev == icd->pdev)
 			break;
@@ -262,6 +265,9 @@ static int sh_csi2_client_connect(struct sh_csi2 *priv)
 
 static void sh_csi2_client_disconnect(struct sh_csi2 *priv)
 {
+	if (!priv->client)
+		return;
+
 	priv->client = NULL;
 
 	pm_runtime_put(v4l2_get_subdevdata(&priv->subdev));
-- 
1.7.2.5

