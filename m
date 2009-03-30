Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3775 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbZC3Muq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 08:50:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Daniel =?iso-8859-1?q?Gl=F6ckner?= <dg@emlix.com>
Subject: Re: [patch 5/5] saa7121 driver for s6000 data port
Date: Mon, 30 Mar 2009 14:50:05 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Chris Zankel <chris@zankel.net>, linux-media@vger.kernel.org
References: <13003.62.70.2.252.1238080086.squirrel@webmail.xs4all.nl> <200903301203.02327.hverkuil@xs4all.nl> <49D0B71A.5080801@emlix.com>
In-Reply-To: <49D0B71A.5080801@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903301450.05240.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 30 March 2009 14:12:10 Daniel Glöckner wrote:
> On 03/30/2009 12:03 PM, Hans Verkuil wrote:
> > What exactly do you need? If there is something missing, then it should be 
> > added. But my guess is that you can pass such information via the s_routing 
> > callback. That's what all other drivers that use v4l2_subdev do.
> 
> The s_routing callback looks very limited. One can pass only two u32 values.

If a driver needs it, it can be extended. In particular I always thought that
a third config value would be useful.

> The parameters that have to be negotiated are:
> - What is the on-wire video format?

That might go to such a config value.

> - how many data lines are connected?

routing

> - synchronization using embedded SAV/EAV codes or using dedicated pins?

config value and/or routing.

> - polarity of sync lines?

config

> - valid CRC and line number in digital blanking?

Do you really need to control these?

> - what is the layout of the digital image?
> - how many odd lines are there? how many even? (including blanking)
> - how many horizontal pixels? (incl. blanking)
> - where is the active region?
> - on which pixels/lines do we start/end horizontal/vertical sync?

It's a PAL/NTSC encoder, so the standard specified with s_std_output will
map to the corresponding values that you need to put in. This is knowledge
that the i2c driver implements.

> 
> >> It seems the soc-camera framework is a better choice here, but to make it
> >> work with the saa7121 one would first have to implement support for video
> >> output.
> > 
> > This framework will also be converted to use v4l2_subdev for the 
> > communication with i2c drivers.
> 
> So it shouldn't matter which one I chose?

You will have to do the work anyway. Better to go with the new framework then
having to do the work twice.

> > Actually, I recommend that you first look at the existing saa7127.c source.
> > I don't know how many differences there are between the saa7121 and 
> > saa7127, but perhaps support for the saa7121 can be added there rather than 
> > introducing a new driver. Of course, that only works if the differences are 
> > not too big.
> 
> The chips appear to be very similar, sharing most of the registers. However, the
> aforementioned problem still exists with this driver. A driver connecting this
> sub device must know beforehand that it has to send standard BT.656 video frames
> with SAV/EAV codes.

So? If some future driver wants to do this differently, then we add the
necessary code to the i2c driver. It's not fixed in stone, you know :-)

Basically a driver only implements what can be tested. There is little point
in adding a full feature set for a device if you are unable to test the code
as well. So if a newer board appears in the future that needs to use
something new, then we add support for that to the i2c driver.

Looking at the datasheets I don't think you should make a new driver for
this. Unless something crops up that makes it hard to use saa7127.c I think
you should extend that driver to support saa7121 and add support for the
missing functionality. But only what is necessary for your setup.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
