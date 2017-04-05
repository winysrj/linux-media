Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40468
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755776AbdDEOx4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 10:53:56 -0400
Date: Wed, 5 Apr 2017 11:53:36 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        mchehab@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [RFC] [media] imx: assume MEDIA_ENT_F_ATV_DECODER entities
 output video on pad 1
Message-ID: <20170405115336.7135e542@vento.lan>
In-Reply-To: <1491384859.2381.51.camel@pengutronix.de>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
        <1490661656-10318-20-git-send-email-steve_longerbeam@mentor.com>
        <1490894749.2404.33.camel@pengutronix.de>
        <20170404231053.GE7909@n2100.armlinux.org.uk>
        <19f0ce92-cad6-8950-8018-e3224e2bf266@gmail.com>
        <7235285c-f39a-64bc-195a-11cfde9e67c5@gmail.com>
        <20170405082134.GF7909@n2100.armlinux.org.uk>
        <1491384859.2381.51.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 05 Apr 2017 11:34:19 +0200
Philipp Zabel <p.zabel@pengutronix.de> escreveu:

> On Wed, 2017-04-05 at 09:21 +0100, Russell King - ARM Linux wrote:
> [...]
> > > Actually what was I thinking, the TVP5150 is already an example of
> > > such a device.
> > > 
> > > All of this could be solved if there was some direction information
> > > in port nodes.  
> > 
> > I disagree.
> >
> > Philipp identified that the TVP5150 has four pads:
> > 
> > * Input pad
> > * Video output pad
> > * VBI output pad
> > * Audio output pad  
> 
> I didn't think hard enough about this earlier, but there are really only
> two hardware interfaces on TVP5150. The ADC input, which can be
> connected to either of two composite input pins (AIP1A, AIP1B), or use
> both for s-video, and the digital output connected to pins (YOUT[7:0]).
> 
> VBI data can be transferred via the output pins during horizontal or
> vertical blanking, if I understand correctly, or read from a FIFO via
> I2C.
> 
> There is no apparent support for audio data whatsoever, and the only
> mention of audio in the data manual is a vague reference about an "audio
> interface available on the TVP5150" providing a clock to an audio
> interface between an external audio decoder and the backend processor.
> 
> Further, commit 55606310e77f ("[media] tvp5150: create the expected
> number of pads") creates DEMOD_NUM_PADS pads, but doesn't mention or
> initialize the audio pad. It clearly expects the value of DEMOD_NUM_PADS
> to be 3. And indeed the fourth pad was added later in commit
> bddc418787cc ("[media] au0828: use standard demod pads struct").
> 
> So to me it looks like the VBI and audio pads should be removed from
> TVP5150.

There are a number of drivers that can work with different
types of TV demodulators. Typical examples of such hardware can be
found at em28xx, saa7134, cx88 drivers (among lots of other drivers).
Those drivers don't use the subdev API. Instead, they use a generic
helper function with sets the pipelines, based on the pad number.

The problem here is that, currently, both MC API and MC core
lacks a way to identify PAD ports per type, as the only information
that a bridge driver has is a pad number. So, in order for a
generic helper function to work, we had to hardcode pad numbers,
in a way that it would work for all possible types of demods.

It shouldn't be hard to add a "pad_type" information at media_pad
struct, but passing such info to userspace requires a new API
(we're calling it as "properties API"). Sakari was meant to send
us an updated RFC for it[1] with a patchset, back in 2015, but
this never happened.

[1] https://linuxtv.org/news.php?entry=2015-08-17.mchehab

Each vendor chooses the demod using some random criteria 
(usually, they use whatever costs less by the time they create a
hardware model). Newer versions of the same hardware frequently
has a different model.

For example, in the case of em28xx driver, there are currently
several types of demods supported there, like (among other options):

- demods with tda9887, with is actually part of a tuner that has 
  an outputs for IF luminance, IF chrominance and IF audio;

- demods with xc3028, with is an integrated tuner + audio demod,
  with outputs both video as a baseband signal and audio data via IF,
  (or outputs a single IF signal, for Digital TV);

- demods with both xc3028 and msp3400. The last one transforms
  audio IF into I2S;

- demods with saa711x (supported by saa7115 driver), with may or may 
  not have raw VBI and/or sliced VBI, depending on the specific model,
  with is detected during driver's probe.

The generic function should be robust enough to handle all above
cases.

Without a way to report the PAD type to userspace, applications
that need to setup or recognize such pipelines need to hardcode the
pad numbers on userspace. That's, by the way, one of the issues why
it is currently impossible to write a full generic MC plugin at libv4l:
there's currently no way for userspace to recognize what type of
signals each PAD input or output carries.

So, in short, the tvp5150 demod doesn't decode audio, but there
are other demods that do it.

In the case of VBI, tvp5150 has actually two ways of reporting
it:

1) via YOUT[7:0] pins. VBI information is transmitted as a
   set of raw samples, via an ancillary data block, during
   vertical/horizontal blanking intervals. So, yes, it shares
   the same hardware output, although the VBI contents are
   actually multiplexed there. Please notice that not all
   video out PADS encapsulate raw VBI the same way as tvp5150
   (and some devices even don't support raw VBI, like saa7110 and
   some models supported by saa7115 driver).

2) via an interrupt that indicates that it decoded VBI data. The
   VBI information itself is there on FIFO, accessible via a set of
   registers (see "VBI Data processor" chapter at the datasheet).

Currently, the driver doesn't support (2), because, at the time
I wrote the driver, I didn't find a way to read the interrupts generated
by tvp5150 at em28xx[1], due to the lack of em28xx documentation,
but adding support for it shoudn't be hard. I may eventually do it
when I have some time to play with my ISEE hardware.

So, in the case of tvp5150 hardware, have those PADS:

- Input baseband;
- Video + raw VBI output;
- sliced VBI output.

Yet, we need an always unconnected audio output, in order to support
different demods out there.

[1] tvp5150 was written to support some em28xx-based devices

> 
> > So, it has one input and three outputs.  How does marking the direction
> > in the port node (which would indicate that there was a data flow out of
> > TVP5150 into the iMX6 capture) help identify which of those pads should
> > be used?
> >
> > It would eliminate the input pad, but you still have three output pads
> > to choose from.
> > 
> > So no, your idea can't work.  
> 
> In this case, removal of the VBI and audio pads might make this work,
> but in general this is true. In my opinion, to make this truly generic,
> we need an interface to ask the driver which media entity pad a given
> device tree port corresponds to, as there might not even be a single
> media entity corresponding to all ports for more complex devices.

Yes. We also need something like that at the userspace API.

Thanks,
Mauro
