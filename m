Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:35659 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503AbZKZDdi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 22:33:38 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Andy Walls <awalls@radix.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com>
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain>
	 <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com>
Content-Type: text/plain
Date: Wed, 25 Nov 2009 22:31:30 -0500
Message-Id: <1259206290.3060.50.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-11-25 at 13:07 -0500, Jarod Wilson wrote:
> On Nov 25, 2009, at 12:40 PM, Krzysztof Halasa wrote:
> 
> > lirc@bartelmus.de (Christoph Bartelmus) writes:
> > 
> >> I'm not sure what two ways you are talking about. With the patches posted  
> >> by Jarod, nothing has to be changed in userspace.
> >> Everything works, no code needs to be written and tested, everybody is  
> >> happy.
> > 
> > The existing drivers use input layer. Do you want part of the tree to
> > use existing lirc interface while the other part uses their own
> > in-kernel (badly broken for example) code to do precisely the same
> > thing?
> 
> Took me a minute to figure out exactly what you were talking about. You're referring to the current in-kernel decoding done on an ad-hoc basis for assorted remotes bundled with capture devices, correct?
> 
> Admittedly, unifying those and the lirc driven devices hasn't really been on my radar.

It has been on mine.  I have been somewhat against the input subsystem
route for unification because it neglects transmitters and appears to
trade the userspace complexity we already have (i.e. LIRC configuration)
for another new (and hence less documented) configuration complexity for
end users.

My strategy for unification goes something like this:

1. Get lirc_dev and the needed supporting headers in the kernel.  I will
concede LIRC is not perfect or beautiful, but I'll assert it is feature
complete for all the end user use cases that matter.

2. Encapsulate all the various IR controller hardware handling in
V4L-DVB into v4l_subdevice objects and provide a uniform interface to IR
hardware internally via v4l2_subdev_ir_ops.  The exact nature of the IR
hardware is then mostly abstracted away: I2C bus microcontroller,
register block, GPIO line control of discretes devices, etc. can all be
accessed in a somewhat unifrom manner.

3. In conjunction with 2, common IR handling routines that exist in
various drivers already can be broken out: RC-5 protocol handling, etc.

4. Develop an internal interface so the v4l2_subdev object instance for
the IR hardware is exposed through a bridge driver's v4l2_device object.

5. Develop the needed layer between lirc_dev and the v4l2_device object
to connect things up.


That unifies all the IR cats and dogs in V4L-DVB at the low levels and
glues them in a consistent manner to something up top (i.e. lirc_dev)
that already handles Rx, Tx, protocols, keymapping, etc.

My primary desire is to encapsulate or remove the complexity we
currently have in kernel with all the ad-hoc IR hardware handling and
get it unifrom and layered.  

The upper level glue to userspace doesn't have to be lirc_dev, but why
not?  It's there and the end users are familiair with it.  I have
set-top boxes, I need IR Tx.



> > We can have a good code for both, or we can end up with "badly broken"
> > media drivers and incompatible, suboptimal existing lirc interface
> > (though most probably much better in terms of quality, especially after
> > Jarod's work).
> 
> Well, is there any reason most of those drivers with
> currently-in-kernel-but-badly-broken decoding can't be converted to
> use the lirc interface if its merged into the kernel? 

I think all the V4L-DVB IR hardware can be.  I have not done sufficient
research on the Serial, USB and other devices to say personally.


> And/or, everything could converge on a new in-kernel decoding infra
> that wasn't badly broken. Sure, there may be two separate ways of
> doing essentially the same thing for a while, but meh. The lirc way
> works NOW for an incredibly wide variety of receivers, transmitters,
> IR protocols, etc.

Also LIRC has had years of requirements collection and refinement of use
cases.  Anything new implementation will likely end up converging to the
feature set LIRC already has implemented.



> I do concur that Just Works decoding for bundled remotes w/o having to
> configure anything would be nice, and one way to go about doing that
> certainly is via in-kernel IR decoding. But at the same time, the
> second you want to use something other than a bundled remote, things
> fall down, and having to do a bunch of setkeycode ops seems less
> optimal than simply dropping an appropriate lircd.conf in place.


>From a big picture perspective I would never see the OS kenrel as a good
place to address usability issues.  It seems more logical to fix
usability issues with a decent GUI application and good documentation.
(LIRC needs a configuration GUI!).  Expecting IR usability problems to
be eased by the kernel and command line utilties is - well -
optimistic. 

I'll add that there are too many factors that can be permuted by the end
user and OEM -- protocols, remote layouts, button codes, PC IR Rx/Tx
hardware, and Set top boxes feeding PC video capture devices -- that
generating defaults that "Just Work" is a generally unsolvable problem.


Regards,
Andy

