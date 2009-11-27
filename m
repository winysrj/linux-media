Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:37394 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbZK0RAE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 12:00:04 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Andy Walls <awalls@radix.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Christoph Bartelmus <christoph@bartelmus.de>, jarod@wilsonet.com,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 27 Nov 2009 11:57:50 -0500
Message-Id: <1259341070.3062.34.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-11-27 at 10:57 -0500, Jon Smirl wrote:
> On Fri, Nov 27, 2009 at 2:45 AM, Christoph Bartelmus
> <christoph@bartelmus.de> wrote:

> > So the plan is to have two ways of using IR in the future which are
> > incompatible to each other, the feature-set of one being a subset of the
> > other?
> 
> Take advantage of the fact that we don't have a twenty year old legacy
> API already in the kernel. Design an IR API that uses current kernel
> systems. Christoph, ignore the code I wrote and make a design proposal
> that addresses these goals...

Jon,

It's good to have clear, sensible goals.  I'd also like to have
concurrence on what are driving requirements vs. nice-to-have's and also
on priorities.


> 1) Unified input in Linux using evdev. IR is on equal footing with
> mouse and keyboard.

Sounds fine.  I think some of the discussion so far indicates the devil
may be in the details.  I understand the driving requirement is to avoid
user(?) problems experienced in the past with PS/2 keyboards, etc.


> 2) plug and play for basic systems - you only need an external app for scripting

I concur.  Users needing hardware to "Just Work" is *the* driving
requirment for in kernel IR from the discussion.  I would only say that
you may not need any application for the default configuration on basic
systems.


> 3) No special tools - use mkdir, echo, cat, shell scripts to build maps

Sounds fine.  I also was a user who used setkeys, loadkeys, et. al. once
years ago, and can't remeber for the life of me why I had to do so or
how they work anymore.


> 4) Use of modern Linux features like sysfs, configfs and udev.

I'm not sure this is strictly driven by anything; it's an implementation
decision stated in advance.  One uses features, if one needs them.


> 5) Direct multi-app support - no daemon

I understand the rationale for this to really be a desire for minimal
userspace components.  If you think/know that the input system can
multiplex or multicast events in a sane way for applications, then I
suppose it's feasible.

I don't hear users asking for minimal userspace components, as their
dsitribution packaging system usually handles this for them.  I suspect
this is mostly driven by kernel developers or embedded systems
developers.


> 6) Hide timing data from user as much as possible.

I do not strictly agree with this.  I understand this goal is to
insulate users from the low level details of IR protocols.  I think that
hinders users' ability to solve or diagnose problems on their own.  Some
people like details and flexible control.  I think users being able to
report about timing data of unknown remotes or protocols has value as
well.


> What are other goals for this subsystem?

7. Support IR transmit by applications.

8. Support IR transmit without using special applications - just cat,
mkdir, shell, etc.
(Following your lead here.)

9. For flexible IR transmit hardware, the one IR transmitter should be
capable of sending codes to STBs with different protocols or keymaps
(not at the same time of course).



Regards,
Andy

