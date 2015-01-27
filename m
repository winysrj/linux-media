Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:60073 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbbA0KoU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 05:44:20 -0500
Received: by mail-wg0-f45.google.com with SMTP id x12so13996548wgg.4
        for <linux-media@vger.kernel.org>; Tue, 27 Jan 2015 02:44:18 -0800 (PST)
Received: from [192.168.1.100] (net-93-64-207-188.cust.vodafonedsl.it. [93.64.207.188])
        by mx.google.com with ESMTPSA id lk2sm1605094wic.22.2015.01.27.02.44.17
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jan 2015 02:44:18 -0800 (PST)
Message-ID: <54C76BFF.3030102@movia.biz>
Date: Tue, 27 Jan 2015 11:44:15 +0100
From: Francesco Marletta <francesco.marletta@movia.biz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Strange behaviour of sizeof(struct v4l2_queryctrl)
References: <54C76BB9.8020308@movia.biz>
In-Reply-To: <54C76BB9.8020308@movia.biz>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again,
I was able to solve the problem... now the userspace program use the 
correct value for VIDIOC_QUERYCTRL.

Regards
Francesco


Il 27/01/2015 11:43, Francesco Marletta ha scritto:
> Hello to anyone,
> I'm working on a problem with V4L2 on Linux Kernel 2.6.37.
>
> The problem arise when I try to query a video device to list the 
> controls it provides.
>
> When is call
>     ioctl(fd, VIDIOC_QUERYCTRL, &queryctrl)
>
> the function doesn't return 0 and errno is set to EINVAL
>
> This happen for every control, even for the controls that the driver 
> provides (checked in the code) like brightness.
>
> After adding a lot of printk in the videodev.ko module I found that 
> the problem is caused by a wrong value of VIDIOC_QUERYCTRL, that in 
> the kernel module is 0xC0485624 while in userspace application is 
> 0xC0445624.
>
> I digged the kernel source to understand what's happening, and 
> discovered the definition of VIDIOC_QUERYCTRL:
>         #define VIDIOC_QUERYCTRL        _IOWR('V', 36, struct 
> v4l2_queryctrl)
>
> dove:
>         #define _IOWR(type,nr,size)     \
> _IOC(_IOC_READ|_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(size)))
>
> with
>         #define _IOC(dir,type,nr,size) \
>                         (((dir)  << _IOC_DIRSHIFT)  | \
>                         ((type)  << _IOC_TYPESHIFT) | \
>                         ((nr)    << _IOC_NRSHIFT)   | \
>                         ((size)  << _IOC_SIZESHIFT))
>
> and
>         #define _IOC_NRSHIFT    0
>         #define _IOC_TYPESHIFT  (_IOC_NRSHIFT+_IOC_NRBITS)
>         #define _IOC_SIZESHIFT  (_IOC_TYPESHIFT+_IOC_TYPEBITS)
>         #define _IOC_DIRSHIFT   (_IOC_SIZESHIFT+_IOC_SIZEBITS)
>
>         #define _IOC_NRBITS     8
>         #define _IOC_TYPEBITS   8
>         #define _IOC_SIZEBITS   14
>
>         #define _IOC_NONE       0U
>         #define _IOC_WRITE      1U
>         #define _IOC_READ       2U
>
>         #define _IOC_TYPECHECK(t) (sizeof(t))
>
> thus, the _IOC definition means:
>         _IOC(dir,type,nr,size)   <=>   [dir|size|type|nr]
>
> that, for the aftermentioned values means:
>         0xC0445624 <=> [3|044|56|24]  ==> size = 0x44 = 68
>         0xC0485624 <=> [3|048|56|24]  ==> size = 0x48 = 72
>
> To be sure that the number 68 and 72 are correct, I added a printk() 
> in the videodev.ko module and a println() in the userspace application 
> to print "sizeof(struct v4l2_queryctrl)", and the outputs are:
>
>     Kernel module:
>         printk("[DBG] %s() ~ sizeof(struct v4l2_queryctrl): %u\n", 
> __func__, sizeof(struct v4l2_queryctrl));
>             => [DBG] videodev_init() ~ sizeof(struct v4l2_queryctrl): 72
>
>     Userspace application:
>         printf("[dbg] sizeof(struct v4l2_queryctrl): %u\n", 
> sizeof(struct v4l2_queryctrl));
>             => [dbg] sizeof(struct v4l2_queryctrl): 68
>
> In both cases (module and application), there is the inclusion of 
> <linux/videodev2.h>.
>
> When I compiled the application I istructed the compiler to pick the 
> same kernel header of the module, with a proper CFLAGS += -I<PATH> in 
> the Makefile.
>
> Any idea about this strangeness?
>
> Regards
> Francesco

