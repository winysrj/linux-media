Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31880 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbcE0MsC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 08:48:02 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de
Subject: [PATCH 2/6] v4l: Fix number of zeroed high order bits in 12-bit raw format defs
Date: Fri, 27 May 2016 15:44:36 +0300
Message-Id: <1464353080-18300-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464353080-18300-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464353080-18300-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The number of high order bits in samples was documented to be 6 for 12-bit
data. This is clearly wrong, fix it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/DocBook/media/v4l/pixfmt-srggb12.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
index 0c8e4ad..4394101 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
@@ -31,7 +31,7 @@ pixel image</title>
 
       <formalpara>
 	<title>Byte Order.</title>
-	<para>Each cell is one byte, high 6 bits in high bytes are 0.
+	<para>Each cell is one byte, high 4 bits in high bytes are 0.
 	  <informaltable frame="none">
 	    <tgroup cols="5" align="center">
 	      <colspec align="left" colwidth="2*" />
-- 
1.9.1

