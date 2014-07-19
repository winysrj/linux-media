Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1248 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaGSHSp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jul 2014 03:18:45 -0400
Message-ID: <53CA1BCB.1020308@xs4all.nl>
Date: Sat, 19 Jul 2014 09:18:35 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: libv4lconvert: fix RGB32 conversion
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RGB32 formats start with an alpha byte in memory. So before calling the
v4lconvert_rgb32_to_rgb24 or v4lconvert_rgb24_to_yuv420 function skip that initial
alpha byte so the src pointer is aligned with the first color component, since
that is what those functions expect.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index cea65aa..e4aa54a 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -1132,6 +1132,7 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 			errno = EPIPE;
 			result = -1;
 		}
+		src++;
 		switch (dest_pix_fmt) {
 		case V4L2_PIX_FMT_RGB24:
 			v4lconvert_rgb32_to_rgb24(src, dest, width, height, 0);
