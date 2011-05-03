Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:53134 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab1ECGeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 02:34:17 -0400
Date: Tue, 3 May 2011 08:34:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?GB2312?B?wNbD9A==?= <lemin9538@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: problems on soc-camera subsystem
In-Reply-To: <BANLkTiku=G-9rJQT9i59CzQkJ+RSo2fPSA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1105030817030.15004@axis700.grange>
References: <BANLkTiku=G-9rJQT9i59CzQkJ+RSo2fPSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The original email was blocked by vger, because it contained HTML. I'm 
quoting it in my reply unchanged for all to read and comment.

On Tue, 3 May 2011, ÀÖÃô wrote:

> Dear Guennadi:
> 
> 
> 
> >           Thank you for your advice.This is my first time to write
> > camera driver.We need two camera sensors in our project.But I do not
> > know whether the host can connect multiple sensors or not.
> >
> > >>        I am very sorry to take up your precious time. These days I
> > >> studied the soc_camera subsystem which was wrote by you,the biggest
> > >> problem I can not understant is how can I register a
> > > >soc_camera_device.when reading the source,I found that
> > > >soc_camera_device_register() was declared as a static function,it was
> > > >not exported to the kernel,and it's only called by
> > > >soc_camera_pdrv_probe() one time,this means if there are two camera
> > > >sensors connected to the camera host,I want to register two platform
> > > >devices whose name is "soc-camera-pdrv", but this isunacceptable.could
> > > >it be said that I can only use one camera sensor if I use the
> soc_camera
> > > >subsystem?
> > >No, in principle you can use multiple sensors. But you have to explain
> (1)
> > >whether both your sensors are of the same type, (2) how they are
> connected
> > >to one host, (3) how you are going to switch between them, (4) whether
> > >they use the same i2c address or not. Then we can discuss how you can
> > >represent them in your platform data.
> >
> > (1)  The CPU is Renesas's sh_mobile_7372,on the cpu there is a host
> > interface called Capture Engine Unit (CEU).It can conncet camera sensors
> > directly.There is another interface called Camera Serial Interface
> > (CSI2),
> > it can connect a MIPI-CSI2 standard serial camera sensor,the CSI
> > Performs serial-to-parallel conversion of data from a camera . And CSI2
> > passes parallel data to CEU. The following sentences is come from the
> > datasheet of the CPU.
> >
> > /*************************************************/
> >
> > List the three homologous series for the interface connecting to camera as
> follows.
> >     16-bit input for a main camera.
> >     8-bit input for a sub camera (This LSI doesn't mount PAD for sub-
> camera.)
> >     32-bit input from CSI2C.
> >
> > /*************************************************/
> >
> > (2)Now I plan to connect two sensors to the CEU, 16-bit input for a
> > main camera and 32-bit input from CSI2,they are not the same type and
> > using different I2C address. Can this able to work well?

It should work, yes.

> > (3) There is a host only, so I think if there are two camera
> > sensors,when one sensor is working,another sensor will be poweroff and
> > can not be actived.The method to switch between them I think is to close
> > the sensor which is not in use.
> >
> > Can you tell me whether the CEU can connect multiple sensors or not,If
> > yes,are there some restrictions?

It should work, yes. Currently soc-camera handles client devices (e.g., 
sensors) in the following way: first during probing it attaches each such 
client device to the host, performs probing _and_ detaches it immediately. 
Then at open() the same happens - only the respective sensor is attached 
to the host, so, the CEU driver only has to deal with one sensor at a 
time. Just make sure to not try to open both nodes at the same time.

> > If it supports multiple sensors ,what should I do?

Just that - write two independent sensor drivers and two platform data 
blocks for them in your board file. Then open and operate each sensor 
independently. You also might want to provide platform struct 
soc_camera_link::power() and / or reset() callbacks.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
