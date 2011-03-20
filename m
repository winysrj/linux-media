Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62531 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab1CTXfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Mar 2011 19:35:21 -0400
Received: by pwi15 with SMTP id 15so693171pwi.19
        for <linux-media@vger.kernel.org>; Sun, 20 Mar 2011 16:35:20 -0700 (PDT)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>
Subject: [PATCH] [media] Make 2.6.39 not 2.6.38 the version when Multi-planar API was added
Date: Sun, 20 Mar 2011 16:35:12 -0700
Message-Id: <1300664112-24910-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Multi-planar API was added to 2.6.39 version of Video for Linux 2 API.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
---
 Documentation/DocBook/v4l/compat.xml |   13 ++++---------
 Documentation/DocBook/v4l/v4l2.xml   |   13 ++-----------
 2 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/Documentation/DocBook/v4l/compat.xml b/Documentation/DocBook/v4l/compat.xml
index 4d74bf2..9f7cd4f 100644
--- a/Documentation/DocBook/v4l/compat.xml
+++ b/Documentation/DocBook/v4l/compat.xml
@@ -2354,9 +2354,12 @@ that used it. It was originally scheduled for removal in 2.6.35.
       </orderedlist>
     </section>
     <section>
-      <title>V4L2 in Linux 2.6.38</title>
+      <title>V4L2 in Linux 2.6.39</title>
       <orderedlist>
         <listitem>
+          <para>The old VIDIOC_*_OLD symbols and V4L1 support were removed.</para>
+        </listitem>
+        <listitem>
           <para>Multi-planar API added. Does not affect the compatibility of
           current drivers and applications. See
           <link linkend="planar-apis">multi-planar API</link>
@@ -2364,14 +2367,6 @@ that used it. It was originally scheduled for removal in 2.6.35.
         </listitem>
       </orderedlist>
     </section>
-    <section>
-      <title>V4L2 in Linux 2.6.39</title>
-      <orderedlist>
-        <listitem>
-          <para>The old VIDIOC_*_OLD symbols and V4L1 support were removed.</para>
-        </listitem>
-      </orderedlist>
-    </section>
 
     <section id="other">
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
diff --git a/Documentation/DocBook/v4l/v4l2.xml b/Documentation/DocBook/v4l/v4l2.xml
index ae7a069..a7fd76d 100644
--- a/Documentation/DocBook/v4l/v4l2.xml
+++ b/Documentation/DocBook/v4l/v4l2.xml
@@ -130,17 +130,8 @@ applications. -->
       <revision>
 	<revnumber>2.6.39</revnumber>
 	<date>2011-03-01</date>
-	<authorinitials>mcc</authorinitials>
-	<revremark>Removed VIDIOC_*_OLD from videodev2.h header and update it to reflect latest changes.
-	</revremark>
-      </revision>
-
-      <revision>
-	<revnumber>2.6.38</revnumber>
-	<date>2011-01-16</date>
-	<authorinitials>po</authorinitials>
-	<revremark>Added the <link linkend="planar-apis">multi-planar API</link>.
-	</revremark>
+	<authorinitials>mcc, po</authorinitials>
+	<revremark>Removed VIDIOC_*_OLD from videodev2.h header and update it to reflect latest changes. Added the <link linkend="planar-apis">multi-planar API</link>.</revremark>
       </revision>
 
       <revision>
-- 
1.7.4.1

