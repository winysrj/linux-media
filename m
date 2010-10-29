Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36979 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab0J2MHd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 08:07:33 -0400
Received: by iwn10 with SMTP id 10so3654698iwn.19
        for <linux-media@vger.kernel.org>; Fri, 29 Oct 2010 05:07:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010290139.10204.laurent.pinchart@ideasonboard.com>
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com>
	<AANLkTi=Nv2Oe=61NQjzH0+P+TcODDJW3_n+NbfzxF5g3@mail.gmail.com>
	<201010290139.10204.laurent.pinchart@ideasonboard.com>
Date: Fri, 29 Oct 2010 14:07:33 +0200
Message-ID: <AANLkTinWnGtb32kBNwoeN27OcCh7sVvZOoC=Vi1BtOua@mail.gmail.com>
Subject: Re: New media framework user space usage
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Laurant,

> With the media-ctl and yavta test applications, just run
>
> ./media-ctl -r -l '"mt9t001 3-005d":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
> CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> ./media-ctl -f '"mt9t001 3-005d":0[SGRBG10 1024x768], "OMAP3 ISP
> CCDC":1[SGRBG10 1024x768]'
>
> ./yavta -f SGRBG10 -s 1024x768 -n 4 --capture=4 --skip 3 -F $(./media-ctl -e
> "OMAP3 ISP CCDC output")
>
> Replace all occurences of 1024x768 by your sensor native resolution, and
> "mt9t001 3-005d" by the sensur subdev name.

I did as you said and everything works fine until I use yavta:

Video format set: width: 2952 height: 1944 buffer size: 11508480
Video format: BA10 (30314142) 2952x1944
4 buffers requested.
length: 11508480 offset: 0
Buffer 0 mapped at address 0x4016d000.
length: 11508480 offset: 11509760
Buffer 1 mapped at address 0x40c67000.
length: 11508480 offset: 23019520
Buffer 2 mapped at address 0x41761000.
length: 11508480 offset: 34529280
Buffer 3 mapped at address 0x4225b000.
Unable to start streaming: 22

This is in
ret = ioctl(dev->fd, enable ? VIDIOC_STREAMON : VIDIOC_STREAMOFF, &type);
errno 22 is: Invalid argument

Any ideas where to look next?

Thanks,

 Bastian


> --
> Regards,
>
> Laurent Pinchart
>
