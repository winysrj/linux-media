Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60929 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab2AIOuf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 09:50:35 -0500
Received: by wibhm6 with SMTP id hm6so2612896wib.19
        for <linux-media@vger.kernel.org>; Mon, 09 Jan 2012 06:50:34 -0800 (PST)
Message-ID: <4F0AFEB7.9080605@gmail.com>
Date: Mon, 09 Jan 2012 15:50:31 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: media_build failures on 3.0.6 Gentoo
References: <4EF1BA0D.4070002@gmail.com> <201201090022.51367.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201090022.51367.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/09/12 00:22, Laurent Pinchart wrote:
> Hi Fredrik,
>
> On Wednesday 21 December 2011 11:50:53 Fredrik Lingvall wrote:
>> Hi,
>>
>> I get this build failure:
> [snip]
>
>>    LD [M]  /usr/src/media_build/v4l/m5mols.o
>>     CC [M]  /usr/src/media_build/v4l/s5k6aa.o
>>     CC [M]  /usr/src/media_build/v4l/adp1653.o
>>     CC [M]  /usr/src/media_build/v4l/as3645a.o
>> /usr/src/media_build/v4l/as3645a.c: In function 'as3645a_probe':
>> /usr/src/media_build/v4l/as3645a.c:815:2: error: implicit declaration of
>> function 'kzalloc'
>> /usr/src/media_build/v4l/as3645a.c:815:8: warning: assignment makes
>> pointer from integer without a cast
>> make[3]: *** [/usr/src/media_build/v4l/as3645a.o] Error 1
>> make[2]: *** [_module_/usr/src/media_build/v4l] Error 2
>> make[2]: Leaving directory `/usr/src/linux-3.0.6-gentoo'
>> make[1]: *** [default] Error 2
>> make[1]: Leaving directory `/usr/src/media_build/v4l'
>> make: *** [all] Error 2
>> build failed at ./build line 380.
>> lin-tv media_build #
> Could you please test this patch ?
>
>  From c7ecae9b57cb29eaa134943d086fb0d83865514e Mon Sep 17 00:00:00 2001
> From: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> Date: Mon, 9 Jan 2012 00:18:19 +0100
> Subject: [PATCH] as3645a: Fix compilation by including slab.h
>
> The as3645a driver calls kzalloc(). Include slab.h.
>
> Reported-by: Fredrik Lingvall<fredrik.lingvall@gmail.com>
> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> ---
>   drivers/media/video/as3645a.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
> index ec859a5..f241702 100644
> --- a/drivers/media/video/as3645a.c
> +++ b/drivers/media/video/as3645a.c
> @@ -29,6 +29,7 @@
>   #include<linux/i2c.h>
>   #include<linux/module.h>
>   #include<linux/mutex.h>
> +#include<linux/slab.h>
>
>   #include<media/as3645a.h>
>   #include<media/v4l2-ctrls.h>
Laurent,

I have upgraded to the latest stable Gentoo kernel, that is 
3.1.6-gentoo, and I don't see the build problem with

http://linuxtv.org/downloads/drivers/linux-media-2012-01-07.tar.bz2

and above anymore (I had to enable DVB for Linux in the 3.1.6-gentoo 
kernel) .

As of linux-media-2012-01-07.tar.bz2 I can now see clear video with 
mplayer on some channels (using the HVR-930C)  but it's not working 
perfectly, in particular not with MythTV. I will do some more testing 
and report back in the "Hauppauge HVR-930C problems" thread.

Regards,

/Fredrik
