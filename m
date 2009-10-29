Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:51115 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbZJ2Fm5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 01:42:57 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9T5gxu4019346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 29 Oct 2009 00:43:01 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 1/1] v4l2 doc: Added S/G_ROTATE, S/G_BG_COLOR information
Date: Thu, 29 Oct 2009 11:12:57 +0530
Message-Id: <1256794977-32473-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 v4l2-spec/controls.sgml |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/v4l2-spec/controls.sgml b/v4l2-spec/controls.sgml
index 477a970..a675f30 100644
--- a/v4l2-spec/controls.sgml
+++ b/v4l2-spec/controls.sgml
@@ -281,10 +281,28 @@ minimum value disables backlight compensation.</entry>
 <constant>V4L2_COLORFX_SEPIA</constant> (2).</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CID_ROTATE</constant></entry>
+	    <entry>integer</entry>
+	    <entry>Rotates the image by specified angle. Common angles are 90,
+	    270 and 180. Rotating the image to 90 and 270 will reverse the height
+	    and width of the display window. It is necessary to set the new height and
+	    width of the picture using S_FMT ioctl, see <xref linkend="vidioc-g-fmt"> according to
+	    the rotation angle selected.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CID_BG_COLOR</constant></entry>
+	    <entry>integer</entry>
+	    <entry>Sets the background color on the current output device.
+	    Background color needs to be specified in the RGB24 format. The
+	    supplied 32 bit value is interpreted as bits 0-7 Red color information,
+	    bits 8-15 Green color information, bits 16-23 Blue color
+	    information and bits 24-31 must be zero.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
 	    <entry></entry>
 	    <entry>End of the predefined control IDs (currently
-<constant>V4L2_CID_COLORFX</constant> + 1).</entry>
+<constant>V4L2_CID_BG_COLOR</constant> + 1).</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
-- 
1.6.2.4

