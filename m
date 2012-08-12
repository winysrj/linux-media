Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43136 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab2HLT4W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 15:56:22 -0400
Received: by obbuo13 with SMTP id uo13so5732497obb.19
        for <linux-media@vger.kernel.org>; Sun, 12 Aug 2012 12:56:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344730005.2468.36.camel@palomino.walls.org>
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
	<1344730005.2468.36.camel@palomino.walls.org>
Date: Sun, 12 Aug 2012 16:56:21 -0300
Message-ID: <CALF0-+UfE2ncJE+S-PABCSLUCJyL0FORQCeNGZctUGK-2NX_ZA@mail.gmail.com>
Subject: Re: boot slow down
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: bjlockie@lockie.ca, Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 11, 2012 at 9:06 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Wed, 2012-08-08 at 13:18 -0400, bjlockie@lockie.ca wrote:
>> How hard would it be to get an official kernel option not to load firmware
>
> Submit a patch for the cx23885 driver to the list.  It could add a
> module option so the user can specify not to load cx23885-av firmware
> (and maybe CX23417 firmware too).  The new module option could be set on
> your kernel commandline: cx23885.no_firmware_load=1
>
> Honestly though such a patch problably won't fly.  The real solution,
> that the cx23885 driver needs anyway, is to inhibit the load of all
> firmware during the device probe by the kernel, and load them on the
> first device open (like the ivtv and cx18 drivers do for analog).
>
> There are at least 2 places in the PCI device probe routine of the
> cx23885 driver, where firmware is requested.  Here is the call chain:
>
> cx23885_initdev()
>         cx23885_dev_setup()
>                 cx23885_card_setup()
>                         v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
>                                 cx25840_load_fw()
>                                         cx23885_initialize()
>                                                 cx25840_work_handler()
>                                                         cx25840_loadfw()
>                                                                 request_firmware()
>                 cx23885_417_register()
>                         cx23885_initialize_codec()
>                                 cx23885_load_firmware()
>                                         request_firmware()
>
> The calls to
>         v4l2_subdev_call(dev->sd_cx25840, core, load_fw);

This one should be really easy, right?
The subdev can be created on probe and then the call to load_fw
can be done on first open.

It is remarkable this is documented in a comment placed just above
cx25840_load_fw:

"Since loading the firmware is often problematic when the driver is
 compiled into the kernel I recommend postponing calling this function
 until the first open of the video device. Another reason for
 postponing it is that loading this firmware takes a long time (seconds)
 due to the slow i2c bus speed. So it will speed up the boot process if
 you can avoid loading the fw as long as the video device isn't used."

If you want to, I can try that patch. Of course, someone must commit
to test it.

Regards,
Ezequiel.
