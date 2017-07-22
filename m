Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:53770 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755229AbdGVLbB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Jul 2017 07:31:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 2/6] s3c-camif: don't set driver_version
Date: Sat, 22 Jul 2017 13:30:53 +0200
Message-Id: <20170722113057.45202-3-hverkuil@xs4all.nl>
In-Reply-To: <20170722113057.45202-1-hverkuil@xs4all.nl>
References: <20170722113057.45202-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This field will be removed as it is not needed anymore.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/s3c-camif/camif-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index 8f0414041e81..c4ab63986c8f 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -317,7 +317,6 @@ static int camif_media_dev_init(struct camif_dev *camif)
 		 ip_rev == S3C6410_CAMIF_IP_REV ? "6410" : "244X");
 	strlcpy(md->bus_info, "platform", sizeof(md->bus_info));
 	md->hw_revision = ip_rev;
-	md->driver_version = LINUX_VERSION_CODE;
 
 	md->dev = camif->dev;
 
-- 
2.13.2
