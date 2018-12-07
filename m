Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34386C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 16:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBD8320673
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 16:01:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="LHXtqYmV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBD8320673
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=megous.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbeLGQBu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 11:01:50 -0500
Received: from vps.xff.cz ([195.181.215.36]:39094 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbeLGQBu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 11:01:50 -0500
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2018 11:01:49 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1544198170; bh=LmUbnue5MJzv+hK1I9FLzBwr7HtQZZapts1I1zfGy3w=;
        h=From:To:Cc:Subject:Date:From;
        b=LHXtqYmVD8jCj3MojaFCHbfyzM3KiOqSTNmJEaNznWOPtZEwiLIljE1qRcYCbJjGq
         7EFuo5dQXnhc5bkt+Q8PZR0oUCQK95aMV+5+7B2c6nxkjDv/UpoXAJ2oCp0tT+8NXO
         xNtaouaZc6JzwGFVtABT70Npjyo4rcpSoOB4c/cw=
From:   megous@megous.com
To:     dev@linux-sunxi.org
Cc:     Ondrej Jirman <megous@megous.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: v4l2-fwnode: Fix setting V4L2_MBUS_DATA_ACTIVE_HIGH/LOW flag
Date:   Fri,  7 Dec 2018 16:56:01 +0100
Message-Id: <20181207155602.27510-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

When parallel bus is used and data-active is being parsed, incorrect
flags are cleared.

Clear the correct flag bits.

Fixes: e9be1b863e2c2948deb003df8edd9635b4611a8a (media: v4l: fwnode:
Use default parallel flags).

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 218f0da0ce76..edd34cf09cf8 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -310,8 +310,8 @@ v4l2_fwnode_endpoint_parse_parallel_bus(struct fwnode_handle *fwnode,
 	}
 
 	if (!fwnode_property_read_u32(fwnode, "data-active", &v)) {
-		flags &= ~(V4L2_MBUS_PCLK_SAMPLE_RISING |
-			   V4L2_MBUS_PCLK_SAMPLE_FALLING);
+		flags &= ~(V4L2_MBUS_DATA_ACTIVE_HIGH |
+			   V4L2_MBUS_DATA_ACTIVE_LOW);
 		flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
 			V4L2_MBUS_DATA_ACTIVE_LOW;
 		pr_debug("data-active %s\n", v ? "high" : "low");
-- 
2.19.2

