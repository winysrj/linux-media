Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:53494 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3ADSN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 13:13:27 -0500
Received: by mail-la0-f48.google.com with SMTP id ej20so9975506lab.7
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 10:13:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50E6E0FC.7060903@iki.fi>
References: <50E6E0FC.7060903@iki.fi>
Date: Fri, 4 Jan 2013 13:13:25 -0500
Message-ID: <CAOcJUbz=csJ0iVSPSf1ihtO6KdQQOob7tXMi-2yrgc-jmEsXbQ@mail.gmail.com>
Subject: Re: RFC run time configuration parameter checks in subdriver
From: Michael Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 4, 2013 at 9:02 AM, Antti Palosaari <crope@iki.fi> wrote:
> I would like to discuss if there is idea to validate subdriver parameters
> explicitly at run-time when subdriver module is load.
>
> There is configuration parameters for about every driver like:
> * I2C address
> * clock frequency
>
> Nowadays, when main driver loads subdriver, it passes those static
> compile-time parameters to the subdriver, those parameters are not mainly
> validated at all. That could lead situation device is not working, instead
> it is will fail with some error, like I/O as I2C address is wrong.
>
> As these parameters are set compile time, this situation affects only
> developers which are adding support for new hardware.
>
> regards
> Antti

As Linux itself appeals most to developers, or at least we as
developers want to encourage Linux users to be involved in their
operating system, I believe it is indeed best to provide checking and
error reporting for the sake of development (especially by newcomer
programmers) during driver bring-up *and* for the use case of users
themselves.

I understand that you are very concerned with "bloat" of what you
consider to be potentially unnecessary checks, but I do believe that
this is better for the grand scheme of things.  If you have concerns
about "bloat" then I would indeed find it friendly to make these such
checks conditional to be included in debug mode, only.  (or if the
kernel is compiled with the media subsystem's "advanced debug" flag
enabled)

Is that a fair compromise?

Cheers,

Mike Krufky
