Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:58916 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3IHP2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Sep 2013 11:28:18 -0400
Date: Thu, 5 Sep 2013 15:32:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 0/3] V4L2: fix em28xx ov2640 support
In-Reply-To: <Pine.LNX.4.64.1309030821050.14776@axis700.grange>
Message-ID: <Pine.LNX.4.64.1309051526120.785@axis700.grange>
References: <1377696508-3190-1-git-send-email-g.liakhovetski@gmx.de>
 <5224DBB8.1010601@googlemail.com> <Pine.LNX.4.64.1309030821050.14776@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,

On Tue, 3 Sep 2013, Guennadi Liakhovetski wrote:

> Hi Frank
> 
> Thanks for testing! Let's have a look then:
> 
> On Mon, 2 Sep 2013, Frank Schäfer wrote:
> 
> > Am 28.08.2013 15:28, schrieb Guennadi Liakhovetski:
> > > This patch series adds a V4L2 clock support to em28xx with an ov2640 
> > > sensor. Only compile tested, might need fixing, please, test.
> > >
> > > Guennadi Liakhovetski (3):
> > >   V4L2: add v4l2-clock helpers to register and unregister a fixed-rate
> > >     clock
> > >   V4L2: add a v4l2-clk helper macro to produce an I2C device ID
> > >   V4L2: em28xx: register a V4L2 clock source
> > >
> > >  drivers/media/usb/em28xx/em28xx-camera.c |   41 ++++++++++++++++++++++-------
> > >  drivers/media/usb/em28xx/em28xx-cards.c  |    3 ++
> > >  drivers/media/usb/em28xx/em28xx.h        |    1 +
> > >  drivers/media/v4l2-core/v4l2-clk.c       |   39 ++++++++++++++++++++++++++++
> > >  include/media/v4l2-clk.h                 |   17 ++++++++++++
> > >  5 files changed, 91 insertions(+), 10 deletions(-)
> > >
> > 
> > Tested a few minutes ago:

[snip]

> > [  104.321167] ------------[ cut here ]------------
> > [  104.321216] WARNING: CPU: 0 PID: 517 at
> > drivers/media/v4l2-core/v4l2-clk.c:131 v4l2_clk_disable+0x83/0x90
> > [videodev]()
> > [  104.321221] Unbalanced v4l2_clk_disable() on 11-0030:mclk!
> 
> Ok, this is because em28xx_init_dev() calls
> 
> 	/* Save some power by putting tuner to sleep */
> 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
> 
> without turning the subdevice on before. Are those subdevices on by 
> default? In principle, this warning is harmless and it should still work 
> afterwards, but we should still clean this up - by either removing the 
> warning, or adding a power-on before a power-off in em28xx_init_dev(), or 
> somehow else. In fact, I think, this should indeed be done: 
> em28xx_card_setup() performs i2c accesses, right? So, we have to power up 
> the subdev before that.

Could you re-test with the .s_power() fixup patch I've sent several 
minutes ago?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
