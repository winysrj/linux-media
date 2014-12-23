Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39025 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbaLWVTC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 16:19:02 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Thomas Mair <thomas.mair86@gmail.com>
Subject: [PATCH 52/66] rtl2832: claim copyright and module author
Date: Tue, 23 Dec 2014 22:49:45 +0200
Message-Id: <1419367799-14263-52-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have implemented tons of things for that driver, more than anyone
else, so lets claim copyright and module authorship.

Cc: Thomas Mair <thomas.mair86@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 2 ++
 drivers/media/dvb-frontends/rtl2832.h      | 1 +
 drivers/media/dvb-frontends/rtl2832_priv.h | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index a552b4b..70fdce4 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -2,6 +2,7 @@
  * Realtek RTL2832 DVB-T demodulator driver
  *
  * Copyright (C) 2012 Thomas Mair <thomas.mair86@gmail.com>
+ * Copyright (C) 2012-2014 Antti Palosaari <crope@iki.fi>
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License as published by
@@ -1304,5 +1305,6 @@ static struct i2c_driver rtl2832_driver = {
 module_i2c_driver(rtl2832_driver);
 
 MODULE_AUTHOR("Thomas Mair <mair.thomas86@gmail.com>");
+MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Realtek RTL2832 DVB-T demodulator driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index 73e2717..e5f67cf 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -2,6 +2,7 @@
  * Realtek RTL2832 DVB-T demodulator driver
  *
  * Copyright (C) 2012 Thomas Mair <thomas.mair86@gmail.com>
+ * Copyright (C) 2012-2014 Antti Palosaari <crope@iki.fi>
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 9edab5d..e25d748 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -2,6 +2,7 @@
  * Realtek RTL2832 DVB-T demodulator driver
  *
  * Copyright (C) 2012 Thomas Mair <thomas.mair86@gmail.com>
+ * Copyright (C) 2012-2014 Antti Palosaari <crope@iki.fi>
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License as published by
-- 
http://palosaari.fi/

