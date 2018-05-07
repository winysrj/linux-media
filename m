Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36663 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752064AbeEGOXs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 10:23:48 -0400
Message-ID: <1525703026.6317.23.camel@pengutronix.de>
Subject: Re: [PATCH 0/2] media: imx: add capture support for RGB565_2X8 on
 parallel bus
From: Jan =?ISO-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: p.zabel@pengutronix.de
Date: Mon, 07 May 2018 16:23:46 +0200
In-Reply-To: <ed3906bf-9682-77c6-011a-31bd1b76be7f@gmail.com>
References: <20180503164120.9912-1-jlu@pengutronix.de>
         <ed3906bf-9682-77c6-011a-31bd1b76be7f@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

thanks for reviewing!

On Sat, 2018-05-05 at 15:22 -0700, Steve Longerbeam wrote:
> I reviewed this patch series, and while I don't have any
> objections to the code-level changes, but my question
> is more specifically about how the IPU/CSI deals with
> receiving RGB565 over a parallel bus.
> 
> My understanding was that if the CSI receives RGB565
> over a parallel 8-bit sensor bus, the CSI_SENS_DATA_FORMAT
> register field is programmed to RGB565, and the CSI outputs
> ARGB8888. Then IDMAC component packing can be setup to
> write pixels to memory as RGB565. Does that not work?

This was our first thought too. As far as we can see in our
experiments, that mode doesn't actually work for the parallel bus.
Philipp's interpretation is that this mode is only intended for use
with the MIPI-CSI2 input.

> Assuming that above does not work (and indeed parallel RGB565
> must be handled as pass-through), then I think support for capturing
> parallel RGB555 as pass-through should be added to this series as
> well.

I don't have a sensor which produces RGB555, so it wouldn't be able to
test it.

> Also what about RGB565 over a 16-bit parallel sensor bus? The
> reference manual hints that perhaps this could be treated as
> non-passthrough ("on the fly processing"), e.g. could be passed
> on to the IC pre-processor:
> 
>      16 bit RGB565
>          This is the only mode that allows on the fly processing of 16 bit data. In this mode the
>          CSI is programmed to receive 16 bit generic data. In this mode the interface is
>          restricted to be in "non-gated mode" and the CSI#_DATA_SOURCE bit has to be set
>          If the external device is 24bit - the user can connect a 16 bit sample of it (RGB565
>          format). The IPU has to be configured in the same way as the case of
>          CSI#_SENS_DATA_FORMAT=RGB565

I've not looked at this case, as I don't have a sensor with that format
either. :/

Thanks,
Jan
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
