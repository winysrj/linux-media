Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway22.websitewelcome.com ([192.185.47.144]:44162 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932109AbeDWSMg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 14:12:36 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 90290FE0B
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 12:50:08 -0500 (CDT)
Date: Mon, 23 Apr 2018 12:50:07 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Helen Koike <helen.koike@collabora.com>
Subject: [PATCH 09/11] vimc-debayer: fix potential Spectre variant 1
Message-ID: <54dea7486d296e39cdbc3e5465fb4f5d3dee92e9.1524499368.git.gustavo@embeddedor.com>
References: <cover.1524499368.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1524499368.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

code->index can be controlled by user-space, hence leading to
a potential exploitation of the Spectre variant 1 vulnerability.

Smatch warning:
drivers/media/platform/vimc/vimc-debayer.c:182 vimc_deb_enum_mbus_code() warn: potential spectre issue 'vimc_deb_pix_map_list'

Fix this by sanitizing code->index before using it to index
vimc_deb_pix_map_list.

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2

Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/platform/vimc/vimc-debayer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
index 6e10b63..bdd96bb 100644
--- a/drivers/media/platform/vimc/vimc-debayer.c
+++ b/drivers/media/platform/vimc/vimc-debayer.c
@@ -24,6 +24,8 @@
 
 #include "vimc-common.h"
 
+#include <linux/nospec.h>
+
 #define VIMC_DEB_DRV_NAME "vimc-debayer"
 
 static unsigned int deb_mean_win_size = 3;
@@ -178,7 +180,8 @@ static int vimc_deb_enum_mbus_code(struct v4l2_subdev *sd,
 	} else {
 		if (code->index >= ARRAY_SIZE(vimc_deb_pix_map_list))
 			return -EINVAL;
-
+		code->index = array_index_nospec(code->index,
+					    ARRAY_SIZE(vimc_deb_pix_map_list));
 		code->code = vimc_deb_pix_map_list[code->index].code;
 	}
 
-- 
2.7.4
