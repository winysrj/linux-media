Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1534 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795Ab2IGN3l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 14/28] DocBook: clarify that sequence is also set for output devices.
Date: Fri,  7 Sep 2012 15:29:14 +0200
Message-Id: <218a8f843734b9b2572842bc817ed36970931c24.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It was not entirely obvious that the sequence count should also
be set for output devices. Also made it more explicit that this
sequence counter counts frames, not fields.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/io.xml |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index b680d66..d1c2369 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -617,8 +617,8 @@ field is independent of the <structfield>timestamp</structfield> and
 	    <entry>__u32</entry>
 	    <entry><structfield>sequence</structfield></entry>
 	    <entry></entry>
-	    <entry>Set by the driver, counting the frames in the
-sequence.</entry>
+	    <entry>Set by the driver, counting the frames (not fields!) in the
+sequence. This field is set for both input and output devices.</entry>
 	  </row>
 	  <row>
 	    <entry spanname="hspan"><para>In <link
-- 
1.7.10.4

