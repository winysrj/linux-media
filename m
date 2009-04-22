Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3M9oLmn030407
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 05:50:21 -0400
Received: from co203.xi-lite.net (co203.xi-lite.net [149.6.83.203])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3M9o6nf000334
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 05:50:06 -0400
Message-ID: <49EEE84A.5090400@parrot.com>
Date: Wed, 22 Apr 2009 11:50:02 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
MIME-Version: 1.0
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: videobuf-dma-contig sync question
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,


I don't understand why __videobuf_sync in videobuf-dma-contig isn't a nop.

All the memory allocated by videobuf-dma-contig is coherent memory. And
Documentation/DMA-API.txt seems to imply that this memory is coherent
and doesn't need extra cache operation for synchronization.

Also calling dma_sync_single_for_cpu cause panic on arm for per-device
coherent memory, because the memory isn't in the main memory[1].

Why __videobuf_sync need dma_sync_single_for_cpu ?

Regards,

Matthieu



[1]
void dma_cache_maint(const void *start, size_t size, int direction)
{
    const void *end = start + size;

    BUG_ON(!virt_addr_valid(start) || !virt_addr_valid(end - 1));

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
