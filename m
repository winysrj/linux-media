Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38656 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753138AbdLEOvT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Dec 2017 09:51:19 -0500
Received: by mail-wr0-f195.google.com with SMTP id o2so579325wro.5
        for <linux-media@vger.kernel.org>; Tue, 05 Dec 2017 06:51:18 -0800 (PST)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: mchehab@kernel.org, alexandre.torgue@st.com,
        hans.verkuil@cisco.com, yannick.fertre@st.com,
        hugues.fruchet@st.com
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: [PATCH] media: platform: stm32: Adopt SPDX identifier
Date: Tue,  5 Dec 2017 15:51:07 +0100
Message-Id: <20171205145107.17785-1-benjamin.gaignard@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add SPDX identifiers to files under stm32 directory

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
---
 drivers/media/platform/stm32/stm32-cec.c  | 5 +----
 drivers/media/platform/stm32/stm32-dcmi.c | 2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-cec.c b/drivers/media/platform/stm32/stm32-cec.c
index 0e5aa17bdd40..7c496bc1cf38 100644
--- a/drivers/media/platform/stm32/stm32-cec.c
+++ b/drivers/media/platform/stm32/stm32-cec.c
@@ -1,11 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * STM32 CEC driver
  * Copyright (C) STMicroelectronics SA 2017
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <linux/clk.h>
diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index ac4c450a6c7d..519952bec6d5 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Driver for STM32 Digital Camera Memory Interface
  *
@@ -5,7 +6,6 @@
  * Authors: Yannick Fertre <yannick.fertre@st.com>
  *          Hugues Fruchet <hugues.fruchet@st.com>
  *          for STMicroelectronics.
- * License terms:  GNU General Public License (GPL), version 2
  *
  * This driver is based on atmel_isi.c
  *
-- 
2.15.0
