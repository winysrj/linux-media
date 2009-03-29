Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2093 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016AbZC2PJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 11:09:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: Status of v4l2_subdev conversion
Date: Sun, 29 Mar 2009 16:09:26 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, Douglas Landgraf <dougsland@gmail.com>
References: <200903291422.08806.hverkuil@xs4all.nl> <20090329160137.303588d6@hyperion.delvare>
In-Reply-To: <20090329160137.303588d6@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903291609.26281.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 29 March 2009 16:01:37 Jean Delvare wrote:
> On Sun, 29 Mar 2009 14:22:08 +0200, Hans Verkuil wrote:
> > Hi Mauro,
> >
> > For your information, this is the current status:
> >
> > - Steve Toth tested the HVR-1800 for me, so I've posted the pull
> > request for the converted cx23885 driver.
> >
> > - The cx88 driver is also finished. I'm waiting for a last test by Jean
> > Delvare before I post that one as well.
>
> Testing complete, it seems to work just fine. Thanks!
>
> > - Added support for saa6588 to saa7134: needed to drop the legacy i2c
> > API from saa6588. This is in my pull request for my v4l-dvb tree.
> >
> > - Douglas has almost finished the em28xx driver conversion.
> >
> > - Jean Delvare is working on the ir-kbd-i2c conversion.
> >
> > That last conversion is stand-alone (i.e. has no impact on the internal
> > v4l API) and I don't think it prevents pushing our v4l-dvb changes to
> > 2.6.30.
> >
> > When the first four items are finished and merged into v4l-dvb, then I
> > have a to do a few final cleanup actions to make everything ready for
> > the 2.6.30 merge:
> >
> > - Remove v4l2-i2c-drv-legacy.h from the remaining i2c drivers. Remove
> > the files v4l2-i2c-drv-legacy.h and v4l2-common.c since these are no
> > longer used. Cleanup v4l2-common.h since the internal ioctls are no
> > longer needed. Update v4l2-framework.txt, removing any references to
> > the legacy behavior.
> >
> > - Fix two subdev callbacks that are in the wrong place (s_std belongs
> > to the video ops, s_standby belongs to the tuner ops).
> >
> > - Add a load_fw callback to the core ops and use that were appropriate
> > instead of the init callback. Analyze whether the init callback can be
> > removed altogether.
> >
> > - Analyze how the probe addresses are used in the v4l2 drivers and move
> > those lists over to the appropriate i2c driver headers.
> >
> > - Add enum_frameintervals and enum_framesizes callbacks for use with
> > omap.
> >
> > - Check for any remaining uses of I2C_DRIVERID and remove them.
>
> Note that this isn't urgent as far as I am concerned. Driver IDs can
> stay as long as they are needed. I _do_ expect them to become useless
> thanks to the improved design, and then we can remove the structure
> fields, but we can wait and see if I am correct, no need to rush.

These all disappear after the convertion. They are simply no longer used.

> > This shouldn't take much time to implement.
>
> Thanks for all your work Hans.

There is one other task I have to do: I've just discovered that I still need 
to use the old autoprobing API for kernels < 2.6.25. While the 
i2c_new_probed_device API exists from kernel 2.6.22 onwards they have a bug 
causing a kernel oops in i2c_smbus_xfer when attempting to probe i2c 
addresses in the range 0x30-0x37 and 0x50-0x5f (7-bit). These addresses can 
contain an eeprom and so the probe mechanism attempts to read a byte 
instead of relying on an SMBUS_QUICK probe. Unfortunately that byte read is 
broken.

The main i2c drivers that have addresses in those ranges are tvaudio and 
tvp5150.

In the case of kernels 2.6.25 and 2.6.26 this bug was fixed in the stable 
series.

I really should have remembered this, since I fixed this i2c bug myself :-(

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
