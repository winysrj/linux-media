Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:65454 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab3L3Mt2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 07:49:28 -0500
Received: by mail-ee0-f49.google.com with SMTP id c41so5044739eek.8
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 04:49:26 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 05/18] libdvbv5: fix NIT structures
Date: Mon, 30 Dec 2013 13:48:38 +0100
Message-Id: <1388407731-24369-5-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors/nit.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/include/descriptors/nit.h b/lib/include/descriptors/nit.h
index f2f6163..d71a762 100644
--- a/lib/include/descriptors/nit.h
+++ b/lib/include/descriptors/nit.h
@@ -48,7 +48,7 @@ struct dvb_table_nit_transport {
 		struct {
 			uint16_t section_length:12;
 			uint16_t reserved:4;
-		};
+		} __attribute__((packed));
 	};
 	struct dvb_desc *descriptor;
 	struct dvb_table_nit_transport *next;
@@ -61,7 +61,7 @@ struct dvb_table_nit {
 		struct {
 			uint16_t desc_length:12;
 			uint16_t reserved:4;
-		};
+		} __attribute__((packed));
 	};
 	struct dvb_desc *descriptor;
 	struct dvb_table_nit_transport *transport;
-- 
1.8.3.2

