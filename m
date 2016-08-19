Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43170 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754557AbcHSNFK (ORCPT
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
Subject: [PATCH 06/15] [media] vidioc-g-tuner.rst: improve documentation for tuner type
Date: Fri, 19 Aug 2016 10:04:56 -0300
Message-Id: <1534569abcf4a05181a7fd552aa23050f397af63.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tuner type table misses descriptions for each type. While
most of stuff are obvious, the two SDR definitions aren't.

So, add descriptions to all of them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index 762918a1e58a..740a4dd0db00 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -260,7 +260,7 @@ To change the radio frequency the
 .. flat-table:: enum v4l2_tuner_type
     :header-rows:  0
     :stub-columns: 0
-    :widths:       3 1 4
+    :widths:       3 1 6
 
 
     -  .. row 1
@@ -269,7 +269,7 @@ To change the radio frequency the
 
        -  1
 
-       -
+       - Tuner supports radio
 
     -  .. row 2
 
@@ -277,7 +277,7 @@ To change the radio frequency the
 
        -  2
 
-       -
+       - Tuner supports analog TV
 
     -  .. row 3
 
@@ -285,7 +285,8 @@ To change the radio frequency the
 
        -  4
 
-       -
+       - Tuner controls the A/D and/or D/A block of a
+	 Sofware Digital Radio (SDR)
 
     -  .. row 4
 
@@ -293,8 +294,7 @@ To change the radio frequency the
 
        -  5
 
-       -
-
+       - Tuner controls the RF part of a Sofware Digital Radio (SDR)
 
 
 .. _tuner-capability:
-- 
2.7.4


