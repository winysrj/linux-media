Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.148.2]:15200 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932093AbeDWRjX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 13:39:23 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 564D760A5
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 12:39:22 -0500 (CDT)
Date: Mon, 23 Apr 2018 12:39:21 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 03/11] fsl-viu: fix potential Spectre variant 1
Message-ID: <a9c766d2aaf75b568ae1cf177c62e90e4eea67f3.1524499368.git.gustavo@embeddedor.com>
References: <cover.1524499368.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1524499368.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

f->index can be controlled by user-space, hence leading to a
potential exploitation of the Spectre variant 1 vulnerability.

Smatch warning:
drivers/media/platform/fsl-viu.c:587 vidioc_enum_fmt() warn: potential spectre issue 'formats'

Fix this by sanitizing f->index before using it to index
formats.

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2

Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/platform/fsl-viu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index e41510c..8356d26 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -33,6 +33,8 @@
 #include <media/v4l2-event.h>
 #include <media/videobuf-dma-contig.h>
 
+#include <linux/nospec.h>
+
 #define DRV_NAME		"fsl_viu"
 #define VIU_VERSION		"0.5.1"
 
@@ -579,12 +581,10 @@ static int vidioc_querycap(struct file *file, void *priv,
 static int vidioc_enum_fmt(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
-	int index = f->index;
-
 	if (f->index >= NUM_FORMATS)
 		return -EINVAL;
-
-	f->pixelformat = formats[index].fourcc;
+	f->index = array_index_nospec(f->index, NUM_FORMATS);
+	f->pixelformat = formats[f->index].fourcc;
 	return 0;
 }
 
-- 
2.7.4
