Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35697 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754618AbcHSDqv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:46:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 18/20] [media] dev-subdev.rst: make table fully visible on LaTeX
Date: Thu, 18 Aug 2016 13:15:47 -0300
Message-Id: <546a6ac8213037d3f5144b56bcb62961501fdf24.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The table there is too big and doesn't have format hints for
LaTeX output.

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/dev-subdev.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
index 5a112eb7a245..b1aed4541bca 100644
--- a/Documentation/media/uapi/v4l/dev-subdev.rst
+++ b/Documentation/media/uapi/v4l/dev-subdev.rst
@@ -204,9 +204,16 @@ list entity names and pad numbers).
 
 .. _sample-pipeline-config:
 
+.. raw:: latex
+
+    \newline\newline\begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|
+
 .. flat-table:: Sample Pipeline Configuration
     :header-rows:  1
     :stub-columns: 0
+    :widths: 5 5 5 5 5 5 5
 
 
     -  .. row 1
@@ -288,7 +295,9 @@ list entity names and pad numbers).
 
        -  *1280x960/SGRBG8_1X8*
 
+.. raw:: latex
 
+    \end{adjustbox}\newline\newline
 
 1. Initial state. The sensor source pad format is set to its native 3MP
    size and V4L2_MBUS_FMT_SGRBG8_1X8 media bus code. Formats on the
-- 
2.7.4


