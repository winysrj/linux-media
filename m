Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33265 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZFMIMW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Jun 2009 04:12:22 -0400
Message-ID: <4A335F5A.1010305@redhat.com>
Date: Sat, 13 Jun 2009 10:12:10 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Erik de Castro Lopo <erik@bcode.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: GPL code for Omnivision USB video camera available.
References: <20090612110228.3f7e42ab.erik@bcode.com>	<4A31FB0A.8030104@redhat.com> <20090613104524.781027d8.erik@bcode.com>
In-Reply-To: <20090613104524.781027d8.erik@bcode.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/13/2009 02:45 AM, Erik de Castro Lopo wrote:
> Hans de Goede wrote:
>
>> This looks to me like its just ov51x-jpeg made to compile with the
>> latest kernel.
>
> Its more than that. This driver supports a number of cameras and the
> only one we (bCODE) are really interested in is the ovfx2 driver.
>

Ah, I hadn't noticed the ovfx2 driver, actually I've never heard of it
before.

>> Did you make any functional changes?
>
> I believe the ovfx2 driver is completely new.
>

It is atleast to me and I know lots of webcam drivers.


>> Also I wonder if you're subscribed to the (low trafic) ov51x-jpeg
>> mailinglist, that seems to be the right thing todo for someone who tries
>> to get that driver in to the mainline.
>
> Sorry its the ovfx2 that I'm interested in pushing into  the kernel.
>

Ok,

Getting ovfx2 support into the mainline kernel sounds like a good idea!

I'm not such a big fan of merging the driver as is though, as it does 
its own buffer management (and ioctl handling, usb interrupt handling, 
locking, etc).

Now a days we prefer for new drivers to use existing infrastructure.

Preferably the ovfx2 driver would be re-written to use the gspca usb
webcam driver framework. See for example the ov519 driver:
drivers/media/video/gspca/ov519.c

Which is also based on ov51x-jpeg. There are also several bulk mode
using drivers under drivers/media/video/gspca

As you will see when you look here, gspca sub drivers currently do not
have the sensor code separated from the bridge :( There are several
reasons for this, the biggest one being that most drivers are reverse
engineered and we simply do not know enough about what all the
sensor registers do, to cleanly separate bridge and sensor code.

Another reason is that quite a few sensor settings can be quite bridge
specific, for example vsync / hsync timing which seems quite sane may
not work with some bridges, because the require some strange timings,
another example is that registers which are meant to adjust the
framerate to match the powernet frequency, are sometimes abused to
correct for a somewhat strange clock being offer to the sensor by the 
bridge, etc. So doing the bridge sensor separation cleanly is far from
easy, and for now we've given up doing this for webcams, esp. as just
getting webcams to work and working properly has a higher priority atm.

Once we have most cams working we can better analyze which sensor 
settings are the same for all bridges and which are bridge specific and
find a why to separate the sensor and bridge code.

For adding the ovfx2 driver, you could start by copying ov519.c, which
already has setup and control code fro most ov sensors and then rewrite
the bridge part to be ovfx2 code, then later we can try to move the 
sensor code to a shared c file for the ov519 and ovfx2 driver, depending
on how much you needed to change the sensor code. Or you could add
support for the ovfx2 to the ov519 driver.

Note I've recently being doing quite a bit of work on the ov519 driver,
adding support for the ov511 and ov518 and adding more controls. I'll
make a mercurial tree available with my latest code in it asap.

Regards,

Hans
