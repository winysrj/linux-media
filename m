Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:36412 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbbFCOaK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2015 10:30:10 -0400
Received: by qgep100 with SMTP id p100so4399829qge.3
        for <linux-media@vger.kernel.org>; Wed, 03 Jun 2015 07:30:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAZRmGxby0r20HX6-MqmFBcJ1de3-Op0XHyO4QrErkZ0K3Om2Q@mail.gmail.com>
References: <b69d68a858a946c59bb1e292111504ad@IITMAIL.intellectit.local>
	<556EB2F7.506@iki.fi>
	<556EB4B0.8050505@iki.fi>
	<CAAZRmGxby0r20HX6-MqmFBcJ1de3-Op0XHyO4QrErkZ0K3Om2Q@mail.gmail.com>
Date: Wed, 3 Jun 2015 10:30:09 -0400
Message-ID: <CALzAhNWZxoCHyYmjTKVzMR-7z_+cqAmcG_LAuCKEaoDdP1JswQ@mail.gmail.com>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
From: Steven Toth <stoth@kernellabs.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Antti Palosaari <crope@iki.fi>,
	Stephen Allan <stephena@intellectit.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 3, 2015 at 5:29 AM, Olli Salonen <olli.salonen@iki.fi> wrote:
> I'm seeing the same issue as well. I thought that maybe some recent
> Si2168 changes did impact this, but it does not seem to be the case.

We've had a couple of people raise this so its highly likely we have an issue.

I had some patches to the 2168 driver to add support for a new
firmware revision. The last time I tested the HVR2205 I convinced
myself those were not required, thus I discarded those and re-tested.
Probably a warm boot.

If the GPIOs aren't truly resetting the SI2168 and thus a warm boot
didn't flush the firmware, I suspect dropping the patches would have
no immediate effect until a full power-down took place. I'm wondering
whether the testing was invalid and indeed we have a problem in the
field, as well as a GPIO issue. Two potential issues.

I'll schedule sometime later this week to fire up my HVR22xx dev
platform and re-validate the 2205.

Thanks for raising this.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
