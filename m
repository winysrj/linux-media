Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway20.websitewelcome.com ([192.185.62.46]:30622 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932109AbeDWSDh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 14:03:37 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 0E188400DDFEF
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 12:40:58 -0500 (CDT)
Date: Mon, 23 Apr 2018 12:40:54 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 04/11] marvell-ccic: mcam-core: fix potential Spectre variant
 1
Message-ID: <64785db2204b1a4446d012e4508c16c523c43345.1524499368.git.gustavo@embeddedor.com>
References: <cover.1524499368.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1524499368.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fmt->index can be controlled by user-space, hence leading to a
potential exploitation of the Spectre variant 1 vulnerability.

Smatch warning:
drivers/media/platform/marvell-ccic/mcam-core.c:1323 mcam_vidioc_enum_fmt_vid_cap() warn: potential spectre issue 'mcam_formats'

Fix this by sanitizing fmt->index before using it to index
mcam_formats.

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2

Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 80670ee..0a54dba 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -33,6 +33,8 @@
 
 #include "mcam-core.h"
 
+#include <linux/nospec.h>
+
 #ifdef MCAM_MODE_VMALLOC
 /*
  * Internal DMA buffer management.  Since the controller cannot do S/G I/O,
@@ -1318,6 +1320,7 @@ static int mcam_vidioc_enum_fmt_vid_cap(struct file *filp,
 {
 	if (fmt->index >= N_MCAM_FMTS)
 		return -EINVAL;
+	fmt->index = array_index_nospec(fmt->index, N_MCAM_FMTS);
 	strlcpy(fmt->description, mcam_formats[fmt->index].desc,
 			sizeof(fmt->description));
 	fmt->pixelformat = mcam_formats[fmt->index].pixelformat;
-- 
2.7.4
