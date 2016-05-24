Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36539 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473AbcEXQvC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:51:02 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC v2 21/21] DocBook: media: Document request flags
Date: Tue, 24 May 2016 19:47:31 +0300
Message-Id: <1464108451-28142-22-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../DocBook/media/v4l/media-ioc-request-cmd.xml    | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/media-ioc-request-cmd.xml b/Documentation/DocBook/media/v4l/media-ioc-request-cmd.xml
index 4f4acea..14c0068 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-request-cmd.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-request-cmd.xml
@@ -132,6 +132,13 @@
 	    <constant>MEDIA_REQ_CMD_ALLOC</constant> and by the application
 	    for all other commands.</entry>
 	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+	    <entry>Flags related to a request. See <xref
+	    linkend="media-request-flags" /> for the list of
+	    flags.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
@@ -161,6 +168,23 @@
 	</tbody>
       </tgroup>
     </table>
+
+    <table frame="none" pgwide="1" id="media-request-flags">
+      <title>Media request flags</title>
+      <tgroup cols="2">
+        <colspec colname="c1"/>
+        <colspec colname="c2"/>
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>MEDIA_REQ_FL_COMPLETE_EVENT</constant></entry>
+	    <entry>Queue and event to the file handle on request
+	    completion. This flag is relevant for
+	    <constant>MEDIA_REQ_CMD_APPLY</constant> and
+	    <constant>MEDIA_REQ_CMD_QUEUE</constant> commands.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
   </refsect1>
 
   <refsect1>
-- 
1.9.1

