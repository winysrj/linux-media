Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BD9C43444
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 17:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBA9621873
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 17:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545155988;
	bh=FP1k+TdJWCFxrBvBUh8kO45spYv1nS2ax7SbyevbaWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=yLlaT8K/lNZCIuEw4J5ZV6lOc2sduPNOZFvXajXjh1ODfjhGEf9rH46FqYHta6ZF9
	 ervRNBRy0paccVEsRjVrce9SRaF3n2COzn+op3HakAyqMmdAc0E6iOIPu0Vx8U2JiU
	 jo4fIri3F8v3ajtLY9vMzJEJUIBPnmUjABMTngDA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbeLRR7r (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 12:59:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727565AbeLRR7q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 12:59:46 -0500
Received: from localhost.localdomain (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 544B7218A6;
        Tue, 18 Dec 2018 17:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545155985;
        bh=FP1k+TdJWCFxrBvBUh8kO45spYv1nS2ax7SbyevbaWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bi+1U4aiOAFA56Pi+M29+R1k3vqcmW55DkqWoIoNhY22LYpSdNRJ8JWUWdM0Gzwt
         /JTxUX9IK2J6U8VckZgShKJCyn/zcaN53nSXUaavjVFZ/lKRoE89ZfJp80P0KG/bPB
         /icDtYDiibY8nI1YaIvCXMCC+CnmNwtyPui7uKV0=
From:   shuah@kernel.org
To:     mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hverkuil@xs4all.nl
Cc:     Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH v9 3/4] media: media.h: Enable ALSA MEDIA_INTF_T* interface types
Date:   Tue, 18 Dec 2018 10:59:38 -0700
Message-Id: <51765ea91f793e00728592a897a98ee69c657fe1.1545154778.git.shuah@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1545154777.git.shuah@kernel.org>
References: <cover.1545154777.git.shuah@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Shuah Khan <shuah@kernel.org>

Move PCM_CAPTURE, PCM_PLAYBACK, and CONTROL ALSA MEDIA_INTF_T* interface
types back into __KERNEL__ scope to get ready for adding ALSA support for
these to the media controller.

Signed-off-by: Shuah Khan <shuah@kernel.org>
---
 include/uapi/linux/media.h | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index e5d0c5c611b5..9aedb187bc48 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -262,6 +262,11 @@ struct media_links_enum {
 #define MEDIA_INTF_T_V4L_SWRADIO		(MEDIA_INTF_T_V4L_BASE + 4)
 #define MEDIA_INTF_T_V4L_TOUCH			(MEDIA_INTF_T_V4L_BASE + 5)
 
+#define MEDIA_INTF_T_ALSA_BASE			0x00000300
+#define MEDIA_INTF_T_ALSA_PCM_CAPTURE		(MEDIA_INTF_T_ALSA_BASE)
+#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK		(MEDIA_INTF_T_ALSA_BASE + 1)
+#define MEDIA_INTF_T_ALSA_CONTROL		(MEDIA_INTF_T_ALSA_BASE + 2)
+
 #if defined(__KERNEL__)
 
 /*
@@ -413,19 +418,19 @@ struct media_v2_topology {
 #define MEDIA_ENT_F_DTV_DECODER			MEDIA_ENT_F_DV_DECODER
 
 /*
- * There is still no ALSA support in the media controller. These
+ * There is still no full ALSA support in the media controller. These
  * defines should not have been added and we leave them here only
  * in case some application tries to use these defines.
+ *
+ * The ALSA defines that are in use have been moved into __KERNEL__
+ * scope. As support gets added to these interface types, they should
+ * be moved into __KERNEL__ scope with the code that uses them.
  */
-#define MEDIA_INTF_T_ALSA_BASE			0x00000300
-#define MEDIA_INTF_T_ALSA_PCM_CAPTURE		(MEDIA_INTF_T_ALSA_BASE)
-#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK		(MEDIA_INTF_T_ALSA_BASE + 1)
-#define MEDIA_INTF_T_ALSA_CONTROL		(MEDIA_INTF_T_ALSA_BASE + 2)
-#define MEDIA_INTF_T_ALSA_COMPRESS		(MEDIA_INTF_T_ALSA_BASE + 3)
-#define MEDIA_INTF_T_ALSA_RAWMIDI		(MEDIA_INTF_T_ALSA_BASE + 4)
-#define MEDIA_INTF_T_ALSA_HWDEP			(MEDIA_INTF_T_ALSA_BASE + 5)
-#define MEDIA_INTF_T_ALSA_SEQUENCER		(MEDIA_INTF_T_ALSA_BASE + 6)
-#define MEDIA_INTF_T_ALSA_TIMER			(MEDIA_INTF_T_ALSA_BASE + 7)
+#define MEDIA_INTF_T_ALSA_COMPRESS             (MEDIA_INTF_T_ALSA_BASE + 3)
+#define MEDIA_INTF_T_ALSA_RAWMIDI              (MEDIA_INTF_T_ALSA_BASE + 4)
+#define MEDIA_INTF_T_ALSA_HWDEP                (MEDIA_INTF_T_ALSA_BASE + 5)
+#define MEDIA_INTF_T_ALSA_SEQUENCER            (MEDIA_INTF_T_ALSA_BASE + 6)
+#define MEDIA_INTF_T_ALSA_TIMER                (MEDIA_INTF_T_ALSA_BASE + 7)
 
 /* Obsolete symbol for media_version, no longer used in the kernel */
 #define MEDIA_API_VERSION			((0 << 16) | (1 << 8) | 0)
-- 
2.17.1

