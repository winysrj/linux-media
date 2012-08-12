Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59226 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285Ab2HLAG4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 20:06:56 -0400
Subject: Re: boot slow down
From: Andy Walls <awalls@md.metrocast.net>
To: bjlockie@lockie.ca
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media Mailing List <linux-media@vger.kernel.org>
Date: Sat, 11 Aug 2012 20:06:44 -0400
In-Reply-To: <18c22f6605c5aefbab8a42c4c0d3eca2.squirrel@lockie.ca>
References: <501D4535.8080404@lockie.ca>
	 <f1bd5aea-00cd-4b3f-9562-d25153f8cef3@email.android.com>
	 <501DA203.7070800@lockie.ca>
	 <20120805212054.GA29636@valkosipuli.retiisi.org.uk>
	 <501F4A5B.1000608@lockie.ca>
	 <20120807112742.GB29636@valkosipuli.retiisi.org.uk>
	 <6ef5338940a90b4c8000594d546bf479.squirrel@lockie.ca>
	 <32d7859a-ceda-442d-be67-f4f682a6e3b9@email.android.com>
	 <48430fdf908e6481ae55103bd11b7cfe.squirrel@lockie.ca>
	 <50218BD8.8040207@lockie.ca>
	 <20120808082408.GE29636@valkosipuli.retiisi.org.uk>
	 <18c22f6605c5aefbab8a42c4c0d3eca2.squirrel@lockie.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1344730005.2468.36.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2012-08-08 at 13:18 -0400, bjlockie@lockie.ca wrote:
> How hard would it be to get an official kernel option not to load firmware

Submit a patch for the cx23885 driver to the list.  It could add a
module option so the user can specify not to load cx23885-av firmware
(and maybe CX23417 firmware too).  The new module option could be set on
your kernel commandline: cx23885.no_firmware_load=1

Honestly though such a patch problably won't fly.  The real solution,
that the cx23885 driver needs anyway, is to inhibit the load of all
firmware during the device probe by the kernel, and load them on the
first device open (like the ivtv and cx18 drivers do for analog).

There are at least 2 places in the PCI device probe routine of the
cx23885 driver, where firmware is requested.  Here is the call chain:

cx23885_initdev()
	cx23885_dev_setup()
		cx23885_card_setup()
			v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
				cx25840_load_fw()
					cx23885_initialize()
						cx25840_work_handler()
							cx25840_loadfw()
								request_firmware()						
		cx23885_417_register()
			cx23885_initialize_codec()
				cx23885_load_firmware()
					request_firmware()

The calls to 
	v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
and
	cx23885_417_register() (or cx23885_initialize_codec())

really need to be deferred to comply with new udev requirements for
driver behavior.

> OR be able to set the timeout?

That would probably be harder politically, even if the code were not
harder.  No driver is supposed to be loading firmware during its device
probes. Once userspace is up, /sys/class/firmware/timeout can be
manipulated very early, before any device would be requesting firmware. 

Regards,
Andy

