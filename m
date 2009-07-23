Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:12413 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbZGWV2v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 17:28:51 -0400
Received: by ey-out-2122.google.com with SMTP id 9so368470eyd.37
        for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 14:28:50 -0700 (PDT)
Message-ID: <4A68D6A2.1080800@gmail.com>
Date: Thu, 23 Jul 2009 23:31:14 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: hverkuil@xs4all.nl, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ivtv: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This mistakenly tests against sizeof(freqs) instead of the array size. Due to
the mask the only illegal value possible was 3.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/video/ivtv/ivtv-controls.c b/drivers/media/video/ivtv/ivtv-controls.c
index a3b77ed..4a9c8ce 100644
--- a/drivers/media/video/ivtv/ivtv-controls.c
+++ b/drivers/media/video/ivtv/ivtv-controls.c
@@ -17,6 +17,7 @@
     along with this program; if not, write to the Free Software
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+#include <linux/kernel.h>
 
 #include "ivtv-driver.h"
 #include "ivtv-cards.h"
@@ -281,7 +282,7 @@ int ivtv_s_ext_ctrls(struct file *file, void *fh, struct v4l2_ext_controls *c)
 		idx = p.audio_properties & 0x03;
 		/* The audio clock of the digitizer must match the codec sample
 		   rate otherwise you get some very strange effects. */
-		if (idx < sizeof(freqs))
+		if (idx < ARRAY_SIZE(freqs))
 			ivtv_call_all(itv, audio, s_clock_freq, freqs[idx]);
 		return err;
 	}
