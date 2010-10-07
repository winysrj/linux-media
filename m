Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:58538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab0JGMsL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Oct 2010 08:48:11 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o97CmBpY022767
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 08:48:11 -0400
Received: from pedra (vpn-225-63.phx2.redhat.com [10.3.225.63])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o97Ck4si028624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 08:48:10 -0400
Date: Thu, 7 Oct 2010 09:45:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] V4L/DVB: videobuf-dma-sg: Use min_t(size_t, PAGE_SIZE
 ..)
Message-ID: <20101007094543.47b77328@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

As pointed by Laurent:

I think min_t(size_t, PAGE_SIZE, size) is the preferred way.

Thanks-to: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 7153e44..20f227e 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -116,8 +116,8 @@ static struct scatterlist *videobuf_pages_to_sg(struct page **pages,
 			goto nopage;
 		if (PageHighMem(pages[i]))
 			goto highmem;
-		sg_set_page(&sglist[i], pages[i], min((unsigned)PAGE_SIZE, size), 0);
-		size -= min((unsigned)PAGE_SIZE, size);
+		sg_set_page(&sglist[i], pages[i], min_t(size_t, PAGE_SIZE, size), 0);
+		size -= min_t(size_t, PAGE_SIZE, size);
 	}
 	return sglist;
 
-- 
1.7.1


