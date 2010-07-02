Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o62Klsab021238
	for <video4linux-list@redhat.com>; Fri, 2 Jul 2010 16:47:55 -0400
Received: from smtpauth02.csee.onr.siteprotect.com
	(smtpauth02.csee.onr.siteprotect.com [64.26.60.136])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o62KlhpB005894
	for <video4linux-list@redhat.com>; Fri, 2 Jul 2010 16:47:44 -0400
Received: from [192.168.0.72] (unknown [70.96.116.236])
	(Authenticated sender: eric.nelson@boundarydevices.com)
	by smtpauth02.csee.onr.siteprotect.com (Postfix) with ESMTPA id
	6D48CE3800F
	for <video4linux-list@redhat.com>; Fri,  2 Jul 2010 15:47:42 -0500 (CDT)
Subject: Contiguous memory allocations
From: Eric Nelson <eric.nelson@boundarydevices.com>
To: video4linux-list@redhat.com
Date: Fri, 02 Jul 2010 13:47:40 -0700
Message-ID: <1278103660.6034.16.camel@localhost>
Mime-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Does anyone know if there's a common infrastructure for allocation
of DMA'able memory by drivers and applications above the straight
kernel API (dma_alloc_coherent)?

I'm working with Freescale i.MX51 drivers to do 720P video 
input and output and the embedded calls to dma_alloc_coherent
fail except when used right after boot because of fragmentation.

I'm fighting the urge to write yet another special-purpose allocator
for video buffers thinking this must be a common problem with a
solution already, but I can't seem to locate one.

The closest thing I've found is the bigphysarea patch, which doesn't
appear to be supported or headed toward main-line.

Thanks in advance,


Eric Nelson


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
