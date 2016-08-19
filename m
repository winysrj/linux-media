Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43187 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754617AbcHSNFK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:05:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 02/15] [media] vidioc-dv-timings-cap.rst: Adjust LaTeX columns
Date: Fri, 19 Aug 2016 10:04:52 -0300
Message-Id: <7ea42f27863b283b9a5453891b180bdc55932cdb.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some tables are not properly displayed on LaTeX. Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
index e14e780eb0d1..b2bf4f3a3c25 100644
--- a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
@@ -56,7 +56,7 @@ that doesn't support them will return an ``EINVAL`` error code.
 
 .. _v4l2-bt-timings-cap:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+.. tabularcolumns:: |p{1.2cm}|p{3.0cm}|p{13.3cm}|
 
 .. flat-table:: struct v4l2_bt_timings_cap
     :header-rows:  0
@@ -136,14 +136,14 @@ that doesn't support them will return an ``EINVAL`` error code.
 
        -  ``reserved``\ [16]
 
-       -  Reserved for future extensions. Drivers must set the array to
-	  zero.
+       -  Reserved for future extensions.
+	  Drivers must set the array to zero.
 
 
 
 .. _v4l2-dv-timings-cap:
 
-.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{7.0cm}|p{3.5cm}|
+.. tabularcolumns:: |p{1.0cm}|p{3.5cm}|p{3.5cm}|p{9.5cm}|
 
 .. flat-table:: struct v4l2_dv_timings_cap
     :header-rows:  0
@@ -175,8 +175,9 @@ that doesn't support them will return an ``EINVAL`` error code.
 
        -  ``reserved``\ [2]
 
-       -  Reserved for future extensions. Drivers and applications must set
-	  the array to zero.
+       -  Reserved for future extensions.
+
+	  Drivers and applications must set the array to zero.
 
     -  .. row 4
 
@@ -203,6 +204,7 @@ that doesn't support them will return an ``EINVAL`` error code.
 
        -
 
+.. tabularcolumns:: |p{7.0cm}|p{10.5cm}|
 
 
 .. _dv-bt-cap-capabilities:
-- 
2.7.4


