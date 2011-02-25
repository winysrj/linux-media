Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34432 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1BYGLg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 01:11:36 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: awalls@md.metrocast.net, mchehab@infradead.org,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 06/21]drivers:media:cx23418.h remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:11:17 -0800
Message-Id: <1298614277-3649-1-git-send-email-justinmattock@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/video/cx18/cx23418.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx18/cx23418.h b/drivers/media/video/cx18/cx23418.h
index 7e40035..935f557 100644
--- a/drivers/media/video/cx18/cx23418.h
+++ b/drivers/media/video/cx18/cx23418.h
@@ -477,7 +477,7 @@
 /* The are no buffers ready. Try again soon! */
 #define CXERR_NODATA_AGAIN      0x00001E
 
-/* The stream is stopping. Function not alllowed now! */
+/* The stream is stopping. Function not allowed now! */
 #define CXERR_STOPPING_STATUS   0x00001F
 
 /* Trying to access hardware when the power is turned OFF */
-- 
1.7.4.1

