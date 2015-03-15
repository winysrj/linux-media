Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46604 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbbCORac (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 13:30:32 -0400
Message-ID: <5505C1B1.8030201@xs4all.nl>
Date: Sun, 15 Mar 2015 18:30:25 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kamil Debski <k.debski@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pawel Osciak <posciak@chromium.org>
Subject: [RFC PATCH] v4l2_plane_pix_format: use __u32 bytesperline instead
 of __u16
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While running v4l2-compliance tests on vivid I suddenly got errors due to
a call to vmalloc_user with size 0 from vb2.

Digging deeper into the cause I discovered that this was due to the fact that
struct v4l2_plane_pix_format defines bytesperline as a __u16 instead of a __u32.

The test I was running selected a format of 4 * 4096 by 4 * 2048 with a 32
bit pixelformat.

So bytesperline was 4 * 4 * 4096 = 65536, which becomes 0 in a __u16. And
bytesperline * height is suddenly 0 as well.

The best approach IMHO is to increase the type to __u32. The only drivers
besides vivid that use the multiplanar API are little-endian ARM and SH platforms
(exynos, ti-vpe, vsp1).

Does anyone know of someone using those drivers on a big-endian system?

I don't think we can ignore this. With work going on for deep-color and 8K formats
you can reach this limit already (8192 * 8 == 65536). Ditto for high-resolution
sensors. Add a scaler in the mix (like the vivid driver does) and you reach the
limit very quickly.

The alternative would be to add a __u32 bytesperline_msb field, but I think
we can still safely change the API today without adding a cumbersome msb field.

Comments?

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 13540fa..35d2f86 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -182,14 +182,14 @@ see <xref linkend="colorspaces" />.</entry>
           </entry>
         </row>
         <row>
-          <entry>__u16</entry>
+          <entry>__u32</entry>
           <entry><structfield>bytesperline</structfield></entry>
           <entry>Distance in bytes between the leftmost pixels in two adjacent
             lines. See &v4l2-pix-format;.</entry>
         </row>
         <row>
           <entry>__u16</entry>
-          <entry><structfield>reserved[7]</structfield></entry>
+          <entry><structfield>reserved[6]</structfield></entry>
           <entry>Reserved for future extensions. Should be zeroed by the
            application.</entry>
         </row>
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fbdc360..44f381d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1841,8 +1841,8 @@ struct v4l2_mpeg_vbi_fmt_ivtv {
  */
 struct v4l2_plane_pix_format {
 	__u32		sizeimage;
-	__u16		bytesperline;
-	__u16		reserved[7];
+	__u32		bytesperline;
+	__u16		reserved[6];
 } __attribute__ ((packed));
 
 /**
