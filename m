Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37808 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab1ASO3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 09:29:05 -0500
Date: Wed, 19 Jan 2011 17:28:27 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Patrick Boettcher <patrick.boettcher@dibcom.fr>,
	Olivier Grenie <olivier.grenie@dibcom.fr>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] [media] dib9000: fix return type in
 dib9000_mbx_send_attr()
Message-ID: <20110119142827.GP2721@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

dib9000_mbx_send_attr() returns an int.  It doesn't work to save
negative error codes in an unsigned char, so I've made "ret" an int
type.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb/frontends/dib9000.c
index 43fb6e4..9151876 100644
--- a/drivers/media/dvb/frontends/dib9000.c
+++ b/drivers/media/dvb/frontends/dib9000.c
@@ -486,10 +486,11 @@ static int dib9000_mbx_host_init(struct dib9000_state *state, u8 risc_id)
 #define MAX_MAILBOX_TRY 100
 static int dib9000_mbx_send_attr(struct dib9000_state *state, u8 id, u16 * data, u8 len, u16 attr)
 {
-	u8 ret = 0, *d, b[2];
+	u8 *d, b[2];
 	u16 tmp;
 	u16 size;
 	u32 i;
+	int ret = 0;
 
 	if (!state->platform.risc.fw_is_running)
 		return -EINVAL;
