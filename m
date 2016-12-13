Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53252 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750988AbcLMLPt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 06:15:49 -0500
Subject: Re: em28xx - Hauppauge WinTV Dualhd atsc/qam
To: Kevin Cheng <kcheng@gmail.com>, linux-media@vger.kernel.org
References: <CAKNt1=e_eb5G4Ka1ao5Bpfas+BCefRh9vWVjQ2tKiyh97ouQUw@mail.gmail.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <98c2999b-e134-55a6-06b9-371ace9546ae@iki.fi>
Date: Tue, 13 Dec 2016 13:15:47 +0200
MIME-Version: 1.0
In-Reply-To: <CAKNt1=e_eb5G4Ka1ao5Bpfas+BCefRh9vWVjQ2tKiyh97ouQUw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2016 06:05 AM, Kevin Cheng wrote:
> Hi all,
>
> I'm working on support in the em8xx module for the Hauppauge WinTV
> dualhd atsc/qam usb stick. I'vey got the first tuner+fe working so
> far, but would appreciate any suggestions/feedback on the items below.
>
> the device has:
> 2x LGDT3306A frontend
> 2x si2157 tuner
>
> (1) since the tuner sits behind the front end, I initially had the
> front end configured to use the i2c gate control but this wasn't
> enough because the tuner would send commands on a timer without
> knowing that the gate had to be opened.
>
> I added an i2c_driver to the lgdt3306a module using an i2c_mux and it
> solved the problem but the lgdt3306a module now has two ways to
> initialize -- through _attach and through (i2c) _probe.  Is this the
> correct approach?

It is correct approach.

> (2) The second front end + tuner registers ok but doesn't work quite
> right.  Tuning works but it doesn't seem like the stream is passing
> through... I noticed that em28xx_capture_start in em28xx-core.c is
> hardcoded to only use the first transport stream but when i tested
> changing it to only enable TS2, that didn't work either.  I'm guessing
> there is something else in the code that's assuming only the first
> transport stream is used.  Anyone have an idea of what I'm missing?
>
>
> Thanks,
> -Kevin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
http://palosaari.fi/
