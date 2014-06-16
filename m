Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:43680 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbaFPPD0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 11:03:26 -0400
From: Antonio Ospite <ao2@ao2.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ao2@ao2.it>, Hans de Goede <hdegoede@redhat.com>,
	Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH RESEND] libv4lconvert: Fix a regression when converting from Y10B
Date: Mon, 16 Jun 2014 17:00:41 +0200
Message-Id: <1402930841-14755-1-git-send-email-ao2@ao2.it>
In-Reply-To: <20140603155930.f72e14f4aab39ec49bdb1b71@ao2.it>
References: <20140603155930.f72e14f4aab39ec49bdb1b71@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a regression introduced in commit
efc29f1764a30808ebf7b3e1d9bfa27b909bf641 (libv4lconvert: Reject too
short source buffer before accessing it).

The old code:

case V4L2_PIX_FMT_Y10BPACK:
	...
	if (result == 0 && src_size < (width * height * 10 / 8)) {
		V4LCONVERT_ERR("short y10b data frame\n");
		errno = EPIPE;
		result = -1;
	}
	...

meant to say "If the conversion was *successful* _but_ the frame size
was invalid, then take the error path", but in
efc29f1764a30808ebf7b3e1d9bfa27b909bf641 this (maybe weird) logic was
misunderstood and v4lconvert_convert_pixfmt() was made to return an
error even in the case of a successful conversion from Y10B.

Fix the check, and now print only the message letting the errno and the
result from the conversion routines to be propagated to the caller.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
Cc: Gregor Jasny <gjasny@googlemail.com>
---
 lib/libv4lconvert/libv4lconvert.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index c49d30d..50d6906 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -1052,11 +1052,8 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 							   width, height);
 			break;
 		}
-		if (result == 0) {
+		if (result != 0)
 			V4LCONVERT_ERR("y10b conversion failed\n");
-			errno = EPIPE;
-			result = -1;
-		}
 		break;
 
 	case V4L2_PIX_FMT_RGB565:
-- 
2.0.0

