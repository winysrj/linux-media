Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52282
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751543AbdICTEA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 15:04:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/7] media: v4l2 uapi book: get rid of driver programming's chapter
Date: Sun,  3 Sep 2017 16:03:48 -0300
Message-Id: <62d228052167c816cebc3ad5d241c51c1ca656e5.1504464984.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504464984.git.mchehab@s-opensource.com>
References: <cover.1504464984.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504464984.git.mchehab@s-opensource.com>
References: <cover.1504464984.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It doesn't make any sense having a driver programming's chapter
at the uAPI book, as this is related to kernel API. Also,
we now have such kAPI book where V4L2 driver programming is covered.

So, get rid of this left-over.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/driver.rst | 9 ---------
 Documentation/media/uapi/v4l/v4l2.rst   | 1 -
 2 files changed, 10 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/driver.rst

diff --git a/Documentation/media/uapi/v4l/driver.rst b/Documentation/media/uapi/v4l/driver.rst
deleted file mode 100644
index 2319b383f0a4..000000000000
--- a/Documentation/media/uapi/v4l/driver.rst
+++ /dev/null
@@ -1,9 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _driver:
-
-***********************
-V4L2 Driver Programming
-***********************
-
-to do
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index 297c293d4c93..2128717299b3 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -25,7 +25,6 @@ This part describes the Video for Linux API version 2 (V4L2 API) specification.
     pixfmt
     io
     devices
-    driver
     libv4l
     compat
     user-func
-- 
2.13.5
