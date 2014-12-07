Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43945 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752703AbaLGXXn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Dec 2014 18:23:43 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: aviv.d.greenberg@intel.com
Subject: [REVIEW PATCH v2 1/3] DocBook: v4l: Fix raw bayer pixel format documentation wording
Date: Mon,  8 Dec 2014 01:22:20 +0200
Message-Id: <1417994542-25826-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1417994542-25826-1-git-send-email-sakari.ailus@iki.fi>
References: <1417994542-25826-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation began with "The following four pixel formats"... but the
format definitions preceded this sentence. Replace it with "These four pixel
formats".

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/DocBook/media/v4l/pixfmt-srggb10.xml      |    2 +-
 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml |    2 +-
 Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml |    2 +-
 Documentation/DocBook/media/v4l/pixfmt-srggb12.xml      |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
index c1c62a9..f34d03e 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
@@ -17,7 +17,7 @@
       <refsect1>
 	<title>Description</title>
 
-	<para>The following four pixel formats are raw sRGB / Bayer formats with
+	<para>These four pixel formats are raw sRGB / Bayer formats with
 10 bits per colour. Each colour component is stored in a 16-bit word, with 6
 unused high bits filled with zeros. Each n-pixel row contains n/2 green samples
 and n/2 blue or red samples, with alternating red and blue rows. Bytes are
diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
index 29acc20..d2e5845 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
@@ -25,7 +25,7 @@
 	  </refnamediv>
 	  <refsect1>
 	    <title>Description</title>
-	    <para>The following four pixel formats are raw sRGB / Bayer
+	    <para>These four pixel formats are raw sRGB / Bayer
 	    formats with 10 bits per color compressed to 8 bits each,
 	    using the A-LAW algorithm. Each color component consumes 8
 	    bits of memory. In other respects this format is similar to
diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
index 2d3f0b1a..bde8987 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
@@ -18,7 +18,7 @@
       <refsect1>
 	<title>Description</title>
 
-	<para>The following four pixel formats are raw sRGB / Bayer formats
+	<para>These four pixel formats are raw sRGB / Bayer formats
 	with 10 bits per colour compressed to 8 bits each, using DPCM
 	compression. DPCM, differential pulse-code modulation, is lossy.
 	Each colour component consumes 8 bits of memory. In other respects
diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
index 96947f1..0c8e4ad 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
@@ -17,7 +17,7 @@
       <refsect1>
 	<title>Description</title>
 
-	<para>The following four pixel formats are raw sRGB / Bayer formats with
+	<para>These four pixel formats are raw sRGB / Bayer formats with
 12 bits per colour. Each colour component is stored in a 16-bit word, with 4
 unused high bits filled with zeros. Each n-pixel row contains n/2 green samples
 and n/2 blue or red samples, with alternating red and blue rows. Bytes are
-- 
1.7.10.4

