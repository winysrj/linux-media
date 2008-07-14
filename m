Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6ECPE41019259
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 08:25:14 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6ECP3UB017466
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 08:25:03 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KIN71-00066B-0r
	for video4linux-list@redhat.com; Mon, 14 Jul 2008 12:25:03 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 12:25:03 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 12:25:03 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Mon, 14 Jul 2008 15:20:34 +0300
Message-ID: <487B4492.2020301@teltonika.lt>
References: <20080714120204.4806.87287.sendpatchset@rx1.opensource.se>
	<20080714120240.4806.15664.sendpatchset@rx1.opensource.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20080714120240.4806.15664.sendpatchset@rx1.opensource.se>
Cc: video4linux-list@redhat.com, linux-sh@vger.kernel.org
Subject: Re: [PATCH 04/06] videobuf: Add physically contiguous queue code V3
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

Magnus Damm wrote:
> This is V3 of the physically contiguous videobuf queues patch.
> Useful for hardware such as the SuperH Mobile CEU which doesn't
> support scatter gatter bus mastering.
                   gather
                      ^
> 
> Since it may be difficult to allocate large chunks of physically
> contiguous memory after some uptime due to fragmentation, this code
> allocates memory using dma_alloc_coherent(). Architectures supporting
> dma_declare_coherent_memory() can easily avoid fragmentation issues
> by using dma_declare_coherent_memory() to force dma_alloc_coherent()
> to allocate from a certain pre-allocated memory area.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>

Tested-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
