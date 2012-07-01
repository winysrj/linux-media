Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:51555 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2GAUP5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jul 2012 16:15:57 -0400
Received: by mail-qa0-f53.google.com with SMTP id s11so1561997qaa.19
        for <linux-media@vger.kernel.org>; Sun, 01 Jul 2012 13:15:57 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 4/6] cx25840: fix vsrc/hsrc usage on cx23888 designs
Date: Sun,  1 Jul 2012 16:15:12 -0400
Message-Id: <1341173714-23627-5-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1341173714-23627-1-git-send-email-dheitmueller@kernellabs.com>
References: <1341173714-23627-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The location of the vsrc/hsrc registers moved in the cx23888, causing the
s_mbus call to fail prematurely indicating that "720x480 is not a valid size".
The function bailed out before many pertinent registers were set related to
the scaler (causing unexpected results in video rendering when doing raw
video capture).

Use the correct registers for the cx23888.

Validated with the following boards:

HVR-1800 retail (0070:7801)
HVR-1800 OEM (0070:7809)
HVR-1850 retail (0070:8541)

Thanks to Steven Toth and Hauppauge for	loaning	me various boards to
regression test with.

Reported-by: Jonathan <sitten74490@mypacks.net>
Thanks-to: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Devin Heitmueler <dheitmueller@kernellabs.com>
---
 drivers/media/video/cx25840/cx25840-core.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index 7dc7bb1..d8eac3e 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -1380,11 +1380,21 @@ static int cx25840_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
 	fmt->field = V4L2_FIELD_INTERLACED;
 	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
 
-	Vsrc = (cx25840_read(client, 0x476) & 0x3f) << 4;
-	Vsrc |= (cx25840_read(client, 0x475) & 0xf0) >> 4;
+	if (is_cx23888(state)) {
+		Vsrc = (cx25840_read(client, 0x42a) & 0x3f) << 4;
+		Vsrc |= (cx25840_read(client, 0x429) & 0xf0) >> 4;
+	} else {
+		Vsrc = (cx25840_read(client, 0x476) & 0x3f) << 4;
+		Vsrc |= (cx25840_read(client, 0x475) & 0xf0) >> 4;
+	}
 
-	Hsrc = (cx25840_read(client, 0x472) & 0x3f) << 4;
-	Hsrc |= (cx25840_read(client, 0x471) & 0xf0) >> 4;
+	if (is_cx23888(state)) {
+		Hsrc = (cx25840_read(client, 0x426) & 0x3f) << 4;
+		Hsrc |= (cx25840_read(client, 0x425) & 0xf0) >> 4;
+	} else {
+		Hsrc = (cx25840_read(client, 0x472) & 0x3f) << 4;
+		Hsrc |= (cx25840_read(client, 0x471) & 0xf0) >> 4;
+	}
 
 	Vlines = fmt->height + (is_50Hz ? 4 : 7);
 
-- 
1.7.1

