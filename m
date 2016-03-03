Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36489 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbcCCNbJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 08:31:09 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Takashi Iwai <tiwai@suse.de>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] [media] Better define MEDIA_ENT_F_CONN_* entities
Date: Thu,  3 Mar 2016 10:31:02 -0300
Message-Id: <32c88fe4e8378ec6a2d74f65f88b004cdd815d82.1457011857.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Putting concepts in a paper is hard, specially since different people
may interpret it in a different way.

Make clear about the meaning of the MEDIA_ENT_F_CONN_* entities

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Shuah Khan <shuahkh@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/media/v4l/media-types.xml | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
index 5e3f20fdcf17..a88f39ab4fd8 100644
--- a/Documentation/DocBook/media/v4l/media-types.xml
+++ b/Documentation/DocBook/media/v4l/media-types.xml
@@ -46,15 +46,26 @@
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_F_CONN_RF</constant></entry>
-	    <entry>Connector for a Radio Frequency (RF) signal.</entry>
+	    <entry>Entity representing the logical connection associated with a
+		    single Radio Frequency (RF) signal connector. It
+		    corresponds to the logical input or output associated
+		    with the RF signal.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_F_CONN_SVIDEO</constant></entry>
-	    <entry>Connector for a S-Video signal.</entry>
+	    <entry>Entity representing the logical connection associated
+		    with a sigle S-Video connector. Such entity should have
+		    two pads, one for the luminance signal (Y) and one
+		    for the chrominance signal (C). It corresponds to the
+		    logical input or output associated with S-Video Y and C
+		    signals.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_F_CONN_COMPOSITE</constant></entry>
-	    <entry>Connector for a RGB composite signal.</entry>
+	    <entry>Entity representing the logical connection for a composite
+		    signal. It corresponds to the logical input or output
+		    associated with the single signal that carries both
+		    chrominance and luminance information (Y+C).</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_F_CAM_SENSOR</constant></entry>
-- 
2.5.0

