Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:41570
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbZKZFlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 00:41:12 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1259206290.3060.50.camel@palomino.walls.org>
Date: Thu, 26 Nov 2009 00:41:13 -0500
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Content-Transfer-Encoding: 8BIT
Message-Id: <05C4F096-0EA6-448E-9C18-82868AB75F01@wilsonet.com>
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain> <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com> <1259206290.3060.50.camel@palomino.walls.org>
To: Andy Walls <awalls@radix.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 25, 2009, at 10:31 PM, Andy Walls wrote:

> On Wed, 2009-11-25 at 13:07 -0500, Jarod Wilson wrote:
>> On Nov 25, 2009, at 12:40 PM, Krzysztof Halasa wrote:
>> 
>>> lirc@bartelmus.de (Christoph Bartelmus) writes:
>>> 
>>>> I'm not sure what two ways you are talking about. With the patches posted  
>>>> by Jarod, nothing has to be changed in userspace.
>>>> Everything works, no code needs to be written and tested, everybody is  
>>>> happy.
>>> 
>>> The existing drivers use input layer. Do you want part of the tree to
>>> use existing lirc interface while the other part uses their own
>>> in-kernel (badly broken for example) code to do precisely the same
>>> thing?
>> 
>> Took me a minute to figure out exactly what you were talking about. You're referring to the current in-kernel decoding done on an ad-hoc basis for assorted remotes bundled with capture devices, correct?
>> 
>> Admittedly, unifying those and the lirc driven devices hasn't really been on my radar.
> 
> It has been on mine.  I have been somewhat against the input subsystem
> route for unification because it neglects transmitters and appears to
> trade the userspace complexity we already have (i.e. LIRC configuration)
> for another new (and hence less documented) configuration complexity for
> end users.
> 
> My strategy for unification goes something like this:
> 
> 1. Get lirc_dev and the needed supporting headers in the kernel.  I will
> concede LIRC is not perfect or beautiful, but I'll assert it is feature
> complete for all the end user use cases that matter.

So... What I'd like to propose is that I address Mauro's review comments for my v2 patchset, and resubmit a v3 patchset. If there are no show-stoppers, lets get the thing merged. If people don't want to use it, they don't have to, I won't be offended. But it seems there are quite a few people that would be incredibly happy to see this finally get in. There are definitely worse things that could be merged. :)

And from what I've been able to surmise, the input layer would need so much new functionality to handle both raw IR output and IR transmit, that we'd simply be reinventing a hefty chunk of the lirc device interface under the guise of being an input device, to be used *only* by things that can already simply use the existing feature-complete lirc device interface, which seems... wasteful.


> 2. Encapsulate all the various IR controller hardware handling in
> V4L-DVB into v4l_subdevice objects and provide a uniform interface to IR
> hardware internally via v4l2_subdev_ir_ops.  The exact nature of the IR
> hardware is then mostly abstracted away: I2C bus microcontroller,
> register block, GPIO line control of discretes devices, etc. can all be
> accessed in a somewhat unifrom manner.
> 
> 3. In conjunction with 2, common IR handling routines that exist in
> various drivers already can be broken out: RC-5 protocol handling, etc.

Once 1 happens, I'd be happy to work on adding code to currently pure lirc device drivers (like lirc_mceusb) to do in-kernel decoding for their bundled remotes. The vague plan in my head (shamelessly heisted from someone else in this thread, can't remember who atm) involves each lirc device registering two devices, one input device and one lirc device. Out of the box, without lircd, they would operate as a pure input device with their bundled remote -- out-of-the-box bliss. Once lircd opened the device's lirc device, we'd stop sending input data, and feed data out via the lirc interface.

This hybrid approach gives those who want nothing to do with lircd and the lirc device interface what they want (hell, drivers might even be buildable w/o the lirc portion even enabled), and those that want more flexibility can use either/or.


> 4. Develop an internal interface so the v4l2_subdev object instance for
> the IR hardware is exposed through a bridge driver's v4l2_device object.
> 
> 5. Develop the needed layer between lirc_dev and the v4l2_device object
> to connect things up.
> 
> 
> That unifies all the IR cats and dogs in V4L-DVB at the low levels and
> glues them in a consistent manner to something up top (i.e. lirc_dev)
> that already handles Rx, Tx, protocols, keymapping, etc.
> 
> My primary desire is to encapsulate or remove the complexity we
> currently have in kernel with all the ad-hoc IR hardware handling and
> get it unifrom and layered.  
> 
> The upper level glue to userspace doesn't have to be lirc_dev, but why
> not?  It's there and the end users are familiair with it.  I have
> set-top boxes, I need IR Tx.

Yup, me too. :)


>>> We can have a good code for both, or we can end up with "badly broken"
>>> media drivers and incompatible, suboptimal existing lirc interface
>>> (though most probably much better in terms of quality, especially after
>>> Jarod's work).
>> 
>> Well, is there any reason most of those drivers with
>> currently-in-kernel-but-badly-broken decoding can't be converted to
>> use the lirc interface if its merged into the kernel? 
> 
> I think all the V4L-DVB IR hardware can be.  I have not done sufficient
> research on the Serial, USB and other devices to say personally.

Which serial and/or usb devices other than those already supported by lirc drivers did you have in mind? Damn near all the serial and usb IR devices I know of are already supported by either another lirc kernel driver I have laying in wait, or by a userspace driver (typically interfacing w/a usb receiver using libusb).


>> And/or, everything could converge on a new in-kernel decoding infra
>> that wasn't badly broken. Sure, there may be two separate ways of
>> doing essentially the same thing for a while, but meh. The lirc way
>> works NOW for an incredibly wide variety of receivers, transmitters,
>> IR protocols, etc.
> 
> Also LIRC has had years of requirements collection and refinement of use
> cases.  Anything new implementation will likely end up converging to the
> feature set LIRC already has implemented.

Yep, I suspect as much myself. The only major feature I'm aware of that lirc hasn't already implemented is zero-config, works-out-of-the-box, really.


>> I do concur that Just Works decoding for bundled remotes w/o having to
>> configure anything would be nice, and one way to go about doing that
>> certainly is via in-kernel IR decoding. But at the same time, the
>> second you want to use something other than a bundled remote, things
>> fall down, and having to do a bunch of setkeycode ops seems less
>> optimal than simply dropping an appropriate lircd.conf in place.
> 
> 
>> From a big picture perspective I would never see the OS kenrel as a good
> place to address usability issues.  It seems more logical to fix
> usability issues with a decent GUI application and good documentation.
> (LIRC needs a configuration GUI!).

gnome-lirc-properties attempts to be that, but needs a lot more love, and isn't actually part of the lirc userspace source, its maintained by some gnome folks on freedesktop.org, iirc...


> Expecting IR usability problems to
> be eased by the kernel and command line utilties is - well -
> optimistic. 
> 
> I'll add that there are too many factors that can be permuted by the end
> user and OEM -- protocols, remote layouts, button codes, PC IR Rx/Tx
> hardware, and Set top boxes feeding PC video capture devices -- that
> generating defaults that "Just Work" is a generally unsolvable problem.

Agreed. *Especially* with IR TX in the mix, which a LOT of DVR users rely heavily upon -- we have no way of divining what the hell IR codes a random set top box needs. And the bulk of bundled remotes we can make Just Work are flimsy, crappy, cheap plastic pieces of junk. No self-respecting HTPC user actually uses any of those things. ;)

-- 
Jarod Wilson
jarod@wilsonet.com



