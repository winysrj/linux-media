Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f180.google.com ([209.85.221.180]:56787 "EHLO
	mail-qy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZD1Ba6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 21:30:58 -0400
Received: by qyk10 with SMTP id 10so539945qyk.33
        for <linux-media@vger.kernel.org>; Mon, 27 Apr 2009 18:30:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904271145270.4375@axis700.grange>
References: <Pine.LNX.4.64.0904241818130.8309@axis700.grange>
	 <Pine.LNX.4.64.0904241832120.8309@axis700.grange>
	 <f17812d70904261957m4ebb606axed8b0423ca81f2f6@mail.gmail.com>
	 <Pine.LNX.4.64.0904271145270.4375@axis700.grange>
Date: Tue, 28 Apr 2009 09:30:57 +0800
Message-ID: <f17812d70904271830w3c734eafs8edb57707e364c58@mail.gmail.com>
Subject: Re: [PATCH 3/8] ARM: convert pcm990 to the new platform-device
	soc-camera interface
From: Eric Miao <eric.y.miao@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 27, 2009 at 5:55 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Mon, 27 Apr 2009, Eric Miao wrote:
>
>> It looks to me the change to the platform code is to move the I2C board
>> info registration into 'struct soc_camera_link'. Are there any specific
>> reason to do so? I'm assuming the original code works equally well,
>> and lists all the i2c devices in a central place is straight forward.
>
> Yes, there are reasons. The first one is, that many i2c camera sensor
> chips switch on their I2C interface only when the camera interface master
> clock is running. Therefore you cannot even probe the chip before the host
> video part has been initialised. So if you load the sensor driver before
> the host camera driver you cannot probe. The current mainline framework
> makes the "first-stage" sensor probe a NOP, in it the sensor driver just
> registers itself with the soc-camera framework and returns success.

Yes, indeed. The driver has to be carefully written so that no actual I2C
access is made during probe, but this makes no sense.

One workaround to this is to separate the logic of clock enabling from
the camera controller and make a 'struct clk' for it. However, this sounds
to be tricky as well.

> And
> only when the soc-camera finds a match of a sensor and a host driver it
> requests the host to activate the interface (switch on the master clock)
> and then the second stage sensor probing is called, which now can actually
> read chip version registers etc. The second reason is that this is also
> how v4l2-subdev framework works - there your camera host driver (in our
> case soc-camera core) uses its internal knowledge about present I2C
> devices (in our case it uses platform devices with referenced there i2c
> board info) to register new I2C devices dynamically and load their
> drivers, at which point we have already switched the master clock on so
> the sensor driver can just probe the chip normally.
>

Sounds reasonable. I'm then OK with these 3 patches.
