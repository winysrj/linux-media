Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:57431 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3L3Mt0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 07:49:26 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so4955067eek.18
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 04:49:25 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 03/18] libdvbv5: VCT table cleanup
Date: Mon, 30 Dec 2013 13:48:36 +0100
Message-Id: <1388407731-24369-3-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors/vct.h  | 10 ++++++----
 lib/libdvbv5/descriptors/vct.c |  3 ++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/include/descriptors/vct.h b/lib/include/descriptors/vct.h
index 6272b43..2d269dc 100644
--- a/lib/include/descriptors/vct.h
+++ b/lib/include/descriptors/vct.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2013 - Mauro Carvalho Chehab <m.chehab@samsung.com>
+ * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -35,14 +36,14 @@ struct dvb_table_vct_channel {
 	uint16_t	__short_name[7];
 
 	union {
-		uint16_t bitfield1;
+		uint32_t bitfield1;
 		struct {
 			uint32_t	modulation_mode:8;
 			uint32_t	minor_channel_number:10;
 			uint32_t	major_channel_number:10;
 			uint32_t	reserved1:4;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 
 	uint32_t	carrier_frequency;
 	uint16_t	channel_tsid;
@@ -60,7 +61,8 @@ struct dvb_table_vct_channel {
 			uint16_t	ETM_location:2;
 
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
+
 	uint16_t source_id;
 	union {
 		uint16_t bitfield3;
@@ -68,7 +70,7 @@ struct dvb_table_vct_channel {
 			uint16_t descriptors_length:10;
 			uint16_t reserved3:6;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 
 	/*
 	 * Everything after descriptor (including it) won't be bit-mapped
diff --git a/lib/libdvbv5/descriptors/vct.c b/lib/libdvbv5/descriptors/vct.c
index e703c52..c1578ad 100644
--- a/lib/libdvbv5/descriptors/vct.c
+++ b/lib/libdvbv5/descriptors/vct.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2013 - Mauro Carvalho Chehab <m.chehab@samsung.com>
+ * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -74,7 +75,7 @@ void dvb_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		bswap32(channel->carrier_frequency);
 		bswap16(channel->channel_tsid);
 		bswap16(channel->program_number);
-		bswap16(channel->bitfield1);
+		bswap32(channel->bitfield1);
 		bswap16(channel->bitfield2);
 		bswap16(channel->source_id);
 		bswap16(channel->bitfield3);
-- 
1.8.3.2

