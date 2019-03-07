Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8EF5C4360F
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 09:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4E5220835
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 09:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfCGJaI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 04:30:08 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:58077 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726143AbfCGJaI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Mar 2019 04:30:08 -0500
Received: from test-no.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 1pLlh7xLdLMwI1pLqhxTCD; Thu, 07 Mar 2019 10:30:06 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv3 4/9] media-entity: set ent_enum->bmap to NULL after freeing it
Date:   Thu,  7 Mar 2019 10:29:56 +0100
Message-Id: <20190307093001.30435-5-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190307093001.30435-1-hverkuil-cisco@xs4all.nl>
References: <20190307093001.30435-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDtJVmErlPxBa0Ma2lFQL3c+sE45ne12HMFudPKIcpNYPTmhRHzD3xO23RtUMY3+tDpj/PlAd6xQKw4abxR8DDbQCWCeqVwfyeBZWWwqV7hUbi81d8KO
 4eHpAWVAc+6IVFbp9kXfysnSaOa/zfJuuFbGgy0Gpu4npbX/kLHPlk1nBuH+6nwCAyos44CyPzQv4gaktqUCgwEabljcCRbKmJZ22iJrpTCDEArIPJ6B4UNo
 oBNxJX2G8iE0NhDfBguNHKlhm4EH0MEYS4HsjCkWSoN6/1p0FfiAi1Ug+NUUCc3+O3rYIU8ViTa1CrEyf8guWA==
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

