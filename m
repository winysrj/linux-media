Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57049 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbbBWNzP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 08:55:15 -0500
Date: Mon, 23 Feb 2015 10:55:08 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Ricardo Ribalda <ricardo.ribalda@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-api@vger.kernel.org
Subject: Re: [PATCH 1/3] media: Fix ALSA and DVB representation at media
 controller API
Message-ID: <20150223105508.54c730fc@recife.lan>
In-Reply-To: <CAGoCfiwi0nj_9sYNzEFOp5BvedFe+HphJ2bVtx_bnBw3d-Bsyw@mail.gmail.com>
References: <cover.1422273497.git.mchehab@osg.samsung.com>
	<cb0517f150942a2d3657c1f2e55754061bfae2c4.1422273497.git.mchehab@osg.samsung.com>
	<54C63D16.3070607@xs4all.nl>
	<20150126113416.311fb376@recife.lan>
	<CAGoCfixoSxspEzpCB95BVPXBrZr2gpDVWHbaikESsuB1V=WM1g@mail.gmail.com>
	<20150126123129.2076b9f8@recife.lan>
	<CAGoCfiwi0nj_9sYNzEFOp5BvedFe+HphJ2bVtx_bnBw3d-Bsyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Jan 2015 09:41:41 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> > It is actually trivial to get the device nodes once you have the
> > major/minor. The media-ctl library does that for you. See:
> 
> No objection then.
> 
> On a related note, you would be very well served to consider testing
> your dvb changes with a device that has more than one DVB tuner (such
> as the hvr-2200/2250).  That will help you shake out any edge cases
> related to ensuring that the different DVB nodes appear in different
> groups.

Hi Devin,

I did some tests (and fixes) for WinTV Nova-TD, with has two adapters.

I saw two alternatives for it:

1) to create a media controller device for each adapter;
2) to create just one media controller.

I actually implemented (1), as, in the case of this device, AFAIKT, the
two devices are indepentent, e. g. it is not possible to, for example,
share the same tuner with two demods:

$ ls -la /dev/media?
crw-rw----. 1 root video 249, 0 Fev 23 10:02 /dev/media0
crw-rw----. 1 root video 249, 1 Fev 23 10:02 /dev/media1

The adapter 0 corresponds to /dev/media0, and the adapter 1
to /dev/media1:

$ media-ctl --print-dot -d /dev/media0
digraph board {
	rankdir=TB
	n00000001 [label="dvb-demux\n/dev/dvb/adapter0/demux0", shape=box, style=filled, fillcolor=yellow]
	n00000001 -> n00000002
	n00000002 [label="dvb-dvr\n/dev/dvb/adapter0/dvr0", shape=box, style=filled, fillcolor=yellow]
	n00000003 [label="dvb-net\n/dev/dvb/adapter0/net0", shape=box, style=filled, fillcolor=yellow]
	n00000004 [label="DiBcom 7000PC\n/dev/dvb/adapter0/frontend0", shape=box, style=filled, fillcolor=yellow]
	n00000004 -> n00000001
}

$ media-ctl --print-dot -d /dev/media1
digraph board {
	rankdir=TB
	n00000001 [label="dvb-demux\n/dev/dvb/adapter1/demux0", shape=box, style=filled, fillcolor=yellow]
	n00000001 -> n00000002
	n00000002 [label="dvb-dvr\n/dev/dvb/adapter1/dvr0", shape=box, style=filled, fillcolor=yellow]
	n00000003 [label="dvb-net\n/dev/dvb/adapter1/net0", shape=box, style=filled, fillcolor=yellow]
	n00000004 [label="DiBcom 7000PC\n/dev/dvb/adapter1/frontend0", shape=box, style=filled, fillcolor=yellow]
	n00000004 -> n00000001
}

On a more complex hardware where some components may be rewired
on a different way, however, using just one media controller
would be a better approach.

Comments?

Mauro
