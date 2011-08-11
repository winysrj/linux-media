Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:41250 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab1HKHTN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 03:19:13 -0400
Date: Thu, 11 Aug 2011 10:19:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: adp1653 usage
Message-ID: <20110811071900.GC5926@valkosipuli.localdomain>
References: <1312974960.2183.15.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312974960.2183.15.camel@smile>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 10, 2011 at 02:16:00PM +0300, Andy Shevchenko wrote:
> Hello, Sakari.

Hi, Andy!

> I would like to understand how to use subdevice (like adp1653) in
> current v4l2 framework from user space.
> 
> My understanding is following.
> 
> Kernel has two drivers (simplified view):
> - camera device
> - flash device
> 
> Kernel initializes a camera driver from a platform specific setup code.
> The camera driver loads the subdevice drivers. Later I could access the
> subdevice driver parts via IOCTL(s) on /dev/videoX device node.
> 
> What I have missed.
> - if the subdevice creates device node /dev/v4l-subdevX, how the user
> space will know the X is corresponding to let say flash device?

The whole media device's entities (of which the flash in this case is one
of) can be enumerated. The device is called /dev/mediaX.

The Media controller API is defined here:

<URL:http://hverkuil.home.xs4all.nl/spec/media.html#media_common>

> - if there is no v4l-subdevX device node, when and how the kernel runs
> ->open() and ->close() methods of v4l2_subdev_internal_ops?

No-one. This is part of the user space interface.

Isp drivers are also free to use the adp1653 subdev directly, but in
embedded systems where such chips typically are used that seldom makes
sense.

A webcam driver could implement the same interface and provide it through a
video node.

-- 
Sakari Ailus
sakari.ailus@iki.fi
