Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37379 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754417Ab2IBTlQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Sep 2012 15:41:16 -0400
Date: Sun, 2 Sep 2012 22:41:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 2/9] ir-rx51: Handle signals properly
Message-ID: <20120902194110.GA6834@valkosipuli.retiisi.org.uk>
References: <1346349271-28073-1-git-send-email-timo.t.kokkonen@iki.fi>
 <1346349271-28073-3-git-send-email-timo.t.kokkonen@iki.fi>
 <20120901171420.GC6638@valkosipuli.retiisi.org.uk>
 <50437328.9050903@iki.fi>
 <504375FA.1030209@iki.fi>
 <20120902152027.GA5236@itanic.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120902152027.GA5236@itanic.dhcp.inet.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 02, 2012 at 06:20:27PM +0300, Timo Kokkonen wrote:
> On 09.02 2012 18:06:34, Sakari Ailus wrote:
> > Heippa,
> > 
> > Timo Kokkonen wrote:
> > > Terve,
> > >
> > > On 09/01/12 20:14, Sakari Ailus wrote:
> > >> Moi,
> > >>
> > >> On Thu, Aug 30, 2012 at 08:54:24PM +0300, Timo Kokkonen wrote:
> > >>> @@ -273,9 +281,18 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
> > >>>
> > >>>   	/*
> > >>>   	 * Don't return back to the userspace until the transfer has
> > >>> -	 * finished
> > >>> +	 * finished. However, we wish to not spend any more than 500ms
> > >>> +	 * in kernel. No IR code TX should ever take that long.
> > >>> +	 */
> > >>> +	i = wait_event_timeout(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0,
> > >>> +			HZ / 2);
> > >>
> > >> Why such an arbitrary timeout? In reality it might not bite the user space
> > >> in practice ever, but is it (and if so, why) really required in the first
> > >> place?
> > >
> > > Well, I can think of two cases:
> > >
> > > 1) Something goes wrong. Such before I converted the patch to use the up
> > > to date PM QoS implementation, the transmitting could take very long
> > > time because the interrupts were not waking up the MPU. Now that this is
> > > sorted out only unknown bugs can cause transmitting to hang indefinitely.
> > >
> > > 2) User is (intentionally?) doing something wrong. For example by
> > > feeding in an IR code that has got very long pulses, he could end up
> > > having the lircd process hung in kernel unkillable for long time. That
> > > could be avoided quite easily by counting the pulse lengths and
> > > rejecting any IR codes that are obviously too long. But since I'd like
> > > to also protect against 1) case, I think this solution works just fine.
> > >
> > > In the end, this is just safety measure that this driver behaves well.
> > 
> > In that case I think you should use wait_event_interruptible() instead. 
> 
> Well, that's what I had there in the first place. With interruptible
> wait we are left with problem with signals. I was told by Sean Young
> that the lirc API expects the write call to finish only after the IR
> code is transmitted.
> 
> > It's not the driver's job to decide what the user can do with the 
> > hardware and what not, is it?
> 
> Yeah, policy should be decided by the user space. However, kernel
> should not leave any objvious denial of service holes open
> either. Allowing a process to get stuck unkillable within kernel for
> long time sounds like one to me.

It's interruptible, so the user space can interrupt that wait if it chooses
so. Besides, if you call this denial of service, then capturing video on
V4L2 is, too, since others can't use the device in the meantime. :-)

> Anyway, we are trying to cover some rare corner cases here, I'm not
> sure how it should work exactly..

If there was a generic maximum timeout for sending a code, wouldn't it make
sense to enforce that in the LIRC framework instead?

Terveisin,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
