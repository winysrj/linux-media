Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C25BC43444
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 14:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1839218A4
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 14:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbeLRONA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 09:13:00 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55383 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbeLRONA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 09:13:00 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gZG7D-0003xP-FE; Tue, 18 Dec 2018 15:12:55 +0100
Received: from mfe by dude.hi.pengutronix.de with local (Exim 4.91)
        (envelope-from <mfe@pengutronix.de>)
        id 1gZG7D-0002il-61; Tue, 18 Dec 2018 15:12:55 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        graphics@pengutronix.de
Subject: [PATCH 3/3] media: tc358746: update MAINTAINERS file
Date:   Tue, 18 Dec 2018 15:12:40 +0100
Message-Id: <20181218141240.3056-4-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181218141240.3056-1-m.felsch@pengutronix.de>
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add me as partial maintainer, others are welcome too.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 546f8d936589..f97dedbe545c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15230,6 +15230,13 @@ S:	Maintained
 F:	drivers/media/i2c/tc358743*
 F:	include/media/i2c/tc358743.h
 
+TOSHIBA TC358746 DRIVER
+M:	Marco Felsch <kernel@pengutronix.de>
+L:	linux-media@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/media/i2c/tc358746*
+F:	Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
+
 TOSHIBA WMI HOTKEYS DRIVER
 M:	Azael Avalos <coproscefalo@gmail.com>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.19.1

