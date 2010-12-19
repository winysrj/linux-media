Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44758 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932463Ab0LSUXa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 15:23:30 -0500
Subject: Re: Power frequency detection.
From: Andy Walls <awalls@md.metrocast.net>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <73wo0g3yy30clob2isac30vm.1292782894810@email.android.com>
References: <73wo0g3yy30clob2isac30vm.1292782894810@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 15:24:09 -0500
Message-ID: <1292790249.2052.16.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sun, 2010-12-19 at 13:21 -0500, Andy Walls wrote:
> Theodore,

Gah.  I need to learn how to type or wear my glasses more often.

> Aside from detect measurment of the power line, isn't a camera the
             ^^^^^^^^^^^^^^^^^
             direct measurement

>  best sort of sensor for this measurment anyway?
                                ^^^^^^^^^^
                                measurement

> Just compute the average image luminosity over several frames and look
                                            ^^^
                                            for


Regards,
Andy

>  for (10 Hz ?) periodic variation (beats), indicating a mismatch.
>
> Sure you could just ask the user, but where's the challenge in
> that. ;)
> 
> Regards,
> Andy
> 
> Theodore Kilgore <kilgota@banach.math.auburn.edu> wrote:
> 
> >
> >
> >On Sun, 19 Dec 2010, Paulo Assis wrote:
> >
> >> Hi,
> >> 
> >> 2010/12/18 Theodore Kilgore <kilgota@banach.math.auburn.edu>:
> >> >
> >> > Does anyone know whether, somewhere in the kernel, there exists a scheme
> >> > for detecting whether the external power supply of the computer is using
> >> > 50hz or 60hz?
> >> >
> >> > The reason I ask:
> >> >
> >> > A certain camera is marketed with Windows software which requests the user
> >> > to set up the option of 50hz or 60hz power during the setup.
> >> >
> >> > Judging by what exists in videodev2.h, for example, it is evidently
> >> > possible to set up this as a control setting in a Linux driver. I am not
> >> > aware of any streaming app which knows how to access such an option.
> >> >
> >> 
> >> Most uvc cameras present this as a control, so any v4l2 control app
> >> should let you access it.
> >> If your camera driver also supports this control then this shouldn't
> >> be a problem for any generci v4l2 app.
> >> here are a couple of ones:
> >> 
> >> v4l2ucp (control panel)
> >> guvcview ("guvcview --control_only" will work along side other apps
> >> just like v4l2ucp)
> >> uvcdynctrl from libwebcam for command line control utility .
> >> 
> >> Regards,
> >> Paulo
> >
> >Thank you. 
> >
> >I still think that it would be even more clever to detect the line 
> >frequency automatically and then just to set the proper setting, if needed 
> >or desirable. That was one of the parts of my question about it, after 
> >all. But if nobody has ever had a reason to do such detection already it 
> >would perhaps be much more trouble than it is worth just do support a 
> >cheap camera.
> >
> >Theodore Kilgore
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> NrybXǧv^)޺{.n+{bj)w*jgݢj/zޖ2ޙ&)ߡaGhj:+vw٥


