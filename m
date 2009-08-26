Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53525 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752565AbZHZSQC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 14:16:02 -0400
Date: Wed, 26 Aug 2009 20:16:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Document the new V4L2_CID_BAND_STOP_FILTER control
Message-ID: <Pine.LNX.4.64.0908262014100.7670@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2 API documentation for the new V4L2_CID_BAND_STOP_FILTER control

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff -r 3489b2efe4b0 v4l2-spec/controls.sgml
--- a/v4l2-spec/controls.sgml	Tue Aug 25 16:53:23 2009 +0200
+++ b/v4l2-spec/controls.sgml	Wed Aug 26 19:59:36 2009 +0200
@@ -1811,6 +1811,14 @@ device is not restricted to these method
 device is not restricted to these methods. Devices that implement the privacy
 control must support read access and may support write access.</entry>
 	  </row>
+
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_BAND_STOP_FILTER</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row><row><entry spanname="descr">Switch the band-stop filter of a
+camera sensor on or off, or specify its strength. Such band-stop filters can
+be used, for example, to filter out the fluorescent light component.</entry>
+	  </row>
 	  <row><entry></entry></row>
 	</tbody>
       </tgroup>
diff -r 3489b2efe4b0 v4l2-spec/v4l2.sgml
--- a/v4l2-spec/v4l2.sgml	Tue Aug 25 16:53:23 2009 +0200
+++ b/v4l2-spec/v4l2.sgml	Wed Aug 26 19:59:36 2009 +0200
@@ -25,7 +25,7 @@
 <book id="v4l2spec">
   <bookinfo>
     <title>Video for Linux Two API Specification</title>
-    <subtitle>Revision 0.27</subtitle>
+    <subtitle>Revision 0.28</subtitle>
 
     <authorgroup>
       <author>
@@ -142,6 +142,13 @@ structs, ioctls) must be noted in more d
 structs, ioctls) must be noted in more detail in the history chapter
 (compat.sgml), along with the possible impact on existing drivers and
 applications. -->
+
+      <revision>
+	<revnumber>0.28</revnumber>
+	<date>2009-08-26</date>
+	<authorinitials>gl</authorinitials>
+	<revremark>Added V4L2_CID_BAND_STOP_FILTER documentation.</revremark>
+      </revision>
 
       <revision>
 	<revnumber>0.27</revnumber>
