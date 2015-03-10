Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:39231 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbbCJOPo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 10:15:44 -0400
Message-ID: <1425996895.11726.3.camel@hadess.net>
Subject: Re: [RFC v2 2/7] media: rc: Add cec protocol handling
From: Bastien Nocera <hadess@hadess.net>
To: Kamil Debski <k.debski@samsung.com>
Cc: 'Mauro Carvalho Chehab' <mchehab@osg.samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, linux-input@vger.kernel.org
Date: Tue, 10 Mar 2015 15:14:55 +0100
In-Reply-To: <001a01d05b2a$26c71640$745542c0$%debski@samsung.com>
References: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
	 <1421942679-23609-3-git-send-email-k.debski@samsung.com>
	 <20150308112033.7d807164@recife.lan>
	 <000801d05a85$2c83f4e0$858bdea0$%debski@samsung.com>
	 <1425919423.1421.14.camel@hadess.net>
	 <001a01d05b2a$26c71640$745542c0$%debski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2015-03-10 at 13:02 +0100, Kamil Debski wrote:
> Hi Bastien,
> 
> From: Bastien Nocera [mailto:hadess@hadess.net]
> Sent: Monday, March 09, 2015 5:44 PM
> > 
> > On Mon, 2015-03-09 at 17:22 +0100, Kamil Debski wrote:
> > > Hi Mauro,
> > > 
> > > From: Mauro Carvalho Chehab [mailto:mchehab@osg.samsung.com]
> > > Sent: Sunday, March 08, 2015 3:21 PM
> > > 
> > > > Em Thu, 22 Jan 2015 17:04:34 +0100
> > > > Kamil Debski <k.debski@samsung.com> escreveu:
> > > > 
> > > > (c/c linux-input ML)
> > > > 
> > > > > Add cec protocol handling the RC framework.
> > > > 
> > > > I added some comments, that reflects my understanding from 
> > > > what's there at the keymap definitions found at:
> > > >         http://xtreamerdev.googlecode.com/files/CEC_Specs.pdf
> > > 
> > > Thank you very much for the review, Mauro. Your comments are very
> > much
> > > appreciated.
> > 
> > How does one use this new support? If I plug in my laptop to my 
> > TV, will using the TV's remote automatically send those key events 
> > to the laptop?
> 
> It depends on the hardware that is used in your laptop to handle 
> HDMI. If there is hardware support for CEC then this framework can 
> be used to create a driver for the laptop's HDMI hardware. Then the 
> laptop will be able to communicate with the TV over CEC - this 
> includes receiving key events from the TV.
> 
> Currently there are some CEC devices (and drivers) that enable Linux 
> to use CEC, but there is no generic framework for CEC in the Linux 
> kernel. My goal is to introduce such a framework, such that 
> userspace application could work with different hardware using the 
> same interface.
> 
> Getting back to your question - using this framework. There should 
> be some initialization done by a user space application:
> - enabling CEC (if needed by the hardware/driver)

I have 2 machines that this could work on, a Intel Baytrail tablet, 
and a laptop with Intel Haswell. Is that part going to be covered by 
your library, or will there be a drm API for that?

> - configuring the connection (e.g. what kind of device should the
>   laptop appear as, request the TV to pass remote control keys, etc.)

That's done through the CEC API as well?

> - the TV will also send other CEC messages to the laptop, hence the
>   application should listen for such messages and act accordingly

That's easier to deal with :)

Something like LIRC can be used in the short-term.

> How this should be done userspace? Definitely, it would be a good 
> idea to use a library. Maybe a deamon that does the steps mentioned 
> above would be a good idea? I am working on a simple library 
> implementation that would wrap the kernel ioctls and provide a more 
> user friendly API.

Great. Do drop me a mail when you have something that I could test.

Cheers
