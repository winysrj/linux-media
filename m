Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <xyzzy@speakeasy.org>) id 1KYoZw-0001ew-Ci
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 22:58:53 +0200
Date: Thu, 28 Aug 2008 13:58:47 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <Pine.LNX.4.44L0.0808271036421.2498-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.58.0808281325120.2423@shell2.speakeasy.net>
References: <Pine.LNX.4.44L0.0808271036421.2498-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Cc: Jean-Francois Moine <moinejf@free.fr>,
	linux-usb <linux-usb@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [v4l-dvb-maintainer] [patch]dma on stack in dib0700
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Wed, 27 Aug 2008, Alan Stern wrote:
> On Tue, 26 Aug 2008, Trent Piepho wrote:
> > > That's not entirely accurate.  The mutex makes sure the buffer gets
> > > used only by one USB control transfer _on the host_.  But it also gets
> > > used simultaneously by the USB host controller, through DMA accesses.
> > >
> > > On some architectures these DMA accesses do not respect the CPU cache.
> > > Access by the CPU to different parts of the same cache line while the
> > > transfer is in progress can overwrite data that was stored by the host
> > > controller.
> >
> > It seems like you would need to allocate the cacheline size times two
> > (minus "1") and then use the middle of that.  Any less and the memory used
> > could overlap a cacheline boundary.
>
> I don't see how you arrived at that conclusion.  (And if you did use
> the middle of a region which was twice the size of a cache line, then
> you would _certainly_ overlap a cache-line boundary!)

What I meant was that if you get a pointer that's unaligned, via the stack
or malloc, and want an N byte region aligned to a multiple of N, you must
allocate 2*N-1 bytes.  Then align the pointer by moving it up between
0 and N-1 bytes, e.g.  p += N - (p % N ? : N)

But if kmalloc is already returning cacheline aligned memory, then
there isn't anything to worry about.

> In theory the buffer _could_ be part of a larger structure, if you
> included GCC attributes telling the compiler that the buffer's address
> and the address of the following item in the structure must be aligned
> at a cache-line boundary.  That would work just as well, but it is kind
> of awkward.  I don't know of any code taking that approach currently.

If the buffer is made the first field in the struct, then shouldn't making
the buffer a multiple of the cacheline size be sufficient?  Assuming the
larger structure is allocated with kmalloc() and thus starts aligned
on a cacheline boundary.

Though I think expecting drivers to work with these constraints is probably
a losing proposition.  The fact of the matter is that most driver are
developed and tested almost entirely on x86.  If something works fine on
x86 but doesn't work on your architecture, you will be forever plagued with
difficult to track down bugs because if it.  You can say it's the drivers
fault for not following a spec, but that isn't going to make the problem go
away.

Most of the non-x86 archs have less strongly ordered IO than x86 does.
But, their versions of writel(), etc. impose additional ordering to
provide x86 like semantics.  Otherwise there are just too many bugs from
drivers that assume x86.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
