Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:33636 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283AbZB1XnD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2009 18:43:03 -0500
Subject: Re: Recommendation for good example i2c driver code
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "William M. Brack" <wbrack@mmm.com.hk>,
	Linux Media <linux-media@vger.kernel.org>
In-Reply-To: <200903010001.12081.hverkuil@xs4all.nl>
References: <be2acbfe1fc9d8501a1ec47397077168.squirrel@delightful.com.hk>
	 <200903010001.12081.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sat, 28 Feb 2009 18:43:16 -0500
Message-Id: <1235864596.3072.53.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-03-01 at 00:01 +0100, Hans Verkuil wrote:
> On Saturday 28 February 2009 23:18:54 William M. Brack wrote:
> > When writing a new driver, which existing driver would be a good model
> > to use for handing the i2c bus?
> 
> Hi Bill,
> 
> I recommend reading Documents/video4linux/v4l2-framework.txt. It's not clear 
> from your question whether you want an example driver for an i2c device, or 
> an example for how to use i2c devices in an PCI or USB driver.
> 
> A simple, but decent example source for the first would be wm8739.c and for 
> the second we have saa7134 or cx18.
> 
> It's a bit in flux at the moment since we are moving all drivers over to the 
> v4l2_device/v4l2_subdev structure, but some still use the old model.

Bill,

Your question also did not specify if this was a driver for an analog
(V4L2) or DTV (DVB) capture unit.  Hans' comments regarding
v4l2_device/v4l2_subdev currently only apply to analog capture units or
the analog side of hybrid capture units.  If you have a DTV-only capture
unit, the v4l2_device/v4l2_subdevice framework doesn't apply at present.

AFAICT, the saa7134 and cx18 drivers both have code to deal with hybrid
analog/DTV units.

Regards,
Andy

> Regards,
> 
> 	Hans


