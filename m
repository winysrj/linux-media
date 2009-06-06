Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:54989 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbZFFIQO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 04:16:14 -0400
Received: by rv-out-0506.google.com with SMTP id f9so819457rvb.1
        for <linux-media@vger.kernel.org>; Sat, 06 Jun 2009 01:16:14 -0700 (PDT)
Subject: [PATCH] V4L: return -ENOMEM
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 16:15:22 +0800
Message-Id: <1244276123.3185.2.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

it is better return -ENOMEM than -EIO 

Signed-off-by: Figo.zhang <figo1802@gmail.com>
--- 
drivers/media/video/videobuf-dma-sg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index da1790e..03c8b04 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -251,7 +251,7 @@ int videobuf_dma_map(struct videobuf_queue* q, struct videobuf_dmabuf *dma)
 			kfree(dma->sglist);
 			dma->sglist = NULL;
 			dma->sglen = 0;
-			return -EIO;
+			return -ENOMEM;
 		}
 	}
 	return 0;


