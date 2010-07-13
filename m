Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62013 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab0GNAAS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jul 2010 20:00:18 -0400
Received: by gwj18 with SMTP id 18so3090888gwj.19
        for <linux-media@vger.kernel.org>; Tue, 13 Jul 2010 17:00:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100713211345.43caeabb@tele>
References: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
	<20100707074431.66629934@tele> <AANLkTimxJi3qvIImwUDZCzWSCC3fEspjAyeXg9Qkneyo@mail.gmail.com>
	<20100707110613.18be4215@tele> <AANLkTim6xCtIMxZj3f4wpY6eZTrJBEv6uvVZZoiX-mg6@mail.gmail.com>
	<20100708121454.75db358c@tele> <AANLkTilw1KxYanoQZEZVaiFCLfkdTpO72Z9xV73i4gm2@mail.gmail.com>
	<20100709200312.755e8069@tele> <AANLkTikxIJxuQiV_7PqPA5C6ZU5XhhmmQ3hAbIwWsrPT@mail.gmail.com>
	<20100710113616.1ed63ebc@tele> <AANLkTikrKBpRSI6wVdMO3tSYPhm1CECFGeNiyJdzTa03@mail.gmail.com>
	<20100711155008.1f8f583f@tele> <AANLkTinnNhJ-DoFWfU8U5NuTj_p48SefYzWWAxZqiUb-@mail.gmail.com>
	<20100712101802.08527e82@tele> <AANLkTinUHyTHt78ihMHy8dzz0kfPvUMBXKreRmuM-cYW@mail.gmail.com>
	<20100712132100.1b4072b9@tele> <AANLkTimku962Cm_7glThtq3X3jZiwmHSWOYzc2d3WLBl@mail.gmail.com>
	<20100713211345.43caeabb@tele>
From: Kyle Baker <kyleabaker@gmail.com>
Date: Tue, 13 Jul 2010 19:59:57 -0400
Message-ID: <AANLkTik5_v0Siy4K6rA0gsLxmA1XmoJAlVv3Dd1gu5hb@mail.gmail.com>
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 13, 2010 at 3:13 PM, Jean-Francois Moine <moinejf@free.fr> wrote:
> In the new gspca test version (2.9.52), I modified the driver for it
> checks the audio device. If present, the bandwidth is reduced and for
> the sn9c105, the bit 0x04 of the GPIO register is always set (I hope
> that the audio connection is done in the same way by all manufacturer!).

I can verify that GSPCA 2.9.52 does indeed work with VX-1000. How long
does it take typically for these changes to work their way into the
Kernel? I'd love to see this included in the Kernel by the time Ubuntu
10.10 is released so I can stop tweaking webcam settings.

On a different note, I've noticed that there is a bug either with
Cheese or with the camera drivers after recording video. The problem
is that, after I record a video in Cheese, the recording stops and the
video is saved, but the record button is now disabled until I reopen
the application.

I'm curious why this would happen, but I think that more people would
notice this bug if it were a Cheese bug. I'm wondering if there is
something that isn't transferred or set correctly after ending the
video/audio data transfers. Cheese is working with V4L2 well in all
other aspects.

I have been testing with Ubuntu 10.10, so I will install your latest
drivers in Ubuntu 10.04 (stable) to see what happens. I know that on
my laptop in Ubuntu 10.04 (where video worked, but audio didn't), the
video would save and the button is re-enabled correctly. I'll test
this against your latest release to see what happens since Ubuntu
10.04 installs GSPCA 2.7.0 by default. I will let you know of the
results soon.

And one more question. Is there anyway to give the camera button an
action when the camera is not on? In windows, pressing the button
would launch a predefined application (Windows Live Messenger), but I
would like to write in the ability to open either a buddy list or
Cheese or something relevant from the button if possible.

Thanks.

-- 
Kyle Baker
