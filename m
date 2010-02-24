Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57044 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab0BXFMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 00:12:17 -0500
Message-ID: <4B84B52A.1000005@infradead.org>
Date: Wed, 24 Feb 2010 02:12:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Tobias Lorenz <tobias.lorenz@gmx.net>
CC: Roel Kluin <roel.kluin@gmail.com>, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] radio-si470x-common: -EINVAL overwritten in si470x_vidioc_s_tuner()
References: <4B69D2F5.2050100@gmail.com> <201002032252.36514.tobias.lorenz@gmx.net> <4B6A242C.8060104@infradead.org> <201002182050.41968.tobias.lorenz@gmx.net>
In-Reply-To: <201002182050.41968.tobias.lorenz@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tobias Lorenz wrote:
> Hello Mauro,
> 
>>> no, the default value of retval makes no difference to the function.
>>>
>>> Retval is set by si470x_disconnect_check and si470x_set_register.
>>> After each call, retval is checked.
>>> There is no need to reset it passed.
> 
>> You may just do then:
>>
>> 	int retval = si470x_disconnect_check(radio);
> 
> In all other set/get functions of v4l2_ioctl_ops in the driver, I just set the default value of retval to 0.
> To be identical in si470x_vidioc_s_tuner, I modified the patch to the one below.
> I already pushed this and another cosmetic patch into mercurial:
> 
> http://linuxtv.org/hg/~tlorenz/v4l-dvb/rev/72a2f38d5956
See comment bellow.


> http://linuxtv.org/hg/~tlorenz/v4l-dvb/rev/3efd5d32a618
Applied.

> 
> Mauro, can you pull them?

Tobias, next time or send one patch per email or send me a pull request.

> 
> Bye,
> Tobias
> 
> --- a/linux/drivers/media/radio/si470x/radio-si470x-common.c	Thu Feb 11 23:11:30 2010 -0200
> +++ b/linux/drivers/media/radio/si470x/radio-si470x-common.c	Thu Feb 18 20:31:33 2010 +0100
> @@ -748,7 +748,7 @@
>  		struct v4l2_tuner *tuner)
>  {
>  	struct si470x_device *radio = video_drvdata(file);
> -	int retval = -EINVAL;
> +	int retval = 0;
>  
>  	/* safety checks */
>  	retval = si470x_disconnect_check(radio);

This really doesn't make any sense. Just do:

	int retval = i470x_disconnect_check(radio);

or
	int retval;

	retval = i470x_disconnect_check(radio);



-- 

Cheers,
Mauro
