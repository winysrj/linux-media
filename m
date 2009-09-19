Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:29707 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbZISGsE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2009 02:48:04 -0400
Received: by ey-out-2122.google.com with SMTP id 4so252684eyf.5
        for <linux-media@vger.kernel.org>; Fri, 18 Sep 2009 23:48:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1e68a10b0908150515l217126f7j41e15ece329176e1@mail.gmail.com>
References: <1e68a10b0908150515l217126f7j41e15ece329176e1@mail.gmail.com>
Date: Sat, 19 Sep 2009 08:48:07 +0200
Message-ID: <1e68a10b0909182348v2026a57dsc877a8c5c1e9289f@mail.gmail.com>
Subject: Re: usb dvb-c tuner status
From: Bert Haverkamp <bert@bertenselena.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

A while back I asked about supported USB dvb-c devices.
Meanwhile my search continued and I have extended my list of available devices.
Unfortunately, none of them currently are supported by linux.

Does anyone have viable solution for me?

- Technotrend CT 1200 which is an old device, hard to get.
- Technotrend CT-3650 for which there is one report that dvb-c works
with a patch,(is this already in-tree?), but dvb-t and CI not
 - Sundtek MediaTV Pro for which a closed source driver exists. I
don't want to go that way.
 Terratec Cinergy Hybrid H5  which seems to be troubled with a driver
for a drx-k or drx-j chip.
- Pinnacle 340e, depends on the xc4000 chip, under development by Devin.
- Hauppauge WinTV HVR-930C, also drx-j based as far as I can see

Regards,

Bert
