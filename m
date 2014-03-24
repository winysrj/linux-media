Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33967 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaCXMq0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 08:46:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] Documentation: media: Remove double 'struct'
Date: Mon, 24 Mar 2014 13:48:13 +0100
Message-Id: <1395665293-4498-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The XML entities for media structures start with the 'struct' word.
Remove duplicate 'struct' from the entity users.

Reported-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/io.xml                   | 2 +-
 Documentation/DocBook/media/v4l/media-ioc-enum-links.xml | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 97a69bf..2955d13 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -125,7 +125,7 @@ location of the buffers in device memory can be determined with the
 <structfield>m.offset</structfield> and <structfield>length</structfield>
 returned in a &v4l2-buffer; are passed as sixth and second parameter to the
 <function>mmap()</function> function. When using the multi-planar API,
-struct &v4l2-buffer; contains an array of &v4l2-plane; structures, each
+&v4l2-buffer; contains an array of &v4l2-plane; structures, each
 containing its own <structfield>m.offset</structfield> and
 <structfield>length</structfield>. When using the multi-planar API, every
 plane of every buffer has to be mapped separately, so the number of
diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
index cf85485..74fb394 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
@@ -79,13 +79,13 @@
 	    <entry>Entity id, set by the application.</entry>
 	  </row>
 	  <row>
-	    <entry>struct &media-pad-desc;</entry>
+	    <entry>&media-pad-desc;</entry>
 	    <entry>*<structfield>pads</structfield></entry>
 	    <entry>Pointer to a pads array allocated by the application. Ignored
 	    if NULL.</entry>
 	  </row>
 	  <row>
-	    <entry>struct &media-link-desc;</entry>
+	    <entry>&media-link-desc;</entry>
 	    <entry>*<structfield>links</structfield></entry>
 	    <entry>Pointer to a links array allocated by the application. Ignored
 	    if NULL.</entry>
@@ -153,12 +153,12 @@
         &cs-str;
 	<tbody valign="top">
 	  <row>
-	    <entry>struct &media-pad-desc;</entry>
+	    <entry>&media-pad-desc;</entry>
 	    <entry><structfield>source</structfield></entry>
 	    <entry>Pad at the origin of this link.</entry>
 	  </row>
 	  <row>
-	    <entry>struct &media-pad-desc;</entry>
+	    <entry>&media-pad-desc;</entry>
 	    <entry><structfield>sink</structfield></entry>
 	    <entry>Pad at the target of this link.</entry>
 	  </row>
-- 
Regards,

Laurent Pinchart

