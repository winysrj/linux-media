Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48011 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZK1BIX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 20:08:23 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <christoph@bartelmus.de>,
	jarod@wilsonet.com, awalls@radix.net, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <4B104971.4020800@s5r6.in-berlin.de>
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
	 <4B104971.4020800@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Nov 2009 03:08:21 +0200
Message-ID: <1259370501.11155.14.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-11-27 at 22:49 +0100, Stefan Richter wrote: 
> Jon Smirl wrote:
> > 3) No special tools - use mkdir, echo, cat, shell scripts to build maps
> 
> From the POV of a distributor, there is always a special tool required.
> Whether it is implemented in bash, Python, or C doesn't make a
> difference to him.
> 
> For an enduser whose distributor doesn't package that tool, it also
> doesn't matter whether it is bash or Python.  (C is awkward because it
> needs to be run through gcc first.)  A Pyton tool can operate the
> existing EVIOCSKEYCODE interface just as well as a C tool.
> 
> Your mkdir/ echo/ cat programs would still just this:  Programs.  Sure,
> these programs would be interpreted by an interpreter which is installed
> everywhere, and the data they operate on is in a clear text format.  The
> downside is that these programs do not exist yet.
> 
> > 5) Direct multi-app support - no daemon
> 
> Think of lircd (when it feeds into uinput) as of a userspace driver
> rather than a daemon.  The huge benefit of a userspace driver is that it
> can load configuration files.
And bear in mind the fact that only handful of lirc drivers are in
kernel.
Many drivers are pure userspace and live in  the lirc daemon itself.
These drivers ether will have to be reimplemented in kernel (huge job)
Or we will have a lot of duplication, because same remote can be used
with kernel or userspace drivers.

Look at daemons subdirectory of lircd to get the idea of how many such
drivers exist.


Btw, for _some_ user space drivers its not possible to re implement them
in kernel, like driver that reads input from a sound card, which I can
say is nice very cheap way to have a receiver.


I want to repeat the correct way of doing things:

1 - all drivers that do all processing in hardware, will use input
system. 

2 - all drivers that decode protocol will use ether lirc, to keep
configuration in one place.

3 - all drivers that send pulse/space will use lirc.

lirc will process the data, convert it to input events and feed them
back to kernel.

Please note, and note again.
We aren't taking about two interfaces for userspace!
Everybody agree that userspace programs will only recieve input events.
The point is that we give an exception for one program that yes is just
a userspace driver to recieve the raw data, process it, and feed it
back.

Also same program (lircd) could receive data from other sources, and
convert that to input events.

Whats wrong with that?

If we add in-kernel decoding, we still will end up with two different
decoding, one in kernel and one in lirc.

Could we finally end this discussion and move forward?

Best regards,
Maxim Levitsky

