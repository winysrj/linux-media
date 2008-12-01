Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1AZKBN007467
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 05:35:20 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB1AZ51m023256
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 05:35:06 -0500
Content-Type: text/plain; charset="iso-8859-1"
Date: Mon, 01 Dec 2008 11:35:05 +0100
From: "Maik Steuer" <Maik.Steuer@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0811281755510.4430@axis700.grange>
Message-ID: <20081201103505.79550@gmx.net>
MIME-Version: 1.0
References: <20081128145844.244860@gmx.net>
	<Pine.LNX.4.64.0811281613160.4430@axis700.grange>
	<20081128162609.107740@gmx.net>
	<Pine.LNX.4.64.0811281755510.4430@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, kernel@pengutronix.de
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

-------- Original-Nachricht --------
> Datum: Fri, 28 Nov 2008 18:00:47 +0100 (CET)
> Von: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> An: Maik Steuer <Maik.Steuer@gmx.de>
> CC: kernel@pengutronix.de, video4linux-list@redhat.com
> Betreff: Re: testing soc_camera with mt9m001 on pxa270

> On Fri, 28 Nov 2008, Maik Steuer wrote:
> 
> > > I would suggest you tell us what camera you are going to use, maybe 
> > > someone is already working on a driver for it. If not - you write a
> driver
> > > yourself and start working with a real hardware.
> > 
> > At the moment the camera is only a FPGA which sends 8 Bit dummy data 
> > with hsync, vsync and pixclock. So I can change all necessary parameters
> > for pxa requirements.
> > 
> > I throught that the ioctl (fd, VIDIOC_REQBUFS, &req) starts 
> > soc_camera_reqbufs() but it isn't so.
> 
> Yes, this is indeed what should happen: see __video_do_ioctl() and around 
> it. You're saying, that VIDIOC_REQBUFS is the first failing ioctl? Then 

Yes, VIDIOC_REQBUFS is the first failling. The right case construction wasn't called. I printed out the commited ioctl cmd and the unsigned integer value for VIDIOC_REQBUFS:

<7>pxa27x-camera: VIDIOC_REQBUFS
<7>switch(c0105608) VIDIOC_REQBUFS = c0145608

They are different! That's the problem. The capture.c example use #include <linux/videodev2.h> but the v4l2-ioctl.c use declarations in #include <media/v4l2-ioctl.h> for the VIDIOC_REQBUF define macro. 

Is there a known version conflict?

> just check what error code it returns, activate the 
> 
> 	dev_dbg(&icd->dev, "%s: %d\n", __func__, p->memory);
> 
> in soc_camera.c::soc_camera_reqbufs(), etc.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer


greets
Maik
-- 
Sensationsangebot verlängert: GMX FreeDSL - Telefonanschluss + DSL 
für nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K1308T4569a

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
