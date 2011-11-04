Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab1KDKtU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Nov 2011 06:49:20 -0400
Message-ID: <4EB3C32E.4010208@redhat.com>
Date: Fri, 04 Nov 2011 08:49:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>
Subject: Re: [GIT PULL FOR v3.2] Compilation fixes
References: <201111041039.58290.hverkuil@xs4all.nl> <4EB3BAE4.2080303@redhat.com> <4EB3BC39.9000404@redhat.com> <201111041127.02908.hverkuil@xs4all.nl>
In-Reply-To: <201111041127.02908.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-11-2011 08:27, Hans Verkuil escreveu:
> On Friday 04 November 2011 11:19:37 Mauro Carvalho Chehab wrote:
>> Em 04-11-2011 08:13, Mauro Carvalho Chehab escreveu:
>>> Em 04-11-2011 07:39, Hans Verkuil escreveu:
>>>> Mauro,
>>>>
>>>> This fixes two compilation problems when using the media_build system.
>>>>
>>>> Both gspca and the solo driver have a header with the same name, and
>>>> that clashes when using media_build.
>>>
>>> This the kind of patch that doesn't make much sense upstream. Granted,
>>> the files weren't properly named, but there's not requirement upstream
>>> that denies naming two different files with the same name.
>>>
>>> Btw, looking at both, it seems that they can be merged: both defines the
>>> jpeg header. The basic difference is that, while gspca jpeg header can
>>> have a size of either 556 or 589 bytes, the one at solo6x10 has 575
>>> bytes.
>>>
>>> IMHO, the proper fix is to make solo6x10 driver to use the gspca jpeg.h
>>> header. Assuming that this driver would find his way out of staging,
>>> then the jpeg.h file should also be moved to another place, like
>>> include/linux/media, as I don't think that solo6x10 driver should be a
>>> gspca sub-driver.
>>>
>>> Hans G, what do you think?
>>
>> The quantization tables are completely different on Solo driver. Merging
>> them will probably be very messy. I withdraw the proposal of merging them.
>>
>> Your patch makes sense to me.
> 
> OK.
> 
> Perhaps the gspca jpeg.h header should be renamed to gspca-jpeg.h as well?

I think so, as it currently doesn't implement a generic way of generating
jpeg headers.

> Since the solo driver is in staging I went for just renaming the header in
> that driver rather than renaming a header in a non-staging driver.
> 
>>>> And the solo driver uses an incorrect Makefile construct, which
>>>> (somewhat mysteriously) skips the compilation of 90% of all media
>>>> drivers.
>>>
>>> Hmm.. probably they're using "=" or ":=" instead of "+=". While this
>>> works at leaf Makefiles, this breaks compilation when there's just one
>>> Makefile, or when you add another thing to be compiled there. This is
>>> something that requires a fix.
> 
> That's indeed what I fixed in my second patch (:= -> +=).

Ok.

Regards,
Mauro
