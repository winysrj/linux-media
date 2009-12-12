Return-path: <linux-media-owner@vger.kernel.org>
Received: from snail.duncangibb.com ([217.169.3.184]:4626 "EHLO
	snail.duncangibb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759795AbZLLNQL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2009 08:16:11 -0500
Received: from edna.duncangibb.com ([217.169.3.179])
	by snail.duncangibb.com with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <dg@duncangibb.com>)
	id 1NJRRp-000784-Jq
	for linux-media@vger.kernel.org; Sat, 12 Dec 2009 12:51:47 +0000
Message-ID: <4B2391E0.3040800@duncangibb.com>
Date: Sat, 12 Dec 2009 12:51:44 +0000
From: Duncan Gibb <dg@duncangibb.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [PATCH] [Trivial] Make saa7134-input.c build for kernels < 2.6.30
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

The current http://linuxtv.org/hg/v4l-dvb tree doesn't build against
my kernel (2.6.26-2-xen-686 from Debian Lenny) and lots of others
according to http://www.xs4all.nl/~hverkuil/logs/Friday.log because
of a typo fixed by this patch.  Apologies for posting what to many
will be the bleeding obvious.

Cheers

Duncan


Signed-off-by: Duncan Gibb <dg@duncangibb.com>
---
diff -r db37ff59927f linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c Thu Dec 10 18:17:49 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c Sat Dec 12 12:08:10 2009 +0000
@@ -962,7 +962,7 @@
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
                snprintf(ir->c.name, sizeof(ir->c.name), "FlyDVB Trio");
                ir->get_key   = get_key_flydvb_trio;
-               ir->ir_codes  = ir_codes_flydvb_table;
+               ir->ir_codes  = &ir_codes_flydvb_table;
 #else
                dev->init_data.name = "FlyDVB Trio";
                dev->init_data.get_key = get_key_flydvb_trio;


