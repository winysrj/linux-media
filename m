Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:52158 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1BAOdA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Feb 2011 09:33:00 -0500
Date: Tue, 1 Feb 2011 15:32:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Uzycki <janusz.uzycki@elproma.com.pl>
cc: g.daniluk@elproma.com.pl,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: SoC Camera driver and TV decoder
In-Reply-To: <18BE1662A1F04B6C8B39AA46440A3FBB@laptop2>
Message-ID: <Pine.LNX.4.64.1102011532360.6673@axis700.grange>
References: <1E539FC23CF84B8A91428720570395E0@laptop2>
 <Pine.LNX.4.64.1101241720001.17567@axis700.grange> <AD14536027B946D6B4504D4F43E352A5@laptop2>
 <Pine.LNX.4.64.1101262045550.3989@axis700.grange> <F95361ABAE1D4A70A10790A798004482@laptop2>
 <Pine.LNX.4.64.1101271809030.8916@axis700.grange> <8026191608244DB98F002E983C866149@laptop2>
 <Pine.LNX.4.64.1102011420540.6673@axis700.grange> <18BE1662A1F04B6C8B39AA46440A3FBB@laptop2>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 1 Feb 2011, Janusz Uzycki wrote:

> camera 0-0: Probing 0-0
> sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver attached to camera 0
> tvp5150 0-005d: chip found @ 0xba (i2c-sh_mobile)
> tvp5150 0-005d: tvp5150am1 detected.
> sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver detached from camera 0
> 
> There is no error 515 but the driver is still detached.

Good, this is correct. It will be re-attached when you open it.

Thanks
Guennadi

> drivers/media/video/sh_mobile_ceu_camera.c:
> sh_mobile_ceu_remove_device() is called /* Called with .video_lock held */
> static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
>        .owner          = THIS_MODULE,
>        .add            = sh_mobile_ceu_add_device,
>        .remove         = sh_mobile_ceu_remove_device,
> It seems sh_mobile_ceu_add_device() was failed.
> I will try to explore that.
> 
> Janusz
> 
> ----- Original Message ----- From: "Guennadi Liakhovetski"
> <g.liakhovetski@gmx.de>
> To: "Janusz Uzycki" <janusz.uzycki@elproma.com.pl>
> Cc: <g.daniluk@elproma.com.pl>; "Linux Media Mailing List"
> <linux-media@vger.kernel.org>
> Sent: Tuesday, February 01, 2011 2:21 PM
> Subject: Re: SoC Camera driver and TV decoder
> 
> 
> > On Tue, 1 Feb 2011, Janusz Uzycki wrote:
> > 
> > > include/linux/errno.h:#define ENOIOCTLCMD       515     /* No ioctl
> > > command */
> > > 
> > > What did I forget below?
> > > static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
> > >        .s_routing = tvp5150_s_routing,
> > > 
> > >        /* SoC camera: */
> > >        .s_stream       = tvp5150_s_stream,
> > >        .g_mbus_fmt     = tvp5150_g_fmt,
> > >        .s_mbus_fmt     = tvp5150_s_fmt,
> > >        .try_mbus_fmt   = tvp5150_try_fmt,
> > >        .enum_mbus_fmt  = tvp5150_enum_fmt,
> > > /*      .cropcap        = tw9910_cropcap,
> > >        .g_crop         = tw9910_g_crop,
> > >        .s_crop         = tw9910_s_crop,*/
> > > };
> > > 
> > > cropcap/g_crop/s_cros are necessary? why and when?
> > 
> > cropcap and g_crop might be necessary - at least minimal static versions.
> > 
> > Thanks
> > Guennadi
> > 
> > > 
> > > thanks
> > > Janusz
> > > 
> > > 
> > > > On Thu, 27 Jan 2011, Janusz Uzycki wrote:
> > > >
> > > > > Hello Guennadi again.
> > > > >
> > > > > I patched tvp5150.c according to tw9910 driver (without real cropping
> > > > > support yet).
> > > > > Unfortunately I got the messages:
> > > > > camera 0-0: Probing 0-0
> > > > > sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver attached to >
> > > > camera
> > > > > 0
> > > > > tvp5150 0-005d: chip found @ 0xba (i2c-sh_mobile)
> > > > > tvp5150 0-005d: tvp5150am1 detected.
> > > >
> > > > This looks good - i2c to the chip works!
> > > >
> > > > > sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver detached from
> > > > > camera 0
> > > > > camera: probe of 0-0 failed with error -515
> > > >
> > > > This is strange, however - error code 515... Can you try to find out >
> > > where
> > > > it is coming from?
> > > >
> > > > Thanks
> > > > Guennadi
> > > >
> > > 
> > 
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
