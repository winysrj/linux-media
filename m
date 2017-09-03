Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52303
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751766AbdICTEB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 15:04:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 6/7] media: pixfmt*.rst: replace a two dots by a comma
Date: Sun,  3 Sep 2017 16:03:52 -0300
Message-Id: <0e43c3db0c0db61f65afba8354fbbd61fe4e0e55.1504464984.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504464984.git.mchehab@s-opensource.com>
References: <cover.1504464984.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504464984.git.mchehab@s-opensource.com>
References: <cover.1504464984.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On several tables, the color sample location table preamble is
written as:
	Color Sample Location..
Instead of:
	Color Sample Location:

I suspect that the repetition of such pattern was due to some
copy-and-paste (or perhaps some error during DocBook conversion).

Anyway, fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/pixfmt-m420.rst    | 2 +-
 Documentation/media/uapi/v4l/pixfmt-nv12.rst    | 2 +-
 Documentation/media/uapi/v4l/pixfmt-nv12m.rst   | 2 +-
 Documentation/media/uapi/v4l/pixfmt-nv16.rst    | 2 +-
 Documentation/media/uapi/v4l/pixfmt-nv16m.rst   | 2 +-
 Documentation/media/uapi/v4l/pixfmt-uyvy.rst    | 2 +-
 Documentation/media/uapi/v4l/pixfmt-vyuy.rst    | 2 +-
 Documentation/media/uapi/v4l/pixfmt-y41p.rst    | 2 +-
 Documentation/media/uapi/v4l/pixfmt-yuv410.rst  | 2 +-
 Documentation/media/uapi/v4l/pixfmt-yuv411p.rst | 2 +-
 Documentation/media/uapi/v4l/pixfmt-yuv420.rst  | 2 +-
 Documentation/media/uapi/v4l/pixfmt-yuv420m.rst | 2 +-
 Documentation/media/uapi/v4l/pixfmt-yuv422m.rst | 2 +-
 Documentation/media/uapi/v4l/pixfmt-yuv422p.rst | 2 +-
 Documentation/media/uapi/v4l/pixfmt-yuv444m.rst | 2 +-
 Documentation/media/uapi/v4l/pixfmt-yuyv.rst    | 2 +-
 Documentation/media/uapi/v4l/pixfmt-yvyu.rst    | 2 +-
 17 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-m420.rst b/Documentation/media/uapi/v4l/pixfmt-m420.rst
index 7dd47c071e2f..6703f4079c3e 100644
--- a/Documentation/media/uapi/v4l/pixfmt-m420.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-m420.rst
@@ -66,7 +66,7 @@ Each cell is one byte.
       - Cr\ :sub:`11`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12.rst b/Documentation/media/uapi/v4l/pixfmt-nv12.rst
index 5b45a6d2ac95..2776b41377d5 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv12.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv12.rst
@@ -71,7 +71,7 @@ Each cell is one byte.
       - Cr\ :sub:`11`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 .. flat-table::
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12m.rst b/Documentation/media/uapi/v4l/pixfmt-nv12m.rst
index de3051fd6b50..c1a2779f604c 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv12m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv12m.rst
@@ -83,7 +83,7 @@ Each cell is one byte.
       - Cr\ :sub:`11`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv16.rst b/Documentation/media/uapi/v4l/pixfmt-nv16.rst
index 8ceba79ff636..f0fdad3006cf 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv16.rst
@@ -79,7 +79,7 @@ Each cell is one byte.
       - Cr\ :sub:`31`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv16m.rst b/Documentation/media/uapi/v4l/pixfmt-nv16m.rst
index 4d46ab39f9f1..c45f036763e7 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv16m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv16m.rst
@@ -83,7 +83,7 @@ Each cell is one byte.
       - Cr\ :sub:`32`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-uyvy.rst b/Documentation/media/uapi/v4l/pixfmt-uyvy.rst
index 30660e04dd0e..ecdc2d94c209 100644
--- a/Documentation/media/uapi/v4l/pixfmt-uyvy.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-uyvy.rst
@@ -65,7 +65,7 @@ Each cell is one byte.
       - Y'\ :sub:`33`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-vyuy.rst b/Documentation/media/uapi/v4l/pixfmt-vyuy.rst
index a3f61f280b94..670c339c1714 100644
--- a/Documentation/media/uapi/v4l/pixfmt-vyuy.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-vyuy.rst
@@ -65,7 +65,7 @@ Each cell is one byte.
       - Y'\ :sub:`33`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 .. flat-table::
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/pixfmt-y41p.rst b/Documentation/media/uapi/v4l/pixfmt-y41p.rst
index 05d040c46a47..e1fe548807a4 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y41p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y41p.rst
@@ -88,7 +88,7 @@ Each cell is one byte.
       - Y'\ :sub:`37`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 .. flat-table::
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv410.rst b/Documentation/media/uapi/v4l/pixfmt-yuv410.rst
index 0c49915af850..b51a0d1c6108 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv410.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv410.rst
@@ -67,7 +67,7 @@ Each cell is one byte.
       - Cb\ :sub:`00`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst b/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
index 2cf33fad7254..2582341972db 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
@@ -75,7 +75,7 @@ Each cell is one byte.
       - Cr\ :sub:`30`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv420.rst b/Documentation/media/uapi/v4l/pixfmt-yuv420.rst
index fd98904058ed..a9b85c4b1dbc 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv420.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv420.rst
@@ -76,7 +76,7 @@ Each cell is one byte.
       - Cb\ :sub:`11`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
index cce8c477fdfc..32c68c33f2b1 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
@@ -85,7 +85,7 @@ Each cell is one byte.
       - Cr\ :sub:`11`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
index d986393aa934..9e7028c4967c 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
@@ -96,7 +96,7 @@ Each cell is one byte.
       - Cr\ :sub:`31`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst b/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
index e6f5de546dba..a96f836c7fa5 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
@@ -84,7 +84,7 @@ Each cell is one byte.
       - Cr\ :sub:`31`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
index 830fbf6fcd1d..8605bfaee112 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
@@ -106,7 +106,7 @@ Each cell is one byte.
       - Cr\ :sub:`33`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuyv.rst b/Documentation/media/uapi/v4l/pixfmt-yuyv.rst
index e1bdd6b1aefc..53e876d053fb 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuyv.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuyv.rst
@@ -68,7 +68,7 @@ Each cell is one byte.
       - Cr\ :sub:`31`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-yvyu.rst b/Documentation/media/uapi/v4l/pixfmt-yvyu.rst
index 0244ce6741a6..b9c31746e565 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yvyu.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yvyu.rst
@@ -65,7 +65,7 @@ Each cell is one byte.
       - Cb\ :sub:`31`
 
 
-**Color Sample Location..**
+**Color Sample Location:**
 
 .. flat-table::
     :header-rows:  0
-- 
2.13.5
