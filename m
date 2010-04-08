Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:37142 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758205Ab0DHArg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Apr 2010 20:47:36 -0400
Date: Wed, 7 Apr 2010 19:47:35 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: hermann pitton <hermann-pitton@arcor.de>
cc: Lars Hanisch <dvb@cinnamon-sage.de>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: RFC: exposing controls in sysfs
In-Reply-To: <1270678528.6429.35.camel@pc07.localdom.local>
Message-ID: <alpine.DEB.1.10.1004071939510.5518@ivanova.isely.net>
References: <201004052347.10845.hverkuil@xs4all.nl>  <alpine.DEB.1.10.1004060848540.27169@cnc.isely.net>  <4BBCD3F9.1070207@cinnamon-sage.de> <1270678528.6429.35.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 8 Apr 2010, hermann pitton wrote:

> Hi,
> 
> Am Mittwoch, den 07.04.2010, 20:50 +0200 schrieb Lars Hanisch:
> > Am 06.04.2010 16:33, schrieb Mike Isely:
> [snip]
> > >>
> > >> Mike, do you know of anyone actively using that additional information?
> > >
> > > Yes.
> > >
> > > The VDR project at one time implemented a plugin to directly interface
> > > to the pvrusb2 driver in this manner.  I do not know if it is still
> > > being used since I don't maintain that plugin.
> > 
> >   Just FYI:
> >   The PVR USB2 device is now handled by the pvrinput-plugin, which uses only ioctls. The "old" pvrusb2-plugin is obsolete.
> > 
> >   http://projects.vdr-developer.org/projects/show/plg-pvrinput

Lars:

Thanks for letting me know about that - until this message I had no idea 
if VDR was still using that interface.


> > 
> > Regards,
> > Lars.
> 
> [snip]
> 
> thanks Lars.
> 
> Mike is really caring and went out for even any most obscure tuner bit
> to help to improve such stuff in the past, when we have been without any
> data sheets.

Hermann:

You might have me confused with Mike Krufky there - he's the one who did 
so much of the tuner driver overhauling in v4l-dvb in the past.


> 
> To open second, maybe third and even forth ways for apps to use a
> device, likely going out of sync soon, does only load maintenance work
> without real gain.

Well it was an experiment at the time to see how well such a concept 
would work.  I had done it in a way to minimize maintenance load going 
forward.  On both counts I feel the interface actually has done very 
well, nonstandard though it may be.

I still get the general impression that the user community really has 
liked the sysfs interface, but the developers never really got very fond 
of it :-(


> 
> We should stay sharp to discover something others don't want to let us
> know about. All other ideas about markets are illusions. Or?
> 
> So, debugfs sounds much better than sysfs for my taste.
> 
> Any app and any driver, going out of sync on the latter, will remind us
> that backward compat _must always be guaranteed_  ...
> 
> Or did change anything on that and is sysfs excluded from that rule?

Backwards compatibility is very important and thus any kind of new 
interface deserves a lot of forethought to ensure that choices are made 
in the present that people will regret in the future.  Making an 
interface self-describing is one way that helps with compatibility: if 
the app can discover on its own how to use the interface then it can 
adapt to interface changes in the future.  I think a lot of people get 
their brains so wrapped around the "ioctl-way" of doing things and then 
they try to map that concept into a sysfs-like (or debugfs-like) 
abstraction that they don't see how to naturally take advantage of what 
is possible there.

  -Mike

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
