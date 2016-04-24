Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34151 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbcDXVKT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:19 -0400
Received: by mail-wm0-f65.google.com with SMTP id n3so20027752wmn.1
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:19 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: [RFC PATCH 05/24] smiapp: Add smiapp_has_quirk() to tell whether a quirk is implemented
Date: Mon, 25 Apr 2016 00:08:05 +0300
Message-Id: <1461532104-24032-6-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-quirk.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.h b/drivers/media/i2c/smiapp/smiapp-quirk.h
index dac5566..209818f 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.h
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.h
@@ -72,9 +72,12 @@ void smiapp_replace_limit(struct smiapp_sensor *sensor,
 		.val = _val,		\
 	}
 
+#define smiapp_has_quirk(sensor, _quirk)	\
+	((sensor)->minfo.quirk &&		\
+	 (sensor)->minfo.quirk->_quirk)
+
 #define smiapp_call_quirk(sensor, _quirk, ...)				\
-	((sensor)->minfo.quirk &&					\
-	 (sensor)->minfo.quirk->_quirk ?				\
+	(smiapp_has_quirk(sensor, _quirk) ?				\
 	 (sensor)->minfo.quirk->_quirk(sensor, ##__VA_ARGS__) : 0)
 
 #define smiapp_needs_quirk(sensor, _quirk)		\
-- 
1.9.1

