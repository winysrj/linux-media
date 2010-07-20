Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932736Ab0GTWXj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jul 2010 18:23:39 -0400
Message-Id: <201007202222.o6KMMg3M021241@imap1.linux-foundation.org>
Subject: [patch 1/2] "dib3000mc: reduce large stack usage" fix
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	obi@linuxtv.org, pboettcher@dibcom.fr, randy.dunlap@oracle.com
From: akpm@linux-foundation.org
Date: Tue, 20 Jul 2010 15:22:42 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>

s/ENODEV/ENOMEM, per Andreas.

This fix got lost when someone merged "dib3000mc: reduce large stack
usage".  Please don't lose fixes.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Patrick Boettcher <pboettcher@dibcom.fr>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andreas Oberritter <obi@linuxtv.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/dib3000mc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/frontends/dib3000mc.c~dib3000mc-reduce-large-stack-usage-fix drivers/media/dvb/frontends/dib3000mc.c
--- a/drivers/media/dvb/frontends/dib3000mc.c~dib3000mc-reduce-large-stack-usage-fix
+++ a/drivers/media/dvb/frontends/dib3000mc.c
@@ -822,7 +822,7 @@ int dib3000mc_i2c_enumeration(struct i2c
 
 	dmcst = kzalloc(sizeof(struct dib3000mc_state), GFP_KERNEL);
 	if (dmcst == NULL)
-		return -ENODEV;
+		return -ENOMEM;
 
 	dmcst->i2c_adap = i2c;
 
_
