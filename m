Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:49203 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751153AbdFBPfr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Jun 2017 11:35:47 -0400
Message-ID: <1496417739.2358.36.camel@pengutronix.de>
Subject: Re: [PATCH 0/3] tc358743: minor driver fixes
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Date: Fri, 02 Jun 2017 17:35:39 +0200
In-Reply-To: <CAAoAYcNsbKH4Yv9nvvKhX3AGGNcKLUPBdnRzAGRPk+Ep4=pYjA@mail.gmail.com>
References: <cover.1496397071.git.dave.stevenson@raspberrypi.org>
         <4dd94754-2a3c-532c-f07c-88ac3765efcf@xs4all.nl>
         <CAAoAYcPWK1bLYSJDwM_Bp8szNkhXN38KRsx9j0xNWXwCH9qk3Q@mail.gmail.com>
         <99d7eba3-c5a8-ade3-54bc-18eb27ef0255@xs4all.nl>
         <1496412801.2358.15.camel@pengutronix.de>
         <CAAoAYcNsbKH4Yv9nvvKhX3AGGNcKLUPBdnRzAGRPk+Ep4=pYjA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

On Fri, 2017-06-02 at 15:36 +0100, Dave Stevenson wrote:
[...]
> >> > Are you aware of the HDMI modes that the TC358743 driver has been used with?
> >> > The comments mention 720P60 at 594MHz, but I have had to modify the
> >> > fifo_level value from 16 to 110 to get VGA60 or 576P50 to work. (The
> >> > value came out of Toshiba's spreadsheet for computing register
> >> > settings). It increases the delay by 2.96usecs at 720P60 on 2 lanes,
> >> > so not a huge change.
> >> > Is it worth going to the effort of dynamically computing the delay, or
> >> > is increasing the default acceptable?
> >>
> >> I see that the fifo_level value of 16 was supplied by Philipp Zabel, so
> >> I have CC-ed him as I am not sure where those values came from.
> >
> > I've just chosen a small delay that worked reliably. For 4-lane 1080p60
> > and for 2-lane 720p60 at 594 Mbps lane speed, the Toshiba spreadsheet
> > believes that it is ok to decrease the FIFO delay all the way down to 0
> > (it is not). I think it should be fine to delay transmission for a few
> > microseconds unconditionally, I'll test this next week.
> 
> Thanks Philipp. Were 1080p60 and 720p60 the only modes you were really testing?

Yes. Since 720p60 needs half the bandwidth of 1080p60, it was possible
to just use the 1080p60 timings by switching from 4 to 2 lanes.

> Did the 594Mbps lane speed come from a specific requirement somewhere?

It is what the spreadsheed suggests for 4-lane 1080p60, I assume because
it is nice and even to generate from the 27 MHz reference clock, and it
fits the 547.28 Mbps/lane requirement (for YCbCr 4:2:2 CSI output) with
a bit of headroom.

> The standard Pi only has 2 CSI2 lanes exposed, and 1080P30 RGB3 just
> tips over into needing 3 lanes with the current link frequency.
>  When I can find a bit more time I was thinking that an alternate link
> frequency would allow us to squeeze it in to 2 lanes. Obviously the
> timing values need to be checked carefully, but it should all work and
> allow support of multiple link frequencies.

See the FIXME comment in tc358743_probe_of, you could calculate and add
the correct pdata for the raised link-frequency.

> (My calcs say that 1080p50 UYVY can fit down 2 lanes, but that
> requires more extensive register mods).

With a lane rate of 911.25 Mbps or higher that should be possible, with
all the CSI timings are relaxed a bit.

regards
Philipp
