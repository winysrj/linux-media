Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9S9xMqA032118
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 05:59:22 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9S9xKjW029281
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 05:59:21 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>) id 1KulMF-0001Yc-Or
	for video4linux-list@redhat.com; Tue, 28 Oct 2008 10:59:27 +0100
Date: Tue, 28 Oct 2008 10:59:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0810281040330.5432@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [Q] difference between size and bsize in struct videobuf_buffer
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

I am confused by the purpose of the above two fields. In the struct 
videobuf_buffer definition "size" is under "info about the buffer," and 
bsize is "buffer size." Looking through drivers, it looks like "bsize" is 
the buffer size, and "size" is the data size. But then why does 
videobuf-dma-sg.c in __videobuf_iolock() in kernel bounce buffer case 
allocates based on "size:"

			pages = PAGE_ALIGN(vb->size) >> PAGE_SHIFT;

and in what, I think, is the "normal" case of mmap on V4L2_MEMORY_MMAP 
memory indeed "bsize" is used to call videobuf_dma_init_user_locked()?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
