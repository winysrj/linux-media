Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m93HkKtP019353
	for <video4linux-list@redhat.com>; Fri, 3 Oct 2008 13:46:28 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m93HfDK9006381
	for <video4linux-list@redhat.com>; Fri, 3 Oct 2008 13:41:55 -0400
From: "Jadav, Brijesh R" <brijesh.j@ti.com>
To: Rob Kramer <robk@starhub.net.sg>, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Date: Fri, 3 Oct 2008 23:11:01 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403DC087DFD@dbde02.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE4AF7E5CAA@dlee06.ent.ti.com>,
	<200810031635.40168.robk@starhub.net.sg>
In-Reply-To: <200810031635.40168.robk@starhub.net.sg>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: RE: videobuf-dma-contig - buffer allocation at init time ?
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

Even dma_alloc_coherent fails after some time because of the memory fragmentation for the large buffer, which is required for the HD modes. This is typically in the Embedded devices because they have less memory. Is it possible to have a hook from the video-buf layer to the driver for allocating contiguous buffer so that allocation and de-allocation is managed in the driver completely?

Thanks,
Brijesh Jadav
________________________________________
From: video4linux-list-bounces@redhat.com [video4linux-list-bounces@redhat.com] On Behalf Of Rob Kramer [robk@starhub.net.sg]
Sent: Friday, October 03, 2008 3:35 AM
To: video4linux-list@redhat.com
Cc: Karicheri, Muralidharan
Subject: Re: videobuf-dma-contig - buffer allocation at init time ?

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


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
