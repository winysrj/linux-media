Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761219Ab0J0NTw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 09:19:52 -0400
Message-ID: <4CC827DD.5070109@redhat.com>
Date: Wed, 27 Oct 2010 15:23:41 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Janne Grunau <j@jannau.net>
CC: Mitar <mmitar@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Too slow libv4l MJPEG decoding with HD cameras
References: <AANLkTikGT6m9Ji3bBrwUB-yJY9dT0j8eCP_RNAvh3deG@mail.gmail.com> <4CC7EC13.1080008@redhat.com> <20101027104933.GC15291@aniel.fritz.box>
In-Reply-To: <20101027104933.GC15291@aniel.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 10/27/2010 12:49 PM, Janne Grunau wrote:

<snip>

>>> With using ffmpeg MJPEG decoding it takes my computer on average
>>> 43.616 ms to decode the frame what is 0.0087 us per pixel.
>>
>> That is a great improvement, but using ffmpeg in libv4l is not an option
>> for multiple reasons:
>>
>> 1) It is GPL licensed not LGPL
>
> FFmpeg is mostly LGPL licensed, only a few optimizations and interfaces
> to GPL libraries. Running FFmpeg's configure without options and
> especially without --enable-gpl will only use lgpl or compatible
> licensed code.
>

Ok, that is good to know.

>> 2) It has various other legal issues which means it is not available
>>      in most distro's main repository.
>
> FUD, Ubuntu doesn't seem to have a problem with it.

Not a really helpful response I'm afraid, there are a number of highprofile
distributions which do not include ffmpeg, so depending on ffmpeg is not
really an option.

>> So I'm afraid that using ffmpeg really is out of the question. What
>> would be interesting is to see how libjpeg performs and then esp. the
>> turbo-libjpeg version:
>> http://libjpeg-turbo.virtualgl.org/
>>
>> I would love to see a patch to use that instead of tiny jpeg, leaving
>> tinyjpeg usage only for the pixart jpeg variant stuff.
>>
>> Note that some cameras generate what I call planar jpeg, this means
>> that they send 3 SOS markers with one component per scan. I don't know
>> if libjpeg will grok this (I had to patch libv4l's tinyjpeg copy for
>> this). But first lets see how libjpeg performs, and then we can always
>> use tinyjpeg to parse the header and depending on the header decide to
>> use tinyjpeg or libjpeg.
>>
>> Sorry about nacking your ffmpeg patch,
>
> While the patch is not the cleanest, there shouldn't be a problem of
> making ffmpeg mjpeg decoding optional.

If and only if libjpeg-turbo turns out to be much slower this is something
to consider. But the first thing to do here is see if we can solve this
in a way which is acceptable to all downstream users of libv4l, and thus
can be added in a non optional way (so make libv4l require libjpeg).

I'm not a big fan of optional features / compile time options as they
do not make support any easier.

Regards,

Hans
