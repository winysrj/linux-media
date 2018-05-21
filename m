Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:49118 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750859AbeEUFv7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 01:51:59 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Tim Harvey <tharvey@gateworks.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
References: <m37eobudmo.fsf@t19.piap.pl>
        <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com>
        <m3tvresqfw.fsf@t19.piap.pl>
        <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com>
        <m3fu2oswjh.fsf@t19.piap.pl>
        <CAJ+vNU3WxSPe9jHRnajU0CNurMS4vMVakh4W0vb197caQhKP7g@mail.gmail.com>
Date: Mon, 21 May 2018 07:51:56 +0200
In-Reply-To: <CAJ+vNU3WxSPe9jHRnajU0CNurMS4vMVakh4W0vb197caQhKP7g@mail.gmail.com>
        (Tim Harvey's message of "Fri, 18 May 2018 10:56:33 -0700")
Message-ID: <m3bmd9sghv.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tim,

Tim Harvey <tharvey@gateworks.com> writes:

> What version of kernel are you using and what specific board model do
> you have (full board model and/or serial number so I know if you've
> got an IMX6DL or an IMX6Q) and have you modified the device-tree? I
> tested the adv7180 a couple of months ago but I don't know if I hit
> your specific combination. I was using NTSC but if your not getting
> VSYNC then yes I would like to make sure the pinmux is correct for
> your situation.

At the moment I'm using 4.16.0 and this particular board IDs itself as
GW5304-D2, the CPU is i.MX6Q. I mostly use GW5300s and GW5400s (and
others in smaller numbers) and they work fine with Steve's older driver
(the one with a special ADV7180 module).

I'm using the official device tree (v4.16 in this case) with just the
LDB (LVDS display) portion removed.

I guess I can test it with a NTSC camera.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
