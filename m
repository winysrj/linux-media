Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57245 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966813AbeCBQge (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 11:36:34 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        sakari.ailus@iki.fi, mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] media: MAINTAINERS: Add entry for Aptina MT9T112
Date: Fri,  2 Mar 2018 17:35:41 +0100
Message-Id: <1520008541-3961-6-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1520008541-3961-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1520008541-3961-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add entry for Aptina/Micron MT9T112 camera sensor. The driver is
currently orphaned.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 91ed6ad..1d8be25 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9385,6 +9385,13 @@ S:	Maintained
 F:	drivers/media/i2c/mt9t001.c
 F:	include/media/i2c/mt9t001.h
 
+MT9T112 APTINA CAMERA SENSOR
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Orphan
+F:	drivers/media/i2c/mt9t112.c
+F:	include/media/i2c/mt9t112.h
+
 MT9V032 APTINA CAMERA SENSOR
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
-- 
2.7.4
