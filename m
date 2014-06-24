Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:51716 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaFXDNB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 23:13:01 -0400
Received: by mail-ig0-f194.google.com with SMTP id c1so1111942igq.1
        for <linux-media@vger.kernel.org>; Mon, 23 Jun 2014 20:13:00 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 24 Jun 2014 00:13:00 -0300
Message-ID: <CAFpGhnP5LY5eOYGB9M3fsWBvXPY2XWj0pfcQy7hiUQYZZ09A1g@mail.gmail.com>
Subject: TV/RADIO tuner card
From: =?UTF-8?Q?Ariel_Arg=C3=BCello?= <arieleoar@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I request support for the number board of my SAA7130 (philips
semiconductor chipset) with fmradio card because it isn't listed in
the v4l2 driver list of Saa7134 module. The Tuner card is Winstars
WS-TVP7130FM.

the output of dmesg command is:

[   20.072044] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[   20.072349] saa7130[0]: found at 0000:02:02.0, rev: 1, irq: 23,
latency: 32, mmio: 0xf7effc00
[   20.072362] saa7134: Board is currently unknown. You might try to
use the card=<nr>
[   20.072362] saa7134: insmod option to specify which board do you
have, but this is
[   20.072362] saa7134: somewhat risky, as might damage your card. It
is better to ask
[   20.072362] saa7134: for support at linux-media@vger.kernel.org.
