Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:62907 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab0DGX5U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Apr 2010 19:57:20 -0400
Received: by gxk9 with SMTP id 9so969270gxk.8
        for <linux-media@vger.kernel.org>; Wed, 07 Apr 2010 16:57:19 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 8 Apr 2010 07:57:19 +0800
Message-ID: <x2l6e8e83e21004071657yf6fabbabv2652ef643b5a1595@mail.gmail.com>
Subject: [PATCH] TM6000: Fix code which cause memory corruption
From: Bee Hock Goh <beehock@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

code was doing malloc when buf is null causing memory corruption. The
analog part is still pretty much broken but at least fixing this will
stop it from crashing the machine when streamon.

Signed-off-by: Bee Hock Goh <beehock@gmail.com>
diff -r 7c0b887911cf linux/drivers/staging/tm6000/tm6000-video.c
--- a/linux/drivers/staging/tm6000/tm6000-video.c       Mon Apr 05
22:56:43 2010 -0400
+++ b/linux/drivers/staging/tm6000/tm6000-video.c       Thu Apr 08
07:45:05 2010 +0800
@@ -502,7 +502,7 @@
        unsigned long copied;

        get_next_buf(dma_q, &buf);
-       if (!buf)
+       if (buf)
                outp = videobuf_to_vmalloc(&buf->vb);

        if (!outp)
