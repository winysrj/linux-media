Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:33530 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbaBGURo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 15:17:44 -0500
Message-ID: <52F53F60.6090003@earthlink.net>
Date: Fri, 07 Feb 2014 14:17:36 -0600
From: The Bit Pit <thebitpit@earthlink.net>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Linux-Media <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: Driver for KWorld UB435Q Version 3 (ATSC) USB id: 1b80:e34c
References: <52F524A8.9000008@earthlink.net> <CALzAhNWfUWYtQaRH-BcWhY6YE1pV3P=69R2NyXHUeAwZMrfrcg@mail.gmail.com>
In-Reply-To: <CALzAhNWfUWYtQaRH-BcWhY6YE1pV3P=69R2NyXHUeAwZMrfrcg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks steve,

Found it.  Its the same files I found at a different place.  I don't
understand the way to do things.
Last time I simply edited the kernel tree and supplied patches to get my
changes in.  The source for  tda18272 is not in the kernel tree I 'git'
following the instructions at linuxtv.org.  It is in Manu's tree, but
the directory structure is slightly different.

I don't understand the current development process.  Are the
instructions at linuxtv.org out of date?

In which tree should I edit the following and supply patches against:
usb/em28xx/em28xx-cards.c
usb/em28xx/em28xx-dvb.c
usb/em28xx/em28xx.h

On 02/07/2014 12:39 PM, Steven Toth wrote:
> On Fri, Feb 7, 2014 at 1:23 PM, The Bit Pit <thebitpit@earthlink.net> wrote:
>> Last May I started writing a driver for a KWorld UB435Q Version 3
>> tuner.  I was able to make the kernel recognize the device, light it's
>> LED, and try to enable the decoder and tuner.
> Slightly related.... I added support for the KWorld UB445-U2
> ATSC/Analog stick the other day. It uses the cx231xx bridge, LG3305
> and TDA18272 tuner. It was fairly simple to get running. Analog and
> digital TV work OK, the baseband inputs and alsa are running. No great
> shakes.
>
> Manu has a TDA18272 Linux tree if you google a little.
>
> - Steve
>

