Return-path: <mchehab@gaivota>
Received: from banach.math.auburn.edu ([131.204.45.3]:37441 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab0LSRrH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 12:47:07 -0500
Date: Sun, 19 Dec 2010 12:23:11 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Paulo Assis <pj.assis@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Power frequency detection.
In-Reply-To: <AANLkTinGnhmEg3zbkhmUGH_+bsqdDmkp24_-Of9e3XN1@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1012191217360.23860@banach.math.auburn.edu>
References: <alpine.LNX.2.00.1012181550500.22984@banach.math.auburn.edu> <AANLkTinGnhmEg3zbkhmUGH_+bsqdDmkp24_-Of9e3XN1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>



On Sun, 19 Dec 2010, Paulo Assis wrote:

> Hi,
> 
> 2010/12/18 Theodore Kilgore <kilgota@banach.math.auburn.edu>:
> >
> > Does anyone know whether, somewhere in the kernel, there exists a scheme
> > for detecting whether the external power supply of the computer is using
> > 50hz or 60hz?
> >
> > The reason I ask:
> >
> > A certain camera is marketed with Windows software which requests the user
> > to set up the option of 50hz or 60hz power during the setup.
> >
> > Judging by what exists in videodev2.h, for example, it is evidently
> > possible to set up this as a control setting in a Linux driver. I am not
> > aware of any streaming app which knows how to access such an option.
> >
> 
> Most uvc cameras present this as a control, so any v4l2 control app
> should let you access it.
> If your camera driver also supports this control then this shouldn't
> be a problem for any generci v4l2 app.
> here are a couple of ones:
> 
> v4l2ucp (control panel)
> guvcview ("guvcview --control_only" will work along side other apps
> just like v4l2ucp)
> uvcdynctrl from libwebcam for command line control utility .
> 
> Regards,
> Paulo

Thank you. 

I still think that it would be even more clever to detect the line 
frequency automatically and then just to set the proper setting, if needed 
or desirable. That was one of the parts of my question about it, after 
all. But if nobody has ever had a reason to do such detection already it 
would perhaps be much more trouble than it is worth just do support a 
cheap camera.

Theodore Kilgore
