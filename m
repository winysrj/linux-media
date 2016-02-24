Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbcBXLHO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 06:07:14 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: mchehab@osg.samsung.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 1/4] xvoutput: Fix xvblit not working with odd widths
Date: Wed, 24 Feb 2016 12:07:04 +0100
Message-Id: <1456312027-8484-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since xvblit blits the u and v planes 2 pixels at a time it needs to
ensure that width always is a multiple of 2.
Add support for planar yuv formats

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/xvoutput.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/xvoutput.c b/src/xvoutput.c
index c5a80a0..c8f5ed3 100644
--- a/src/xvoutput.c
+++ b/src/xvoutput.c
@@ -232,6 +232,9 @@ static void xv_blit( uint8_t *dest, uint8_t *src,
 {
     uint8_t *y_dest, *u_dest, *v_dest, *src1;
 
+    /* We always copy 2 pixels at a time */
+    width = (width + 1) & ~1;
+
     /* Adjust src for x and y start coordinates */
     src += y * input_width * 2 + (x & ~1) * 2;
 
-- 
2.7.1

