Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:30737 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934359Ab0BYW7M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 17:59:12 -0500
Message-ID: <4B87006A.4030303@oracle.com>
Date: Thu, 25 Feb 2010 14:57:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: [PATCH] media: fix precedence in dvb/frontends/tda665x
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix precedence so that data is used correctly.
Fixes sparse warning:
drivers/media/dvb/frontends/tda665x.c:136:55: warning: right shift by bigger than source value

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Manu Abraham <abraham.manu@gmail.com>
---
 drivers/media/dvb/frontends/tda665x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2633-spr.orig/drivers/media/dvb/frontends/tda665x.c
+++ lnx-2633-spr/drivers/media/dvb/frontends/tda665x.c
@@ -133,7 +133,7 @@ static int tda665x_set_state(struct dvb_
 		frequency += config->ref_divider >> 1;
 		frequency /= config->ref_divider;
 
-		buf[0] = (u8) (frequency & 0x7f00) >> 8;
+		buf[0] = (u8) ((frequency & 0x7f00) >> 8);
 		buf[1] = (u8) (frequency & 0x00ff) >> 0;
 		buf[2] = 0x80 | 0x40 | 0x02;
 		buf[3] = 0x00;

