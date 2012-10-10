Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab2JJNpp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 09:45:45 -0400
Date: Wed, 10 Oct 2012 10:45:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
Message-ID: <20121010104522.53dabe5e@redhat.com>
In-Reply-To: <1744244.z7BseID5vc@avalon>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
	<201210051323.45571.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.1210081306240.12203@axis700.grange>
	<1744244.z7BseID5vc@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 10 Oct 2012 14:54 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> > Also, ideally OF-compatible (I2C) drivers should run with no platform
> > data, but soc-camera is using I2C device platform data intensively. To
> > avoid modifying the soc-camera core and all drivers, I also trigger on the
> > BUS_NOTIFY_BIND_DRIVER event and assign a reference to the dynamically
> > created platform data to the I2C device. Would we also want to do this for
> > all V4L2 bridge drivers? We could call this a "prepare" callback or
> > something similar...
> 
> If that's going to be an interim solution only I'm fine with keeping it in 
> soc-camera.

I'm far from being an OF expert, but why do we need to export I2C devices to
DT/OF? On my understanding, it is the bridge code that should be responsible
for detecting, binding and initializing the proper I2C devices. On several
cases, it is impossible or it would cause lots of ugly hacks if we ever try
to move away from platform data stuff, as only the bridge driver knows what
initialization is needed for an specific I2C driver.

To make things more complex, it is expected that most I2C drivers to be arch
independent, and they should be allowed to be used by a personal computer
or by an embedded device. 

Let me give 2 such examples:

	- ir-i2c-kbd driver supports lots of IR devices. Platform_data is needed
to specify what hardware will actually be used, and what should be the default
Remote Controller keymap;

	- Sensor drivers like ov2940 is needed by soc_camera and by other
webcam drivers like em28xx. The setup for em28xx should be completely different
than the one for soc_camera: the initial registers init sequence is different
for both. As several registers there aren't properly documented, there's no
easy way to parametrize the configuration.

So, for me, we should not expose the I2C devices directly on OF; it should,
instead, see just the bridge, and let the bridge to map the needed I2C devices
using the needed platform_data.

-- 
Regards,
Mauro
