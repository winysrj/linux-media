Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44092 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab2ABU1W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 15:27:22 -0500
Received: by wgbdr13 with SMTP id dr13so26951865wgb.1
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 12:27:21 -0800 (PST)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH] libv4l: add hflip quirk for dealextreme cam sku #44507
Date: Mon,  2 Jan 2012 23:25:01 +0300
Message-Id: <1325535901-15251-1-git-send-email-anarsoul@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 lib/libv4lconvert/control/libv4lcontrol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
index 12fa874..a9908ac 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -51,6 +51,8 @@ static const struct v4lcontrol_flags_info v4lcontrol_flags[] = {
 	/* Genius E-M 112 (also want whitebalance by default) */
 	{ 0x093a, 0x2476, 0, NULL, NULL,
 		V4LCONTROL_HFLIPPED|V4LCONTROL_VFLIPPED | V4LCONTROL_WANTS_WB, 1500 },
+	/* uvc-compatible cam from dealextreme (sku #44507) */
+	{ 0x18ec, 0x3366, 0, NULL, NULL, V4LCONTROL_HFLIPPED },
 
 	/* Laptops (and all in one PC's) */
 	{ 0x0402, 0x5606, 0,
-- 
1.7.8.1

