Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:43338 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756887AbdJJU3s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 16:29:48 -0400
Received: by mail-wm0-f54.google.com with SMTP id m72so17448064wmc.0
        for <linux-media@vger.kernel.org>; Tue, 10 Oct 2017 13:29:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1507284841.8440.4.camel@pengutronix.de>
References: <CAJ+vNU1kx-mwBZZj=DrOX=Lq5+WuJS9gDj+N6rAaV+4XOW1zcA@mail.gmail.com>
 <20171006074909.gy24vp2xvsnrtmzl@valkosipuli.retiisi.org.uk> <1507284841.8440.4.camel@pengutronix.de>
From: Tim Harvey <tharvey@gateworks.com>
Date: Tue, 10 Oct 2017 13:29:46 -0700
Message-ID: <CAJ+vNU22cG838Rm4d6UhzFy5FWqxyGGVRhkruKvYPQmfDe7Hfw@mail.gmail.com>
Subject: Re: IMX CSI max pixel rate
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 6, 2017 at 3:14 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
>
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

I got the number from the ref manual section 9.2.1.1 Camera ports which says:

The input rate supported by the camera port is as follows:
 - Peak: up to 240 MHz (values/sec)
 - Average (assuming 35% blanking overhead), for YUV 4:2:2
   - Pixel in one cycle (e.g. BT.1120): up to 180 MP/sec, e.g. 12M
pixels @ 15 fps
   - Pixel on two cycles (e.g. BT.656): up to 90 MP/sec, e.g. 6M
pixels @ 15 fps.
 - On-the-fly processing may be restricted to a lower input rate - see below.

I would agree that it appears 240MHz is the important limit here and
I'm not clear how they get 180/90 MP/sec from this assuming 35%
blanking - seems to me that should be 156MP/sec or 180MP/sec with 25%
blanking for single-cycle max.

The only place I've run into this is the 2-cycle BT656 case where
1080p@60 would exceed the input rate
(1920*1080*60fps*2cycles=248.8MHz).

Tim
