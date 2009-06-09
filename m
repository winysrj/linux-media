Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n59B8oWL005180
	for <video4linux-list@redhat.com>; Tue, 9 Jun 2009 07:08:50 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n59B8WRp030947
	for <video4linux-list@redhat.com>; Tue, 9 Jun 2009 07:08:33 -0400
Date: Tue, 9 Jun 2009 13:08:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <ubpoxoelq.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0906091306410.4085@axis700.grange>
References: <ud49domlx.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0906091057120.4085@axis700.grange>
	<ubpoxoelq.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: question about soc_camera_open
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

On Tue, 9 Jun 2009, Kuninori Morimoto wrote:

> > > soc_camera_open use icd->current_fmt directly.
> > > It doesn't check if icd->current_fmt != NULL.
> > 
> > Which kernel version, resp., version of the soc-camera stack are you 
> > using? What you describe would be a bug, but it shouldn't be present 
> > neither in the soc-camera stack, converted to v4l2-subdev (see my last 
> > series of 10 patches), nor in a partially converted stack.
> 
> I use latest Paul's (for SH) git
> 
> > is present in the current mainline. There's a call to
> > 
> > 	if (icd->ops->remove)
> > 		icd->ops->remove(icd);
> > 
> > missing on the "goto eiufmt;" error path. You'd just have to insert the 
> > above call before the goto. Would you like to prepare a patch?
> 
> wow...
> why can I call soc_camera_open even if soc_camera_probe failed ?

For this very reason - because icd->ops->remove(icd) is not called if 
soc_camera_init_user_formats() fails, which is a bug and should be fixed.

Thanks
Guennadi

> I'm not sure why... but...
> 
> following is my kernel panic story.
> 
> 1) I use "soc_camera_platform" and "sh_mobile_ceu" driver.
> 
> 2) soc_camera_platform_info :: bus_param = SOCAM_xxx;
>   this bus_param is miss mach to sh_mobile_ceu.
>   ex) if it use SOCAM_DATAWIDTH_4, sh_mobile_ceu can not use it.
> 
> 3) soc_camera_bus_param_compatible will be return 0
>   in sh_mobile_ceu_try_bus_param
> 
>   I think this behavior is correct
> 
> 4) sh_mobile_ceu_get_formats return 0
>    because sh_mobile_ceu_try_bus_param return 0 
> 
> 5) soc_camera_init_user_formats return -ENXIO
>   because fmts is 0.
>   then, icd->current_fmt is still NULL.
> 
> 6) when I use mplayer, kernel panic occur on soc_camera_open.
>   because .pixelformat = icd->current_fmt->fourcc will access NULL address
>   but why can I call soc_camera_open ?
> 
> Best regards
> --
> Kuninori Morimoto
>  
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
