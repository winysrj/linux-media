Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52276
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751389AbdICTEA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 15:04:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Aviv Greenberg <aviv.d.greenberg@intel.com>
Subject: [PATCH 5/7] media: fix build breakage with Sphinx 1.6
Date: Sun,  3 Sep 2017 16:03:51 -0300
Message-Id: <82fc5322d611390dca21f28e3fd5f7cbe0c27be4.1504464984.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504464984.git.mchehab@s-opensource.com>
References: <cover.1504464984.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504464984.git.mchehab@s-opensource.com>
References: <cover.1504464984.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not sure why, but, on this particular document, on Sphinx 1.4 and 1.5,
the usage of \small here causes it to write the table at the same
column where the text before it ended, with makes the table to
go out of the page.

A possible solution would be to add a \newline on latex raw,
with was the approach took.

Unfortunately, that causes a breakage on Sphinx 1.6.

So, we're adding a small dot here, in order to avoid polluting
too much the document, while making it compatible with all versions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
index 9e52610aa954..aa3dbf163b97 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
@@ -33,10 +33,22 @@ of a small V4L2_PIX_FMT_SBGGR10P image:
 **Byte Order.**
 Each cell is one byte.
 
-
 .. raw:: latex
 
-    \newline\small
+    \small
+
+.. HACK:
+
+   On Sphinx 1.4 and 1.5, the usage of \small just before the table
+   causes it to continue at the same column where the above text ended.
+
+   A possible solution would be to add a \newline on latex raw.
+   Unfortunately, that causes a breakage on Sphinx 1.6.
+
+   So, we're placing the \small before this note, with should be producing
+   the same result on all versions
+
+.
 
 .. tabularcolumns:: |p{2.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{10.0cm}|
 
-- 
2.13.5
