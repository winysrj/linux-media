Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757586Ab0JGB7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 21:59:04 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o971x4cv001427
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 6 Oct 2010 21:59:04 -0400
Received: from pedra (vpn-225-141.phx2.redhat.com [10.3.225.141])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o971uuB8028164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 6 Oct 2010 21:59:03 -0400
Date: Wed, 6 Oct 2010 22:56:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] V4L/DVB: videobuf-dma-sg: Fix a warning due to the
 usage of min(PAGE_SIZE, arg)
Message-ID: <20101006225647.2c0dfa39@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

drivers/media/video/videobuf-dma-sg.c: In function ‘videobuf_pages_to_sg’:
drivers/media/video/videobuf-dma-sg.c:119: warning: comparison of distinct pointer types lacks a cast
drivers/media/video/videobuf-dma-sg.c:120: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 359f2f3..7153e44 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -116,8 +116,8 @@ static struct scatterlist *videobuf_pages_to_sg(struct page **pages,
 			goto nopage;
 		if (PageHighMem(pages[i]))
 			goto highmem;
-		sg_set_page(&sglist[i], pages[i], min(PAGE_SIZE, size), 0);
-		size -= min(PAGE_SIZE, size);
+		sg_set_page(&sglist[i], pages[i], min((unsigned)PAGE_SIZE, size), 0);
+		size -= min((unsigned)PAGE_SIZE, size);
 	}
 	return sglist;
 
-- 
1.7.1


