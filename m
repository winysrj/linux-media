Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout06.plus.net ([212.159.14.18]:53279 "EHLO
        avasout06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754178AbcIOUa4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 16:30:56 -0400
From: Nick Dyer <nick@shmanahar.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Healy <cphealy@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Nick Dyer <nick@shmanahar.org>
Subject: [PATCH] Input: v4l-touch - add copyright lines
Date: Thu, 15 Sep 2016 21:30:43 +0100
Message-Id: <1473971443-19348-1-git-send-email-nick@shmanahar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans-

Please could you apply this patch to your media_tree/touch branch before it
goes to v4.9 if possible.

Thanks



Add copyright lines for Zodiac who paid for the V4L touch work.

Signed-off-by: Nick Dyer <nick@shmanahar.org>
---
 drivers/input/rmi4/rmi_f54.c             | 1 +
 drivers/input/touchscreen/atmel_mxt_ts.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/input/rmi4/rmi_f54.c b/drivers/input/rmi4/rmi_f54.c
index 99a8836..185b753 100644
--- a/drivers/input/rmi4/rmi_f54.c
+++ b/drivers/input/rmi4/rmi_f54.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2012-2015 Synaptics Incorporated
+ * Copyright (C) 2016 Zodiac Inflight Innovations
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published by
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index beede8f..e5d185f 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2010 Samsung Electronics Co.Ltd
  * Copyright (C) 2011-2014 Atmel Corporation
  * Copyright (C) 2012 Google, Inc.
+ * Copyright (C) 2016 Zodiac Inflight Innovations
  *
  * Author: Joonyoung Shim <jy0922.shim@samsung.com>
  *
-- 
2.7.4

