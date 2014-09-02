Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:26935 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIBHPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 03:15:12 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NB90003WITBJRA0@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Sep 2014 03:15:11 -0400 (EDT)
Date: Tue, 02 Sep 2014 04:15:06 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Changbing Xiong <cb.xiong@samsung.com>
Cc: Antti Palosaari <crope@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3] media: check status of dmxdev->exit in poll functions
 of demux&dvr
Message-id: <20140902041506.0761a4fa.m.chehab@samsung.com>
In-reply-to: <1888513592.247021409640162173.JavaMail.weblogic@epmlwas04b>
References: <1888513592.247021409640162173.JavaMail.weblogic@epmlwas04b>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 02 Sep 2014 06:42:42 +0000 (GMT)
Changbing Xiong <cb.xiong@samsung.com> escreveu:

> > Actually, poll() may return an error as well (from poll() manpage):
> 
> > "RETURN VALUE
> >        On success, a positive number is returned; this is the number of struc‐
> >        tures which have nonzero revents fields (in other words, those descrip‐
> >        tors  with events or errors reported).  A value of 0 indicates that the
> >        call timed out and no file descriptors were ready.   On  error,  -1  is
> >        returned, and errno is set appropriately."
> 
> > So, if the Kernel returns -ENODEV, the glibc poll() wrapper would return -1
> > and errno will be ENODEV. Never actually tested if this works on poll()
> > though.
> 
> > Actually, poll() may return an error as well (from poll() manpage):
> 
> > "RETURN VALUE
> >        On success, a positive number is returned; this is the number of struc‐
> >        tures which have nonzero revents fields (in other words, those descrip‐
> >        tors  with events or errors reported).  A value of 0 indicates that the
> >        call timed out and no file descriptors were ready.   On  error,  -1  is
> >        returned, and errno is set appropriately."
> 
> > So, if the Kernel returns -ENODEV, the glibc poll() wrapper would return -1
> > and errno will be ENODEV. Never actually tested if this works on poll()
> > though.
> 
> maybe the poll() manpage is wrong.
> The standard system call poll() can not get -ENODEV from errno. 

Well, it would likely put ENODEV at errno (and not -ENODEV).

> My experiment has proved that I was right(return -ENODEV directly in dvb_dvr_poll).  
> and you can also check code of do_poll() and do_sys_poll() in select.c file, it also shows that -ENODEV is invalid.

Yeah, I'll check it there. Poll have some different handling, so
it is possible that it only accepts a subset of error codes.

Btw, I'm not against returning POLLERR there. Just not sure at
this point what would be the best approach. Anyway, read and
all other syscalls should return -ENODEV.

> please also check that.

Sure I will.
> 
> thanks!
> Xiong changbing
> 
> ------- Original Message -------
> Sender : Mauro Carvalho Chehab<m.chehab@samsung.com> Director/SRBR-Open Source/삼성전자
> Date : 九月 02, 2014 15:00 (GMT+09:00)
> Title : Re: [PATCH 3/3] media: check status of dmxdev->exit in poll functions of demux&dvr
> 
> Em Tue, 02 Sep 2014 03:16:00 +0000 (GMT)
> Changbing Xiong escreveu:
> 
> > 
> > > Well, we may start returning -ENODEV when such event happens. 
> > 
> > > At the frontend, we could use fe->exit = DVB_FE_DEVICE_REMOVED to
> > > signalize it. I don't think that the demod frontend has something
> > > similar.
> > 
> > > Yet, it should be up to the userspace application to properly handle 
> > > the error codes and close the devices on fatal non-recovery errors like
> > > ENODEV. 
> > 
> > > So, what we can do, at Kernel level, is to always return -ENODEV when
> > > the device is known to be removed, and double check libdvbv5 if it
> > > handles such error properly.
> > 
> >  well, we do not use libdvbv5,
> 
> The upstream stuff I maintain, related to it, are the media subsystems
> and libdvbv5. Of course, other apps will need to be patched as well.
> 
> > and  -ENODEV can be returned by read syscall,  
> > but for poll syscall,
> 
> Actually, poll() may return an error as well (from poll() manpage):
> 
> "RETURN VALUE
>        On success, a positive number is returned; this is the number of struc‐
>        tures which have nonzero revents fields (in other words, those descrip‐
>        tors  with events or errors reported).  A value of 0 indicates that the
>        call timed out and no file descriptors were ready.   On  error,  -1  is
>        returned, and errno is set appropriately."
> 
> So, if the Kernel returns -ENODEV, the glibc poll() wrapper would return -1
> and errno will be ENODEV. Never actually tested if this works on poll()
> though.
> 
> >  -ENODEV can never be returned to user, as negative number
> >  is invalid  type for poll returned value. please refer to my second patch.
> > 
> > and in our usage, whether to read the device is up to the poll result. if tuner is plugged out, 
> > and there is no data in dvr ringbuffer. then user code will still go on polling the dvr device and never stop.
> > if POLLERR is returned, then user will perform read dvr, and then -ENODEV can be got, and 
> > user will stop polling dvr device.
> 
> Your app should be also be handling poll() errors, as there are already
> other errors that poll() can return.
> 
> > the first patch is enough to fix the deadlock issue.
> > the second patch is used to correct the wrong type of returned value.
> > the third patch is used to provide user a better controlling logic.
> 
> I'll take a deeper look and do some tests on your patches likely
> tomorrow. 
> 
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
