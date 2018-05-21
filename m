Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway20.websitewelcome.com ([192.185.55.25]:19068 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753097AbeEURpt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:45:49 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 3F7F1400F061B
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 11:57:19 -0500 (CDT)
Date: Mon, 21 May 2018 11:57:17 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] media: si470x: fix potential Spectre variant 1
Message-ID: <20180521165717.GA9167@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

band->index can be controlled by user-space, hence leading to
a potential exploitation of the Spectre variant 1 vulnerability.

This issue was detected with the help of Smatch:
drivers/media/radio/si470x/radio-si470x-common.c:758 si470x_vidioc_enum_freq_bands() warn: potential spectre issue 'bands'

Fix this by sanitizing band->index before using it to index
`bands'

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2

Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/radio/si470x/radio-si470x-common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index c40e175..e81f9aa 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -110,6 +110,10 @@
 /* kernel includes */
 #include "radio-si470x.h"
 
+/* Hardening for Spectre-v1 */
+#include <linux/nospec.h>
+
+
 /**************************************************************************
  * Module Parameters
  **************************************************************************/
@@ -755,7 +759,7 @@ static int si470x_vidioc_enum_freq_bands(struct file *file, void *priv,
 		return -EINVAL;
 	if (band->index >= ARRAY_SIZE(bands))
 		return -EINVAL;
-	*band = bands[band->index];
+	*band = bands[array_index_nospec(band->index, ARRAY_SIZE(bands))];
 	return 0;
 }
 
-- 
2.7.4
