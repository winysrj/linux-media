Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.49.219]:14765 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932129AbeDWSDE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 14:03:04 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id A0C953E3B
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 12:38:05 -0500 (CDT)
Date: Mon, 23 Apr 2018 12:38:03 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 01/11] media: tm6000: fix potential Spectre variant 1
Message-ID: <3d4973141e218fb516422d3d831742d55aaa5c04.1524499368.git.gustavo@embeddedor.com>
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
drivers/media/usb/tm6000/tm6000-video.c:879 vidioc_enum_fmt_vid_cap() warn: potential spectre issue 'format'

Fix this by sanitizing f->index before using it to index
array _format_

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2

Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/usb/tm6000/tm6000-video.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index b2399d4..d701027 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -26,6 +26,7 @@
 #include <linux/kthread.h>
 #include <linux/highmem.h>
 #include <linux/freezer.h>
+#include <linux/nospec.h>
 
 #include "tm6000-regs.h"
 #include "tm6000.h"
@@ -875,6 +876,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (f->index >= ARRAY_SIZE(format))
 		return -EINVAL;
 
+	f->index = array_index_nospec(f->index, ARRAY_SIZE(format));
 	strlcpy(f->description, format[f->index].name, sizeof(f->description));
 	f->pixelformat = format[f->index].fourcc;
 	return 0;
-- 
2.7.4
