Return-Path: <SRS0=jH9h=P3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0D0C61CE8
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 12:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5D862086A
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 12:02:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MjPqic2A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfASMCL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 19 Jan 2019 07:02:11 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37900 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfASMCK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Jan 2019 07:02:10 -0500
Received: by mail-wr1-f65.google.com with SMTP id v13so18140764wrw.5
        for <linux-media@vger.kernel.org>; Sat, 19 Jan 2019 04:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CRKPeEVvwbwPyW8PlCLSf72e4jMeIVWoAQn62FQ1RKs=;
        b=MjPqic2A1DdF4TOUqaXwQQvE8QQzM7o+jNpfWWAMoZOHLsxR4q72qQ04PSYyalN7Gt
         SyRFeUGSZxSMCL2QZnEdWyE60vxmaOp2ypdo8XZelzPncvmLuUuTWnRfBzlXLw4WTEz9
         P14FOmKiLFjNKSIblweEE4gaACBVZ3/b2wpjlMDig3RdC3VlbjiH0/uEsX1EkWG1GMJ5
         cW6LAWkp4LTfz3aabKHwu90/jVwSfp0+ake+zlt8RIpl5HqdHDtZhE1sbBoDpTvjmol1
         44IyG5AJCoTZ8KVvj4OYK1ifsFPBDS/2s7ebQhVj5CcYBs0tITN91qJAPmyVxoltSunn
         qdXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CRKPeEVvwbwPyW8PlCLSf72e4jMeIVWoAQn62FQ1RKs=;
        b=Zp9jLDtZme5CkKVQhYKDweNc36Ucg98BjxdEvtN4T0cffzyTzC6P4VDqiZBOmQaUnP
         HsyN0DPkCms0PrF/ZLEMk8L9JcgADaISFFpjDIlEIQM24jRYYI53TVXaYmWa+4iGc39w
         Vg/s9fsOz34okUe2ykRQZjvB7oLFZArNJHTtuPRqWQzNxnz0Pm0poEh8lu2c2Drg6rRm
         tWv8T611HdnpJ0OG76XqvfQxOGzuVDyg5mXMdMy0sLCzOgqzevXUzAu4T+v7xZ1jShU5
         QUpk1FgiECy39M+OBVB48raTW6fvkeY6wuMGSsbclLA/X0HFiNZq/uzGb0ONCqnM4aAj
         3mfg==
X-Gm-Message-State: AJcUukf9whYEVgtyhmDXc7IpxNrmGtf75hVK1wlPzaX4LeERKu/1P7vI
        fBCQHZFXVl3WMF/Z5Il4UeMBlfLJsII=
X-Google-Smtp-Source: ALg8bN7pCWfR4pH4J1dNhMIOUQdsfnISN0c/ZmuNoBfY/Cth3tvqj3sMDeMfTDEBiAkoOM1eZzzH2A==
X-Received: by 2002:adf:83a7:: with SMTP id 36mr20487226wre.13.1547899328916;
        Sat, 19 Jan 2019 04:02:08 -0800 (PST)
Received: from localhost.localdomain ([87.71.51.33])
        by smtp.gmail.com with ESMTPSA id e27sm95011131wra.67.2019.01.19.04.02.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Jan 2019 04:02:07 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 3/6] media: vicodec: use 3 bits for the number of components
Date:   Sat, 19 Jan 2019 04:01:53 -0800
Message-Id: <20190119120156.15851-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190119120156.15851-1-dafna3@gmail.com>
References: <20190119120156.15851-1-dafna3@gmail.com>
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

