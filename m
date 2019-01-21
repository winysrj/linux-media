Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72761C7113B
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 11:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 356DF2085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 11:46:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b0j4PIem"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbfAULqj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 06:46:39 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44345 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727931AbfAULqj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 06:46:39 -0500
Received: by mail-wr1-f65.google.com with SMTP id z5so22914387wrt.11
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 03:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CRKPeEVvwbwPyW8PlCLSf72e4jMeIVWoAQn62FQ1RKs=;
        b=b0j4PIemNlWC4026BxZ+wVFTRQ+KXpelpqAGuqMNqwZg+ceZFZGBvBCqZeS4jqXjo5
         uTPmJl4PVBRazP4SndBN3AQF5K8dT+IT8iWQt12aqxcX3rWexXuavuGIfA5X6jh8WMjq
         v1T52YKE5cEYgIxuDqQNw7CXQRzW2kyuM+jWsPlJXmONLW1g84lEaRx9VkHPdIltlPtW
         Kghxj0Y1BCYB8yVwgUwu3GkgP58ViBjC47UENH4DdwIXi3ZAWZE2zJDXRZgHkiNN6Emd
         NS3XP5EWgrNymI3EhBk7ndTrNGlYPvpYhBHQaYVgkbsSVyJJfLgaD3PpCEev5BaVcV51
         wloA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CRKPeEVvwbwPyW8PlCLSf72e4jMeIVWoAQn62FQ1RKs=;
        b=opqWxlWaEDtskr/Ql9nx31bUhjyj04kSqQu4yCr1oALTpGw88JYt9V1iKawz/cxtPW
         v/VcCowR44yQe5Pkd0/gE+ZBHRh8/95juTfXTEpAZ/HD3TNR5xcdAidi9+B0zpShsmcZ
         OnxnAQR+cP88DLZufw2HqakHKlwA/eZPWjER5qbAEknlXZJf+bRMXgdlRh3TBYRx2Itm
         1flWKR5jPt8Am8uyaky0PHx5IE9etCVlR6SStW0kaO1Y5xJURolF3QG4So+qabBBCO8r
         c5+6l+dC645rdHCs4MV0S/Ls1hVmdKmYPyx13pgi9Bx+1sLvvCaU1uaaTkit2usX0ZZv
         SxjA==
X-Gm-Message-State: AJcUukfQaUyl1BaWvRYA4Bw4rcscsxP3m0Uylm5YgV2kbF6Fx439Lwpq
        dFyAjD78O2dbKpRcEuQ8TRRQHaHjBhA=
X-Google-Smtp-Source: ALg8bN6ZaL34pkRoQC7/yQrosYaDQOwVsgkb8TE0R/5sRUeARMm09NDViOvxK87/v7U1m1FG6dhbGQ==
X-Received: by 2002:adf:fa83:: with SMTP id h3mr29433192wrr.173.1548071197552;
        Mon, 21 Jan 2019 03:46:37 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id z7sm83189584wrw.22.2019.01.21.03.46.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 03:46:37 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v6 2/5] media: vicodec: use 3 bits for the number of components
Date:   Mon, 21 Jan 2019 03:46:15 -0800
Message-Id: <20190121114618.115282-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190121114618.115282-1-dafna3@gmail.com>
References: <20190121114618.115282-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use 3 bits for the number of components mask in the fwht
header flags

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index 6d230f5e9d60..2984dc772515 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -78,7 +78,7 @@
 #define FWHT_FL_ALPHA_IS_UNCOMPRESSED	BIT(9)
 
 /* A 4-values flag - the number of components - 1 */
-#define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(17, 16)
+#define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(18, 16)
 #define FWHT_FL_COMPONENTS_NUM_OFFSET	16
 
 /*
-- 
2.17.1

