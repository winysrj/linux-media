Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50924
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752856AbdICCfK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Sep 2017 22:35:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 05/12] media: docs: fix PDF build with Sphinx 1.4
Date: Sat,  2 Sep 2017 23:34:57 -0300
Message-Id: <63c085f9ab9e44c190353e015b46c3b2dfa0821c.1504405125.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset 70b074df4ed1 ("media: fix pdf build with Spinx 1.6") caused
a regression at Sphinx 1.4 PDF build: although it produces a full
document in batch mode, it returns errors on interactive mode:

	[63]
	Runaway argument?
	{\relax
	! Paragraph ended before \multicolumn was complete.
	<to be read again>
	                   \par
	l.7703 \hline\end{tabulary}

The error seems to be due to some bug at Sphinx PDF output:
when multicolumns is used, it doesn't accept an empty string.

Just removing the :cpan:`1` and replacing by two empty
columns fix the issue.

Fixes: 70b074df4ed1 ("media: fix pdf build with Spinx 1.6")

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst | 6 ++++--
 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
index bb85abcfceb5..4938d9655a41 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
@@ -35,7 +35,8 @@ next to each other in memory.
       - :cspan:`7` Byte 1
       - :cspan:`7` Byte 2
       - :cspan:`7` Byte 3
-    * - :cspan:`1`
+    * -
+      -
       - 7
       - 6
       - 5
@@ -665,7 +666,8 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - :cspan:`7` Byte 2
 
       - :cspan:`7` Byte 3
-    * - :cspan:`1`
+    * -
+      -
       - 7
       - 6
       - 5
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst b/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
index d6a6e890f5a9..d7644b411ccc 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
@@ -37,7 +37,8 @@ component of each pixel in one 16 or 32 bit word.
       - :cspan:`7` Byte 2
 
       - :cspan:`7` Byte 3
-    * - :cspan:`1`
+    * -
+      -
       - 7
       - 6
       - 5
-- 
2.13.5
