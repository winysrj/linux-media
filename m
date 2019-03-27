Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408CCC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 02:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C56D208E4
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 02:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553653527;
	bh=ArcGIucQXiy8vIZ0oY6G2rrKIztzKnNxJNPq6tvzvKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LvSofvajpxKO2y/MXOIPw66CfPfFWLXUtzhmYU9MJjfV2RxFdX9k+tYSZwRLNuUlS
	 ie8v0/GRplExHfTMHrlPcoIvO50/gP6XMCtB16WTsmpZDk4tzrkcTb/iTx54XC6jwh
	 lYxTx+otsvI577oP0jVH1rHoysZ+6i3olczAS6oI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732447AbfC0CZW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 22:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732617AbfC0CY7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 22:24:59 -0400
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CDD9208E4;
        Wed, 27 Mar 2019 02:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553653498;
        bh=ArcGIucQXiy8vIZ0oY6G2rrKIztzKnNxJNPq6tvzvKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yW4Z10hbkQfmc6C+hSzm+s6Nsfcfw0We1P/3abNT/VUzwZ4N79ilKsRnap/o5lnBk
         +3hYwI/wiRwtkgEUlxFuNNsc7Rf6ATQiLIdLGyPLL6PQGASBn0Jc82LWz6pAX4KB5G
         bM2wb2L7F1rUjn+dmGIsOMVaQpJuswt2RNARgH6o=
From:   Shuah Khan <shuah@kernel.org>
To:     mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hverkuil@xs4all.nl
Cc:     Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH v12 3/5] media: media.h: Enable ALSA MEDIA_INTF_T* interface types
Date:   Tue, 26 Mar 2019 20:24:50 -0600
Message-Id: <5de53c34d4e5bcc9584f0eda79a353b3b75bd60b.1553634246.git.shuah@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1553634246.git.shuah@kernel.org>
References: <cover.1553634246.git.shuah@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

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

