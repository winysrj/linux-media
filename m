Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39499 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755448AbZLKR3D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 12:29:03 -0500
Date: Fri, 11 Dec 2009 18:29:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alan Carvalho de Assis <acassis@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc_camera: OV2640
In-Reply-To: <37367b3a0912110856p24462203q481d6c330380c665@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0912111826300.5084@axis700.grange>
References: <37367b3a0912071113y41efc736h20a6fe203244811d@mail.gmail.com>
 <Pine.LNX.4.64.0912072052030.8481@axis700.grange>
 <37367b3a0912080842h601be618tdc4151ba226bbb60@mail.gmail.com>
 <37367b3a0912110856p24462203q481d6c330380c665@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 11 Dec 2009, Alan Carvalho de Assis wrote:

> Hi Guennadi,
> 
> On 12/8/09, Alan Carvalho de Assis <acassis@gmail.com> wrote:
> > Hi Guennadi,
> ...
> >>> I am trying to use an OV2640 camera with soc_camera.
> >>>
> >>> I'm using ov772x driver as base, but it needs too much modification to
> >>> work with ov2640.
> >>
> >> I don't know that sensor specifically, but they can be quite different.
> >>
> >
> > Yes, in fact ov2640 appears quite different compared to ov772x and ov9640.
> >
> >>> The OV2640 chip remaps all registers when register 0xFF is 1 or when it
> >>> is
> >>> 0.
> >>
> >> This is not unusual. There are a few ways to implement this, for example,
> >> drivers/media/video/rj54n1cb0c.c uses 16-bit addresses, and decodes them
> >> to bank:register pairs in its reg_read() and reg_write() routines.
> >>
> >
> > Ok, I will try to implement it this way, case nobody suggests me a
> > better approach.
> >
> 
> I got mx27_camera from pengutronix tree and modified it to work with
> kernel 2.6.32 (few modifications).

Sorry, I cannot help you with an out-of-tree driver, and generally I would 
expect significant changes when going to 2.6.32.

> I added platform data/device on my
> board using pcm970-baseboard.c as example.
> 
> In the kernel config I selected:
> CONFIG_VIDEO_MX27
> CONFIG_SOC_CAMERA_OV9640
> 
> 
> I noticed a strange behavior: the ov9640 driver is called before mx27_camera:
> 
> Linux video capture interface: v2.00
> >>> Probe OK until now, going to ProbeVideo <<<
> >>> Probing OV9640 <<<
> Parent missing or invalid!
> Driver for 1-wire Dallas network protocol.
> i.MX SDHC driver
> usbcore: registered new interface driver usbhid
> usbhid: v2.6:USB HID core driver
> oprofile: using timer interrupt.
> TCP cubic registered
> NET: Registered protocol family 17
> mx27-camera mx27-camera.0: initialising
> >>> mx27_camera: IRQ request OK!
> >>> mx27_camera: pcdev OK!
> >>> mx27_camera: clk_csi OK!
> mx27-camera mx27-camera.0: Camera clock frequency: 26600000
> >>> mx27_camera: DMA request OK!
> mx27-camera mx27-camera.0: Using EMMA
> >>> mx27_camera: probe OK until now!
> mx27-camera mx27-camera.0: Non-NULL drvdata on register
> >>> mx27_camera: soc_camera_host_register returned 0!
> 
> Then ov9640 returns error because icd->dev.parent doesn't exist.
> 
> Did you already see this issue?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
