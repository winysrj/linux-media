Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:61726 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbZDDWlv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2009 18:41:51 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
	model
From: Andy Walls <awalls@radix.net>
To: Mike Isely <isely@pobox.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <1238883855.2995.30.camel@morgan.walls.org>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <20090404142837.3e12824c@hyperion.delvare>
	 <1238852529.2845.34.camel@morgan.walls.org>
	 <Pine.LNX.4.64.0904041059080.32720@cnc.isely.net>
	 <1238883855.2995.30.camel@morgan.walls.org>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 18:39:11 -0400
Message-Id: <1238884751.2995.38.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-04-04 at 18:25 -0400, Andy Walls wrote:
> On Sat, 2009-04-04 at 11:05 -0500, Mike Isely wrote:

> So my rough outline of an idea (which probably runs slightly afoul of
> Hans' media_controller device, but we don't have it yet):
> 
> 1. Add a function to the v4l2 framework to iterate over all the
> v4l2_device's that are registered (if there isn't one already).
> 
> 2. Add a method to the v4l2_device class to return the IR subdevice for
> a given v4l2_device:
> 
> 	v4l2_subdev *v4l2_device_get_ir_subdev(v4l2_device *dev);
> 
> and if it returns NULL, that device has no IR chip.
> 
> 
> 3. To the v4l2_subdev framework add:
> 
> 	struct v4l2_subdev_ir_ops {
> 		(*enumerate) (v4l2_subdev *sd, /* bus_type, bus #, addr for Rx, addr for Tx */);
> 		(*claim) (v4l2_subdev *sd, /* claiming driver name string, going-away callback function pointer */);
> 		(*release) (v4l2_subdev *sd, /* handle */);
> 		bool (*is_claimed) (v4l2_subdev *sd, /* output string of the "owner" */);
> 		/* Or maybe just */
> 		(*send) (v4l2_subdev *sd, /* data buffer */);
> 		(*receive) (v4l2_subdev *sd, /* data buffer */);
> 	}
> 
> and have the bridge driver support these.  (I also had some in mind for
> the IR micro-controller debug/programming port, but the above will fit
> the task at hand I think.)
> 
> 
> OK so that's all a bit rough around the edges.  The idea is a uniform
> call in for ir-kdb-i2c or lirc_foo or ir_foo to get at an IR chip behind
> a bridge device, that the bridge device driver itself cares about very
> little.  *Except* ir driver modules would be coordinated by the bridge
> driver in what they can and cannot do to get at the IR device.  This
> coordination prevents bad things on the bridge chip's I2C bus(es) or
> from having modules racing to get the IR device.  That way whatever
> module the user loads will get first shot at claiming the IR chip.  This
> also provides a discovery mechanism four use by ir driver modules that
> is informed by the bridge chip driver.  I think lirc_foo can also still
> use it's current way of doing business too. 
> 
> It really just looks like a small subset of what Hans intended for the
> media controller, so maybe this would be a good chance to get some
> "lessons learned."

Oops.  That leaves DTV only devices with IR out in the cold, unless they
start to implement a v4l2_device and IR v4l2_subdev as well, or unless
they were never used with ir-kbd-i2c in the first place.

Regards,
Andy

