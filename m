Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:38591 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2HUTzp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 15:55:45 -0400
Date: Tue, 21 Aug 2012 21:55:36 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jwilson@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [media] rc-core: move timeout and checks to lirc
Message-ID: <20120821195536.GC4993@hardeman.nu>
References: <20120816221514.GA26546@pequod.mess.org>
 <502D7E62.9040204@redhat.com>
 <20120820213659.GC14636@hardeman.nu>
 <5032B407.8030407@redhat.com>
 <20120821125511.GA2361@pequod.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120821125511.GA2361@pequod.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 21, 2012 at 01:55:12PM +0100, Sean Young wrote:
>On Mon, Aug 20, 2012 at 07:02:47PM -0300, Mauro Carvalho Chehab wrote:
>> Em 20-08-2012 18:36, David Härdeman escreveu:
>> > On Thu, Aug 16, 2012 at 08:12:34PM -0300, Mauro Carvalho Chehab wrote:
>> >> Em 16-08-2012 19:15, Sean Young escreveu:
>> >>> Could we have a flag in rc_dev to signify whether a driver blocks on
>> >>> completion of a transmit and only sleep here if it is not set?
>> >>>
>> >>> e.g. rc_dev.tx_blocks_until_complete
>> >>>
>> >>> The wording could be improved.
>> >>>
>> >>> Another alternative would be if the drivers provided a 
>> >>> "wait_for_tx_to_complete()" function. If they can provided that; using 
>> >>> that it would be possible to implement O_NONBLOCK and sync.
>> >>
>> >> Seems fine on my eyes. It may avoid code duplication if you pass the fd 
>> >> flags to the lirc call, and add a code there that will wait for complete, 
>> >> if the device was not opened in block mode.
>> > 
>> > I think a future rc-core native TX API should behave like a write() on a
>> > network socket does.
>> > 
>> > That is, a write on a rc device opened with O_NONBLOCK will either
>> > succeed immediately (i.e. write data to buffers for further processing)
>> > or return EAGAIN.  A write on a non-O_NONBLOCK device will either write
>> > the data to buffer space and return or wait for more space to be
>> > available. No waiting for the data to actually leave the "device" (NIC
>> > or IR transmitter) is done by the write() call.
>
>The waiting for the data to leave the device could be enforced by opening
>with O_SYNC or fsync(). I agree with O_NONBLOCK being better for blocking
>on outgoing buffer space.

I don't think we should support O_SYNC at all unless there is a
compelling use-case for it. I seriously doubt there is one. A rc device
has more in common with a socket() than a open():ed file which resides
on a harddisk.

The O_NONBLOCK case is useful for e.g. a future lircd which uses some
kind of epoll() event loop to write TX data, read RX data and to
send/receive commands to/from userspace.

The non-O_NONBLOCK case is useful to e.g. a debug command line program
which does a blocking write and returns once the entire TX data stream
has been passed to the kernel (eg some kind of rc_tx tool which could be
used in scripts).

>We could also have a kernel space write buffer (kfifo?) which the device 
>driver works its way through; user space would just have to make sure
>the buffer doesn't deplete, but there would be no limit on the IR signal
>including silences. In that way the timing is entirely done in kernel 
>space and no need for awkward sleeps and crossing of fingers.

That is what I've proposed (in the patchset I've already sent, a kfifo
is used for TX and trailing silences and/or inter-command silences can
be encoded in the TX data itself).

>> The lirc interface may not be the right device for such usage,
>> if changing it would break support for existing devices.
>
>It would be great to obsolete that interface. Could reading raw IR be
>merged with the input interface?

No, it should be done using a separate RC-specific device...because we
should support multiple input devices per RC device and not pollute the
input subsystem with rc specifics.

-- 
David Härdeman
