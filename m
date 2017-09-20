Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59411 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751887AbdITMgb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 08:36:31 -0400
Message-ID: <1505910982.7865.10.camel@pengutronix.de>
Subject: Re: [PATCH 2/3] [media] tc358743: Increase FIFO level to 300.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hansverk@cisco.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Wed, 20 Sep 2017 14:36:22 +0200
In-Reply-To: <f4824a16-13ce-7d49-c7dd-19a11f3c01ec@cisco.com>
References: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
         <3e638375aff788b24f988e452214649d6100a596.1505826082.git.dave.stevenson@raspberrypi.org>
         <1505834685.10076.5.camel@pengutronix.de>
         <20170919134930.6fa28562@recife.lan>
         <CAAoAYcNCPrpZWvxTTsCtGd4vobsQKDw-ckLhXyRst0dS++h_Ag@mail.gmail.com>
         <1505903026.7865.6.camel@pengutronix.de>
         <CAAoAYcN+KGSNNvF2SZVg=HnS5DC8pR26S+=ofwbaeJim5tsQaA@mail.gmail.com>
         <f4824a16-13ce-7d49-c7dd-19a11f3c01ec@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-09-20 at 13:24 +0200, Hans Verkuil wrote:
> On 09/20/17 13:00, Dave Stevenson wrote:
[...]
> > It is communicated over the subdevice API - tc358743_g_mbus_config
> > reports back the appropriate number of lanes to the receiver
> > subdevice.
> > A suitable v4l2_subdev_has_op(dev->sensor, video, g_mbus_config) call
> > as you're starting streaming therefore gives you the correct
> > information. That's what I've just done for the BCM283x Unicam
> > driver[1], but admittedly I'm not using the media controller API which
> > i.MX6 is.
> 
> Shouldn't this information come from the device tree? The g_mbus_config
> op is close to being deprecated or even removed. There are currently only
> two obscure V4L2 bridge drivers that call it. It dates from pre-DT times
> I rather not see it used in a new bridge driver.
> 
> The problem is that contains data that belongs to the DT (hardware
> capabilities). Things that can actually change dynamically should be
> communicated via another op. We don't have that, so that should be
> created.
> 
> I've CC-ed Sakari, he is the specialist for such things.

The total number of MIPI CSI-2 lanes (as well as their order) and the
list of allowed link frequencies are static and come from the device
tree.

But the possible combinations of link frequency and number of active
lanes out of those for a given resolution and format can vary depending
on both transmitter and receiver capabilities.

For example, if the DT specifies 4 lanes and both 148.5 MHz and 297 MHz
link frequencies, the Toshiba chip could send 720p60 YUYV via 4 lanes at
148.5 MHz, via 2 lanes at 297 MHz, or even via 4 lanes at 297 MHz, with
the longer FIFO delay.

> > 
> > [1] http://www.spinics.net/lists/linux-media/msg121813.html, as part
> > of the unicam_start_streaming function.
> > 
> > > The i.MX6 MIPI CSI-2 receiver driver can't cope with that, as it always
> > > activates all four lanes that are configured in the device tree. I can
> > > work around that with the following patch:
> > 
> > It can't cope running at less than 4 lanes, or it can't cope with a
> > change?

The hardware can cope with both, although I don't know if there are
receivers that can not.
In my case this is just about not knowing how many lanes to activate
(see below) and which link frequency to choose (currently fixed to the
first).

[...]
> > > [...] 300 is giving a fair safety margin.
> > > 
> > > It does not work for 720p60 on 4 lanes at 594 Mbit/s, as the spreadsheet
> > > warns, and testing shows.
> > 
> > If it doesn't work with 720p60, then I guess it has no hope with many
> > other resolutions.

That would have to be checked on a case by case basis, unfortunately.
I have a usecase that only supports 1080p50/60 and 720p50/60.

> > It sounds like confirming whether g_mbus_config is a potential
> > solution for i.MX6 (sorry I'm not familiar enough with that code to do
> > my own quick search), but otherwise cranking it up to 320 is
> > reasonable, and I'll see what other numbers fall out of the
> > spreadsheet.

It seems we need a replacement for g_mbus_config that only returns the
dynamic parameters.

regards
Philipp
