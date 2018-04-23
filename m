Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.51.172]:24276 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932164AbeDWSKZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 14:10:25 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 03D082E8E4
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 12:48:59 -0500 (CDT)
Date: Mon, 23 Apr 2018 12:48:55 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 08/11] sh_vou: fix potential Spectre variant 1
Message-ID: <56615d4b6a9557645468873d60f5b0b5fcffcfc7.1524499368.git.gustavo@embeddedor.com>
References: <cover.1524499368.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1524499368.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fmt->index can be controlled by user-space, hence leading to
a potential exploitation of the Spectre variant 1 vulnerability.

Smatch warning:
drivers/media/platform/sh_vou.c:407 sh_vou_enum_fmt_vid_out() warn: potential spectre issue 'vou_fmt'

Fix this by sanitizing fmt->index before using it to index
vou_fmt.

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2

Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/platform/sh_vou.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 4dccf29..58d8645 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -30,6 +30,8 @@
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
+#include <linux/nospec.h>
+
 /* Mirror addresses are not available for all registers */
 #define VOUER	0
 #define VOUCR	4
@@ -398,6 +400,7 @@ static int sh_vou_enum_fmt_vid_out(struct file *file, void  *priv,
 
 	if (fmt->index >= ARRAY_SIZE(vou_fmt))
 		return -EINVAL;
+	fmt->index = array_index_nospec(fmt->index, ARRAY_SIZE(vou_fmt));
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-- 
2.7.4
