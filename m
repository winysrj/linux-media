Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:24000 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbaCRKmA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 06:42:00 -0400
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Archit Taneja <archit@ti.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] v4l: ti-vpe: fix devm_ioremap_resource() return value checking
Date: Tue, 18 Mar 2014 11:41:42 +0100
Message-id: <2203316.gzhRfbGDkb@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_ioremap_resource() returns a pointer to the remapped memory or
an ERR_PTR() encoded error code on failure.  Fix the checks inside
csc_create() and sc_create() accordingly.

Cc: Archit Taneja <archit@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
Compile tested only.

 drivers/media/platform/ti-vpe/csc.c |    4 ++--
 drivers/media/platform/ti-vpe/sc.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: b/drivers/media/platform/ti-vpe/csc.c
===================================================================
--- a/drivers/media/platform/ti-vpe/csc.c	2014-03-14 16:45:25.848724010 +0100
+++ b/drivers/media/platform/ti-vpe/csc.c	2014-03-18 11:01:36.595182833 +0100
@@ -187,9 +187,9 @@ struct csc_data *csc_create(struct platf
 	}
 
 	csc->base = devm_ioremap_resource(&pdev->dev, csc->res);
-	if (!csc->base) {
+	if (IS_ERR(csc->base)) {
 		dev_err(&pdev->dev, "failed to ioremap\n");
-		return ERR_PTR(-ENOMEM);
+		return csc->base;
 	}
 
 	return csc;
Index: b/drivers/media/platform/ti-vpe/sc.c
===================================================================
--- a/drivers/media/platform/ti-vpe/sc.c	2014-03-14 16:45:25.848724010 +0100
+++ b/drivers/media/platform/ti-vpe/sc.c	2014-03-18 11:02:09.555182273 +0100
@@ -302,9 +302,9 @@ struct sc_data *sc_create(struct platfor
 	}
 
 	sc->base = devm_ioremap_resource(&pdev->dev, sc->res);
-	if (!sc->base) {
+	if (IS_ERR(sc->base)) {
 		dev_err(&pdev->dev, "failed to ioremap\n");
-		return ERR_PTR(-ENOMEM);
+		return sc->base;
 	}
 
 	return sc;

