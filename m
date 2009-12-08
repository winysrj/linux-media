Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:43427 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936046AbZLHREL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 12:04:11 -0500
Date: Tue, 8 Dec 2009 09:04:12 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091208170412.GA14143@core.coreip.homeip.net>
References: <1260070593.3236.6.camel@pc07.localdom.local> <20091206065512.GA14651@core.coreip.homeip.net> <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain> <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com> <m3skbn6dv1.fsf@intrepid.localdomain> <9e4733910912061323x22c618ccyf6edcee5b021cbe3@mail.gmail.com> <4B1D934E.7030103@redhat.com> <9e4733910912071628x3f3eba82r4c964982f9d8c5a4@mail.gmail.com> <4B1E35D6.6000602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1E35D6.6000602@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 08, 2009 at 09:17:42AM -0200, Mauro Carvalho Chehab wrote:
> Jon Smirl wrote:
> > On Mon, Dec 7, 2009 at 6:44 PM, Mauro Carvalho Chehab
> > <mchehab@redhat.com> wrote:
> 
> >>> Where is the documentation for the protocol?
> >> I'm not sure what you're meaning here. I've started a doc about IR at the media
> > 
> > What is the format of the pulse stream data coming out of the lirc device?
> 
> AFAIK, it is at:
> 	http://www.lirc.org/html/index.html
> 
> It would be nice to to add it to DocBook after integrating the API in kernel.
> 
> >> docbook. This is currently inside the kernel Documents/DocBook. If you want
> >> to browse, it is also available as:
> >>
> >>        http://linuxtv.org/downloads/v4l-dvb-apis/ch17.html
> >>
> >> For sure we need to better document the IR's, and explain the API's there.
> >>
> >>> Is it a device interface or something else?
> >> lirc_dev should create a device interface.
> >>
> >>> What about capabilities of the receiver, what frequencies?
> >>> If a receiver has multiple frequencies, how do you report what
> >>> frequency the data came in on?
> >> IMO, via sysfs.
> > 
> > Say you have a hardware device with two IR diodes, one at 38K and one
> > at 56K. Both of these receivers can get pulses. How do we tell the
> > user space app which frequency the pulses were received on? Seems to
> > me like there has to be a header on the pulse data indicating the
> > received carrier frequency. There is also baseband signaling. sysfs
> > won't work for this because of the queuing latency.
> 
> Simply create two interfaces. One for each IR receiver. At sysfs, you'll
> have /sys/class/irrcv/irrcv0 for the first one and /sys/class/irrcv/irrcv1.

Yes, please. Distinct hardware - distinct representation in the kernel.
This is the most sane way.

...
> >>
> >>> What is the interface for attaching an in-kernel decoder?
> >> IMO, it should use the kfifo for it. However, if we allow both raw data and
> >> in-kernel decoders to read data there, we'll need a spinlock to protect the
> >> kfifo.

Probably we should do what input layer does - the data is pushed into
all handlers that are signed up for it and they can deal with it at
their leisure.

> >>
> >>> If there is an in-kernel decoder should the pulse data stop being
> >>> reported, partially stopped, something else?
> >> I don't have a strong opinion here, but, from the previous discussions, it
> >> seems that people want it to be double-reported by default. If so, I think
> >> we need to implement a command at the raw interface to allow disabling the
> >> in-kernel decoder, while the raw interface is kept open.
> > 
> > Data could be sent to the in-kernel decoders first and then if they
> > don't handle it, send it to user space.

You do not know what userspace wants to do with the data. They may want
to simply observe it, store or do something else. Since we do provide
interface for such raw[ish] data we just need to transmit it to
userpsace as long as there are users (i.e. interface is open).

> 
> Hmm... like adding a delay if the raw userspace is open and, if the raw userspace
> doesn't read all pulse data, it will send via in-kernel decoder instead? This can
> work, but I'm not sure if this is the better way, and will require some logic to
> synchronize lirc_dev and IR core modules. Also, doing it key by key will introduce
> some delay.
> 
> If you're afraid of having the userspace app hanged and having no IR output, 
> it would be simpler to just close the raw interface if an available data won't be
> read after a bigger timeout (3 seconds? 5 seconds?).

We can not foresee all use cases. Just let all parties signed up for the
data get and process it, do not burden the core with heuristics.

-- 
Dmitry
