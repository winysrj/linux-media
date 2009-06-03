Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:18078 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZFCCNx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2009 22:13:53 -0400
Received: by rv-out-0506.google.com with SMTP id f9so46479rvb.17
        for <linux-media@vger.kernel.org>; Tue, 02 Jun 2009 19:13:54 -0700 (PDT)
Subject: [PATCH] videobuf-dma-sg.c : not need memset()
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Trent Piepho <xyzzy@speakeasy.org>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 10:13:44 +0800
Message-Id: <1243995225.3459.15.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mem have malloc zero memory by kzalloc(), so it have not need to 
memset().
 
Signed-off-by: Figo.zhang <figo1802@gmail.com>
--- 
 drivers/media/video/videobuf-dma-sg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index da1790e..add2f34 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -420,7 +420,7 @@ static void *__videobuf_alloc(size_t size)
 	mem = vb->priv = ((char *)vb)+size;
 	mem->magic=MAGIC_SG_MEM;
 
-	videobuf_dma_init(&mem->dma);
+	mem->dma.magic = MAGIC_DMABUF;
 
 	dprintk(1,"%s: allocated at %p(%ld+%ld) & %p(%ld)\n",
 		__func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),


