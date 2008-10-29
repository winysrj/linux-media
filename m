Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9TJNhaw024728
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 15:23:43 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9TJNVh2015015
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 15:23:31 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>) id 1KvGdu-0002Ay-Uk
	for video4linux-list@redhat.com; Wed, 29 Oct 2008 20:23:46 +0100
Date: Wed, 29 Oct 2008 20:23:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0810291916210.7926@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [Q] doubt regarding video data format
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

Hi all

while working on a v4l2 / soc-camera driver for the i.MX31 ARM11 SoC I was 
trying to use its Image DMA Controller's "support" for non-contiguous 
buffers, i.e., sg-dma. However, it turned out, that the IDMAC only can DMA 
data to / from sg-buffers in units of rows. Which means, if I use 
videobuf-dma-sg.c with, for example, 640x480 resolution 2 bytes per pixel 
I get 1280 bytes per row, 3 rows fit in a page, which makes 3840 bytes and 
256 bytes are left in each page... To me it looks like this practically 
rules out the use of this "support" and forces me to use contiguous 
buffers. Am I right or is there a good way to make use of this 
functionality?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
