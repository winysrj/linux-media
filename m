Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3EC0C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 19:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B33B7217F9
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 19:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbfBEThg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 14:37:36 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:37885 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfBEThg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 14:37:36 -0500
X-Originating-IP: 81.164.19.127
Received: from uno.localdomain (d51A4137F.access.telenet.be [81.164.19.127])
        (Authenticated sender: jacopo@jmondi.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 748CA1C0002;
        Tue,  5 Feb 2019 19:37:31 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     hverkuil@xs4all.nl, mchehab@kernel.org, linux-media@vger.kernel.org
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sh: migor: Include missing dma-mapping header
Date:   Tue,  5 Feb 2019 20:37:42 +0100
Message-Id: <20190205193742.24940-1-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Since the removal of the stale soc_camera headers, Migo-R board fails to
build due to missing dma-mapping include directive.

Include missing dma-mapping.h header in Migo-R board file to fix the build
error.

Fixes: a50c7738e8ae ("media: sh: migor: Remove stale soc_camera include")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
Hans pointed me to this error quite some time ago, but it took me a kbuild
error to address this. Sorry for the delay.

Again, should this go through media as this is caused by soc_camera related
churn?

Thanks
  j

---
 arch/sh/boards/mach-migor/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index f4ad33c6d2aa..1d2993bdd231 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2008 Magnus Damm
  */
 #include <linux/clkdev.h>
+#include <linux/dma-mapping.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
--
2.20.1

