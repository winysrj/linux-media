Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:46769 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754557Ab2EFU4w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 16:56:52 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: linux-media@vger.kernel.org,
	Thomas Mair <thomas.mair86@googlemail.com>
Subject: [PATCH 1/3] fc001x: common header file for FC0012 and FC0013
Date: Sun, 6 May 2012 22:56:50 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205062256.50092.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Common defines for the FC0012 (v0.5) and FC0013 tuner drivers

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

 drivers/media/common/tuners/fc001x-common.h |   39 ++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff -up --new-file --recursive a/drivers/media/common/tuners/fc001x-common.h 
b/drivers/media/common/tuners/fc001x-common.h
--- a/drivers/media/common/tuners/fc001x-common.h	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/media/common/tuners/fc001x-common.h	2012-05-06 19:42:16.785457023 +0200
@@ -0,0 +1,39 @@
+/*
+ * Fitipower FC0012 & FC0013 tuner driver - common defines
+ *
+ * Copyright (C) 2012 Hans-Frieder Vogt <hfvogt@gmx.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _FC001X_COMMON_H_
+#define _FC001X_COMMON_H_
+
+enum fc001x_xtal_freq {
+	FC_XTAL_27_MHZ,		/* 27000000 */
+	FC_XTAL_28_8_MHZ,	/* 28800000 */
+	FC_XTAL_36_MHZ,		/* 36000000 */
+};
+
+/*
+ * enum fc001x_fe_callback_commands - Frontend callbacks
+ *
+ * @FC_FE_CALLBACK_VHF_ENABLE: enable VHF or UHF
+ */
+enum fc001x_fe_callback_commands {
+	FC_FE_CALLBACK_VHF_ENABLE,
+};
+
+#endif

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
