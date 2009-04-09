Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3975JPr029202
	for <video4linux-list@redhat.com>; Thu, 9 Apr 2009 03:05:19 -0400
Received: from m15-13.126.com (m15-13.126.com [220.181.15.13])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n3974vAZ030619
	for <video4linux-list@redhat.com>; Thu, 9 Apr 2009 03:04:58 -0400
Date: Thu, 9 Apr 2009 15:04:55 +0800 (CST)
From: "figo.zhang" <figo1802@126.com>
To: video4linux-list <video4linux-list@redhat.com>
Message-ID: <18455608.278591239260695776.JavaMail.coremail@bj126app13.126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 7bit
Subject: how to mmap which using dma_map_sg() alloc dma buf
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


hi, all:
i have a question, who would like to help me.

i am writing a video card driver, it support scatter DMA, so i want to using scatterlist and dma_map_sg() to alloc the dma buf, but now i dont know how to write the mmap() function.
i see other code using remap_pfn_range(). but in the video_dma_sg.c, __videobuf_mmap_mapper() have not call remap_pfn_range(), why?

Thx,
Figo
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
