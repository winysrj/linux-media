Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50265 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933175AbeAKW0q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 17:26:46 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@kernel.org, shuah@kernel.org, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: v4l2-core: v4l2-mc: Add SPDX license identifier
Date: Thu, 11 Jan 2018 15:26:22 -0700
Message-Id: <20180111222622.32206-1-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace GPL license statement with SPDX GPL-2.0 license identifier.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
Changes since v1:
- Fixed SPDX comment format
- Fixed SPDX license text to eliminate change in license. It now
  reads GPL-2.0-or-later to maintain the original.

 drivers/media/v4l2-core/v4l2-mc.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 303980b71aae..8b61ccf3df81 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
 /*
  * Media Controller ancillary functions
  *
@@ -5,16 +7,6 @@
  * Copyright (C) 2016 Shuah Khan <shuahkh@osg.samsung.com>
  * Copyright (C) 2006-2010 Nokia Corporation
  * Copyright (c) 2016 Intel Corporation.
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
  */
 
 #include <linux/module.h>
-- 
2.14.1
