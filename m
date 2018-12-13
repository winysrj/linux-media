Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77732C67872
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BCE02087F
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:41:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BCE02087F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbeLMNlX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 08:41:23 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:51642 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729663AbeLMNlS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 08:41:18 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud7.xs4all.net with ESMTPA
        id XREngf3iadllcXREpgEECY; Thu, 13 Dec 2018 14:41:15 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv5 PATCH 4/4] vimc: add property test code
Date:   Thu, 13 Dec 2018 14:41:13 +0100
Message-Id: <20181213134113.15247-5-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181213134113.15247-1-hverkuil-cisco@xs4all.nl>
References: <20181213134113.15247-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfHOaWAa9T0hX0cy0lvLPmonAa9fBNHICWnMmB+u3IVCGCsJHEggH9FjzVoprc6YFyE5n8/zTY61pZmuyKsRoUVYHLbEAvZBVXmnG4CxVUyorrptV0uC2
 B1EIofqPJQdckMVnBOI5VBLMa0dcYn2QTxUXCUg8JFPEtmEng+fdpBOuzMAx7qePBdRu9/BLE3rFnTattHBcHkXqpAQfESrkQL5CkhWiJ1/Qk96CQmvjy8RJ
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

Add properties to entities and pads to be able to test the
properties API.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vimc/vimc-common.c | 50 +++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index 867e24dbd6b5..e3d5d4b3b44d 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -417,6 +417,7 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
 			 const unsigned long *pads_flag,
 			 const struct v4l2_subdev_ops *sd_ops)
 {
+	struct media_prop *prop = NULL;
 	int ret;
 
 	/* Allocate the pads */
@@ -454,6 +455,55 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
 		goto err_clean_m_ent;
 	}
 
+	ret = media_entity_add_prop_u64(&sd->entity, "u64", ~1);
+	if (!ret)
+		ret = media_entity_add_prop_s64(&sd->entity, "s64", -5);
+	if (!ret)
+		ret = media_entity_add_prop_string(&sd->entity, "string",
+						   sd->name);
+	if (!ret) {
+		prop = media_entity_add_prop_group(&sd->entity, "empty-group");
+		ret = PTR_ERR_OR_ZERO(prop);
+	}
+	if (!ret) {
+		prop = media_entity_add_prop_group(&sd->entity, "group");
+		ret = PTR_ERR_OR_ZERO(prop);
+	}
+	if (!ret)
+		ret = media_prop_add_prop_u64(prop, "u64", 42);
+	if (!ret)
+		ret = media_prop_add_prop_s64(prop, "s64", -42);
+	if (!ret)
+		ret = media_prop_add_prop_string(prop, "string", "42");
+	if (!ret)
+		ret = media_pad_add_prop_u64(&sd->entity.pads[num_pads - 1],
+					     "u64", ~1);
+	if (!ret)
+		ret = media_pad_add_prop_s64(&sd->entity.pads[num_pads - 1],
+					     "s64", -5);
+	if (!ret) {
+		prop = media_pad_add_prop_group(&sd->entity.pads[num_pads - 1],
+						"group");
+		ret = PTR_ERR_OR_ZERO(prop);
+	}
+	if (!ret)
+		ret = media_prop_add_prop_u64(prop, "u64", 24);
+	if (!ret)
+		ret = media_prop_add_prop_s64(prop, "s64", -24);
+	if (!ret)
+		ret = media_pad_add_prop_string(&sd->entity.pads[0],
+						"string", sd->name);
+	if (!ret)
+		ret = media_prop_add_prop_string(prop, "string", "24");
+	if (!ret) {
+		prop = media_prop_add_prop_group(prop, "subgroup");
+		ret = PTR_ERR_OR_ZERO(prop);
+	}
+	if (!ret)
+		ret = media_prop_add_prop_string(prop, "string", "substring");
+	if (ret)
+		goto err_clean_m_ent;
+
 	return 0;
 
 err_clean_m_ent:
-- 
2.19.2

