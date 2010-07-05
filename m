Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o65AAkjB028416
	for <video4linux-list@redhat.com>; Mon, 5 Jul 2010 06:10:46 -0400
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.186])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o65AAF2H019294
	for <video4linux-list@redhat.com>; Mon, 5 Jul 2010 06:10:36 -0400
Message-ID: <4C31AF7E.7090602@2net.co.uk>
Date: Mon, 05 Jul 2010 11:10:06 +0100
From: Chris Simmonds <chris.simmonds@2net.co.uk>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: Re: Contiguous memory allocations
References: <1278103660.6034.16.camel@localhost>
In-Reply-To: <1278103660.6034.16.camel@localhost>
Reply-To: chris@2net.co.uk
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On 02/07/10 21:47, Eric Nelson wrote:
> Does anyone know if there's a common infrastructure for allocation
> of DMA'able memory by drivers and applications above the straight
> kernel API (dma_alloc_coherent)?
>
> I'm working with Freescale i.MX51 drivers to do 720P video
> input and output and the embedded calls to dma_alloc_coherent
> fail except when used right after boot because of fragmentation.
>
> I'm fighting the urge to write yet another special-purpose allocator
> for video buffers thinking this must be a common problem with a
> solution already, but I can't seem to locate one.
>
> The closest thing I've found is the bigphysarea patch, which doesn't
> appear to be supported or headed toward main-line.
>
> Thanks in advance,
>

dma_alloc_coherent is pretty much just a wrapper round get_free_pages, 
which is the lowest level allocator in the kernel. So, no there is no 
other option (but see below). The simplest thing is to make sure your 
driver is loaded at boot time and to grab all the memory you need then 
and never let it go. That's what I do.

If you are desperate, you can use the bigphysarea patch - it's quite 
common on streaming video devices - but you will have to port it to your 
kernel. Or, you can restrict the memory the kernel uses with something 
like "mem=128M" on the command line and take that above 128M for 
yourself. You will have to map it in with ioremap(_nocache).

Bye for now,
Chris.

-- 
Chris Simmonds                   2net Limited
chris@2net.co.uk                 http://www.2net.co.uk/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
