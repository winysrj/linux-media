Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60293 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbaCERUa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 12:20:30 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] DocBook: Fix a breakage at controls.xml
Date: Wed,  5 Mar 2014 14:19:50 -0300
Message-Id: <1394039990-26111-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some previous patch introduced this bug:

/devel/v4l/patchwork/Documentation/DocBook/controls.xml:2262: parser error : attributes construct error
	      <row id=""v4l2-mpeg-video-hor-search-range">
	                ^
/devel/v4l/patchwork/Documentation/DocBook/controls.xml:2262: parser error : Couldn't find end of Start Tag row line 2262
	      <row id=""v4l2-mpeg-video-hor-search-range">
	                ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 0e1770c133a8..b7f3feb820db 100644
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
1.8.5.3

