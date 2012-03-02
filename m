Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:28015 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab2CBRcz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 12:32:55 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v4 13/34] v4l: Document raw bayer 4CC codes
Date: Fri,  2 Mar 2012 19:30:21 +0200
Message-Id: <1330709442-16654-13-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120302173219.GA15695@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
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

