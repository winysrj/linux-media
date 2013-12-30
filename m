Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:43295 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab3L3Mtf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 07:49:35 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so5022157ead.6
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 04:49:34 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 14/18] libdvbv5: cleanup dvb_nit_transport_foreach macro
Date: Mon, 30 Dec 2013 13:48:47 +0100
Message-Id: <1388407731-24369-14-git-send-email-neolynx@gmail.com>
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
index d71a762..4f19c5e 100644
--- a/lib/include/descriptors/nit.h
+++ b/lib/include/descriptors/nit.h
@@ -76,8 +76,8 @@ typedef void nit_tran_handler_callback_t(struct dvb_table_nit *nit,
 					 struct dvb_desc *desc,
 					 void *priv);
 
-			       #define dvb_nit_transport_foreach( tran, nit ) \
-  for (struct dvb_table_nit_transport *tran = nit->transport; tran; tran = tran->next) \
+#define dvb_nit_transport_foreach( _tran, _nit ) \
+  for (struct dvb_table_nit_transport *_tran = _nit->transport; _tran; _tran = _tran->next) \
 
 struct dvb_v5_fe_parms;
 
-- 
1.8.3.2

