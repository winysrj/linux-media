Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:58486 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1A0RK1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 12:10:27 -0500
Date: Thu, 27 Jan 2011 18:10:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Uzycki <janusz.uzycki@elproma.com.pl>
cc: g.daniluk@elproma.com.pl,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: SoC Camera driver and TV decoder
In-Reply-To: <F95361ABAE1D4A70A10790A798004482@laptop2>
Message-ID: <Pine.LNX.4.64.1101271809030.8916@axis700.grange>
References: <1E539FC23CF84B8A91428720570395E0@laptop2>
 <Pine.LNX.4.64.1101241720001.17567@axis700.grange> <AD14536027B946D6B4504D4F43E352A5@laptop2>
 <Pine.LNX.4.64.1101262045550.3989@axis700.grange> <F95361ABAE1D4A70A10790A798004482@laptop2>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 27 Jan 2011, Janusz Uzycki wrote:

> Hello Guennadi again.
> 
> I patched tvp5150.c according to tw9910 driver (without real cropping
> support yet).
> Unfortunately I got the messages:
> camera 0-0: Probing 0-0
> sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver attached to camera 0
> tvp5150 0-005d: chip found @ 0xba (i2c-sh_mobile)
> tvp5150 0-005d: tvp5150am1 detected.

This looks good - i2c to the chip works!

> sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver detached from camera 0
> camera: probe of 0-0 failed with error -515

This is strange, however - error code 515... Can you try to find out where 
it is coming from?

Thanks
Guennadi

> 
> I have also found 2 patches here http://www.sleepyrobot.com/?cat=3 but it
> does not support soc camera also.
> 
> My "copy-paste" patch in attachement this time.
> 
> kind regards
> Janusz
> 
> ----- Original Message ----- From: "Guennadi Liakhovetski"
> <g.liakhovetski@gmx.de>
> To: "Janusz Uzycki" <janusz.uzycki@elproma.com.pl>
> Cc: <g.daniluk@elproma.com.pl>
> Sent: Wednesday, January 26, 2011 8:47 PM
> Subject: Re: SoC Camera driver and TV decoder
> 
> 
> > On Wed, 26 Jan 2011, Janusz Uzycki wrote:
> > 
> > > Thanks for the help. I found your post at
> > > http://www.spinics.net/lists/linux-media/msg16346.html and
> > > http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/11486/focus=11493
> > > Do you remember some similar threads or guide? It will be better to read
> > > before to ask :)
> > 
> > There have been a couple of threads with similar content, and no, there is
> > no guide.
> > 
> > Regards
> > Guennadi
> > 
> > > 
> > > best regards
> > > Janusz Uzycki
> > > ELPROMA
> > > 
> > > ----- Original Message ----- From: "Guennadi Liakhovetski"
> > > <g.liakhovetski@gmx.de>
> > > To: "Janusz Uzycki" <janusz.uzycki@elproma.com.pl>
> > > Cc: <g.daniluk@elproma.com.pl>
> > > Sent: Monday, January 24, 2011 5:25 PM
> > > Subject: Re: SoC Camera driver and TV decoder
> > > 
> > > 
> > > > On Mon, 24 Jan 2011, Janusz Uzycki wrote:
> > > >
> > > > > Hello.
> > > > >
> > > > > We are developing a customized system based on Renesas SH7724 CPU. In
> > > > > dev.kit of that CPU video input (TV decoder) is powered by TW9910 > >
> > > chip.
> > > > > Our customized board contains TVP5150 chip instead. Unfortunately
> > > > > SoC-camera driver supports SH-mobile host but not the our client.
> > > > > TVP5150 is supported in Linux kernel via default video decoders > >
> > > driver
> > > > > but we weren't able to link SoC-camera and V4L2 driver of TVP5150 to
> > > > > work together. Both modules are loaded but /dev/video0 has not > >
> > > appeared.
> > > > > Could you point how to do it right? Does we need to rewrite TVP5150
> > > > > driver using TW9910 driver as template?
> > > >
> > > > Yes, you will have to adjust / extend the tvp5150.c driver to (also) >
> > > work
> > > > with soc-camera. Unfortunately, the soc-camera framework is still not
> > > > completely compatible with the plain v4l2-subdev API. Yes, use any of
> > > > existing soc-camera sensor or tv-decoder drivers as an example. The >
> > > only
> > > > soc-camera tv-decoder driver currently available, as you've correctly
> > > > recognised, is tw9910.
> > > >
> > > > With more detailed questions please CC the
> > > >
> > > > Linux Media Mailing List <linux-media@vger.kernel.org>
> > > >
> > > > mailing list.
> > > >
> > > > Thanks
> > > > Guennadi
> > > >
> > > > >
> > > > > Current our part for SoC in /arch/sh/boards/mach-ecovec24/setup.c is:
> > > > >
> > > > > static struct i2c_board_info i2c_camera[] = {
> > > > >         {
> > > > >                 I2C_BOARD_INFO("tvp5150", 0x5d),
> > > > >         },
> > > > > };
> > > > >
> > > > > static struct soc_camera_link tvp5150_link = {
> > > > >         .i2c_adapter_id = 0,
> > > > >         .bus_id         = 0,
> > > > >         .board_info     = &i2c_camera[0],
> > > > >          /*.priv           = &tw9910_info,*/            /* not > >
> > > supported
> > > > > */
> > > > >          /*.power          = tw9910_power,*/        /* not supported >
> > > > */
> > > > >         .module_name    = "tvp5150"
> > > > > };
> > > > >
> > > > > static struct platform_device camera_devices[] = {
> > > > >         {
> > > > >                 .name   = "soc-camera-pdrv",
> > > > >                 .id     = 0,
> > > > >                 .dev    = {
> > > > >                         .platform_data = &tvp5150_link,
> > > > >                 },
> > > > >         },
> > > > > };
> > > > >
> > > > > kind regards
> > > > > Janusz Uzycki
> > > > > ELPROMA
> > > > >
> > > >
> > > > ---
> > > > Guennadi Liakhovetski, Ph.D.
> > > > Freelance Open-Source Software Developer
> > > > http://www.open-technology.de/
> > > >
> > > 
> > 
> > ---
> > Guennadi Liakhovetski
> > 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
