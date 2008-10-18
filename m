Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9IKccOb026514
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 16:38:38 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9IKcQl2027305
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 16:38:27 -0400
Date: Sat, 18 Oct 2008 22:38:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Jadav, Brijesh R" <brijesh.j@ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739403DC2A8962@dbde02.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0810182237230.30019@axis700.grange>
References: <19F8576C6E063C45BE387C64729E739403DC2A8962@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: Physically Contiguous Buffer
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

On Sat, 18 Oct 2008, Jadav, Brijesh R wrote:

> I am working with a device, which can work with physically 
> non-contiguous buffer. Since physically contiguous buffer can also be 
> treated as non-contiguous buffer, device can also work with contiguous 
> buffer. I am using videobuf-dma-sg layer for the buffer manager of 
> non-contiguous buffer. The problem I am facing is since this layer does 
> not handle physically contiguous buffers, whenever I pass pointer to the 
> physically contiguous buffer to the videobuf_iolock function through 
> VIDIOC_QBUF ioctl, it returns me error. Since videobuf_iolock function 
> always calls get_user_pages to get the user land pages, it returns error 
> for this buffer. Can someone help in solving this problem? Is it 
> possible to treat physically contiguous buffer as non-contiguous buffer 
> and create a scatter-gather list in this layer?

Wouldn't videobuf-dma-contig.c solve your problem?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
