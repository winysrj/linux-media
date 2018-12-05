Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C657C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 16:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EB8F2084C
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 16:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EB8F2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lucaceresoli.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbeLEQzz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 11:55:55 -0500
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:44918 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbeLEQzz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 11:55:55 -0500
Received: from [109.168.11.45] (port=58050 helo=pc-ceresoli.dev.aim)
        by srv-hp10.netsons.net with esmtpa (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1gUaSl-009CjB-AU; Wed, 05 Dec 2018 17:55:51 +0100
From:   Luca Ceresoli <luca@lucaceresoli.net>
To:     linux-media@vger.kernel.org
Cc:     Luca Ceresoli <luca@lucaceresoli.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: v4l2-subdev: document controls need _FL_HAS_DEVNODE
Date:   Wed,  5 Dec 2018 17:55:37 +0100
Message-Id: <20181205165537.21502-1-luca@lucaceresoli.net>
X-Mailer: git-send-email 2.17.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv-hp10.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: srv-hp10.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: srv-hp10.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Control events can be subscribed and received by the user. Therefore
drivers that support controls must expose the
V4L2_SUBDEV_FL_HAS_EVENTS flag.

[As discussed in https://lkml.org/lkml/2018/11/27/637]
Reported-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 include/media/v4l2-subdev.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 9102d6ca566e..47af609dc8f1 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -776,7 +776,11 @@ struct v4l2_subdev_internal_ops {
 #define V4L2_SUBDEV_FL_IS_SPI			(1U << 1)
 /* Set this flag if this subdev needs a device node. */
 #define V4L2_SUBDEV_FL_HAS_DEVNODE		(1U << 2)
-/* Set this flag if this subdev generates events. */
+/*
+ * Set this flag if this subdev generates events.
+ * Note controls can send events, thus drivers exposing controls
+ * should set this flag.
+ */
 #define V4L2_SUBDEV_FL_HAS_EVENTS		(1U << 3)
 
 struct regulator_bulk_data;
-- 
2.17.1

