Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F54C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB62E206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:05:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="keF49SW8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB62E206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbeLEKFR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:05:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49326 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728140AbeLEKFQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 05:05:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+mxfzg6UhPtWrtB97+lllG3nfhF1XlTbTaSfdDfLjpw=; b=keF49SW8BkEGgL0BwowJ9RPiA
        j1eTI9ENCwrKR6gUygkh4NeDd3DWnhU92ZPKMLUZWT22VKnwaffeEOYzlyUshObjVRBWcJ5hyCYnB
        PvSIziqZbKFo8xgNeLHpoK4kTGdtMmkMs9cVpVkOmPRjv/NDv817/WWtmv+COShrR2CDy7Ex4lJNV
        cXoWoNu2ikoRZlfLTMFyCNF1asAgcX8AfQz1nlz+PWG9bId09mSWtQPV927EmHECZtyA8k8gC0l9Q
        aTgoCHPD4RmKD/HkPn/DfvVRWPqLs7rf3+mXUtaIndYM95dlnOGY8xVRdTcF9HOwOFxgefnX29R73
        mwAL0h0Yw==;
Received: from [191.33.148.129] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUU3N-0004uh-Jl; Wed, 05 Dec 2018 10:05:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gUU3K-0003Jt-GZ; Wed, 05 Dec 2018 05:05:10 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Daniel Scheller <d.scheller@gmx.net>,
        zhong jiang <zhongjiang@huawei.com>,
        Jasmin Jessich <jasmin@anw.at>
Subject: [PATCH] media: ddbridge: remove another duplicate of io.h and sort includes
Date:   Wed,  5 Dec 2018 05:05:09 -0500
Message-Id: <b6973637c4cc842c1aa7d6c848781b4bdeb4415b.1544004305.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The io.h was still included twice. Having a large number of
includes like that unsorted is likely the reason why we ended
by having 3 includes of io.h and two includes of interrupt.h
at the first place.

So, let's reorder the includes on alphabetic order. That would
make easier to maintain it.

Fixes: 12645e0655e4 ("media: ddbridge: remove some duplicated include file")
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/pci/ddbridge/ddbridge.h | 52 +++++++++++++--------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 27b46fe704cd..0be6ed216e65 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -18,45 +18,43 @@
 #ifndef _DDBRIDGE_H_
 #define _DDBRIDGE_H_
 
-#include <linux/module.h>
-#include <linux/init.h>
+#include <asm/dma.h>
+#include <asm/irq.h>
+
+#include <linux/clk.h>
+#include <linux/completion.h>
 #include <linux/delay.h>
-#include <linux/slab.h>
-#include <linux/poll.h>
-#include <linux/pci.h>
-#include <linux/timer.h>
+#include <linux/device.h>
+#include <linux/dvb/ca.h>
+#include <linux/gpio.h>
 #include <linux/i2c.h>
-#include <linux/swab.h>
-#include <linux/vmalloc.h>
-#include <linux/workqueue.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
 #include <linux/platform_device.h>
-#include <linux/clk.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/socket.h>
 #include <linux/spi/spi.h>
-#include <linux/gpio.h>
-#include <linux/completion.h>
-
+#include <linux/swab.h>
+#include <linux/timer.h>
 #include <linux/types.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/mutex.h>
-#include <asm/dma.h>
-#include <asm/irq.h>
-#include <linux/io.h>
 #include <linux/uaccess.h>
-
-#include <linux/dvb/ca.h>
-#include <linux/socket.h>
-#include <linux/device.h>
-#include <linux/io.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 
 #include <media/dmxdev.h>
-#include <media/dvbdev.h>
+#include <media/dvb_ca_en50221.h>
 #include <media/dvb_demux.h>
+#include <media/dvbdev.h>
 #include <media/dvb_frontend.h>
-#include <media/dvb_ringbuffer.h>
-#include <media/dvb_ca_en50221.h>
 #include <media/dvb_net.h>
+#include <media/dvb_ringbuffer.h>
 
 #define DDBRIDGE_VERSION "0.9.33-integrated"
 
-- 
2.19.1

