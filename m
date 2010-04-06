Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:54295 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab0DFPFn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 11:05:43 -0400
Date: Tue, 6 Apr 2010 10:05:42 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC: exposing controls in sysfs
In-Reply-To: <v2x829197381004060659u5563952et2d06f7dc876c00a8@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.1004060944060.27169@cnc.isely.net>
References: <201004052347.10845.hverkuil@xs4all.nl>  <201004060012.48261.hverkuil@xs4all.nl>  <201004060837.24770.hverkuil@xs4all.nl> <4BBB341D.2010300@redhat.com>  <59e96807eef191ed2c8913139748b655.squirrel@webmail.xs4all.nl>
 <v2x829197381004060659u5563952et2d06f7dc876c00a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 6 Apr 2010, Devin Heitmueller wrote:

   [...]

> 
> I tend to agree with Hans.  We've already got *too many* interfaces
> that do the same thing.  The testing matrix is already a nightmare -
> V4L1 versus V4L2, mmap() versus read(), legacy controls versus
> extended controls, and don't get even me started on VBI.
> 
> We should be working to make drivers and interfaces simpler, with
> *fewer* ways of doing the same thing.  The flexibility of providing
> yet another interface via sysfs compared to just calling v4l2-ctl just
> isn't worth the extra testing overhead.  We've already got too much
> stuff that needs to be fixed and not enough good developers to warrant
> making the code more complicated with little tangible benefit.

If another API (e.g. sysfs) is defined and it is specifically NOT 
permitted to be a complete set, then one can ultimately end up with 
situations where in order to effectively use a driver then multiple APIs 
*must* be used by the application.  That's even worse.

This situation already exists in the pvrusb2 driver and it's not because 
of sysfs - it's because of V4L and DVB.  When the pvrusb2 driver is used 
to handle a hybrid device (such as the HVR-1950) one has to use both the 
DVB and V4L APIs in order to effectively operate the device.  This is 
because both APIs provide something not available in the other.  And 
this really sucks if all the user wants to do is "stream mpeg, darn it! 
And I don't care if it is digital or analog".  I think that situation is 
very wrong; given that the HVR-1950 can spit out mpeg in either mode the 
user shouldn't be forced to make his application choice based on which 
mode he wants.  There's only ONE application out there that allows the 
user to operate an HVR-1950 without being forced to deal with this: 
MythTV, and that's because, well, MythTV implements both APIs: V4L and 
DVB.

I really, really dislike situations that arise where multiple APIs are 
*required* to operate a device, when really there should just be one 
API.  That said, if multiple APIs are to be exported by the driver 
interface, then such APIs really should be as complete as possible in 
order to avoid potential problems later where because of previous 
limiting choices of API design now multiple APIs become required.

I agree that testing against multiple APIs can be a pain and a drain on 
effort.  But that has not happened with the pvrusb2 driver.  It should 
be possible to implement the API in a way that minimizes further 
thrashing due to driver changes.  The pvrusb2 sysfs implementation there 
is programmatically created when the driver comes up.  The code which 
implements that interface really doesn't have any logic specific to 
particular API functions; it is just a reflection of what is internally 
in the driver.  If new "knobs" are added to the pvrusb2 driver, then the 
knob automatically appears in the sysfs interface.  If you were to go 
through the change history of the pvrusb2-sysfs.c module, all you're 
really going to find are changes caused by the sysfs class environment 
itself (i.e. when struct class was morphed into struct device), not the 
driver or its functionality.



> 
> And nobody I've talked to who writes applications that work with V4L
> has been screaming "OMG, if only V4L had a sysfs interface to manage
> controls!"

The experience I've seen with users and the pvrusb2 interface is that 
once they discover the sysfs API, the response is in fact very positive.  
Most users of the driver had no concept that such a thing was even 
possible until they were exposed to it.  Now that's not to say that we 
should all be screaming for this - but if people didn't really 
understand what was possible, then how could they ask for it?

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
