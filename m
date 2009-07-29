Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38071 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbZG2TGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 15:06:34 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	v4l2_linux <linux-media@vger.kernel.org>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?Windows-1252?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?=
	<kyungmin.park@samsung.com>,
	"jm105.lee@samsung.com" <jm105.lee@samsung.com>,
	=?Windows-1252?Q?=EC=9D=B4=EC=84=B8=EB=AC=B8?=
	<semun.lee@samsung.com>,
	=?Windows-1252?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?=
	<inki.dae@samsung.com>,
	=?Windows-1252?Q?=EA=B9=80=ED=98=95=EC=A4=80?=
	<riverful.kim@samsung.com>
Date: Wed, 29 Jul 2009 14:06:17 -0500
Subject: RE: How to save number of times using memcpy?
Message-ID: <A69FA2915331DC488A831521EAE36FE401450FAE31@dlee06.ent.ti.com>
References: <10799.62.70.2.252.1248852719.squirrel@webmail.xs4all.nl>
In-Reply-To: <10799.62.70.2.252.1248852719.squirrel@webmail.xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hans,

>
>True. However, my experience is that this approach isn't needed in most
>cases as long as the v4l driver is compiled into the kernel. In that case
>it is called early enough in the boot sequence that there is still enough
>unfragmented memory available. This should definitely be the default case
>for drivers merged into v4l-dvb.
>
In my understanding, the buffer is allocated in the video buffer layer when driver makes the videobuf_reqbufs() call. Since this happens after the kernel is up, this is indeed a serious issue when we require HD resolution buffers. When I have tested vpfe capture from MT9T031 with 2048x1536 resolution buffer, the video buffer layer gives an oops due to failure to allocate buffer( I think video buffer layer is not handling error case when there are not enough buffers to allocate). Since buffer allocation happens very late (not at initialization), it is unlikely to succeed due to fragmentation issue. So I have added support for USERPTR IO in vpfe capture to handle high resolution capture. This requires a kernel module to allocate contiguous buffer and the same is returned to application using an IOCTL. The physical/logical address can then be given to driver through USERPTR IO.

Another way this can be done, when using mmap IO, is to allocate device memory (I have not tried it myself, but this seems to work in SOC Camera drivers) using dma_declare_coherent_memory() (Thanks to Guennadi Liakhovetski for the suggestion). This function takes physical memory address outside the kernel memory space. Then when dma_alloc_coherent() is called by video buffer layer, the buffer is allocated from the above pre-allocated device memory and will succeed always. But for this, the target architecture require support for consistent memory allocation.

Murali
>Regards,
>
>        Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

