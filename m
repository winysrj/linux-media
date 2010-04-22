Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758582Ab0DVUgA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 16:36:00 -0400
Message-ID: <4BD0B32B.8060505@redhat.com>
Date: Thu, 22 Apr 2010 17:35:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Bee Hock Goh <beehock@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Help needed in understanding v4l2_device_call_all
References: <x2m6e8e83e21004062310ia0eef09fgf97bcfafcdf25737@mail.gmail.com>
In-Reply-To: <x2m6e8e83e21004062310ia0eef09fgf97bcfafcdf25737@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bee Hock Goh wrote:
> Hi,
> 
> I am trying to understand how the subdev function are triggered when I
> use v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner,t) on
> tm600-video.

It calls tuner-core.c code, with g_tuner command. tuner-core
checks what's the used tuner and, in the case of tm6000, calls the corresponding
function at tuner-xc2028. This is implemented on tuner_g_tuner() function.

The function basically does some sanity checks, and some common tuner code, but
the actual implementation is handled by some callbacks that the driver needs to
define (get_afc, get_status, is_stereo, has_signal). In general, drivers use
get_status for it:
                fe_tuner_ops->get_status(&t->fe, &tuner_status);


You will find a good example of how to implement such code at tuner-simple 
simple_get_status() function.

In the case of tuner-xc2028, we never found a way for it to properly report the
status of the tuner lock. That's why this function is not implemented on the driver.

> How am i able to link the callback from the tuner_xc2028 function?

The callback is used by tuner-xc2028 when it detects the need of changing the
firmware (or when the firmware is not loaded yet, or when you select a standard
that it is not supported by the current firmware).

Basically, xc2028 driver will use the callback that was set previously via:

	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_config, &xc2028_cfg);


> 
> Please help me to understand or directly me to any documentation that
> I can read up?
> 
> thanks,
>  Hock.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
