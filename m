Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48666 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751370AbaCBPfh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Mar 2014 10:35:37 -0500
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 2712F6008E
	for <linux-media@vger.kernel.org>; Sun,  2 Mar 2014 17:35:34 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: Trivial documentation fix
Date: Sun,  2 Mar 2014 17:38:52 +0200
Message-Id: <1393774732-32538-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove one quotation mark. This fixes DocBook documentation build.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/controls.xml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 0e1770c..b7f3feb 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2259,7 +2259,7 @@ VBV buffer control.</entry>
 	      </row>
 
 		  <row><entry></entry></row>
-	      <row id=""v4l2-mpeg-video-hor-search-range">
+	      <row id="v4l2-mpeg-video-hor-search-range">
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE</constant>&nbsp;</entry>
 		<entry>integer</entry>
 	      </row>
-- 
1.7.10.4

