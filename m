Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:48168 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504Ab1CGBv7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Mar 2011 20:51:59 -0500
Subject: Re: [RFC/PATCH 1/2] v4l: videobuf2: Handle buf_queue errors
From: Andy Walls <awalls@md.metrocast.net>
To: Pawel Osciak <pawel@osciak.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	hverkuil@xs4all.nl
In-Reply-To: <AANLkTi=UKiPWRoDMj5aS1bAMOrnHOJ3Kiq-NyTQQpUjd@mail.gmail.com>
References: <1298830353-9797-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1298830353-9797-2-git-send-email-laurent.pinchart@ideasonboard.com>
	 <AANLkTimx+MBg4qPHzubOCrAe7vDsic8_ot99NOxOWDHD@mail.gmail.com>
	 <201103011154.19883.laurent.pinchart@ideasonboard.com>
	 <AANLkTi=UKiPWRoDMj5aS1bAMOrnHOJ3Kiq-NyTQQpUjd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Mar 2011 20:52:15 -0500
Message-ID: <1299462735.10239.85.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-03-06 at 15:20 -0800, Pawel Osciak wrote:
> Hi Laurent,
> 
> On Tue, Mar 1, 2011 at 02:54, Laurent Pinchart


> > I think a disconnection is pretty fatal. If the user unplugs the webcam,
> > there's not much that can be done anymore. Userspace needs to be woken up with
> > all buffers marked as erroneous, and the next QBUF call needs to return an
> > error without queuing any buffer. We need to define the expected behaviour in
> > the V4L2 spec, so that applications can rely on it and implement it properly.
> > I would also like to handle this inside videobuf2 if possible (something like
> > vb2_disconnect() ?) to ensure that all drivers behave correctly, but I'm not
> > sure if that will be possible without messing locking up.
> >
> 
> I definitely agree that videbuf2 should handle as much as possible and
> it shouldn't be left up to drivers. Although I'm not an expert in USB,
> shouldn't a disconnection event cause a removal of the device node?

Hi Pawel,

I would think it should cause the device node to be unlink()-ed from the
filesystem.

However, even though the device node has been unlink()-ed from the
filesystem, all the currently open file descriptors still exist and need
to be intelligently handled by the driver until they are closed.



> Could you explain how does that work for USB devices in general? If
> not, we may need a more general state in vb2, something like "device
> inoperable". Not only qbuf should fail then, but almost everything
> should. And memory should be freed. I feel there will be the locking
> problems as well.

The USB layer or cdev should take a reference on the driver module so it
can't be unloaded until all the open file descriptors are closed.

The driver itself (and maybe videobuf2?) will need to reference count
structures that must not be kfree()-ed if a file descriptor is still
open.
.


> I definitely agree that we need to add this to the V4L2 spec. So could
> we start from that point? Could we maybe start with a general flow and
> expected behavior for a disconnection event? I guess we both have some
> ideas in mind, but first I'd like to establish what will happen in
> linux driver/USB core when a device is disconnected.


>  My understanding
> is that the driver is removed and module is unloaded, but how does
> that happen if we are in the middle of something? Could you give an
> example of what happens after a disconnect a camera?

A module cannot be unloaded, as long as anything has a reference to the
module text using get_module().  If a file descriptor for the driver is
still open, something should be holding a reference to the driver module
text, so that it cannot be unloaded.

In the case of an underlying device being disconnected, the driver has
to do something sensible as long as file descriptors for that
disconnected device remain open.

In fixing up lirc_zilog, an IR device driver, I used locked reference
counters to get() and put() pointers to objetcs for the underlying
devices.  I then had to modify all the driver code to sensibly handle
the case when a get() of an object pointer to an underlying device came
back as NULL.

I suspect Laurent probably had to deal with similar issues already in
his changes for v4l2_subdev's.



Because it is all still fresh in my mind, what follow are (lengthy)
details about how lirc_zilog handles the problem with a disconnect of an
IR device.  Hopefully it provides something useful for you...

lirc_zilog can have the bridge driver (ivtv, cx18, pvrusb2, or hdpvr)
removed out from under it, or have the underlying USB device
disconnected (pvrusb2, hdpvr), while /dev/lircN device nodes are still
open.

Here is the sum of my rework to support that gracefully:

http://git.linuxtv.org/awalls/media_tree.git?a=blob;f=drivers/staging/lirc/lirc_zilog.c;h=40195ef55e6dcfb4b10c8ff132eb81d551a253a8;hb=8a1f6484fd16ef990d588cc3b979416b2dca23bd

It was more work than I expected.

Pointers to instances of the following items in that driver are
reference counted:

	struct IR	// a Z8 IR device instance
	struct IR_tx	// the Tx function instance of a Z8 instance
	struct IR_rx	// the Rx function instance of a Z8 instance

and the structres themselves maintain pointers to each other (which are
not exempt from the reference counting)

                +------------------------+
                v                        |
	struct IR <-------------------+  |
	      | |                     |  |
	      | +----> struct IR_rx --+  |
	      |	                         |
	      +------> struct IR_tx -----+


The pointers to object instances are handed out like this on device
probe; each reference given out is counted:

 a struct IR    pointer is given to the struct IR_rx instance
 a struct IR_rx pointer is given to the struct IR    instance
 a struct IR_rx pointer is given to the RX i2c_client instance

 a struct IR    pointer is given to the struct IR_tx instance
 a struct IR_tx pointer is given to the struct IR    instance
 a struct IR_tx pointer is given to the TX i2c_client instance

 a struct IR pointer is given to the Rx read polling kthread instance


During operation

 on open(),  a struct IR is given    to   the struct file instance
 on close(), a struct IR is returned from the struct file instance

 The lirc_zilog RX polling kthread instance takes and returns struct
	IR_tx pointers as needed.
 The lirc_zilog RX polling kthread instance takes and returns struct
	IR_rx pointers as needed.

 The lirc_zilog file operations, aside from open() and close(), take and
	return struct IR_tx pointers as needed.
 The lirc_zilog file operations, aside from open() and close(), take and
	return struct IR_rx pointers as needed.


Upon device unplug or bridge driver removal:

 a struct IR_rx pointer is returned from the RX i2c_client instance
 a struct IR_tx pointer is returned from the TX i2c_client instance

Upon returning the last pointer to a particular struct IR_tx instance:

 the IR_tx pointer in its parent struct IR instance is set to NULL
 the struct IR_tx instance is kfree()-ed
 the struct IR reference held by that IR_tx is returned	

Upon returning the last pointer to a particular struct IR_rx instance:

 the IR_rx pointer in its parent struct IR instance is set to NULL
 the lirc_zilog Rx polling kthread instance is destroyed
 the struct IR reference held by the polling kthread is returned
 the struct IR_rx instance is kfree()-ed
 a wakeup is performed on the read wait_queue for the poll() fileop
 the struct IR reference held by that IR_rx is returned 

Upon returning the last pointer to a particular struct IR instance:

 the IR unit is unregistered from lirc_dev
 the struct IR instance is removed from lirc_zilog's list of devices
 the struct IR instance is kfree()-ed


Registering with the lirc_dev module prompts lirc_dev to take a
reference to the lirc_zilog module text, so it can't be unloaded.  

Unregistering with lirc_dev causes that reference to the lirc_zilog
module text to be returned.

I'm not sure if cdev will also take and return references to
lirc_zilog's module text on open() and close().

Note that a module cannot take a reference to it's own module text as
that is unreliable due to a race with possible unloading.


Regards,
Andy


