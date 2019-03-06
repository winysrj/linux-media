Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A05AC10F00
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 139E420684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sGfnxYIT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfCFVO1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:27 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51827 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfCFVO0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:26 -0500
Received: by mail-wm1-f67.google.com with SMTP id n19so7289574wmi.1
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GEbCD/ih7J+/ZvXmFpUkDA3R5lsMRrCkygPLKoaIavw=;
        b=sGfnxYITC5k0Q7VcGtAfFy0jnJgj6nXZXyhwLDgxRGQDh5LXLO2R/9PKjvpLDjIiBF
         XjGr2QkHAb4C8Mz9uno0Tok3WyagAXgz5tyzHC2YbRr/xjjGhEfc1QW57nMFos9gN2rB
         1O2wlG1xeBNk6k/jAu3lvosV4PqlZnwtPcWcbeKVRb/H6GhYgvQtnWW6cnwSOPeET6fD
         JNegZUxj3c1vc9HQref44wBGA3GYQzX6JM8S7JSJPwKHZM+O4ss1qwsjt+PjS0ume8T/
         URxZlWe4+OagtYPMIDfvkIJz55CUeNdysgd3+Qm0XGfpAahWhXbYH8+fa9awCX3r/5hd
         xRsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GEbCD/ih7J+/ZvXmFpUkDA3R5lsMRrCkygPLKoaIavw=;
        b=OHecppx7HjER+hqdyRh4ZdeAl+i3/vu1SSDXFrHOkPmfot8iwfSzImr3w8Am0EK262
         mdEKr2Yg67V6UrBR0sjU/d6O5VDCGe2rXtXhVxdsjwj+Dy9/pVSdu5RaJ22Vi9LNOgK1
         sCwVmX0aiI5iuZc9Q4PFmqzglLsHoIzroggfWtNxolrxi33g5JOe+oTkd+4Cyna4D3MD
         YimIF3tn76cvFLX+KjMHXVP4IvRaILUIrp/9vse4KWlbrX7Hfm5aWI07LtvDLXmlP/PS
         qppy0DNq6lfVpBts+NAP1KemRqoJatY5/U82PjqW3ICvBfIpI3cLQ05/1RN7bXexCmww
         atrQ==
X-Gm-Message-State: APjAAAXN6fvt0QCCjHo6/mVN0bU+b58zPaUVAdn4AV1W+M9DA9DqtUXY
        6e55WwTdVYz9MeGXDWBMB/XvFn6vfA0=
X-Google-Smtp-Source: APXvYqwECtY7lkcQHnL17EYyXmvg1N55EDpAc2E19dt35T+wHr5GtCgDlcJPV3M/TvW6KVkP0Bof+g==
X-Received: by 2002:a1c:16:: with SMTP id 22mr3388964wma.91.1551906864577;
        Wed, 06 Mar 2019 13:14:24 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:23 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 13/23] media: vicodec: Validate version dependent header values in a separate function
Date:   Wed,  6 Mar 2019 13:13:33 -0800
Message-Id: <20190306211343.15302-14-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Move the code that validates version dependent header
values to a separate function 'validate_by_version'

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 31 ++++++++++++-------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 4b97ba30fec3..d051f9901409 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -191,6 +191,23 @@ static void copy_cap_to_ref(const u8 *cap, const struct v4l2_fwht_pixfmt_info *i
 	}
 }
 
+static bool validate_by_version(unsigned int flags, unsigned int version)
+{
+	if (!version || version > FWHT_VERSION)
+		return false;
+
+	if (version >= 2) {
+		unsigned int components_num = 1 +
+			((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
+			 FWHT_FL_COMPONENTS_NUM_OFFSET);
+		unsigned int pixenc = flags & FWHT_FL_PIXENC_MSK;
+
+		if (components_num == 0 || components_num > 4 || !pixenc)
+			return false;
+	}
+	return true;
+}
+
 static int device_process(struct vicodec_ctx *ctx,
 			  struct vb2_v4l2_buffer *src_vb,
 			  struct vb2_v4l2_buffer *dst_vb)
@@ -397,21 +414,11 @@ static bool is_header_valid(const struct fwht_cframe_hdr *p_hdr)
 	unsigned int version = ntohl(p_hdr->version);
 	unsigned int flags = ntohl(p_hdr->flags);
 
-	if (!version || version > FWHT_VERSION)
-		return false;
-
 	if (w < MIN_WIDTH || w > MAX_WIDTH || h < MIN_HEIGHT || h > MAX_HEIGHT)
 		return false;
 
-	if (version >= 2) {
-		unsigned int components_num = 1 +
-			((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
-			FWHT_FL_COMPONENTS_NUM_OFFSET);
-		unsigned int pixenc = flags & FWHT_FL_PIXENC_MSK;
-
-		if (components_num == 0 || components_num > 4 || !pixenc)
-			return false;
-	}
+	if (!validate_by_version(flags, version))
+		return false;
 
 	info = info_from_header(p_hdr);
 	if (!info)
-- 
2.17.1

