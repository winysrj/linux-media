Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45120 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646Ab2GMNQh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 09:16:37 -0400
Received: by ghrr11 with SMTP id r11so3525234ghr.19
        for <linux-media@vger.kernel.org>; Fri, 13 Jul 2012 06:16:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FFF763B.1060705@iki.fi>
References: <4FFF327A.9080300@iki.fi>
	<CALzAhNVwN3TJhn-3i9SDhKfk=tvZZ49RTKkUzWC8RZ_m=v=A+w@mail.gmail.com>
	<CALzAhNUmdcd7cE-fcMHJsNk1rTcKXoZR9Oyu+5XciNZQ57EBGQ@mail.gmail.com>
	<4FFF763B.1060705@iki.fi>
Date: Fri, 13 Jul 2012 09:16:36 -0400
Message-ID: <CALzAhNXTq5T1SyukjoswUFo8HS6q9XzP=nUPUSTV-xjGPUUQMQ@mail.gmail.com>
Subject: Re: GPIO interface between DVB sub-drivers (bridge, demod, tuner)
From: Steven Toth <stoth@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> There is set_property() and get_property() callbacks defined for FE already.
> But those are not used. My opinion is that those callbacks should be changed
> to deliver data for demodulator and for tuner too instead of current method
> - which is common huge properties cache structure shared between all
> sub-drivers. I don't like it all as it is stupid to add stuff that common
> structure for every standard we has. Lets take example device that supports
> DVB-C and other device supports ISDB-T. How many common parameters we has? I
> think only one - frequency. All the others are just waste.

When we did DVB V5 for S2 we added set/get property for the
demodulators, from memory I had some cx24116 S2 specifics that I was
passing, and I expected other demod drivers to adopt the same
mechanism. It was fairly obvious at the time that we needed a much
more generic way to pass internel controls around from the core to the
demods.

The cache was to support backwards compatible V3 interfaces and
demods, amongst other things.

No reason why a new demod today could not support get/set only for
configuration.

>
> What I think I am going to make new RFC which changes that so every
> parameter from userspace is passed to the demodulator driver (using
> set_property() - change it current functionality) and not cached to the
> common cache at all. Shortly: change current common cache based parameter
> transmission to happen set parameter to demodulator one by one.

The other reason for the common cache was to allow sets of parameters
to be pushed into the kernel from apps then, at the most appropriate
time, tuned. The order of operations becomes irrelevant, so the cache
is highly useful, else you end up with demods caching all of their own
parameters anyway, many drivers duplicating a frequency field in their
provate contexts, for example.

It's hard to imaging how not using the cache today.

>
>>> What did you ever decide about the enable/disable of the LNA? And, how
>>> would the bridge do that in your proposed solution? Via the proposed GPIO
>>> interface?
>
>
> I sent PATCH RFC for DVB API to add LNA support yesterday. It is new API

Understood, thanks for the note.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490
