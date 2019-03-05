Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B0BC4360F
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 166DF2087C
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbfCEN4J (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 08:56:09 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49508 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727751AbfCEN4G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 08:56:06 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id B4E30634C7F;
        Tue,  5 Mar 2019 15:55:04 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     akinobu.mita@gmail.com, robert.jarzmik@free.fr, hverkuil@xs4all.nl,
        bparrot@ti.com
Subject: [PATCH 3/4] pxa-camera: Match with device node, not the port node
Date:   Tue,  5 Mar 2019 15:56:01 +0200
Message-Id: <20190305135602.24199-4-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190305135602.24199-1-sakari.ailus@linux.intel.com>
References: <20190305135602.24199-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

V4L2 fwnode matching right now still works based on device nodes, not port
nodes. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/pxa_camera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 3cf3c6390cc8..f729519f34e1 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2350,7 +2350,7 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 		pcdev->platform_flags |= PXA_CAMERA_PCLK_EN;
 
 	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-	remote = of_graph_get_remote_port(np);
+	remote = of_graph_get_remote_port_parent(np);
 	if (remote)
 		asd->match.fwnode = of_fwnode_handle(remote);
 	else
-- 
2.11.0

