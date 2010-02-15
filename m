Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:44829 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445Ab0BOWRu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 17:17:50 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Nh9GG-0006j6-5t
	for linux-media@vger.kernel.org; Mon, 15 Feb 2010 23:17:48 +0100
Received: from 80-218-69-65.dclient.hispeed.ch ([80.218.69.65])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 23:17:48 +0100
Received: from auslands-kv by 80-218-69-65.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 23:17:48 +0100
To: linux-media@vger.kernel.org
From: Michael <auslands-kv@gmx.de>
Subject: Re: cx23885
Date: Mon, 15 Feb 2010 23:17:22 +0100
Message-ID: <hlch5h$ogp$1@ger.gmane.org>
References: <hlbe6t$kc4$1@ger.gmane.org> <1266238446.3075.13.camel@palomino.walls.org> <hlbhck$uh9$1@ger.gmane.org> <4B795D1A.9040502@kernellabs.com> <hlbopr$v7s$1@ger.gmane.org> <4B79803B.4070302@kernellabs.com> <hlcbhu$4s3$1@ger.gmane.org> <4B79B437.5000004@kernellabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now comes the best part:

I found a linux driver on the producers web page. And it is written by ... 
Steven Toth :-)

http://www.commell.com.tw/Product/Surveillance/MPX-885/mpx-885.rar

I am looking at the files to see what they have changed (if anything at 
all).

One thing I found pretty fast is that they added in cx23885-card.c:

[CX23885_BOARD_MPX885] = {
	    .name       = "MPX-885",
        .porta      = CX23885_ANALOG_VIDEO,
        .portb      = CX23885_MPEG_ENCODER,
        .portc      = CX23885_MPEG_DVB,
        .input          = {{
            .type   = CX23885_VMUX_COMPOSITE1,
            .vmux   = CX25840_VIN1_CH1,
            .gpio0  = 0,
        }, {
            .type   = CX23885_VMUX_COMPOSITE2,
            .vmux   = CX25840_VIN2_CH1,
            .gpio0  = 0,
        }, {
            .type   = CX23885_VMUX_COMPOSITE3,
            .vmux   = CX25840_VIN3_CH1,
            .gpio0  = 0,
        }, {
            .type   = CX23885_VMUX_COMPOSITE4,
            .vmux   = CX25840_VIN4_CH1,
            .gpio0  = 0,
        } }

Now, concerning the rest of the code, I'm afraid my knowledge is far below 
what is needed to understand just a little bit of it. I can try to compile 
the code, but they state it is for kernel 2.6.21, so I don't know whether it 
compiles for 2.6.31 (or newer).

I can try to make a diff, but I guess there will be lots of changes between 
this rather old code and an actual cx23885 version.

But maybe it is a start. What do you think?

Michael

Steven Toth wrote:

> 
>> Well if tvtime runs then mplayer will most probably, too. The question
>> is, what means "with some work" :-)
> 
> If you haven't worked on the cx23885 driver in the past, and you're not
> accustomed to developing tv/video drivers then you're going to struggle,
> massively.
> 
> Not that I'm trying to discourage, on the contrary, the more driver
> developers the better. In reality this isn't something you can fix with an
> evenings work.
> 
> However, if you would like to take a shot then look at the existing
> support for the HVR1800 board in the cx23885 tree. Specifically look at
> the raw video support in the cx23885-video.c file and you'll also want to
> investigate the cx25840 driver for configuring the A/V subsystem.
> 
> Feel free to submit patches.
> 
> Regards,
> 
> - Steve
> 


