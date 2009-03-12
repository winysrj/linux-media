Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1696 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZCLXcQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 19:32:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sri Deevi <Srinivasa.Deevi@conexant.com>
Subject: cx231xx review of i2c handling
Date: Fri, 13 Mar 2009 00:32:04 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903130032.07709.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sri,

Here is a review of the i2c part of this driver, together with pointers on 
how to proceed to convert it to v4l2_device/v4l2_subdev.

Time permitting I hope to look at the v4l2 implementation in the driver as 
well over the weekend, but the i2c part is for me the most urgent issue at 
the moment as you've no doubt guessed by now :-)

Although I couldn't help noticing this typo:

cx231xx-cards.c:                cx231xx_info("Board is Conexnat RDE 250\n");
cx231xx-cards.c:                cx231xx_info("Board is Conexnat RDU 250\n");

:-)

Looking at cx231xx-i2c.c I see it has the following devices:

0x32: Geminit III
0x02: Acquarius
0xa0: eeprom
0x60: Colibri
0x8e: IR
0x80/0x88: Hammerhead

And it also uses an external tuner.

It is my understanding that these devices are integrated on the cx231xx and 
so are completely internal to it:

Geminit III, Acquarius, Colibri, Hammerhead.

Is the eeprom also internal, or is it external?

Why can Hammerhead be at two addresses? Since it is an integral device I'd 
expect that the address would be fixed. Or are there two Hammerheads? 
Looking at the source I'd say that it can only be at address 0x88.

A general note: please add a description in the cx231xx.h header or in 
another suitable place for each of these devices. The codenames themselves 
do not give much of an idea of what the device actually does.

I have 'decoded' that Hammerhead is the cx231xx version of the cx25843. You 
are loading the cx25840 module to handle this (good), but you also write 
directly to the i2c device from the cx231xx driver (bad). You have to make 
a choice here: either handle it completely from inside cx231xx, or add full 
support for it to the cx25840 module and call that.

The rule is that parent drivers of an i2c module should never attempt to set 
registers directly as that breaks reusability. In this case, suppose a 
change is made in cx25840 that overwrites a register you've set from 
without cx231xx. Now the cx231xx is broken, and that is because there is no 
way of knowing when you edit the cx25840 sources that it is used like that.

Whereas if all the code that reads and writes registers is fully within the 
cx25840 module, then whoever needs to modify that driver can see the whole 
picture.

It is much preferred to keep using cx25840 and just add the missing pieces 
to that driver, rather than moving all the code inside cx231xx.

Since the i2c addresses for the integral i2c devices are hardwired (I 
assume), I recommend making some simple inline functions like this:

static int inline colibri_read_byte(struct cx231xx *dev, int reg, u8 *byte)
{
	return cx231xx_read_i2c_data(dev, Colibri_DEVICE_ADDRESS,
                     reg, 2, byte, 1);
}

That will make the code much more readable.

A note on the cx231xx_usb_disconnect: this can be simplified without needing 
user counts and complicated code. Read the section on video_device cleanup 
in the v4l2-framework.txt. The release() callback is guaranteed to be 
called when the last user disappears, so you can do your cleanup there. 
This is a fairly recent change. Before this was implemented each USB driver 
had to do their own reference counting.

Anyway, none of the points above is really urgent. What is urgent is that 
the new i2c API should be used. The background for this is that currently 
you just load an i2c module (e.g. tuner or cx25840) and it magically probes 
the i2c bus and attaches itself when it finds a suitable i2c device. The 
problem with that is that not all i2c devices can be uniquely identified, 
so that can lead to misdetections and that can cause lots of problems, 
including cases of corrupted eeproms.

A new i2c API was created for this and at the moment both old and new 
co-exist. However, the intention is to remove support for the old i2c API 
from the i2c core in 2.6.30.

Rather than just switching to the new API I've taken the opportunity to 
integrate it into a bigger v4l2 framework, based around new v4l2_device and 
v4l2_subdev structs. Currently the sole purpose is to aid in the migration 
to the new i2c API, basically hiding all the details from the driver. A 
major advantage of v4l2_subdev is also that it is not limited to i2c 
devices, instead you can model just about any type of device around it. 
This is particularly useful for highly integrated devices and it might be 
interesting to consider their use for the integrated devices that cx231xx 
has.

Please read v4l2-framework.txt. Let me know if something is not clear as 
that might indicate that I need to improve it.

This driver luckily doesn't need a lot of work. The first step is to 
introduce struct v4l2_device. Just stick it in struct cx231xx, register it 
in cx231xx_usb_probe and unregister it when cleaning up.

One thing you need to be aware of is that you should set i2c_set_adapdata to 
the v4l2_device pointer instead of the cx231xx_i2c bus.

The second step is to load the i2c modules through v4l2_i2c_new_subdev or 
v4l2_i2c_new_probed_subdev and call the i2c modules using 
v4l2_device_call_all() or a variant of that. Note that you have to delete 
the .class assignment in the i2c_adapter struct to enable the new style 
API. Once done you can also delete attach_inform and detach_inform as these 
serve no purpose anymore (and will be deleted in the future from the i2c 
core).

Again, the v4l2-framework.txt should do a fairly decent job of explaining 
the details and background. If not, let me know and I'll attempt to improve 
it.

In case of any questions please do not hesitate to contact me!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
