Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34418 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756497AbdDPKwC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 06:52:02 -0400
Date: Sun, 16 Apr 2017 13:51:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Patrick Doyle <wpdster@gmail.com>, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se
Subject: Re: Looking for device driver advice
Message-ID: <20170416105121.GC7456@valkosipuli.retiisi.org.uk>
References: <CAF_dkJAwwj0mpOztkTNTrDC1YQkgh=HvZGh=tv3SYsuvUzTb+g@mail.gmail.com>
 <2ea495f2-022d-a9ee-11a0-28fbcba5db57@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ea495f2-022d-a9ee-11a0-28fbcba5db57@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Patrick,

On Wed, Apr 12, 2017 at 01:37:33PM +0200, Hans Verkuil wrote:
> Hi Patrick,
> 
> On 04/10/2017 10:13 PM, Patrick Doyle wrote:
> > I am looking for advice regarding the construction of a device driver
> > for a MIPI CSI2 imager (a Sony IMX241) that is connected to a
> > MIPI<->Parallel converter (Toshiba TC358748) wired into a parallel
> > interface on a Soc (a Microchip/Atmel SAMAD2x device.)
> > 
> > The Sony imager is controlled and configured via I2C, as is the
> > Toshiba converter.  I could write a single driver that configures both
> > devices and treats them as a single device that just happens to use 2
> > i2c addresses.  I could use the i2c_new_dummy() API to construct the
> > device abstraction for the second physical device at probe time for
> > the first physical device.
> > 
> > Or I could do something smarter (or at least different), specifying
> > the two devices independently via my device tree file, perhaps linking
> > them together via "port" nodes.  Currently, I use the "port" node
> > concept to link an i2c imager to the Image System Controller (isc)
> > node in the SAMA5 device.  Perhaps that generalizes to a chain of
> > nodes linked together... I don't know.
> 
> That would be the right solution. Unfortunately the atmel-isc.c driver
> (at least the version in the mainline kernel) only supports a single
> subdev device. At least, as far as I can see.

There have been multiple cases recently where the media pipeline can have
sub-devices controlled by more than two drivers. We need to have a common
approach on how we do handle such cases.

For instance, how is the entire DT graph parsed or when and how are the
device nodes created?

Parsing the graph should probably be initiated by the master driver but
instead implemented in the framework as it's a non-trivial task and common
to all such drivers. Another equestion is how do we best support this also
on existing drivers.

I actually have a small documentation patch on handling streaming control in
such cases as there are choices now to be made not thought about when the
sub-device ops were originally addeed. I'll cc you to that.

We do have a similar case currently in i.MX6, Nokia N9 (OMAP3) and on some
Renesas hardware unless I'm mistaken.

Cc Niklas.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
