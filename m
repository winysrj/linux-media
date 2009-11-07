Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbZKGMlY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 07:41:24 -0500
Date: Sat, 7 Nov 2009 10:41:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: e9hack <e9hack@googlemail.com>
Cc: linux-media@vger.kernel.org, johann.friedrichs@web.de,
	hunold@linuxtv.org
Subject: Re: bug in changeset 13239:54535665f94b ?
Message-ID: <20091107104113.0df4593b@pedra.chehab.org>
In-Reply-To: <4AEDB05E.1090704@googlemail.com>
References: <4AEDB05E.1090704@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hartmut,

Em Sun, 01 Nov 2009 16:59:26 +0100
e9hack <e9hack@googlemail.com> escreveu:

> Hi,
> 
> something is wrong in changeset 13239:54535665f94b. After applying it, I get page faults
> in various applications:
> ...
> 
> If I remove the call to release_all_pagetables() in buffer_release(), I don't see this
> page faults.


Em Mon, 2 Nov 2009 21:27:44 +0100
e9hack@googlemail.com escreveu:

> the BUG is in vidioc_streamoff() for the saa7146. This function
> releases all buffers first, and stops the capturing and dma tranfer of
> the saa7146 as second. If the page table, which is currently used by
> the saa7146, is modified by another thread, the saa7146 writes
> anywhere to the physical RAM. IMHO vidioc_streamoff() must stop the
> saa7146 first and may then release the buffers.

I agree. We need first to stop DMA activity, and then release the page tables.

Could you please test if the enclosed patch fixes the issue?

Cheers,
Mauro

saa7146: stop DMA before de-allocating DMA scatter/gather page buffers

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/linux/drivers/media/common/saa7146_video.c b/linux/drivers/media/common/saa7146_video.c
--- a/linux/drivers/media/common/saa7146_video.c
+++ b/linux/drivers/media/common/saa7146_video.c
@@ -1334,9 +1334,9 @@ static void buffer_release(struct videob
 
 	DEB_CAP(("vbuf:%p\n",vb));
 
+	saa7146_dma_free(dev,q,buf);
+
 	release_all_pagetables(dev, buf);
-
-	saa7146_dma_free(dev,q,buf);
 }
 
 static struct videobuf_queue_ops video_qops = {
