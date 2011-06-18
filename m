Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53760 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab1FRIwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 04:52:49 -0400
Received: by eyx24 with SMTP id 24so66714eyx.19
        for <linux-media@vger.kernel.org>; Sat, 18 Jun 2011 01:52:48 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH] v4l: Fix minor typos in the documentation
Date: Sat, 18 Jun 2011 10:52:21 +0200
Message-Id: <1308387141-12395-1-git-send-email-snjw23@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 .../DocBook/media/v4l/media-ioc-enum-links.xml     |    2 +-
 Documentation/DocBook/media/v4l/subdev-formats.xml |    2 +-
 Documentation/media-framework.txt                  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
index d2fc73e..355df43 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
@@ -139,7 +139,7 @@
     </table>
 
     <table pgwide="1" frame="none" id="media-link-desc">
-      <title>struct <structname>media_links_desc</structname></title>
+      <title>struct <structname>media_link_desc</structname></title>
       <tgroup cols="3">
         &cs-str;
 	<tbody valign="top">
diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 8d3409d..383b88e 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -2528,7 +2528,7 @@
 
       <para>Those data formats consist of an ordered sequence of 8-bit bytes
 	obtained from JPEG compression process. Additionally to the
-	<constant>_JPEG</constant> prefix the format code is made of
+	<constant>_JPEG</constant> postfix the format code is made of
 	the following information.
 	<itemizedlist>
 	  <listitem><para>The number of bus samples per entropy encoded byte.</para></listitem>
diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index 76a2087..669b5fb 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -310,7 +310,7 @@ is non-immutable. The operation must either configure the hardware or store
 the configuration information to be applied later.
 
 Link configuration must not have any side effect on other links. If an enabled
-link at a sink pad prevents another link at the same pad from being disabled,
+link at a sink pad prevents another link at the same pad from being enabled,
 the link_setup operation must return -EBUSY and can't implicitly disable the
 first enabled link.
 
-- 
1.7.1

