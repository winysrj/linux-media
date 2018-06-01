Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51901 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751342AbeFANwo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 09:52:44 -0400
Message-ID: <1527861161.5913.14.camel@pengutronix.de>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-media@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
Date: Fri, 01 Jun 2018 15:52:41 +0200
In-Reply-To: <dee0fb18-faf3-12b7-3014-d5b63a8b3e38@gmail.com>
References: <m37eobudmo.fsf@t19.piap.pl>
         <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com>
         <m3tvresqfw.fsf@t19.piap.pl>
         <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com>
         <m3fu2oswjh.fsf@t19.piap.pl> <m3603hsa4o.fsf@t19.piap.pl>
         <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
         <m3h8mxqc7t.fsf@t19.piap.pl>
         <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
         <1527229949.4938.1.camel@pengutronix.de>
         <dee0fb18-faf3-12b7-3014-d5b63a8b3e38@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-05-25 at 16:21 -0700, Steve Longerbeam wrote:
> Hi Philipp,
> 
> On 05/24/2018 11:32 PM, Philipp Zabel wrote:
> > On Thu, 2018-05-24 at 11:12 -0700, Steve Longerbeam wrote:
> > [...]
> > > > The following is required as well. Now the question is why we can't skip
> > > > writing those odd UV rows. Anyway, with these 2 changes, I get a stable
> > > > NTSC (and probably PAL) interlaced video stream.
> > > > 
> > > > The manual says: Reduce Double Read or Writes (RDRW):
> > > > This bit is relevant for YUV4:2:0 formats. For write channels:
> > > > U and V components are not written to odd rows.
> > > > 
> > > > How could it be so? With YUV420, are they normally written?
> > > 
> > > Well, given that this bit exists, and assuming I understand it correctly
> > > (1),
> > > I guess the U and V components for odd rows normally are placed on the
> > > AXI bus. Which is a total waste of bus bandwidth because in 4:2:0,
> > > the U and V components are the same for odd and even rows.
> > > 
> > > In other words for writing 4:2:0 to memory, this bit should _always_ be set.
> > > 
> > > (1) OTOH I don't really understand what this bit is trying to say.
> > > Whether this bit is set or not, the data in memory is correct
> > > for planar 4:2:0: y plane buffer followed by U plane of 1/4 size
> > > (decimated by 2 in width and height), followed by Y plane of 1/4
> > > size.
> > > 
> > > So I assume it is saying that the IPU normally places U/V components
> > > on the AXI bus for odd rows, that are identical to the even row values.
> > 
> > Whether they are identical depends on the input format.
> 
> Right, this is the part I was missing, thanks for clarifying. The
> even and odd chroma rows coming into the IDMAC from the
> CSI (or IC) may not be identical if the CSI has captured 4:4:4
> (or 4:2:2 yeah? 4:2:2 is only decimated in width not height).

Oh right, the MEDIA_BUS_FMT_YUYV variants are pretty common, they have
chroma for all the lines. Actually, that is my default test case (1080p
YUYV from TC358743), usually written to NV12 so it can be encoded.

> But still, when the IDMAC has finished pixel packing/unpacking and
> is writing 4:2:0 to memory, it should always skip overwriting the even
> rows with the odd rows, whether or not it has received identical chroma
> even/odd lines from the CSI.
> 
> Unless interweave is enabled :) See below.

Agreed.

regards
Philipp
