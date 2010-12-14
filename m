Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:32496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab0LNOFh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 09:05:37 -0500
Message-ID: <4D0779A7.5090807@redhat.com>
Date: Tue, 14 Dec 2010 12:05:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Gerd Hoffmann <kraxel@redhat.com>, linux-media@vger.kernel.org
Subject: Re: Hauppauge USB Live 2
References: <4D073F83.8010301@redhat.com> <AANLkTimuS+O1rv1GL_ujj4D=gSXw+VLKh0vMc2mXx1Cd@mail.gmail.com>
In-Reply-To: <AANLkTimuS+O1rv1GL_ujj4D=gSXw+VLKh0vMc2mXx1Cd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Devin,

Em 14-12-2010 08:06, Devin Heitmueller escreveu:
> On Tue, Dec 14, 2010 at 4:57 AM, Gerd Hoffmann <kraxel@redhat.com> wrote:
>>  Hi folks,
>>
>> Got a "Hauppauge USB Live 2" after google found me that there is a linux
>> driver for it.  Unfortunaly linux doesn't manage to initialize the device.
>>
>> I've connected the device to a Thinkpad T60.  It runs a 2.6.37-rc5 kernel
>> with the linuxtv/staging/for_v2.6.38 branch merged in.
>>
>> Kernel log and lsusb output are attached.
>>
>> Ideas anyone?
> 
> Looks like a regression got introduced since I submitted the original
> support for the device.
> 
> Mauro?

No idea what happened. The driver is working here with the devices I have.
Unfortunately, I don't have any USB Live 2 here for testing.

Based on the logs, maybe the driver is directing the I2C commands to the
wrong bus.

The better would be to bisect the kernel and see what patch broke it.
The support for USB live2 were added on changeset 4270c3ca.

There aren't many changes on it (45 changes), so, bisecting it shouldn't be hard:

$ git log --oneline --no-merges 4270c3ca.. drivers/media/video/cx231xx 
f5db33f [media] cx231xx: stray unlock on error path
9a1f8b3 [media] v4l: Remove module_name argument to the v4l2_i2c_new_subdev* functions
80bab1f [media] rc: Properly name the rc_map struct
e58462f [media] rc: Rename remote controller type to rc_type instead of ir_type
9489b78 [media] cx231xx: Properly name rc_map name
6054b77 [media] rc: rename the remaining things to rc_core
b8da8d2 [media] cx231xx-417: Remove unnecessary casts of void ptr returning alloc function return values
c3e1500 [media] cx231xx: Fix i2c support at cx231xx-input
1639cc0 [media] ir-core: make struct rc_dev the primary interface
0d71fa1 [media] ir-core: more cleanups of ir-functions.c
0edf2e5 [media] v4l: kill the BKL
e31e62a [media] cx231xx: Add IR support for Pixelview Hybrid SBTVD
0d1220a [media] cx231xx: Add a driver for I2C-based IR
2d1b6c2 [media] mb86a20s: add support for serial streams
9bb63ec [media] cx231xx: use callback to set agc on PixelView
e97fc39 [media] add digital support for PV SBTVD hybrid
4938aef [media] Add analog support for Pixelvied Hybrid SBTVD
1532a07 [media] v4l: Remove hardcoded module names passed to v4l2_i2c_new_subdev*
b838396 [media] cx231xx: fix double lock typo
4372584 [media] cx231xx: Fix compilation breakage if DVB is not selected
44ed895 [media] cx231xx: Remove IR support from the driver
10e4ebb [media] cx231xx: Only register USB interface 1
9439943 [media] v4l-dvb: using vmalloc needs vmalloc.h in cx231xx-417.c
643800d [media] cx231xx: use core-assisted lock
0f86158 [media] cx231xx: Colibri carrier offset was wrong for PAL/M
1001f90 [media] cx231xx: remove some unused functions
82c3cca [media] cx231xx: declare static functions as such
bae94dc [media] cx231xx-417: Fix a gcc warning
955e6ed [media] CodingStyle cleanup at s5h1432 and cx231xx
61b04cb [media] cx231xx-audio: fix some locking issues
78bb6df [media] cx231xx: Only change gpio direction when needed
a6f6fb9 [media] cx231xx: better handle the master port enable command
1a4aa92 [media] cx231xx: properly use the right tuner i2c address
24c80b6 [media] cx231xx: properly implement URB control messages log
92fbb811 [media] cx231xx: fix Kconfig dependencies
62c78c9 [media] cx231xx: remove a printk warning at -avcore and at -417
6af8cc0 [media] cx231xx: Fix vblank/vactive line counts for PAL/SECAM
222c435 [media] cx231xx: properly set active line count for PAL/SECAM
2ded0fe [media] cx231xx: whitespace cleanup
b6cd9c4 [media] cx231xx: remove board specific check for Colibri configuration
8aed3f4 [media] cx231xx: Make the DIF configuration based on the tuner not the board id
b522591 [media] cx231xx: remove i2c ir stubs
2b43db3 [media] cx231xx: move printk() line related to 417 initialization
9f51259 [media] cx231xx: fixup video grabber board profile
8880621 [media] cx231xx: make output mode configurable via the board profile

Cheers,
Mauro
