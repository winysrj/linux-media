Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34208 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751925AbdJFNCz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 09:02:55 -0400
Date: Fri, 6 Oct 2017 16:02:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Tim Harvey <tharvey@gateworks.com>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: IMX CSI max pixel rate
Message-ID: <20171006130252.hhptwrddu36bmhvq@valkosipuli.retiisi.org.uk>
References: <CAJ+vNU1kx-mwBZZj=DrOX=Lq5+WuJS9gDj+N6rAaV+4XOW1zcA@mail.gmail.com>
 <20171006074909.gy24vp2xvsnrtmzl@valkosipuli.retiisi.org.uk>
 <1507284841.8440.4.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507284841.8440.4.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 06, 2017 at 12:14:01PM +0200, Philipp Zabel wrote:
> On Fri, 2017-10-06 at 10:49 +0300, Sakari Ailus wrote:
> > On Thu, Oct 05, 2017 at 10:21:16AM -0700, Tim Harvey wrote:
> > > Greetings,
> > > 
> > > I'm working on a HDMI receiver driver for the TDA1997x
> > > (https://lwn.net/Articles/734692/) and wanted to throw an error if
> > > the
> > > detected input resolution/vidout-output-bus-format exceeded the max
> > > pixel rate of the SoC capture bus the chip connects to (in my case
> > > is
> > > the IMX6 CSI which has a limit of 180MP/sec).
> 
> Where does this number come from? I see there are 180 MP/s advertised
> for burst mode still image capture (with up to 35% blanking overhead) in
> the i.MX6Q reference manual. For continuous still image capture, only
> 160 MP/s are advertised. The CSI really supports up to about 240 MHz
> pixel clock (assuming the IPU is clocked at 264 MHz), so MP/s for video
> really depends a lot on the blanking.
> 
> In the IPU display ports chapter, two different numbers are given for
> CSI-2 input, though: 200 MHz for 4 data lanes, and 250 MHz 2 data lanes.
> For 1-3 data lanes, the limiting factor is the maximum CSI-2 link
> frequency, at up to 500 MHz (1000 Mbps/lane).
> 
> > > Any recommendations on where a dt property should live, its naming,
> > > and location/naming and functions to validate the pixel rate or is
> > > there even any interest in this sort of check?
> > 
> > Why a DT property?
> > 
> > We do have V4L2_CID_PIXEL_RATE, would that be applicable for this?
> 
> Isn't this is meant to return the currently set pixel rate at the input
> of a single subdevice, not the total maximum pixel rate supported by its
> input?

Yes. Couldn't it be used for the purpose?

If the maximum rate supported is specific to a hardware component, it'd be
much better to handle that in drivers than put it to board file.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
