Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:52091 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab1EDOFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 10:05:07 -0400
Date: Wed, 04 May 2011 16:05:02 +0200
From: "Issa Gorissen" <flop.m@usa.net>
To: Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH] Ngene cam device name
CC: <linux-media@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <208PeDoec2016S01.1304517902@web01.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andreas Oberritter <obi@linuxtv.org>
> >> Last but not least, using a different adapter number wouldn't fit
> >> either, because a DVB adapter is supposed to
> >> - be one independent piece of hardware
> >> - provide at least a frontend and a demux device
> > 
> > 
> > How would you support device like the Hauppauge WinTV-CI ? This one comes
on a
> > USB port and does not provide any frontend and demux device.
> 
> Yes, as an exception, this device indeed wouldn't have a frontend,
> because it doesn't exist physycally.
> 
> It wouldn't have multiple adapters numbers either.


What do you mean by they shouldn't have mulitple adapters numbers ? Multiple
WinTV-CI devices should have distinct node parents, ie
/dev/dvb/adapter[01]/<node>



> > With the transmitted keys changed frequently (at least for viaccess),
what's
> > the point in supporting offline descrambling when it will not work
reliably
> > for all ?
> 
> The reliability of offline descrambling depends on the network operators
> policy. So while it won't be useful for everybody in the world, it might
> well be useful to all customers of certain operators.
> 
> > As for descrambling multiple tv channels from different transponders with
only
> > one cam, this is already possible. An example is what Digital Devices
calls
> > MTD (Multi Transponder Decrypting). But this is CAM dependent, some do
not
> > support it.
> 
> What's the point if it doesn't work reliably for everybody? ;-)


Well, isn't it easier to change a CAM than an operator ? For many of us in
France/Belgium, you might even have no choice at all for the operator.


> >> Why don't you just create a new device, e.g. ciX, deprecate the use of
> >> caX for CI devices, inherit CI-related existing ioctls from the CA API,
> >> translate the existing read and write funtions to ioctls and then use
> >> read and write for TS I/O? IIRC, Ralph suggested something similar. I'm
> >> pretty sure this can be done without too much code and in a backwards
> >> compatible way.
> > 
> > 
> > I'm open to this idea, but is there a consensus on this big API change ?
> > (deprecating ca device) If yes, I will try to prepare something.
> 
> The existing API could be copied to linux/dvb/ci.h and then simplified
> and reviewed.
> 

As I said, if you can create a consensus behind your idea, then I will try to
prepare something.

