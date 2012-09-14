Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:23132 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab2INK6D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:58:03 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqBm013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:57:56 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 17/31] DocBook: clarify that sequence is also set for output devices.
Date: Fri, 14 Sep 2012 12:57:32 +0200
Message-Id: <43be7ce4539b2bb5cf7715af61c59186803e9d8b.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It was not entirely obvious that the sequence count should also
be set for output devices. Also made it more explicit that this
sequence counter counts frames, not fields.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 Documentation/DocBook/media/v4l/io.xml |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index b680d66..c32cb0a 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -617,8 +617,8 @@ field is independent of the <structfield>timestamp</structfield> and
 	    <entry>__u32</entry>
 	    <entry><structfield>sequence</structfield></entry>
 	    <entry></entry>
-	    <entry>Set by the driver, counting the frames in the
-sequence.</entry>
+	    <entry>Set by the driver, counting the frames (not fields!) in
+sequence. This field is set for both input and output devices.</entry>
 	  </row>
 	  <row>
 	    <entry spanname="hspan"><para>In <link
-- 
1.7.10.4

