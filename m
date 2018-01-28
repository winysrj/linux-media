Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:41426 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752085AbeA1UG2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 Jan 2018 15:06:28 -0500
Received: by mail-wr0-f194.google.com with SMTP id v15so4993065wrb.8
        for <linux-media@vger.kernel.org>; Sun, 28 Jan 2018 12:06:27 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: mchehab@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] media: mantis: remove mantis_vp3028.c/mantis_vp3028.h
Date: Sun, 28 Jan 2018 20:06:18 +0000
Message-Id: <1517169978-26298-1-git-send-email-clabbe@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thoses files are unused since commit b3b961448f70 ("V4L/DVB (13795): [Mantis/Hopper] Code overhaul, add Hopper devices into the PCI ID list")
8 year after, we could remove it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/media/pci/mantis/mantis_vp3028.c | 38 --------------------------------
 drivers/media/pci/mantis/mantis_vp3028.h | 33 ---------------------------
 2 files changed, 71 deletions(-)
 delete mode 100644 drivers/media/pci/mantis/mantis_vp3028.c
 delete mode 100644 drivers/media/pci/mantis/mantis_vp3028.h

diff --git a/drivers/media/pci/mantis/mantis_vp3028.c b/drivers/media/pci/mantis/mantis_vp3028.c
deleted file mode 100644
index 4155c838a18a..000000000000
--- a/drivers/media/pci/mantis/mantis_vp3028.c
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
-	Mantis VP-3028 driver
-
-	Copyright (C) Manu Abraham (abraham.manu@gmail.com)
-
-	This program is free software; you can redistribute it and/or modify
-	it under the terms of the GNU General Public License as published by
-	the Free Software Foundation; either version 2 of the License, or
-	(at your option) any later version.
-
-	This program is distributed in the hope that it will be useful,
-	but WITHOUT ANY WARRANTY; without even the implied warranty of
-	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-	GNU General Public License for more details.
-
-	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the Free Software
-	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-#include "mantis_common.h"
-#include "mantis_vp3028.h"
-
-struct zl10353_config mantis_vp3028_config = {
-	.demod_address	= 0x0f,
-};
-
-#define MANTIS_MODEL_NAME	"VP-3028"
-#define MANTIS_DEV_TYPE		"DVB-T"
-
-struct mantis_hwconfig vp3028_mantis_config = {
-	.model_name	= MANTIS_MODEL_NAME,
-	.dev_type	= MANTIS_DEV_TYPE,
-	.ts_size	= MANTIS_TS_188,
-	.baud_rate	= MANTIS_BAUD_9600,
-	.parity		= MANTIS_PARITY_NONE,
-	.bytes		= 0,
-};
diff --git a/drivers/media/pci/mantis/mantis_vp3028.h b/drivers/media/pci/mantis/mantis_vp3028.h
deleted file mode 100644
index 34130d29e0aa..000000000000
--- a/drivers/media/pci/mantis/mantis_vp3028.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
-	Mantis VP-3028 driver
-
-	Copyright (C) Manu Abraham (abraham.manu@gmail.com)
-
-	This program is free software; you can redistribute it and/or modify
-	it under the terms of the GNU General Public License as published by
-	the Free Software Foundation; either version 2 of the License, or
-	(at your option) any later version.
-
-	This program is distributed in the hope that it will be useful,
-	but WITHOUT ANY WARRANTY; without even the implied warranty of
-	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-	GNU General Public License for more details.
-
-	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the Free Software
-	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-#ifndef __MANTIS_VP3028_H
-#define __MANTIS_VP3028_H
-
-#include <media/dvb_frontend.h>
-#include "mantis_common.h"
-#include "zl10353.h"
-
-#define MANTIS_VP_3028_DVB_T	0x0028
-
-extern struct zl10353_config mantis_vp3028_config;
-extern struct mantis_hwconfig vp3028_mantis_config;
-
-#endif /* __MANTIS_VP3028_H */
-- 
2.13.6
