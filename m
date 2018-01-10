Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47157 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932430AbeAJQgG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 11:36:06 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@kernel.org, shuah@kernel.org, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: v4l2-core: v4l2-mc: Add SPDX license identifier
Date: Wed, 10 Jan 2018 09:35:36 -0700
Message-Id: <20180110163540.8396-2-shuahkh@osg.samsung.com>
In-Reply-To: <20180110163540.8396-1-shuahkh@osg.samsung.com>
References: <20180110163540.8396-1-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace GPL license statement with SPDX GPL-2.0 license identifier.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-mc.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 303980b71aae..1297132acd4e 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Media Controller ancillary functions
  *
@@ -5,16 +6,6 @@
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
