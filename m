Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F58C65BAF
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 17:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27A0420868
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 17:57:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27A0420868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=collabora.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbeLGR5U (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 12:57:20 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59522 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbeLGR5T (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 12:57:19 -0500
Received: from localhost.localdomain (unknown [IPv6:2804:431:9719:1d1c:60c2:167c:a334:f7b3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: koike)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 864AA26042B;
        Fri,  7 Dec 2018 17:57:04 +0000 (GMT)
From:   Helen Koike <helen.koike@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org,
        lkcamp@lists.libreplanetbr.org, kernel@collabora.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: vimc: fix start stream when link is disabled
Date:   Fri,  7 Dec 2018 15:56:41 -0200
Message-Id: <20181207175641.1982-1-helen.koike@collabora.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

If link is disabled, media_entity_remote_pad returns NULL, causing a
NULL pointer deference.
Ignore links that are not enabled instead.

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

 drivers/media/platform/vimc/vimc-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index dee1b9dfc4f6..867e24dbd6b5 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -276,6 +276,8 @@ int vimc_pipeline_s_stream(struct media_entity *ent, int enable)
 
 		/* Start the stream in the subdevice direct connected */
 		pad = media_entity_remote_pad(&ent->pads[i]);
+		if (!pad)
+			continue;
 
 		if (!is_media_entity_v4l2_subdev(pad->entity))
 			return -EINVAL;
-- 
2.19.1

