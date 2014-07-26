Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.uli-eckhardt.de ([85.214.28.137]:42830 "EHLO
	mail.uli-eckhardt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751448AbaGZSBO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 14:01:14 -0400
Message-ID: <53D3ECE8.7090006@uli-eckhardt.de>
Date: Sat, 26 Jul 2014 20:01:12 +0200
From: Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: jarod@wilsonet.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] imon: Fix not working front panel.
References: <53247996.7050303@uli-eckhardt.de> <20140723175537.0e9e5541.m.chehab@samsung.com> <53D3E991.9040006@uli-eckhardt.de>
In-Reply-To: <53D3E991.9040006@uli-eckhardt.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the front panel buttons working after another button on the 
remote was pressed.

Signed-off-by: Ulrich Eckhardt <uli@uli-eckhardt.de>

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index c64acbf..3b392f7 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1609,6 +1609,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 		scancode = be64_to_cpu(*((u64 *)buf));
 		ktype = IMON_KEY_PANEL;
 		kc = imon_panel_key_lookup(ictx, scancode);
+		ictx->release_code = false;
 	} else {
 		scancode = be32_to_cpu(*((u32 *)buf));
 		if (ictx->rc_type == RC_BIT_RC6_MCE) {


-- 
Ulrich Eckhardt                  http://www.uli-eckhardt.de

Ein Blitzableiter auf dem Kirchturm ist das denkbar stärkste 
Misstrauensvotum gegen den lieben Gott. (Karl Krauss)
