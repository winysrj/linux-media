Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29771 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab3DQHUu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 03:20:50 -0400
Date: Wed, 17 Apr 2013 10:20:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] go7007: dubious one-bit signed bitfields
Message-ID: <20130417072029.GF7923@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Because they're signed, "is_video" and "is_audio" can be 0 and -1
instead of 0 and 1 as intended.  It doesn't cause a bug, but it makes
Sparse complain:
drivers/staging/media/go7007/go7007-priv.h:94:31: error: dubious one-bit signed bitfield
drivers/staging/media/go7007/go7007-priv.h:95:31: error: dubious one-bit signed bitfield

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index 8bde187..6e16af7 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -91,8 +91,8 @@ struct go7007_board_info {
 	int num_i2c_devs;
 	struct go_i2c {
 		const char *type;
-		int is_video:1;
-		int is_audio:1;
+		unsigned int is_video:1;
+		unsigned int is_audio:1;
 		int addr;
 		u32 flags;
 	} i2c_devs[5];
