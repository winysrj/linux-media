Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:59363 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1EDLHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 07:07:10 -0400
Received: from cmsout02.mbox.net (co02-lo [127.0.0.1])
	by cmsout02.mbox.net (Postfix) with ESMTP id A8BA01340F1
	for <linux-media@vger.kernel.org>; Wed,  4 May 2011 11:07:09 +0000 (GMT)
Date: Wed, 04 May 2011 13:07:05 +0200
From: "Issa Gorissen" <flop.m@usa.net>
To: <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Ngene cam device name
Mime-Version: 1.0
Message-ID: <889PeDLgF4624S03.1304507225@web03.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andreas Oberritter <obi@linuxtv.org>
> 
> Of course I'm referring to devices connected to the same physical
> adapter. Otherwise they would all be called ca0. Device enumeration
> always starts at 0, for each adapter. What you're describing just
> doesn't make sense.


Yes indeed you're right, I answered too quickly.


> Last but not least, using a different adapter number wouldn't fit
> either, because a DVB adapter is supposed to
> - be one independent piece of hardware
> - provide at least a frontend and a demux device


How would you support device like the Hauppauge WinTV-CI ? This one comes on a
USB port and does not provide any frontend and demux device.


> 
> At least on embedded devices, it simply isn't feasible to copy a TS to
> userspace from a demux, just to copy it back to the kernel and again
> back to userspace through a caio device, when live streaming. But you
> may want to provide a way to use the caio device for
> offline-descrambling. Unless you want to force users to buy multiple
> modules and multiple subscriptions for a single receiver, which in turn
> would need multiple CI slots, you need a way to make sure caio can not
> be used during live streaming. If this dependency is between different
> adapters, then something is really, really wrong.


With the transmitted keys changed frequently (at least for viaccess), what's
the point in supporting offline descrambling when it will not work reliably
for all ?

As for descrambling multiple tv channels from different transponders with only
one cam, this is already possible. An example is what Digital Devices calls
MTD (Multi Transponder Decrypting). But this is CAM dependent, some do not
support it.

Question is, where does this belong ? kernel or userspace ?


> 
> Why don't you just create a new device, e.g. ciX, deprecate the use of
> caX for CI devices, inherit CI-related existing ioctls from the CA API,
> translate the existing read and write funtions to ioctls and then use
> read and write for TS I/O? IIRC, Ralph suggested something similar. I'm
> pretty sure this can be done without too much code and in a backwards
> compatible way.


I'm open to this idea, but is there a consensus on this big API change ?
(deprecating ca device) If yes, I will try to prepare something.

