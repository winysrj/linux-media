Return-Path: <SRS0=HJwa=PE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB6C1C43387
	for <linux-media@archiver.kernel.org>; Thu, 27 Dec 2018 13:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3F6521479
	for <linux-media@archiver.kernel.org>; Thu, 27 Dec 2018 13:07:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WTnNERQT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbeL0NHF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 27 Dec 2018 08:07:05 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54541 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbeL0NHE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Dec 2018 08:07:04 -0500
Received: by mail-wm1-f68.google.com with SMTP id a62so16723701wmh.4;
        Thu, 27 Dec 2018 05:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QUT4daLVJspLYfP3LmDn4Juz5nNjvcoscnR5gCLp6Dg=;
        b=WTnNERQTY8eDS0K7gV4ldDsmQZ0nn4MeXnIa+d9WPluaEPdeo1333yDq7fNoKP8o7q
         XB+/PwW2k+1OmNeYCWm/Sle1sT2YMnRW+4YveHmJIdoBhhHh0qbgbd4HT0pm5ienCDqE
         RpcUXr3kbpALqZ748CQV7BBamtaoOTcFp5+MJwARjdratFuDKwvPDDkmBKVC+8zrV4HC
         aj7dri3asYW6t5hkAPamxf5DzJZYqrzF07xy+6zBg3mM/0LYLRwnRkWsG2bBrKCtj8Wx
         gFhRb7KGiwCteEWhceL/Q6QDpbCElNSkfJmugmGtQtllx7RPbyqQJs5UqeAoW3TL3QFf
         BWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QUT4daLVJspLYfP3LmDn4Juz5nNjvcoscnR5gCLp6Dg=;
        b=QvBgyaW7hKMkaMZ2Uz0oNlNW/smv1DXLuYNnb9Ojej2eI1xso/plG7MMmq/ZcZsP76
         wt0CuMTP9jDh82P/JZRvQW+iSCT0ePGtY1jr1sXMzok4yD+wyrOSCU9OpyzvWRKIxXYI
         u+cccLMjhYdZVmIqysEXmZ2zavan2Crj7Rn2xynrdjB8OkOXrHqhzl8GOP3K8+9kGigN
         d415boxeQK8uITw5O69eegGfHzCcccZh4ZwhV2Q7Fs9VYLC3IiVOJlJd3VwR2OF84rWt
         gzRX+Bzj7hptM51ImEZPgYgqix7BUmRI6lOIhW8Z/5DXJH36mu3pPkZuZcFx8eLtejms
         4aug==
X-Gm-Message-State: AJcUukfp/U6k9iDFbw8sqnGY46zusqlZY0S3h9JP+Vu/8P7pZcJjPZRh
        /MlWVp3bKjzraQf3ga2AxGc=
X-Google-Smtp-Source: ALg8bN692iqIurVclzf1jgnxgQMNXl/F/CQ8A57Ixuoy7SZWPJ00idYI3xMVB8P2ryxFGDL2b7uCdA==
X-Received: by 2002:a7b:c0c5:: with SMTP id s5mr22239867wmh.40.1545916021551;
        Thu, 27 Dec 2018 05:07:01 -0800 (PST)
Received: from localhost.localdomain (generic-nat1.unisi.it. [193.205.5.2])
        by smtp.gmail.com with ESMTPSA id f18sm21696905wrs.92.2018.12.27.05.06.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Dec 2018 05:07:00 -0800 (PST)
From:   Ettore Chimenti <ek5.chimenti@gmail.com>
Cc:     hverkuil@xs4all.nl, luca.pisani@udoo.org, jose.abreu@synopsys.com,
        sean@mess.org, sakari.ailus@linux.intel.com,
        Ettore Chimenti <ek5.chimenti@gmail.com>, jacopo@jmondi.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: secocec: fix ir address shift
Date:   Thu, 27 Dec 2018 14:06:35 +0100
Message-Id: <a6d0c6cf16c9a77b25d2747296b74d3344f81f0a.1545915989.git.ek5.chimenti@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The actual value of the RC5 System Number (address) is stored in the
IR_READ_DATA common register masked with 0x1F00 so it have to be shifted
by 8 bits.

Signed-off-by: Ettore Chimenti <ek5.chimenti@gmail.com>
---
 drivers/media/platform/seco-cec/seco-cec.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/seco-cec/seco-cec.h b/drivers/media/platform/seco-cec/seco-cec.h
index e632c4a2a044..843de8c7dfd4 100644
--- a/drivers/media/platform/seco-cec/seco-cec.h
+++ b/drivers/media/platform/seco-cec/seco-cec.h
@@ -106,7 +106,7 @@
 #define SECOCEC_IR_COMMAND_MASK		0x007F
 #define SECOCEC_IR_COMMAND_SHL		0
 #define SECOCEC_IR_ADDRESS_MASK		0x1F00
-#define SECOCEC_IR_ADDRESS_SHL		7
+#define SECOCEC_IR_ADDRESS_SHL		8
 #define SECOCEC_IR_TOGGLE_MASK		0x8000
 #define SECOCEC_IR_TOGGLE_SHL		15
 
-- 
2.20.1

