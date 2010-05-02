Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49265 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab0EBXyi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 19:54:38 -0400
Received: from 201-13-168-84.dial-up.telesp.net.br ([201.13.168.84] helo=[192.168.30.170])
	by bombadil.infradead.org with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1O8izd-0003v9-JC
	for linux-media@vger.kernel.org; Sun, 02 May 2010 23:54:37 +0000
Message-ID: <4BDE10A8.4040500@infradead.org>
Date: Sun, 02 May 2010 20:54:16 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "linux-me >> Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: [PATCH] tm6000: Don't copy outside the buffer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
BUG: unable to handle kernel paging request at 000000000100f700
IP: [<ffffffffa007ee79>] tm6000_irq_callback+0x51e/0xac7 [tm6000]
    
(gdb) list * tm6000_irq_callback+0x51e
0x2e79 is in tm6000_irq_callback (drivers/staging/tm6000/tm6000-video.c:363).
358                                             dev->isoc_ctl.tmp_buf_len--;
359                                     }
360                                     if (dev->isoc_ctl.tmp_buf_len) {
361                                             memcpy (&header,p,
362                                                     dev->isoc_ctl.tmp_buf_l$
363                                             memcpy (((u8 *)header)+
364                                                     dev->isoc_ctl.tmp_buf,
365                                                     ptr,
366                                                     4-dev->isoc_ctl.tmp_buf$
367                                             ptr+=4-dev->isoc_ctl.tmp_buf_le$
    
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 3317220..4444487 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -358,13 +358,13 @@ static int copy_streams(u8 *data, u8 *out_p, unsigned long len,
 					dev->isoc_ctl.tmp_buf_len--;
 				}
 				if (dev->isoc_ctl.tmp_buf_len) {
-					memcpy (&header,p,
+					memcpy(&header, p,
 						dev->isoc_ctl.tmp_buf_len);
-					memcpy (((u8 *)header)+
-						dev->isoc_ctl.tmp_buf,
+					memcpy((u8 *)&header +
+						dev->isoc_ctl.tmp_buf_len,
 						ptr,
-						4-dev->isoc_ctl.tmp_buf_len);
-					ptr+=4-dev->isoc_ctl.tmp_buf_len;
+						4 - dev->isoc_ctl.tmp_buf_len);
+					ptr += 4 - dev->isoc_ctl.tmp_buf_len;
 					goto HEADER;
 				}
 			}

-- 

Cheers,
Mauro
