Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:37730 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab0DXVEu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Apr 2010 17:04:50 -0400
Date: Sat, 24 Apr 2010 16:04:49 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Sven Barth <pascaldragon@googlemail.com>
cc: linux-media@vger.kernel.org
Subject: Re: Problem with cx25840 and Terratec Grabster AV400
In-Reply-To: <4BD35AA3.7070003@googlemail.com>
Message-ID: <alpine.DEB.1.10.1004241555420.5135@ivanova.isely.net>
References: <4BD2EACA.5040005@googlemail.com> <alpine.DEB.1.10.1004241212100.5135@ivanova.isely.net> <4BD34E5A.40507@googlemail.com> <alpine.DEB.1.10.1004241517320.5135@ivanova.isely.net> <4BD35AA3.7070003@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 24 Apr 2010, Sven Barth wrote:

> Hi!
> 
> On 24.04.2010 22:24, Mike Isely wrote:
> > On Sat, 24 Apr 2010, Sven Barth wrote:
> > > 
> > > Hi!
> > > 
> > > Although you never really completed that support for the AV400 it runs
> > > pretty
> > > well once you've touched the cx25840 source. I'm using it for months now
> > > and
> > > it runs better than it did with Windows (I sometimes had troubles with
> > > audio
> > > there which led to an "out of sync" audio track).
> > 
> > Unfortunately I can't really "say" it is supported in the pvrusb2 driver
> > until it actually works well enough that a user doesn't have to hack
> > driver source (pvrusb2 or otherwise).  Otherwise I'm just going to get
> > inundated with help requests for this.  Not having a sample of the
> > device here I'm handicapped from debugging such issues.
> > 
> 
> I don't want to have this hacking as much as you do. But currently it's the
> only way that works for me (I'm really glad that it has come that far ^^)...
> I'll try to help here as good as I can (and time permits) to solve this issue.

I understand.


> 
> > I've just made a change to the pvrusb2 driver to allow for the ability
> > to mark a piece of hardware (such as this device) as "experimental".
> > Such devices will generate a warning in the kernel log upon
> > initialization.  The experimental marker doesn't impact the ability to
> > use the device; it just triggers the warning message.  Once we know the
> > device is working acceptably well enough, the marker can be turned off.
> > This should help avoid misleading others about whether or not the
> > pvrusb2 driver fully supports a particular piece of hardware.
> > 
> 
> No offense intended, but do you really think that people will read that?
> Normal users (using Ubuntu, etc) don't really care whether their device is
> marked as experimental or not... they just want it to work and thus can go to
> great lengths to "disturb" the developers working on their driver...

No offense taken.  Not a problem.  But I felt it was at least important 
enough for the driver to document this fact.  For those who use the 
device who are capable of attempting some hacking - those people WILL 
see the message and hopefully that will encourage such folks to contact 
the author (me) for assistance in further stabilizing the device.

The intent wasn't for the flag to be any excuse not to work on it - I 
just want to leave a marker indicating that the driver is not expected 
to be fully working (or "supported") at this time.


> 
> > > PS: Did you read my mail from last December?
> > > http://www.isely.net/pipermail/pvrusb2/2009-December/002716.html
> > 
> > Yeah, I saw it back then, and then I probably got distracted away :-(
> 
> I know that problem pretty well. ^^ I was only curious.

Spending a lot of time today catching up on stuff like this.  Just 
smoked out two kernel oopses in the driver today as well.


> 
> > 
> > The key issue is that your hardware doesn't seem to work until you make
> > those two changes to the v4l-dvb cx25840 driver.  Obviously one can't
> > just make those changes without understanding the implications for other
> > users of the driver.  I (or someone expert at the cx25840 module) needs
> > to study that patch and understand what is best to do for the driver.
> > 
> >    -Mike
> > 
> > 
> 

> It would be interesting to know why the v4l devs disabled the audio routing
> for cx2583x chips and whether it was intended that a cx25837 chip gets the
> same treatment as a e.g. cx25836.

I wish I could provide specific information about that :-(


> And those "implications" you're talking about is the reason why I wrote here:
> I want to check whether there is a better or more correct way than to disable
> those checks (it works here, because I have only that one device that contains
> a cx2583x chip...).

> Just a thought: can it be that my chip's audio routing isn't set to the
> correct value after initialization and thus it needs to be set at least once,
> while all other chips default to a working routing after initialization? Could
> be a design mistake done by Terratec...

There is no one "correct" audio routing.  And by "audio routing" I mean 
the wiring between the chip and the various audio inputs that feed it.  
The choice for how to route all this is up to the vendor of the device.  
In many cases there is a common reference design that the vendor starts 
from, in which case such routing will be more common across devices.  
But that's just luck really.  The cx25840 driver provides an API to 
things like the pvrusb2 driver to select the proper routing based on 
that bridge driver's knowledge of the surrounding hardware.  This is one 
of the areas that have to be worked on when porting to a new device.  
The PVR2_ROUTING_SCHEME_xxxx enumeration in the pvrusb2 driver is part 
of this.

With that all said I haven't looked closely enough at your patch to the 
cx25840 module so I'm only assuming that we're talking about the same 
thing here.  I have a funny feeling that you're hitting on something 
else however.  I need to look at this more closely.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
