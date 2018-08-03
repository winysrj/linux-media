Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52860 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbeHCU3w (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 16:29:52 -0400
Date: Fri, 3 Aug 2018 15:32:15 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: linux-media@vger.kernel.org
Cc: m.felsch@pengutronix.de, Rob Herring <robh@kernel.org>,
        mchehab@kernel.org, mark.rutland@arm.com, p.zabel@pengutronix.de,
        afshin.nasser@gmail.com, javierm@redhat.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, hverkuil@xs4all.nl
Subject: [RFC] minute notes from DT bindings discussion on Aug, 2
Message-ID: <20180803153215.32473465@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

In 2016, we had lots of discussions among the top media developers with regards
to connectors and DT bindings. On that time, we didn't reach a final conclusion.

We recently received a patchset from Marco changing how tvp5150 driver
works, adding a new DT binding proposal:

	https://patchwork.linuxtv.org/patch/50648/

So, yesterday we did another round in order to try to reach some consensus
among the core developers. The goal of this RFC is to summarize the consensus
we reached, asking the community to provide us feedback, in order for us to
improve the subsystem support for connectors.

The entire discussion can be seen at:
	https://linuxtv.org/irc/irclogger_log/media-maint?date=2018-08-02,Thu

Exceptionally, this time we did the discussions at the media maintainer's
channel, because #v4l was to noisy with lots of spam being flooded there.

Thanks,
Mauro

1. Description of the problem
=============================

In 2015, we had the first media controller workshop and we added support
for new stuff at the media controller side. One of the points agreed there
is that connectors should be represented at the media graph.

In 2016, we had several discussions about how to properly represent
connectors, like, for example:

	- https://linuxtv.org/irc/irclogger_log/v4l?date=2016-02-26,Fri
	- https://linuxtv.org/irc/irclogger_log/v4l?date=2016-03-03,Thu

On that time, the consensus was that connectors should be describing
the logical connections, as physically sometimes a single connector
(like SCART) can bring several different signals inside, each being
routed to a different entity or pad.

However, we didn't finish the discussions. On today's meeting, we
came with the challenge of answering two questions:

(a) should a physical connector that internally comes with two separate
electric signals (like S-Video) be mapped as a single connector?

(b) what would be the proper way to describe a device like tvp5150, with
has internally a MUX that selects between 3 different possible
physical connectors (composite 0, composite 1, s-video), mapping
them into 2 electrical pins (AIP1A and AIP1B) and the decoder itself
can handle just one signal, e. g., physically, the hardware is:

"physical"              pin input                     internal
connectors              terminals                     input port

comp 0 ------\
              + ------> AIP1A ----> \     +-----+
        +----/           pin         \--> |     |
	| luma                            |     |
s-video-+                                 | MUX +---> video decoder  
        | chroma                          |     |
        +-----\                      /--> |     |
               + -----> AIP1B ----> /     +-----+
comp 1 -------/          pin


So, depending on how the device is seemed, it could have 3, 2 or 1
media controller pads and 3, 2 or 1 Device tree ports.

2. Answers for the questions
============================


question (a): S-Video is a connector?
-------------_-----------------------

During the discussion, Hans came with a similar problem on a hardware
he works with (SX80 telepresence codec). This hardware has:

	- 3 HDMI inputs;
	- 1 DVI-I input;
	- 2 RCA inputs
	  (either two composite or combines to one S-Video);
	- 2 HDMI outputs;
	- 1 DVI-I output. 

The DVI-I mapping is also a challenge, as it can carry either an analog or
a digital signal (or both).

On this specific hardware, if one wants to use S-Video, it needs a
cable with one miniDin 4-pin in one side and 2 RCA pins at the other
side.

It was also discussed about the properties API, with would allow adding
labels to each connector.

It was a consensus that the best way to map S-Video is to be a single
connector.

So, on a hardware like SX80, for example, the properties API could carry
a description like:

	comp0:  -> "RCA Y Plug"
	comp1   -> "RCA C Plug"
	s-video -> "RCA Y+C Plugs" 

question (b): how many MC PADs and DT ports tvp5150 should have?
----------------------------------------------------------------

That was the warmer discussion, as we started with 3 different opinions:

- Mauro would map at the output of the mux, e. g. 1 pad/port;
- Marco proposed on his patchset to use (up to) 3 pad/ports,
  e. g. at the "physically" visible connectors[1];
- Laurent would map as 2, e. g. at the two physical pins at the tvp5150
  chip.

[1] That's actually not true physical connectors - as the connectors
    are device-specific. For example the device I'm using for tests
    is a Terratec Grabster AV-350. It have one SCART connector with
    both composite and S-Video signals, a S-Video port and 3 connectors
    for composite (video, audio R, audio L) and a mechanical switch
    (labeled Video/Scart) with selects between the SCART connector and
    the 4 other ones;

After some discussions, we reached a consensus that mapping it at
the tvp5150 chip pin level - e. g. two pads/ports (AIP1A and AIP1B)
is the best model, as it allows more flexibility in the case where
the chipset would allow switching s-video luma and croma electrical
signals among two separate input pins. Its is also the only way to
represent the chip's physical inputs.

One point that come to us is that, on such case, it could make
sense to map the connector itself as having 2 pads/ports.

We ended by agreeing that, for nowadays usage, just one pad/port
is enough for S-Video.

So, for a device like tvp-5150, the DT binding maps should be:

tvp-5150 port@0 (AIP1A)
	endpoint@0 -----------> Comp0-Con  port
	endpoint@1 -----+-----> Svideo-Con port
tvp-5150 port@1	(AIP1B) |
	endpoint@1 -----+
	endpoint@0 -----------> Comp1-Con  port
tvp-5150 port@2 
	endpoint (video bitstream output at YOUT[0-7] parallel bus) 

Yet, for more complex devices that would allow switching the
endpoints at the Svideo connector, the model would be:

device's port@0 input pin 1			
	endpoint@0 -----------> Comp0-Con   port
	endpoint@1 -----------> Svideo-Con  port@0 (luminance)
device's port@1 input pin 2
	endpoint@0 -----------> Comp1-Con   port
	endpoint@1 -----------> Svideo-Con  port@1 (chrominance)
device's port@2 bitstream output pin(s)
	endpoint

Comments?

Regards,
Mauro
