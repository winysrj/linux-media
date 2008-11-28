Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mASFHo6P014574
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 10:17:50 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mASFGgjO031941
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 10:16:42 -0500
Date: Fri, 28 Nov 2008 16:16:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Maik Steuer <Maik.Steuer@gmx.de>
In-Reply-To: <20081128145844.244860@gmx.net>
Message-ID: <Pine.LNX.4.64.0811281613160.4430@axis700.grange>
References: <20081128145844.244860@gmx.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
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

On Fri, 28 Nov 2008, Maik Steuer wrote:

> Hello,
> 
> I'm testing at the moment the capture interface with the soc-camera and 
> mt9m001 driver.
> 
> I fixed all I2C routines to test without any connected camera like 
> mt9m001, because we want to use another camera hardware as mt9m001.
> 
> To read out the capture buffer I use the example project capture.c from 
> V4L2-API with mmap(). The ioctl (fd, VIDIOC_REQBUFS, &req) at the 
> beginning of initialization fails.  I have debuged the most important 
> parts of the driver (pxa_camera, soc_camera and mt9m001) but I can't 
> find the mistake.
> 
> Any Idea?

Sorry, no. Without knowing what kernel version you're using, without 
seeing your "fixes to all I2C routines" I don't think anyone would be able 
to tell you what the problem is. And anyway you wouldn't get too far 
without a real camera - at best when the pxa will start capturing, it will 
timeout waiting for sync signals. Maybe you would be able to do this if 
you switch to the slave mode, but beware, that this mode hasn't been 
tested.

I would suggest you tell us what camera you are going to use, maybe 
someone is already working on a driver for it. If not - you write a driver 
yourself and start working with a real hardware.

Thanks
Guennadi

> 
> 
> Here is a short log, which functions were called:
> 
> [@Linux /opt]#./capture -m
> soc_camera_open()
> pxa_camera_add_device() !!!
> camera 0-0: PXA Camera driver attached to camera 0
> pxa_camera_activate() !!!
> mt9m001_init() !
> pxa_camera_add_device() ret !!!
> pxa_camera_init_videobuf() !!!
> soc_camera_querycap()
> soc_camera_querycap() ret 0
> soc_camera_cropcap()
> soc_camera_s_crop()
> mt9m001_set_fmt_cap() !
> mt9m001_set_fmt_cap() ! ret 0
> soc_camera_s_crop() ret 0
> soc_camera_s_fmt_vid_cap()
> soc_camera_try_fmt_vid_cap()
> pxa_camera_try_bus_param() !!!
> 	test_platform_param() !!!
> buswidth 8 flags 3133
> 	buswidth 8 flags 3197
> mt9m001_query_bus_param() !
> bus_switch_possible() !
> width_flag 455
> soc_camera_bus_param_compatible() ret 1109 !!!
> mt9m001_try_fmt_cap() !
> try_fmt__cap() ret 0
> soc_camera_try_fmt_vid_cap() ret 0
> mt9m001_set_fmt_cap() !
> mt9m001_set_fmt_cap() ! ret 0
> pxa_camera_set_bus_param()!!!
> 	test_platform_param() !!!
> buswidth 8 flags 3133
> 	buswidth 8 flags 3197
> mt9m001_query_bus_param()!
> bus_switch_possible()!
> width_flag 455
> mt9m001_set_bus_param()!
> flags 1109 datawidth 8 width_flags 64
> pxa_camera_set_bus_param() ret 0 !!!
> soc_camera_s_fmt_vid_cap() ret 0 
> /dev/video does not support memory mapping
> soc_camera_close()
> camera 0-0: PXA Camera driver detached from camera 0
> mt9m001_release() !
> 
> 
> greets
> 
> Maik
> -- 
> Sensationsangebot nur bis 30.11: GMX FreeDSL - Telefonanschluss + DSL 
> für nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K11308T4569a
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
