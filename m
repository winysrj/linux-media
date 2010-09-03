Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35002 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab0ICQTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Sep 2010 12:19:02 -0400
Received: by wwj40 with SMTP id 40so2779826wwj.1
        for <linux-media@vger.kernel.org>; Fri, 03 Sep 2010 09:19:01 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Sep 2010 11:19:00 -0500
Message-ID: <AANLkTim=Gy=hdePJBiA0M_+nvR9Netc2KXPdJCK8ZZi4@mail.gmail.com>
Subject: PATCH to hdpvr-video.c solves DMA allocation problems on arm processsors.
From: James MacLaren <jm.maclaren@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

I needed to patch hdpvr-video.c to capture on my dockstar arm
processor.  I see that this patch has been noted on a number of other
usb drivers on this list.

diff -Naur hdpvr-video.c hdpvr-video-jmm.c

--- hdpvr-video.c       2010-08-29 09:28:57.126133063 -0500
+++ hdpvr-video-jmm.c   2010-09-03 08:41:37.854129338 -0500
@@ -157,6 +157,7 @@

                                  mem, dev->bulk_in_size,
                                  hdpvr_read_bulk_callback, buf);

+                buf->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
// added JMM
                buf->status = BUFSTAT_AVAILABLE;
                list_add_tail(&buf->buff_list, &dev->free_buff_list);
        }


Hopefully this patch can be applied.
James
