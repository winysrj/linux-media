Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47911 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab1HGBEc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2011 21:04:32 -0400
Received: by fxh19 with SMTP id 19so4088998fxh.19
        for <linux-media@vger.kernel.org>; Sat, 06 Aug 2011 18:04:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312678116.50271.YahooMailClassic@web130113.mail.mud.yahoo.com>
References: <S1756684Ab1HGARL/20110807001711Z+1467@vger.kernel.org>
	<1312678116.50271.YahooMailClassic@web130113.mail.mud.yahoo.com>
Date: Sat, 6 Aug 2011 21:04:30 -0400
Message-ID: <CAGoCfiyKMQXAuGzQY-cr0fauLz7WFdW8TOGfn3qzcHuvXPMw3A@mail.gmail.com>
Subject: Re: Any advice for writing Ruby driver for Hauppauge WinTV-HVR-1150
 on Linux?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bob Carpenter <rgc3679@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 6, 2011 at 8:48 PM, Bob Carpenter <rgc3679@yahoo.com> wrote:
> I'd like to write a driver using Ruby language for a Hauppauge WinTV-HVR-1150 card.
>
> I will be attaching an NTSC analog camera to the composite video input and want to stream the video across the internet to a client app that can display it.
>
> I've never written a PCI driver.
>
> The 1150 card will be attached to an Ubuntu 10.04 box.
>
> I'd welcome any ideas or advice to get started.
>
> Thanks,
>
> --Bob

Several points:

Under Linux, you don't write drivers in Ruby.  You write them in C.

The HVR-1150 already has a driver under Linux.

You probably want to be writing a Ruby application, not a driver.

You should probably start by reading the video4linux2 API
documentation, which is the kernel API for interacting with tuner
drivers.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
