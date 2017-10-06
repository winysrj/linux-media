Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:34163 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751663AbdJFKOF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 06:14:05 -0400
Message-ID: <1507284841.8440.4.camel@pengutronix.de>
Subject: Re: IMX CSI max pixel rate
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Tim Harvey <tharvey@gateworks.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Date: Fri, 06 Oct 2017 12:14:01 +0200
In-Reply-To: <20171006074909.gy24vp2xvsnrtmzl@valkosipuli.retiisi.org.uk>
References: <CAJ+vNU1kx-mwBZZj=DrOX=Lq5+WuJS9gDj+N6rAaV+4XOW1zcA@mail.gmail.com>
         <20171006074909.gy24vp2xvsnrtmzl@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-10-06 at 10:49 +0300, Sakari Ailus wrote:
> On Thu, Oct 05, 2017 at 10:21:16AM -0700, Tim Harvey wrote:
> > Greetings,
> > 
> > I'm working on a HDMI receiver driver for the TDA1997x
> > (https://lwn.net/Articles/734692/) and wanted to throw an error if
> > the
> > detected input resolution/vidout-output-bus-format exceeded the max
> > pixel rate of the SoC capture bus the chip connects to (in my case
> > is
> > the IMX6 CSI which has a limit of 180MP/sec).

Where does this number come from? I see there are 180 MP/s advertised
for burst mode still image capture (with up to 35% blanking overhead) in
the i.MX6Q reference manual. For continuous still image capture, only
160 MP/s are advertised. The CSI really supports up to about 240 MHz
pixel clock (assuming the IPU is clocked at 264 MHz), so MP/s for video
really depends a lot on the blanking.

In the IPU display ports chapter, two different numbers are given for
CSI-2 input, though: 200 MHz for 4 data lanes, and 250 MHz 2 data lanes.
For 1-3 data lanes, the limiting factor is the maximum CSI-2 link
frequency, at up to 500 MHz (1000 Mbps/lane).

> > Any recommendations on where a dt property should live, its naming,
> > and location/naming and functions to validate the pixel rate or is
> > there even any interest in this sort of check?
> 
> Why a DT property?
> 
> We do have V4L2_CID_PIXEL_RATE, would that be applicable for this?

Isn't this is meant to return the currently set pixel rate at the input
of a single subdevice, not the total maximum pixel rate supported by its
input?

regards
Philipp
