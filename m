Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:37237 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab3A1Vpo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 16:45:44 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ao2@amarulasolutions.com>,
	linux-doc@vger.kernel.org,
	Michael Trimarchi <michael@amarulasolutions.com>
Subject: [PATCH 2/2] [media] Documentation/DocBook/media/v4l/subdev-formats.xml: fix a typo
Date: Mon, 28 Jan 2013 22:45:32 +0100
Message-Id: <1359409532-32088-3-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1359409532-32088-1-git-send-email-ospite@studenti.unina.it>
References: <1359409532-32088-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Antonio Ospite <ao2@amarulasolutions.com>

s/lisst/lists/

Signed-off-by: Antonio Ospite <ao2@amarulasolutions.com>
---

Should it also be s/packet/packed/ on the same line?
If so I'll send another patch for that, there are a couple more of
these.

Thanks,
   Antonio

 Documentation/DocBook/media/v4l/subdev-formats.xml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index a0a9364..d5d1e02 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -877,7 +877,7 @@
       U, Y, V, Y order will be named <constant>V4L2_MBUS_FMT_UYVY8_2X8</constant>.
       </para>
 
-      <para>The following table lisst existing packet YUV formats.</para>
+      <para>The following table lists existing packet YUV formats.</para>
 
       <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-yuv8">
 	<title>YUV Formats</title>
-- 
1.7.10.4

