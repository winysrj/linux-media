Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35897 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3LOBRW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 20:17:22 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq4so762330wib.3
        for <linux-media@vger.kernel.org>; Sat, 14 Dec 2013 17:17:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52ACE809.1000406@gmail.com>
References: <1386969579.3914.13.camel@piranha.localdomain>
	<20131214092443.622b069d@samsung.com>
	<52ACE809.1000406@gmail.com>
Date: Sat, 14 Dec 2013 20:17:20 -0500
Message-ID: <CAGoCfiwxGU-j14oGDfvoYTA5WZUkQdM_3=80gfpWUjXVNN_nng@mail.gmail.com>
Subject: Re: stable regression: tda18271_read_regs: [1-0060|M] ERROR:
 i2c_transfer returned: -19
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Connor Behan <connor.behan@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Frederik Himpe <fhimpe@telenet.be>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> My basic problem is
>
> __tda18271_write_regs: [1-0060|M] ERROR: idx = 0x0, len = 39, i2c_transfer returned: -32
>
> where it attaches lgdt3305 before tda18271. Do you know a similar patch
> that could help me?

It's a totally different issue.  The problem with the US Exeter has to
do with the lgdt3305 wedging the I2C bus after initialization because
there's a timing window where you have to strobe the reset after chip
powerup.

I had a patch kicking around which fixed part of the issue, but it
didn't completely work because of the lgdt3305 having AGC enabled at
chip powerup (which interferes with analog tuning on the shared
tuner), and the internal v4l-dvb APIs don't provide any easy way to
reset the AGC from the analog side of the device.

In short, it's been a known issue for almost three years and nobody's
gotten around to fixing it, and it sees unlikely anyone with the
appropriate level of knowledge of the device will anytime soon.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
