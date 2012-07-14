Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:50465 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029Ab2GNWgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jul 2012 18:36:11 -0400
References: <CALzAhNVDnyjwNqcWDcgv2kgQ97Hr0gArk8=V_mL62J0cD0Ydag@mail.gmail.com>
In-Reply-To: <CALzAhNVDnyjwNqcWDcgv2kgQ97Hr0gArk8=V_mL62J0cD0Ydag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: staging/for_v3.6 is currently broken
From: Andy Walls <awalls@md.metrocast.net>
Date: Sat, 14 Jul 2012 18:36:07 -0400
To: Steven Toth <stoth@kernellabs.com>,
	Mauro Chehab <mchehab@infradead.org>
CC: Linux-Media <linux-media@vger.kernel.org>
Message-ID: <c8d61d57-0582-455b-9e24-7f1c5e6049c7@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steven Toth <stoth@kernellabs.com> wrote:

>Looks like the new union in v4l2_ioctl_info breaks things.
>
>-bash-4.1$ make -j6
>make[1]: Nothing to be done for `all'.
>  CHK     include/linux/version.h
>  CHK     include/generated/utsrelease.h
>  CALL    scripts/checksyscalls.sh
>  CHK     include/generated/compile.h
>  CC      drivers/media/video/v4l2-ioctl.o
>drivers/media/video/v4l2-ioctl.c:1848:517: error: unknown field ‘func’
>specified in initializer
>drivers/media/video/v4l2-ioctl.c:1848:517: warning: missing braces
>around initializer
>drivers/media/video/v4l2-ioctl.c:1848:517: warning: (near
>initialization for ‘v4l2_ioctls[0].<anonymous>’)
>drivers/media/video/v4l2-ioctl.c:1848:517: warning: initialization
>makes integer from pointer without a cast
>drivers/media/video/v4l2-ioctl.c:1849:644: error: unknown field ‘func’
>specified in initializer
>drivers/media/video/v4l2-ioctl.c:1849:644: warning: initialization
>makes integer from pointer without a cast
>
>Removing the union and the code compiles, although that probably
>wasn't the original authors intension.
>
>diff --git a/drivers/media/video/v4l2-ioctl.c
>b/drivers/media/video/v4l2-ioctl.c
>index 70e0efb..1f090c4 100644
>--- a/drivers/media/video/v4l2-ioctl.c
>+++ b/drivers/media/video/v4l2-ioctl.c
>@@ -1802,11 +1802,9 @@ struct v4l2_ioctl_info {
>        unsigned int ioctl;
>        u32 flags;
>        const char * const name;
>-       union {
>                u32 offset;
>                int (*func)(const struct v4l2_ioctl_ops *ops,
>                                struct file *file, void *fh, void *p);
>-       };
>        void (*debug)(const void *arg, bool write_only);
> };
>
>FYI
>
>-- 
>Steven Toth - Kernel Labs
>http://www.kernellabs.com
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


I think Hans fixed it another way:

http://www.spinics.net/lists/linux-media/msg50234.html

Regards,
Andy
