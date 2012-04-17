Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.insync.za.net ([103.247.152.98]:59416 "EHLO
	mail.insync.za.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab2DQVMw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 17:12:52 -0400
Date: Wed, 18 Apr 2012 09:12:48 +1200 (NZST)
From: Pieter De Wit <pieter@insync.za.net>
To: =?ISO-8859-15?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>
cc: linux-media@vger.kernel.org
Subject: Re: v4l2 Device with H264 support
In-Reply-To: <201204172345.47837.remi@remlab.net>
Message-ID: <alpine.DEB.2.02.1204180912130.3685@eragon.insync.za.net>
References: <alpine.DEB.2.02.1204171159380.3685@eragon.insync.za.net> <a5a29db4793a36095a2f8746361f6b63@chewa.net> <alpine.DEB.2.02.1204180828510.3685@eragon.insync.za.net> <201204172345.47837.remi@remlab.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-647220006-1334697168=:3685"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-647220006-1334697168=:3685
Content-Type: TEXT/PLAIN; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 17 Apr 2012, Rémi Denis-Courmont wrote:

> Le mardi 17 avril 2012 23:30:43 Pieter De Wit, vous avez écrit :
>> Thanks for the reply. I suspect that there is some tricks needed to get
>> the h264 stream from this device, into something of a player.
>
> At least for UVC devices, it's pretty damn straight forward. You just need to
> set pixel format 'H264' with the standard VIDIOC_S_FMT. Then you get the H.264
> elementary stream with the plain normal streaming or read/write modes of V4L2.
>
> E.g.:
>
> # v4l2-ctl --set-fmt-video=width=640,height=480,pixelformat=H264
> # vlc v4l2c/h264://
>
> -- 
> Rémi Denis-Courmont
> http://www.remlab.net/
> http://fi.linkedin.com/in/remidenis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Yeah - that didn't work so well. I will make up a more detailed report 
tonight when I have the device on hand.

Cheers,

Pieter
--8323329-647220006-1334697168=:3685--
