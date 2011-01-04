Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49635 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1ADEQY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 23:16:24 -0500
Received: by wwa36 with SMTP id 36so14815842wwa.1
        for <linux-media@vger.kernel.org>; Mon, 03 Jan 2011 20:16:23 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 3 Jan 2011 22:16:23 -0600
Message-ID: <AANLkTikedj2Pun=KvjdfRue57+1eOo1uKR9zuomz=H5W@mail.gmail.com>
Subject: TW68 driver fails to compile
From: isaac smith <hunternet93@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

I am trying to compile the TW68 driver (freshly cloned from the git
repo), on Fedora 14 kernel version 2.6.37-rc8. Make dies with the
errors:
make -C /lib/modules/2.6.37-rc5/build M=/home/hunter/devel/tw68-v2 modules
make[1]: Entering directory `/usr/src/kernels/linux-2.6.37-rc5'
  CC [M]  /home/hunter/devel/tw68-v2/tw68-core.o
/home/hunter/devel/tw68-v2/tw68-core.c: In function ‘tw68_dma_free’:
/home/hunter/devel/tw68-v2/tw68-core.c:113:2: error: incompatible type
for argument 1 of ‘videobuf_waiton’
include/media/videobuf-core.h:183:5: note: expected ‘struct
videobuf_queue *’ but argument is of type ‘struct videobuf_buffer’
/home/hunter/devel/tw68-v2/tw68-core.c:113:2: error: too few arguments
to function ‘videobuf_waiton’
include/media/videobuf-core.h:183:5: note: declared here
make[2]: *** [/home/hunter/devel/tw68-v2/tw68-core.o] Error 1
make[1]: *** [_module_/home/hunter/devel/tw68-v2] Error 2
make[1]: Leaving directory `/usr/src/kernels/linux-2.6.37-rc5'
make: *** [all] Error 2

I poked in the code a bit, but it was way over my head. I've tried
this on a 64-bit and a 32-bit computer, with the same result.

-- 
God Bless ,
                     Isaac
