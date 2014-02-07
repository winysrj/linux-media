Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:51097 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaBGUYL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 15:24:11 -0500
Received: by mail-vb0-f43.google.com with SMTP id p5so3010287vbn.16
        for <linux-media@vger.kernel.org>; Fri, 07 Feb 2014 12:24:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALzAhNWfUWYtQaRH-BcWhY6YE1pV3P=69R2NyXHUeAwZMrfrcg@mail.gmail.com>
References: <52F524A8.9000008@earthlink.net>
	<CALzAhNWfUWYtQaRH-BcWhY6YE1pV3P=69R2NyXHUeAwZMrfrcg@mail.gmail.com>
Date: Sat, 8 Feb 2014 01:54:10 +0530
Message-ID: <CAHFNz9KTii80nF70aTV0HAwEugf8NOHYRZ2HHJ=NF=iVDFLQ+g@mail.gmail.com>
Subject: Re: Driver for KWorld UB435Q Version 3 (ATSC) USB id: 1b80:e34c
From: Manu Abraham <abraham.manu@gmail.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: The Bit Pit <thebitpit@earthlink.net>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 8, 2014 at 12:09 AM, Steven Toth <stoth@kernellabs.com> wrote:
> On Fri, Feb 7, 2014 at 1:23 PM, The Bit Pit <thebitpit@earthlink.net> wrote:
>> Last May I started writing a driver for a KWorld UB435Q Version 3
>> tuner.  I was able to make the kernel recognize the device, light it's
>> LED, and try to enable the decoder and tuner.
>
> Slightly related.... I added support for the KWorld UB445-U2
> ATSC/Analog stick the other day. It uses the cx231xx bridge, LG3305
> and TDA18272 tuner. It was fairly simple to get running. Analog and
> digital TV work OK, the baseband inputs and alsa are running. No great
> shakes.
>
> Manu has a TDA18272 Linux tree if you google a little.


If you need, I can push the 7231 tree up as well for upstream merge.
