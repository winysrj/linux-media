Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21991 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab1HJLQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2011 07:16:26 -0400
Subject: adp1653 usage
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Aug 2011 14:16:00 +0300
Message-ID: <1312974960.2183.15.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Sakari.

I would like to understand how to use subdevice (like adp1653) in
current v4l2 framework from user space.

My understanding is following.

Kernel has two drivers (simplified view):
- camera device
- flash device

Kernel initializes a camera driver from a platform specific setup code.
The camera driver loads the subdevice drivers. Later I could access the
subdevice driver parts via IOCTL(s) on /dev/videoX device node.

What I have missed.
- if the subdevice creates device node /dev/v4l-subdevX, how the user
space will know the X is corresponding to let say flash device?
- if there is no v4l-subdevX device node, when and how the kernel runs
->open() and ->close() methods of v4l2_subdev_internal_ops?


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
