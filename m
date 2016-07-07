Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59499 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbcGGGtJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jul 2016 02:49:09 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, bparrot@ti.com, nsekhar@ti.com,
	prabhakar.csengg@gmail.com
Subject: [PATCH v2.2 09/10] v4l: 16-bit BGGR is always 16 bits
Date: Thu,  7 Jul 2016 09:48:21 +0300
Message-Id: <1467874102-28365-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1467039471-19416-2-git-send-email-sakari.ailus@linux.intel.com>
References: <1467039471-19416-2-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_PIX_FMT_SBGGR16 format is documented to contain samples of fewer
than 16 bits. However, we do have specific definitions for smaller sample
sizes. Therefore, this note is redundant from the API point of view.

Currently only two drivers, am437x and davinci, use the V4L2_PIX_FMT_SBGGR16
pixelformat currently. The sampling precision is understood to be 16 bits in
all current cases.

Remove the note on sampling precision.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml b/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
index 6494b05..789160565 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
@@ -14,9 +14,7 @@
 linkend="V4L2-PIX-FMT-SBGGR8">
 <constant>V4L2_PIX_FMT_SBGGR8</constant></link>, except each pixel has
 a depth of 16 bits. The least significant byte is stored at lower
-memory addresses (little-endian). Note the actual sampling precision
-may be lower than 16 bits, for example 10 bits per pixel with values
-in range 0 to 1023.</para>
+memory addresses (little-endian).</para>
 
     <example>
       <title><constant>V4L2_PIX_FMT_SBGGR16</constant> 4 &times; 4
-- 
2.7.4

