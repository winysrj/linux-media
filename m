Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9F9C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 20:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 470C4222A1
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 20:59:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ku2A8pti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391704AbfBOU7G (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 15:59:06 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37227 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391158AbfBOU7G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 15:59:06 -0500
Received: by mail-wr1-f68.google.com with SMTP id c8so11704720wrs.4
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2019 12:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=loXf6iAXCsTa7/ucswIGYwGRE+4U2uYxtt7L+W/BdNE=;
        b=ku2A8ptiq1EiczxXIpQNWSaFd8DObuEvSOdGq6exNjk4z4aRs7K0ftCdvAY//t9T4K
         TMArObI0lPpucetBikF8R3xCOcbtwqGflsbyaOm004B48Da+zZs5dgisnnQ3a2x0yGjd
         dxK9EzllMH6zH7woGn0yAwFYVMs3+p30K09Dwd/JjHEFq2lsXhhJXfgvRvOkgoymIzTF
         hpPU7CpxmkJdeRE3Hs0x9TjoFS3EUH+OKltrWU7VELDnPvPGMOChJTrCGtnOM1TBxpx7
         DPRCEbVwZIKBp1VtHmIG2P5gtXIDw/lkPCwx7xMMV2VuwOoFbPyOjXcsyZBoPvYB54cx
         j+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=loXf6iAXCsTa7/ucswIGYwGRE+4U2uYxtt7L+W/BdNE=;
        b=JHTC+1D7qizY8km7Uu1JIvNux+A3cMp/tKIaU5ghLQN5Jm+jtdRZ0GbNlHS084wnsW
         Y87Dn31XVekY45la3t2i25EPkdoho1/VIo79zjGuLZDnBU5iT3CKU28BSkhCvqNEHrZX
         4WeWMSHyO72CpjdaaR/UqUspYKAipPcSzUM4edeukYAObI1M75GuQSPt1uoolFfy+Dzs
         e64YeDjh9Gp5kyfZ+dIqHKIDKelxuDXzgz1UWgyNemu8K4BiEsWwVBC+W9WRKJqLTKW3
         /6Yq05ZdDZecKKxoYzWJqVZXdwzvnO0yB25W7AP1pYzdA2uch9+w7w7uRhH0FMa6Z68V
         dWJw==
X-Gm-Message-State: AHQUAua7DNZoDqyNXIlvlt+Cxaaut4KNxRTe6q/4jPW17f2GJh1eGY0b
        uJjoD4VwlVYNk4hMVq3WYVATW/CLEyY=
X-Google-Smtp-Source: AHgI3IadUcyBFdjp8F893yKAVX0a70NVqT1a8ifUKUmIvwS+z47biPo+ea17nNOd+Qpstqg++EIZEw==
X-Received: by 2002:a05:6000:10c1:: with SMTP id b1mr7748649wrx.275.1550264344196;
        Fri, 15 Feb 2019 12:59:04 -0800 (PST)
Received: from localhost.localdomain ([37.26.146.189])
        by smtp.gmail.com with ESMTPSA id r70sm4025777wme.46.2019.02.15.12.59.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 12:59:02 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v2] media: vicodec: Add a flag for I-frames in fwht header
Date:   Fri, 15 Feb 2019 12:58:53 -0800
Message-Id: <20190215205853.48137-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add a flag 'FWHT_FL_I_FRAME' that indicates that
this is an I-frame. This requires incrementing
to version 3

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.h      | 3 ++-
 drivers/media/platform/vicodec/codec-v4l2-fwht.c | 4 +++-
 drivers/media/platform/vicodec/vicodec-core.c    | 4 ++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index 60d71d9dacb3..c410512d47c5 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -56,7 +56,7 @@
 #define FWHT_MAGIC1 0x4f4f4f4f
 #define FWHT_MAGIC2 0xffffffff
 
-#define FWHT_VERSION 2
+#define FWHT_VERSION 3
 
 /* Set if this is an interlaced format */
 #define FWHT_FL_IS_INTERLACED		BIT(0)
@@ -76,6 +76,7 @@
 #define FWHT_FL_CHROMA_FULL_HEIGHT	BIT(7)
 #define FWHT_FL_CHROMA_FULL_WIDTH	BIT(8)
 #define FWHT_FL_ALPHA_IS_UNCOMPRESSED	BIT(9)
+#define FWHT_FL_I_FRAME			BIT(10)
 
 /* A 4-values flag - the number of components - 1 */
 #define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(18, 16)
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index c15034849133..6573a471c5ca 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -218,6 +218,8 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 		flags |= FWHT_FL_CR_IS_UNCOMPRESSED;
 	if (encoding & FWHT_ALPHA_UNENCODED)
 		flags |= FWHT_FL_ALPHA_IS_UNCOMPRESSED;
+	if (!(encoding & FWHT_FRAME_PCODED))
+		flags |= FWHT_FL_I_FRAME;
 	if (rf.height_div == 1)
 		flags |= FWHT_FL_CHROMA_FULL_HEIGHT;
 	if (rf.width_div == 1)
@@ -265,7 +267,7 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 
 	flags = ntohl(state->header.flags);
 
-	if (version == FWHT_VERSION) {
+	if (version >= 2) {
 		if ((flags & FWHT_FL_PIXENC_MSK) != info->pixenc)
 			return -EINVAL;
 		components_num = 1 + ((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 9d739ea5542d..d7636fe9e174 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -339,7 +339,7 @@ info_from_header(const struct fwht_cframe_hdr *p_hdr)
 	unsigned int pixenc = 0;
 	unsigned int version = ntohl(p_hdr->version);
 
-	if (version == FWHT_VERSION) {
+	if (version >= 2) {
 		components_num = 1 + ((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
 				FWHT_FL_COMPONENTS_NUM_OFFSET);
 		pixenc = (flags & FWHT_FL_PIXENC_MSK);
@@ -362,7 +362,7 @@ static bool is_header_valid(const struct fwht_cframe_hdr *p_hdr)
 	if (w < MIN_WIDTH || w > MAX_WIDTH || h < MIN_HEIGHT || h > MAX_HEIGHT)
 		return false;
 
-	if (version == FWHT_VERSION) {
+	if (version >= 2) {
 		unsigned int components_num = 1 +
 			((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
 			FWHT_FL_COMPONENTS_NUM_OFFSET);
-- 
2.17.1

