Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:58369 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933275AbbEOM3a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 08:29:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/6] DocBook/media: document COLORSPACE_DEFAULT
Date: Fri, 15 May 2015 14:29:06 +0200
Message-Id: <1431692950-17453-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1431692950-17453-1-git-send-email-hverkuil@xs4all.nl>
References: <1431692950-17453-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document this new colorspace define.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index fcde4e2..e6d2d42 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -498,6 +498,11 @@ BT.2020 which uses limited range R'G'B' quantization.</para>
 	</thead>
 	<tbody valign="top">
 	  <row>
+	    <entry><constant>V4L2_COLORSPACE_DEFAULT</constant></entry>
+	    <entry>The default colorspace. This can be used by applications to let the
+	    driver fill in the colorspace.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_COLORSPACE_SMPTE170M</constant></entry>
 	    <entry>See <xref linkend="col-smpte-170m" />.</entry>
 	  </row>
-- 
2.1.4

