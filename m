Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <xyzzy@speakeasy.org>) id 1KY9sr-0000uL-VO
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 03:31:43 +0200
Date: Tue, 26 Aug 2008 18:31:35 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <Pine.LNX.4.44L0.0808261430330.2139-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.58.0808261826420.2423@shell2.speakeasy.net>
References: <Pine.LNX.4.44L0.0808261430330.2139-100000@iolanthe.rowland.org>
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

On Tue, 26 Aug 2008, Alan Stern wrote:
> > > That isn't good enough.  If the buffer is part of a larger data
> > > structure (such as the main device descriptor), then the mutex has to
> > > protect the entire data structure -- not just the buffer.
> > >
> >
> > Erm, why? The mutex makes sure the buffer gets used only by one usb control
> > transaction at a time, and the structure of which it is part does not get freed
> >   until all usb transactions using the buffer are done.
>
> That's not entirely accurate.  The mutex makes sure the buffer gets
> used only by one USB control transfer _on the host_.  But it also gets
> used simultaneously by the USB host controller, through DMA accesses.
>
> On some architectures these DMA accesses do not respect the CPU cache.
> Access by the CPU to different parts of the same cache line while the
> transfer is in progress can overwrite data that was stored by the host
> controller.

Isn't there a dma API for this?

It seems like you would need to allocate the cacheline size times two
(minus "1") and then use the middle of that.  Any less and the memory used
could overlap a cacheline boundary.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
