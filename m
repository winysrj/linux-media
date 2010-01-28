Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4182 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab0A1MAo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 07:00:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dmitri Belimov <d.belimov@gmail.com>
Subject: Re: saa7134 and =?iso-8859-1?q?=C3=8E=C2=BCPD61151_MPEG2?= coder
Date: Thu, 28 Jan 2010 13:00:25 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <20091007101142.3b83dbf2@glory.loctelecom.ru> <201001271214.01837.hverkuil@xs4all.nl> <20100128110941.47fda876@glory.loctelecom.ru>
In-Reply-To: <20100128110941.47fda876@glory.loctelecom.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001281300.25222.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 28 January 2010 03:09:41 Dmitri Belimov wrote:
> HIi Hans
> 
> > Hi Dmitri,
> > 
> > Just a quick note: the video4linux mailinglist is obsolete, just use
> > linux-media.
> 
> OK
> 
> > On Wednesday 27 January 2010 06:36:37 Dmitri Belimov wrote:
> > > Hi Hans.
> > > 
> > > I finished saa7134 part of SPI. Please review saa7134-spi.c and
> > > diff saa7134-core and etc. I wrote config of SPI to board
> > > structure. Use this config for register master and slave devices.
> > > 
> > > SPI other then I2C, do not need call request_module. Udev do it. 
> > > I spend 10 days for understanding :(  
> > 
> > I'm almost certain that spi works the same way as i2c and that means
> > that you must call request_module. Yes, udev will load it for you,
> > but that is a delayed load: i.e. the module may not be loaded when we
> > need it. The idea behind this is that usually i2c or spi modules are
> > standalone, but in the context of v4l such modules are required to be
> > present before the bridge can properly configure itself.
> > 
> > The easiest way to ensure the correct load sequence is to do a
> > request_module at the start.
> > 
> > Now, I haven't compiled this, but I think this will work:
> > 
> > struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
> >                struct spi_master *master, struct spi_board_info *info)
> > {
> > 	struct v4l2_subdev *sd = NULL;
> >         struct spi_device *spi;
> > 	
> > 	BUG_ON(!v4l2_dev);
> > 
> > 	if (module_name)
> >         	request_module(module_name);

There is one thing missing here: module_name should be passed in as argument
to v4l2_spi_new_subdev. Does this code actually compile? If so, then I suspect
module_name must be some global variable with some bogus value which causes
request_module to time out.

> [  240.476082]  [<f84c8f3b>] ? v4l2_spi_new_subdev_board+0x2e/0x35 [v4l2_common]
> [  240.476086]  [<f84c8fa6>] ? v4l2_spi_new_subdev+0x64/0x6c [v4l2_common]

Remove v4l2_spi_new_subdev_board. Just have a v4l2_spi_new_subdev as in my code.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
