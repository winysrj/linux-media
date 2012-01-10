Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab2AJVRS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 16:17:18 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: toralf.foerster@gmx.de
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] dvb_ca_en50221: fix compilation breakage
Date: Tue, 10 Jan 2012 19:15:01 -0200
Message-Id: <1326230101-27381-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <201201081919.52142.toralf.foerster@gmx.de>
References: <201201081919.52142.toralf.foerster@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Toralf:

the build failed with :
  CC [M]  drivers/media/dvb/dvb-core/dvb_ca_en50221.o
In file included from arch/x86/include/asm/uaccess.h:573:0,
                 from include/linux/poll.h:14,
                 from drivers/media/dvb/dvb-core/dvbdev.h:27,
                 from drivers/media/dvb/dvb-core/dvb_ca_en50221.h:27,
                 from drivers/media/dvb/dvb-core/dvb_ca_en50221.c:41:
In function "copy_from_user", inlined from "dvb_ca_en50221_io_write" at drivers/media/dvb/dvb-core/dvb_ca_en50221.c:1314:26: arch/x86/include/asm/uaccess_32.h:211:26: error: call to "copy_from_user_overflow" declared with attribute error: copy_from_user() buffer size is not provably correct

Reported-by: Toralf Foerster <toralf.foerster@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
index 7ea517b..9be65a3 100644
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -1306,6 +1306,10 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 	/* fragment the packets & store in the buffer */
 	while (fragpos < count) {
 		fraglen = ca->slot_info[slot].link_buf_size - 2;
+		if (fraglen < 0)
+			break;
+		if (fraglen > HOST_LINK_BUF_SIZE - 2)
+			fraglen = HOST_LINK_BUF_SIZE - 2;
 		if ((count - fragpos) < fraglen)
 			fraglen = count - fragpos;
 
-- 
1.7.7.5

