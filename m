Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35969 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbcEULfc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2016 07:35:32 -0400
Received: by mail-lf0-f68.google.com with SMTP id d132so1654689lfb.3
        for <linux-media@vger.kernel.org>; Sat, 21 May 2016 04:35:31 -0700 (PDT)
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: andrea.gelmini@gelma.net
Cc: trivial@kernel.org, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com, wuchengli@chromium.org,
	keescook@chromium.org, crope@iki.fi, standby24x7@gmail.com,
	linux-media@vger.kernel.org
Subject: [PATCH 0002/1529] Fix typo
Date: Sat, 21 May 2016 13:35:26 +0200
Message-Id: <20160521113526.31380-1-andrea.gelmini@gelma.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 Documentation/DocBook/media/v4l/controls.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index e2e5484..dc3ef53 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4615,7 +4615,7 @@ manually or automatically if set to zero. Unit, range and step are driver-specif
 	    sample rate in each spatial dimension. See <xref linkend="itu-t81"/>,
 	    clause A.1.1. for more details. The <constant>
 	    V4L2_CID_JPEG_CHROMA_SUBSAMPLING</constant> control determines how
-	    Cb and Cr components are downsampled after coverting an input image
+	    Cb and Cr components are downsampled after converting an input image
 	    from RGB to Y'CbCr color space.
 	    </entry>
 	  </row>
-- 
2.8.2.534.g1f66975

