Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:35311 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbbFCWQz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2015 18:16:55 -0400
Received: by qkhq76 with SMTP id q76so14301975qkh.2
        for <linux-media@vger.kernel.org>; Wed, 03 Jun 2015 15:16:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20150603T234551-193@post.gmane.org>
References: <b69d68a858a946c59bb1e292111504ad@IITMAIL.intellectit.local>
	<556EB2F7.506@iki.fi>
	<CALzAhNWKPOFe1=jdo6f=FFMtWyNWxm34M1EoJA0CMD3GZfhvWA@mail.gmail.com>
	<loom.20150603T234551-193@post.gmane.org>
Date: Wed, 3 Jun 2015 18:16:54 -0400
Message-ID: <CALzAhNVLBdpk3R9use4hOuc4z49a4QreFmsfOb2bCyezy6GU9Q@mail.gmail.com>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
From: Steven Toth <stoth@kernellabs.com>
To: Peter Faulkner-Ball <faulkner-ball@xtra.co.nz>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I have a working solution (workaround) for the HVR2205/HVR2215 firmware
> loading issue.
>
>
> In the file:
>
> dvb-frontends/si2168.c
>
>
> change:
>
> #define SI2168_B40 ('B' << 24 | 68 << 16 | '4' << 8 | '0' << 0)
>
>
> to:
>
> #define SI2168_B40 (68 << 16 | '4' << 8 | '0' << 0)
>
>
> I do not know why this works, but this is the place where the new chip
> is not being detected correctly.
>
> In my case the chip is labelled as: SI2168 40
> When the firmware failed to load the error log reported as: si2168-x0040
>
> I hope this is helpful.
>
>
> I have 2x HVR2215 cards both working for DVB-T on OpenSuse13.2

So the hardware is reporting as a 'D' revision, and a prior firmware
is being loaded and its working nicely. Looks like an easy fix to the
2168 driver.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
