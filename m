Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n59B1tks001763
	for <video4linux-list@redhat.com>; Tue, 9 Jun 2009 07:01:55 -0400
Received: from mail02.idc.renesas.com (mail.renesas.com [202.234.163.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n59B1fh5027286
	for <video4linux-list@redhat.com>; Tue, 9 Jun 2009 07:01:42 -0400
Date: Tue, 09 Jun 2009 20:01:37 +0900
From: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-reply-to: <Pine.LNX.4.64.0906091057120.4085@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-id: <ubpoxoelq.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
References: <ud49domlx.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0906091057120.4085@axis700.grange>
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


Dear Guennadi

Thank you for comment

> > soc_camera_open use icd->current_fmt directly.
> > It doesn't check if icd->current_fmt != NULL.
> 
> Which kernel version, resp., version of the soc-camera stack are you 
> using? What you describe would be a bug, but it shouldn't be present 
> neither in the soc-camera stack, converted to v4l2-subdev (see my last 
> series of 10 patches), nor in a partially converted stack.

I use latest Paul's (for SH) git

> is present in the current mainline. There's a call to
> 
> 	if (icd->ops->remove)
> 		icd->ops->remove(icd);
> 
> missing on the "goto eiufmt;" error path. You'd just have to insert the 
> above call before the goto. Would you like to prepare a patch?

wow...
why can I call soc_camera_open even if soc_camera_probe failed ?
I'm not sure why... but...

following is my kernel panic story.

1) I use "soc_camera_platform" and "sh_mobile_ceu" driver.

2) soc_camera_platform_info :: bus_param = SOCAM_xxx;
  this bus_param is miss mach to sh_mobile_ceu.
  ex) if it use SOCAM_DATAWIDTH_4, sh_mobile_ceu can not use it.

3) soc_camera_bus_param_compatible will be return 0
  in sh_mobile_ceu_try_bus_param

  I think this behavior is correct

4) sh_mobile_ceu_get_formats return 0
   because sh_mobile_ceu_try_bus_param return 0 

5) soc_camera_init_user_formats return -ENXIO
  because fmts is 0.
  then, icd->current_fmt is still NULL.

6) when I use mplayer, kernel panic occur on soc_camera_open.
  because .pixelformat = icd->current_fmt->fourcc will access NULL address
  but why can I call soc_camera_open ?

Best regards
--
Kuninori Morimoto
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
