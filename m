Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.148.212]:18265 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932164AbeDWSKg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 14:10:36 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 6339716ADD
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 12:47:21 -0500 (CDT)
Date: Mon, 23 Apr 2018 12:47:20 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 06/11] rcar-v4l2: fix potential Spectre variant 1
Message-ID: <45621d4cd0639906cf16c4b4d666e8cd0e1c3694.1524499368.git.gustavo@embeddedor.com>
References: <cover.1524499368.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1524499368.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

f->index can be controlled by user-space, hence leading to
a potential exploitation of the Spectre variant 1 vulnerability.

Smatch warning:
drivers/media/platform/rcar-vin/rcar-v4l2.c:344 rvin_enum_fmt_vid_cap() warn: potential spectre issue 'rvin_formats'

Fix this by sanitizing f->index before using it to index
rvin_formats.

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2

Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index b479b88..bbfc3b8 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -22,6 +22,8 @@
 
 #include "rcar-vin.h"
 
+#include <linux/nospec.h>
+
 #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
 #define RVIN_MAX_WIDTH		2048
 #define RVIN_MAX_HEIGHT		2048
@@ -340,7 +342,7 @@ static int rvin_enum_fmt_vid_cap(struct file *file, void *priv,
 {
 	if (f->index >= ARRAY_SIZE(rvin_formats))
 		return -EINVAL;
-
+	f->index = array_index_nospec(f->index, ARRAY_SIZE(rvin_formats));
 	f->pixelformat = rvin_formats[f->index].fourcc;
 
 	return 0;
-- 
2.7.4
