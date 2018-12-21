Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE54FC43612
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 827B021904
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545355214;
	bh=60JBschBnEvvqxiCWtKKuHoiVCFr+2AQqWWXEfD6i/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nn+LZbrQ4vSxIjKsmNTbh6veR/KhSyaF6ALtELVPZOWY31+rQWraBhSv+zLeR9JP/
	 Jf0BjM0kRTA+Ud562cVJGfpBtMV3OlBt0LqVQJcgSgK0rGnDZm0eBs28b4zc2aETO7
	 16vFlLBGoG14HHjJqTU9r2X4KYw+NcjHD8XyNmeE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388596AbeLUBSN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 20:18:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387963AbeLUBSL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 20:18:11 -0500
Received: from mail.kernel.org (unknown [185.216.33.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73E4D218E0;
        Fri, 21 Dec 2018 01:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545355091;
        bh=60JBschBnEvvqxiCWtKKuHoiVCFr+2AQqWWXEfD6i/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rt4arJHU5TBy5N1isrBVy+FTDnleGxO5DBAqbkFqSF50NhyfOH8iAoZOWxXmr3eHS
         NOQkPwpyrS8ulKgxFwMr9snrXN3lzsauYe0I3C3AdHWsveNDG+JHoWIzZJJNn7ZcnH
         S9JpIH1sNlXcedO7wH7FqZCUwF4FJ/+onHc6yxwc=
From:   Sebastian Reichel <sre@kernel.org>
To:     Sebastian Reichel <sre@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>
Cc:     Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-bluetooth@vger.kernel.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH 02/14] ARM: dts: IGEP: Add WiLink UART node
Date:   Fri, 21 Dec 2018 02:17:40 +0100
Message-Id: <20181221011752.25627-3-sre@kernel.org>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181221011752.25627-1-sre@kernel.org>
References: <20181221011752.25627-1-sre@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Sebastian Reichel <sebastian.reichel@collabora.com>

Add a node for the UART part of WiLink chip.

Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
This is compile tested only!
---
 arch/arm/boot/dts/omap3-igep0020-rev-f.dts | 8 ++++++++
 arch/arm/boot/dts/omap3-igep0030-rev-g.dts | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-igep0020-rev-f.dts b/arch/arm/boot/dts/omap3-igep0020-rev-f.dts
index 285681d7af49..8bb4298ca05e 100644
--- a/arch/arm/boot/dts/omap3-igep0020-rev-f.dts
+++ b/arch/arm/boot/dts/omap3-igep0020-rev-f.dts
@@ -52,3 +52,11 @@
 		interrupts = <17 IRQ_TYPE_EDGE_RISING>; /* gpio 177 */
 	};
 };
+
+&uart2 {
+	bluetooth {
+		compatible = "ti,wl1835-st";
+		enable-gpios = <&gpio5 9 GPIO_ACTIVE_HIGH>; /* gpio 137 */
+		max-speed = <300000>;
+	};
+};
diff --git a/arch/arm/boot/dts/omap3-igep0030-rev-g.dts b/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
index 1adc73bd2ca0..03be171e9de7 100644
--- a/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
+++ b/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
@@ -74,3 +74,11 @@
 		interrupts = <8 IRQ_TYPE_EDGE_RISING>; /* gpio 136 */
 	};
 };
+
+&uart2 {
+	bluetooth {
+		compatible = "ti,wl1835-st";
+		enable-gpios = <&gpio5 9 GPIO_ACTIVE_HIGH>; /* gpio 137 */
+		max-speed = <300000>;
+	};
+};
-- 
2.19.2

