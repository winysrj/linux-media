Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:48164 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757552AbbA1UbV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 15:31:21 -0500
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH 3/3] dvb_net: Convert local hex dump to print_hex_dump_debug
Date: Wed, 28 Jan 2015 10:05:52 -0800
Message-Id: <96bfe405e460471c8d11ccf14b7dd69e1933520e.1422468185.git.joe@perches.com>
In-Reply-To: <cover.1422468185.git.joe@perches.com>
References: <cover.1422468185.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the generic facility instead of a home-grown one.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb-core/dvb_net.c | 28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index 0b0f97a..686d327 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -83,33 +83,9 @@ static inline __u32 iov_crc32( __u32 c, struct kvec *iov, unsigned int cnt )
 
 #ifdef ULE_DEBUG
 
-#define isprint(c)	((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9'))
-
-static void hexdump( const unsigned char *buf, unsigned short len )
+static void hexdump(const unsigned char *buf, unsigned short len)
 {
-	char str[80], octet[10];
-	int ofs, i, l;
-
-	for (ofs = 0; ofs < len; ofs += 16) {
-		sprintf( str, "%03d: ", ofs );
-
-		for (i = 0; i < 16; i++) {
-			if ((i + ofs) < len)
-				sprintf( octet, "%02x ", buf[ofs + i] );
-			else
-				strcpy( octet, "   " );
-
-			strcat( str, octet );
-		}
-		strcat( str, "  " );
-		l = strlen( str );
-
-		for (i = 0; (i < 16) && ((i + ofs) < len); i++)
-			str[l++] = isprint( buf[ofs + i] ) ? buf[ofs + i] : '.';
-
-		str[l] = '\0';
-		printk( KERN_WARNING "%s\n", str );
-	}
+	print_hex_dump_debug("", DUMP_PREFIX_OFFSET, 16, 1, buf, len, true);
 }
 
 #endif
-- 
2.1.2

