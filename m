Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:63172 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757498AbcLPNck (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 08:32:40 -0500
From: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1] [media] v4l2-common: fix aligned value calculation
Date: Fri, 16 Dec 2016 14:32:15 +0100
Message-ID: <1481895135-11055-1-git-send-email-jean-christophe.trotin@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct the calculation of the rounding to nearest aligned value in
the clamp_align() function. For example, clamp_align(1277, 1, 9600, 2)
returns 1276, while it should return 1280.

Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
---
 drivers/media/v4l2-core/v4l2-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 57cfe26a..2970ce7 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -315,7 +315,7 @@ static unsigned int clamp_align(unsigned int x, unsigned int min,
 
 	/* Round to nearest aligned value */
 	if (align)
-		x = (x + (1 << (align - 1))) & mask;
+		x = (x + ((1 << align) - 1)) & mask;
 
 	return x;
 }
-- 
1.9.1

