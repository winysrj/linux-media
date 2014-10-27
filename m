Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44747 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaJ0Rii (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 13:38:38 -0400
Received: by mail-pa0-f44.google.com with SMTP id bj1so2349450pad.3
        for <linux-media@vger.kernel.org>; Mon, 27 Oct 2014 10:38:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141027162252.GA9984@linuxtv.org>
References: <BLU437-SMTP74723F476D15D78EEEA959BA900@phx.gbl>
	<20141027094619.69851745.m.chehab@samsung.com>
	<CAOcJUbyK7Y5=fMfEGv5rhC3bPpeiiS3Mp1z+8cVfHoqy-opy5Q@mail.gmail.com>
	<20141027135727.297ba10a.m.chehab@samsung.com>
	<20141027162252.GA9984@linuxtv.org>
Date: Mon, 27 Oct 2014 13:38:38 -0400
Message-ID: <CAOcJUbxU=uQXCuxiAY95TmwB+pk0xmPYQFBzWvdSAsdjtHnXrA@mail.gmail.com>
Subject: Re: [PATCH 1/3] xc5000: tuner firmware update
From: Michael Ira Krufky <mkrufky@linuxtv.org>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	Richard Vollkommer <linux@hauppauge.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 27, 2014 at 12:22 PM, Johannes Stezenbach <js@linuxtv.org> wrote:
> On Mon, Oct 27, 2014 at 01:57:27PM -0200, Mauro Carvalho Chehab wrote:
>> Em Mon, 27 Oct 2014 10:25:48 -0400
>> Michael Ira Krufky <mkrufky@linuxtv.org> escreveu:
>>
>> > I like the idea of supporting older firmware revisions if the new one
>> > is not present, but, the established president for this sort of thing
>> > has always been to replace older firmware with newer firmware without
>> > backward compatibility support for older binaries.
>>
>> No, we're actually adding backward support. There are some drivers
>> already with it. See for example xc4000 (changeset da7bfa2c5df).
>>
>> > Although the current driver can work with both old and new firmware
>> > versions, this hasn't been the case in the past, and won't always be
>> > the case with future firmware revisions.
>>
>> Yeah, we did a very crap job breaking backward firmware compat in
>> the past. We're not doing it anymore ;)
>>
>> > Hauppauge has provided links to the new firmware for both the XC5000
>> > and XC5000C chips along with licensing.  Maybe instead, we can just
>> > upstream those into the linux-firmware packages for distribution.
>>
>> Upstreaming to linux-firmware was done already for the previous firmwares.
>> The firmwares at linux-firmware for xc5000 and xc5000c were merged back
>> there for 3.17 a few weeks ago.
>>
>> Feel free to submit them a new version.
>>
>> > I don't think supporting two different firmware versions is a good
>> > idea for the case of the xc5000 driver.
>>
>> Why not? It should work as-is with either version. We can always add
>> some backward compat code if needed.
>
> FWIW, Linus recently addressed the topic wrt wireless firmware:
> http://article.gmane.org/gmane.linux.kernel.wireless.general/126794
>
>
> HTH,
> Johannes

OK, I read Linus' email.  I am willing to add an additional patch that
will look for the new firmware image and fall back to the older one if
the new one is not present, but I strongly believe that we should only
support both firmware revisions for a finite period of time -- this
can give people (and distros) time to update to the newer firmware,
and will help to eliminate future bug reports and quality issues that
would otherwise have been resolved by moving to the new firmware.

The new firmware image itself is a bug-fix and improves tuning
performance.  If users complain of quality issues using the old
firmware, it will not be very likely to gain developer interest, as
only the new firmware is considered to be truly "supported" now.

Is this acceptable?

-Mike Krufky
