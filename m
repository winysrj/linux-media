Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.148.212]:39310 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932109AbeDWSNK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 14:13:10 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 5C1657F7EB
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 12:51:26 -0500 (CDT)
Date: Mon, 23 Apr 2018 12:51:23 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 10/11] vivid-sdr-cap: fix potential Spectre variant 1
Message-ID: <586469aa63a9579ecdeb8ffa4fb31d441564c622.1524499368.git.gustavo@embeddedor.com>
References: <cover.1524499368.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1524499368.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

band->index can be controlled by user-space, hence leading to
a potential exploitation of the Spectre variant 1 vulnerability.

Smatch warning:
drivers/media/platform/vivid/vivid-sdr-cap.c:323 vivid_sdr_enum_freq_bands() warn: potential spectre issue 'bands_adc'

Fix this by sanitizing band->index before using it to index
bands_adc and bands_fm.

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2

Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/platform/vivid/vivid-sdr-cap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index cfb7cb4..684d8a2 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -22,6 +22,8 @@
 #include "vivid-ctrls.h"
 #include "vivid-sdr-cap.h"
 
+#include <linux/nospec.h>
+
 /* stream formats */
 struct vivid_format {
 	u32	pixelformat;
@@ -320,11 +322,15 @@ int vivid_sdr_enum_freq_bands(struct file *file, void *fh,
 	case 0:
 		if (band->index >= ARRAY_SIZE(bands_adc))
 			return -EINVAL;
+		band->index = array_index_nospec(band->index,
+						 ARRAY_SIZE(bands_adc));
 		*band = bands_adc[band->index];
 		return 0;
 	case 1:
 		if (band->index >= ARRAY_SIZE(bands_fm))
 			return -EINVAL;
+		band->index = array_index_nospec(band->index,
+						 ARRAY_SIZE(bands_fm));
 		*band = bands_fm[band->index];
 		return 0;
 	default:
-- 
2.7.4
