Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50918
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752855AbdICCfK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Sep 2017 22:35:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 03/12] media: vidioc-g-tuner.rst: Fix table number of cols
Date: Sat,  2 Sep 2017 23:34:55 -0300
Message-Id: <792e51cd3047467692c4e3c39572950ba342ecdf.1504405125.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Tuner Audio Matrix table is broken: the first row has 7
columns instead of 6, causing it to be parsed wrong and displayed
very badly on PDF output.

Fix it and adjust the table to look nice at PDF output

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index 491866484f57..acdd15901a51 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -395,20 +395,23 @@ To change the radio frequency the
 
     \scriptsize
 
+.. tabularcolumns:: |p{1.5cm}|p{1.5cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|
+
 .. _tuner-matrix:
 
 .. flat-table:: Tuner Audio Matrix
     :header-rows:  2
     :stub-columns: 0
+    :widths: 7 7 14 14 14 14
 
     * -
-      - :cspan:`5` Selected ``V4L2_TUNER_MODE_``
+      - :cspan:`4` Selected ``V4L2_TUNER_MODE_``
     * - Received ``V4L2_TUNER_SUB_``
       - ``MONO``
       - ``STEREO``
       - ``LANG1``
       - ``LANG2 = SAP``
-      - ``LANG1_LANG2``\  [#f1]_
+      - ``LANG1_LANG2``\ [#f1]_
     * - ``MONO``
       - Mono
       - Mono/Mono
@@ -435,7 +438,7 @@ To change the radio frequency the
       - L+R/SAP (preferred) or L/R or L+R/L+R
     * - ``LANG1 | LANG2``
       - Language 1
-      - Lang1/Lang2 (deprecated [#f2]_) or Lang1/Lang1
+      - Lang1/Lang2 (deprecated\ [#f2]_) or Lang1/Lang1
       - Language 1
       - Language 2
       - Lang1/Lang2 (preferred) or Lang1/Lang1
-- 
2.13.5
