Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:22301 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870Ab2CFQd2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 11:33:28 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: [PATCH v5 13/35] v4l: Document raw bayer 4CC codes
Date: Tue,  6 Mar 2012 18:32:54 +0200
Message-Id: <1331051596-8261-13-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120306163239.GN1075@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document guidelines how 4CC codes should be named. Only raw bayer is
included currently. Other formats should be documented later on.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/video4linux/4CCs.txt |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/video4linux/4CCs.txt

diff --git a/Documentation/video4linux/4CCs.txt b/Documentation/video4linux/4CCs.txt
new file mode 100644
index 0000000..41241af
--- /dev/null
+++ b/Documentation/video4linux/4CCs.txt
@@ -0,0 +1,32 @@
+Guidelines for Linux4Linux pixel format 4CCs
+============================================
+
+Guidelines for Video4Linux 4CC codes defined using v4l2_fourcc() are
+specified in this document. First of the characters defines the nature of
+the pixel format, compression and colour space. The interpretation of the
+other three characters depends on the first one.
+
+Existing 4CCs may not obey these guidelines.
+
+Formats
+=======
+
+Raw bayer
+---------
+
+The following first characters are used by raw bayer formats:
+
+	B: raw bayer, uncompressed
+	b: raw bayer, DPCM compressed
+	a: A-law compressed
+	u: u-law compressed
+
+2nd character: pixel order
+	B: BGGR
+	G: GBRG
+	g: GRBG
+	R: RGGB
+
+3rd character: uncompressed bits-per-pixel 0--9, A--
+
+4th character: compressed bits-per-pixel 0--9, A--
-- 
1.7.2.5

