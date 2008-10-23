Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9N85TtE000514
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 04:05:29 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9N85OEk023817
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 04:05:24 -0400
Received: by yw-out-2324.google.com with SMTP id 5so38161ywb.81
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 01:05:24 -0700 (PDT)
Message-ID: <aec7e5c30810230105l7d8be417h783c62ff9ee1d6d0@mail.gmail.com>
Date: Thu, 23 Oct 2008 17:05:23 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Jadav, Brijesh R" <brijesh.j@ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739403DC31BF9C@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19F8576C6E063C45BE387C64729E739403DC2A8962@dbde02.ent.ti.com>
	<Pine.LNX.4.64.0810182237230.30019@axis700.grange>
	<19F8576C6E063C45BE387C64729E739403DC31BF9C@dbde02.ent.ti.com>
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
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

Hi Jadav,

Please try to avoid top-posting. It makes it difficult to follow the
conversation.

On Tue, Oct 21, 2008 at 1:11 PM, Jadav, Brijesh R <brijesh.j@ti.com> wrote:
>> From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>> On Sat, 18 Oct 2008, Jadav, Brijesh R wrote:
>>> I am working with a device, which can work with physically
>>> non-contiguous buffer. Since physically contiguous buffer can also be
>>> treated as non-contiguous buffer, device can also work with contiguous
>>> buffer. I am using videobuf-dma-sg layer for the buffer manager of
>>> non-contiguous buffer. The problem I am facing is since this layer does
>>> not handle physically contiguous buffers, whenever I pass pointer to the
>>> physically contiguous buffer to the videobuf_iolock function through
>>> VIDIOC_QBUF ioctl, it returns me error. Since videobuf_iolock function
>>> always calls get_user_pages to get the user land pages, it returns error
>>> for this buffer. Can someone help in solving this problem? Is it
>>> possible to treat physically contiguous buffer as non-contiguous buffer
>>> and create a scatter-gather list in this layer?
>>
>> Wouldn't videobuf-dma-contig.c solve your problem?
>>
>> Thank you for your reply. I think videobuf layer videobuf-dma-contig is for the physically contiguous buffer. It does not handle non-contiguous buffer so I will not be able to use it because my device handles non-contiguous buffer. Isn't it possible to handle in videobuf-dma-sg layer such that it makes scatter gather list out of physically contiguous buffer also?

Please look at how videobuf_to_dma() is used in pxa_camera.c. That's a
good example for non-contiguous memory. The sh_mobile_ceu driver is a
good example driver using physically contiguous memory.

It sounds like you want to use something similar to extents from the
filesystem world. So you want to have a list of ranges of physically
contiguous pages. I don't think the videobuf-dma-sg helper code
supports that today.

I recommend you write and submit code that is as simple as possible.
If your hardware can do scatter gather on N physically contiguous
pages then you can easily use the videobuf-dma-contig code and just
program your hardware to do a single range. Or you can use the
videobuf-dma-sg code. It's up to you. =)

Cheers,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
