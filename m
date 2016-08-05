Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:55923 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759594AbcHEKqi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 06:46:38 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v3 01/11] doc-rst: Correct the ordering of LSBs of the 10-bit raw packed formats
Date: Fri,  5 Aug 2016 13:45:31 +0300
Message-Id: <1470393941-26959-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 10-bit packed raw bayer format documented that the data of the first
pixel of a four-pixel group was found in the first byte and the two
highest bits of the fifth byte. This was not entirely correct. The two
bits in the fifth byte are the two lowest bits. The second pixel occupies
the second byte and third and fourth least significant bits and so on.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Aviv Greenberg <aviv.d.greenberg@intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
index d71368f..32c067c 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
@@ -54,8 +54,8 @@ Each cell is one byte.
 
        -  G\ :sub:`03high`
 
-       -  B\ :sub:`00low`\ (bits 7--6) G\ :sub:`01low`\ (bits 5--4)
-	  B\ :sub:`02low`\ (bits 3--2) G\ :sub:`03low`\ (bits 1--0)
+       -  G\ :sub:`03low`\ (bits 7--6) B\ :sub:`02low`\ (bits 5--4)
+	  G\ :sub:`01low`\ (bits 3--2) B\ :sub:`00low`\ (bits 1--0)
 
     -  .. row 2
 
@@ -69,8 +69,8 @@ Each cell is one byte.
 
        -  R\ :sub:`13high`
 
-       -  G\ :sub:`10low`\ (bits 7--6) R\ :sub:`11low`\ (bits 5--4)
-	  G\ :sub:`12low`\ (bits 3--2) R\ :sub:`13low`\ (bits 1--0)
+       -  R\ :sub:`13low`\ (bits 7--6) G\ :sub:`12low`\ (bits 5--4)
+	  R\ :sub:`11low`\ (bits 3--2) G\ :sub:`10low`\ (bits 1--0)
 
     -  .. row 3
 
@@ -84,8 +84,8 @@ Each cell is one byte.
 
        -  G\ :sub:`23high`
 
-       -  B\ :sub:`20low`\ (bits 7--6) G\ :sub:`21low`\ (bits 5--4)
-	  B\ :sub:`22low`\ (bits 3--2) G\ :sub:`23low`\ (bits 1--0)
+       -  G\ :sub:`23low`\ (bits 7--6) B\ :sub:`22low`\ (bits 5--4)
+	  G\ :sub:`21low`\ (bits 3--2) B\ :sub:`20low`\ (bits 1--0)
 
     -  .. row 4
 
@@ -99,5 +99,5 @@ Each cell is one byte.
 
        -  R\ :sub:`33high`
 
-       -  G\ :sub:`30low`\ (bits 7--6) R\ :sub:`31low`\ (bits 5--4)
-	  G\ :sub:`32low`\ (bits 3--2) R\ :sub:`33low`\ (bits 1--0)
+       -  R\ :sub:`33low`\ (bits 7--6) G\ :sub:`32low`\ (bits 5--4)
+	  R\ :sub:`31low`\ (bits 3--2) G\ :sub:`30low`\ (bits 1--0)
-- 
2.7.4

