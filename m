Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:43377 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932377AbeCLOMf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 10:12:35 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        sakari.ailus@iki.fi, mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] media: MAINTAINERS: Add entry for Aptina MT9T112
Date: Mon, 12 Mar 2018 14:43:05 +0100
Message-Id: <1520862185-17150-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1520862185-17150-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1520862185-17150-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add entry for Aptina/Micron MT9T112 camera sensor. The driver is
maintained by me for "Odd Fixes" only due to lack of suitable hardware
for testing.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 91ed6ad..ed95cad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9385,6 +9385,14 @@ S:	Maintained
 F:	drivers/media/i2c/mt9t001.c
 F:	include/media/i2c/mt9t001.h
 
+MT9T112 APTINA CAMERA SENSOR
+M:	Jacopo Mondi <jacopo@jmondi.org>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Odd Fixes
+F:	drivers/media/i2c/mt9t112.c
+F:	include/media/i2c/mt9t112.h
+
 MT9V032 APTINA CAMERA SENSOR
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
-- 
2.7.4
