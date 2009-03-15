Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2657 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbZCOWIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 18:08:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
Date: Sun, 15 Mar 2009 23:09:05 +0100
Cc: Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200903151344.01730.hverkuil@xs4all.nl> <20090315181207.36d951ac@hyperion.delvare> <1237145673.3314.47.camel@palomino.walls.org>
In-Reply-To: <1237145673.3314.47.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903152309.05803.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 15 March 2009 20:34:33 Andy Walls wrote:
> On Sun, 2009-03-15 at 18:12 +0100, Jean Delvare wrote:
> > Hi Hans,
> >
> > On Sun, 15 Mar 2009 13:44:01 +0100, Hans Verkuil wrote:
> > > Hi Mauro, Jean,
> > >
> > > When converting the bttv driver to v4l2_subdev I found one probing
> > > conflict between tvaudio and ir-kbd-i2c: address 0x96 (or 0x4b in
> > > 7-bit notation).
> > >
> > > It turns out that this is one and the same PIC16C54 device used on
> > > the ProVideo PV951 board. This chip is used for both audio input
> > > selection and for IR handling.
> > >
> > > But the tvaudio module does the audio part and the ir-kbd-i2c module
> > > does the IR part. I have truly no idea how this should be handled in
> > > the new situation. For that matter, I wonder whether it ever worked
> > > at all since my understanding is that once you called
> > > i2c_attach_client for a particular address, you cannot do that a
> > > second time. So depending on which module happens to register itself
> > > first, you either have working audio or working IR, but not both.
> >
> > You are right.
> >
> >
> > This is the typical multifunction device problem. It isn't specifically
> > related to I2C,
>
> But the specific problem that Hans' brings up is precisely a Linux
> kernel I2C subsystem *software* prohibition on two i2c_clients binding
> to the same address on the same adapter.
>
> >From linux/drivers/i2c/i2c-core.c:
>
> static int __i2c_check_addr(struct device *dev, void *addrp)
> {
>         struct i2c_client       *client = i2c_verify_client(dev);
>         int                     addr = *(int *)addrp;
>
>         if (client && client->addr == addr)
>                 return -EBUSY;
>         return 0;
> }
> [...]
> int i2c_attach_client(struct i2c_client *client)
> {
>         struct i2c_adapter *adapter = client->adapter;
>         int res;
>
>         /* Check for address business */
>         res = i2c_check_addr(adapter, client->addr);
>         if (res)
>                 return res;
> [...]
>
>
> It seems like an artificial restriction: intended for safety, but
> getting in the way when something like that is a valid need.
>
> >  the exact same problem happens for other devices, for
> > example a PCI south bridge including hardware monitoring and SMBus, or
> > a Super-I/O chip including hardware monitoring, parallel port,
> > infrared, watchdog, etc. Linux currently only allows one driver to bind
> > to a given device, so it becomes very difficult to make per-function
> > drivers for such devices.
> >
> >
> > I know that there was some work in progress to allow multiple drivers
> > to bind to the same device. However it seems to be very slow because it
> > is fundamentally incompatible with the device driver model as it was
> > originally designed.
>
> The driver model outside of the I2C subsystem?
>
> Looking at the rest of i2c_attach_client() (that I didn't paste in
> above), I dont' see how the call to device_register(&client->dev) would
> care, as each i2c_client has it's own dev.  Although I guess you might
> get duplicately named sysfs directory entries like
>
> /sys/devices/.../i2c-adapter/i2c-3/3-0096
>
> Which could be a problem for accessing via the sysfs filesystem.  But
> that could be fixed in i2c_attach_client?
>
> Then there's a matter of accessing the I2C device only by the address
> which means the wrong client might be used.  But since they both point
> to the same address on the same device, does that really matter?
>
> > In the meantime, one workaround is to list the multifunction device as
> > supported by several drivers, and make the probe functions for this
> > device fail, while still keeping a reference to the device. The
> > reference lets you access the device, and is freed when you remove the
> > drivers. See for example the via686a, vt8231 and i2c-viapro drivers.
> > This approach may or may not be suitable for the ir-kbd-i2c and tvaudio
> > drivers. One drawback is that you can't do power management on the
> > device.
>
> To me it would be more forward looking to add support in the I2C
> subsystem for allowing multiple client drivers to use the same address
> on the same adapter, instead of adding non-intuitive behavior to module
> probe routines as a workaround.  Integration of discrete I2C chip cores
> into multifunction devices is likely to be a continuing trend.
>
> The PCI subsystem handles single devices with multiple functions.
> There, of course, the function number is in the logical device address.
>
> For an single I2C chip with multiple functions,  I've seen two types of
> functional block separation provided: a separate I2C address per
> functional block, and functions are separated by register address
> ranges.  The CX25843 leaps to mind as being of the second type.  There
> are register blocks for the basic device, the analog front end, the
> consumer IR device, the video decoding, the broadcast audio decoding,
> and AC97 interface functions.
>
> > As far as the PIC16C54 is concerned, another possibility would be to
> > move support to a dedicated driver. Depending on how much code is
> > common between the PIC16C54 and the other supported devices, the new
> > driver may either be standalone, or rely on functions exported by the
> > ir-kbd-i2c and tvaudio modules.
>
> I'll guess that solution is probably the path of least resistance for
> the problem at hand.  It seems like a workaround for design decision
> made in the I2C subsystem long ago though.

Actually, it seems like this used to work at one time in the past. Jean, can 
you confirm that it used to be possible to have two i2c clients at the same 
i2c address in the past? Looking at the post (see the link in my original 
mail) it apparently worked in 2.6.19 at least.

I do think that the initial approach to this is to ensure that tvaudio is at 
least working. After all, it is better to have audio and no remote than to 
have a working remote, but no audio. Until we find a proper solution I 
think that this should not stop us from going forward since this way we 
remain bug-compatible with the current situation. Or even slightly better 
since we can now ensure that audio is working at least.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
