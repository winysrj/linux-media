Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50156 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752961AbeBVJrv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 04:47:51 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 3/3] MAINTAINERS: Add entry for Techwell TW9910
Date: Thu, 22 Feb 2018 10:47:19 +0100
Message-Id: <1519292839-7028-4-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519292839-7028-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519292839-7028-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add entry for Techwell TW9910 video decoder. The driver is currently
orphaned.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 64b8cd4..da1a88d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13391,6 +13391,12 @@ L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/rc/ttusbir.c
 
+TECHWELL TW9910 VIDEO DECODER
+L:	linux-media@vger.kernel.org
+S:	Orphan
+F:	drivers/media/i2c/tw9910.c
+F:	include/media/i2c/tw9910.h
+
 TEE SUBSYSTEM
 M:	Jens Wiklander <jens.wiklander@linaro.org>
 S:	Maintained
-- 
2.7.4
