Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36594 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbcE0MsA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 08:48:00 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de
Subject: [PATCH 1/6] v4l: Correct the ordering of LSBs of the 10-bit raw packed formats
Date: Fri, 27 May 2016 15:44:35 +0300
Message-Id: <1464353080-18300-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464353080-18300-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464353080-18300-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 10-bit packed raw bayer format documented that the data of the first
pixel of a four-pixel group was found in the first byte and the two
highest bits of the fifth byte. This was not entirely correct. The two
bits in the fifth byte are the two lowest bits. The second pixel occupies
the second byte and third and fourth least significant bits and so on.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../DocBook/media/v4l/pixfmt-srggb10p.xml          | 32 +++++++++++-----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
index a8cc102..747822b 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
@@ -47,10 +47,10 @@
 		  <entry>G<subscript>01high</subscript></entry>
 		  <entry>B<subscript>02high</subscript></entry>
 		  <entry>G<subscript>03high</subscript></entry>
-		  <entry>B<subscript>00low</subscript>(bits 7--6)
-			 G<subscript>01low</subscript>(bits 5--4)
-			 B<subscript>02low</subscript>(bits 3--2)
-			 G<subscript>03low</subscript>(bits 1--0)
+		  <entry>G<subscript>03low</subscript>(bits 7--6)
+			 B<subscript>02low</subscript>(bits 5--4)
+			 G<subscript>01low</subscript>(bits 3--2)
+			 B<subscript>00low</subscript>(bits 1--0)
 		  </entry>
 		</row>
 		<row>
@@ -59,10 +59,10 @@
 		  <entry>R<subscript>11high</subscript></entry>
 		  <entry>G<subscript>12high</subscript></entry>
 		  <entry>R<subscript>13high</subscript></entry>
-		  <entry>G<subscript>10low</subscript>(bits 7--6)
-			 R<subscript>11low</subscript>(bits 5--4)
-			 G<subscript>12low</subscript>(bits 3--2)
-			 R<subscript>13low</subscript>(bits 1--0)
+		  <entry>R<subscript>13low</subscript>(bits 7--6)
+			 G<subscript>12low</subscript>(bits 5--4)
+			 R<subscript>11low</subscript>(bits 3--2)
+			 G<subscript>10low</subscript>(bits 1--0)
 		  </entry>
 		</row>
 		<row>
@@ -71,10 +71,10 @@
 		  <entry>G<subscript>21high</subscript></entry>
 		  <entry>B<subscript>22high</subscript></entry>
 		  <entry>G<subscript>23high</subscript></entry>
-		  <entry>B<subscript>20low</subscript>(bits 7--6)
-			 G<subscript>21low</subscript>(bits 5--4)
-			 B<subscript>22low</subscript>(bits 3--2)
-			 G<subscript>23low</subscript>(bits 1--0)
+		  <entry>G<subscript>23low</subscript>(bits 7--6)
+			 B<subscript>22low</subscript>(bits 5--4)
+			 G<subscript>21low</subscript>(bits 3--2)
+			 B<subscript>20low</subscript>(bits 1--0)
 		  </entry>
 		</row>
 		<row>
@@ -83,10 +83,10 @@
 		  <entry>R<subscript>31high</subscript></entry>
 		  <entry>G<subscript>32high</subscript></entry>
 		  <entry>R<subscript>33high</subscript></entry>
-		  <entry>G<subscript>30low</subscript>(bits 7--6)
-			 R<subscript>31low</subscript>(bits 5--4)
-			 G<subscript>32low</subscript>(bits 3--2)
-			 R<subscript>33low</subscript>(bits 1--0)
+		  <entry>R<subscript>33low</subscript>(bits 7--6)
+			 G<subscript>32low</subscript>(bits 5--4)
+			 R<subscript>31low</subscript>(bits 3--2)
+			 G<subscript>30low</subscript>(bits 1--0)
 		  </entry>
 		</row>
 	      </tbody>
-- 
1.9.1

