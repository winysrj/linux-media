Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab0J0RjN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 13:39:13 -0400
Message-ID: <4CC864A5.1070101@redhat.com>
Date: Wed, 27 Oct 2010 19:43:01 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mitar <mmitar@gmail.com>
CC: Janne Grunau <j@jannau.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Too slow libv4l MJPEG decoding with HD cameras
References: <AANLkTikGT6m9Ji3bBrwUB-yJY9dT0j8eCP_RNAvh3deG@mail.gmail.com>	<4CC7EC13.1080008@redhat.com>	<20101027104933.GC15291@aniel.fritz.box>	<4CC827DD.5070109@redhat.com> <AANLkTim6ji=_bgdPWpv7608J8t6P5EfWZrhq8BRVWjnR@mail.gmail.com>
In-Reply-To: <AANLkTim6ji=_bgdPWpv7608J8t6P5EfWZrhq8BRVWjnR@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 10/27/2010 03:59 PM, Mitar wrote:
> Hi!
>
> On Wed, Oct 27, 2010 at 3:23 PM, Hans de Goede<hdegoede@redhat.com>  wrote:
>> If and only if libjpeg-turbo turns out to be much slower this is something
>> to consider. But the first thing to do here is see if we can solve this
>> in a way which is acceptable to all downstream users of libv4l, and thus
>> can be added in a non optional way (so make libv4l require libjpeg).
>
> I opted for avcodec as I have been told it is the fastest
> implementation around. But I have not really tested that claim. So for
> sure this should be tested. I tested just original tinyjpeg vs.
> avcodec implementation.
>
> I am sorry but I do not have time to do more work on this. Especially
> because libjpeg-turbo also seems to have problems with restart
> markers:
>
> http://libjpeg-turbo.virtualgl.org/About/Performance (at the end)
>
> which is the problem I am currently try to deal with also with ffmpeg:
>
> https://roundup.ffmpeg.org/issue2325
>

Well the problem is not entirely the same. libjpeg-turbo will degrade
a bit in performance when encountering these markers, where as if I
understand your ffmpeg bugreport properly ffmpeg does not properly
decode these images. This seems actually like an argument in favor of
giving libjpeg a try.

Are you sure you cannot make some time for this?

Regards,

Hans
