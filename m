Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:50422 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3KXSU3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Nov 2013 13:20:29 -0500
Received: by mail-we0-f176.google.com with SMTP id t61so2964341wes.35
        for <linux-media@vger.kernel.org>; Sun, 24 Nov 2013 10:20:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA9z4Lbro=UjZjcjK1e51ikVG7Q2XU9Ei1XWPELCq47iGowkWg@mail.gmail.com>
References: <20130603171607.73d0b856@endymion.delvare>
	<20130603172150.1aaf1904@endymion.delvare>
	<CAHFNz9LX0WzmO1zvn51Ge8VQkfiPrao3AQVLprhqrp1V-0h=fQ@mail.gmail.com>
	<CAA9z4Lbro=UjZjcjK1e51ikVG7Q2XU9Ei1XWPELCq47iGowkWg@mail.gmail.com>
Date: Sun, 24 Nov 2013 13:20:26 -0500
Message-ID: <CAGoCfixzV+N7WMhwA=e72pvQJREV5KaR0By=O6+emgsS5eQwGA@mail.gmail.com>
Subject: Re: [PATCH 2/3] femon: Display SNR in dB
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chris Lee <updatelee@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 24, 2013 at 1:02 PM, Chris Lee <updatelee@gmail.com> wrote:
> This is a frustration of mine. Some report it in SNR others report it
> in terms of % (current snr / (max_snr-min_snr)) others its completely
> random.
>
> Seems many dvb-s report arbitrary % which is stupid and many atsc
> report snr by 123 would be 12.3db. But there isnt any standardization
> around.
>
> imo everything should be reported in terms of db, why % was ever
> chosen is beyond logic.
>
> Is this something we can get ratified ?

I wouldn't hold your breath.  We've been arguing about this for years.
 You can check the archives for the dozens of messages exchanged on
the topic.

Given almost all the Linux drivers for ATSC/ClearQAM devices sold
today report in 0.1 dB increments, I'm tempted to put a hack in the
various applications to assume all ATSC devices are in that format.
I've essentially given up on any hope that there will be any agreement
on a kernel API which applications can rely on for a uniform format.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
