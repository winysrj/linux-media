Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45768 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab0GKCbU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 22:31:20 -0400
Received: by gye5 with SMTP id 5so2071076gye.19
        for <linux-media@vger.kernel.org>; Sat, 10 Jul 2010 19:31:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100710113616.1ed63ebc@tele>
References: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
	<20100707074431.66629934@tele> <AANLkTimxJi3qvIImwUDZCzWSCC3fEspjAyeXg9Qkneyo@mail.gmail.com>
	<20100707110613.18be4215@tele> <AANLkTim6xCtIMxZj3f4wpY6eZTrJBEv6uvVZZoiX-mg6@mail.gmail.com>
	<20100708121454.75db358c@tele> <AANLkTilw1KxYanoQZEZVaiFCLfkdTpO72Z9xV73i4gm2@mail.gmail.com>
	<20100709200312.755e8069@tele> <AANLkTikxIJxuQiV_7PqPA5C6ZU5XhhmmQ3hAbIwWsrPT@mail.gmail.com>
	<20100710113616.1ed63ebc@tele>
From: Kyle Baker <kyleabaker@gmail.com>
Date: Sat, 10 Jul 2010 22:30:58 -0400
Message-ID: <AANLkTikrKBpRSI6wVdMO3tSYPhm1CECFGeNiyJdzTa03@mail.gmail.com>
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 10, 2010 at 5:36 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> So, the GPIO register is the second one of the bridge. It is
> initialized at line 71 of sonixj.c. May you change it from 0x40 to 0x44?
> (see attached diff)

I've compiled the driver with this updated setting and it appears to
be the same. The microphone works initially, until video is loaded.

$ dmesg | grep "gspca"
[   22.141766] gspca: main v2.9.0 registered
[   22.163928] gspca-2.9.50: probing 045e:00f7
[   22.181869] gspca-2.9.50: video0 created
[   22.181872] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
[   22.181894] gspca-2.9.50: 045e:00f7 bad interface 1
[   22.181902] gspca-2.9.50: 045e:00f7 bad interface 2
[  544.774056] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100
[  546.318045] gspca-2.9.50: found int in endpoint: 0x83,
buffer_len=1, interval=100

Is this change from 0x40 to 0x44 intended to fix the "bad interface"
messages as well as the mic becoming disabled? Also, is a reboot after
installing these drivers and changes required? I'm only curious
because it takes so much longer to test changes.

Thanks.

-- 
Kyle Baker
