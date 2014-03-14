Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3158 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbaCNMjT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 08:39:19 -0400
Message-ID: <5322F864.6050507@xs4all.nl>
Date: Fri, 14 Mar 2014 13:39:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: hdegoede@redhat.com
Subject: libv4lconvert: remove broken ALTERNATE handling
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 specification used to say that if field == V4L2_FIELD_ALTERNATE, the
height would have to be divided by two. This is incorrect, the height is that of
a single field. This has been corrected in the spec, now this code in libv4lconvert
needs to be removed as well.

Tested with both bttv and saa7146, the only two drivers supporting FIELD_ALTERNATE
today.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 lib/libv4lconvert/libv4lconvert.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index e2afc27..df06b75 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -1328,13 +1328,6 @@ int v4lconvert_convert(struct v4lconvert_data *data,
 		return to_copy;
 	}
 
-	/* When field is V4L2_FIELD_ALTERNATE, each buffer only contains half the
-	   lines */
-	if (my_src_fmt.fmt.pix.field == V4L2_FIELD_ALTERNATE) {
-		my_src_fmt.fmt.pix.height /= 2;
-		my_dest_fmt.fmt.pix.height /= 2;
-	}
-
 	/* sanity check, is the dest buffer large enough? */
 	switch (my_dest_fmt.fmt.pix.pixelformat) {
 	case V4L2_PIX_FMT_RGB24:
-- 
1.9.0

