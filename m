Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:54372 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab2HUMzO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 08:55:14 -0400
Date: Tue, 21 Aug 2012 13:55:12 +0100
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jwilson@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [media] rc-core: move timeout and checks to lirc
Message-ID: <20120821125511.GA2361@pequod.mess.org>
References: <20120816221514.GA26546@pequod.mess.org>
 <502D7E62.9040204@redhat.com>
 <20120820213659.GC14636@hardeman.nu>
 <5032B407.8030407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5032B407.8030407@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 20, 2012 at 07:02:47PM -0300, Mauro Carvalho Chehab wrote:
> Em 20-08-2012 18:36, David Härdeman escreveu:
> > On Thu, Aug 16, 2012 at 08:12:34PM -0300, Mauro Carvalho Chehab wrote:
> >> Em 16-08-2012 19:15, Sean Young escreveu:
> >>> Could we have a flag in rc_dev to signify whether a driver blocks on
> >>> completion of a transmit and only sleep here if it is not set?
> >>>
> >>> e.g. rc_dev.tx_blocks_until_complete
> >>>
> >>> The wording could be improved.
> >>>
> >>> Another alternative would be if the drivers provided a 
> >>> "wait_for_tx_to_complete()" function. If they can provided that; using 
> >>> that it would be possible to implement O_NONBLOCK and sync.
> >>
> >> Seems fine on my eyes. It may avoid code duplication if you pass the fd 
> >> flags to the lirc call, and add a code there that will wait for complete, 
> >> if the device was not opened in block mode.
> > 
> > I think a future rc-core native TX API should behave like a write() on a
> > network socket does.
> > 
> > That is, a write on a rc device opened with O_NONBLOCK will either
> > succeed immediately (i.e. write data to buffers for further processing)
> > or return EAGAIN.  A write on a non-O_NONBLOCK device will either write
> > the data to buffer space and return or wait for more space to be
> > available. No waiting for the data to actually leave the "device" (NIC
> > or IR transmitter) is done by the write() call.

The waiting for the data to leave the device could be enforced by opening
with O_SYNC or fsync(). I agree with O_NONBLOCK being better for blocking
on outgoing buffer space.

We could also have a kernel space write buffer (kfifo?) which the device 
driver works its way through; user space would just have to make sure
the buffer doesn't deplete, but there would be no limit on the IR signal
including silences. In that way the timing is entirely done in kernel 
space and no need for awkward sleeps and crossing of fingers.

> > 
> > The "gap calculation" that lirc wants to do based on the time a write()
> > takes to complete is quite non-unixy in my eyes and seems bogus.

Yes. Also if a signal arrives then the the user space program has no idea 
where it is at.

> > If a user-space program wants a very specific and deterministic
> > behaviour, eg. wrt gaps...it should just add it to the TX data.
> > 
> > I.e. if you want to TX command "A", wait 150ms, TX command "B", then
> > instead of doing:
> > 
> > write(A); sleep(150ms); write(B);
> > 
> > the app should do:
> > 
> > write(A + 150ms silence + B);
> > 
> > The same goes for e.g. trailing silences after commands, etc...
> 
> That makes sense to me, but we need to not break existing userspace
> applications with new improvements.
> 
> Yeah, a better API is needed to not only allow sending pulse/space/waiting
> times to IR TX, but also sending real keystrokes, like:
> 
> echo "A" > /dev/<some rc device>
>
> Still, I'm not sure if we should create a "150 ms silence" keystroke. That
> doesn't sound linux style to me.
> 
> The Linux way would be:
> 
> fputs("A", fp);
> fflush(fp);
> usleep(150000);
> fputs("B", fp);
> 
> That's close to what is done on term apps like minicom.
> 
> Ok, currently, all drivers have only "raw" TX. Yet, HDMI CEC provides
> a way to receive/send IR commands from/to the TV set. So, I think we'll
> have soon some drivers that only work on 'non-raw' TX mode.
> 
> So, IMO, it makes sense to have a "high end" API that accepts
> writing keystrokes like above, working with both "raw drivers"
> using some kernel IR protocol encoders, and with devices that can
> accept "processed" keystrokes, like HDMI CEC.

For devices that only accept "raw" IR, it can be done in user space.

I agree the existing user space tools aren't sufficient; it would be nice 
to have:

1. Something to send IR codes (NEC, RC-5, etc)
2. Something send a file with "pulse %d\nspace %d"..., i.e. the output mode2
3. Something to send keystrokes read from the rc_keymaps

I've written the first two for my own usage and it really doesn't need
moving into the kernel, IMHO.

> The lirc interface may not be the right device for such usage,
> if changing it would break support for existing devices.

It would be great to obsolete that interface. Could reading raw IR be
merged with the input interface?


Sean
