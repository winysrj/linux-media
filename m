Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:17882 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3H0QAr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 12:00:47 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MS700LJR5SWX150@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Aug 2013 12:00:46 -0400 (EDT)
Date: Tue, 27 Aug 2013 13:00:41 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Frank =?UTF-8?B?U2No?= =?UTF-8?B?w6RmZXI=?=
	<fschaefer.oss@googlemail.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
Message-id: <20130827130041.15db82d5@samsung.com>
In-reply-to: <5182139.9PqyLJNP0L@avalon>
References: <520E76E7.30201@googlemail.com> <6237856.Ni2ROBVUfl@avalon>
 <20130827110858.01d88513@samsung.com> <5182139.9PqyLJNP0L@avalon>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Aug 2013 17:27:52 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Tuesday 27 August 2013 11:08:58 Mauro Carvalho Chehab wrote:
> > Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> > > On Monday 26 August 2013 11:09:33 Mauro Carvalho Chehab wrote:
> > > > Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:
> 

> > Ok, but the voltage and clock regulators are not mapped, on embedded
> > devices, as part of the USB or PCI bus bridge device (except, of course,
> > when the voltage/clocks are needed by the bridge device itself). It is
> > mapped elsewhere, at DT.
> 
> Or in a C code board file, depending on the platform. DT or board files are 
> more or less equivalent, both of them store information about the board. For 
> PCI and USB devices we need to store that information somewhere as well. As 
> the em28xx driver already stores board layout information in em28xx-cards.c, 
> we could store clock information there as well (I haven't checked whether 
> that's the best place to store that information in the driver). I don't see 
> why storing board-specific clock information ("there's a fixed-frequency clock 
> with this frequency and this name on the board") in the driver is a different 
> issue than storing other kind of board information in the em28xx_board 
> structure.

Yes, on PCI/USB drivers, we have a board specific setup. On em28xx, it is
at em28xx-cards.c.

Yet, there's no board-specific information in this case: em28xx doesn't
manage clocks. It is always on. No need to add a bit there at the boards
config file to initialize the clock before loading the subdevice, because
the clock is already there.

> The point is that the client driver knows that it needs a clock, and knows how 
> to use it (for instance it knows that it should turn the clock on at least 
> 100ms before sending the first I2C command). However, the client should not 
> know how the clock is provided. That's the clock API abstraction layer. The 
> client will request the clock and turn it on/off when it needs to, and if the 
> clock source is a crystal it will always be on. On platforms where the clock 
> can be controlled we will thus save power by disabling the clock when it's not 
> used, and on other platforms the clock will just always be on, without any 
> need to code this explictly in all client drivers.

On em28xx devices, power saving is done by enabling reset pin. On several
hardware, doing that internally disables the clock line. I'm not sure if
ov2640 supports this mode (Frank may know better how power saving is done
with those cameras). Other devices have an special pin for power off or
power saving.

Anyway, that rises an interesting question: on devices with wired clocks,
the power saving mode should not be provided via clock API abstraction
layer, but via a callback to the bridge (as the bridge knows the GPIO
register/bit that corresponds to device reset and/or power off pin).

> > So, the only sense on having a clock API is when the hardware allows some
> > control on it.
> > 
> > So, if the hardware can't be controlled and it is always on, it makes no
> > sense to register a clock.
> 
> Please also note that, even if the clock can't be controlled, the sensor might 
> need to query the clock frequency for instance to adjust its PLL parameters. 
> The clk_get_rate() call is used for such a purpose, and requires a clock 
> object.

Ok, this is a good point.

> > The thing is that you're wanting to use the clock register as a way to
> > detect that the device got initialized.
> 
> I'm not sure to follow you there, I don't think that's how I want to use the 
> clock. Could you please elaborate ?

As Sylwester pointed, the lack of clock register makes ov2640 to defer
probing, as it assumes that the sensor is not ready.

Cheers,
Mauro
