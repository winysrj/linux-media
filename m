Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34074 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234Ab2H3Qgk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 12:36:40 -0400
Received: by lagy9 with SMTP id y9so1686386lag.19
        for <linux-media@vger.kernel.org>; Thu, 30 Aug 2012 09:36:38 -0700 (PDT)
Message-ID: <503F9692.8000600@gmail.com>
Date: Thu, 30 Aug 2012 18:36:34 +0200
From: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec H7 aka az6007 with CI
References: <503A7E98.9030404@gmail.com> <503B45E8.1050002@iki.fi>
In-Reply-To: <503B45E8.1050002@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari skrev 2012-08-27 12:03:
> On 08/26/2012 10:52 PM, Roger Mårtensson wrote:
>> The pattern are:
>> * Open up device / Start Kaffeine
>> * Tune to encrypted channel / Choose channel in Kaffeine
>> * Close Device / Close Kaffeine
>> * Open device / Start Kaffeine
>> * Watch channel
>>
>> The exact procedure that MythTV uses when tuning to a channel.
>>
>> Not exactly sure if this is a driver bug or a Kaffeine bug since I'm
>> just a user.
>
> It is likely driver bug.
>
> You could take sniffs from windows and do some hacking. It should not be
> very hard to fix.

Sorry but that is a no go for me.. It is in production now and my 
boss(AKA Wife) would do some unspeakable to me if I do anything that 
interrupts her favourite shows. Just kidding about the last part but not 
about running on windows. Sorry.

I will do my best if you or anyone else need any debugging done and/or 
testing of patches that I can use when compiling media_build.

>> The "normal" way that do not work in Kaffeine are:
>> * Start Kaffeine
>> * Tune to an encrypted channel
>> * If that works tune to another encrypted channel which will not work.
>>
>> Since it is working with my main application I'm satisfied but look at
>> this as a formal bug report. If you need any help or testing I'm willing
>> to help time permitting. I know that some of you doing the actual work
>> doesn't have access to a CAM but if you need debugging information or
>> any output just notify me directly.
>>
>> I'm am running a relativly new media_build. Haven't been able to test
>> the latest media_build since it is stopping on a compile error. (As of
>> 25 of August 2012)
>
> I don't see that, but it is not surprise as I use latest Kernel.
>
> Also latest build test logs shows all builds are working
> http://hverkuil.home.xs4all.nl/logs/Sunday.log

I did some more testing today and it seems that my media_build 
environment was in a funky state. Will try to take some time and install 
latest and greatest not that I'm very optimistic. Mauro did some work 
lately on the driver but he said it shouldn't have anything to do about 
this problem and the commit messages seems to be about something 
entirely different.

Since it is setup correctly when opening the device it looks like the 
same stuff has to be done when tuning? Maybe a forced CAM-reset or 
something? Well.. Now I'm just guessing.

Since the driver is the same for DVB-T and DVB-C both types should 
experience the same problem.

Isn't there anyone else on this list with this device with access to a 
CAM/CI that could help? Pretty please? :-)

Thanks again for the response. Sorry I couldn't help with USB snooping .
It is a very good device and I sure would like to get it to work even on 
kaffeine :). It's quite new. Still in production and with working CI. 
That is a rare thing in Linux.


>
>
>> Thanks again for the hard work with the driver (Mauro for the inclusion
>> and Jose for the CI. Hopefully I got the names right).
>>
>> It is much appreciated by me and my better half.
>
> regards
> Antti
>

