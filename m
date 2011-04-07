Return-path: <mchehab@pedra>
Received: from smtp207.alice.it ([82.57.200.103]:55370 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab1DGP5g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Apr 2011 11:57:36 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] libv4lconvert-priv.h: indent with tabs, not spaces
Date: Thu,  7 Apr 2011 17:57:25 +0200
Message-Id: <1302191845-7506-1-git-send-email-ospite@studenti.unina.it>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Indent wrapped lines with tabs, just like it is done for the other
functions in the same file.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 lib/libv4lconvert/libv4lconvert-priv.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
index 30d1cfe..84c706e 100644
--- a/lib/libv4lconvert/libv4lconvert-priv.h
+++ b/lib/libv4lconvert/libv4lconvert-priv.h
@@ -131,7 +131,7 @@ void v4lconvert_grey_to_rgb24(const unsigned char *src, unsigned char *dest,
 		int width, int height);
 
 void v4lconvert_grey_to_yuv420(const unsigned char *src, unsigned char *dest,
-                const struct v4l2_format *src_fmt);
+		const struct v4l2_format *src_fmt);
 
 void v4lconvert_rgb565_to_rgb24(const unsigned char *src, unsigned char *dest,
 		int width, int height);
-- 
1.7.4.1

