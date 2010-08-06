Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39528 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab0HFLnI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Aug 2010 07:43:08 -0400
Received: by fxm14 with SMTP id 14so3766831fxm.19
        for <linux-media@vger.kernel.org>; Fri, 06 Aug 2010 04:43:06 -0700 (PDT)
Date: Fri, 6 Aug 2010 13:43:03 +0200
From: Davor Emard <davoremard@gmail.com>
To: linux-media@vger.kernel.org
Subject: Avermedia dvb-t hybrid A188
Message-ID: <20100806114248.GA29247@emard.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI

For the card AVerTV Duo Hybrid PCI-E II (A188)

I have compiled correctly saa716x driver with kernel 2.6.32.17 
I have to modify a card id with this patch:

--- linux/drivers/media/common/saa716x/saa716x_hybrid.h~        2010-06-20
--- 13:24:18.000000000 +0200
+++ linux/drivers/media/common/saa716x/saa716x_hybrid.h 2010-08-06
12:34:49.795695203 +0200
@@ -6,6 +6,6 @@
 
 #define TWINHAN_VP_6090                0x0027
 #define AVERMEDIA_HC82         0x2355
-#define AVERMEDIA_H788         0x1455
+#define AVERMEDIA_H788         0x1855
 
 #endif /* __SAA716x_HYBRID_H */

And the driver cleanly compiles with make and installs with make install
also it cleanly loads:

Aug  6 13:25:49 elf kernel: SAA716x Hybrid 0000:02:00.0: PCI INT A -> Link[LN0A] -> GSI 19 (level, low) -> IRQ 19  
Aug  6 13:25:49 elf kernel: SAA716x Hybrid 0000:02:00.0: setting latency timer to 64
Aug  6 13:25:49 elf kernel: DVB: registering new adapter (SAA716x dvb adapter)

Card registers dvb demux entries, but there's no frontend:

ls -al /dev/dvb/adapter0/
total 0
drwxr-xr-x  2 root root     100 2010-08-06 13:25 .
drwxr-xr-x  3 root root      60 2010-08-06 13:25 ..
crw-rw----+ 1 root video 212, 0 2010-08-06 13:25 demux0
crw-rw----+ 1 root video 212, 1 2010-08-06 13:25 dvr0
crw-rw----+ 1 root video 212, 2 2010-08-06 13:25 net0

Maybe someone has idea how to get frontend working.... :)

d.
