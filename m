Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52465 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752961AbeBVJrs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 04:47:48 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 2/3] MAINTAINERS: Add entry for Omnivision OV772x
Date: Thu, 22 Feb 2018 10:47:18 +0100
Message-Id: <1519292839-7028-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519292839-7028-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519292839-7028-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add entry for Omnivision OV772x image sensor listing myself as maintainer
for 'Odd fixes' only, as I currently have access to a platform for
testing.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index de0d4c6..64b8cd4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10071,6 +10071,14 @@ S:	Maintained
 F:	drivers/media/i2c/ov7670.c
 F:	Documentation/devicetree/bindings/media/i2c/ov7670.txt
 
+OMNIVISION OV772x SENSOR DRIVER
+M:	Jacopo Mondi <jacopo@jmondi.org>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Odd fixes
+F:	drivers/media/i2c/ov772x.c
+F:	include/media/i2c/ov772x.h
+
 OMNIVISION OV7740 SENSOR DRIVER
 M:	Wenyou Yang <wenyou.yang@microchip.com>
 L:	linux-media@vger.kernel.org
-- 
2.7.4
