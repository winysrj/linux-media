Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab0EEUQ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 May 2010 16:16:59 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o45KGwIS023988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 5 May 2010 16:16:58 -0400
Received: from [10.11.9.8] (vpn-9-8.rdu.redhat.com [10.11.9.8])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o45KGtlU031715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 5 May 2010 16:16:58 -0400
Message-ID: <4BE1D237.9020007@redhat.com>
Date: Wed, 05 May 2010 17:16:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] videobuf-vmalloc: remove __videobuf_sync()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf-core checks if .sync ops is defined before calling.

So, we don't need a do-nothing function.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

-- 

Cheers,
Mauro
diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
index f8b5b56..583728f 100644
--- a/drivers/media/video/videobuf-vmalloc.c
+++ b/drivers/media/video/videobuf-vmalloc.c
@@ -229,12 +229,6 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 	return 0;
 }
 
-static int __videobuf_sync(struct videobuf_queue *q,
-			   struct videobuf_buffer *buf)
-{
-	return 0;
-}
-
 static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 				  struct videobuf_buffer *buf,
 				  struct vm_area_struct *vma)
@@ -301,7 +295,6 @@ static struct videobuf_qtype_ops qops = {
 
 	.alloc        = __videobuf_alloc,
 	.iolock       = __videobuf_iolock,
-	.sync         = __videobuf_sync,
 	.mmap_mapper  = __videobuf_mmap_mapper,
 	.vaddr        = videobuf_to_vmalloc,
 };
