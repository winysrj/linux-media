Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35954 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755344AbdBGQlz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 11:41:55 -0500
Received: by mail-wm0-f42.google.com with SMTP id c85so168574221wmi.1
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 08:41:54 -0800 (PST)
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Kevin Hilman <khilman@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 07/10] ARM: davinci: fix a whitespace error
Date: Tue,  7 Feb 2017 17:41:20 +0100
Message-Id: <1486485683-11427-8-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a stray tab in da850_vpif_legacy_init(). Remove it.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 arch/arm/mach-davinci/pdata-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-davinci/pdata-quirks.c b/arch/arm/mach-davinci/pdata-quirks.c
index a186513..94948c1 100644
--- a/arch/arm/mach-davinci/pdata-quirks.c
+++ b/arch/arm/mach-davinci/pdata-quirks.c
@@ -111,7 +111,7 @@ static struct vpif_capture_config da850_vpif_capture_config = {
 static void __init da850_vpif_legacy_init(void)
 {
 	int ret;
-	
+
 	/* LCDK doesn't have the 2nd TVP514x on CH1 */
 	if (of_machine_is_compatible("ti,da850-lcdk"))
 		da850_vpif_capture_config.subdev_count = 1;
-- 
2.9.3

