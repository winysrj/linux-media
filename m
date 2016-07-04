Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbcGDLr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 30/51] Documentation: linux_tv: Fix remaining undefined references
Date: Mon,  4 Jul 2016 08:46:51 -0300
Message-Id: <80c5dbb43cd911638bb864bcdab4f84162bd968c.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix Sphinx those warnings:
	WARNING: undefined label: fdl-modified>`as given on the :ref:`title page <fdl-title-page (if the link has no caption the label must precede a section header)
	WARNING: undefined label: v4l2-pix-fmt-yuv420 (if the link has no caption the label must precede a section $
	WARNING: undefined label: pixfmt-srggb10 (if the link has no caption the label must precede a section heade$

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/fdl-appendix.rst        | 2 +-
 Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst | 2 +-
 Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst       | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/fdl-appendix.rst b/Documentation/linux_tv/media/v4l/fdl-appendix.rst
index 4a7be9b00670..cb0704883744 100644
--- a/Documentation/linux_tv/media/v4l/fdl-appendix.rst
+++ b/Documentation/linux_tv/media/v4l/fdl-appendix.rst
@@ -246,7 +246,7 @@ Modified Version:
 
    Preserve the section entitled “History”, and its title, and add to it
    an item stating at least the title, year, new authors, and publisher
-   of the :ref:`Modified Version <fdl-modified>`as given on the
+   of the :ref:`Modified Version <fdl-modified>` as given on the
    :ref:`Title Page <fdl-title-page>`. If there is no section entitled
    “History” in the :ref:`Document <fdl-document>`, create one stating
    the title, year, authors, and publisher of the Document as given on
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst
index 581ab5190246..03a27c43be21 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst
@@ -21,7 +21,7 @@ These four pixel formats are raw sRGB / Bayer formats with 10 bits per
 colour compressed to 8 bits each, using DPCM compression. DPCM,
 differential pulse-code modulation, is lossy. Each colour component
 consumes 8 bits of memory. In other respects this format is similar to
-:ref:`pixfmt-srggb10`.
+:ref:`V4L2-PIX-FMT-SRGGB10`.
 
 
 .. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst
index dcf3a176d1ba..0dd7e4632dd9 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst
@@ -1,6 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-YVU420:
+.. _V4L2-PIX-FMT-YUV420:
 
 **********************************************************
 V4L2_PIX_FMT_YVU420 ('YV12'), V4L2_PIX_FMT_YUV420 ('YU12')
-- 
2.7.4


