Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway33.websitewelcome.com ([192.185.145.23]:44721 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932268AbeDWSgW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 14:36:22 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id CA2AA29440
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 12:48:12 -0500 (CDT)
Date: Mon, 23 Apr 2018 12:48:11 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 07/11] rcar_drif: fix potential Spectre variant 1
Message-ID: <ad9e037eeafc9c1f04810ddcceacc8735c544e54.1524499368.git.gustavo@embeddedor.com>
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
drivers/media/platform/rcar_drif.c:909 rcar_drif_enum_fmt_sdr_cap() warn: potential spectre issue 'formats'

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
 drivers/media/platform/rcar_drif.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index dc7e280..2c21ec2 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -66,6 +66,8 @@
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 
+#include <linux/nospec.h>
+
 /* DRIF register offsets */
 #define RCAR_DRIF_SITMDR1			0x00
 #define RCAR_DRIF_SITMDR2			0x04
@@ -905,7 +907,7 @@ static int rcar_drif_enum_fmt_sdr_cap(struct file *file, void *priv,
 {
 	if (f->index >= ARRAY_SIZE(formats))
 		return -EINVAL;
-
+	f->index = array_index_nospec(f->index, ARRAY_SIZE(formats));
 	f->pixelformat = formats[f->index].pixelformat;
 
 	return 0;
-- 
2.7.4
