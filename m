Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51343 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753051AbeDPNE2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 09:04:28 -0400
Message-ID: <1523883866.5918.10.camel@pengutronix.de>
Subject: Re: OV5640 with 12MHz xclk
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Samuel Bobrowicz <sam@elite-embedded.com>,
        linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@bootlin.com>
Date: Mon, 16 Apr 2018 15:04:26 +0200
In-Reply-To: <CAFwsNOEF0rK+SeHQ618Rnuj2ZWaGZG2WY4keWmavqG_agSi+dw@mail.gmail.com>
References: <CAFwsNOEF0rK+SeHQ618Rnuj2ZWaGZG2WY4keWmavqG_agSi+dw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2018-04-15 at 18:39 -0700, Samuel Bobrowicz wrote:
> Can anyone verify if the OV5640 driver works with input clocks other
> than the typical 24MHz? The driver suggests anything from 6MHz-24MHz
> is acceptable, but I am running into issues while bringing up a module
> that uses a 12MHz oscillator. I'd expect that different xclk's would
> necessitate different register settings for the various resolutions
> (PLL settings, PCLK width, etc.), however the driver does not seem to
> modify nearly enough based on the frequency of xclk.
> 
> Sam
> 

Have you seen Maxime's recent "media: ov5640: Misc cleanup and
improvements" series, especially patch 08/12 ("media: ov5640: Adjust the
clock based on the expected rate")? That seems to be something you'd
need.

regards
Philipp
