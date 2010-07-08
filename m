Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38831 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab0GHWzD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jul 2010 18:55:03 -0400
Received: by gye5 with SMTP id 5so811440gye.19
        for <linux-media@vger.kernel.org>; Thu, 08 Jul 2010 15:55:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100708121454.75db358c@tele>
References: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
	<20100707074431.66629934@tele> <AANLkTimxJi3qvIImwUDZCzWSCC3fEspjAyeXg9Qkneyo@mail.gmail.com>
	<20100707110613.18be4215@tele> <AANLkTim6xCtIMxZj3f4wpY6eZTrJBEv6uvVZZoiX-mg6@mail.gmail.com>
	<20100708121454.75db358c@tele>
From: Kyle Baker <kyleabaker@gmail.com>
Date: Thu, 8 Jul 2010 18:54:41 -0400
Message-ID: <AANLkTilw1KxYanoQZEZVaiFCLfkdTpO72Z9xV73i4gm2@mail.gmail.com>
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 8, 2010 at 6:14 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> Strange! Well, I put the change my test version. May you get this one
> from my web page and test it?

Okay, now I've exhausted the quick fixes that you've suggested and
have come to a new conclusion.

Without modifying the value in "gspca_dev->nbalt" the drivers will
report "bandwidth not wide enough - trying again". Modifying this
value to subtract between 1 and 8 seems to eliminate this bandwidth
error.

However, the results ultimately stay the same as before where there is
video and no audio for decreasing "gspca_dev->nbalt" from 0-5.

Video input stops working after decreasing by 6-8 while still breaking
the audio input, except for decreasing  by 8 where the video breaks
and audio remains...due to a "no transfer endpoint found" message.

My conclusion, reducing "gspca_dev->nbalt" by values 1-5 apparently
fix the bandwidth issue and don't alter the video input. However, they
also do not correct the issue where the microphone breaks and becomes
disabled.

Below is a log that I kept of each test, compiling the changes,
rebooting, testing and recording, then repeating for each decrement.

-------------------------------------

gspca_dev->nbalt -= 0; /* or same as no change */

	Initial startup (audio works)
		$ dmesg | grep "gspca"
		[   21.268018] gspca: main v2.9.0 registered
		[   21.268850] gspca-2.9.50: probing 045e:00f7
		[   21.285392] gspca-2.9.50: video0 created
		[   21.285395] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.285413] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.285419] gspca-2.9.50: 045e:00f7 bad interface 2

	Started Cheese (video works, no audio)
		$ dmesg | grep "gspca"
		[   21.268018] gspca: main v2.9.0 registered
		[   21.268850] gspca-2.9.50: probing 045e:00f7
		[   21.285392] gspca-2.9.50: video0 created
		[   21.285395] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.285413] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.285419] gspca-2.9.50: 045e:00f7 bad interface 2
		[  158.861671] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[  160.405694] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[  160.405698] gspca-2.9.50: bandwidth not wide enough - trying again
		[  160.434684] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[  175.635876] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100

gspca_dev->nbalt -= 1;

	Initial startup (audio works)
		$ dmesg | grep "gspca"
		[   21.905722] gspca: main v2.9.0 registered
		[   21.915236] gspca-2.9.50: probing 045e:00f7
		[   21.931505] gspca-2.9.50: video0 created
		[   21.931508] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.931528] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.931536] gspca-2.9.50: 045e:00f7 bad interface 2

	Started Cheese (video works, no audio)
		$ dmesg | grep "gspca"
		[   21.905722] gspca: main v2.9.0 registered
		[   21.915236] gspca-2.9.50: probing 045e:00f7
		[   21.931505] gspca-2.9.50: video0 created
		[   21.931508] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.931528] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.931536] gspca-2.9.50: 045e:00f7 bad interface 2
		[  188.170963] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[  188.170963] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100

gspca_dev->nbalt -= 2;

	Initial startup (audio works)
		$ dmesg | grep "gspca"
		[   22.463556] gspca: main v2.9.0 registered
		[   22.466506] gspca-2.9.50: probing 045e:00f7
		[   22.483436] gspca-2.9.50: video0 created
		[   22.483438] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   22.483458] gspca-2.9.50: 045e:00f7 bad interface 1
		[   22.483465] gspca-2.9.50: 045e:00f7 bad interface 2

	Started Cheese (video works, no audio)
		$ dmesg | grep "gspca"
		[   22.463556] gspca: main v2.9.0 registered
		[   22.466506] gspca-2.9.50: probing 045e:00f7
		[   22.483436] gspca-2.9.50: video0 created
		[   22.483438] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   22.483458] gspca-2.9.50: 045e:00f7 bad interface 1
		[   22.483465] gspca-2.9.50: 045e:00f7 bad interface 2
		[  139.718647] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[  147.487578] gspca-2.9.50: frame overflow 234239 > 233472
		[  158.147090] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100

gspca_dev->nbalt -= 3;

	Initial startup (audio works)
		$ dmesg | grep "gspca"
		[   21.295529] gspca: main v2.9.0 registered
		[   21.296266] gspca-2.9.50: probing 045e:00f7
		[   21.321505] gspca-2.9.50: video0 created
		[   21.321508] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.321528] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.321536] gspca-2.9.50: 045e:00f7 bad interface 2

	Started Cheese (video works, no audio)
		$ dmesg | grep "gspca"
		[   21.295529] gspca: main v2.9.0 registered
		[   21.296266] gspca-2.9.50: probing 045e:00f7
		[   21.321505] gspca-2.9.50: video0 created
		[   21.321508] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.321528] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.321536] gspca-2.9.50: 045e:00f7 bad interface 2
		[  130.140725] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[  138.444830] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100

gspca_dev->nbalt -= 4;

	Initial startup (audio works)
		$ dmesg | grep "gspca"
		[   21.775525] gspca: main v2.9.0 registered
		[   21.776456] gspca-2.9.50: probing 045e:00f7
		[   21.793435] gspca-2.9.50: video0 created
		[   21.793438] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.793455] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.793463] gspca-2.9.50: 045e:00f7 bad interface 2

	Started Cheese (video works, no audio)
		$ dmesg | grep "gspca"
		[   21.775525] gspca: main v2.9.0 registered
		[   21.776456] gspca-2.9.50: probing 045e:00f7
		[   21.793435] gspca-2.9.50: video0 created
		[   21.793438] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.793455] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.793463] gspca-2.9.50: 045e:00f7 bad interface 2
		[  102.566613] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[  107.669128] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100

gspca_dev->nbalt -= 5;

	Initial startup (audio works)
		$ dmesg | grep "gspca"
		[   21.150636] gspca: main v2.9.0 registered
		[   21.151538] gspca-2.9.50: probing 045e:00f7
		[   21.174690] gspca-2.9.50: video0 created
		[   21.174692] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.174710] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.174717] gspca-2.9.50: 045e:00f7 bad interface 2

	Started Cheese (video works, no audio)
		$ dmesg | grep "gspca"
		[   21.150636] gspca: main v2.9.0 registered
		[   21.151538] gspca-2.9.50: probing 045e:00f7
		[   21.174690] gspca-2.9.50: video0 created
		[   21.174692] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.174710] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.174717] gspca-2.9.50: 045e:00f7 bad interface 2
		[  103.857992] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[  108.318804] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100

gspca_dev->nbalt -= 6;

	Initial startup (audio works)
		$ dmesg | grep "gspca"
		[   21.719670] gspca: main v2.9.0 registered
		[   21.720735] gspca-2.9.50: probing 045e:00f7
		[   21.741407] gspca-2.9.50: video0 created
		[   21.741409] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.741425] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.741433] gspca-2.9.50: 045e:00f7 bad interface 2

	Started Cheese (no video, no audio)
		$ dmesg | grep "gspca"
		[   21.719670] gspca: main v2.9.0 registered
		[   21.720735] gspca-2.9.50: probing 045e:00f7
		[   21.741407] gspca-2.9.50: video0 created
		[   21.741409] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.741425] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.741433] gspca-2.9.50: 045e:00f7 bad interface 2
		[   86.749179] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   98.646330] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100

gspca_dev->nbalt -= 7;

	Initial startup (audio works)
		$ dmesg | grep "gspca"
		[   21.911549] gspca: main v2.9.0 registered
		[   21.912648] gspca-2.9.50: probing 045e:00f7
		[   21.934429] gspca-2.9.50: video0 created
		[   21.934431] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.934452] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.934460] gspca-2.9.50: 045e:00f7 bad interface 2

	Started Cheese (no video, no audio)
		$ dmesg | grep "gspca"
		[   21.911549] gspca: main v2.9.0 registered
		[   21.912648] gspca-2.9.50: probing 045e:00f7
		[   21.934429] gspca-2.9.50: video0 created
		[   21.934431] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.934452] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.934460] gspca-2.9.50: 045e:00f7 bad interface 2
		[  108.513126] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[  121.592828] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100

gspca_dev->nbalt -= 8;

	Initial startup (audio works)
		$ dmesg | grep "gspca"
		[   21.215610] gspca: main v2.9.0 registered
		[   21.217198] gspca-2.9.50: probing 045e:00f7
		[   21.233435] gspca-2.9.50: video0 created
		[   21.233437] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.233459] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.233467] gspca-2.9.50: 045e:00f7 bad interface 2

	Started Cheese (no video, audio works)
		$ dmesg | grep "gspca"
		[   21.215610] gspca: main v2.9.0 registered
		[   21.217198] gspca-2.9.50: probing 045e:00f7
		[   21.233435] gspca-2.9.50: video0 created
		[   21.233437] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
		[   21.233459] gspca-2.9.50: 045e:00f7 bad interface 1
		[   21.233467] gspca-2.9.50: 045e:00f7 bad interface 2
		[   85.830434] gspca: no transfer endpoint found

-------------------------------------

The point of breaking the microphone appears to be at the same
instance that the second "found int in endpoint: 0x83, buffer_len=1,
interval=100" occurs. This is in the alloc_and_submit_int_urb()
function in gspca.c.

Is there any way that I can do a deeper trace on this to find what is
actually going wrong here?

Does this help at all?

Thanks.

-- 
Kyle Baker
