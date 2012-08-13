Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab2HMMZ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 08:25:28 -0400
Message-ID: <5028F22A.4040504@redhat.com>
Date: Mon, 13 Aug 2012 09:25:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: bjlockie@lockie.ca, Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: boot slow down
References: <501D4535.8080404@lockie.ca>  <f1bd5aea-00cd-4b3f-9562-d25153f8cef3@email.android.com>  <501DA203.7070800@lockie.ca>  <20120805212054.GA29636@valkosipuli.retiisi.org.uk>  <501F4A5B.1000608@lockie.ca>  <20120807112742.GB29636@valkosipuli.retiisi.org.uk>  <6ef5338940a90b4c8000594d546bf479.squirrel@lockie.ca>  <32d7859a-ceda-442d-be67-f4f682a6e3b9@email.android.com>  <48430fdf908e6481ae55103bd11b7cfe.squirrel@lockie.ca>  <50218BD8.8040207@lockie.ca>  <20120808082408.GE29636@valkosipuli.retiisi.org.uk>  <18c22f6605c5aefbab8a42c4c0d3eca2.squirrel@lockie.ca> <1344730005.2468.36.camel@palomino.walls.org>
In-Reply-To: <1344730005.2468.36.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Em 11-08-2012 21:06, Andy Walls escreveu:
> On Wed, 2012-08-08 at 13:18 -0400, bjlockie@lockie.ca wrote:
>> How hard would it be to get an official kernel option not to load firmware
> 
> Submit a patch for the cx23885 driver to the list.  It could add a
> module option so the user can specify not to load cx23885-av firmware
> (and maybe CX23417 firmware too).  The new module option could be set on
> your kernel commandline: cx23885.no_firmware_load=1

No, adding a parameter there is not right: it is not an user option to not
do firmware load during module init; it is a requirement for a driver to
work with newer userspace tools.

There are two situations there:

1) for devices where the firmware is inside an I2C driver, the solution
is to simply not load the firmware during module probing.

The easiest do to that is to call request_firmware_nowait() during module
probing. This call will start a deferred work that will use a callback
to warn the driver when the firmware is loaded.

If you want an example, please see: 61a96113de51e1f8f43ac98cbeadb54e60045905.
While I intend to do the same on other drivers as I have some spare time,
please don't wait for me on that, as I'm not with much spare time those
days.

You'll likely need to add a status flag at all drivers callback, that would
return a temporary error indication like -EAGAIN (or -ERESTARTSYS) and maybe
change the drivers to handle such error code.

2) for drivers where the firmware is needed for the bridge driver to work,
I couldn't find a perfect solution. There are two alternatives there:

a) patch the drivers base in order to improve the deferred probe. Currently,
a deferred probe will only be called again if a new device driver is probing.
It would make sense to add some way to make it do the probe after a while.

b) lie to probe(), returning 0 before probing the driver, and run a deferred 
probe inside the driver, in order to load the firmware and run the real probing
code.

Regards,
Mauro


