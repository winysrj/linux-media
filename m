Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37090 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753963AbZFKP6J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 11:58:09 -0400
Date: Thu, 11 Jun 2009 17:58:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: mt9t031 (was RE: [PATCH] adding support for setting bus parameters
 in sub device)
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40139A09039@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0906111755550.5625@axis700.grange>
References: <1244580891-24153-1-git-send-email-m-karicheri2@ti.com>
 <Pine.LNX.4.64.0906102022320.4817@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139A08DC3@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0906102303190.4817@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139A08E4F@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0906102337130.4817@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139A08E67@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0906110112590.4817@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139A09039@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 11 Jun 2009, Karicheri, Muralidharan wrote:

> >On Wed, 10 Jun 2009, Karicheri, Muralidharan wrote:
> >
> >> So how do I know what frame-rate I get? Sensor output frame rate depends
> >> on the resolution of the frame, blanking, exposure time etc.
> >
> >This is not supported.
> >
> I am still not clear. You had said in an earlier email that it can 
> support streaming. That means application can stream frames from the 
> capture device.
> I know you don't have support for setting a specific frame rate, but it 
> must be outputting frame at some rate right?

I am sorry, I do not know how I can explain myself clearer.

Yes, you can stream video with mt9t031.

No, you neither get the framerate measured by the driver nor can you set a 
specific framerate. Frames are produced as fast as it goes, depending on 
clock settings, frame size, black areas, autoexposure.

Thanks
Guennadi

> 
> Here is my usecase.
> 
> open capture device,
> set resolutions (say VGA) for capture (S_FMT ???)
> request buffer for streaming & mmap & QUERYBUF
> start streaming (STREAMON)
> DQBUF/QBUF in a loop -> get VGA buffers at some fps.
> STREAMOFF
> close device
> 
> Is this possible with mt9t031 available currently in the tree? This requires sensor device output frames continuously on the bus using PCLK/HSYNC/VSYNC timing to the bridge device connected to the bus. Can you give a use case like above that you are using. I just want to estimate how much effort is required to add this support in the mt9t031 driver.
> 
> Thanks
> 
> Murali
> 
> >Thanks
> >Guennadi
> >---
> >Guennadi Liakhovetski, Ph.D.
> >Freelance Open-Source Software Developer
> >http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
