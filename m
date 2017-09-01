Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48338
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752223AbdIATh6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:37:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 01/14] media: dvb uapi docs: better organize header files
Date: Fri,  1 Sep 2017 16:37:37 -0300
Message-Id: <20a109caba32f49fde9e8de35c7efdd4b404fbd5.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of having one chapter per file, place all of them at
the same chapter. That better organize the chapters at the uAPI
documentation.

As a side effect, now all uAPI headers are at the same page,
at the html output, with makes easier to use it as a reference
index for the spec.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/audio_h.rst    |  9 ---------
 Documentation/media/uapi/dvb/ca_h.rst       |  9 ---------
 Documentation/media/uapi/dvb/dmx_h.rst      |  9 ---------
 Documentation/media/uapi/dvb/dvbapi.rst     |  7 +------
 Documentation/media/uapi/dvb/frontend_h.rst |  9 ---------
 Documentation/media/uapi/dvb/headers.rst    | 21 +++++++++++++++++++++
 Documentation/media/uapi/dvb/net_h.rst      |  9 ---------
 Documentation/media/uapi/dvb/video_h.rst    |  9 ---------
 8 files changed, 22 insertions(+), 60 deletions(-)
 delete mode 100644 Documentation/media/uapi/dvb/audio_h.rst
 delete mode 100644 Documentation/media/uapi/dvb/ca_h.rst
 delete mode 100644 Documentation/media/uapi/dvb/dmx_h.rst
 delete mode 100644 Documentation/media/uapi/dvb/frontend_h.rst
 create mode 100644 Documentation/media/uapi/dvb/headers.rst
 delete mode 100644 Documentation/media/uapi/dvb/net_h.rst
 delete mode 100644 Documentation/media/uapi/dvb/video_h.rst

diff --git a/Documentation/media/uapi/dvb/audio_h.rst b/Documentation/media/uapi/dvb/audio_h.rst
deleted file mode 100644
index e00c3010fdf9..000000000000
--- a/Documentation/media/uapi/dvb/audio_h.rst
+++ /dev/null
@@ -1,9 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _audio_h:
-
-*********************
-DVB Audio Header File
-*********************
-
-.. kernel-include:: $BUILDDIR/audio.h.rst
diff --git a/Documentation/media/uapi/dvb/ca_h.rst b/Documentation/media/uapi/dvb/ca_h.rst
deleted file mode 100644
index f513592ef529..000000000000
--- a/Documentation/media/uapi/dvb/ca_h.rst
+++ /dev/null
@@ -1,9 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _ca_h:
-
-**********************************
-DVB Conditional Access Header File
-**********************************
-
-.. kernel-include:: $BUILDDIR/ca.h.rst
diff --git a/Documentation/media/uapi/dvb/dmx_h.rst b/Documentation/media/uapi/dvb/dmx_h.rst
deleted file mode 100644
index 4fd1704a0833..000000000000
--- a/Documentation/media/uapi/dvb/dmx_h.rst
+++ /dev/null
@@ -1,9 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _dmx_h:
-
-*********************
-DVB Demux Header File
-*********************
-
-.. kernel-include:: $BUILDDIR/dmx.h.rst
diff --git a/Documentation/media/uapi/dvb/dvbapi.rst b/Documentation/media/uapi/dvb/dvbapi.rst
index 37680137e3f2..9ca3dd24bd7d 100644
--- a/Documentation/media/uapi/dvb/dvbapi.rst
+++ b/Documentation/media/uapi/dvb/dvbapi.rst
@@ -30,12 +30,7 @@ Part II - Digital TV API
     net
     legacy_dvb_apis
     examples
-    audio_h
-    ca_h
-    dmx_h
-    frontend_h
-    net_h
-    video_h
+    headers
 
 
 **********************
diff --git a/Documentation/media/uapi/dvb/frontend_h.rst b/Documentation/media/uapi/dvb/frontend_h.rst
deleted file mode 100644
index 15fca04d1c32..000000000000
--- a/Documentation/media/uapi/dvb/frontend_h.rst
+++ /dev/null
@@ -1,9 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _frontend_h:
-
-************************
-DVB Frontend Header File
-************************
-
-.. kernel-include:: $BUILDDIR/frontend.h.rst
diff --git a/Documentation/media/uapi/dvb/headers.rst b/Documentation/media/uapi/dvb/headers.rst
new file mode 100644
index 000000000000..c13fd537fbff
--- /dev/null
+++ b/Documentation/media/uapi/dvb/headers.rst
@@ -0,0 +1,21 @@
+****************************
+Digital TV uAPI header files
+****************************
+
+Digital TV uAPI headers
+***********************
+
+.. kernel-include:: $BUILDDIR/frontend.h.rst
+
+.. kernel-include:: $BUILDDIR/dmx.h.rst
+
+.. kernel-include:: $BUILDDIR/ca.h.rst
+
+.. kernel-include:: $BUILDDIR/net.h.rst
+
+Legacy uAPI
+***********
+
+.. kernel-include:: $BUILDDIR/audio.h.rst
+
+.. kernel-include:: $BUILDDIR/video.h.rst
diff --git a/Documentation/media/uapi/dvb/net_h.rst b/Documentation/media/uapi/dvb/net_h.rst
deleted file mode 100644
index 7bcf5ba9d1eb..000000000000
--- a/Documentation/media/uapi/dvb/net_h.rst
+++ /dev/null
@@ -1,9 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _net_h:
-
-***********************
-DVB Network Header File
-***********************
-
-.. kernel-include:: $BUILDDIR/net.h.rst
diff --git a/Documentation/media/uapi/dvb/video_h.rst b/Documentation/media/uapi/dvb/video_h.rst
deleted file mode 100644
index 3f39b0c4879c..000000000000
--- a/Documentation/media/uapi/dvb/video_h.rst
+++ /dev/null
@@ -1,9 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _video_h:
-
-*********************
-DVB Video Header File
-*********************
-
-.. kernel-include:: $BUILDDIR/video.h.rst
-- 
2.13.5
