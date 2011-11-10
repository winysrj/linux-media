Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54266 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab1KJXe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 18:34:57 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3520899iag.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 15:34:56 -0800 (PST)
From: Patrick Dickey <pdickeybeta@gmail.com>
To: linux-media@vger.kernel.org
Cc: Patrick Dickey <pdickeybeta@gmail.com>
Subject: [PATCH 07/25] added drx39xxj header for pctv80e support
Date: Thu, 10 Nov 2011 17:31:27 -0600
Message-Id: <1320967905-7932-8-git-send-email-pdickeybeta@gmail.com>
In-Reply-To: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/dvb/frontends/drx39xxj.h |   40 ++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/drx39xxj.h

diff --git a/drivers/media/dvb/frontends/drx39xxj.h b/drivers/media/dvb/frontends/drx39xxj.h
new file mode 100644
index 0000000..168d251
--- /dev/null
+++ b/drivers/media/dvb/frontends/drx39xxj.h
@@ -0,0 +1,40 @@
+/*
+ *  Driver for Micronas DRX39xx family (drx3933j)
+ *
+ *  Written by Devin Heitmueller <devin.heitmueller@kernellabs.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=
+ */
+
+#ifndef DRX39XXJ_H
+#define DRX39XXJ_H
+
+#include <linux/dvb/frontend.h>
+#include "dvb_frontend.h"
+#include "drx_driver.h"
+
+struct drx39xxj_state {
+	struct i2c_adapter *i2c;
+	DRXDemodInstance_t *demod;
+	DRXStandard_t current_standard;
+	struct dvb_frontend frontend;
+	int powered_up:1;
+	unsigned int i2c_gate_open:1;
+};
+
+extern struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c);
+
+#endif // DRX39XXJ_H
-- 
1.7.5.4

