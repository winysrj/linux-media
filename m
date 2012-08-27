Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47954 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab2H0KDh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Aug 2012 06:03:37 -0400
Message-ID: <503B45E8.1050002@iki.fi>
Date: Mon, 27 Aug 2012 13:03:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec H7 aka az6007 with CI
References: <503A7E98.9030404@gmail.com>
In-Reply-To: <503A7E98.9030404@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/26/2012 10:52 PM, Roger Mårtensson wrote:
> Hello!
>
> Just a reminder that az6007 with CI still isn't working 100% with Kaffeine.
> But since I use my device with MythTV that uses the same usage pattern
> as my workaround for Kaffeine it works like a charm.
>
> The pattern are:
> * Open up device / Start Kaffeine
> * Tune to encrypted channel / Choose channel in Kaffeine
> * Close Device / Close Kaffeine
> * Open device / Start Kaffeine
> * Watch channel
>
> The exact procedure that MythTV uses when tuning to a channel.
>
> Not exactly sure if this is a driver bug or a Kaffeine bug since I'm
> just a user.

It is likely driver bug.

You could take sniffs from windows and do some hacking. It should not be 
very hard to fix.

> The "normal" way that do not work in Kaffeine are:
> * Start Kaffeine
> * Tune to an encrypted channel
> * If that works tune to another encrypted channel which will not work.
>
> Since it is working with my main application I'm satisfied but look at
> this as a formal bug report. If you need any help or testing I'm willing
> to help time permitting. I know that some of you doing the actual work
> doesn't have access to a CAM but if you need debugging information or
> any output just notify me directly.
>
> I'm am running a relativly new media_build. Haven't been able to test
> the latest media_build since it is stopping on a compile error. (As of
> 25 of August 2012)

I don't see that, but it is not surprise as I use latest Kernel.

Also latest build test logs shows all builds are working
http://hverkuil.home.xs4all.nl/logs/Sunday.log


> Thanks again for the hard work with the driver (Mauro for the inclusion
> and Jose for the CI. Hopefully I got the names right).
>
> It is much appreciated by me and my better half.

regards
Antti

-- 
http://palosaari.fi/
