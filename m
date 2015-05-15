Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:58369 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934489AbbEOM3d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 08:29:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/6] DocBook/media: document COLORSPACE_RAW.
Date: Fri, 15 May 2015 14:29:08 +0200
Message-Id: <1431692950-17453-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1431692950-17453-1-git-send-email-hverkuil@xs4all.nl>
References: <1431692950-17453-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document this new colorspace define.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index e6d2d42..0dae181 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -538,6 +538,13 @@ BT.2020 which uses limited range R'G'B' quantization.</para>
 	    <entry><constant>V4L2_COLORSPACE_JPEG</constant></entry>
 	    <entry>See <xref linkend="col-jpeg" />.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_COLORSPACE_RAW</constant></entry>
+	    <entry>The raw colorspace. This is used for raw image capture where
+	    the image is minimally processed and is using the internal colorspace
+	    of the device. The software that processes an image using this
+	    'colorspace' will have to know the internals of the capture device.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
2.1.4

