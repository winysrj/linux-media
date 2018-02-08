Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45219 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbeBHKrA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Feb 2018 05:47:00 -0500
Message-ID: <1518086816.4359.4.camel@pengutronix.de>
Subject: Re: [PATCH v8 0/7] TDA1997x HDMI video reciver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Tim Harvey <tharvey@gateworks.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date: Thu, 08 Feb 2018 11:46:56 +0100
In-Reply-To: <d188a172-fc00-eb46-c6f5-833a86475390@xs4all.nl>
References: <1517948874-21681-1-git-send-email-tharvey@gateworks.com>
         <c7771c44-a9ff-0207-38f6-28bcc06ccdee@xs4all.nl>
         <CAJ+vNU1oiM0Y0rO-DHi57nVOqnw60A7pn_1=h5b46-BrY7_p2Q@mail.gmail.com>
         <605fd4a8-43ab-c566-57b6-abb1c9f8f0f8@xs4all.nl>
         <7cf38465-7a79-5d81-a995-9acfbacf5023@xs4all.nl>
         <CAJ+vNU014FJZsb44YnidE3fFiqeB6o8A7kvGinJWu7=yq3_dhA@mail.gmail.com>
         <d188a172-fc00-eb46-c6f5-833a86475390@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-02-07 at 23:19 +0100, Hans Verkuil wrote:
> On 02/07/2018 11:05 PM, Tim Harvey wrote:
> > On Wed, Feb 7, 2018 at 1:09 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > On 02/07/18 09:22, Hans Verkuil wrote:
> > > > On 02/07/2018 12:29 AM, Tim Harvey wrote:
> > > > > Media Controller ioctls:
> > > > >                 fail: v4l2-test-media.cpp(141): ent.function ==
> > > > > MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN
> > > > 
> > > > Weird, this shouldn't happen. I'll look into this a bit more.
> > > 
> > > Can you run 'mc_nextgen_test -e -i' and post the output?
> > > 
> > > It's found in contrib/test.
> > > 
> > 
> > root@ventana:~# ./v4l-utils/contrib/test/mc_nextgen_test -e -i
> > Device: imx-media (driver imx-media)
> > Bus:
> > version: 0
> > number of entities: 24
> > number of interfaces: 24
> > number of pads: 48
> > number of links: 50
> > entity entity#1: 'unknown entity type' adv7180 2-0020, 1 pad(s), 1 source(s)
> > entity entity#3: 'unknown entity type' tda19971 2-0048, 1 pad(s), 1 source(s)
> > entity entity#5: 'unknown entity type' ipu1_vdic, 3 pad(s), 2 sink(s),
> > 1 source(s)
> > entity entity#9: 'unknown entity type' ipu2_vdic, 3 pad(s), 2 sink(s),
> > 1 source(s)
> > entity entity#13: 'unknown entity type' ipu1_ic_prp, 3 pad(s), 1
> > sink(s), 2 source(s)
> > entity entity#17: 'unknown entity type' ipu1_ic_prpenc, 2 pad(s), 1
> > sink(s), 1 source(s)
> > entity entity#20: 'V4L I/O' ipu1_ic_prpenc capture, 1 pad(s), 1 sink(s)
> > entity entity#26: 'unknown entity type' ipu1_ic_prpvf, 2 pad(s), 1
> > sink(s), 1 source(s)
> > entity entity#29: 'V4L I/O' ipu1_ic_prpvf capture, 1 pad(s), 1 sink(s)
> > entity entity#35: 'unknown entity type' ipu2_ic_prp, 3 pad(s), 1
> > sink(s), 2 source(s)
> > entity entity#39: 'unknown entity type' ipu2_ic_prpenc, 2 pad(s), 1
> > sink(s), 1 source(s)
> > entity entity#42: 'V4L I/O' ipu2_ic_prpenc capture, 1 pad(s), 1 sink(s)
> > entity entity#48: 'unknown entity type' ipu2_ic_prpvf, 2 pad(s), 1
> > sink(s), 1 source(s)
> > entity entity#51: 'V4L I/O' ipu2_ic_prpvf capture, 1 pad(s), 1 sink(s)
> > entity entity#57: 'unknown entity type' ipu1_csi0, 3 pad(s), 1
> > sink(s), 2 source(s)
> > entity entity#61: 'V4L I/O' ipu1_csi0 capture, 1 pad(s), 1 sink(s)
> > entity entity#67: 'unknown entity type' ipu1_csi1, 3 pad(s), 1
> > sink(s), 2 source(s)
> > entity entity#71: 'V4L I/O' ipu1_csi1 capture, 1 pad(s), 1 sink(s)
> > entity entity#77: 'unknown entity type' ipu2_csi0, 3 pad(s), 1
> > sink(s), 2 source(s)
> > entity entity#81: 'V4L I/O' ipu2_csi0 capture, 1 pad(s), 1 sink(s)
> > entity entity#87: 'unknown entity type' ipu2_csi1, 3 pad(s), 1
> > sink(s), 2 source(s)
> > entity entity#91: 'V4L I/O' ipu2_csi1 capture, 1 pad(s), 1 sink(s)
> > entity entity#97: 'unknown entity type' ipu1_csi0_mux, 3 pad(s), 2
> > sink(s), 1 source(s)
> > entity entity#101: 'unknown entity type' ipu2_csi1_mux, 3 pad(s), 2
> > sink(s), 1 source(s)
> 
> Yuck. So nobody in imx (and adv7180!) is setting a valid function.
> And I see the mc_nextgen_test.c doesn't know all the latest functions
> anyway.

That's probably because for most of the entities it's a bit unclear
which function should be assigned.

ipu[12]_csi[01]_mux are video multiplexers, so MEDIA_ENT_F_VID_MUX. I
thought those should already be set correctly in the video-mux driver.

ipu[12]_csi[01] are the interfaces to the outside parallel busses, but
they can also 'downscale' by skipping, skip frames and pack or expand
pixels from the bus into the internal FIFOs that lead to the next
element. These are not MEDIA_ENT_F_VID_IF_BRIDGE, are they?

ipu[12]_vdic are mainly deinterlacers, so a new function
MEDIA_ENT_F_PROC_VIDEO_DEINTERLACER ? These entities could also be used
as composers in a mem2mem scenario (MEDIA_ENT_F_PROC_VIDEO_COMPOSER ?),
but this is currently not supported.

ipu[12]_ic_prp is just a tee element that feeds both ipu[12]_ic_prpenc
and ipu[12]_ic_prpvf. These are both scalers and colorspace converters.
MEDIA_ENT_F_PROC_VIDEO_SCALER ?
MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV ?

"ipu[12]_csi[01] capture" are the DMA elements writing to memory, so
MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER ?

> That's what happens when you don't have compliance tests, nobody bothers
> to fill stuff like that in. Anyway, that explains the v4l2-compliance error
> you got (although I should improve the error to also mentioned the entity
> in question). In other words, it's not you, it's them :-)

regards
Philipp
