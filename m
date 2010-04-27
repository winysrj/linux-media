Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755187Ab0D0VVL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 17:21:11 -0400
Message-Id: <201004272111.o3RLBK9R019985@imap1.linux-foundation.org>
Subject: [patch 03/11] dvb-usb: gp8psk, fix potential null derefernce
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	jslaby@suse.cz, alannisota@gmail.com, pb@linuxtv.org
From: akpm@linux-foundation.org
Date: Tue, 27 Apr 2010 14:11:20 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jiri Slaby <jslaby@suse.cz>

Stanse found that in gp8psk_load_bcm4500fw there is missing a check for
return value of kmalloc. Add one and bail out appropriatelly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Nisota <alannisota@gmail.com>
Cc: Patrick Boettcher <pb@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/gp8psk.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/media/dvb/dvb-usb/gp8psk.c~dvb-usb-gp8psk-fix-potential-null-derefernce drivers/media/dvb/dvb-usb/gp8psk.c
--- a/drivers/media/dvb/dvb-usb/gp8psk.c~dvb-usb-gp8psk-fix-potential-null-derefernce
+++ a/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -105,6 +105,10 @@ static int gp8psk_load_bcm4500fw(struct 
 
 	ptr = fw->data;
 	buf = kmalloc(64, GFP_KERNEL | GFP_DMA);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out_rel_fw;
+	}
 
 	while (ptr[0] != 0xff) {
 		u16 buflen = ptr[0] + 4;
_
