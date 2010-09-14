Return-path: <mchehab@pedra>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:64280 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0INX5B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 19:57:01 -0400
From: rjkm <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19600.3015.410234.367070@valen.metzler>
Date: Wed, 15 Sep 2010 01:56:55 +0200
To: Johannes Stezenbach <js@linuxtv.org>
Cc: linux-media@vger.kernel.org
Subject: Re: How to handle independent CA devices
In-Reply-To: <20100914144339.GA9525@linuxtv.org>
References: <19593.22297.612764.560375@valen.metzler>
	<20100914144339.GA9525@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Johannes,


Johannes Stezenbach writes:
 > > So, I would like to hear your opinions about how to handle such CA devices 
 > > regarding device names/types, the DVB API and user libraries.
 > 
 > it looks like there isn't much interest from DVB developers
 > in that topic...  I'll try...
 > 
 > 
 > IMHO there are three sub topics:
 > 
 > 1. be compatible with existing applications
 >    (I guess this means: feed stream from frontend through CI transparently)
 > 2. create an API which would also work for CI-only
 >    devices like this Hauppauge WinTV-CI USB thingy
 > 3. how to switch between these modes?
 > 
 > This sec0 device is history (unused and deprecated for years), right?

Yes, the former DiSEqC, etc. device. I only use it because it is is
unused and I do not have to change anything in dvb-core this way.
But trivial to change it or add ci0.


 > How about the following:
 > Rename it to ci0.  When ci0 is closed the stream is routed
 > transparently from frontend through CI, if it's opened one needs to
 > read/write the stream from userspace.


You still need a mechanism to decide which tuner gets it. First one
which opens its own ca device?
Sharing the CI (multi-stream decoding) in such an automatic way 
would also be complicated.
I think I will only add such a feature if there is very high demand
and rather look into the separate API solution.


 > If you can't get responses here I guess you could talk to
 > vdr or other application developers.  After all they'll have
 > to use the API.

I am in contact with some.
Just wanted to check what people think about it on this list.

Thanks for your comments.


-Ralph
