Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:43109 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab2KSOis (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 09:38:48 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] Add MAINTAINERS entries for some RC devices
Date: Mon, 19 Nov 2012 14:32:53 +0000
Message-Id: <1353335573-27228-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 MAINTAINERS |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f4b3aa8..1a69d21 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3751,6 +3751,12 @@ F:	net/ieee802154/
 F:	net/mac802154/
 F:	drivers/ieee802154/
 
+IGUANAWORKS USB IR TRANSCEIVER
+M:	Sean Young <sean@mess.org>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/rc/iguanair.c
+
 IIO SUBSYSTEM AND DRIVERS
 M:	Jonathan Cameron <jic23@cam.ac.uk>
 L:	linux-iio@vger.kernel.org
@@ -7256,6 +7262,12 @@ S:	Supported
 F:	drivers/net/team/
 F:	include/linux/if_team.h
 
+TECHNOTREND USB IR RECEIVER
+M:	Sean Young <sean@mess.org>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/rc/ttusbir.c
+
 TEGRA SUPPORT
 M:	Stephen Warren <swarren@wwwdotorg.org>
 L:	linux-tegra@vger.kernel.org
-- 
1.7.2.5

