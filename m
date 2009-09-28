Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:34849 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZI1KtI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 06:49:08 -0400
Received: from smtp06.web.de (fmsmtp06.dlan.cinetic.de [172.20.5.172])
	by fmmailgate03.web.de (Postfix) with ESMTP id E2F5711BD09C1
	for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 12:49:11 +0200 (CEST)
Received: from [91.13.103.153] (helo=[192.168.2.214])
	by smtp06.web.de with asmtp (WEB.DE 4.110 #314)
	id 1MsDn2-0005Ka-00
	for linux-media@vger.kernel.org; Mon, 28 Sep 2009 12:49:08 +0200
Message-ID: <4AC094A2.4070806@web.de>
Date: Mon, 28 Sep 2009 12:49:06 +0200
From: Johann Friedrichs <johann.friedrichs@web.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] saa7146 memory leakage in pagetable-handling
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is necessary to release the allocated pgtables in buffer_release. It 
is now done only in buffer_prepare. This will not work if a new 
videobuf_buffer has been requested since the last call, as the former 
pointers are lost.
Signed-off-by: johann.friedrichs@web.de

--- a/drivers/media/common/saa7146_video.c      2009-04-17 
21:42:35.000000000 +0200
+++ b/drivers/media/common/saa7146_video.c      2009-09-22 
09:03:50.000000000 +0200
@@ -1331,6 +1331,9 @@ static void buffer_release(struct videob

         DEB_CAP(("vbuf:%p\n",vb));
         saa7146_dma_free(dev,q,buf);
+       saa7146_pgtable_free(dev->pci, &buf->pt[0]);
+       saa7146_pgtable_free(dev->pci, &buf->pt[1]);
+       saa7146_pgtable_free(dev->pci, &buf->pt[2]);
  }

  static struct videobuf_queue_ops video_qops = {
