Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1410 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbcEFK4n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 06:56:43 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC 22/22] DocBook: media: Document request flags
Date: Fri,  6 May 2016 13:53:31 +0300
Message-Id: <1462532011-15527-23-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
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

