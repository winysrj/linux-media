Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:41150 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3A1Lv0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 06:51:26 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	LDOC <linux-doc@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Rob Landley <rob@landley.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH v2] media: add support for decoder as one of media entity types
Date: Mon, 28 Jan 2013 17:20:43 +0530
Message-Id: <1359373843-15956-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Manjunath Hadli <manjunath.hadli@ti.com>

A lot of SOCs including Texas Instruments Davinci family mainly use
video decoders as input devices. This patch adds a flag
'MEDIA_ENT_T_V4L2_SUBDEV_DECODER' media entity type for decoder's.
Along side updates the documentation for this media entity type.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Rob Landley <rob@landley.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Changes for v2:
 1: Sending as a separate patch. 
 2: Added documentation for the added media entity type.
 3: Improved the commit message.
 
 .../DocBook/media/v4l/media-ioc-enum-entities.xml  |   10 ++++++++++
 include/uapi/linux/media.h                         |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index 576b68b..116c301 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -272,6 +272,16 @@
 	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_LENS</constant></entry>
 	    <entry>Lens controller</entry>
 	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_DECODER</constant></entry>
+	    <entry>Video decoder, the basic function of the video decoder is to
+	    accept analogue video from a wide variety of sources such as
+	    broadcast, DVD players, cameras and video cassette recorders, in
+	    either NTSC, PAL or HD format and still occasionally SECAM, separate
+	    it into its component parts, luminance and chrominance, and output
+	    it in some digital video standard, with appropriate embedded timing
+	    signals.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 0ef8833..dac06d7 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -56,6 +56,8 @@ struct media_device_info {
 #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENT_T_V4L2_SUBDEV + 1)
 #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV + 2)
 #define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV + 3)
+/* DECODER: Converts analogue video to digital */
+#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)
 
 #define MEDIA_ENT_FL_DEFAULT		(1 << 0)
 
-- 
1.7.4.1

