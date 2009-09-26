Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:52035 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbZIZN3P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2009 09:29:15 -0400
Received: from localhost (localhost [127.0.0.1])
	by bamako.nerim.net (Postfix) with ESMTP id 9794339DE69
	for <linux-media@vger.kernel.org>; Sat, 26 Sep 2009 15:29:16 +0200 (CEST)
Received: from bamako.nerim.net ([127.0.0.1])
	by localhost (bamako.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rPwcJ6oU-7Cl for <linux-media@vger.kernel.org>;
	Sat, 26 Sep 2009 15:29:15 +0200 (CEST)
Received: from hyperion.delvare (jdelvare.pck.nerim.net [62.212.121.182])
	by bamako.nerim.net (Postfix) with ESMTP id A90AB39DCD1
	for <linux-media@vger.kernel.org>; Sat, 26 Sep 2009 15:29:15 +0200 (CEST)
Date: Sat, 26 Sep 2009 15:29:17 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] Fix adv7180 build failures with old kernels
Message-ID: <20090926152917.38d9c347@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The adv7180 driver is a new-style i2c driver, unconditionally using
struct i2c_device_id. As such, it can't be built on kernels older than
2.6.26.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 v4l/versions.txt |    1 +
 1 file changed, 1 insertion(+)

--- v4l-dvb.orig/v4l/versions.txt	2009-09-26 13:10:09.000000000 +0200
+++ v4l-dvb/v4l/versions.txt	2009-09-26 14:37:43.000000000 +0200
@@ -38,6 +38,7 @@ SOC_CAMERA_PLATFORM
 [2.6.26]
 # Requires struct i2c_device_id
 VIDEO_TVP514X
+VIDEO_ADV7180
 # requires id_table and new i2c stuff
 RADIO_TEA5764
 VIDEO_THS7303


-- 
Jean Delvare
