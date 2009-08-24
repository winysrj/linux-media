Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3425 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZHXIBC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2009 04:01:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] v4l2_subdev_ir_ops
Date: Mon, 24 Aug 2009 10:00:09 +0200
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jwilson@redhat.com>
References: <1250906940.3159.20.camel@palomino.walls.org> <200908232116.36519.hverkuil@xs4all.nl> <20090823210506.0857a35e@pedra.chehab.org>
In-Reply-To: <20090823210506.0857a35e@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908241000.09360.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 24 August 2009 02:05:06 Mauro Carvalho Chehab wrote:
> Em Sun, 23 Aug 2009 21:16:36 +0200
>
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > On Sunday 23 August 2009 20:00:00 Mauro Carvalho Chehab wrote:
> > > Em Sat, 22 Aug 2009 17:27:50 -0400
> > >
> > > Andy Walls <awalls@radix.net> escreveu:
> > > > > The more important one is what kind of IR interfaces a V4L2
> > > > > device will open to lirc.
> > > >
> > > > I was thinking a lirc-v4l2-subdev plugin for lirc-dev.  If the
> > > > v4l2_subdev_ir_ops interface aligned or can easily translate to
> > > > supporting things LIRC needed, then follow on support for all video
> > > > related IR devices would fall out from implementing the
> > > > v4l2_subdev_ir_ops interface.  (In my optimistic version of the
> > > > future ;] ).
> > >
> > > This won't work, due to two reasons:
> > >
> > > 1) a subdev interface works for the devices with i2c interfaces (e.
> > > g. the subdev's), but it won't work on other cases;
> >
> > Subdev is actually independent of i2c, that was the one of the reasons
> > for making v4l2_subdev in the first place. Both the cx18 and ivtv
> > drivers use a non-i2c subdev in fact. It does rely on there being a
> > parent v4l2_device struct with which it will be registered. In other
> > words: while there may be good reasons for not using v4l2_subdev, this
> > reason isn't one of them.
>
> See bellow.
>
> > > 2) even when you'll have this at i2c, you may still need to properly
> > > lock the IR code to avoid that the IR operation to happen in the
> > > middle of another i2c transfer.
> >
> > I could well be wrong, but isn't the i2c_adapter already locking at the
> > bus level?
>
> It won't lock. The issue is outside i2c code. Probably you haven't seen
> the code I've posted on my previous email. Lirc does 2 separate
> transfers, one for send and another for receive:
>
>         i2c_master_send(&ir->c, keybuf, 1);
>         /* poll IR chip */
>         if (i2c_master_recv(&ir->c, keybuf, sizeof(keybuf)) !=
> sizeof(keybuf)) { dprintk("read error\n");
>                 return -EIO;
>         }
>
> Between the two independent transactions, an ioctl or a kernel thread may
> happen doing some stuff at i2c. You'll then have an i2c send where an i2c
> receive operation were expected to happen. This is known to cause some
> problems with some i2c implementations on some chips, including some
> eeprom's.
>
> In this specific case, one possible solution could be to replace them by
> i2c_master_xfer().
>
> > > See above. This should be unified outside subdev, since, on most
> > > cases, the IR is handled directly by the bridge code. Another
> > > alternative would be to create a fake subdev for the IR handling
> > > code, but, IMHO, such change will be large and I don't see much gain
> > > on doing it. Also, since on several cases it shares the bridge IRQ
> > > code, the IR handling code will be broken on just a layer interface
> > > at the subdev, but the real work will be handled at the bridge
> > > driver.
> >
> > It is a perfectly legitimate approach to use a subdev for IR handling.
> > Usually it is some separate set of registers or IC block anyway,
> > whether it is a bridge driver or a complex chip like cx2584x.
>
> No. Having a different sets of register for IR is generally the
> exception. I guess that, on 80-90% of the cases, it uses the same GPIO
> set of registers used by other parts of the driver. Just taking a few
> real examples: almost all bttv and cx88 are based on GPIO poll; on
> saa7134, just a few uses i2c. The great majority has a mix of GPIO poll
> or GPIO IRQ. If you take a look at the IRQ code, it is the same code used
> also by videobuf. On em28xx, you have 3 types: i2c, GPIO poll (mostly on
> devices with em282x and em284x) and some dedicated IR registers found on
> hardware with em286x/em288x (yet, a few of those devices still uses the
> old strategy).
>
> Ok, it would be possible to artificially add a layer in order to deal
> with some bits of those common registers differently, and to create an
> IRQ ops abstraction layer for IR but this is overkill. It will just add
> an extra abstraction layer for nothing. It may even interfere at the IR
> protocol handling, as, on those GPIO poll code, extra delays may
> interfere at the decoding, since the processor is responsible for
> measuring the times.
>
> > The v4l2_subdev approach
> > allows one to model such things in a relatively high-level manner. Andy
> > has experience doing exactly that in the cx18 driver, so he is very
> > well placed to investigate which approach is best.
>
> The v4l2_subdev approach works fine for the communication between a
> bridge driver and their ancillary sub-devices. There's nothing wrong on
> proposing an IR interface for that usage, in the cases where a separate
> IC chip is measuring the time or returning scan codes, like the cases
> where Andy mentioned.
>
> However, just letting lirc (or any other IR driver) to directly access a
> v4l_subdev without passing it via the bridge driver is risky, since
> bridge cannot protect the shared registers or avoid that another subdev
> call won't be interfered by IR.
>
> In other words, I'm seeing those valid scenarios:
>
> (1)	lirc -> v4l_device -> v4l_subdev -> IR;
> (2)	lirc -> v4l_device -> v4l_subdev -> subdev gpio -> IR;
> (3)	lirc -> v4l_device -> IR.
>
> But those scenarios:
> (4)	lirc -> v4l_subdev -> IR
> (5)	lirc -> v4l_subdev -> subdev gpio -> IR;
>
> Shouldn't be allowed since:

I agree with that. For now at least the v4l2_subdev struct should not be 
used outside of v4l2 drivers.

>
> 1) it will break IR support for the scenario (3), as no v4l_subdev knows
> how to deal with almost all of bttv, cx88, saa7134 and em28xx IR's;
>
> 2) some sort of memory barrier may be needed at v4l_device.
>
> > It is very important that everyone realizes that the sub-device
> > construct basically is an abstract model of the hardware, independent
> > of any busses or where that hardware actually is (i.e. as a part of a
> > larger IC or a self-contained i2c device). In 95% of the cases it does
> > indeed model an i2c device, but that is just because these are so
> > common.
> >
> > In fact, it could be especially useful in cases where the i2c support
> > is sometimes in a bridge, sometimes in an i2c device (or more than
> > one). If the actual API is through a v4l2_subdev, then that will make
> > everything nicely consistent.
> >
> > Of course, the proof of the pudding is in the eating, so try it in a
> > few drivers. You generally discover very quickly whether something is a
> > good API or not.
>
> Ok, those are valid uses, but it is not the better solution for sharing
> device resources like IRQ and GPIO's. I'm all for using it in the cases
> that Andy pointed in scenarios (1), (2) and (3).
>
> > > IMHO, it should be providing a driver that checks for the creation of
> > > e at /dev/video? and, if a node is found, it should do the a
> > > procedure similar to what is done by v4l2-apps/util/v4l2-sysfs-path
> > > (the latest version at http://linuxtv.org/hg/v4l-dvb tree), to
> > > determine the associated event device. For example, with my HVR-950,
> > > it returns:
> > >
> > > device     = /dev/video0
> > > bus info   = usb-0000:00:1d.7-8
> > > sysfs path = /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-8
> > > Associated devices:
> > >         i2c-adapter:i2c-4
> > >         input:input12:event6 (dev 13,70)
> > >         sound:pcmC1D0c (dev 116,9)
> > >         sound:dsp1 (dev 14,19)
> > >         sound:audio1 (dev 14,20)
> > >         sound:controlC1 (dev 116,10)
> > >         sound:mixer1 (dev 14,16)
> > >         dvb:dvb0.frontend0 (dev 212,0)
> > >         dvb:dvb0.demux0 (dev 212,1)
> > >         dvb:dvb0.dvr0 (dev 212,2)
> > >         dvb:dvb0.net0 (dev 212,3)
> > >         usb_endpoint:usbdev1.11_ep00 (dev 252,20)
> > >
> > > So, the event interface associated with /dev/video0 is
> > > /dev/input/event6 (minor 13, major 70), as reported above.
> >
> > Mauro, you should consider using libudev to map major/minor device
> > numbers to the actual device nodes. Right now no udev rules are taken
> > into account. So if someone renames a device node you will never find
> > it.
>
> Thank you for your suggestion.
>
> I've considered to use also libudev for it, but, while seeking the net
> for some coding example, this patch appeared:
>
> http://lists.lm-sensors.org/pipermail/lm-sensors/2007-November/022043.htm
>l
>
> There, Jean proposed a patch to get rid of libudev since, on that time,
> libudev weren't maintained anymore, according to him. I haven't check if
> this is still true or not, but, as all I wanted with that code is to get
> the event name and the device, I took, instead, the approach that gave me
> the quickest solution. For sure using a well maintained library is much
> better than having to reinvent the wheel.

Kay Sievers is actively maintaining this library. In fact, features like 
resolving major/minor numbers is something that he added in the last year 
if I am not mistaken. I discussed this problem with him during the Embedded 
Linux Conference early this year and he says that using libudev is the 
right approach. Apparently other people needed the same functionality so he 
had added it to the library.

Actually Andy Walls experimented with it and he posted some example code for 
this not too long ago. It was pretty trivial.

See: http://osdir.com/ml/linux-media/2009-07/msg00098.html

> In a matter of fact, to be really useful, the better would be if
> v4l2-sysfs-path could return the path of the devices instead of just the
> major/minor.
>
> Please, feel free to propose some patches to improve it, if you have time
> for it.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
