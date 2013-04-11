Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:53812 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3DKT6z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 15:58:55 -0400
Message-ID: <516715FA.8000901@gmail.com>
Date: Thu, 11 Apr 2013 21:58:50 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v8 0/7] V4L2 clock and async patches and soc-camera example
References: <1365433538-15975-1-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1304111156400.23859@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1304111156400.23859@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 04/11/2013 11:59 AM, Guennadi Liakhovetski wrote:
> Hi all
>
> On Mon, 8 Apr 2013, Guennadi Liakhovetski wrote:
>
>> >  Mostly just a re-spin of v7 with minor modifications.
>> >
>> >  Guennadi Liakhovetski (7):
>> >     media: V4L2: add temporary clock helpers
>> >     media: V4L2: support asynchronous subdevice registration
>> >     media: soc-camera: switch I2C subdevice drivers to use v4l2-clk
>> >     soc-camera: add V4L2-async support
>> >     sh_mobile_ceu_camera: add asynchronous subdevice probing support
>> >     imx074: support asynchronous probing
>> >     ARM: shmobile: convert ap4evb to asynchronously register camera
>> >       subdevices
>
> So far there haven't been any comments to this, and Mauro asked to push
> all non-fixes to him by tomorrow. So, if at least the API is now ok, we
> could push this to 3.10, at least the core patches 1 and 2. Then during
> 3.10 we could look at porting individual drivers on top of this.

This patch series has significantly improved over time but I'm not sure
it is all ready to merge it at this moment. At least it doesn't make sense
to me to merge it without any users.

The purpose of an introduction of this whole asynchronous probing concept
was to add support for the device tree based systems. However there is no
patch in this series that would be adding device tree support to some V4L2
driver. That's a minor issue though I think.

A significant blocking point IMHO is that this API is bound to the circular
dependency issue between a sub-device and the host driver. I think we 
should
have at least some specific ideas on how to resolve it before pushing the
API upstream. Or are there any already ?

One of the ideas I had was to make a sub-device driver drop the reference
it has to the clock provider module (the host) as soon as it gets registered
to it. But it doesn't seem straightforward with the common clock API.

Other option is a sysfs attribute at a host driver that would allow to
release its sub-device(s). But it sounds a bit strange to me to require
userspace to touch some sysfs attributes before being able to remove some
modules.

Something probably needs to be changed at the high level design to avoid
this circular dependency.


Thanks,
Sylwester
