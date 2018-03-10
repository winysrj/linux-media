Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43168 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751193AbeCJRTt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Mar 2018 12:19:49 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: i2c: mt9t112: Add TODO note for frame rate control
Date: Sat, 10 Mar 2018 18:19:35 +0100
Message-Id: <1520702375-29671-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver lacks support for frame rate control, and v4l2-compliance
complains about that. Add a TODO note to warn driver users that this is
expected.

While at there, update copyright note to the year we're actually in.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/mt9t112.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9t112.c b/drivers/media/i2c/mt9t112.c
index 6eaf3c6..f237d85 100644
--- a/drivers/media/i2c/mt9t112.c
+++ b/drivers/media/i2c/mt9t112.c
@@ -2,7 +2,7 @@
 /*
  * mt9t112 Camera Driver
  *
- * Copyright (C) 2017 Jacopo Mondi <jacopo+renesas@jmondi.org>
+ * Copyright (C) 2018 Jacopo Mondi <jacopo+renesas@jmondi.org>
  *
  * Copyright (C) 2009 Renesas Solutions Corp.
  * Kuninori Morimoto <morimoto.kuninori@renesas.com>
@@ -14,6 +14,10 @@
  * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
  * Copyright (C) 2008 Magnus Damm
  * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ *
+ * TODO: This driver lacks support for frame rate control due to missing
+ * 	 register level documentation and suitable hardware for testing.
+ * 	 v4l-utils compliance tools will report errors.
  */

 #include <linux/clk.h>
--
2.7.4
