Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:52825 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483AbZBDCdD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2009 21:33:03 -0500
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
From: Andy Walls <awalls@radix.net>
To: Adam Baker <linux@baker-net.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	kilgota@banach.math.auburn.edu, linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <200902032209.44133.linux@baker-net.org.uk>
References: <200901192322.33362.linux@baker-net.org.uk>
	 <alpine.LNX.2.00.0902031302060.1882@banach.math.auburn.edu>
	 <20090203202307.0ae074ec@free.fr>
	 <200902032209.44133.linux@baker-net.org.uk>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 21:33:28 -0500
Message-Id: <1233714808.3086.57.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-02-03 at 22:09 +0000, Adam Baker wrote:
> On Tuesday 03 February 2009, Jean-Francois Moine wrote:
> > Indeed, the problem is there! You must have only one process reading the
> > webcam! I do not see how this can work with these 2 processes...
> 
> Although 2 processes are created only one ever gets used. 
> create_singlethread_workqueue would therefore be less wasteful but make no 
> other difference. 

This is generally not the case.  There is a single workqueue as far as a
driver is concerned.  Work items submitted to the queue by the driver
are set to be processed by the same CPU submitting the work item (unless
you call queue_work_on() to specify the CPU).  However, there is no
guarantee that the same CPU will be submitting work requests to the
workqueue every time.

For most drivers this is a moot point though, because they only ever
instantiate and submit one work object ever per device.  This means the
workqueue depth never exceeds 1 for most drivers.  So the correct
statement would be, I believe, "only one sq905 worker thread ever gets
used (per device per capture) at a time in sq905.c"

(For the cx18 driver, where the workqueue can have up to 70 items queued
for all ongoing capture streams per device, it makes quite a difference
on whether a single thread or multiple threads process the work queue.
To preserve ordering of the work items, as needed for work orders for
moving video buffers from one place to another, a singlethreaded
workqueue had to be used.)


I did look at the patch as submitted on Jan 19, and do have what I
intend to be constructive criticisms (sorry if they're overcome by
events by now):

Creating and destroying the worker thread(s) at the start and stop of
each capture is a bit overkill.  It's akin to registering and
unregistering a device's interrupt handler before and after every
capture, but it's a bit worse overhead-wise.  It's probably better to
just instantiate the workqueue when the device "appears" (I'm not a USB
guy so insert appropraite term there) and destroy the workqueue and
worker threads(s) when the device is going to "disappear".  Or if it
will meet your performance requirements, create and destroy the
workqueue when you init and remove the module.  The workqueue and its
thread(s) are essentially the bottom half of your interrupt handler to
handle deferrable work - no point in killing them off until you really
don't need them anymore.

Also, you've created the workqueue threads with a non-unique name: the
expansion of MODULE_NAME.  You're basically saying that you only need
one workqueue, with it's per CPU thread(s), for all instantiations of an
sq905 device - which *can* be a valid design choice.  However, you're
bringing them up and tearing them down on a per capture basis.  That's a
problem that needs to be corrected if you intend to support multiple
sq905 devices on a single machine.  What happens when you attempt to
have two sq905 devices do simultaneous captures?  I don't know myself;
I've never tried to create 2 separate instantiations of a workqueue
object with the same name. 


Regards,
Andy

