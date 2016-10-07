Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46795 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938896AbcJGRYq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 13:24:46 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>,
        Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 21/26] pctv452e: don't call BUG_ON() on non-fatal error
Date: Fri,  7 Oct 2016 14:24:31 -0300
Message-Id: <930024c357cd6ec079aee59f410734aad1d4be59.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some conditions on this driver that are tested with
BUG_ON() with are not serious enough to hang a machine.

So, just return an error if this happens.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/pctv452e.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index 855fe9d34b59..14bd927c50d8 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -109,9 +109,11 @@ static int tt3650_ci_msg(struct dvb_usb_device *d, u8 cmd, u8 *data,
 	unsigned int rlen;
 	int ret;
 
-	BUG_ON(NULL == data && 0 != (write_len | read_len));
-	BUG_ON(write_len > 64 - 4);
-	BUG_ON(read_len > 64 - 4);
+	if (NULL == data && 0 != (write_len | read_len) ||
+	    write_len > 64 - 4) || (read_len > 64 - 4)) {
+		ret = -EIO;
+		goto failed;
+	};
 
 	id = state->c++;
 
-- 
2.7.4


