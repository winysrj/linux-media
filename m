Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:25579 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab0BOClJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2010 21:41:09 -0500
Date: Sun, 14 Feb 2010 18:39:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] dvb: fix sparse warnings
Message-Id: <20100214183932.46d678c9.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse warnings in media/dvb/frontends:

drivers/media/dvb/frontends/dibx000_common.c:177:13: warning: non-ANSI function declaration of function 'systime'
drivers/media/dvb/frontends/dib0090.c:286:13: warning: function 'dib0090_dcc_freq' with external linkage has definition
drivers/media/dvb/frontends/tda665x.c:136:55: warning: right shift by bigger than source value

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/dvb/frontends/dib0090.c        |    2 +-
 drivers/media/dvb/frontends/dibx000_common.c |    2 +-
 drivers/media/dvb/frontends/tda665x.c        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.33-rc8.orig/drivers/media/dvb/frontends/dib0090.c
+++ linux-2.6.33-rc8/drivers/media/dvb/frontends/dib0090.c
@@ -283,7 +283,7 @@ static int dib0090_sleep(struct dvb_fron
 	return 0;
 }
 
-extern void dib0090_dcc_freq(struct dvb_frontend *fe, u8 fast)
+void dib0090_dcc_freq(struct dvb_frontend *fe, u8 fast)
 {
 	struct dib0090_state *state = fe->tuner_priv;
 	if (fast)
--- linux-2.6.33-rc8.orig/drivers/media/dvb/frontends/dibx000_common.c
+++ linux-2.6.33-rc8/drivers/media/dvb/frontends/dibx000_common.c
@@ -174,7 +174,7 @@ void dibx000_exit_i2c_master(struct dibx
 EXPORT_SYMBOL(dibx000_exit_i2c_master);
 
 
-u32 systime()
+u32 systime(void)
 {
     struct timespec t;
 
--- linux-2.6.33-rc8.orig/drivers/media/dvb/frontends/tda665x.c
+++ linux-2.6.33-rc8/drivers/media/dvb/frontends/tda665x.c
@@ -133,7 +133,7 @@ static int tda665x_set_state(struct dvb_
 		frequency += config->ref_divider >> 1;
 		frequency /= config->ref_divider;
 
-		buf[0] = (u8) (frequency & 0x7f00) >> 8;
+		buf[0] = (u8) ((frequency & 0x7f00) >> 8);
 		buf[1] = (u8) (frequency & 0x00ff) >> 0;
 		buf[2] = 0x80 | 0x40 | 0x02;
 		buf[3] = 0x00;
---
~Randy
