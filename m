Return-path: <linux-media-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:22031
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932604Ab2C3Khd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Mar 2012 06:37:33 -0400
Received: from mail72-va3 (localhost [127.0.0.1])	by mail72-va3-R.bigfish.com
 (Postfix) with ESMTP id 3881D2200F8	for <linux-media@vger.kernel.org>; Fri,
 30 Mar 2012 10:37:32 +0000 (UTC)
Received: from VA3EHSMHS005.bigfish.com (unknown [10.7.14.249])	by
 mail72-va3.bigfish.com (Postfix) with ESMTP id DCC4D36006B	for
 <linux-media@vger.kernel.org>; Fri, 30 Mar 2012 10:37:30 +0000 (UTC)
Received: from shlinux1.ap.freescale.net ([10.213.130.145])	by
 az84smr01.freescale.net (8.14.3/8.14.0) with ESMTP id q2UAbNUF005093	for
 <linux-media@vger.kernel.org>; Fri, 30 Mar 2012 03:37:23 -0700
From: Liu Ying <Ying.liu@freescale.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: <g.liakhovetski@gmx.de>, <hechtb@gmail.com>,
	<laurent.pinchart@ideasonboard.com>, <sfr@canb.auug.org.au>,
	<linux-media@vger.kernel.org>, Liu Ying <Ying.Liu@freescale.com>
Subject: [PATCH 1/1] [media] V4L: OV5642:remove redundant code to set cropping w/h
Date: Fri, 30 Mar 2012 17:41:27 +0800
Message-ID: <1333100487-32484-1-git-send-email-Ying.liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Liu Ying <Ying.Liu@freescale.com>

This patch contains code change only to remove redundant
code to set priv->crop_rect.width/height in probe function.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 drivers/media/video/ov5642.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
index bb37ec8..efdd6be 100644
--- a/drivers/media/video/ov5642.c
+++ b/drivers/media/video/ov5642.c
@@ -1025,8 +1025,6 @@ static int ov5642_probe(struct i2c_client *client,
 	priv->crop_rect.height	= OV5642_DEFAULT_HEIGHT;
 	priv->crop_rect.left	= (OV5642_MAX_WIDTH - OV5642_DEFAULT_WIDTH) / 2;
 	priv->crop_rect.top	= (OV5642_MAX_HEIGHT - OV5642_DEFAULT_HEIGHT) / 2;
-	priv->crop_rect.width	= OV5642_DEFAULT_WIDTH;
-	priv->crop_rect.height	= OV5642_DEFAULT_HEIGHT;
 	priv->total_width = OV5642_DEFAULT_WIDTH + BLANKING_EXTRA_WIDTH;
 	priv->total_height = BLANKING_MIN_HEIGHT;
 
-- 
1.7.1


