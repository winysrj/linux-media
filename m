Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:54937 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1BQUXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 15:23:11 -0500
Date: Thu, 17 Feb 2011 21:23:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paolo Santinelli <paolo.santinelli@unimore.it>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Kernel configuration for ov9655 on the PXA27x Quick Capture
 Interface
In-Reply-To: <AANLkTi=9hTp-s0UGKMNrTJOL0pzhnsunWkA6UwpobJE5@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1102172111300.30692@axis700.grange>
References: <AANLkTika03k=cppbejCHkuOT+Uq9ptVHZwYa80ubwLqT@mail.gmail.com>
 <Pine.LNX.4.64.1102172029220.30692@axis700.grange>
 <AANLkTi=9hTp-s0UGKMNrTJOL0pzhnsunWkA6UwpobJE5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

(replaced the old mailing list address)

On Thu, 17 Feb 2011, Paolo Santinelli wrote:

> Hi Guennadi,
> 
> thank you for the information.
> 
> Can I use or adapt this patch:  https://patchwork.kernel.org/patch/16548/  ?

You'd have to port it to the current kernel, the patch is almost 2 years 
old...

> I Could  use the code from the patch  to direct control the sensor
> register configuration and use the  PXA27x Quick Capture Interface to
> capture data by mean "soc_camera" and "pxa_camera" driver modules. But
> now when I try to load the soc_camera module i get this error:
> 
> insmod soc_camera.ko
> insmod: cannot insert 'soc_camera.ko': No such device
> 
> Please, could you give mi some tips and indication

No, all the drivers: soc-camera core, camera host driver (pxa_camera) and 
a camera sensor driver (ov9655) have to work together. And their mutual 
work is configured at the platform level. Sorry, I don't think, I can 
guide you in detail through a complete v4l2-subdev / soc-camera driver 
architecture. You can try to have a look at one of the multiple examples, 
e.g.,

arch/arm/mach-pxa/ezx.c (see a780_camera)
drivers/media/video/mt9m111.c
drivers/media/video/pxa_camera.c

Good luck
Guennadi

> 
> Thanks
> 
> Paolo
> 
> 2011/2/17 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> > On Wed, 16 Feb 2011, Paolo Santinelli wrote:
> >
> >> Hi all,
> >>
> >> I have an embedded smart camera equipped with an XScal-PXA270
> >> processor running Linux 2.6.37 and the OV9655 Image sensor connected
> >> on the PXA27x Quick Capture Interface.
> >>
> >> Please, what kernel module I have to select in order to use the Image sensor ?
> >
> > You need to write a new or adapt an existing driver for your ov9655
> > sensor, currently, there's no driver available to work with your pxa270.
> >
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> >
> 
> 
> 
> -- 
> --------------------------------------------------
> Paolo Santinelli
> ImageLab Computer Vision and Pattern Recognition Lab
> Dipartimento di Ingegneria dell'Informazione
> Universita' di Modena e Reggio Emilia
> via Vignolese 905/B, 41125, Modena, Italy
> 
> Cell. +39 3472953357,  Office +39 059 2056270, Fax +39 059 2056129
> email:  <mailto:paolo.santinelli@unimore.it> paolo.santinelli@unimore.it
> URL:  <http://imagelab.ing.unimo.it/> http://imagelab.ing.unimo.it
> --------------------------------------------------
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
