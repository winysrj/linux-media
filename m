Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:36682 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbbFDMq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2015 08:46:57 -0400
Received: by qkx62 with SMTP id 62so22903722qkx.3
        for <linux-media@vger.kernel.org>; Thu, 04 Jun 2015 05:46:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALzAhNWZxoCHyYmjTKVzMR-7z_+cqAmcG_LAuCKEaoDdP1JswQ@mail.gmail.com>
References: <b69d68a858a946c59bb1e292111504ad@IITMAIL.intellectit.local>
	<556EB2F7.506@iki.fi>
	<556EB4B0.8050505@iki.fi>
	<CAAZRmGxby0r20HX6-MqmFBcJ1de3-Op0XHyO4QrErkZ0K3Om2Q@mail.gmail.com>
	<CALzAhNWZxoCHyYmjTKVzMR-7z_+cqAmcG_LAuCKEaoDdP1JswQ@mail.gmail.com>
Date: Thu, 4 Jun 2015 08:46:56 -0400
Message-ID: <CALzAhNXPBOhYeirQrp8OVqS9cEqMcFcBEjx-nohWBLK-xrUgCg@mail.gmail.com>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
From: Steven Toth <stoth@kernellabs.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Antti Palosaari <crope@iki.fi>,
	Stephen Allan <stephena@intellectit.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> If the GPIOs aren't truly resetting the SI2168 and thus a warm boot
> didn't flush the firmware, I suspect dropping the patches would have
> no immediate effect until a full power-down took place. I'm wondering
> whether the testing was invalid and indeed we have a problem in the
> field, as well as a GPIO issue. Two potential issues.
>
> I'll schedule sometime later this week to fire up my HVR22xx dev
> platform and re-validate the 2205.

For the record, here's what happened.

1. The GPIO is working correctly, I've validated this with a meter.
This wasn't a warm vs cold boot issue, or in any way Windows related.
2. I have multiple HVR22x5 cards. a HVR2205 and a HVR2215. The HVR2215
I obtained much later after prompting my Olli, it has a newer build
date stamped on the demodulators and reports a newer chip version.
These newer demods are not recognized by the current tip, the prior
ones are.

The solution was to patch the SI2168 to recognize the newer demodulator version.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
