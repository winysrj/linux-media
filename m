Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52343 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab1G2LQU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 07:16:20 -0400
Received: by gyh3 with SMTP id 3so2435824gyh.19
        for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 04:16:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E31526F.3060608@southpole.se>
References: <CAKdnbx5DQe+c1+ZD6tEJqgSfv6CRV18s2YGv=Z3cOT=wEOyF7g@mail.gmail.com>
 <4E31526F.3060608@southpole.se>
From: Eddi De Pieri <eddi@depieri.net>
Date: Fri, 29 Jul 2011 13:15:59 +0200
Message-ID: <CAKdnbx6O8JgMM37e28q1g9dt=AdJpAAjWHqxBnTXHZrcyBMKyQ@mail.gmail.com>
Subject: Re: Trying to support for HAUPPAUGE HVR-930C
To: linux-media@vger.kernel.org
Cc: Benjamin Larsson <benjamin@southpole.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/7/28 Benjamin Larsson <benjamin@southpole.se>:
> 0x82 is the address of the chip handling the analog signals(?) Micronas
> AVF 4910BA1 maybe.

I don't have the schematic of hauppauge card, so I can't say you if
082 is the AVF 4910

> So change the names so it is clear that this part
> sends commands to that chip.

As I already told my patch is a derivate work of Terratec H5 Patch.
Mauro's patch should have the same issue

> I'm not sure I understand the I2C addressing but my tuner is at 0xc2 and
> the demod at 0x52.

I hate binary operation however if you shift the address you should
get same value...
0x52 = 0x29 << 1
0x29 = 0x52 >> 1


Eddi
