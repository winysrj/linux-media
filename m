Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48677 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440AbaKEISD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 03:18:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 8/8] ti-vpe: fix sparse warnings
Date: Wed,  5 Nov 2014 09:17:52 +0100
Message-Id: <1415175472-24203-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
References: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

sc.c:303:26: warning: incorrect type in return expression (different address spaces)
csc.c:188:27: warning: incorrect type in return expression (different address spaces)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/ti-vpe/csc.c | 2 +-
 drivers/media/platform/ti-vpe/sc.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/csc.c b/drivers/media/platform/ti-vpe/csc.c
index 44fbf41..bec6749 100644
--- a/drivers/media/platform/ti-vpe/csc.c
+++ b/drivers/media/platform/ti-vpe/csc.c
@@ -185,7 +185,7 @@ struct csc_data *csc_create(struct platform_device *pdev)
 	csc->base = devm_ioremap_resource(&pdev->dev, csc->res);
 	if (IS_ERR(csc->base)) {
 		dev_err(&pdev->dev, "failed to ioremap\n");
-		return csc->base;
+		return ERR_CAST(csc->base);
 	}
 
 	return csc;
diff --git a/drivers/media/platform/ti-vpe/sc.c b/drivers/media/platform/ti-vpe/sc.c
index 1088381..f82d1c7 100644
--- a/drivers/media/platform/ti-vpe/sc.c
+++ b/drivers/media/platform/ti-vpe/sc.c
@@ -300,7 +300,7 @@ struct sc_data *sc_create(struct platform_device *pdev)
 	sc->base = devm_ioremap_resource(&pdev->dev, sc->res);
 	if (IS_ERR(sc->base)) {
 		dev_err(&pdev->dev, "failed to ioremap\n");
-		return sc->base;
+		return ERR_CAST(sc->base);
 	}
 
 	return sc;
-- 
2.1.1

