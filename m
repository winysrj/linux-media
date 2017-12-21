Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64294 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751655AbdLUQSW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 11:18:22 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>
Subject: [PATCH 11/11] media: dvb_vb2: add SPDX headers
Date: Thu, 21 Dec 2017 14:18:10 -0200
Message-Id: <2252209414e0d59b71973984ea5da4eb2440d8d0.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This code is released under GPL. Add the corresponding SPDX
headers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_vb2.c | 1 +
 drivers/media/dvb-core/dvb_vb2.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index 7b1663f64e84..10d8f627af3a 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL
 /*
  * dvb-vb2.c - dvb-vb2
  *
diff --git a/drivers/media/dvb-core/dvb_vb2.h b/drivers/media/dvb-core/dvb_vb2.h
index d68653926d91..a5164effee16 100644
--- a/drivers/media/dvb-core/dvb_vb2.h
+++ b/drivers/media/dvb-core/dvb_vb2.h
@@ -1,4 +1,6 @@
 /*
+ * SPDX-License-Identifier: GPL
+ *
  * dvb-vb2.h - DVB driver helper framework for streaming I/O
  *
  * Copyright (C) 2015 Samsung Electronics
-- 
2.14.3
