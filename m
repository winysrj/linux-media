Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:60748 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbZDDW0t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2009 18:26:49 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
	model
From: Andy Walls <awalls@radix.net>
To: Mike Isely <isely@pobox.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0904041059080.32720@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <20090404142837.3e12824c@hyperion.delvare>
	 <1238852529.2845.34.camel@morgan.walls.org>
	 <Pine.LNX.4.64.0904041059080.32720@cnc.isely.net>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 18:24:15 -0400
Message-Id: <1238883855.2995.30.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-04-04 at 11:05 -0500, Mike Isely wrote:
> On Sat, 4 Apr 2009, Andy Walls wrote:
> 
>    [...]
> 
> > 
> > I have an I2C related question.  If the cx18 or ivtv driver autoloads
> > "ir-kbd-i2c" and registers an I2C client on the bus, does that preclude
> > lirc_i2c, lirc_pvr150 or lirc_zilog from using the device?  LIRC users
> > may notice, if it does.
> > 
> > If that is the case, then we probably shouldn't autoload the ir-kbd
> > module after the CX23418 i2c adapters are initialized.  
> > 
> > I'm not sure what's the best solution:
> > 
> > 1. A module option to the cx18 driver to tell it to call
> > init_cx18_i2c_ir() from cx18_probe() or not? (Easiest solution)
> > 
> > 2. Some involved programmatic way for IR device modules to query bridge
> > drivers about what IR devices they may have, and on which I2C bus, and
> > at what addresses to probe, and whether a driver/module has already
> > claimed that device? (Gold plated solution)

I was thinking about this while mowing the lawn today....

The objectives seem to be:

1. Avoid auto probing
2. Leverage the bridge driver's knowledge of what should be available
3. Allow the user to dictate which kernel IR driver module be used with
the subordinate device.


So my rough outline of an idea (which probably runs slightly afoul of
Hans' media_controller device, but we don't have it yet):

1. Add a function to the v4l2 framework to iterate over all the
v4l2_device's that are registered (if there isn't one already).

2. Add a method to the v4l2_device class to return the IR subdevice for
a given v4l2_device:

	v4l2_subdev *v4l2_device_get_ir_subdev(v4l2_device *dev);

and if it returns NULL, that device has no IR chip.


3. To the v4l2_subdev framework add:

	struct v4l2_subdev_ir_ops {
		(*enumerate) (v4l2_subdev *sd, /* bus_type, bus #, addr for Rx, addr for Tx */);
		(*claim) (v4l2_subdev *sd, /* claiming driver name string, going-away callback function pointer */);
		(*release) (v4l2_subdev *sd, /* handle */);
		bool (*is_claimed) (v4l2_subdev *sd, /* output string of the "owner" */);
		/* Or maybe just */
		(*send) (v4l2_subdev *sd, /* data buffer */);
		(*receive) (v4l2_subdev *sd, /* data buffer */);
	}

and have the bridge driver support these.  (I also had some in mind for
the IR micro-controller debug/programming port, but the above will fit
the task at hand I think.)


OK so that's all a bit rough around the edges.  The idea is a uniform
call in for ir-kdb-i2c or lirc_foo or ir_foo to get at an IR chip behind
a bridge device, that the bridge device driver itself cares about very
little.  *Except* ir driver modules would be coordinated by the bridge
driver in what they can and cannot do to get at the IR device.  This
coordination prevents bad things on the bridge chip's I2C bus(es) or
from having modules racing to get the IR device.  That way whatever
module the user loads will get first shot at claiming the IR chip.  This
also provides a discovery mechanism four use by ir driver modules that
is informed by the bridge chip driver.  I think lirc_foo can also still
use it's current way of doing business too. 

It really just looks like a small subset of what Hans intended for the
media controller, so maybe this would be a good chance to get some
"lessons learned."

Regards,
Andy

> > Regards,
> > Andy
> 
> Ah, glad to see I'm not the only one concerned about this.
> 
> I suppose I could instead add a module option to the pvrusb2 driver to 
> control autoloading of ir-kbd (option 1).  It also should probably be a 
> per-device attribute, since AFAIK, ir-kbd only even works when using 
> older Hauppauge IR receivers (i.e. lirc_i2c - cases that would otherwise 
> use lirc_pvr150 or lirc_zilog I believe do not work with ir-kbd).  Some 
> devices handled by the pvrusb2 driver are not from Hauppauge.  Too bad 
> if this is the case, it was easier to let the user decide just by 
> choosing which actual module to load.

I think we can get there and still have the random probing reduced.

Regards,
Andy


>   -Mike


