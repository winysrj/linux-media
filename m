Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mASH0kVZ028670
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 12:00:46 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mASH0Xap028761
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 12:00:33 -0500
Date: Fri, 28 Nov 2008 18:00:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Maik Steuer <Maik.Steuer@gmx.de>
In-Reply-To: <20081128162609.107740@gmx.net>
Message-ID: <Pine.LNX.4.64.0811281755510.4430@axis700.grange>
References: <20081128145844.244860@gmx.net>
	<Pine.LNX.4.64.0811281613160.4430@axis700.grange>
	<20081128162609.107740@gmx.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

On Fri, 28 Nov 2008, Maik Steuer wrote:

> > I would suggest you tell us what camera you are going to use, maybe 
> > someone is already working on a driver for it. If not - you write a driver
> > yourself and start working with a real hardware.
> 
> At the moment the camera is only a FPGA which sends 8 Bit dummy data 
> with hsync, vsync and pixclock. So I can change all necessary parameters 
> for pxa requirements.
> 
> I throught that the ioctl (fd, VIDIOC_REQBUFS, &req) starts 
> soc_camera_reqbufs() but it isn't so.

Yes, this is indeed what should happen: see __video_do_ioctl() and around 
it. You're saying, that VIDIOC_REQBUFS is the first failing ioctl? Then 
just check what error code it returns, activate the 

	dev_dbg(&icd->dev, "%s: %d\n", __func__, p->memory);

in soc_camera.c::soc_camera_reqbufs(), etc.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
