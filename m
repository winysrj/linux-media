Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2D6C5CFFE
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 23:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F3522082F
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 23:36:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RjSnnbax"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F3522082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbeLJXgG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 18:36:06 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39001 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbeLJXgF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 18:36:05 -0500
Received: by mail-wr1-f65.google.com with SMTP id t27so12229164wra.6;
        Mon, 10 Dec 2018 15:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8frUolhO8+pKt0Tihs8gZLAmLD0ckP+G4QvemMgZ9Kg=;
        b=RjSnnbaxI2hxAIyuaN3NIurKe58Nmop7n9FxnZfFe2/xi+glmzx02T14CGmBFQlBQn
         gpxWQtSVmESgwrYKkEcFXY81WGUaZY4d0h5empwH7PxOmBDNAF8PEItzFLThjlUI41qf
         9Kf/Ao6ALUkn1F1aYYVFgtkhrr/N0ORhaX7iysNo1yalaDNmFwnXXuf9n2Cae3ZbQtoa
         wazPxmFSH9UGOeAwhno1/9xZMcuOOBXc4owXgdc/8GMoj9OjEy2N2r4D8cyR3QjoGGf2
         Ia9TU11EENB9V9CemvfgHI6LdsgnsaEKa0d1VHEHLUZHrC0n1CmS+uXleN8uVmWNYsNP
         CqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8frUolhO8+pKt0Tihs8gZLAmLD0ckP+G4QvemMgZ9Kg=;
        b=DXWlU8De4L+3Y+GA3q4xEbJV5Tbg7OV6B9ndK1EYp68ay0zg08rPHFlY5FoSA1jO9i
         aVtoED2+6D8jWJexMljVmY3ZyVeZPviETKVyMXpKHrfLvjbLTBDbB0hANaVeTV+zn1Wj
         McZmoMTb/4j1mYZH2jZ8dgh5jGBbcT3YY8KL9+SXqgJ8Hg7ZRsZz8UMFuB3lla8oopRz
         RvfEpzV+AxLbg2nnVGZR4kM3903ILzRgicnBxj4hxbLgYU4KoB5AumIyjYZWjT16Qy/j
         XDfPgR2pkx80Wlso4URwp04IFmiTl915o9RnvvSjhMrwwtB4BwihWL9toUaryq9baInL
         X8DA==
X-Gm-Message-State: AA+aEWZ33p75VYsk6dRwUU0r0gU8q3Brg59XhK/rbNxKHSTmDkEkygPh
        ZeFZ17n2RJS8LTkqJ/mKzXY=
X-Google-Smtp-Source: AFSGD/XCgaKCtAeD47R6589diUzd7nMFh5ziHdxmFrTDdO7cnaw/itEQfbrEDc/7+Gi6lhqbObr5dA==
X-Received: by 2002:adf:a14d:: with SMTP id r13mr11080524wrr.169.1544484963190;
        Mon, 10 Dec 2018 15:36:03 -0800 (PST)
Received: from localhost.localdomain ([2a01:4f8:10b:24a5::2])
        by smtp.gmail.com with ESMTPSA id o81sm575957wmd.10.2018.12.10.15.36.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Dec 2018 15:36:02 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] media: ddbridge: Move asm includes after linux ones
Date:   Mon, 10 Dec 2018 16:35:14 -0700
Message-Id: <20181210233514.3069-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Without this, cpumask_t and bool are not defined:

In file included from drivers/media/pci/ddbridge/ddbridge-ci.c:19:
In file included from drivers/media/pci/ddbridge/ddbridge.h:22:
./arch/arm/include/asm/irq.h:35:50: error: unknown type name 'cpumask_t'
extern void arch_trigger_cpumask_backtrace(const cpumask_t *mask,
                                                 ^
./arch/arm/include/asm/irq.h:36:9: error: unknown type name 'bool'
                                           bool exclude_self);
                                           ^

Doing a survey of the kernel tree, this appears to be expected because
'#include <asm/irq.h>' is always after the linux includes.

This also fixes warnings of this variety (with Clang):

In file included from drivers/media/pci/ddbridge/ddbridge-ci.c:19:
In file included from drivers/media/pci/ddbridge/ddbridge.h:56:
In file included from ./include/media/dvb_net.h:22:
In file included from ./include/linux/netdevice.h:50:
In file included from ./include/uapi/linux/neighbour.h:6:
In file included from ./include/linux/netlink.h:9:
In file included from ./include/net/scm.h:11:
In file included from ./include/linux/sched/signal.h:6:
./include/linux/signal.h:87:11: warning: array index 3 is past the end
of the array (which contains 2 elements) [-Warray-bounds]
                return (set->sig[3] | set->sig[2] |
                        ^        ~
./arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
        unsigned long sig[_NSIG_WORDS];
        ^

Fixes: b6973637c4cc ("media: ddbridge: remove another duplicate of io.h and sort includes")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/media/pci/ddbridge/ddbridge.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 0be6ed216e65..b834449e78f8 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -18,9 +18,6 @@
 #ifndef _DDBRIDGE_H_
 #define _DDBRIDGE_H_
 
-#include <asm/dma.h>
-#include <asm/irq.h>
-
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
@@ -48,6 +45,9 @@
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
 
+#include <asm/dma.h>
+#include <asm/irq.h>
+
 #include <media/dmxdev.h>
 #include <media/dvb_ca_en50221.h>
 #include <media/dvb_demux.h>
-- 
2.20.0

