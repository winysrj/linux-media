Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:56653 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0APRfJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 12:35:09 -0500
Message-ID: <4B51F8C7.1040202@freemail.hu>
Date: Sat, 16 Jan 2010 18:35:03 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@dibcom.fr>,
	Olivier Grenie <olivier.grenie@dibcom.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] dib0090: cleanup dib0090_dcc_freq()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

'extern' is not needed at function definition.

This will remove the following sparse warning (see "make C=1"):
 * function 'dib0090_dcc_freq' with external linkage has definition

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 5bcdcc072b6d linux/drivers/media/dvb/frontends/dib0090.c
--- a/linux/drivers/media/dvb/frontends/dib0090.c	Sat Jan 16 07:25:43 2010 +0100
+++ b/linux/drivers/media/dvb/frontends/dib0090.c	Sat Jan 16 18:33:43 2010 +0100
@@ -283,7 +283,7 @@
 	return 0;
 }

-extern void dib0090_dcc_freq(struct dvb_frontend *fe, u8 fast)
+void dib0090_dcc_freq(struct dvb_frontend *fe, u8 fast)
 {
 	struct dib0090_state *state = fe->tuner_priv;
 	if (fast)
