Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:45873 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab0DXUYJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Apr 2010 16:24:09 -0400
Date: Sat, 24 Apr 2010 15:24:08 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Sven Barth <pascaldragon@googlemail.com>
cc: linux-media@vger.kernel.org
Subject: Re: Problem with cx25840 and Terratec Grabster AV400
In-Reply-To: <4BD34E5A.40507@googlemail.com>
Message-ID: <alpine.DEB.1.10.1004241517320.5135@ivanova.isely.net>
References: <4BD2EACA.5040005@googlemail.com> <alpine.DEB.1.10.1004241212100.5135@ivanova.isely.net> <4BD34E5A.40507@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 24 Apr 2010, Sven Barth wrote:

> On 24.04.2010 19:13, Mike Isely wrote:
> > 
> > Actually the support in the pvrusb2 driver was never really completed.
> > But since I don't have a sample of the hardware here I went on ahead and
> > merged what was there so that it could get exposure and the remaining
> > problems sorted out.
> > 
> >    -Mike
> > 
> 
> Hi!
> 
> Although you never really completed that support for the AV400 it runs pretty
> well once you've touched the cx25840 source. I'm using it for months now and
> it runs better than it did with Windows (I sometimes had troubles with audio
> there which led to an "out of sync" audio track).

Unfortunately I can't really "say" it is supported in the pvrusb2 driver 
until it actually works well enough that a user doesn't have to hack 
driver source (pvrusb2 or otherwise).  Otherwise I'm just going to get 
inundated with help requests for this.  Not having a sample of the 
device here I'm handicapped from debugging such issues.

I've just made a change to the pvrusb2 driver to allow for the ability 
to mark a piece of hardware (such as this device) as "experimental".  
Such devices will generate a warning in the kernel log upon 
initialization.  The experimental marker doesn't impact the ability to 
use the device; it just triggers the warning message.  Once we know the 
device is working acceptably well enough, the marker can be turned off.  
This should help avoid misleading others about whether or not the 
pvrusb2 driver fully supports a particular piece of hardware.


> 
> I wrote the last mail, because I want to sort out why the cx25837 chip in my
> device is behaving differently than expected by the corresponding driver and
> to remove the need to patch the v4l sources manually.
> Once I don't need to fear that the next system update breaks the device again
> (because cx25840.ko is overwritten), I'm more then willed to help you to
> complete the support for my device in your driver (feature testing, etc).

We definitely need to do this.


> 
> Regards,
> Sven
> 
> PS: Did you read my mail from last December?
> http://www.isely.net/pipermail/pvrusb2/2009-December/002716.html

Yeah, I saw it back then, and then I probably got distracted away :-(

The key issue is that your hardware doesn't seem to work until you make 
those two changes to the v4l-dvb cx25840 driver.  Obviously one can't 
just make those changes without understanding the implications for other 
users of the driver.  I (or someone expert at the cx25840 module) needs 
to study that patch and understand what is best to do for the driver.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
