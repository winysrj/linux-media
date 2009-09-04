Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:32909 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbZIDL2K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Sep 2009 07:28:10 -0400
Received: by vws33 with SMTP id 33so605498vws.33
        for <linux-media@vger.kernel.org>; Fri, 04 Sep 2009 04:28:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090904112438.15890681@tele>
References: <1250820538.29546.5.camel@Joe-Laptop.home>
	 <20090904112438.15890681@tele>
Date: Fri, 4 Sep 2009 07:28:11 -0400
Message-ID: <f34657950909040428p433925g330509acd551f29a@mail.gmail.com>
Subject: Re: [PATCH] sn9c20x: Reduce data usage, make functions static
From: Brian Johnson <brijohn@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Joe Perches <joe@perches.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois,

The two red tables actually do contain values greater then 127 so
would not fit within a s8 variable, the other four i think may have
only values between -128 and 127 but i haven't gone through and made
sure of that.

Brian

On Fri, Sep 4, 2009 at 5:24 AM, Jean-Francois Moine<moinejf@free.fr> wrote:
> On Thu, 20 Aug 2009 19:08:58 -0700
> Joe Perches <joe@perches.com> wrote:
>
>> Compiled, not tested, no hardware
>>
>> Reduces size of object
>>
>> Use s16 instead of int where possible.
>        [snip]
>> -static const int hsv_red_x[] = {
>> +static const s16 hsv_red_x[] = {
>>       41,  44,  46,  48,  50,  52,  54,  56,
>>       58,  60,  62,  64,  66,  68,  70,  72,
>>       74,  76,  78,  80,  81,  83,  85,  87,
>        [snip]
>
> Hi Joe and Brian,
>
> I got the patch but I was wondering if such tables could be even
> smaller with 's8'?
>
> Cheers.
>
> --
> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
>
