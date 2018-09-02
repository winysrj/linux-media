Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:41125 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726006AbeIBOw3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 2 Sep 2018 10:52:29 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tom aan de Wiel <tom.aandewiel@gmail.com>
Cc: Nicolas Dufresne <nicolas.dufresne@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vicodec: change codec license to LGPL
Message-ID: <6c7584ed-c7ba-b9c2-73fa-2201fcba8201@xs4all.nl>
Date: Sun, 2 Sep 2018 12:37:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FWHT codec can also be used by userspace utilities and libraries, but
since the current license is GPL and not LGPL it is not possible to include
it in e.g. gstreamer, since LGPL is required for that.

Change the license of these four files to LGPL.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Tom, if you agree to this, can you give your 'Signed-off-by' line? I cannot
make this change for the codec-fwht.c/h files without it. I think this change
makes sense.

Regards,

	Hans
---
diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index 47939160560e..36656031b295 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: LGPL-2.1+
 /*
  * Copyright 2016 Tom aan de Wiel
  * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index 1f9e47331197..3e9391fec5fe 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0+ */
+/* SPDX-License-Identifier: LGPL-2.1+ */
 /*
  * Copyright 2016 Tom aan de Wiel
  * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index cfcf84b8574d..6b06aa382cbb 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * A V4L2 frontend for the FWHT codec
  *
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
index 7794c186d905..95d1756556db 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: LGPL-2.1 */
 /*
  * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
  */
