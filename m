Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:53643 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaIBGAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 02:00:24 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NB900KRFFCLLZ20@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Sep 2014 02:00:21 -0400 (EDT)
Date: Tue, 02 Sep 2014 03:00:17 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Changbing Xiong <cb.xiong@samsung.com>
Cc: Antti Palosaari <crope@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3] media: check status of dmxdev->exit in poll functions
 of demux&dvr
Message-id: <20140902030017.4019f9ff.m.chehab@samsung.com>
In-reply-to: <1309141204.238711409627760764.JavaMail.weblogic@epmlwas04b>
References: <1309141204.238711409627760764.JavaMail.weblogic@epmlwas04b>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 02 Sep 2014 03:16:00 +0000 (GMT)
Changbing Xiong <cb.xiong@samsung.com> escreveu:

> 
> > Well, we may start returning -ENODEV when such event happens. 
> 
> > At the frontend, we could use fe->exit = DVB_FE_DEVICE_REMOVED to
> > signalize it. I don't think that the demod frontend has something
> > similar.
> 
> > Yet, it should be up to the userspace application to properly handle 
> > the error codes and close the devices on fatal non-recovery errors like
> > ENODEV. 
> 
> > So, what we can do, at Kernel level, is to always return -ENODEV when
> > the device is known to be removed, and double check libdvbv5 if it
> > handles such error properly.
> 
>  well, we do not use libdvbv5,

The upstream stuff I maintain, related to it, are the media subsystems
and libdvbv5. Of course, other apps will need to be patched as well.

> and  -ENODEV can be returned by read syscall,  
> but for poll syscall,

Actually, poll() may return an error as well (from poll() manpage):

"RETURN VALUE
       On success, a positive number is returned; this is the number of struc‐
       tures which have nonzero revents fields (in other words, those descrip‐
       tors  with events or errors reported).  A value of 0 indicates that the
       call timed out and no file descriptors were ready.   On  error,  -1  is
       returned, and errno is set appropriately."

So, if the Kernel returns -ENODEV, the glibc poll() wrapper would return -1
and errno will be ENODEV. Never actually tested if this works on poll()
though.

>  -ENODEV can never be returned to user, as negative number
>  is invalid  type for poll returned value. please refer to my second patch.
> 
> and in our usage, whether to read the device is up to the poll result. if tuner is plugged out, 
> and there is no data in dvr ringbuffer. then user code will still go on polling the dvr device and never stop.
> if POLLERR is returned, then user will perform read dvr, and then -ENODEV can be got, and 
> user will stop polling dvr device.

Your app should be also be handling poll() errors, as there are already
other errors that poll() can return.

> the first patch is enough to fix the deadlock issue.
> the second patch is used to correct the wrong type of returned value.
> the third patch is used to provide user a better controlling logic.

I'll take a deeper look and do some tests on your patches likely
tomorrow. 

Regards,
Mauro
