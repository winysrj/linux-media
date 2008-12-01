Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1EbGft031549
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 09:37:16 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1EbEiN008873
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 09:37:14 -0500
Date: Mon, 1 Dec 2008 12:37:04 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20081201123704.2c7d99fc@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0812011140350.3915@axis700.grange>
References: <20081128145844.244860@gmx.net>
	<Pine.LNX.4.64.0811281613160.4430@axis700.grange>
	<20081128162609.107740@gmx.net>
	<Pine.LNX.4.64.0811281755510.4430@axis700.grange>
	<20081201103505.79550@gmx.net>
	<Pine.LNX.4.64.0812011140350.3915@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Maik Steuer <Maik.Steuer@gmx.de>,
	kernel@pengutronix.de
Subject: Re: testing soc_camera with mt9m001 on pxa270
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

On Mon, 1 Dec 2008 11:43:04 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Mon, 1 Dec 2008, Maik Steuer wrote:
> 
> > -------- Original-Nachricht --------
> > > Datum: Fri, 28 Nov 2008 18:00:47 +0100 (CET)
> > > Von: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > An: Maik Steuer <Maik.Steuer@gmx.de>
> > > CC: kernel@pengutronix.de, video4linux-list@redhat.com
> > > Betreff: Re: testing soc_camera with mt9m001 on pxa270
> > 
> > > On Fri, 28 Nov 2008, Maik Steuer wrote:
> > > 
> > > > > I would suggest you tell us what camera you are going to use, maybe 
> > > > > someone is already working on a driver for it. If not - you write a
> > > driver
> > > > > yourself and start working with a real hardware.
> > > > 
> > > > At the moment the camera is only a FPGA which sends 8 Bit dummy data 
> > > > with hsync, vsync and pixclock. So I can change all necessary parameters
> > > > for pxa requirements.
> > > > 
> > > > I throught that the ioctl (fd, VIDIOC_REQBUFS, &req) starts 
> > > > soc_camera_reqbufs() but it isn't so.
> > > 
> > > Yes, this is indeed what should happen: see __video_do_ioctl() and around 
> > > it. You're saying, that VIDIOC_REQBUFS is the first failing ioctl? Then 
> > 
> > Yes, VIDIOC_REQBUFS is the first failling. The right case construction 
> > wasn't called. I printed out the commited ioctl cmd and the unsigned 
> > integer value for VIDIOC_REQBUFS:
> > 
> > <7>pxa27x-camera: VIDIOC_REQBUFS
> > <7>switch(c0105608) VIDIOC_REQBUFS = c0145608
> > 
> > They are different! That's the problem. The capture.c example use 
> > #include <linux/videodev2.h> but the v4l2-ioctl.c use declarations in 
> > #include <media/v4l2-ioctl.h> for the VIDIOC_REQBUF define macro.
> > 
> > Is there a known version conflict?
> 
> Oops, not to me. Mauro?

v4l2-ioctl.h doesn't define VIDIOC_REQBUF. It just includes linux/videodev2.h, as:

linux/include/linux/videodev2.h:#define VIDIOC_REQBUFS          _IOWR('V',  8, struct v4l2_requestbuffers)

Can you double check what #define are you using with the driver and with the userspace?

Maybe the macro is wrongly evaluated or you're linking against a broken version of the file.

There's another possibility:

the 3rd argument of the macro is used to determine the size of the parameter.
The size of the struct may vary (depending on how the struct is defined),
depending on the architecture.

In the case of this macro, it is defined as:

struct v4l2_requestbuffers {
        __u32                   count;
        enum v4l2_buf_type      type;
        enum v4l2_memory        memory;
        __u32                   reserved[2];
};

On most architectures, enum is evaluated as a 32 bits data. So, the size of the
struct is 16. However, on a few architectures, like arm, enum is generally
evaluated as 8 bits. You can see some discussions about this at [1]. The fix on
ARM is to pass an additional compilation parameter on ARM [2]. Probably,
something like this is needed also when compiling v4l utils.

[1] http://threebit.net/mail-archive/video4linux/msg01880.html
[2] http://threebit.net/mail-archive/video4linux/msg02037.html

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
