Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m938bLQa013011
	for <video4linux-list@redhat.com>; Fri, 3 Oct 2008 04:37:21 -0400
Received: from surfgate2.starhub.net.sg (surfgate2.starhub.net.sg
	[203.117.3.7])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m938aOIO025238
	for <video4linux-list@redhat.com>; Fri, 3 Oct 2008 04:36:32 -0400
Received: from wrobbie.localdomain ([203.117.215.163])
	by kbsmtao1.starhub.net.sg
	(Sun Java System Messaging Server 6.2-9.07 (built Oct 18 2007))
	with ESMTPP id <0K8500I4PMJHQ6M0@kbsmtao1.starhub.net.sg> for
	video4linux-list@redhat.com; Fri, 03 Oct 2008 16:35:41 +0800 (SGT)
Date: Fri, 03 Oct 2008 16:35:39 +0800
From: Rob Kramer <robk@starhub.net.sg>
In-reply-to: <A69FA2915331DC488A831521EAE36FE4AF7E5CAA@dlee06.ent.ti.com>
To: video4linux-list@redhat.com
Message-id: <200810031635.40168.robk@starhub.net.sg>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <A69FA2915331DC488A831521EAE36FE4AF7E5CAA@dlee06.ent.ti.com>
Cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: videobuf-dma-contig - buffer allocation at init time ?
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

Hia,

On 23 September 2008, Karicheri, Muralidharan wrote:
> 1) Why the allocation of buffer done as part of mmap() not at the
> init time?  Usually video capture requires big frame buffers of 4M or so,
> if HD capture is involved. So in our driver (based on 2.6.10) we allocate
> the buffer at driver initialization and had a hacked version of the buffer
> allocation module which used this pre-allocated frame buffer address ptrs
> during mmap. Allocating buffer of such big size during kernel operation is
> likely to fail due to fragmentation of buffers. 

The original videobuf-dma-contig patch had the following comment:

"Since it may be difficult to allocate large chunks of physically
contiguous memory after some uptime due to fragmentation, this code
allocates memory using dma_alloc_coherent(). Architectures supporting
dma_declare_coherent_memory() can easily avoid fragmentation issues
by using dma_declare_coherent_memory() to force dma_alloc_coherent()
to allocate from a certain pre-allocated memory area."

I'm facing the same issue with a Zoran Vaddis driver I'm writing. I haven't 
seen fragmentation issues yet because the buffer size is much smaller at 256k 
or so, but I probably should pre-allocate too.

I couldn't quite figure out how dma_declare_coherent_memory() is used; there 
is no use-case anywhere in the kernel that I can make sense of.

Cheers!

    Rob

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
