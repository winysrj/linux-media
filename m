Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbaFLOZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 10:25:22 -0400
Date: Thu, 12 Jun 2014 07:25:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>, arm@kernel.org,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] staging: allow omap4iss to be modular
Message-ID: <20140612142515.GA7653@kroah.com>
References: <5192928.MkINji4uKU@wuerfel>
 <7948240.P51u2omQa4@wuerfel>
 <2046469.GckHavNRr1@avalon>
 <7460455.eZRbtzsNrd@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7460455.eZRbtzsNrd@wuerfel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 12, 2014 at 04:15:32PM +0200, Arnd Bergmann wrote:
> On Thursday 12 June 2014 16:12:17 Laurent Pinchart wrote:
> > > From 3a965f4fd5a6b3ef4a66aa4e7c916cfd34fd5706 Mon Sep 17 00:00:00 2001
> > > From: Arnd Bergmann <arnd@arndb.de>
> > > Date: Tue, 21 Jan 2014 09:32:43 +0100
> > > Subject: [PATCH] [media] staging: tighten omap4iss dependencies
> > > 
> > > The OMAP4 camera support depends on I2C and VIDEO_V4L2, both
> > > of which can be loadable modules. This causes build failures
> > > if we want the camera driver to be built-in.
> > > 
> > > This can be solved by turning the option into "tristate",
> > > which unfortunately causes another problem, because the
> > > driver incorrectly calls a platform-internal interface
> > > for omap4_ctrl_pad_readl/omap4_ctrl_pad_writel.
> > > 
> > > Instead, this patch just forbids the invalid configurations
> > > and ensures that the driver can only be built if all its
> > > dependencies are built-in.
> > > 
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Should I take this in my tree for v3.17 or would you like to fast-track it ?
> > 
> 
> I'd actually like to see it in 3.15 as a stable backport if possible,

It's not stable material, sorry.

> but definitely in 3.16. What is the normal path for staging/media
> but fix patches?

Through Mauro's tree.

greg k-h
