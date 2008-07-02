Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m627oH3O025077
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 03:50:17 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m627o6TB031507
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 03:50:06 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KDx6I-0004M7-9V
	for video4linux-list@redhat.com; Wed, 02 Jul 2008 07:50:02 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 02 Jul 2008 07:50:02 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 02 Jul 2008 07:50:02 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Wed, 02 Jul 2008 10:43:19 +0300
Message-ID: <486B3197.5000100@teltonika.lt>
References: <20080701124638.30446.81449.sendpatchset@rx1.opensource.se>
	<20080701124735.30446.89320.sendpatchset@rx1.opensource.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20080701124735.30446.89320.sendpatchset@rx1.opensource.se>
Cc: video4linux-list@redhat.com, linux-sh@vger.kernel.org
Subject: Re: [PATCH 06/07] videobuf: Add physically contiguous queue code
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

Heh. I have written almost identical videobuf driver also :)
You should run checkpatch.pl on this patch to correct some style
problems. Since your version is a little bit more generic than mine:

Acked-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>

Magnus Damm wrote:
> This patch adds support for videobuf queues made from physically
> contiguous memory. Useful for hardware such as the SuperH Mobile CEU
> which doesn't support scatter gatter bus mastering.
> 
> Since it may be difficult to allocate large chunks of physically
> contiguous memory after some uptime due to fragmentation, this code
> allocates memory using dma_alloc_coherent(). Architectures supporting
> dma_declare_coherent_memory() can easily avoid fragmentation issues
> by using dma_declare_coherent_memory() to force dma_alloc_coherent()
> to allocate from a certain pre-allocated memory area.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
