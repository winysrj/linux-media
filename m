Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC34C10F09
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 09:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C63852084D
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 09:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfCEJ6y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 04:58:54 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:38983 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727497AbfCEJ6y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 04:58:54 -0500
Received: from test-no.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 16qVhtdVBLMwI16qahrctE; Tue, 05 Mar 2019 10:58:52 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv2 4/9] media-entity: set ent_enum->bmap to NULL after freeing it
Date:   Tue,  5 Mar 2019 10:58:42 +0100
Message-Id: <20190305095847.21428-5-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
References: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfP+uY9uGQYe20y5TGuTJqaR1zB8TGzHZINr7yBiK0P7Q/AhAt1T1lYldFKqjWoC51MuN/RZdoEhi8FCg/8rXZV4ZU/kx55IbUacHm5wv8+GFEGt0O0jx
 nDSXLgWi5xm34zC5xkThlbZsuXcyG39PofBCS5yyhiMTEMUktaBe/oEwU7JJN6jV3dfEhuHsQi17yvr9okq7c8fv2P23dIkQns0gvrZS76YvNobC5f0nCCIh
 1B9yKdJG1JxnFnvP1aTSVjV+ty2ih3ViE1YKg9+MBI2xGAbcnSSuh+QmvMZ0m/mvE6nrl7eWbLwPqBYREdVkfQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Ensure that this pointer is set to NULL after it is freed.
The vimc driver has a static media_entity and after
unbinding and rebinding the vimc device the media code will
try to free this pointer again since it wasn't set to NULL.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/media-entity.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 0b1cb3559140..7b2a2cc95530 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -88,6 +88,7 @@ EXPORT_SYMBOL_GPL(__media_entity_enum_init);
 void media_entity_enum_cleanup(struct media_entity_enum *ent_enum)
 {
 	kfree(ent_enum->bmap);
+	ent_enum->bmap = NULL;
 }
 EXPORT_SYMBOL_GPL(media_entity_enum_cleanup);
 
-- 
2.20.1

