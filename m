Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:58015 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934075AbeGDKQU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 06:16:20 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, mchehab@kernel.org, ysato@users.sourceforge.jp,
        dalias@libc.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] sh: migor: Remove stale soc_camera include
Date: Wed,  4 Jul 2018 12:15:46 +0200
Message-Id: <1530699346-3235-10-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1530699346-3235-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1530699346-3235-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove a stale inclusion for the soc_camera header.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 arch/sh/boards/mach-migor/setup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 26543cc..254f2c6 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -28,7 +28,6 @@
 #include <video/sh_mobile_lcdc.h>
 #include <media/drv-intf/renesas-ceu.h>
 #include <media/i2c/ov772x.h>
-#include <media/soc_camera.h>
 #include <media/i2c/tw9910.h>
 #include <asm/clock.h>
 #include <asm/machvec.h>
-- 
2.7.4
