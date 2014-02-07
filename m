Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:47619 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaBGSjd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 13:39:33 -0500
Received: by mail-qc0-f170.google.com with SMTP id e9so6753418qcy.1
        for <linux-media@vger.kernel.org>; Fri, 07 Feb 2014 10:39:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52F524A8.9000008@earthlink.net>
References: <52F524A8.9000008@earthlink.net>
Date: Fri, 7 Feb 2014 13:39:32 -0500
Message-ID: <CALzAhNWfUWYtQaRH-BcWhY6YE1pV3P=69R2NyXHUeAwZMrfrcg@mail.gmail.com>
Subject: Re: Driver for KWorld UB435Q Version 3 (ATSC) USB id: 1b80:e34c
From: Steven Toth <stoth@kernellabs.com>
To: The Bit Pit <thebitpit@earthlink.net>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 7, 2014 at 1:23 PM, The Bit Pit <thebitpit@earthlink.net> wrote:
> Last May I started writing a driver for a KWorld UB435Q Version 3
> tuner.  I was able to make the kernel recognize the device, light it's
> LED, and try to enable the decoder and tuner.

Slightly related.... I added support for the KWorld UB445-U2
ATSC/Analog stick the other day. It uses the cx231xx bridge, LG3305
and TDA18272 tuner. It was fairly simple to get running. Analog and
digital TV work OK, the baseband inputs and alsa are running. No great
shakes.

Manu has a TDA18272 Linux tree if you google a little.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
