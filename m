Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35542 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759175AbcAUOTX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2016 09:19:23 -0500
Received: by mail-lf0-f65.google.com with SMTP id c134so2372775lfb.2
        for <linux-media@vger.kernel.org>; Thu, 21 Jan 2016 06:19:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160119145224.GI10663@odux.rfo.atmel.com>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
	<20160119145224.GI10663@odux.rfo.atmel.com>
Date: Thu, 21 Jan 2016 22:19:22 +0800
Message-ID: <CAJe_HAfqQoT7fDTSdtOyt8vv5z8w8zjxH2TQ10kW1Pr7bzjQTw@mail.gmail.com>
Subject: Re: [PATCH 00/13] media: atmel-isi: extract the hw releated functions
 into structure
From: Josh Wu <rainyfeeling@gmail.com>
To: Josh Wu <rainyfeeling@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Songjun Wu <songjun.wu@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Ludovic

2016-01-19 22:52 GMT+08:00 Ludovic Desroches <ludovic.desroches@atmel.com>:
>
> Hi Josh,
>
> On Mon, Jan 18, 2016 at 08:21:36PM +0800, Josh Wu wrote:
> > This series refactor the atmel-isi drvier. In the meantime, extract all
> > the hardware related functions, and made it as function table. Also add
> > some hardware data.
> >
> > All those hardware functions, datas are defined with the compatible
> > string.
> >
> > In this way, it is easy to add another compatible string for new
> > hardware support.
>
> What is the goal of these patches? I mean is it to ease the support of
> ISC?


yes, I think these patches can make it easy to support ISC. As after
those patches, we can reuse the main framework, and just replace the
hardware operations to support ISC. (the patches are queued yet, I
would like to get some feedback before do such changes.)


>
>
> Discussing with Songjun, I understand that he wanted to have one driver
> for ISI and one for ISC but I have the feeling that your patches go in
> the opposite direction. What is your mind about this?


In my point of view, I prefer to use one driver to support both ISI
and ISC hardware. That would reduce many duplicated code. In the
meantime, using the different compatible string with different
hardware operation functions table can make ISC work well and also can
support further hardware IP.

What's your thought about this?

Best Regards,
Josh Wu

>
> Thanks
>
> Regards
>
> Ludovic
>
> >
> >
> > Josh Wu (13):
> >   atmel-isi: use try_or_set_fmt() for both set_fmt() and try_fmt()
> >   atmel-isi: move the is_support() close to try/set format function
> >   atmel-isi: add isi_hw_initialize() function to handle hw setup
> >   atmel-isi: move the cfg1 initialize to isi_hw_initialize()
> >   atmel-isi: add a function: isi_hw_wait_status() to check ISI_SR status
> >   atmel-isi: check ISI_SR's flags by polling instead of interrupt
> >   atmel-isi: move hw code into isi_hw_initialize()
> >   atmel-isi: remove the function set_dma_ctrl() as it just use once
> >   atmel-isi: add a function start_isi()
> >   atmel-isi: reuse start_dma() function in isi interrupt handler
> >   atmel-isi: add hw_uninitialize() in stop_streaming()
> >   atmel-isi: use union for the fbd (frame buffer descriptor)
> >   atmel-isi: use an hw_data structure according compatible string
> >
> >  drivers/media/platform/soc_camera/atmel-isi.c | 529 ++++++++++++++------------
> >  1 file changed, 277 insertions(+), 252 deletions(-)
> >
> > --
> > 1.9.1
> >
