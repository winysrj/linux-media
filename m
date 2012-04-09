Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34517 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab2DINck (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2012 09:32:40 -0400
Received: by wejx9 with SMTP id x9so2627613wej.19
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2012 06:32:39 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH] V4L: DocBook: Fix typos in the multi-plane formats description
Date: Mon,  9 Apr 2012 15:31:56 +0200
Message-Id: <1333978316-28192-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml   |    2 +-
 Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml b/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
index 3fd3ce5..5274c24 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
@@ -1,6 +1,6 @@
     <refentry id="V4L2-PIX-FMT-NV12M">
       <refmeta>
-	<refentrytitle>V4L2_PIX_FMT_NV12M ('NV12M')</refentrytitle>
+	<refentrytitle>V4L2_PIX_FMT_NV12M ('NM12')</refentrytitle>
 	&manvol;
       </refmeta>
       <refnamediv>
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
index 9957863..60308f1 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
@@ -1,6 +1,6 @@
     <refentry id="V4L2-PIX-FMT-YUV420M">
       <refmeta>
-	<refentrytitle>V4L2_PIX_FMT_YUV420M ('YU12M')</refentrytitle>
+	<refentrytitle>V4L2_PIX_FMT_YUV420M ('YM12')</refentrytitle>
 	&manvol;
       </refmeta>
       <refnamediv>
-- 
1.7.4.1

