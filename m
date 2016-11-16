Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49650 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753719AbcKPQnO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:14 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 27/35] [media] v4l2-common: add a debug macro to be used with dev_foo()
Date: Wed, 16 Nov 2016 14:42:59 -0200
Message-Id: <bd33aafcefabffc59f7750afb0251fdd94c28a88.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, there's a mess at the V4L2 printk macros: some drivers
use their own macros, others use pr_foo() or v4l_foo() macros,
while more modern drivers use dev_foo() macros.

The best is to get rid of v4l_foo() macros, as they can be
replaced by either dev_foo() or pr_foo(). Yet, such change can
be disruptive, as dev_foo() cannot use KERN_CONT. So, the best
is to do such change driver by driver.

There are replacements for most v4l_foo() macros, but it lacks
a way to enable debug messages per level. So, add such macro,
in order to make the conversion easier.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-common.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 350cbf9fb10e..aac8b7b6e691 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -55,6 +55,13 @@
 			v4l_client_printk(KERN_DEBUG, client, fmt , ## arg); \
 	} while (0)
 
+/* Add a version of v4l_dbg to be used on drivers using dev_foo() macros */
+#define dev_dbg_lvl(__dev, __level, __debug, __fmt, __arg...)		\
+	do {								\
+		if (__debug >= (__level))				\
+			dev_printk(KERN_DEBUG, __dev, __fmt, ##__arg);	\
+	} while (0)
+
 /* ------------------------------------------------------------------------- */
 
 /* These printk constructs can be used with v4l2_device and v4l2_subdev */
-- 
2.7.4


