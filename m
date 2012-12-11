Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51452 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2LKAhU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 19:37:20 -0500
Received: from avalon.ideasonboard.com (unknown [91.178.169.86])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7312035A87
	for <linux-media@vger.kernel.org>; Tue, 11 Dec 2012 01:37:19 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] MAINTAINERS: Add an entry for the ad3645a LED flash controller driver
Date: Tue, 11 Dec 2012 01:38:24 +0100
Message-Id: <1355186304-17399-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1355186304-17399-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1355186304-17399-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d4b699b..47678e4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1258,6 +1258,14 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm64/
 
+AS3645A LED FLASH CONTROLLER DRIVER
+M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/as3645a.c
+F:	include/media/as3645a.h
+
 ASC7621 HARDWARE MONITOR DRIVER
 M:	George Joseph <george.joseph@fairview5.com>
 L:	lm-sensors@lm-sensors.org
-- 
1.7.8.6

