Return-path: <mchehab@localhost>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38110 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab1GHH06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2011 03:26:58 -0400
Date: Fri, 8 Jul 2011 10:25:40 +0300
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	"Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"open list:STAGING - TRIDENT..." <linux-media@vger.kernel.org>,
	"open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch] Staging: tm6000: remove unneeded check in get_next_buf()
Message-ID: <20110708072540.GV18655@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

We dereference "buf" on the line before so if it were NULL here we
would have OOPsed earlier.  Also list_entry() never returns NULL.
And finally, we handled the situation where the list is empty
earlier in the function.

So this test isn't needed and I've removed it.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 3fe6038..8d8b939 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -179,9 +179,6 @@ static inline void get_next_buf(struct tm6000_dmaqueue *dma_q,
 	*buf = list_entry(dma_q->active.next,
 			struct tm6000_buffer, vb.queue);
 
-	if (!buf)
-		return;
-
 	/* Cleans up buffer - Useful for testing for frame/URB loss */
 	outp = videobuf_to_vmalloc(&(*buf)->vb);
 
