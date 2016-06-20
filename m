Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38859 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbcFTKQX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 06:16:23 -0400
Received: by mail-wm0-f52.google.com with SMTP id r201so54533121wme.1
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2016 03:16:09 -0700 (PDT)
Date: Mon, 20 Jun 2016 12:16:03 +0200
From: Gary Bisson <gary.bisson@boundarydevices.com>
To: Jack Mitchell <ml@embed.me.uk>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [19/38] ARM: dts: imx6-sabrelite: add video capture ports and
 connections
Message-ID: <20160620101603.GA817@t450s.lan>
References: <1465944574-15745-20-git-send-email-steve_longerbeam@mentor.com>
 <20160616083231.GA6548@t450s.lan>
 <20160617151814.GA16378@t450s.lan>
 <57644915.3010006@gmail.com>
 <20160620093351.GA24310@t450s.lan>
 <d9bd2b49-e36b-6082-e31a-99d6c8c70b2c@embed.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9bd2b49-e36b-6082-e31a-99d6c8c70b2c@embed.me.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jack, All,

On Mon, Jun 20, 2016 at 10:44:44AM +0100, Jack Mitchell wrote:
> <snip>
> > I've tried that patch have a some comments:
> > - When applied, no capture shows up any more, instead I have two m2m
> >   v4l2 devices [1].
> > - OV5640 Mipi is assigned the same address as OV5642, therefore both
> 
> Yes, I only have one device attached in my scenario.

Thanks for confirming.

> >   can't work at the same time right now. There's a register in the
> >   camera that allows to modify its I2C address, see this patch [2].
> > - How is the mclk working in this patch? It should be using the PWM3
> 
> As mentioned I have an eCon sensor board [1] which generates it's own clock
> on the board and as such I don't need the PWM signal, just the two GPIOs.

Oh ok, thanks I didn't this sensor board was different than ours [1].

But in your patch, you specifically disable pwm3, what's the reason for
it?

> >   output to generate a ~22MHz clock. I would expect the use of a
> >   pwm-clock node [3].
> > 
> > Also another remark on both OV5642 and OV5640 patches, is it recommended
> > to use 0x80000000 pin muxing value? This leaves it to the bootloader to
> 
> I also wondered about this, but didn't know if the pinmux driver did this
> based on the define name? I tried it both ways and it worked so I just left
> it as it was.

Actually my phrasing is wrong, the muxing is ok. Yes depending on the
name a pin will be muxed to one function or another. The problem is the
pad configuration (pull-up, pull-down etc..). I am not surprised that it
works, because the bootloader should properly set those. But it would be
safer IMO not to rely on it.

Regards,
Gary

[1] https://boundarydevices.com/product/nit6x_5mp_mipi/
